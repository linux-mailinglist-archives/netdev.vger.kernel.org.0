Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 360A7C2951
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 00:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732359AbfI3WLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 18:11:50 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:15872 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728035AbfI3WLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 18:11:50 -0400
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8ULvRTe023370;
        Mon, 30 Sep 2019 23:11:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=TbUk/r59p5jSgo6wWhlrBKMk1/6+sLGLI0gTgW/rd1s=;
 b=CT0y69r+IhZ74kHzZMbkieM0hzCW3SnjCMjB39qO3+y6t+8e5CRSZs3rtyfLfHXGkIpP
 BWj/+BWhDFtSyuIz/H+514VkT2N4RL6sAl1MITUDME3ieoO5IObq2Y6chVFxOwBgctxC
 CVIyqh1ppXeqjKNhDbynwg3o7hzlj+WOxfSzOGSjqbwxz0gvKSWXIWF8cpze32N+ESj2
 XJytZst9MjCiCQyV0aHCighT5Ywhw2NgBZhVQCZbna9yq37n7iviS7AFivTx9v0SfhBq
 caK8m/R3uXcGYJ29Zxlp66bKGUJ1Kon77xKF25j7o5Uy0L3aLCng7xjSBSEx7xfVYKxv ig== 
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2v9y5v28qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Sep 2019 23:11:42 +0100
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
        by prod-mail-ppoint2.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x8UM2Ja7018679;
        Mon, 30 Sep 2019 18:11:41 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint2.akamai.com with ESMTP id 2va2uw2rk6-1;
        Mon, 30 Sep 2019 18:11:41 -0400
Received: from bos-lpwg1 (bos-lpwg1.kendall.corp.akamai.com [172.29.171.203])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id DF14F1FC95;
        Mon, 30 Sep 2019 22:11:40 +0000 (GMT)
Received: from johunt by bos-lpwg1 with local (Exim 4.86_2)
        (envelope-from <johunt@akamai.com>)
        id 1iF3tn-0005i5-KN; Mon, 30 Sep 2019 18:12:07 -0400
From:   Josh Hunt <johunt@akamai.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, willemb@google.com,
        alexander.h.duyck@intel.com, Josh Hunt <johunt@akamai.com>
Subject: [PATCH 1/2] udp: fix gso_segs calculations
Date:   Mon, 30 Sep 2019 18:11:57 -0400
Message-Id: <1569881518-21885-1-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-30_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=816
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909300183
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_12:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=843
 clxscore=1011 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909300183
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit dfec0ee22c0a ("udp: Record gso_segs when supporting UDP segmentation offload")
added gso_segs calculation, but incorrectly got sizeof() the pointer and
not the underlying data type. It also does not account for v6 UDP GSO segs.

Fixes: dfec0ee22c0a ("udp: Record gso_segs when supporting UDP segmentation offload")
Signed-off-by: Josh Hunt <johunt@akamai.com>
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

