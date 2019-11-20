Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0130103B49
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730538AbfKTNXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:23:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18844 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727784AbfKTNVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 08:21:08 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAKDIPh8133541
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 08:21:07 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wcf57g440-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 08:21:07 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 20 Nov 2019 13:21:05 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 20 Nov 2019 13:21:02 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAKDL0Bh46465136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 13:21:00 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E69252052;
        Wed, 20 Nov 2019 13:21:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 58CDF5204F;
        Wed, 20 Nov 2019 13:21:00 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 1/2] s390/qeth: fix potential deadlock on workqueue flush
Date:   Wed, 20 Nov 2019 14:20:56 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191120132057.1788-1-jwi@linux.ibm.com>
References: <20191120132057.1788-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19112013-0012-0000-0000-00000369D029
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112013-0013-0000-0000-000021A55FD1
Message-Id: <20191120132057.1788-2-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-20_03:2019-11-15,2019-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 spamscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911200120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The L2 bridgeport code uses the coarse 'conf_mutex' for guarding access
to its configuration state.
This can result in a deadlock when qeth_l2_stop_card() - called under the
conf_mutex - blocks on flush_workqueue() to wait for the completion of
pending bridgeport workers. Such workers would also need to aquire
the conf_mutex, stalling indefinitely.

Introduce a lock that specifically guards the bridgeport configuration,
so that the workers no longer need the conf_mutex.
Wrapping qeth_l2_promisc_to_bridge() in this fine-grained lock then also
fixes a theoretical race against a concurrent qeth_bridge_port_role_store()
operation.

Fixes: c0a2e4d10d93 ("s390/qeth: conclude all event processing before offlining a card")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h    |  1 +
 drivers/s390/net/qeth_l2_main.c | 21 ++++++++++++++-------
 drivers/s390/net/qeth_l2_sys.c  | 14 +++++++++++++-
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index e4b55f9aa062..65e31df37b1f 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -839,6 +839,7 @@ struct qeth_card {
 	struct service_level qeth_service_level;
 	struct qdio_ssqd_desc ssqd;
 	debug_info_t *debug;
+	struct mutex sbp_lock;
 	struct mutex conf_mutex;
 	struct mutex discipline_mutex;
 	struct napi_struct napi;
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index bd8143e51747..4bccdce19b5a 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -467,10 +467,14 @@ static void qeth_l2_set_promisc_mode(struct qeth_card *card)
 	if (card->info.promisc_mode == enable)
 		return;
 
-	if (qeth_adp_supported(card, IPA_SETADP_SET_PROMISC_MODE))
+	if (qeth_adp_supported(card, IPA_SETADP_SET_PROMISC_MODE)) {
 		qeth_setadp_promisc_mode(card, enable);
-	else if (card->options.sbp.reflect_promisc)
-		qeth_l2_promisc_to_bridge(card, enable);
+	} else {
+		mutex_lock(&card->sbp_lock);
+		if (card->options.sbp.reflect_promisc)
+			qeth_l2_promisc_to_bridge(card, enable);
+		mutex_unlock(&card->sbp_lock);
+	}
 }
 
 /* New MAC address is added to the hash table and marked to be written on card
@@ -631,6 +635,7 @@ static int qeth_l2_probe_device(struct ccwgroup_device *gdev)
 	int rc;
 
 	qeth_l2_vnicc_set_defaults(card);
+	mutex_init(&card->sbp_lock);
 
 	if (gdev->dev.type == &qeth_generic_devtype) {
 		rc = qeth_l2_create_device_attributes(&gdev->dev);
@@ -804,10 +809,12 @@ static int qeth_l2_set_online(struct ccwgroup_device *gdev)
 	} else
 		card->info.hwtrap = 0;
 
+	mutex_lock(&card->sbp_lock);
 	qeth_bridgeport_query_support(card);
 	if (card->options.sbp.supported_funcs)
 		dev_info(&card->gdev->dev,
 		"The device represents a Bridge Capable Port\n");
+	mutex_unlock(&card->sbp_lock);
 
 	qeth_l2_register_dev_addr(card);
 
@@ -1162,9 +1169,9 @@ static void qeth_bridge_state_change_worker(struct work_struct *work)
 
 	/* Role should not change by itself, but if it did, */
 	/* information from the hardware is authoritative.  */
-	mutex_lock(&data->card->conf_mutex);
+	mutex_lock(&data->card->sbp_lock);
 	data->card->options.sbp.role = entry->role;
-	mutex_unlock(&data->card->conf_mutex);
+	mutex_unlock(&data->card->sbp_lock);
 
 	snprintf(env_locrem, sizeof(env_locrem), "BRIDGEPORT=statechange");
 	snprintf(env_role, sizeof(env_role), "ROLE=%s",
@@ -1230,9 +1237,9 @@ static void qeth_bridge_host_event_worker(struct work_struct *work)
 			: (data->hostevs.lost_event_mask == 0x02)
 			? "Bridge port state change"
 			: "Unknown reason");
-		mutex_lock(&data->card->conf_mutex);
+		mutex_lock(&data->card->sbp_lock);
 		data->card->options.sbp.hostnotification = 0;
-		mutex_unlock(&data->card->conf_mutex);
+		mutex_unlock(&data->card->sbp_lock);
 		qeth_bridge_emit_host_event(data->card, anev_abort,
 			0, NULL, NULL);
 	} else
diff --git a/drivers/s390/net/qeth_l2_sys.c b/drivers/s390/net/qeth_l2_sys.c
index f2c3b127b1e4..e2bcb26105a3 100644
--- a/drivers/s390/net/qeth_l2_sys.c
+++ b/drivers/s390/net/qeth_l2_sys.c
@@ -24,6 +24,7 @@ static ssize_t qeth_bridge_port_role_state_show(struct device *dev,
 	if (qeth_l2_vnicc_is_in_use(card))
 		return sprintf(buf, "n/a (VNIC characteristics)\n");
 
+	mutex_lock(&card->sbp_lock);
 	if (qeth_card_hw_is_reachable(card) &&
 					card->options.sbp.supported_funcs)
 		rc = qeth_bridgeport_query_ports(card,
@@ -57,6 +58,7 @@ static ssize_t qeth_bridge_port_role_state_show(struct device *dev,
 		else
 			rc = sprintf(buf, "%s\n", word);
 	}
+	mutex_unlock(&card->sbp_lock);
 
 	return rc;
 }
@@ -91,6 +93,7 @@ static ssize_t qeth_bridge_port_role_store(struct device *dev,
 		return -EINVAL;
 
 	mutex_lock(&card->conf_mutex);
+	mutex_lock(&card->sbp_lock);
 
 	if (qeth_l2_vnicc_is_in_use(card))
 		rc = -EBUSY;
@@ -104,6 +107,7 @@ static ssize_t qeth_bridge_port_role_store(struct device *dev,
 	} else
 		card->options.sbp.role = role;
 
+	mutex_unlock(&card->sbp_lock);
 	mutex_unlock(&card->conf_mutex);
 
 	return rc ? rc : count;
@@ -158,6 +162,7 @@ static ssize_t qeth_bridgeport_hostnotification_store(struct device *dev,
 		return rc;
 
 	mutex_lock(&card->conf_mutex);
+	mutex_lock(&card->sbp_lock);
 
 	if (qeth_l2_vnicc_is_in_use(card))
 		rc = -EBUSY;
@@ -168,6 +173,7 @@ static ssize_t qeth_bridgeport_hostnotification_store(struct device *dev,
 	} else
 		card->options.sbp.hostnotification = enable;
 
+	mutex_unlock(&card->sbp_lock);
 	mutex_unlock(&card->conf_mutex);
 
 	return rc ? rc : count;
@@ -223,6 +229,7 @@ static ssize_t qeth_bridgeport_reflect_store(struct device *dev,
 		return -EINVAL;
 
 	mutex_lock(&card->conf_mutex);
+	mutex_lock(&card->sbp_lock);
 
 	if (qeth_l2_vnicc_is_in_use(card))
 		rc = -EBUSY;
@@ -234,6 +241,7 @@ static ssize_t qeth_bridgeport_reflect_store(struct device *dev,
 		rc = 0;
 	}
 
+	mutex_unlock(&card->sbp_lock);
 	mutex_unlock(&card->conf_mutex);
 
 	return rc ? rc : count;
@@ -269,6 +277,8 @@ void qeth_l2_setup_bridgeport_attrs(struct qeth_card *card)
 		return;
 	if (!card->options.sbp.supported_funcs)
 		return;
+
+	mutex_lock(&card->sbp_lock);
 	if (card->options.sbp.role != QETH_SBP_ROLE_NONE) {
 		/* Conditional to avoid spurious error messages */
 		qeth_bridgeport_setrole(card, card->options.sbp.role);
@@ -280,8 +290,10 @@ void qeth_l2_setup_bridgeport_attrs(struct qeth_card *card)
 		rc = qeth_bridgeport_an_set(card, 1);
 		if (rc)
 			card->options.sbp.hostnotification = 0;
-	} else
+	} else {
 		qeth_bridgeport_an_set(card, 0);
+	}
+	mutex_unlock(&card->sbp_lock);
 }
 
 /* VNIC CHARS support */
-- 
2.17.1

