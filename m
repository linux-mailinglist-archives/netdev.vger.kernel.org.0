Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC1E1C5628
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 15:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgEENCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 09:02:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5466 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728834AbgEENCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 09:02:08 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045CbFfB179553;
        Tue, 5 May 2020 09:02:04 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s2g2vmv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 09:02:03 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045D0amO015690;
        Tue, 5 May 2020 13:01:43 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 30s0g5aurd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 13:01:42 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045D1dMq62062766
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 13:01:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7F11AE057;
        Tue,  5 May 2020 13:01:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94A99AE055;
        Tue,  5 May 2020 13:01:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 May 2020 13:01:39 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 1/2] net/smc: log important pnetid and state change events
Date:   Tue,  5 May 2020 15:01:20 +0200
Message-Id: <20200505130121.103272-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505130121.103272-1-kgraul@linux.ibm.com>
References: <20200505130121.103272-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_07:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=3 bulkscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050098
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print to system log when SMC links are available or go down, link group
state changes or pnetids are applied to and removed from devices.
The log entries are triggered by either user configuration actions or
adapter activation/deactivation events and are not expected to happen
often. The entries help SMC users to keep track of the SMC link group
status and to detect when actions are needed (like to add replacements
for failed adapters).

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/af_smc.c   |  6 ++----
 net/smc/smc_core.c | 34 ++++++++++++++++++++++++++++-----
 net/smc/smc_core.h |  2 +-
 net/smc/smc_ib.c   | 11 +++++++++++
 net/smc/smc_ism.c  |  6 ++++++
 net/smc/smc_llc.c  | 25 ++++++++++++++++++------
 net/smc/smc_llc.h  |  2 +-
 net/smc/smc_pnet.c | 47 +++++++++++++++++++++++++++++++++++++++++++---
 8 files changed, 113 insertions(+), 20 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 4e4421c95ca1..903321543838 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -378,8 +378,6 @@ static int smcr_clnt_conf_first_link(struct smc_sock *smc)
 	struct smc_llc_qentry *qentry;
 	int rc;
 
-	link->lgr->type = SMC_LGR_SINGLE;
-
 	/* receive CONFIRM LINK request from server over RoCE fabric */
 	qentry = smc_llc_wait(link->lgr, NULL, SMC_LLC_WAIT_TIME,
 			      SMC_LLC_CONFIRM_LINK);
@@ -414,6 +412,7 @@ static int smcr_clnt_conf_first_link(struct smc_sock *smc)
 		return SMC_CLC_DECL_TIMEOUT_CL;
 
 	smc_llc_link_active(link);
+	smcr_lgr_set_type(link->lgr, SMC_LGR_SINGLE);
 
 	/* optional 2nd link, receive ADD LINK request from server */
 	qentry = smc_llc_wait(link->lgr, NULL, SMC_LLC_WAIT_TIME,
@@ -1037,8 +1036,6 @@ static int smcr_serv_conf_first_link(struct smc_sock *smc)
 	struct smc_llc_qentry *qentry;
 	int rc;
 
-	link->lgr->type = SMC_LGR_SINGLE;
-
 	if (smcr_link_reg_rmb(link, smc->conn.rmb_desc))
 		return SMC_CLC_DECL_ERR_REGRMB;
 
@@ -1067,6 +1064,7 @@ static int smcr_serv_conf_first_link(struct smc_sock *smc)
 	smc->conn.rmb_desc->is_conf_rkey = true;
 
 	smc_llc_link_active(link);
+	smcr_lgr_set_type(link->lgr, SMC_LGR_SINGLE);
 
 	/* initial contact - try to establish second link */
 	smc_llc_srv_add_link(link);
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index fb5f685ff494..65de700e1f17 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -369,7 +369,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 free_link_mem:
 	smc_wr_free_link_mem(lnk);
 clear_llc_lnk:
-	smc_llc_link_clear(lnk);
+	smc_llc_link_clear(lnk, false);
 out:
 	put_device(&ini->ib_dev->ibdev->dev);
 	memset(lnk, 0, sizeof(struct smc_link));
@@ -718,14 +718,14 @@ static void smcr_rtoken_clear_link(struct smc_link *lnk)
 }
 
 /* must be called under lgr->llc_conf_mutex lock */
-void smcr_link_clear(struct smc_link *lnk)
+void smcr_link_clear(struct smc_link *lnk, bool log)
 {
 	struct smc_ib_device *smcibdev;
 
 	if (!lnk->lgr || lnk->state == SMC_LNK_UNUSED)
 		return;
 	lnk->peer_qpn = 0;
-	smc_llc_link_clear(lnk);
+	smc_llc_link_clear(lnk, log);
 	smcr_buf_unmap_lgr(lnk);
 	smcr_rtoken_clear_link(lnk);
 	smc_ib_modify_qp_reset(lnk);
@@ -812,7 +812,7 @@ static void smc_lgr_free(struct smc_link_group *lgr)
 		mutex_lock(&lgr->llc_conf_mutex);
 		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 			if (lgr->lnk[i].state != SMC_LNK_UNUSED)
-				smcr_link_clear(&lgr->lnk[i]);
+				smcr_link_clear(&lgr->lnk[i], false);
 		}
 		mutex_unlock(&lgr->llc_conf_mutex);
 		smc_llc_lgr_clear(lgr);
@@ -1040,12 +1040,36 @@ void smc_smcr_terminate_all(struct smc_ib_device *smcibdev)
 /* set new lgr type and clear all asymmetric link tagging */
 void smcr_lgr_set_type(struct smc_link_group *lgr, enum smc_lgr_type new_type)
 {
+	char *lgr_type = "";
 	int i;
 
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++)
 		if (smc_link_usable(&lgr->lnk[i]))
 			lgr->lnk[i].link_is_asym = false;
+	if (lgr->type == new_type)
+		return;
 	lgr->type = new_type;
+
+	switch (lgr->type) {
+	case SMC_LGR_NONE:
+		lgr_type = "NONE";
+		break;
+	case SMC_LGR_SINGLE:
+		lgr_type = "SINGLE";
+		break;
+	case SMC_LGR_SYMMETRIC:
+		lgr_type = "SYMMETRIC";
+		break;
+	case SMC_LGR_ASYMMETRIC_PEER:
+		lgr_type = "ASYMMETRIC_PEER";
+		break;
+	case SMC_LGR_ASYMMETRIC_LOCAL:
+		lgr_type = "ASYMMETRIC_LOCAL";
+		break;
+	}
+	pr_warn_ratelimited("smc: SMC-R lg %*phN state changed: "
+			    "%s, pnetid %.16s\n", SMC_LGR_ID_SIZE, &lgr->id,
+			    lgr_type, lgr->pnet_id);
 }
 
 /* set new lgr type and tag a link as asymmetric */
@@ -1146,7 +1170,7 @@ static void smcr_link_down(struct smc_link *lnk)
 	smc_ib_modify_qp_reset(lnk);
 	to_lnk = smc_switch_conns(lgr, lnk, true);
 	if (!to_lnk) { /* no backup link available */
-		smcr_link_clear(lnk);
+		smcr_link_clear(lnk, true);
 		return;
 	}
 	smcr_lgr_set_type(lgr, SMC_LGR_SINGLE);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 4ae76802214f..86d160f0d187 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -383,7 +383,7 @@ void smc_core_exit(void);
 
 int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 		   u8 link_idx, struct smc_init_info *ini);
-void smcr_link_clear(struct smc_link *lnk);
+void smcr_link_clear(struct smc_link *lnk, bool log);
 int smcr_buf_map_lgr(struct smc_link *lnk);
 int smcr_buf_reg_lgr(struct smc_link *lnk);
 void smcr_lgr_set_type(struct smc_link_group *lgr, enum smc_lgr_type new_type);
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 2c743caad69a..f0a5064bf9bd 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -575,6 +575,8 @@ static void smc_ib_add_dev(struct ib_device *ibdev)
 
 	/* trigger reading of the port attributes */
 	port_cnt = smcibdev->ibdev->phys_port_cnt;
+	pr_warn_ratelimited("smc: adding ib device %s with port count %d\n",
+			    smcibdev->ibdev->name, port_cnt);
 	for (i = 0;
 	     i < min_t(size_t, port_cnt, SMC_MAX_PORTS);
 	     i++) {
@@ -583,6 +585,13 @@ static void smc_ib_add_dev(struct ib_device *ibdev)
 		if (smc_pnetid_by_dev_port(ibdev->dev.parent, i,
 					   smcibdev->pnetid[i]))
 			smc_pnetid_by_table_ib(smcibdev, i + 1);
+		pr_warn_ratelimited("smc:    ib device %s port %d has pnetid "
+				    "%.16s%s\n",
+				    smcibdev->ibdev->name, i + 1,
+				    smcibdev->pnetid[i],
+				    smcibdev->pnetid_by_user[i] ?
+				     " (user defined)" :
+				     "");
 	}
 	schedule_work(&smcibdev->port_event_work);
 }
@@ -599,6 +608,8 @@ static void smc_ib_remove_dev(struct ib_device *ibdev, void *client_data)
 	spin_lock(&smc_ib_devices.lock);
 	list_del_init(&smcibdev->list); /* remove from smc_ib_devices */
 	spin_unlock(&smc_ib_devices.lock);
+	pr_warn_ratelimited("smc: removing ib device %s\n",
+			    smcibdev->ibdev->name);
 	smc_smcr_terminate_all(smcibdev);
 	smc_ib_cleanup_per_ibdev(smcibdev);
 	ib_unregister_event_handler(&smcibdev->event_handler);
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 32be2da2cb85..91f85fc09fb8 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -321,12 +321,18 @@ int smcd_register_dev(struct smcd_dev *smcd)
 	list_add_tail(&smcd->list, &smcd_dev_list.list);
 	spin_unlock(&smcd_dev_list.lock);
 
+	pr_warn_ratelimited("smc: adding smcd device %s with pnetid %.16s%s\n",
+			    dev_name(&smcd->dev), smcd->pnetid,
+			    smcd->pnetid_by_user ? " (user defined)" : "");
+
 	return device_add(&smcd->dev);
 }
 EXPORT_SYMBOL_GPL(smcd_register_dev);
 
 void smcd_unregister_dev(struct smcd_dev *smcd)
 {
+	pr_warn_ratelimited("smc: removing smcd device %s\n",
+			    dev_name(&smcd->dev));
 	spin_lock(&smcd_dev_list.lock);
 	list_del_init(&smcd->list);
 	spin_unlock(&smcd_dev_list.lock);
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 66ddc9cf5e2f..4cc583678ac7 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -870,7 +870,7 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
 	if (!rc)
 		goto out;
 out_clear_lnk:
-	smcr_link_clear(lnk_new);
+	smcr_link_clear(lnk_new, false);
 out_reject:
 	smc_llc_cli_add_link_reject(qentry);
 out:
@@ -977,7 +977,7 @@ static void smc_llc_delete_asym_link(struct smc_link_group *lgr)
 	}
 	smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
 out_free:
-	smcr_link_clear(lnk_asym);
+	smcr_link_clear(lnk_asym, true);
 }
 
 static int smc_llc_srv_rkey_exchange(struct smc_link *link,
@@ -1121,7 +1121,7 @@ int smc_llc_srv_add_link(struct smc_link *link)
 		goto out_err;
 	return 0;
 out_err:
-	smcr_link_clear(link_new);
+	smcr_link_clear(link_new, false);
 	return rc;
 }
 
@@ -1227,7 +1227,7 @@ static void smc_llc_process_cli_delete_link(struct smc_link_group *lgr)
 		smc_switch_conns(lgr, lnk_del, false);
 		smc_wr_tx_wait_no_pending_sends(lnk_del);
 	}
-	smcr_link_clear(lnk_del);
+	smcr_link_clear(lnk_del, true);
 
 	active_links = smc_llc_active_link_count(lgr);
 	if (lnk_del == lnk_asym) {
@@ -1320,7 +1320,7 @@ static void smc_llc_process_srv_delete_link(struct smc_link_group *lgr)
 			}
 		}
 	}
-	smcr_link_clear(lnk_del);
+	smcr_link_clear(lnk_del, true);
 
 	active_links = smc_llc_active_link_count(lgr);
 	if (active_links == 1) {
@@ -1711,6 +1711,12 @@ int smc_llc_link_init(struct smc_link *link)
 
 void smc_llc_link_active(struct smc_link *link)
 {
+	pr_warn_ratelimited("smc: SMC-R lg %*phN link added: id %*phN, "
+			    "peerid %*phN, ibdev %s, ibport %d\n",
+			    SMC_LGR_ID_SIZE, &link->lgr->id,
+			    SMC_LGR_ID_SIZE, &link->link_uid,
+			    SMC_LGR_ID_SIZE, &link->peer_link_uid,
+			    link->smcibdev->ibdev->name, link->ibport);
 	link->state = SMC_LNK_ACTIVE;
 	if (link->lgr->llc_testlink_time) {
 		link->llc_testlink_time = link->lgr->llc_testlink_time * HZ;
@@ -1720,8 +1726,15 @@ void smc_llc_link_active(struct smc_link *link)
 }
 
 /* called in worker context */
-void smc_llc_link_clear(struct smc_link *link)
+void smc_llc_link_clear(struct smc_link *link, bool log)
 {
+	if (log)
+		pr_warn_ratelimited("smc: SMC-R lg %*phN link removed: id %*phN"
+				    ", peerid %*phN, ibdev %s, ibport %d\n",
+				    SMC_LGR_ID_SIZE, &link->lgr->id,
+				    SMC_LGR_ID_SIZE, &link->link_uid,
+				    SMC_LGR_ID_SIZE, &link->peer_link_uid,
+				    link->smcibdev->ibdev->name, link->ibport);
 	complete(&link->llc_testlink_resp);
 	cancel_delayed_work_sync(&link->llc_testlink_wrk);
 	smc_wr_wakeup_reg_wait(link);
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index 55287376112d..a5d2fe3eea61 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -82,7 +82,7 @@ void smc_llc_lgr_init(struct smc_link_group *lgr, struct smc_sock *smc);
 void smc_llc_lgr_clear(struct smc_link_group *lgr);
 int smc_llc_link_init(struct smc_link *link);
 void smc_llc_link_active(struct smc_link *link);
-void smc_llc_link_clear(struct smc_link *link);
+void smc_llc_link_clear(struct smc_link *link, bool log);
 int smc_llc_do_confirm_rkey(struct smc_link *send_link,
 			    struct smc_buf_desc *rmb_desc);
 int smc_llc_do_delete_rkey(struct smc_link_group *lgr,
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 50c96e843fab..be03f1260d59 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -110,8 +110,14 @@ static int smc_pnet_remove_by_pnetid(struct net *net, char *pnet_name)
 		if (!pnet_name ||
 		    smc_pnet_match(pnetelem->pnet_name, pnet_name)) {
 			list_del(&pnetelem->list);
-			if (pnetelem->type == SMC_PNET_ETH && pnetelem->ndev)
+			if (pnetelem->type == SMC_PNET_ETH && pnetelem->ndev) {
 				dev_put(pnetelem->ndev);
+				pr_warn_ratelimited("smc: net device %s "
+						    "erased user defined "
+						    "pnetid %.16s\n",
+						    pnetelem->eth_name,
+						    pnetelem->pnet_name);
+			}
 			kfree(pnetelem);
 			rc = 0;
 		}
@@ -130,6 +136,12 @@ static int smc_pnet_remove_by_pnetid(struct net *net, char *pnet_name)
 			    (!pnet_name ||
 			     smc_pnet_match(pnet_name,
 					    ibdev->pnetid[ibport]))) {
+				pr_warn_ratelimited("smc: ib device %s ibport "
+						    "%d erased user defined "
+						    "pnetid %.16s\n",
+						    ibdev->ibdev->name,
+						    ibport + 1,
+						    ibdev->pnetid[ibport]);
 				memset(ibdev->pnetid[ibport], 0,
 				       SMC_MAX_PNETID_LEN);
 				ibdev->pnetid_by_user[ibport] = false;
@@ -144,6 +156,10 @@ static int smc_pnet_remove_by_pnetid(struct net *net, char *pnet_name)
 		if (smcd_dev->pnetid_by_user &&
 		    (!pnet_name ||
 		     smc_pnet_match(pnet_name, smcd_dev->pnetid))) {
+			pr_warn_ratelimited("smc: smcd device %s "
+					    "erased user defined pnetid "
+					    "%.16s\n", dev_name(&smcd_dev->dev),
+					    smcd_dev->pnetid);
 			memset(smcd_dev->pnetid, 0, SMC_MAX_PNETID_LEN);
 			smcd_dev->pnetid_by_user = false;
 			rc = 0;
@@ -174,6 +190,10 @@ static int smc_pnet_add_by_ndev(struct net_device *ndev)
 			dev_hold(ndev);
 			pnetelem->ndev = ndev;
 			rc = 0;
+			pr_warn_ratelimited("smc: adding net device %s with "
+					    "user defined pnetid %.16s\n",
+					    pnetelem->eth_name,
+					    pnetelem->pnet_name);
 			break;
 		}
 	}
@@ -201,6 +221,10 @@ static int smc_pnet_remove_by_ndev(struct net_device *ndev)
 			dev_put(pnetelem->ndev);
 			pnetelem->ndev = NULL;
 			rc = 0;
+			pr_warn_ratelimited("smc: removing net device %s with "
+					    "user defined pnetid %.16s\n",
+					    pnetelem->eth_name,
+					    pnetelem->pnet_name);
 			break;
 		}
 	}
@@ -357,6 +381,10 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 		kfree(new_pe);
 		goto out_put;
 	}
+	if (ndev)
+		pr_warn_ratelimited("smc: net device %s "
+				    "applied user defined pnetid %.16s\n",
+				    new_pe->eth_name, new_pe->pnet_name);
 	return 0;
 
 out_put:
@@ -377,11 +405,24 @@ static int smc_pnet_add_ib(struct smc_pnettable *pnettable, char *ib_name,
 
 	/* try to apply the pnetid to active devices */
 	ib_dev = smc_pnet_find_ib(ib_name);
-	if (ib_dev)
+	if (ib_dev) {
 		ibdev_applied = smc_pnet_apply_ib(ib_dev, ib_port, pnet_name);
+		if (ibdev_applied)
+			pr_warn_ratelimited("smc: ib device %s ibport %d "
+					    "applied user defined pnetid "
+					    "%.16s\n", ib_dev->ibdev->name,
+					    ib_port,
+					    ib_dev->pnetid[ib_port - 1]);
+	}
 	smcd_dev = smc_pnet_find_smcd(ib_name);
-	if (smcd_dev)
+	if (smcd_dev) {
 		smcddev_applied = smc_pnet_apply_smcd(smcd_dev, pnet_name);
+		if (smcddev_applied)
+			pr_warn_ratelimited("smc: smcd device %s "
+					    "applied user defined pnetid "
+					    "%.16s\n", dev_name(&smcd_dev->dev),
+					    smcd_dev->pnetid);
+	}
 	/* Apply fails when a device has a hardware-defined pnetid set, do not
 	 * add a pnet table entry in that case.
 	 */
-- 
2.17.1

