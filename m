Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFCE189C6A
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 13:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgCRMzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 08:55:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26902 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726851AbgCRMzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 08:55:23 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ICWogI102755
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 08:55:22 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yu719t238-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 08:55:22 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 18 Mar 2020 12:55:20 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Mar 2020 12:55:18 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02ICtGbv40435986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 12:55:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5208A405B;
        Wed, 18 Mar 2020 12:55:16 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D856A405C;
        Wed, 18 Mar 2020 12:55:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Mar 2020 12:55:16 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 02/11] s390/qeth: use memory reserves in TX slow path
Date:   Wed, 18 Mar 2020 13:54:46 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200318125455.5838-1-jwi@linux.ibm.com>
References: <20200318125455.5838-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20031812-0008-0000-0000-0000035F5792
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031812-0009-0000-0000-00004A80B1EC
Message-Id: <20200318125455.5838-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_05:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180059
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When falling back to an allocation from the HW header cache, check if
the skb is eligible for using memory reserves.
This only makes a difference if the cache is empty and needs to be
refilled.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 6 ++++--
 drivers/s390/net/qeth_l2_main.c   | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index be3f6295309b..767cef04c9d8 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3705,6 +3705,7 @@ static int qeth_add_hw_header(struct qeth_qdio_out_q *queue,
 			      unsigned int hdr_len, unsigned int proto_len,
 			      unsigned int *elements)
 {
+	gfp_t gfp = GFP_ATOMIC | (skb_pfmemalloc(skb) ? __GFP_MEMALLOC : 0);
 	const unsigned int contiguous = proto_len ? proto_len : 1;
 	const unsigned int max_elements = queue->max_elements;
 	unsigned int __elements;
@@ -3760,10 +3761,11 @@ static int qeth_add_hw_header(struct qeth_qdio_out_q *queue,
 		*hdr = skb_push(skb, hdr_len);
 		return hdr_len;
 	}
-	/* fall back */
+
+	/* Fall back to cache element with known-good alignment: */
 	if (hdr_len + proto_len > QETH_HDR_CACHE_OBJ_SIZE)
 		return -E2BIG;
-	*hdr = kmem_cache_alloc(qeth_core_header_cache, GFP_ATOMIC);
+	*hdr = kmem_cache_alloc(qeth_core_header_cache, gfp);
 	if (!*hdr)
 		return -ENOMEM;
 	/* Copy protocol headers behind HW header: */
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 4c8e93132e08..8ba4ac2a5b47 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -499,6 +499,7 @@ static void qeth_l2_rx_mode_work(struct work_struct *work)
 static int qeth_l2_xmit_osn(struct qeth_card *card, struct sk_buff *skb,
 			    struct qeth_qdio_out_q *queue)
 {
+	gfp_t gfp = GFP_ATOMIC | (skb_pfmemalloc(skb) ? __GFP_MEMALLOC : 0);
 	struct qeth_hdr *hdr = (struct qeth_hdr *)skb->data;
 	addr_t end = (addr_t)(skb->data + sizeof(*hdr));
 	addr_t start = (addr_t)skb->data;
@@ -511,7 +512,7 @@ static int qeth_l2_xmit_osn(struct qeth_card *card, struct sk_buff *skb,
 
 	if (qeth_get_elements_for_range(start, end) > 1) {
 		/* Misaligned HW header, move it to its own buffer element. */
-		hdr = kmem_cache_alloc(qeth_core_header_cache, GFP_ATOMIC);
+		hdr = kmem_cache_alloc(qeth_core_header_cache, gfp);
 		if (!hdr)
 			return -ENOMEM;
 		hd_len = sizeof(*hdr);
-- 
2.17.1

