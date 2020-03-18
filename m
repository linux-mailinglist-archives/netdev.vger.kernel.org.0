Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C738A189C65
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 13:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgCRMze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 08:55:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42640 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726546AbgCRMzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 08:55:24 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ICma4d131231
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 08:55:23 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yuk25a1rb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 08:55:23 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 18 Mar 2020 12:55:21 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Mar 2020 12:55:19 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02ICtIqY459262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 12:55:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A42CA4054;
        Wed, 18 Mar 2020 12:55:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7761A4064;
        Wed, 18 Mar 2020 12:55:17 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Mar 2020 12:55:17 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 07/11] s390/qeth: add SW timestamping support for IQD devices
Date:   Wed, 18 Mar 2020 13:54:51 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200318125455.5838-1-jwi@linux.ibm.com>
References: <20200318125455.5838-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20031812-0020-0000-0000-000003B67DD6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031812-0021-0000-0000-0000220EE750
Message-Id: <20200318125455.5838-8-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_05:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 phishscore=0 bulkscore=0 clxscore=1015 spamscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180061
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for SOF_TIMESTAMPING_TX_SOFTWARE.
No support for non-IQD devices, since they orphan the skb in their xmit
path.

To play nice with TX bulking, set the timestamp when the buffer that
contains the skb(s) is actually flushed out to HW.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c |  6 +++++-
 drivers/s390/net/qeth_ethtool.c   | 12 ++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index e1d984c29e1f..33796fe80a63 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3355,6 +3355,7 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 
 	for (i = index; i < index + count; ++i) {
 		unsigned int bidx = QDIO_BUFNR(i);
+		struct sk_buff *skb;
 
 		buf = queue->bufs[bidx];
 		buf->buffer->element[buf->next_element_to_fill - 1].eflags |=
@@ -3363,8 +3364,11 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 		if (queue->bufstates)
 			queue->bufstates[bidx].user = buf;
 
-		if (IS_IQD(queue->card))
+		if (IS_IQD(card)) {
+			skb_queue_walk(&buf->skb_list, skb)
+				skb_tx_timestamp(skb);
 			continue;
+		}
 
 		if (!queue->do_pack) {
 			if ((atomic_read(&queue->used_buffers) >=
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index 079b695032ef..5cfa371b7426 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -204,6 +204,17 @@ static int qeth_set_channels(struct net_device *dev,
 	return qeth_set_real_num_tx_queues(card, channels->tx_count);
 }
 
+static int qeth_get_ts_info(struct net_device *dev,
+			    struct ethtool_ts_info *info)
+{
+	struct qeth_card *card = dev->ml_priv;
+
+	if (!IS_IQD(card))
+		return -EOPNOTSUPP;
+
+	return ethtool_op_get_ts_info(dev, info);
+}
+
 static int qeth_get_tunable(struct net_device *dev,
 			    const struct ethtool_tunable *tuna, void *data)
 {
@@ -440,6 +451,7 @@ const struct ethtool_ops qeth_ethtool_ops = {
 	.get_drvinfo = qeth_get_drvinfo,
 	.get_channels = qeth_get_channels,
 	.set_channels = qeth_set_channels,
+	.get_ts_info = qeth_get_ts_info,
 	.get_tunable = qeth_get_tunable,
 	.set_tunable = qeth_set_tunable,
 	.get_link_ksettings = qeth_get_link_ksettings,
-- 
2.17.1

