Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059501B541D
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 07:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgDWFUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 01:20:00 -0400
Received: from mail.fudan.edu.cn ([202.120.224.10]:60771 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725863AbgDWFT7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 01:19:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=oKq3oYorpk83ICjscW/wqDC15xPQ4BXvibMUxOOVjpY=; b=J
        zIhcvVxHIXUwxoz21x6yGF0GfkokA1Lt0sS1MOwHAC9Ntz8CcCkV2RKkO8FIysnb
        BE/tjAJX/JIMnNuBT9xoMQbtgOSGF8+ZepRDnuyNtcIa5Ifw0HNdnSuQONqJhbCk
        0kRhnwn/oq41h2dsWps6dJfNZtY68jdihP69iDRdEU=
Received: from localhost.localdomain (unknown [120.229.255.80])
        by app1 (Coremail) with SMTP id XAUFCgDXx3RxJaFej708AA--.30683S3;
        Thu, 23 Apr 2020 13:19:47 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] xfrm: Fix xfrm_state refcnt leak in xfrm_input()
Date:   Thu, 23 Apr 2020 13:19:20 +0800
Message-Id: <1587619161-14094-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XAUFCgDXx3RxJaFej708AA--.30683S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXr4DXr18Gw47ZFykuw4Uurg_yoW5Wr15pF
        W5C39rtrWv9ay8Aw1kt348XF1Ut3yxKryFkFykC3WUJF90y3WFgryFgFWaqFW8ArWkCa40
        qrySqrWFg34kJaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl
        6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8JVWxJw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxEwVAFwVW8WwCF04k20xvY0x0EwIxGrw
        CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAv
        wI8IcIk0rVW3JVWrJr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
        AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUfHUDUUUUU=
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xfrm_input() invokes xfrm_state_lookup(), which returns a reference of
the specified xfrm_state object to "x" with increased refcnt and then
"x" is escaped to "sp->xvec[]".

When xfrm_input() encounters error, it calls kfree_skb() to free the
"skb" memory. Since "sp" comes from one of "skb" fields, this "free"
behavior causes "sp" becomes invalid, so the refcount for its field
should be decreased to keep refcount balanced before kfree_skb() calls.

The reference counting issue happens in several exception handling paths
of xfrm_input(). When those error scenarios occur such as skb_dst()
fails, the function forgets to decrease the refcnt increased by
xfrm_state_lookup() and directly calls kfree_skb(), causing a refcnt
leak.

Fix this issue by jumping to "put_sp" label when those error scenarios
occur.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/xfrm/xfrm_input.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index aa35f23c4912..9ca534e28462 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -589,7 +589,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		skb_dst_force(skb);
 		if (!skb_dst(skb)) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINERROR);
-			goto drop;
+			goto put_sp;
 		}
 
 lock:
@@ -623,7 +623,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 
 		if (xfrm_tunnel_check(skb, x, family)) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEMODEERROR);
-			goto drop;
+			goto put_sp;
 		}
 
 		seq_hi = htonl(xfrm_replay_seqhi(x, seq));
@@ -677,13 +677,13 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			inner_mode = xfrm_ip2inner_mode(x, XFRM_MODE_SKB_CB(skb)->protocol);
 			if (inner_mode == NULL) {
 				XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEMODEERROR);
-				goto drop;
+				goto put_sp;
 			}
 		}
 
 		if (xfrm_inner_mode_input(x, inner_mode, skb)) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEMODEERROR);
-			goto drop;
+			goto put_sp;
 		}
 
 		if (x->outer_mode.flags & XFRM_MODE_FLAG_TUNNEL) {
@@ -701,7 +701,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		err = xfrm_parse_spi(skb, nexthdr, &spi, &seq);
 		if (err < 0) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINHDRERROR);
-			goto drop;
+			goto put_sp;
 		}
 		crypto_done = false;
 	} while (!err);
@@ -744,6 +744,8 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 
 drop_unlock:
 	spin_unlock(&x->lock);
+put_sp:
+	skb_ext_put_sp(sp);
 drop:
 	xfrm_rcv_cb(skb, family, x && x->type ? x->type->proto : nexthdr, -1);
 	kfree_skb(skb);
-- 
2.7.4

