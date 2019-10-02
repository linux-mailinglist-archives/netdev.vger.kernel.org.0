Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975DFC8FE8
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 19:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbfJBR3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 13:29:16 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:53460 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727624AbfJBR3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 13:29:16 -0400
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x92HMYBr010027;
        Wed, 2 Oct 2019 18:29:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=jan2016.eng;
 bh=XusIg4NDWfE6MmSrDnoOz+YWzXcAC55Ij9PJFz34rK8=;
 b=HHr1noWimibhgQEkrPrWepMsOmejULN5hs+r12cMYh3PZVt3vk6b/1ha4jedYQsI6Gyy
 D/WxZMrEwGVyhJybrK2D9FOlClzjgvtY+DqLSG8U/+Cd9l5jebvshlB69JSDUzTs2Jr/
 wFEUJ9j7x0zGvR+UJy8iXsA0Qndb7hpSp5rzEeHwvFzK0WcBXNo9eXMG2ZqbugMo8uwf
 rTCufSx41cMXDWm0qGMzDB/hgWXH7vwmR3PT29F1gd1dCeloTNO4WH9wJwuJQtMOlytO
 CGJiAZGF8RtpAHjMwagmkpSnUOv1Uh/SoTKC/Tl2aB6qj+3A/wvSoygG832pVjb2YxV1 5A== 
Received: from prod-mail-ppoint8 (prod-mail-ppoint8.akamai.com [96.6.114.122] (may be forged))
        by m0050095.ppops.net-00190b01. with ESMTP id 2v9y24fe9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Oct 2019 18:29:10 +0100
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
        by prod-mail-ppoint8.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x92HGrBY028935;
        Wed, 2 Oct 2019 13:29:09 -0400
Received: from prod-mail-relay14.akamai.com ([172.27.17.39])
        by prod-mail-ppoint8.akamai.com with ESMTP id 2va2uxb5ac-1;
        Wed, 02 Oct 2019 13:29:09 -0400
Received: from bos-lpwg1 (bos-lpwg1.kendall.corp.akamai.com [172.29.171.203])
        by prod-mail-relay14.akamai.com (Postfix) with ESMTP id F0D8F80E97;
        Wed,  2 Oct 2019 17:29:08 +0000 (GMT)
Received: from johunt by bos-lpwg1 with local (Exim 4.86_2)
        (envelope-from <johunt@akamai.com>)
        id 1iFiRU-0003GN-1o; Wed, 02 Oct 2019 13:29:36 -0400
From:   Josh Hunt <johunt@akamai.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, willemb@google.com,
        alexander.h.duyck@intel.com, Josh Hunt <johunt@akamai.com>
Subject: [PATCH net v2 2/2] udp: only do GSO if # of segs > 1
Date:   Wed,  2 Oct 2019 13:29:23 -0400
Message-Id: <1570037363-12485-2-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570037363-12485-1-git-send-email-johunt@akamai.com>
References: <1570037363-12485-1-git-send-email-johunt@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-02_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910020145
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-02_07:2019-10-01,2019-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 bulkscore=0 mlxscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1910020146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prior to this change an application sending <= 1MSS worth of data and
enabling UDP GSO would fail if the system had SW GSO enabled, but the
same send would succeed if HW GSO offload is enabled. In addition to this
inconsistency the error in the SW GSO case does not get back to the
application if sending out of a real device so the user is unaware of this
failure.

With this change we only perform GSO if the # of segments is > 1 even
if the application has enabled segmentation. I've also updated the
relevant udpgso selftests.

Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 net/ipv4/udp.c                       | 11 +++++++----
 net/ipv6/udp.c                       | 11 +++++++----
 tools/testing/selftests/net/udpgso.c | 16 ++++------------
 3 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index be98d0b8f014..c31c7c353fcb 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -821,6 +821,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
 	int is_udplite = IS_UDPLITE(sk);
 	int offset = skb_transport_offset(skb);
 	int len = skb->len - offset;
+	int datalen = len - sizeof(*uh);
 	__wsum csum = 0;
 
 	/*
@@ -854,10 +855,12 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
 			return -EIO;
 		}
 
-		skb_shinfo(skb)->gso_size = cork->gso_size;
-		skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
-		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(*uh),
-							 cork->gso_size);
+		if (datalen > cork->gso_size) {
+			skb_shinfo(skb)->gso_size = cork->gso_size;
+			skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
+			skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(datalen,
+								 cork->gso_size);
+		}
 		goto csum_partial;
 	}
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index eb9a9934ac05..6324d3a8cb53 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1109,6 +1109,7 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 	__wsum csum = 0;
 	int offset = skb_transport_offset(skb);
 	int len = skb->len - offset;
+	int datalen = len - sizeof(*uh);
 
 	/*
 	 * Create a UDP header
@@ -1141,10 +1142,12 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 			return -EIO;
 		}
 
-		skb_shinfo(skb)->gso_size = cork->gso_size;
-		skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
-		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(*uh),
-							 cork->gso_size);
+		if (datalen > cork->gso_size) {
+			skb_shinfo(skb)->gso_size = cork->gso_size;
+			skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
+			skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(datalen,
+								 cork->gso_size);
+		}
 		goto csum_partial;
 	}
 
diff --git a/tools/testing/selftests/net/udpgso.c b/tools/testing/selftests/net/udpgso.c
index b8265ee9923f..614b31aad168 100644
--- a/tools/testing/selftests/net/udpgso.c
+++ b/tools/testing/selftests/net/udpgso.c
@@ -89,12 +89,9 @@ struct testcase testcases_v4[] = {
 		.tfail = true,
 	},
 	{
-		/* send a single MSS: will fail with GSO, because the segment
-		 * logic in udp4_ufo_fragment demands a gso skb to be > MTU
-		 */
+		/* send a single MSS: will fall back to no GSO */
 		.tlen = CONST_MSS_V4,
 		.gso_len = CONST_MSS_V4,
-		.tfail = true,
 		.r_num_mss = 1,
 	},
 	{
@@ -139,10 +136,9 @@ struct testcase testcases_v4[] = {
 		.tfail = true,
 	},
 	{
-		/* send a single 1B MSS: will fail, see single MSS above */
+		/* send a single 1B MSS: will fall back to no GSO */
 		.tlen = 1,
 		.gso_len = 1,
-		.tfail = true,
 		.r_num_mss = 1,
 	},
 	{
@@ -196,12 +192,9 @@ struct testcase testcases_v6[] = {
 		.tfail = true,
 	},
 	{
-		/* send a single MSS: will fail with GSO, because the segment
-		 * logic in udp4_ufo_fragment demands a gso skb to be > MTU
-		 */
+		/* send a single MSS: will fall back to no GSO */
 		.tlen = CONST_MSS_V6,
 		.gso_len = CONST_MSS_V6,
-		.tfail = true,
 		.r_num_mss = 1,
 	},
 	{
@@ -246,10 +239,9 @@ struct testcase testcases_v6[] = {
 		.tfail = true,
 	},
 	{
-		/* send a single 1B MSS: will fail, see single MSS above */
+		/* send a single 1B MSS: will fall back to no GSO */
 		.tlen = 1,
 		.gso_len = 1,
-		.tfail = true,
 		.r_num_mss = 1,
 	},
 	{
-- 
2.7.4

