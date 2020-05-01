Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C5F1C1130
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 12:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgEAKs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 06:48:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50198 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728621AbgEAKsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 06:48:31 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041AX6Rv112267;
        Fri, 1 May 2020 06:48:29 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30r7mdevqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 06:48:29 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 041AjtRH028243;
        Fri, 1 May 2020 10:48:27 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 30mcu5bfbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 10:48:27 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 041AlFLU393946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 May 2020 10:47:15 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DF16A405F;
        Fri,  1 May 2020 10:48:24 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51F0DA4054;
        Fri,  1 May 2020 10:48:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 May 2020 10:48:24 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 07/13] net/smc: add smcr_port_add() and smcr_link_up() processing
Date:   Fri,  1 May 2020 12:48:07 +0200
Message-Id: <20200501104813.76601-8-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200501104813.76601-1-kgraul@linux.ibm.com>
References: <20200501104813.76601-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_04:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=3 clxscore=1015 phishscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010082
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call smcr_port_add() when an IB event reports a new active IB device.
smcr_port_add() will start a work which either triggers the local
ADD_LINK processing, or send an ADD_LINK LLC message to the SMC server
to initiate the processing.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c | 86 ++++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_core.h |  1 +
 net/smc/smc_ib.c   |  1 +
 3 files changed, 88 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index d7ab92fc5b15..20bc9e46bf52 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -44,10 +44,19 @@ static struct smc_lgr_list smc_lgr_list = {	/* established link groups */
 static atomic_t lgr_cnt = ATOMIC_INIT(0); /* number of existing link groups */
 static DECLARE_WAIT_QUEUE_HEAD(lgrs_deleted);
 
+struct smc_ib_up_work {
+	struct work_struct	work;
+	struct smc_link_group	*lgr;
+	struct smc_ib_device	*smcibdev;
+	u8			ibport;
+};
+
 static void smc_buf_free(struct smc_link_group *lgr, bool is_rmb,
 			 struct smc_buf_desc *buf_desc);
 static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft);
 
+static void smc_link_up_work(struct work_struct *work);
+
 /* return head of link group list and its lock for a given link group */
 static inline struct list_head *smc_lgr_list_head(struct smc_link_group *lgr,
 						  spinlock_t **lgr_lock)
@@ -928,6 +937,83 @@ void smc_smcr_terminate_all(struct smc_ib_device *smcibdev)
 	}
 }
 
+/* link is up - establish alternate link if applicable */
+static void smcr_link_up(struct smc_link_group *lgr,
+			 struct smc_ib_device *smcibdev, u8 ibport)
+{
+	struct smc_link *link = NULL;
+
+	if (list_empty(&lgr->list) ||
+	    lgr->type == SMC_LGR_SYMMETRIC ||
+	    lgr->type == SMC_LGR_ASYMMETRIC_PEER)
+		return;
+
+	if (lgr->role == SMC_SERV) {
+		/* trigger local add link processing */
+		link = smc_llc_usable_link(lgr);
+		if (!link)
+			return;
+		/* tbd: call smc_llc_srv_add_link_local(link); */
+	} else {
+		/* invite server to start add link processing */
+		u8 gid[SMC_GID_SIZE];
+
+		if (smc_ib_determine_gid(smcibdev, ibport, lgr->vlan_id, gid,
+					 NULL))
+			return;
+		if (lgr->llc_flow_lcl.type != SMC_LLC_FLOW_NONE) {
+			/* some other llc task is ongoing */
+			wait_event_interruptible_timeout(lgr->llc_waiter,
+				(lgr->llc_flow_lcl.type == SMC_LLC_FLOW_NONE),
+				SMC_LLC_WAIT_TIME);
+		}
+		if (list_empty(&lgr->list) ||
+		    !smc_ib_port_active(smcibdev, ibport))
+			return; /* lgr or device no longer active */
+		link = smc_llc_usable_link(lgr);
+		if (!link)
+			return;
+		smc_llc_send_add_link(link, smcibdev->mac[ibport - 1], gid,
+				      NULL, SMC_LLC_REQ);
+	}
+}
+
+void smcr_port_add(struct smc_ib_device *smcibdev, u8 ibport)
+{
+	struct smc_ib_up_work *ib_work;
+	struct smc_link_group *lgr, *n;
+
+	list_for_each_entry_safe(lgr, n, &smc_lgr_list.list, list) {
+		if (strncmp(smcibdev->pnetid[ibport - 1], lgr->pnet_id,
+			    SMC_MAX_PNETID_LEN) ||
+		    lgr->type == SMC_LGR_SYMMETRIC ||
+		    lgr->type == SMC_LGR_ASYMMETRIC_PEER)
+			continue;
+		ib_work = kmalloc(sizeof(*ib_work), GFP_KERNEL);
+		if (!ib_work)
+			continue;
+		INIT_WORK(&ib_work->work, smc_link_up_work);
+		ib_work->lgr = lgr;
+		ib_work->smcibdev = smcibdev;
+		ib_work->ibport = ibport;
+		schedule_work(&ib_work->work);
+	}
+}
+
+static void smc_link_up_work(struct work_struct *work)
+{
+	struct smc_ib_up_work *ib_work = container_of(work,
+						      struct smc_ib_up_work,
+						      work);
+	struct smc_link_group *lgr = ib_work->lgr;
+
+	if (list_empty(&lgr->list))
+		goto out;
+	smcr_link_up(lgr, ib_work->smcibdev, ib_work->ibport);
+out:
+	kfree(ib_work);
+}
+
 /* Determine vlan of internal TCP socket.
  * @vlan_id: address to store the determined vlan id into
  */
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 413eaad50c7f..86453ad83491 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -345,6 +345,7 @@ void smc_lgr_forget(struct smc_link_group *lgr);
 void smc_lgr_cleanup_early(struct smc_connection *conn);
 void smc_lgr_terminate_sched(struct smc_link_group *lgr);
 void smc_port_terminate(struct smc_ib_device *smcibdev, u8 ibport);
+void smcr_port_add(struct smc_ib_device *smcibdev, u8 ibport);
 void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid,
 			unsigned short vlan);
 void smc_smcd_terminate_all(struct smcd_dev *dev);
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index c090678a3e5a..545fb0bc3714 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -252,6 +252,7 @@ static void smc_ib_port_event_work(struct work_struct *work)
 			smc_port_terminate(smcibdev, port_idx + 1);
 		} else {
 			clear_bit(port_idx, smcibdev->ports_going_away);
+			smcr_port_add(smcibdev, port_idx + 1);
 		}
 	}
 }
-- 
2.17.1

