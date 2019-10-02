Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEAFC8FE7
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 19:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfJBR3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 13:29:15 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:45708 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726697AbfJBR3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 13:29:15 -0400
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
        by m0050093.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x92HMVc3003303;
        Wed, 2 Oct 2019 18:29:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=P3xtU1qAakR53ydKJlTvFN+MqzBtWcqbj0LMe4Hr6Bs=;
 b=SY4gsPre7WgfARNYMT7UL7lgIzVHqtIKg08RvKnDZVu7uxfpHFzbKROVW8XRXeMCFVQV
 kLK1o95vFLMUZc4tlKNVWErDNXF8znbchRImq09yk/dS76qI/QRTDppSQPdDB+sUHsaO
 pjjUKrN25RASSHYVA+utXC2WvyNG9THDr5JZGkWBHNAkKdQFuGgNotwuDazD661ETt1N
 Z87o0wgEQaamEotQU18xO0y9WQdbSpubJZxjXb63NqPQ4qqNXDY/ipzmsLucUNlkGswI
 GVduzWp3GW3mqYv9AedPp+1zioQsGGSXXFBC9cBlqbIsKr8924XwlED7CHDPG1bL4XoC rQ== 
Received: from prod-mail-ppoint8 (prod-mail-ppoint8.akamai.com [96.6.114.122] (may be forged))
        by m0050093.ppops.net-00190b01. with ESMTP id 2v9xspygqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Oct 2019 18:29:10 +0100
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
        by prod-mail-ppoint8.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x92HGq1t028924;
        Wed, 2 Oct 2019 13:29:09 -0400
Received: from prod-mail-relay15.akamai.com ([172.27.17.40])
        by prod-mail-ppoint8.akamai.com with ESMTP id 2va2uxb5ab-1;
        Wed, 02 Oct 2019 13:29:09 -0400
Received: from bos-lpwg1 (bos-lpwg1.kendall.corp.akamai.com [172.29.171.203])
        by prod-mail-relay15.akamai.com (Postfix) with ESMTP id E5E892006A;
        Wed,  2 Oct 2019 17:29:08 +0000 (GMT)
Received: from johunt by bos-lpwg1 with local (Exim 4.86_2)
        (envelope-from <johunt@akamai.com>)
        id 1iFiRU-0003GJ-0r; Wed, 02 Oct 2019 13:29:36 -0400
From:   Josh Hunt <johunt@akamai.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, willemb@google.com,
        alexander.h.duyck@intel.com, Josh Hunt <johunt@akamai.com>
Subject: [PATCH net v2 1/2] udp: fix gso_segs calculations
Date:   Wed,  2 Oct 2019 13:29:22 -0400
Message-Id: <1570037363-12485-1-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-02_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910020145
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-02_07:2019-10-01,2019-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 mlxscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1910020146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit dfec0ee22c0a ("udp: Record gso_segs when supporting UDP segmentation offload")
added gso_segs calculation, but incorrectly got sizeof() the pointer and
not the underlying data type. In addition let's fix the v6 case.

Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
Fixes: dfec0ee22c0a ("udp: Record gso_segs when supporting UDP segmentation offload")
Signed-off-by: Josh Hunt <johunt@akamai.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 net/ipv4/udp.c | 2 +-
 net/ipv6/udp.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index cf755156a684..be98d0b8f014 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -856,7 +856,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
 
 		skb_shinfo(skb)->gso_size = cork->gso_size;
 		skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
-		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(uh),
+		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(*uh),
 							 cork->gso_size);
 		goto csum_partial;
 	}
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index aae4938f3dea..eb9a9934ac05 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1143,6 +1143,8 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 
 		skb_shinfo(skb)->gso_size = cork->gso_size;
 		skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
+		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(*uh),
+							 cork->gso_size);
 		goto csum_partial;
 	}
 
-- 
2.7.4

