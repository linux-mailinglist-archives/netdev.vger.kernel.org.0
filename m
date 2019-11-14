Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12753FC5DE
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 13:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfKNMDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 07:03:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60412 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726910AbfKNMDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 07:03:02 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEBvmux061988
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:03:01 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w933sqqmm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:03:00 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Thu, 14 Nov 2019 12:02:57 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 12:02:55 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEC2r3P28835864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 12:02:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDE734C05E;
        Thu, 14 Nov 2019 12:02:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 871894C044;
        Thu, 14 Nov 2019 12:02:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 12:02:53 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 1/8] net/smc: fix final cleanup sequence for SMCD devices
Date:   Thu, 14 Nov 2019 13:02:40 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114120247.68889-1-kgraul@linux.ibm.com>
References: <20191114120247.68889-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111412-4275-0000-0000-0000037DACEE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111412-4276-0000-0000-0000389112FC
Message-Id: <20191114120247.68889-2-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140113
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

If peer announces shutdown, use the link group terminate worker for
local cleanup of link groups and connections to terminate link group
in proper context.

Make sure link groups are cleaned up first before destroying the
event queue of the SMCD device, because link group cleanup may
raise events.

Send signal shutdown only if peer has not done it already.

Send socket abort or close only, if peer has not already announced
shutdown.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_cdc.c  |  3 +++
 net/smc/smc_core.c | 18 +++++++++++-------
 net/smc/smc_core.h |  2 ++
 net/smc/smc_ism.c  |  7 +++++--
 4 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 7dc07ec2379b..164f1584861b 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -131,6 +131,9 @@ int smc_cdc_get_slot_and_msg_send(struct smc_connection *conn)
 {
 	int rc;
 
+	if (!conn->lgr || (conn->lgr->is_smcd && conn->lgr->peer_shutdown))
+		return -EPIPE;
+
 	if (conn->lgr->is_smcd) {
 		spin_lock_bh(&conn->send_lock);
 		rc = smcd_cdc_msg_send(conn);
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 0d92456729ab..561f069b30de 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -275,6 +275,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		lgr->smcd = ini->ism_dev;
 		lgr_list = &ini->ism_dev->lgr_list;
 		lgr_lock = &lgr->smcd->lgr_lock;
+		lgr->peer_shutdown = 0;
 	} else {
 		/* SMC-R specific settings */
 		get_device(&ini->ib_dev->ibdev->dev);
@@ -514,11 +515,16 @@ static void smc_conn_kill(struct smc_connection *conn)
 {
 	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
 
-	smc_close_abort(conn);
+	if (conn->lgr->is_smcd && conn->lgr->peer_shutdown)
+		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
+	else
+		smc_close_abort(conn);
 	conn->killed = 1;
+	smc->sk.sk_err = ECONNABORTED;
 	smc_sk_wake_ups(smc);
+	if (conn->lgr->is_smcd)
+		tasklet_kill(&conn->rx_tsklet);
 	smc_lgr_unregister_conn(conn);
-	smc->sk.sk_err = ECONNABORTED;
 	smc_close_active_abort(smc);
 }
 
@@ -604,6 +610,8 @@ void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid, unsigned short vlan)
 	list_for_each_entry_safe(lgr, l, &dev->lgr_list, list) {
 		if ((!peer_gid || lgr->peer_gid == peer_gid) &&
 		    (vlan == VLAN_VID_MASK || lgr->vlan_id == vlan)) {
+			if (peer_gid) /* peer triggered termination */
+				lgr->peer_shutdown = 1;
 			list_move(&lgr->list, &lgr_free_list);
 		}
 	}
@@ -612,11 +620,7 @@ void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid, unsigned short vlan)
 	/* cancel the regular free workers and actually free lgrs */
 	list_for_each_entry_safe(lgr, l, &lgr_free_list, list) {
 		list_del_init(&lgr->list);
-		__smc_lgr_terminate(lgr);
-		cancel_delayed_work_sync(&lgr->free_work);
-		if (!peer_gid && vlan == VLAN_VID_MASK) /* dev terminated? */
-			smc_ism_signal_shutdown(lgr);
-		smc_lgr_free(lgr);
+		schedule_work(&lgr->terminate_work);
 	}
 }
 
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index e6fd1ed42064..097ceba86caf 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -228,6 +228,8 @@ struct smc_link_group {
 						/* Peer GID (remote) */
 			struct smcd_dev		*smcd;
 						/* ISM device for VLAN reg. */
+			u8			peer_shutdown : 1;
+						/* peer triggered shutdownn */
 		};
 	};
 };
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index ee7340898cb4..18946e95a3be 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -226,6 +226,9 @@ int smc_ism_signal_shutdown(struct smc_link_group *lgr)
 	int rc;
 	union smcd_sw_event_info ev_info;
 
+	if (lgr->peer_shutdown)
+		return 0;
+
 	memcpy(ev_info.uid, lgr->id, SMC_LGR_ID_SIZE);
 	ev_info.vlan_id = lgr->vlan_id;
 	ev_info.code = ISM_EVENT_REQUEST;
@@ -313,12 +316,12 @@ EXPORT_SYMBOL_GPL(smcd_register_dev);
 void smcd_unregister_dev(struct smcd_dev *smcd)
 {
 	spin_lock(&smcd_dev_list.lock);
-	list_del(&smcd->list);
+	list_del_init(&smcd->list);
 	spin_unlock(&smcd_dev_list.lock);
 	smcd->going_away = 1;
+	smc_smcd_terminate(smcd, 0, VLAN_VID_MASK);
 	flush_workqueue(smcd->event_wq);
 	destroy_workqueue(smcd->event_wq);
-	smc_smcd_terminate(smcd, 0, VLAN_VID_MASK);
 
 	device_del(&smcd->dev);
 }
-- 
2.17.1

