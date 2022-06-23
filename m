Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D5055727E
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 07:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiFWFMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 01:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiFWFMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 01:12:02 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2F444A16
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 22:04:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m11-20020a25710b000000b0065d4a4abca1so16358788ybc.18
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 22:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=r+Crtbvq8iDvuhDMduPTWi3XQ/95QYHYjtiBVKyEKUQ=;
        b=eeTpLBvvDpxm0tsH2fBjBPQjdX1cAazSqxK2O+HQJzKerJxjkUpuTiFEP2AmLQ0jdv
         ECnd3grAWFFlpRbS5RumFXaPiggzhfUv7d8nEviwBmKaY5Ogi0+WBCb7uYp8/gZ66LYk
         +xcl9l8eUKF+7trS4ddWcQvdyJtQkpC9KLlnF0HL9SUs64Hex5M+zJwQQ55t1dkld4Er
         6Xo4vHJrzvTgTl7A1mAPlOuTHow/zNvVwAju+Co+gG6VktMs7dixU59gggI0VDytBk0J
         43UvoSVCDiLpZMFXY4+Z4Lhn3IYvrQ8lAzDTZDogDIu66o92mPQl14nu9BL2QLjNgHww
         Og9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=r+Crtbvq8iDvuhDMduPTWi3XQ/95QYHYjtiBVKyEKUQ=;
        b=8RrPomFA/cEmZ1pZHFSmdQHG/p21LDPYCkn82NQlVxKui+30SeqPcpu8vhtRWY/GRj
         adbIR9A66Kvc/rkmghsEqQNFUqXNVkG1zEsIcCj54Zg6q9q73E6WpSFUWGCtuhUwLeml
         vX/bahvbc4rGjRn1E6dd9rzO0gO04j+oHS3Zo6/YKDrFhaA/S77eSW9RLTY+aJTJ9maq
         YysSSOCmRsFs7kd+Gxc2+x+48pgT23mJwDsKdMIHpSVZuB4PAQjLvgY2um47LVh9Y++m
         iCpEcZ7X3SlKu9I+FBu0tBpZ6QHwgBq2dHrOH0SzqKwFoyAa+p20CudGJZwOGPcHgLRj
         V7cg==
X-Gm-Message-State: AJIora+XOPR54q1ty7C8wHlgB4hGi5+EtgXwHu1vyuAobZVH2i5HyTqU
        eOCRMO5yeqqz+xvA5cYQYTltaKYSy3WZZg==
X-Google-Smtp-Source: AGRyM1suxio0cDZYSxwhzZwFh/5RbNkszjczuOO3xVkjf0PxR2aTiuPDd3MBF3pnzBqatGhTGStFLnRkUQIoIg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:982:0:b0:63e:7d7e:e2f2 with SMTP id
 c2-20020a5b0982000000b0063e7d7ee2f2mr7172383ybq.549.1655960677832; Wed, 22
 Jun 2022 22:04:37 -0700 (PDT)
Date:   Thu, 23 Jun 2022 05:04:36 +0000
Message-Id: <20220623050436.1290307-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net] tcp: add a missing nf_reset_ct() in 3WHS handling
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the third packet of 3WHS connection establishment
contains payload, it is added into socket receive queue
without the XFRM check and the drop of connection tracking
context.

This means that if the data is left unread in the socket
receive queue, conntrack module can not be unloaded.

As most applications usually reads the incoming data
immediately after accept(), bug has been hiding for
quite a long time.

Commit 68822bdf76f1 ("net: generalize skb freeing
deferral to per-cpu lists") exposed this bug because
even if the application reads this data, the skb
with nfct state could stay in a per-cpu cache for
an arbitrary time, if said cpu no longer process RX softirqs.

Many thanks to Ilya Maximets for reporting this issue,
and for testing various patches:
https://lore.kernel.org/netdev/20220619003919.394622-1-i.maximets@ovn.org/

Note that I also added a missing xfrm4_policy_check() call,
although this is probably not a big issue, as the SYN
packet should have been dropped earlier.

Fixes: b59c270104f0 ("[NETFILTER]: Keep conntrack reference until IPsec policy checks are done")
Reported-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/tcp_ipv4.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index fe8f23b95d32ca4a35d05166d471327bc608fa91..da5a3c44c4fb70f1d3ecc596e694a86267f1c44a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1964,7 +1964,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		drop_reason = tcp_inbound_md5_hash(sk, skb,
+		if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
+			drop_reason = SKB_DROP_REASON_XFRM_POLICY;
+		else
+			drop_reason = tcp_inbound_md5_hash(sk, skb,
 						   &iph->saddr, &iph->daddr,
 						   AF_INET, dif, sdif);
 		if (unlikely(drop_reason)) {
@@ -2016,6 +2019,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			}
 			goto discard_and_relse;
 		}
+		nf_reset_ct(skb);
 		if (nsk == sk) {
 			reqsk_put(req);
 			tcp_v4_restore_cb(skb);
-- 
2.37.0.rc0.104.g0611611a94-goog

