Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDD449479E
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 07:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358774AbiATGv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 01:51:58 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:51501 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237909AbiATGv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 01:51:56 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=guangguan.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V2L1mkI_1642661507;
Received: from localhost.localdomain(mailfrom:guangguan.wang@linux.alibaba.com fp:SMTPD_---0V2L1mkI_1642661507)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 20 Jan 2022 14:51:53 +0800
From:   Guangguan Wang <guangguan.wang@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>
Subject: [RFC PATCH net-next] net/smc: Introduce receive queue flow control support
Date:   Thu, 20 Jan 2022 14:51:40 +0800
Message-Id: <20220120065140.5385-1-guangguan.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implement rq flow control in smc-r link layer. QPs
communicating without rq flow control, in the previous
version, may result in RNR (reveive not ready) error, which
means when sq sends a message to the remote qp, but the
remote qp's rq has no valid rq entities to receive the message.
In RNR condition, the rdma transport layer may retransmit
the messages again and again until the rq has any entities,
which may lower the performance, especially in heavy traffic.
Using credits to do rq flow control can avoid the occurrence
of RNR.

Test environment:
- CPU Intel Xeon Platinum 8 core, mem 32 GiB, nic Mellanox CX4.
- redis benchmark 6.2.3 and redis server 6.2.3.
- redis server: redis-server --save "" --appendonly no
  --protected-mode no --io-threads 7 --io-threads-do-reads yes
- redis client: redis-benchmark -h 192.168.26.36 -q -t set,get
  -P 1 --threads 7 -n 2000000 -c 200 -d 10

 Before:
 SET: 205229.23 requests per second, p50=0.799 msec
 GET: 212278.16 requests per second, p50=0.751 msec

 After:
 SET: 623674.69 requests per second, p50=0.303 msec
 GET: 688326.00 requests per second, p50=0.271 msec

The test of redis-benchmark shows that more than 3X rps
improvement after the implementation of rq flow control.

Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
---
 net/smc/af_smc.c   | 12 ++++++
 net/smc/smc_cdc.c  | 10 ++++-
 net/smc/smc_cdc.h  |  3 +-
 net/smc/smc_clc.c  |  3 ++
 net/smc/smc_clc.h  |  3 +-
 net/smc/smc_core.h | 17 ++++++++-
 net/smc/smc_ib.c   |  6 ++-
 net/smc/smc_llc.c  | 92 +++++++++++++++++++++++++++++++++++++++++++++-
 net/smc/smc_llc.h  |  5 +++
 net/smc/smc_wr.c   | 30 ++++++++++++---
 net/smc/smc_wr.h   | 54 ++++++++++++++++++++++++++-
 11 files changed, 222 insertions(+), 13 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index aa3bcaaeabf7..108ac85bd794 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -531,6 +531,13 @@ static void smc_link_save_peer_info(struct smc_link *link,
 	memcpy(link->peer_mac, ini->peer_mac, sizeof(link->peer_mac));
 	link->peer_psn = ntoh24(clc->r0.psn);
 	link->peer_mtu = clc->r0.qp_mtu;
+	link->credits_enable = clc->r0.init_credits ? 1 : 0;
+	if (link->credits_enable) {
+		atomic_set(&link->peer_rq_credits, clc->r0.init_credits);
+		// set peer rq credits watermark, if less than init_credits * 2/3,
+		// then credit announcement is needed.
+		link->peer_cr_watermark_low = max(clc->r0.init_credits * 2 / 3, 1);
+	}
 }
 
 static void smc_stat_inc_fback_rsn_cnt(struct smc_sock *smc,
@@ -945,6 +952,11 @@ static int smc_connect_rdma(struct smc_sock *smc,
 			goto connect_abort;
 		}
 	} else {
+		if (smc_llc_announce_credits(link, SMC_LLC_RESP, true)) {
+			reason_code = SMC_CLC_DECL_CREDITSERR;
+			goto connect_abort;
+		}
+
 		if (smcr_lgr_reg_rmbs(link, smc->conn.rmb_desc)) {
 			reason_code = SMC_CLC_DECL_ERR_REGRMB;
 			goto connect_abort;
diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 84c8a4374fdd..6c0f71d6dc23 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -101,14 +101,18 @@ int smc_cdc_msg_send(struct smc_connection *conn,
 		     struct smc_cdc_tx_pend *pend)
 {
 	struct smc_link *link = conn->lnk;
+	struct smc_cdc_msg *cdc_msg = (struct smc_cdc_msg *)wr_buf;
 	union smc_host_cursor cfed;
+	u8 saved_credits = 0;
 	int rc;
 
 	smc_cdc_add_pending_send(conn, pend);
 
 	conn->tx_cdc_seq++;
 	conn->local_tx_ctrl.seqno = conn->tx_cdc_seq;
-	smc_host_msg_to_cdc((struct smc_cdc_msg *)wr_buf, conn, &cfed);
+	smc_host_msg_to_cdc(cdc_msg, conn, &cfed);
+	saved_credits = (u8)smc_wr_rx_get_credits(link);
+	cdc_msg->credits = saved_credits;
 
 	atomic_inc(&conn->cdc_pend_tx_wr);
 	smp_mb__after_atomic(); /* Make sure cdc_pend_tx_wr added before post */
@@ -120,6 +124,7 @@ int smc_cdc_msg_send(struct smc_connection *conn,
 	} else {
 		conn->tx_cdc_seq--;
 		conn->local_tx_ctrl.seqno = conn->tx_cdc_seq;
+		smc_wr_rx_put_credits(link, saved_credits);
 		atomic_dec(&conn->cdc_pend_tx_wr);
 	}
 
@@ -430,6 +435,9 @@ static void smc_cdc_rx_handler(struct ib_wc *wc, void *buf)
 	if (cdc->len != SMC_WR_TX_SIZE)
 		return; /* invalid message */
 
+	if (cdc->credits)
+		smc_wr_tx_put_credits(link, cdc->credits, true);
+
 	/* lookup connection */
 	lgr = smc_get_lgr(link);
 	read_lock_bh(&lgr->conns_lock);
diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
index 696cc11f2303..145ce7997e64 100644
--- a/net/smc/smc_cdc.h
+++ b/net/smc/smc_cdc.h
@@ -47,7 +47,8 @@ struct smc_cdc_msg {
 	union smc_cdc_cursor		cons;	/* piggy backed "ack" */
 	struct smc_cdc_producer_flags	prod_flags;
 	struct smc_cdc_conn_state_flags	conn_state_flags;
-	u8				reserved[18];
+	u8				credits;	/* credits synced by every cdc msg */
+	u8				reserved[17];
 };
 
 /* SMC-D cursor format */
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 6be95a2a7b25..f477ac24c427 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -1038,9 +1038,12 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 		switch (clc->hdr.type) {
 		case SMC_CLC_ACCEPT:
 			clc->r0.qp_mtu = link->path_mtu;
+			clc->r0.init_credits = (u8)link->wr_rx_cnt;
 			break;
 		case SMC_CLC_CONFIRM:
 			clc->r0.qp_mtu = min(link->path_mtu, link->peer_mtu);
+			clc->r0.init_credits =
+				link->credits_enable ? (u8)link->wr_rx_cnt : 0;
 			break;
 		}
 		clc->r0.rmbe_size = conn->rmbe_size_short;
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 83f02f131fc0..eb4bba54d6df 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -63,6 +63,7 @@
 #define SMC_CLC_DECL_ERR_RTOK	0x09990001  /*	 rtoken handling failed       */
 #define SMC_CLC_DECL_ERR_RDYLNK	0x09990002  /*	 ib ready link failed	      */
 #define SMC_CLC_DECL_ERR_REGRMB	0x09990003  /*	 reg rmb failed		      */
+#define SMC_CLC_DECL_CREDITSERR	0x09990004  /*	 announce credits failed	  */
 
 #define SMC_FIRST_CONTACT_MASK	0b10	/* first contact bit within typev2 */
 
@@ -190,7 +191,7 @@ struct smcr_clc_msg_accept_confirm {	/* SMCR accept/confirm */
 	u8 qp_mtu   : 4,
 	   rmbe_size : 4;
 #endif
-	u8 reserved;
+	u8 init_credits;		/* QP rq init credits for rq flowctrl */
 	__be64 rmb_dma_addr;	/* RMB virtual address */
 	u8 reserved2;
 	u8 psn[3];		/* packet sequence number */
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 521c64a3d8d3..ce859dfdbe6c 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -21,7 +21,12 @@
 #include "smc.h"
 #include "smc_ib.h"
 
-#define SMC_RMBS_PER_LGR_MAX	255	/* max. # of RMBs per link group */
+#define SMC_RMBS_PER_LGR_MAX	32	/* max. # of RMBs per link group. Correspondingly,
+					 * SMC_WR_BUF_CNT should not be less than 2 *
+					 * SMC_RMBS_PER_LGR_MAX, since every connection at
+					 * least has two rq/sq credits in average, otherwise
+					 * may result in waiting for credits in sending process.
+					 */
 
 struct smc_lgr_list {			/* list of link group definition */
 	struct list_head	list;
@@ -80,6 +85,8 @@ struct smc_rdma_wr {				/* work requests per message
 
 #define SMC_LGR_ID_SIZE		4
 
+#define SMC_LINKFLAG_ANNOUNCE_PENDING	0
+
 struct smc_link {
 	struct smc_ib_device	*smcibdev;	/* ib-device */
 	u8			ibport;		/* port - values 1 | 2 */
@@ -123,6 +130,14 @@ struct smc_link {
 	atomic_t		wr_reg_refcnt;	/* reg refs to link */
 	enum smc_wr_reg_state	wr_reg_state;	/* state of wr_reg request */
 
+	atomic_t	peer_rq_credits;	/* credits for peer rq flowctrl */
+	atomic_t	local_rq_credits;	/* credits for local rq flowctrl */
+	u8		credits_enable;		/* credits enable flag, set when negotiation */
+	u8		local_cr_watermark_high;	/* local rq credits watermark */
+	u8		peer_cr_watermark_low;	/* peer rq credits watermark */
+	struct work_struct	credits_announce_work;	/* work for credits announcement */
+	unsigned long	flags;	/* link flags, SMC_LINKFLAG_ANNOUNCE_PENDING .etc */
+
 	u8			gid[SMC_GID_SIZE];/* gid matching used vlan id*/
 	u8			sgid_index;	/* gid index for vlan id      */
 	u32			peer_qpn;	/* QP number of peer */
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index a3e2d3b89568..9c8206da0d2b 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -665,10 +665,12 @@ int smc_ib_create_queue_pair(struct smc_link *lnk)
 		.srq = NULL,
 		.cap = {
 				/* include unsolicited rdma_writes as well,
-				 * there are max. 2 RDMA_WRITE per 1 WR_SEND
+				 * there are max. 2 RDMA_WRITE per 1 WR_SEND.
+				 * RDMA_WRITE consumes send queue entities,
+				 * without recv queue entities.
 				 */
 			.max_send_wr = SMC_WR_BUF_CNT * 3,
-			.max_recv_wr = SMC_WR_BUF_CNT * 3,
+			.max_recv_wr = SMC_WR_BUF_CNT,
 			.max_send_sge = SMC_IB_MAX_SEND_SGE,
 			.max_recv_sge = sges_per_buf,
 		},
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index c4d057b2941d..10653b4e3d3f 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -75,7 +75,8 @@ struct smc_llc_msg_add_link {		/* type 0x02 */
 	   reserved3 : 4;
 #endif
 	u8 initial_psn[3];
-	u8 reserved[8];
+	u8 init_credits;	/* QP rq init credits for rq flowctrl */
+	u8 reserved[7];
 };
 
 struct smc_llc_msg_add_link_cont_rt {
@@ -170,6 +171,12 @@ struct smc_llc_msg_delete_rkey {	/* type 0x09 */
 	u8 reserved2[4];
 };
 
+struct smc_llc_msg_announce_credits {	/* type 0x0A */
+	struct smc_llc_hdr hd;
+	u8 credits;
+	u8 reserved[39];
+};
+
 struct smc_llc_msg_delete_rkey_v2 {	/* type 0x29 */
 	struct smc_llc_hdr hd;
 	u8 num_rkeys;
@@ -189,6 +196,7 @@ union smc_llc_msg {
 	struct smc_llc_msg_delete_rkey delete_rkey;
 
 	struct smc_llc_msg_test_link test_link;
+	struct smc_llc_msg_announce_credits announce_credits;
 	struct {
 		struct smc_llc_hdr hdr;
 		u8 data[SMC_LLC_DATA_LEN];
@@ -750,6 +758,46 @@ static int smc_llc_send_test_link(struct smc_link *link, u8 user_data[16])
 	return rc;
 }
 
+/* send credits announce request or response  */
+int smc_llc_announce_credits(struct smc_link *link,
+			     enum smc_llc_reqresp reqresp, bool force)
+{
+	struct smc_llc_msg_announce_credits *announce_credits;
+	struct smc_wr_tx_pend_priv *pend;
+	struct smc_wr_buf *wr_buf;
+	int rc;
+	u8 saved_credits = 0;
+
+	if (!link->credits_enable ||
+	    (!force && !smc_wr_rx_credits_need_announce(link)))
+		return 0;
+
+	saved_credits = (u8)smc_wr_rx_get_credits(link);
+	if (!saved_credits)
+		/* maybe synced by cdc msg */
+		return 0;
+
+	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
+	if (rc) {
+		smc_wr_rx_put_credits(link, saved_credits);
+		return rc;
+	}
+
+	announce_credits = (struct smc_llc_msg_announce_credits *)wr_buf;
+	memset(announce_credits, 0, sizeof(*announce_credits));
+	announce_credits->hd.common.type = SMC_LLC_ANNOUNCE_CREDITS;
+	announce_credits->hd.length = sizeof(struct smc_llc_msg_announce_credits);
+	if (reqresp == SMC_LLC_RESP)
+		announce_credits->hd.flags |= SMC_LLC_FLAG_RESP;
+	announce_credits->credits = saved_credits;
+	/* send llc message */
+	rc = smc_wr_tx_send(link, pend);
+	if (rc)
+		smc_wr_rx_put_credits(link, saved_credits);
+
+	return rc;
+}
+
 /* schedule an llc send on link, may wait for buffers */
 static int smc_llc_send_message(struct smc_link *link, void *llcbuf)
 {
@@ -1012,6 +1060,13 @@ static void smc_llc_save_add_link_info(struct smc_link *link,
 	memcpy(link->peer_mac, add_llc->sender_mac, ETH_ALEN);
 	link->peer_psn = ntoh24(add_llc->initial_psn);
 	link->peer_mtu = add_llc->qp_mtu;
+	link->credits_enable = add_llc->init_credits ? 1 : 0;
+	if (link->credits_enable) {
+		atomic_set(&link->peer_rq_credits, add_llc->init_credits);
+		// set peer rq credits watermark, if less than init_credits * 2/3,
+		// then credit announcement is needed.
+		link->peer_cr_watermark_low = max(add_llc->init_credits * 2 / 3, 1);
+	}
 }
 
 /* as an SMC client, process an add link request */
@@ -1931,6 +1986,10 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 			smc_llc_flow_stop(lgr, &lgr->llc_flow_rmt);
 		}
 		return;
+	case SMC_LLC_ANNOUNCE_CREDITS:
+		if (smc_link_active(link))
+			smc_wr_tx_put_credits(link, llc->announce_credits.credits, true);
+		break;
 	case SMC_LLC_REQ_ADD_LINK:
 		/* handle response here, smc_llc_flow_stop() cannot be called
 		 * in tasklet context
@@ -2016,6 +2075,10 @@ static void smc_llc_rx_response(struct smc_link *link,
 	case SMC_LLC_CONFIRM_RKEY_CONT:
 		/* not used because max links is 3 */
 		break;
+	case SMC_LLC_ANNOUNCE_CREDITS:
+		if (smc_link_active(link))
+			smc_wr_tx_put_credits(link, qentry->msg.announce_credits.credits, true);
+		break;
 	default:
 		smc_llc_protocol_violation(link->lgr,
 					   qentry->msg.raw.hdr.common.type);
@@ -2109,6 +2172,27 @@ static void smc_llc_testlink_work(struct work_struct *work)
 	schedule_delayed_work(&link->llc_testlink_wrk, next_interval);
 }
 
+static void smc_llc_announce_credits_work(struct work_struct *work)
+{
+	struct smc_link *link = container_of(work,
+					     struct smc_link, credits_announce_work);
+	int rc, retry = 0, agains = 0;
+
+again:
+	do {
+		rc = smc_llc_announce_credits(link, SMC_LLC_RESP, false);
+	} while ((rc == -EBUSY) && smc_link_sendable(link) &&
+			(retry++ < SMC_LLC_ANNOUNCE_CR_MAX_RETRY));
+
+	if (smc_wr_rx_credits_need_announce(link) &&
+	    smc_link_sendable(link) && agains <= 5 && !rc) {
+		agains++;
+		goto again;
+	}
+
+	clear_bit(SMC_LINKFLAG_ANNOUNCE_PENDING, &link->flags);
+}
+
 void smc_llc_lgr_init(struct smc_link_group *lgr, struct smc_sock *smc)
 {
 	struct net *net = sock_net(smc->clcsock->sk);
@@ -2144,6 +2228,7 @@ int smc_llc_link_init(struct smc_link *link)
 {
 	init_completion(&link->llc_testlink_resp);
 	INIT_DELAYED_WORK(&link->llc_testlink_wrk, smc_llc_testlink_work);
+	INIT_WORK(&link->credits_announce_work, smc_llc_announce_credits_work);
 	return 0;
 }
 
@@ -2177,6 +2262,7 @@ void smc_llc_link_clear(struct smc_link *link, bool log)
 				    link->smcibdev->ibdev->name, link->ibport);
 	complete(&link->llc_testlink_resp);
 	cancel_delayed_work_sync(&link->llc_testlink_wrk);
+	cancel_work_sync(&link->credits_announce_work);
 }
 
 /* register a new rtoken at the remote peer (for all links) */
@@ -2291,6 +2377,10 @@ static struct smc_wr_rx_handler smc_llc_rx_handlers[] = {
 		.handler	= smc_llc_rx_handler,
 		.type		= SMC_LLC_DELETE_RKEY
 	},
+	{
+		.handler    = smc_llc_rx_handler,
+		.type       = SMC_LLC_ANNOUNCE_CREDITS
+	},
 	/* V2 types */
 	{
 		.handler	= smc_llc_rx_handler,
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index 4404e52b3346..f8a14643faf4 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -20,6 +20,8 @@
 #define SMC_LLC_WAIT_FIRST_TIME		(5 * HZ)
 #define SMC_LLC_WAIT_TIME		(2 * HZ)
 
+#define SMC_LLC_ANNOUNCE_CR_MAX_RETRY	(1)
+
 enum smc_llc_reqresp {
 	SMC_LLC_REQ,
 	SMC_LLC_RESP
@@ -35,6 +37,7 @@ enum smc_llc_msg_type {
 	SMC_LLC_TEST_LINK		= 0x07,
 	SMC_LLC_CONFIRM_RKEY_CONT	= 0x08,
 	SMC_LLC_DELETE_RKEY		= 0x09,
+	SMC_LLC_ANNOUNCE_CREDITS	= 0X0A,
 	/* V2 types */
 	SMC_LLC_CONFIRM_LINK_V2		= 0x21,
 	SMC_LLC_ADD_LINK_V2		= 0x22,
@@ -86,6 +89,8 @@ int smc_llc_send_add_link(struct smc_link *link, u8 mac[], u8 gid[],
 int smc_llc_send_delete_link(struct smc_link *link, u8 link_del_id,
 			     enum smc_llc_reqresp reqresp, bool orderly,
 			     u32 reason);
+int smc_llc_announce_credits(struct smc_link *link,
+			     enum smc_llc_reqresp reqresp, bool force);
 void smc_llc_srv_delete_link_local(struct smc_link *link, u8 del_link_id);
 void smc_llc_lgr_init(struct smc_link_group *lgr, struct smc_sock *smc);
 void smc_llc_lgr_clear(struct smc_link_group *lgr);
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 24be1d03fef9..7a0136e1f78a 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -173,11 +173,16 @@ static inline int smc_wr_tx_get_free_slot_index(struct smc_link *link, u32 *idx)
 	*idx = link->wr_tx_cnt;
 	if (!smc_link_sendable(link))
 		return -ENOLINK;
+
+	if (!smc_wr_tx_get_credit(link))
+		return -EBUSY;
+
 	for_each_clear_bit(*idx, link->wr_tx_mask, link->wr_tx_cnt) {
 		if (!test_and_set_bit(*idx, link->wr_tx_mask))
 			return 0;
 	}
 	*idx = link->wr_tx_cnt;
+	smc_wr_tx_put_credits(link, 1, false);
 	return -EBUSY;
 }
 
@@ -283,7 +288,7 @@ int smc_wr_tx_put_slot(struct smc_link *link,
 		memset(&link->wr_tx_bufs[idx], 0,
 		       sizeof(link->wr_tx_bufs[idx]));
 		test_and_clear_bit(idx, link->wr_tx_mask);
-		wake_up(&link->wr_tx_wait);
+		smc_wr_tx_put_credits(link, 1, true);
 		return 1;
 	} else if (link->lgr->smc_version == SMC_V2 &&
 		   pend->idx == link->wr_tx_cnt) {
@@ -471,6 +476,12 @@ static inline void smc_wr_rx_process_cqes(struct ib_wc wc[], int num)
 				break;
 			}
 		}
+
+		if (smc_wr_rx_credits_need_announce(link) &&
+		    !test_bit(SMC_LINKFLAG_ANNOUNCE_PENDING, &link->flags)) {
+			set_bit(SMC_LINKFLAG_ANNOUNCE_PENDING, &link->flags);
+			schedule_work(&link->credits_announce_work);
+		}
 	}
 }
 
@@ -513,6 +524,8 @@ int smc_wr_rx_post_init(struct smc_link *link)
 
 	for (i = 0; i < link->wr_rx_cnt; i++)
 		rc = smc_wr_rx_post(link);
+	// credits have already been announced to peer
+	atomic_set(&link->local_rq_credits, 0);
 	return rc;
 }
 
@@ -547,7 +560,7 @@ void smc_wr_remember_qp_attr(struct smc_link *lnk)
 
 	lnk->wr_tx_cnt = min_t(size_t, SMC_WR_BUF_CNT,
 			       lnk->qp_attr.cap.max_send_wr);
-	lnk->wr_rx_cnt = min_t(size_t, SMC_WR_BUF_CNT * 3,
+	lnk->wr_rx_cnt = min_t(size_t, SMC_WR_BUF_CNT,
 			       lnk->qp_attr.cap.max_recv_wr);
 }
 
@@ -736,7 +749,7 @@ int smc_wr_alloc_link_mem(struct smc_link *link)
 	link->wr_tx_bufs = kcalloc(SMC_WR_BUF_CNT, SMC_WR_BUF_SIZE, GFP_KERNEL);
 	if (!link->wr_tx_bufs)
 		goto no_mem;
-	link->wr_rx_bufs = kcalloc(SMC_WR_BUF_CNT * 3, SMC_WR_BUF_SIZE,
+	link->wr_rx_bufs = kcalloc(SMC_WR_BUF_CNT, SMC_WR_BUF_SIZE,
 				   GFP_KERNEL);
 	if (!link->wr_rx_bufs)
 		goto no_mem_wr_tx_bufs;
@@ -744,7 +757,7 @@ int smc_wr_alloc_link_mem(struct smc_link *link)
 				  GFP_KERNEL);
 	if (!link->wr_tx_ibs)
 		goto no_mem_wr_rx_bufs;
-	link->wr_rx_ibs = kcalloc(SMC_WR_BUF_CNT * 3,
+	link->wr_rx_ibs = kcalloc(SMC_WR_BUF_CNT,
 				  sizeof(link->wr_rx_ibs[0]),
 				  GFP_KERNEL);
 	if (!link->wr_rx_ibs)
@@ -763,7 +776,7 @@ int smc_wr_alloc_link_mem(struct smc_link *link)
 				   GFP_KERNEL);
 	if (!link->wr_tx_sges)
 		goto no_mem_wr_tx_rdma_sges;
-	link->wr_rx_sges = kcalloc(SMC_WR_BUF_CNT * 3,
+	link->wr_rx_sges = kcalloc(SMC_WR_BUF_CNT,
 				   sizeof(link->wr_rx_sges[0]) * sges_per_buf,
 				   GFP_KERNEL);
 	if (!link->wr_rx_sges)
@@ -886,6 +899,13 @@ int smc_wr_create_link(struct smc_link *lnk)
 	atomic_set(&lnk->wr_tx_refcnt, 0);
 	init_waitqueue_head(&lnk->wr_reg_wait);
 	atomic_set(&lnk->wr_reg_refcnt, 0);
+	atomic_set(&lnk->peer_rq_credits, 0);
+	atomic_set(&lnk->local_rq_credits, 0);
+	lnk->flags = 0;
+	// set local rq credits high watermark to lnk->wr_rx_cnt / 3,
+	// if local rq credits more than high watermark, announcement is needed.
+	lnk->local_cr_watermark_high = max(lnk->wr_rx_cnt / 3, 1U);
+	lnk->peer_cr_watermark_low = 0;
 	return rc;
 
 dma_unmap:
diff --git a/net/smc/smc_wr.h b/net/smc/smc_wr.h
index 47512ccce5ef..1104bcf1040a 100644
--- a/net/smc/smc_wr.h
+++ b/net/smc/smc_wr.h
@@ -19,7 +19,12 @@
 #include "smc.h"
 #include "smc_core.h"
 
-#define SMC_WR_BUF_CNT 16	/* # of ctrl buffers per link */
+#define SMC_WR_BUF_CNT 64	/* # of ctrl buffers per link, SMC_WR_BUF_CNT
+				 * should not be less than 2 * SMC_RMBS_PER_LGR_MAX,
+				 * since every connection at least has two rq/sq
+				 * credits in average, otherwise may result in
+				 * waiting for credits in sending process.
+				 */
 
 #define SMC_WR_TX_WAIT_FREE_SLOT_TIME	(10 * HZ)
 
@@ -83,6 +88,51 @@ static inline void smc_wr_wakeup_reg_wait(struct smc_link *lnk)
 	wake_up(&lnk->wr_reg_wait);
 }
 
+// get one tx credit, and peer rq credits dec
+static inline int smc_wr_tx_get_credit(struct smc_link *link)
+{
+	return !link->credits_enable || atomic_dec_if_positive(&link->peer_rq_credits) >= 0;
+}
+
+// put tx credits, when some failures occurred after tx credits got
+// or receive announce credits msgs
+static inline void smc_wr_tx_put_credits(struct smc_link *link, int credits, bool wakeup)
+{
+	if (link->credits_enable && credits) {
+		atomic_add(credits, &link->peer_rq_credits);
+		if (wakeup && wq_has_sleeper(&link->wr_tx_wait))
+			wake_up_nr(&link->wr_tx_wait, credits);
+	}
+}
+
+// to check whether peer rq credits is lower than watermark.
+static inline int smc_wr_tx_credits_need_announce(struct smc_link *link)
+{
+	return link->credits_enable &&
+		atomic_read(&link->peer_rq_credits) <= link->peer_cr_watermark_low;
+}
+
+// get local rq credits and set credits to zero.
+// may called when announcing credits
+static inline int smc_wr_rx_get_credits(struct smc_link *link)
+{
+	return link->credits_enable ? atomic_fetch_and(0, &link->local_rq_credits) : 0;
+}
+
+// called when post_recv a rqe
+static inline void smc_wr_rx_put_credits(struct smc_link *link, int credits)
+{
+	if (link->credits_enable && credits)
+		atomic_add(credits, &link->local_rq_credits);
+}
+
+// to check whether local rq credits is higher than watermark.
+static inline int smc_wr_rx_credits_need_announce(struct smc_link *link)
+{
+	return link->credits_enable &&
+		atomic_read(&link->local_rq_credits) >= link->local_cr_watermark_high;
+}
+
 /* post a new receive work request to fill a completed old work request entry */
 static inline int smc_wr_rx_post(struct smc_link *link)
 {
@@ -95,6 +145,8 @@ static inline int smc_wr_rx_post(struct smc_link *link)
 	index = do_div(temp_wr_id, link->wr_rx_cnt);
 	link->wr_rx_ibs[index].wr_id = wr_id;
 	rc = ib_post_recv(link->roce_qp, &link->wr_rx_ibs[index], NULL);
+	if (!rc)
+		smc_wr_rx_put_credits(link, 1);
 	return rc;
 }
 
-- 
2.24.3 (Apple Git-128)

