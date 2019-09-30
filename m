Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFDAC2950
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 00:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732347AbfI3WLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 18:11:50 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:50784 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726590AbfI3WLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 18:11:50 -0400
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8ULvMic026623;
        Mon, 30 Sep 2019 23:11:43 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=jan2016.eng;
 bh=03Xko2jKzArzPzN0wlIFBP9sHpYemkLKiwaptn2qMJk=;
 b=ANTssvZRlQkukB2yypEeY/cJOZwVFyyWc8MJOazAXJyYjX7pCcFhDuNPDg8fKdk5aRF8
 zCWg4szvLCb8EE96Nd2sQvlV2SJaujqkf5z9zuMHj3cFd9WrNpg9hKhnoBv1k1fAqUei
 L268pcPMXRkm/M0NVQfoURqzMIac2JTFYSu1pPmFoBJhn3uhdn/Ui/cS9wmX+OH2RACJ
 CDdx3rmv7YQGIyPzSbrQZKskDWDE8I4p8HLtTX/XgI5grRU3NhjPoSnDiyWbW/kpODPt
 uBTOQ3XGioxYEK5hVoC8PkQjeytR5On/3NpYRPROiIv7vv8Qu9Cf1EJ+28H9Cn1J43/R Hg== 
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2v9xs840ej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Sep 2019 23:11:43 +0100
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
        by prod-mail-ppoint2.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x8UM2Ja8018679;
        Mon, 30 Sep 2019 18:11:42 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint2.akamai.com with ESMTP id 2va2uw2rka-1;
        Mon, 30 Sep 2019 18:11:42 -0400
Received: from bos-lpwg1 (bos-lpwg1.kendall.corp.akamai.com [172.29.171.203])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 11C7E1FC6A;
        Mon, 30 Sep 2019 22:11:42 +0000 (GMT)
Received: from johunt by bos-lpwg1 with local (Exim 4.86_2)
        (envelope-from <johunt@akamai.com>)
        id 1iF3to-0005iA-R0; Mon, 30 Sep 2019 18:12:08 -0400
From:   Josh Hunt <johunt@akamai.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, willemb@google.com,
        alexander.h.duyck@intel.com, Josh Hunt <johunt@akamai.com>
Subject: [PATCH 2/2] udp: only do GSO if # of segs > 1
Date:   Mon, 30 Sep 2019 18:11:58 -0400
Message-Id: <1569881518-21885-2-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569881518-21885-1-git-send-email-johunt@akamai.com>
References: <1569881518-21885-1-git-send-email-johunt@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-30_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=997
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909300183
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_12:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 phishscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909300183
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
 net/ipv4/udp.c                       |  5 +++--
 net/ipv6/udp.c                       |  5 +++--
 tools/testing/selftests/net/udpgso.c | 16 ++++------------
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index be98d0b8f014..ac0baf947560 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -821,6 +821,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
 	int is_udplite = IS_UDPLITE(sk);
 	int offset = skb_transport_offset(skb);
 	int len = skb->len - offset;
+	int datalen = len - sizeof(*uh);
 	__wsum csum = 0;
 
 	/*
@@ -832,7 +833,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
 	uh->len = htons(len);
 	uh->check = 0;
 
-	if (cork->gso_size) {
+	if (cork->gso_size && datalen > cork->gso_size) {
 		const int hlen = skb_network_header_len(skb) +
 				 sizeof(struct udphdr);
 
@@ -856,7 +857,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
 
 		skb_shinfo(skb)->gso_size = cork->gso_size;
 		skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
-		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(*uh),
+		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(datalen,
 							 cork->gso_size);
 		goto csum_partial;
 	}
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index eb9a9934ac05..5e5f4013d905 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1109,6 +1109,7 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 	__wsum csum = 0;
 	int offset = skb_transport_offset(skb);
 	int len = skb->len - offset;
+	int datalen = len - sizeof(*uh);
 
 	/*
 	 * Create a UDP header
@@ -1119,7 +1120,7 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 	uh->len = htons(len);
 	uh->check = 0;
 
-	if (cork->gso_size) {
+	if (cork->gso_size && datalen > cork->gso_size) {
 		const int hlen = skb_network_header_len(skb) +
 				 sizeof(struct udphdr);
 
@@ -1143,7 +1144,7 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 
 		skb_shinfo(skb)->gso_size = cork->gso_size;
 		skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
-		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(*uh),
+		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(datalen,
 							 cork->gso_size);
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

