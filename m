Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2A821F3DF
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgGNOX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:23:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13102 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728721AbgGNOXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:23:25 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06EE262F099304;
        Tue, 14 Jul 2020 10:23:19 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 329dhw20nu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 10:23:18 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06EEF3Zk031336;
        Tue, 14 Jul 2020 14:23:17 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 327q2y1c5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 14:23:17 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06EENEdc55574762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 14:23:14 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F6AA4C059;
        Tue, 14 Jul 2020 14:23:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBA854C040;
        Tue, 14 Jul 2020 14:23:13 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jul 2020 14:23:13 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 05/10] s390/qeth: clean up error handling for isolation mode cmds
Date:   Tue, 14 Jul 2020 16:23:00 +0200
Message-Id: <20200714142305.29297-6-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200714142305.29297-1-jwi@linux.ibm.com>
References: <20200714142305.29297-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_04:2020-07-14,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the cmd IO path has learned to propagate errnos back to its callers,
let them deal with errors instead of trying to restore their previous
configuration from within the IO error path.

Also translate the HW error to a meaningful errno, instead of returning
-EIO for all cases (and don't map this to -EOPNOTSUPP later on...).

While at it, add a READ_ONCE() / WRITE_ONCE() pair to ensure that the
data path always sees a valid isolation mode during reconfiguration.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  5 +-
 drivers/s390/net/qeth_core_main.c | 85 ++++++++++---------------------
 drivers/s390/net/qeth_core_sys.c  | 20 ++++----
 3 files changed, 40 insertions(+), 70 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 51ea56b73a97..c77a87105ea8 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -721,7 +721,6 @@ struct qeth_card_options {
 	struct qeth_vnicc_info vnicc; /* VNICC options */
 	enum qeth_discipline_id layer;
 	enum qeth_ipa_isolation_modes isolation;
-	enum qeth_ipa_isolation_modes prev_isolation;
 	int sniffer;
 	enum qeth_cq cq;
 	char hsuid[9];
@@ -1071,6 +1070,9 @@ int qeth_query_switch_attributes(struct qeth_card *card,
 				  struct qeth_switch_info *sw_info);
 int qeth_query_card_info(struct qeth_card *card,
 			 struct carrier_info *carrier_info);
+int qeth_setadpparms_set_access_ctrl(struct qeth_card *card,
+				     enum qeth_ipa_isolation_modes mode);
+
 unsigned int qeth_count_elements(struct sk_buff *skb, unsigned int data_offset);
 int qeth_do_send_packet(struct qeth_card *card, struct qeth_qdio_out_q *queue,
 			struct sk_buff *skb, struct qeth_hdr *hdr,
@@ -1078,7 +1080,6 @@ int qeth_do_send_packet(struct qeth_card *card, struct qeth_qdio_out_q *queue,
 			int elements_needed);
 int qeth_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 void qeth_dbf_longtext(debug_info_t *id, int level, char *text, ...);
-int qeth_set_access_ctrl_online(struct qeth_card *card, int fallback);
 int qeth_configure_cq(struct qeth_card *, enum qeth_cq);
 int qeth_hw_trap(struct qeth_card *, enum qeth_diags_trap_action);
 void qeth_trace_features(struct qeth_card *);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 782a5128ac04..bd6489d87ede 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4557,7 +4557,6 @@ static int qeth_setadpparms_set_access_ctrl_cb(struct qeth_card *card,
 {
 	struct qeth_ipa_cmd *cmd = (struct qeth_ipa_cmd *) data;
 	struct qeth_set_access_ctrl *access_ctrl_req;
-	int fallback = *(int *)reply->param;
 
 	QETH_CARD_TEXT(card, 4, "setaccb");
 
@@ -4571,70 +4570,54 @@ static int qeth_setadpparms_set_access_ctrl_cb(struct qeth_card *card,
 				 cmd->data.setadapterparms.hdr.return_code);
 	switch (qeth_setadpparms_inspect_rc(cmd)) {
 	case SET_ACCESS_CTRL_RC_SUCCESS:
-		if (card->options.isolation == ISOLATION_MODE_NONE) {
+		if (access_ctrl_req->subcmd_code == ISOLATION_MODE_NONE)
 			dev_info(&card->gdev->dev,
 			    "QDIO data connection isolation is deactivated\n");
-		} else {
+		else
 			dev_info(&card->gdev->dev,
 			    "QDIO data connection isolation is activated\n");
-		}
-		break;
+		return 0;
 	case SET_ACCESS_CTRL_RC_ALREADY_NOT_ISOLATED:
 		QETH_DBF_MESSAGE(2, "QDIO data connection isolation on device %x already deactivated\n",
 				 CARD_DEVID(card));
-		if (fallback)
-			card->options.isolation = card->options.prev_isolation;
-		break;
+		return 0;
 	case SET_ACCESS_CTRL_RC_ALREADY_ISOLATED:
 		QETH_DBF_MESSAGE(2, "QDIO data connection isolation on device %x already activated\n",
 				 CARD_DEVID(card));
-		if (fallback)
-			card->options.isolation = card->options.prev_isolation;
-		break;
+		return 0;
 	case SET_ACCESS_CTRL_RC_NOT_SUPPORTED:
 		dev_err(&card->gdev->dev, "Adapter does not "
 			"support QDIO data connection isolation\n");
-		break;
+		return -EOPNOTSUPP;
 	case SET_ACCESS_CTRL_RC_NONE_SHARED_ADAPTER:
 		dev_err(&card->gdev->dev,
 			"Adapter is dedicated. "
 			"QDIO data connection isolation not supported\n");
-		if (fallback)
-			card->options.isolation = card->options.prev_isolation;
-		break;
+		return -EOPNOTSUPP;
 	case SET_ACCESS_CTRL_RC_ACTIVE_CHECKSUM_OFF:
 		dev_err(&card->gdev->dev,
 			"TSO does not permit QDIO data connection isolation\n");
-		if (fallback)
-			card->options.isolation = card->options.prev_isolation;
-		break;
+		return -EPERM;
 	case SET_ACCESS_CTRL_RC_REFLREL_UNSUPPORTED:
 		dev_err(&card->gdev->dev, "The adjacent switch port does not "
 			"support reflective relay mode\n");
-		if (fallback)
-			card->options.isolation = card->options.prev_isolation;
-		break;
+		return -EOPNOTSUPP;
 	case SET_ACCESS_CTRL_RC_REFLREL_FAILED:
 		dev_err(&card->gdev->dev, "The reflective relay mode cannot be "
 					"enabled at the adjacent switch port");
-		if (fallback)
-			card->options.isolation = card->options.prev_isolation;
-		break;
+		return -EREMOTEIO;
 	case SET_ACCESS_CTRL_RC_REFLREL_DEACT_FAILED:
 		dev_warn(&card->gdev->dev, "Turning off reflective relay mode "
 					"at the adjacent switch failed\n");
-		break;
+		/* benign error while disabling ISOLATION_MODE_FWD */
+		return 0;
 	default:
-		/* this should never happen */
-		if (fallback)
-			card->options.isolation = card->options.prev_isolation;
-		break;
+		return -EIO;
 	}
-	return (cmd->hdr.return_code) ? -EIO : 0;
 }
 
-static int qeth_setadpparms_set_access_ctrl(struct qeth_card *card,
-		enum qeth_ipa_isolation_modes isolation, int fallback)
+int qeth_setadpparms_set_access_ctrl(struct qeth_card *card,
+				     enum qeth_ipa_isolation_modes mode)
 {
 	int rc;
 	struct qeth_cmd_buffer *iob;
@@ -4643,41 +4626,28 @@ static int qeth_setadpparms_set_access_ctrl(struct qeth_card *card,
 
 	QETH_CARD_TEXT(card, 4, "setacctl");
 
+	if (!qeth_adp_supported(card, IPA_SETADP_SET_ACCESS_CONTROL)) {
+		dev_err(&card->gdev->dev,
+			"Adapter does not support QDIO data connection isolation\n");
+		return -EOPNOTSUPP;
+	}
+
 	iob = qeth_get_adapter_cmd(card, IPA_SETADP_SET_ACCESS_CONTROL,
 				   SETADP_DATA_SIZEOF(set_access_ctrl));
 	if (!iob)
 		return -ENOMEM;
 	cmd = __ipa_cmd(iob);
 	access_ctrl_req = &cmd->data.setadapterparms.data.set_access_ctrl;
-	access_ctrl_req->subcmd_code = isolation;
+	access_ctrl_req->subcmd_code = mode;
 
 	rc = qeth_send_ipa_cmd(card, iob, qeth_setadpparms_set_access_ctrl_cb,
-			       &fallback);
-	QETH_CARD_TEXT_(card, 2, "rc=%d", rc);
-	return rc;
-}
-
-int qeth_set_access_ctrl_online(struct qeth_card *card, int fallback)
-{
-	int rc = 0;
-
-	QETH_CARD_TEXT(card, 4, "setactlo");
-
-	if (!qeth_adp_supported(card, IPA_SETADP_SET_ACCESS_CONTROL)) {
-		dev_err(&card->gdev->dev, "Adapter does not "
-			"support QDIO data connection isolation\n");
-		if (fallback)
-			card->options.isolation = card->options.prev_isolation;
-		return -EOPNOTSUPP;
-	}
-
-	rc = qeth_setadpparms_set_access_ctrl(card, card->options.isolation,
-					      fallback);
+			       NULL);
 	if (rc) {
+		QETH_CARD_TEXT_(card, 2, "rc=%d", rc);
 		QETH_DBF_MESSAGE(3, "IPA(SET_ACCESS_CTRL(%d) on device %x: sent failed\n",
 				 rc, CARD_DEVID(card));
-		rc = -EOPNOTSUPP;
 	}
+
 	return rc;
 }
 
@@ -5347,7 +5317,8 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 		card->info.hwtrap = 0;
 
 	if (card->options.isolation != ISOLATION_MODE_NONE) {
-		rc = qeth_set_access_ctrl_online(card, 0);
+		rc = qeth_setadpparms_set_access_ctrl(card,
+						      card->options.isolation);
 		if (rc)
 			goto out;
 	}
@@ -6858,7 +6829,7 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 
 	/* Traffic with local next-hop is not eligible for some offloads: */
 	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    card->options.isolation != ISOLATION_MODE_FWD) {
+	    READ_ONCE(card->options.isolation) != ISOLATION_MODE_FWD) {
 		netdev_features_t restricted = 0;
 
 		if (skb_is_gso(skb) && !netif_needs_gso(skb, features))
diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
index c901c942fed7..8def82336f53 100644
--- a/drivers/s390/net/qeth_core_sys.c
+++ b/drivers/s390/net/qeth_core_sys.c
@@ -448,19 +448,17 @@ static ssize_t qeth_dev_isolation_store(struct device *dev,
 		rc = -EINVAL;
 		goto out;
 	}
-	rc = count;
-
-	/* defer IP assist if device is offline (until discipline->set_online)*/
-	card->options.prev_isolation = card->options.isolation;
-	card->options.isolation = isolation;
-	if (qeth_card_hw_is_reachable(card)) {
-		int ipa_rc = qeth_set_access_ctrl_online(card, 1);
-		if (ipa_rc != 0)
-			rc = ipa_rc;
-	}
+
+	if (qeth_card_hw_is_reachable(card))
+		rc = qeth_setadpparms_set_access_ctrl(card, isolation);
+
+	if (!rc)
+		WRITE_ONCE(card->options.isolation, isolation);
+
 out:
 	mutex_unlock(&card->conf_mutex);
-	return rc;
+
+	return rc ? rc : count;
 }
 
 static DEVICE_ATTR(isolation, 0644, qeth_dev_isolation_show,
-- 
2.17.1

