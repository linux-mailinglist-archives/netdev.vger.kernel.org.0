Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B5058508
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfF0PBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:01:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14786 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726370AbfF0PBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:01:42 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5REwH53046099
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:01:41 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tcy7xb08h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:01:40 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 27 Jun 2019 16:01:39 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Jun 2019 16:01:37 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RF1PnU17957364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 15:01:25 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FAF0A4065;
        Thu, 27 Jun 2019 15:01:35 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38CA2A405F;
        Thu, 27 Jun 2019 15:01:35 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jun 2019 15:01:35 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 01/12] s390/qeth: dynamically allocate simple IPA cmds
Date:   Thu, 27 Jun 2019 17:01:22 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627150133.58746-1-jwi@linux.ibm.com>
References: <20190627150133.58746-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19062715-0020-0000-0000-0000034E1314
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062715-0021-0000-0000-000021A18EC9
Message-Id: <20190627150133.58746-2-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270175
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch reduces the usage of the write channel's static cmd buffers,
by dynamically allocating all simple IPA cmds (eg. STARTLAN, SETVMAC).
It also converts the OSN path.

Doing so requires some changes to how we calculate the cmd length.
Currently when building IPA cmds, we're quite generous in how much data
we send down to the device (basically the size of the biggest cmd we
know). This is no real concern at the moment, since the static cmd
buffers are backed with zeroed pages. But for dynamic allocations, the
exact length matters. So this patch also adds the needed length
calculations to each cmd path.

Commands that have multiple subtypes (eg. SETADP) of differing length
will be converted with follow-up patches.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 10 +++++++++-
 drivers/s390/net/qeth_core_main.c | 33 ++++++++++++++++++++++++-------
 drivers/s390/net/qeth_core_mpc.h  |  2 ++
 drivers/s390/net/qeth_l2_main.c   | 12 ++++++++---
 drivers/s390/net/qeth_l3_main.c   | 17 +++++++++-------
 5 files changed, 56 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 5bcdede5e955..42aa4a21a4c2 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -551,6 +551,7 @@ enum qeth_card_states {
  * Protocol versions
  */
 enum qeth_prot_versions {
+	QETH_PROT_NONE = 0x0000,
 	QETH_PROT_IPV4 = 0x0004,
 	QETH_PROT_IPV6 = 0x0006,
 };
@@ -995,6 +996,14 @@ int qeth_send_ipa_cmd(struct qeth_card *, struct qeth_cmd_buffer *,
 		  void *);
 struct qeth_cmd_buffer *qeth_get_ipacmd_buffer(struct qeth_card *,
 			enum qeth_ipa_cmds, enum qeth_prot_versions);
+struct qeth_cmd_buffer *qeth_ipa_alloc_cmd(struct qeth_card *card,
+					   enum qeth_ipa_cmds cmd_code,
+					   enum qeth_prot_versions prot,
+					   unsigned int data_length);
+struct qeth_cmd_buffer *qeth_alloc_cmd(struct qeth_channel *channel,
+				       unsigned int length, unsigned int ccws,
+				       long timeout);
+
 struct sk_buff *qeth_core_get_next_skb(struct qeth_card *,
 		struct qeth_qdio_buffer *, struct qdio_buffer_element **, int *,
 		struct qeth_hdr **);
@@ -1012,7 +1021,6 @@ void qeth_release_buffer(struct qeth_cmd_buffer *iob);
 void qeth_notify_reply(struct qeth_reply *reply, int reason);
 void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 			  u16 cmd_length);
-struct qeth_cmd_buffer *qeth_get_buffer(struct qeth_channel *channel);
 int qeth_query_switch_attributes(struct qeth_card *card,
 				  struct qeth_switch_info *sw_info);
 int qeth_query_card_info(struct qeth_card *card,
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index fe3dfeaf5ceb..84ed772bbfbd 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -756,7 +756,7 @@ static void qeth_cancel_cmd(struct qeth_cmd_buffer *iob, int rc)
 	qeth_release_buffer(iob);
 }
 
-struct qeth_cmd_buffer *qeth_get_buffer(struct qeth_channel *channel)
+static struct qeth_cmd_buffer *qeth_get_buffer(struct qeth_channel *channel)
 {
 	struct qeth_cmd_buffer *buffer = NULL;
 	unsigned long flags;
@@ -766,11 +766,10 @@ struct qeth_cmd_buffer *qeth_get_buffer(struct qeth_channel *channel)
 	spin_unlock_irqrestore(&channel->iob_lock, flags);
 	return buffer;
 }
-EXPORT_SYMBOL_GPL(qeth_get_buffer);
 
-static struct qeth_cmd_buffer *qeth_alloc_cmd(struct qeth_channel *channel,
-					      unsigned int length,
-					      unsigned int ccws, long timeout)
+struct qeth_cmd_buffer *qeth_alloc_cmd(struct qeth_channel *channel,
+				       unsigned int length, unsigned int ccws,
+				       long timeout)
 {
 	struct qeth_cmd_buffer *iob;
 
@@ -795,6 +794,7 @@ static struct qeth_cmd_buffer *qeth_alloc_cmd(struct qeth_channel *channel,
 	iob->length = length;
 	return iob;
 }
+EXPORT_SYMBOL_GPL(qeth_alloc_cmd);
 
 void qeth_clear_cmd_buffers(struct qeth_channel *channel)
 {
@@ -2804,6 +2804,25 @@ struct qeth_cmd_buffer *qeth_get_ipacmd_buffer(struct qeth_card *card,
 }
 EXPORT_SYMBOL_GPL(qeth_get_ipacmd_buffer);
 
+struct qeth_cmd_buffer *qeth_ipa_alloc_cmd(struct qeth_card *card,
+					   enum qeth_ipa_cmds cmd_code,
+					   enum qeth_prot_versions prot,
+					   unsigned int data_length)
+{
+	struct qeth_cmd_buffer *iob;
+
+	data_length += offsetof(struct qeth_ipa_cmd, data);
+	iob = qeth_alloc_cmd(&card->write, IPA_PDU_HEADER_SIZE + data_length, 1,
+			     QETH_IPA_TIMEOUT);
+	if (!iob)
+		return NULL;
+
+	qeth_prepare_ipa_cmd(card, iob, data_length);
+	qeth_fill_ipacmd_header(card, __ipa_cmd(iob), cmd_code, prot);
+	return iob;
+}
+EXPORT_SYMBOL_GPL(qeth_ipa_alloc_cmd);
+
 static int qeth_send_ipa_cmd_cb(struct qeth_card *card,
 				struct qeth_reply *reply, unsigned long data)
 {
@@ -2862,7 +2881,7 @@ static int qeth_send_startlan(struct qeth_card *card)
 
 	QETH_CARD_TEXT(card, 2, "strtlan");
 
-	iob = qeth_get_ipacmd_buffer(card, IPA_CMD_STARTLAN, 0);
+	iob = qeth_ipa_alloc_cmd(card, IPA_CMD_STARTLAN, QETH_PROT_NONE, 0);
 	if (!iob)
 		return -ENOMEM;
 	return qeth_send_ipa_cmd(card, iob, qeth_send_startlan_cb, NULL);
@@ -2971,7 +2990,7 @@ static int qeth_query_ipassists(struct qeth_card *card,
 	struct qeth_cmd_buffer *iob;
 
 	QETH_CARD_TEXT_(card, 2, "qipassi%i", prot);
-	iob = qeth_get_ipacmd_buffer(card, IPA_CMD_QIPASSIST, prot);
+	iob = qeth_ipa_alloc_cmd(card, IPA_CMD_QIPASSIST, prot, 0);
 	if (!iob)
 		return -ENOMEM;
 	rc = qeth_send_ipa_cmd(card, iob, qeth_query_ipassists_cb, NULL);
diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index fadafdc0e8e4..e84249f8803e 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -806,6 +806,8 @@ struct qeth_ipa_cmd {
 	} data;
 } __attribute__ ((packed));
 
+#define IPA_DATA_SIZEOF(field)	FIELD_SIZEOF(struct qeth_ipa_cmd, data.field)
+
 /*
  * special command for ARP processing.
  * this is not included in setassparms command before, because we get
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 9565ef9747c1..1dd8d22299c2 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -85,7 +85,8 @@ static int qeth_l2_send_setdelmac(struct qeth_card *card, __u8 *mac,
 	struct qeth_cmd_buffer *iob;
 
 	QETH_CARD_TEXT(card, 2, "L2sdmac");
-	iob = qeth_get_ipacmd_buffer(card, ipacmd, QETH_PROT_IPV4);
+	iob = qeth_ipa_alloc_cmd(card, ipacmd, QETH_PROT_IPV4,
+				 IPA_DATA_SIZEOF(setdelmac));
 	if (!iob)
 		return -ENOMEM;
 	cmd = __ipa_cmd(iob);
@@ -240,7 +241,8 @@ static int qeth_l2_send_setdelvlan(struct qeth_card *card, __u16 i,
 	struct qeth_cmd_buffer *iob;
 
 	QETH_CARD_TEXT_(card, 4, "L2sdv%x", ipacmd);
-	iob = qeth_get_ipacmd_buffer(card, ipacmd, QETH_PROT_IPV4);
+	iob = qeth_ipa_alloc_cmd(card, ipacmd, QETH_PROT_IPV4,
+				 IPA_DATA_SIZEOF(setdelvlan));
 	if (!iob)
 		return -ENOMEM;
 	cmd = __ipa_cmd(iob);
@@ -1040,6 +1042,8 @@ int qeth_osn_assist(struct net_device *dev, void *data, int data_len)
 	struct qeth_cmd_buffer *iob;
 	struct qeth_card *card;
 
+	if (data_len < 0)
+		return -EINVAL;
 	if (!dev)
 		return -ENODEV;
 	card = dev->ml_priv;
@@ -1048,7 +1052,9 @@ int qeth_osn_assist(struct net_device *dev, void *data, int data_len)
 	QETH_CARD_TEXT(card, 2, "osnsdmc");
 	if (!qeth_card_hw_is_reachable(card))
 		return -ENODEV;
-	iob = qeth_get_buffer(&card->write);
+
+	iob = qeth_alloc_cmd(&card->write, IPA_PDU_HEADER_SIZE + data_len, 1,
+			     QETH_IPA_TIMEOUT);
 	if (!iob)
 		return -ENOMEM;
 
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 4d66f9556451..81312be8a36b 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -377,7 +377,8 @@ static int qeth_l3_send_setdelmc(struct qeth_card *card,
 
 	QETH_CARD_TEXT(card, 4, "setdelmc");
 
-	iob = qeth_get_ipacmd_buffer(card, ipacmd, addr->proto);
+	iob = qeth_ipa_alloc_cmd(card, ipacmd, addr->proto,
+				 IPA_DATA_SIZEOF(setdelipm));
 	if (!iob)
 		return -ENOMEM;
 	cmd = __ipa_cmd(iob);
@@ -429,7 +430,8 @@ static int qeth_l3_send_setdelip(struct qeth_card *card,
 
 	QETH_CARD_TEXT(card, 4, "setdelip");
 
-	iob = qeth_get_ipacmd_buffer(card, ipacmd, addr->proto);
+	iob = qeth_ipa_alloc_cmd(card, ipacmd, addr->proto,
+				 IPA_DATA_SIZEOF(setdelip6));
 	if (!iob)
 		return -ENOMEM;
 	cmd = __ipa_cmd(iob);
@@ -461,7 +463,8 @@ static int qeth_l3_send_setrouting(struct qeth_card *card,
 	struct qeth_cmd_buffer *iob;
 
 	QETH_CARD_TEXT(card, 4, "setroutg");
-	iob = qeth_get_ipacmd_buffer(card, IPA_CMD_SETRTG, prot);
+	iob = qeth_ipa_alloc_cmd(card, IPA_CMD_SETRTG, prot,
+				 IPA_DATA_SIZEOF(setrtg));
 	if (!iob)
 		return -ENOMEM;
 	cmd = __ipa_cmd(iob);
@@ -981,8 +984,8 @@ static int qeth_l3_iqd_read_initial_mac(struct qeth_card *card)
 
 	QETH_CARD_TEXT(card, 2, "hsrmac");
 
-	iob = qeth_get_ipacmd_buffer(card, IPA_CMD_CREATE_ADDR,
-				     QETH_PROT_IPV6);
+	iob = qeth_ipa_alloc_cmd(card, IPA_CMD_CREATE_ADDR, QETH_PROT_IPV6,
+				 IPA_DATA_SIZEOF(create_destroy_addr));
 	if (!iob)
 		return -ENOMEM;
 	cmd = __ipa_cmd(iob);
@@ -1025,8 +1028,8 @@ static int qeth_l3_get_unique_id(struct qeth_card *card)
 		return 0;
 	}
 
-	iob = qeth_get_ipacmd_buffer(card, IPA_CMD_CREATE_ADDR,
-				     QETH_PROT_IPV6);
+	iob = qeth_ipa_alloc_cmd(card, IPA_CMD_CREATE_ADDR, QETH_PROT_IPV6,
+				 IPA_DATA_SIZEOF(create_destroy_addr));
 	if (!iob)
 		return -ENOMEM;
 	cmd = __ipa_cmd(iob);
-- 
2.17.1

