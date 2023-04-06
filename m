Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223E16D9C69
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239470AbjDFPaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjDFPas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:30:48 -0400
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B205E61;
        Thu,  6 Apr 2023 08:30:45 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VfTVmhO_1680795041;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VfTVmhO_1680795041)
          by smtp.aliyun-inc.com;
          Thu, 06 Apr 2023 23:30:41 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [RFC PATCH bpf-next 1/5] net/smc: move smc_sock related structure definition
Date:   Thu,  6 Apr 2023 23:30:30 +0800
Message-Id: <1680795034-86384-2-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1680795034-86384-1-git-send-email-alibuda@linux.alibaba.com>
References: <1680795034-86384-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

This patch only try to move the definition of smc_sock and its
related structure, from et/smc/smc.h to include/net/smc/smc.h.
In that way can ebpf generate the BTF ID corresponding to our
structure.

Of course, we can also choose to hide the structure and only to
expose an intermediate structure, but it requires an additional
transformation. If we need to obtain some information frequently, this
may cause some performance problems.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 include/net/smc.h | 225 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc.h     | 224 -----------------------------------------------------
 2 files changed, 225 insertions(+), 224 deletions(-)

diff --git a/include/net/smc.h b/include/net/smc.h
index 597cb93..eccbd37 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -11,12 +11,17 @@
 #ifndef _SMC_H
 #define _SMC_H
 
+#include <net/inet_connection_sock.h>
 #include <linux/device.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/wait.h>
 #include "linux/ism.h"
 
+#ifdef ATOMIC64_INIT
+#define KERNEL_HAS_ATOMIC64
+#endif
+
 struct sock;
 
 #define SMC_MAX_PNETID_LEN	16	/* Max. length of PNET id */
@@ -90,4 +95,224 @@ struct smcd_dev {
 	u8 going_away : 1;
 };
 
+struct smc_wr_rx_hdr {	/* common prefix part of LLC and CDC to demultiplex */
+	union {
+		u8 type;
+#if defined(__BIG_ENDIAN_BITFIELD)
+		struct {
+			u8 llc_version:4,
+			   llc_type:4;
+		};
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		struct {
+			u8 llc_type:4,
+			   llc_version:4;
+		};
+#endif
+	};
+} __aligned(1);
+
+struct smc_cdc_conn_state_flags {
+#if defined(__BIG_ENDIAN_BITFIELD)
+	u8	peer_done_writing : 1;	/* Sending done indicator */
+	u8	peer_conn_closed : 1;	/* Peer connection closed indicator */
+	u8	peer_conn_abort : 1;	/* Abnormal close indicator */
+	u8	reserved : 5;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	u8	reserved : 5;
+	u8	peer_conn_abort : 1;
+	u8	peer_conn_closed : 1;
+	u8	peer_done_writing : 1;
+#endif
+};
+
+struct smc_cdc_producer_flags {
+#if defined(__BIG_ENDIAN_BITFIELD)
+	u8	write_blocked : 1;	/* Writing Blocked, no rx buf space */
+	u8	urg_data_pending : 1;	/* Urgent Data Pending */
+	u8	urg_data_present : 1;	/* Urgent Data Present */
+	u8	cons_curs_upd_req : 1;	/* cursor update requested */
+	u8	failover_validation : 1;/* message replay due to failover */
+	u8	reserved : 3;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	u8	reserved : 3;
+	u8	failover_validation : 1;
+	u8	cons_curs_upd_req : 1;
+	u8	urg_data_present : 1;
+	u8	urg_data_pending : 1;
+	u8	write_blocked : 1;
+#endif
+};
+
+/* in host byte order */
+union smc_host_cursor {	/* SMC cursor - an offset in an RMBE */
+	struct {
+		u16	reserved;
+		u16	wrap;		/* window wrap sequence number */
+		u32	count;		/* cursor (= offset) part */
+	};
+#ifdef KERNEL_HAS_ATOMIC64
+	atomic64_t		acurs;	/* for atomic processing */
+#else
+	u64			acurs;	/* for atomic processing */
+#endif
+} __aligned(8);
+
+/* in host byte order, except for flag bitfields in network byte order */
+struct smc_host_cdc_msg {		/* Connection Data Control message */
+	struct smc_wr_rx_hdr		common; /* .type = 0xFE */
+	u8				len;	/* length = 44 */
+	u16				seqno;	/* connection seq # */
+	u32				token;	/* alert_token */
+	union smc_host_cursor		prod;		/* producer cursor */
+	union smc_host_cursor		cons;		/* consumer cursor,
+							 * piggy backed "ack"
+							 */
+	struct smc_cdc_producer_flags	prod_flags;	/* conn. tx/rx status */
+	struct smc_cdc_conn_state_flags	conn_state_flags; /* peer conn. status*/
+	u8				reserved[18];
+} __aligned(8);
+
+enum smc_urg_state {
+	SMC_URG_VALID	= 1,			/* data present */
+	SMC_URG_NOTYET	= 2,			/* data pending */
+	SMC_URG_READ	= 3,			/* data was already read */
+};
+
+struct smc_connection {
+	struct rb_node		alert_node;
+	struct smc_link_group	*lgr;		/* link group of connection */
+	struct smc_link		*lnk;		/* assigned SMC-R link */
+	u32			alert_token_local; /* unique conn. id */
+	u8			peer_rmbe_idx;	/* from tcp handshake */
+	int			peer_rmbe_size;	/* size of peer rx buffer */
+	atomic_t		peer_rmbe_space;/* remaining free bytes in peer
+						 * rmbe
+						 */
+	int			rtoken_idx;	/* idx to peer RMB rkey/addr */
+
+	struct smc_buf_desc	*sndbuf_desc;	/* send buffer descriptor */
+	struct smc_buf_desc	*rmb_desc;	/* RMBE descriptor */
+	int			rmbe_size_short;/* compressed notation */
+	int			rmbe_update_limit;
+						/* lower limit for consumer
+						 * cursor update
+						 */
+
+	struct smc_host_cdc_msg	local_tx_ctrl;	/* host byte order staging
+						 * buffer for CDC msg send
+						 * .prod cf. TCP snd_nxt
+						 * .cons cf. TCP sends ack
+						 */
+	union smc_host_cursor	local_tx_ctrl_fin;
+						/* prod crsr - confirmed by peer
+						 */
+	union smc_host_cursor	tx_curs_prep;	/* tx - prepared data
+						 * snd_max..wmem_alloc
+						 */
+	union smc_host_cursor	tx_curs_sent;	/* tx - sent data
+						 * snd_nxt ?
+						 */
+	union smc_host_cursor	tx_curs_fin;	/* tx - confirmed by peer
+						 * snd-wnd-begin ?
+						 */
+	atomic_t		sndbuf_space;	/* remaining space in sndbuf */
+	u16			tx_cdc_seq;	/* sequence # for CDC send */
+	u16			tx_cdc_seq_fin;	/* sequence # - tx completed */
+	spinlock_t		send_lock;	/* protect wr_sends */
+	atomic_t		cdc_pend_tx_wr; /* number of pending tx CDC wqe
+						 * - inc when post wqe,
+						 * - dec on polled tx cqe
+						 */
+	wait_queue_head_t	cdc_pend_tx_wq; /* wakeup on no cdc_pend_tx_wr*/
+	atomic_t		tx_pushing;     /* nr_threads trying tx push */
+	struct delayed_work	tx_work;	/* retry of smc_cdc_msg_send */
+	u32			tx_off;		/* base offset in peer rmb */
+
+	struct smc_host_cdc_msg	local_rx_ctrl;	/* filled during event_handl.
+						 * .prod cf. TCP rcv_nxt
+						 * .cons cf. TCP snd_una
+						 */
+	union smc_host_cursor	rx_curs_confirmed; /* confirmed to peer
+						    * source of snd_una ?
+						    */
+	union smc_host_cursor	urg_curs;	/* points at urgent byte */
+	enum smc_urg_state	urg_state;
+	bool			urg_tx_pend;	/* urgent data staged */
+	bool			urg_rx_skip_pend;
+						/* indicate urgent oob data
+						 * read, but previous regular
+						 * data still pending
+						 */
+	char			urg_rx_byte;	/* urgent byte */
+	bool			tx_in_release_sock;
+						/* flush pending tx data in
+						 * sock release_cb()
+						 */
+	atomic_t		bytes_to_rcv;	/* arrived data,
+						 * not yet received
+						 */
+	atomic_t		splice_pending;	/* number of spliced bytes
+						 * pending processing
+						 */
+#ifndef KERNEL_HAS_ATOMIC64
+	spinlock_t		acurs_lock;	/* protect cursors */
+#endif
+	struct work_struct	close_work;	/* peer sent some closing */
+	struct work_struct	abort_work;	/* abort the connection */
+	struct tasklet_struct	rx_tsklet;	/* Receiver tasklet for SMC-D */
+	u8			rx_off;		/* receive offset:
+						 * 0 for SMC-R, 32 for SMC-D
+						 */
+	u64			peer_token;	/* SMC-D token of peer */
+	u8			killed : 1;	/* abnormal termination */
+	u8			freed : 1;	/* normal termiation */
+	u8			out_of_sync : 1; /* out of sync with peer */
+};
+
+struct smc_sock {				/* smc sock container */
+	struct sock		sk;
+	struct socket		*clcsock;	/* internal tcp socket */
+	void			(*clcsk_state_change)(struct sock *sk);
+						/* original stat_change fct. */
+	void			(*clcsk_data_ready)(struct sock *sk);
+						/* original data_ready fct. */
+	void			(*clcsk_write_space)(struct sock *sk);
+						/* original write_space fct. */
+	void			(*clcsk_error_report)(struct sock *sk);
+						/* original error_report fct. */
+	struct smc_connection	conn;		/* smc connection */
+	struct smc_sock		*listen_smc;	/* listen parent */
+	struct work_struct	connect_work;	/* handle non-blocking connect*/
+	struct work_struct	tcp_listen_work;/* handle tcp socket accepts */
+	struct work_struct	smc_listen_work;/* prepare new accept socket */
+	struct list_head	accept_q;	/* sockets to be accepted */
+	spinlock_t		accept_q_lock;	/* protects accept_q */
+	bool			limit_smc_hs;	/* put constraint on handshake */
+	bool			use_fallback;	/* fallback to tcp */
+	int			fallback_rsn;	/* reason for fallback */
+	u32			peer_diagnosis; /* decline reason from peer */
+	atomic_t                queued_smc_hs;  /* queued smc handshakes */
+	struct inet_connection_sock_af_ops		af_ops;
+	const struct inet_connection_sock_af_ops	*ori_af_ops;
+						/* original af ops */
+	int			sockopt_defer_accept;
+						/* sockopt TCP_DEFER_ACCEPT
+						 * value
+						 */
+	u8			wait_close_tx_prepared : 1;
+						/* shutdown wr or close
+						 * started, waiting for unsent
+						 * data to be sent
+						 */
+	u8			connect_nonblock : 1;
+						/* non-blocking connect in
+						 * flight
+						 */
+	struct mutex            clcsock_release_lock;
+						/* protects clcsock of a listen
+						 * socket
+						 */
+};
+
 #endif	/* _SMC_H */
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 5ed765e..6f27f40 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -34,10 +34,6 @@
 extern struct proto smc_proto;
 extern struct proto smc_proto6;
 
-#ifdef ATOMIC64_INIT
-#define KERNEL_HAS_ATOMIC64
-#endif
-
 enum smc_state {		/* possible states of an SMC socket */
 	SMC_ACTIVE	= 1,
 	SMC_INIT	= 2,
@@ -57,232 +53,12 @@ enum smc_state {		/* possible states of an SMC socket */
 
 struct smc_link_group;
 
-struct smc_wr_rx_hdr {	/* common prefix part of LLC and CDC to demultiplex */
-	union {
-		u8 type;
-#if defined(__BIG_ENDIAN_BITFIELD)
-		struct {
-			u8 llc_version:4,
-			   llc_type:4;
-		};
-#elif defined(__LITTLE_ENDIAN_BITFIELD)
-		struct {
-			u8 llc_type:4,
-			   llc_version:4;
-		};
-#endif
-	};
-} __aligned(1);
-
-struct smc_cdc_conn_state_flags {
-#if defined(__BIG_ENDIAN_BITFIELD)
-	u8	peer_done_writing : 1;	/* Sending done indicator */
-	u8	peer_conn_closed : 1;	/* Peer connection closed indicator */
-	u8	peer_conn_abort : 1;	/* Abnormal close indicator */
-	u8	reserved : 5;
-#elif defined(__LITTLE_ENDIAN_BITFIELD)
-	u8	reserved : 5;
-	u8	peer_conn_abort : 1;
-	u8	peer_conn_closed : 1;
-	u8	peer_done_writing : 1;
-#endif
-};
-
-struct smc_cdc_producer_flags {
-#if defined(__BIG_ENDIAN_BITFIELD)
-	u8	write_blocked : 1;	/* Writing Blocked, no rx buf space */
-	u8	urg_data_pending : 1;	/* Urgent Data Pending */
-	u8	urg_data_present : 1;	/* Urgent Data Present */
-	u8	cons_curs_upd_req : 1;	/* cursor update requested */
-	u8	failover_validation : 1;/* message replay due to failover */
-	u8	reserved : 3;
-#elif defined(__LITTLE_ENDIAN_BITFIELD)
-	u8	reserved : 3;
-	u8	failover_validation : 1;
-	u8	cons_curs_upd_req : 1;
-	u8	urg_data_present : 1;
-	u8	urg_data_pending : 1;
-	u8	write_blocked : 1;
-#endif
-};
-
-/* in host byte order */
-union smc_host_cursor {	/* SMC cursor - an offset in an RMBE */
-	struct {
-		u16	reserved;
-		u16	wrap;		/* window wrap sequence number */
-		u32	count;		/* cursor (= offset) part */
-	};
-#ifdef KERNEL_HAS_ATOMIC64
-	atomic64_t		acurs;	/* for atomic processing */
-#else
-	u64			acurs;	/* for atomic processing */
-#endif
-} __aligned(8);
-
-/* in host byte order, except for flag bitfields in network byte order */
-struct smc_host_cdc_msg {		/* Connection Data Control message */
-	struct smc_wr_rx_hdr		common; /* .type = 0xFE */
-	u8				len;	/* length = 44 */
-	u16				seqno;	/* connection seq # */
-	u32				token;	/* alert_token */
-	union smc_host_cursor		prod;		/* producer cursor */
-	union smc_host_cursor		cons;		/* consumer cursor,
-							 * piggy backed "ack"
-							 */
-	struct smc_cdc_producer_flags	prod_flags;	/* conn. tx/rx status */
-	struct smc_cdc_conn_state_flags	conn_state_flags; /* peer conn. status*/
-	u8				reserved[18];
-} __aligned(8);
-
-enum smc_urg_state {
-	SMC_URG_VALID	= 1,			/* data present */
-	SMC_URG_NOTYET	= 2,			/* data pending */
-	SMC_URG_READ	= 3,			/* data was already read */
-};
-
 struct smc_mark_woken {
 	bool woken;
 	void *key;
 	wait_queue_entry_t wait_entry;
 };
 
-struct smc_connection {
-	struct rb_node		alert_node;
-	struct smc_link_group	*lgr;		/* link group of connection */
-	struct smc_link		*lnk;		/* assigned SMC-R link */
-	u32			alert_token_local; /* unique conn. id */
-	u8			peer_rmbe_idx;	/* from tcp handshake */
-	int			peer_rmbe_size;	/* size of peer rx buffer */
-	atomic_t		peer_rmbe_space;/* remaining free bytes in peer
-						 * rmbe
-						 */
-	int			rtoken_idx;	/* idx to peer RMB rkey/addr */
-
-	struct smc_buf_desc	*sndbuf_desc;	/* send buffer descriptor */
-	struct smc_buf_desc	*rmb_desc;	/* RMBE descriptor */
-	int			rmbe_size_short;/* compressed notation */
-	int			rmbe_update_limit;
-						/* lower limit for consumer
-						 * cursor update
-						 */
-
-	struct smc_host_cdc_msg	local_tx_ctrl;	/* host byte order staging
-						 * buffer for CDC msg send
-						 * .prod cf. TCP snd_nxt
-						 * .cons cf. TCP sends ack
-						 */
-	union smc_host_cursor	local_tx_ctrl_fin;
-						/* prod crsr - confirmed by peer
-						 */
-	union smc_host_cursor	tx_curs_prep;	/* tx - prepared data
-						 * snd_max..wmem_alloc
-						 */
-	union smc_host_cursor	tx_curs_sent;	/* tx - sent data
-						 * snd_nxt ?
-						 */
-	union smc_host_cursor	tx_curs_fin;	/* tx - confirmed by peer
-						 * snd-wnd-begin ?
-						 */
-	atomic_t		sndbuf_space;	/* remaining space in sndbuf */
-	u16			tx_cdc_seq;	/* sequence # for CDC send */
-	u16			tx_cdc_seq_fin;	/* sequence # - tx completed */
-	spinlock_t		send_lock;	/* protect wr_sends */
-	atomic_t		cdc_pend_tx_wr; /* number of pending tx CDC wqe
-						 * - inc when post wqe,
-						 * - dec on polled tx cqe
-						 */
-	wait_queue_head_t	cdc_pend_tx_wq; /* wakeup on no cdc_pend_tx_wr*/
-	atomic_t		tx_pushing;     /* nr_threads trying tx push */
-	struct delayed_work	tx_work;	/* retry of smc_cdc_msg_send */
-	u32			tx_off;		/* base offset in peer rmb */
-
-	struct smc_host_cdc_msg	local_rx_ctrl;	/* filled during event_handl.
-						 * .prod cf. TCP rcv_nxt
-						 * .cons cf. TCP snd_una
-						 */
-	union smc_host_cursor	rx_curs_confirmed; /* confirmed to peer
-						    * source of snd_una ?
-						    */
-	union smc_host_cursor	urg_curs;	/* points at urgent byte */
-	enum smc_urg_state	urg_state;
-	bool			urg_tx_pend;	/* urgent data staged */
-	bool			urg_rx_skip_pend;
-						/* indicate urgent oob data
-						 * read, but previous regular
-						 * data still pending
-						 */
-	char			urg_rx_byte;	/* urgent byte */
-	bool			tx_in_release_sock;
-						/* flush pending tx data in
-						 * sock release_cb()
-						 */
-	atomic_t		bytes_to_rcv;	/* arrived data,
-						 * not yet received
-						 */
-	atomic_t		splice_pending;	/* number of spliced bytes
-						 * pending processing
-						 */
-#ifndef KERNEL_HAS_ATOMIC64
-	spinlock_t		acurs_lock;	/* protect cursors */
-#endif
-	struct work_struct	close_work;	/* peer sent some closing */
-	struct work_struct	abort_work;	/* abort the connection */
-	struct tasklet_struct	rx_tsklet;	/* Receiver tasklet for SMC-D */
-	u8			rx_off;		/* receive offset:
-						 * 0 for SMC-R, 32 for SMC-D
-						 */
-	u64			peer_token;	/* SMC-D token of peer */
-	u8			killed : 1;	/* abnormal termination */
-	u8			freed : 1;	/* normal termiation */
-	u8			out_of_sync : 1; /* out of sync with peer */
-};
-
-struct smc_sock {				/* smc sock container */
-	struct sock		sk;
-	struct socket		*clcsock;	/* internal tcp socket */
-	void			(*clcsk_state_change)(struct sock *sk);
-						/* original stat_change fct. */
-	void			(*clcsk_data_ready)(struct sock *sk);
-						/* original data_ready fct. */
-	void			(*clcsk_write_space)(struct sock *sk);
-						/* original write_space fct. */
-	void			(*clcsk_error_report)(struct sock *sk);
-						/* original error_report fct. */
-	struct smc_connection	conn;		/* smc connection */
-	struct smc_sock		*listen_smc;	/* listen parent */
-	struct work_struct	connect_work;	/* handle non-blocking connect*/
-	struct work_struct	tcp_listen_work;/* handle tcp socket accepts */
-	struct work_struct	smc_listen_work;/* prepare new accept socket */
-	struct list_head	accept_q;	/* sockets to be accepted */
-	spinlock_t		accept_q_lock;	/* protects accept_q */
-	bool			limit_smc_hs;	/* put constraint on handshake */
-	bool			use_fallback;	/* fallback to tcp */
-	int			fallback_rsn;	/* reason for fallback */
-	u32			peer_diagnosis; /* decline reason from peer */
-	atomic_t                queued_smc_hs;  /* queued smc handshakes */
-	struct inet_connection_sock_af_ops		af_ops;
-	const struct inet_connection_sock_af_ops	*ori_af_ops;
-						/* original af ops */
-	int			sockopt_defer_accept;
-						/* sockopt TCP_DEFER_ACCEPT
-						 * value
-						 */
-	u8			wait_close_tx_prepared : 1;
-						/* shutdown wr or close
-						 * started, waiting for unsent
-						 * data to be sent
-						 */
-	u8			connect_nonblock : 1;
-						/* non-blocking connect in
-						 * flight
-						 */
-	struct mutex            clcsock_release_lock;
-						/* protects clcsock of a listen
-						 * socket
-						 * */
-};
-
 static inline struct smc_sock *smc_sk(const struct sock *sk)
 {
 	return (struct smc_sock *)sk;
-- 
1.8.3.1

