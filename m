Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4C81C6AFF
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgEFIKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:10:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5966 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728704AbgEFIKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:10:00 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046825xK160218;
        Wed, 6 May 2020 04:09:57 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4v8y8ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 04:09:56 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04686EuW019043;
        Wed, 6 May 2020 08:09:55 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5rpek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 08:09:55 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04689q7m55443582
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 May 2020 08:09:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25DB0A4054;
        Wed,  6 May 2020 08:09:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8A29A405F;
        Wed,  6 May 2020 08:09:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 May 2020 08:09:51 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH v2 net-next 01/10] s390/qeth: keep track of LP2LP capability for csum offload
Date:   Wed,  6 May 2020 10:09:40 +0200
Message-Id: <20200506080949.3915-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506080949.3915-1-jwi@linux.ibm.com>
References: <20200506080949.3915-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_02:2020-05-04,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxscore=0 mlxlogscore=759
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060058
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When enabling TX CSO, make a note of whether the device has support for
LP2LP offloading. This will become relevant in subsequent patches.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  3 +++
 drivers/s390/net/qeth_core_main.c | 23 ++++++++++++++---------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index e0b26310ecab..2ac7771394d8 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -688,6 +688,9 @@ struct qeth_card_info {
 	u8 promisc_mode:1;
 	u8 use_v1_blkt:1;
 	u8 is_vm_nic:1;
+	/* no bitfield, we take a pointer on these two: */
+	u8 has_lp2lp_cso_v6;
+	u8 has_lp2lp_cso_v4;
 	enum qeth_card_types type;
 	enum qeth_link_types link_type;
 	int broadcast_capable;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index f7689461c242..ef96890eea5c 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6300,7 +6300,7 @@ static int qeth_set_csum_off(struct qeth_card *card, enum qeth_ipa_funcs cstype,
 }
 
 static int qeth_set_csum_on(struct qeth_card *card, enum qeth_ipa_funcs cstype,
-			    enum qeth_prot_versions prot)
+			    enum qeth_prot_versions prot, u8 *lp2lp)
 {
 	u32 required_features = QETH_IPA_CHECKSUM_UDP | QETH_IPA_CHECKSUM_TCP;
 	struct qeth_cmd_buffer *iob;
@@ -6352,8 +6352,11 @@ static int qeth_set_csum_on(struct qeth_card *card, enum qeth_ipa_funcs cstype,
 
 	dev_info(&card->gdev->dev, "HW Checksumming (%sbound IPv%d) enabled\n",
 		 cstype == IPA_INBOUND_CHECKSUM ? "in" : "out", prot);
-	if (!qeth_ipa_caps_enabled(&caps, QETH_IPA_CHECKSUM_LP2LP) &&
-	    cstype == IPA_OUTBOUND_CHECKSUM)
+
+	if (lp2lp)
+		*lp2lp = qeth_ipa_caps_enabled(&caps, QETH_IPA_CHECKSUM_LP2LP);
+
+	if (lp2lp && !*lp2lp)
 		dev_warn(&card->gdev->dev,
 			 "Hardware checksumming is performed only if %s and its peer use different OSA Express 3 ports\n",
 			 QETH_CARD_IFNAME(card));
@@ -6361,9 +6364,9 @@ static int qeth_set_csum_on(struct qeth_card *card, enum qeth_ipa_funcs cstype,
 }
 
 static int qeth_set_ipa_csum(struct qeth_card *card, bool on, int cstype,
-			     enum qeth_prot_versions prot)
+			     enum qeth_prot_versions prot, u8 *lp2lp)
 {
-	return on ? qeth_set_csum_on(card, cstype, prot) :
+	return on ? qeth_set_csum_on(card, cstype, prot, lp2lp) :
 		    qeth_set_csum_off(card, cstype, prot);
 }
 
@@ -6451,13 +6454,13 @@ static int qeth_set_ipa_rx_csum(struct qeth_card *card, bool on)
 
 	if (qeth_is_supported(card, IPA_INBOUND_CHECKSUM))
 		rc_ipv4 = qeth_set_ipa_csum(card, on, IPA_INBOUND_CHECKSUM,
-					    QETH_PROT_IPV4);
+					    QETH_PROT_IPV4, NULL);
 	if (!qeth_is_supported6(card, IPA_INBOUND_CHECKSUM_V6))
 		/* no/one Offload Assist available, so the rc is trivial */
 		return rc_ipv4;
 
 	rc_ipv6 = qeth_set_ipa_csum(card, on, IPA_INBOUND_CHECKSUM,
-				    QETH_PROT_IPV6);
+				    QETH_PROT_IPV6, NULL);
 
 	if (on)
 		/* enable: success if any Assist is active */
@@ -6504,13 +6507,15 @@ int qeth_set_features(struct net_device *dev, netdev_features_t features)
 
 	if ((changed & NETIF_F_IP_CSUM)) {
 		rc = qeth_set_ipa_csum(card, features & NETIF_F_IP_CSUM,
-				       IPA_OUTBOUND_CHECKSUM, QETH_PROT_IPV4);
+				       IPA_OUTBOUND_CHECKSUM, QETH_PROT_IPV4,
+				       &card->info.has_lp2lp_cso_v4);
 		if (rc)
 			changed ^= NETIF_F_IP_CSUM;
 	}
 	if (changed & NETIF_F_IPV6_CSUM) {
 		rc = qeth_set_ipa_csum(card, features & NETIF_F_IPV6_CSUM,
-				       IPA_OUTBOUND_CHECKSUM, QETH_PROT_IPV6);
+				       IPA_OUTBOUND_CHECKSUM, QETH_PROT_IPV6,
+				       &card->info.has_lp2lp_cso_v6);
 		if (rc)
 			changed ^= NETIF_F_IPV6_CSUM;
 	}
-- 
2.17.1

