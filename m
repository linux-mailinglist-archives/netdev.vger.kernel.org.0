Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9DEDEF09
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbfJUONl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:13:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51742 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729223AbfJUONk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:13:40 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9LEDbox025495
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 10:13:40 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vse75r43x-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 10:13:38 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Mon, 21 Oct 2019 15:13:26 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 21 Oct 2019 15:13:22 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9LEDLMB29229396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 14:13:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7EFB4C05C;
        Mon, 21 Oct 2019 14:13:20 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78FA24C058;
        Mon, 21 Oct 2019 14:13:20 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Oct 2019 14:13:20 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 2/8] net/smc: terminate link group without holding lgr lock
Date:   Mon, 21 Oct 2019 16:13:09 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021141315.58969-1-kgraul@linux.ibm.com>
References: <20191021141315.58969-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19102114-0012-0000-0000-0000035AF872
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102114-0013-0000-0000-000021961FF2
Message-Id: <20191021141315.58969-3-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-21_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910210135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

When a link group is to be terminated, it is sufficient to hold
the lgr lock when unlinking the link group from its list.
Move the lock-protected link group unlinking into smc_lgr_terminate().

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 4ee0e33b8c5a..b53ba8f0a833 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -182,8 +182,7 @@ static void smc_lgr_free_work(struct work_struct *work)
 		spin_unlock_bh(lgr_lock);
 		return;
 	}
-	if (!list_empty(&lgr->list))
-		list_del_init(&lgr->list); /* remove from smc_lgr_list */
+	list_del_init(&lgr->list); /* remove from smc_lgr_list */
 	spin_unlock_bh(lgr_lock);
 
 	if (!lgr->is_smcd && !lgr->terminating)	{
@@ -479,7 +478,7 @@ void smc_lgr_forget(struct smc_link_group *lgr)
 	spin_unlock_bh(lgr_lock);
 }
 
-/* terminate linkgroup abnormally */
+/* terminate link group */
 static void __smc_lgr_terminate(struct smc_link_group *lgr)
 {
 	struct smc_connection *conn;
@@ -489,8 +488,6 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr)
 	if (lgr->terminating)
 		return;	/* lgr already terminating */
 	lgr->terminating = 1;
-	if (!list_empty(&lgr->list)) /* forget lgr */
-		list_del_init(&lgr->list);
 	if (!lgr->is_smcd)
 		smc_llc_link_inactive(&lgr->lnk[SMC_SINGLE_LINK]);
 
@@ -516,29 +513,41 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr)
 	smc_lgr_schedule_free_work(lgr);
 }
 
+/* unlink and terminate link group */
 void smc_lgr_terminate(struct smc_link_group *lgr)
 {
 	spinlock_t *lgr_lock;
 
 	smc_lgr_list_head(lgr, &lgr_lock);
 	spin_lock_bh(lgr_lock);
-	__smc_lgr_terminate(lgr);
+	if (lgr->terminating) {
+		spin_unlock_bh(lgr_lock);
+		return;	/* lgr already terminating */
+	}
+	list_del_init(&lgr->list);
 	spin_unlock_bh(lgr_lock);
+	__smc_lgr_terminate(lgr);
 }
 
 /* Called when IB port is terminated */
 void smc_port_terminate(struct smc_ib_device *smcibdev, u8 ibport)
 {
 	struct smc_link_group *lgr, *l;
+	LIST_HEAD(lgr_free_list);
 
 	spin_lock_bh(&smc_lgr_list.lock);
 	list_for_each_entry_safe(lgr, l, &smc_lgr_list.list, list) {
 		if (!lgr->is_smcd &&
 		    lgr->lnk[SMC_SINGLE_LINK].smcibdev == smcibdev &&
 		    lgr->lnk[SMC_SINGLE_LINK].ibport == ibport)
-			__smc_lgr_terminate(lgr);
+			list_move(&lgr->list, &lgr_free_list);
 	}
 	spin_unlock_bh(&smc_lgr_list.lock);
+
+	list_for_each_entry_safe(lgr, l, &lgr_free_list, list) {
+		list_del_init(&lgr->list);
+		__smc_lgr_terminate(lgr);
+	}
 }
 
 /* Called when SMC-D device is terminated or peer is lost */
@@ -552,7 +561,6 @@ void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid, unsigned short vlan)
 	list_for_each_entry_safe(lgr, l, &dev->lgr_list, list) {
 		if ((!peer_gid || lgr->peer_gid == peer_gid) &&
 		    (vlan == VLAN_VID_MASK || lgr->vlan_id == vlan)) {
-			__smc_lgr_terminate(lgr);
 			list_move(&lgr->list, &lgr_free_list);
 		}
 	}
@@ -561,6 +569,7 @@ void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid, unsigned short vlan)
 	/* cancel the regular free workers and actually free lgrs */
 	list_for_each_entry_safe(lgr, l, &lgr_free_list, list) {
 		list_del_init(&lgr->list);
+		__smc_lgr_terminate(lgr);
 		cancel_delayed_work_sync(&lgr->free_work);
 		if (!peer_gid && vlan == VLAN_VID_MASK) /* dev terminated? */
 			smc_ism_signal_shutdown(lgr);
-- 
2.17.1

