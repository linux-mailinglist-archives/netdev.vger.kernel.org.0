Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6276D609806
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 04:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiJXCBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 22:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiJXCBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 22:01:30 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAA56EF2C
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 19:01:28 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id p3so6378399pld.10
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 19:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gFDx4bqwKbJ/H0XAa8sQr4f7T9HC0BzpHXfmygktIjA=;
        b=ANeefk+PEHyU9jKvaluWBa/MwlAJXAgNiIlq6TQuThtkoTratS9VYZUhJukuLcPogT
         zxczc61zRK3pKL2JRN1AQKRDrgdYdDl+cJnMUQVGNMgxAWvX35OCailA1ZpXPqiJaM9l
         6wDsb5BY9oxJ+7XNZUslpiMUt7oc2KeH7NYUynHs0n9AQeZJf9CqSzl799aeWYNZ/7cY
         jhDPMVtC9oJCVybZElrwWDz0jV2doX45ocPLI+eCeRQ3ArE9++zIaqkfPwnnWhLJ2kd8
         YEvmg9ljo+A/FqM6VvY0M6FOUuRfFjRjeDXsNrxSvOGCE/OebMeAYd2LAaZrJsT5ZFnV
         hIUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gFDx4bqwKbJ/H0XAa8sQr4f7T9HC0BzpHXfmygktIjA=;
        b=fL1TY+R48jB0DaiHlyA7nAoGfrBMwScS/iUuF9YLbOhJYNEelbELKz7Y/qAnlPREyp
         +u+5tSFO3avwhU4rDhUuqhHvynETt5hALCn451FuBKYCX0D0TGGcZ+VhEOP94hm0IePa
         2+C96NZ6Vqn9DraHIM4xvc8r/+qykq1grMI5ZYHu+jVHuwk62mQTMHL7LdyoMLe0cISy
         DKN1bfO8wJtF2wZJ+B+huhmTSly1t6HUS3pUwOhFphoLABq1dhpFXrJ0zeTJ3vtwXc9C
         2vRdf0dDqAROrKnzQr/Yq1fghR507LXWS+Pw9ciPFGbVUFY4gsw/ZXXii9mkn5UaNWVs
         J1AQ==
X-Gm-Message-State: ACrzQf3vbx6BAzorVK+OE+4QixcJ4kozF4ye1AP/FyBwIDE2Qe8MZ0Z9
        uoyA1PNCM01u2i0vH1EM9/0=
X-Google-Smtp-Source: AMsMyM5RfJlKfS008UtEGQTPTzKQwHx90tJN5EV4pqQIgJdmxXaWKQCr6oCwfGbOYv07MBxZFI1LDw==
X-Received: by 2002:a17:90a:4607:b0:210:99f9:a915 with SMTP id w7-20020a17090a460700b0021099f9a915mr26477707pjg.62.1666576888454;
        Sun, 23 Oct 2022 19:01:28 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:dfee:f920:b53a:79f8])
        by smtp.gmail.com with ESMTPSA id m22-20020a170902bb9600b00186b1bfbe79sm87215pls.66.2022.10.23.19.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Oct 2022 19:01:27 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] ipv6: ensure sane device mtu in tunnels
Date:   Sun, 23 Oct 2022 19:01:24 -0700
Message-Id: <20221024020124.3756833-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Another syzbot report [1] with no reproducer hints
at a bug in ip6_gre tunnel (dev:ip6gretap0)

Since ipv6 mcast code makes sure to read dev->mtu once
and applies a sanity check on it (see commit b9b312a7a451
"ipv6: mcast: better catch silly mtu values"), a remaining
possibility is that a layer is able to set dev->mtu to
an underflowed value (high order bit set).

This could happen indeed in ip6gre_tnl_link_config_route(),
ip6_tnl_link_config() and ipip6_tunnel_bind_dev()

Make sure to sanitize mtu value in a local variable before
it is written once on dev->mtu, as lockless readers could
catch wrong temporary value.

[1]
skbuff: skb_over_panic: text:ffff80000b7a2f38 len:40 put:40 head:ffff000149dcf200 data:ffff000149dcf2b0 tail:0xd8 end:0xc0 dev:ip6gretap0
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:120
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 PID: 10241 Comm: kworker/1:1 Not tainted 6.0.0-rc7-syzkaller-18095-gbbed346d5a96 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
Workqueue: mld mld_ifc_work
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : skb_panic+0x4c/0x50 net/core/skbuff.c:116
lr : skb_panic+0x4c/0x50 net/core/skbuff.c:116
sp : ffff800020dd3b60
x29: ffff800020dd3b70 x28: 0000000000000000 x27: ffff00010df2a800
x26: 00000000000000c0 x25: 00000000000000b0 x24: ffff000149dcf200
x23: 00000000000000c0 x22: 00000000000000d8 x21: ffff80000b7a2f38
x20: ffff00014c2f7800 x19: 0000000000000028 x18: 00000000000001a9
x17: 0000000000000000 x16: ffff80000db49158 x15: ffff000113bf1a80
x14: 0000000000000000 x13: 00000000ffffffff x12: ffff000113bf1a80
x11: ff808000081c0d5c x10: 0000000000000000 x9 : 73f125dc5c63ba00
x8 : 73f125dc5c63ba00 x7 : ffff800008161d1c x6 : 0000000000000000
x5 : 0000000000000080 x4 : 0000000000000001 x3 : 0000000000000000
x2 : ffff0001fefddcd0 x1 : 0000000100000000 x0 : 0000000000000089
Call trace:
skb_panic+0x4c/0x50 net/core/skbuff.c:116
skb_over_panic net/core/skbuff.c:125 [inline]
skb_put+0xd4/0xdc net/core/skbuff.c:2049
ip6_mc_hdr net/ipv6/mcast.c:1714 [inline]
mld_newpack+0x14c/0x270 net/ipv6/mcast.c:1765
add_grhead net/ipv6/mcast.c:1851 [inline]
add_grec+0xa20/0xae0 net/ipv6/mcast.c:1989
mld_send_cr+0x438/0x5a8 net/ipv6/mcast.c:2115
mld_ifc_work+0x38/0x290 net/ipv6/mcast.c:2653
process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
worker_thread+0x340/0x610 kernel/workqueue.c:2436
kthread+0x12c/0x158 kernel/kthread.c:376
ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860
Code: 91011400 aa0803e1 a90027ea 94373093 (d4210000)

Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6_gre.c    | 12 +++++++-----
 net/ipv6/ip6_tunnel.c | 11 ++++++-----
 net/ipv6/sit.c        |  8 +++++---
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 48b4ff0294f6c53e84578bca9016e0905ab6a539..c035a96fba3a4dacf643cadaf5780263b7bc5a4f 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1175,14 +1175,16 @@ static void ip6gre_tnl_link_config_route(struct ip6_tnl *t, int set_mtu,
 				dev->needed_headroom = dst_len;
 
 			if (set_mtu) {
-				dev->mtu = rt->dst.dev->mtu - t_hlen;
+				int mtu = rt->dst.dev->mtu - t_hlen;
+
 				if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
-					dev->mtu -= 8;
+					mtu -= 8;
 				if (dev->type == ARPHRD_ETHER)
-					dev->mtu -= ETH_HLEN;
+					mtu -= ETH_HLEN;
 
-				if (dev->mtu < IPV6_MIN_MTU)
-					dev->mtu = IPV6_MIN_MTU;
+				if (mtu < IPV6_MIN_MTU)
+					mtu = IPV6_MIN_MTU;
+				WRITE_ONCE(dev->mtu, mtu);
 			}
 		}
 		ip6_rt_put(rt);
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index cc5d5e75b658f3972122d573eac88c7d59d637cb..2fb4c6ad724321c634a4bf94f535f06bb18dbb7d 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1450,8 +1450,8 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
 	struct net_device *tdev = NULL;
 	struct __ip6_tnl_parm *p = &t->parms;
 	struct flowi6 *fl6 = &t->fl.u.ip6;
-	unsigned int mtu;
 	int t_hlen;
+	int mtu;
 
 	__dev_addr_set(dev, &p->laddr, sizeof(struct in6_addr));
 	memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
@@ -1498,12 +1498,13 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
 			dev->hard_header_len = tdev->hard_header_len + t_hlen;
 			mtu = min_t(unsigned int, tdev->mtu, IP6_MAX_MTU);
 
-			dev->mtu = mtu - t_hlen;
+			mtu = mtu - t_hlen;
 			if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
-				dev->mtu -= 8;
+				mtu -= 8;
 
-			if (dev->mtu < IPV6_MIN_MTU)
-				dev->mtu = IPV6_MIN_MTU;
+			if (mtu < IPV6_MIN_MTU)
+				mtu = IPV6_MIN_MTU;
+			WRITE_ONCE(dev->mtu, mtu);
 		}
 	}
 }
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index d27683e3fc971ec8f9c6ece5f92c5927f5feb789..5703d3cbea9ba669c21d3f40bca347652077e6f0 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1124,10 +1124,12 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
 
 	if (tdev && !netif_is_l3_master(tdev)) {
 		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
+		int mtu;
 
-		dev->mtu = tdev->mtu - t_hlen;
-		if (dev->mtu < IPV6_MIN_MTU)
-			dev->mtu = IPV6_MIN_MTU;
+		mtu = tdev->mtu - t_hlen;
+		if (mtu < IPV6_MIN_MTU)
+			mtu = IPV6_MIN_MTU;
+		WRITE_ONCE(dev->mtu, mtu);
 	}
 }
 
-- 
2.38.0.135.g90850a2211-goog

