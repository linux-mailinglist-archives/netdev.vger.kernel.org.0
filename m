Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AA52E28AD
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 20:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbgLXTCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 14:02:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48327 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728563AbgLXTCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 14:02:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608836478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Z8MpfZcGhrP8iGy29XT88QvFzgqRvNA/G6lBDtAxjSI=;
        b=J4fH0kEPQORPQZ5RpaNbLTyssXdPTGqiIZItj7egQkzYpcTesrO4mNwhE9uujCkQlh2B5k
        5Q+r4QMu3k7kNVEsAqMfnve6d1i80ieAfDuapwT/1zMhAkTWVq3WggV9iTs+hdK06Zv8L0
        r+DXPknLnLdpm6jyQw4Wb5pfBdRjILQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-WkrCTilSNceRAdzwnIi2QQ-1; Thu, 24 Dec 2020 14:01:13 -0500
X-MC-Unique: WkrCTilSNceRAdzwnIi2QQ-1
Received: by mail-wr1-f72.google.com with SMTP id u29so1209510wru.6
        for <netdev@vger.kernel.org>; Thu, 24 Dec 2020 11:01:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Z8MpfZcGhrP8iGy29XT88QvFzgqRvNA/G6lBDtAxjSI=;
        b=WoG+wabpy9HymY1ex4fYNJ6zRw634RBZlg8OkPAe6q50gCKOfHH2lNy1Mf01hHmxI6
         EUrOxTBTk0jdCkxWhVVpG5vTp69IzIarQHkz7ZU2REp9z1+HKo/0iEk+BKQ36iqZPniw
         aG+0VKp93GYz8u3gpCslDGm9JKvt+Cvkf/i9A3V/WmUvoh/LbLB6Zb1ZHD7c8LrjXU4N
         D5kMDfInjtNYBICXpmUKOrVGn3UfTTzYPjNq7VaMLvNtZ2M0T6wWfvZx/ru5dSRipl8e
         eHbZfyCN4CeDRmGfGS6BCTd3+m7rz3TiNGA4zgQubQvkQEcX+upVULgqNeh/+rPMZD0U
         Be/A==
X-Gm-Message-State: AOAM531R/Lzn7bgLPJkpm9sEEz++VEzbUy/G/duCKpQabHZgXAeABthv
        2vUMTSClqxjHa2PzBVHCUtNNHP8KXECgFNYdGr5sgcMvamyP26qxPRwD6eRGe7Uz6hnWZRtZ7Na
        plvfr1p6SaW99pHsi
X-Received: by 2002:a1c:2e88:: with SMTP id u130mr5501001wmu.83.1608836472016;
        Thu, 24 Dec 2020 11:01:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzjug5k5Hu6/nXivtFpCBUcIbzBxu94e7Zi5ybGss+pMF8ofMM1a4nzikRpQmOLzOIRBKLjWg==
X-Received: by 2002:a1c:2e88:: with SMTP id u130mr5500988wmu.83.1608836471846;
        Thu, 24 Dec 2020 11:01:11 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id i11sm4367126wmd.47.2020.12.24.11.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 11:01:11 -0800 (PST)
Date:   Thu, 24 Dec 2020 20:01:09 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] ipv4: Ignore ECN bits for fib lookups in
 fib_compute_spec_dst()
Message-ID: <49ff39b1f55c914847cd58678bae6282112db701.1608836260.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RT_TOS() only clears one of the ECN bits. Therefore, when
fib_compute_spec_dst() resorts to a fib lookup, it can return
different results depending on the value of the second ECN bit.

For example, ECT(0) and ECT(1) packets could be treated differently.

  $ ip netns add ns0
  $ ip netns add ns1
  $ ip link add name veth01 netns ns0 type veth peer name veth10 netns ns1
  $ ip -netns ns0 link set dev lo up
  $ ip -netns ns1 link set dev lo up
  $ ip -netns ns0 link set dev veth01 up
  $ ip -netns ns1 link set dev veth10 up

  $ ip -netns ns0 address add 192.0.2.10/24 dev veth01
  $ ip -netns ns1 address add 192.0.2.11/24 dev veth10

  $ ip -netns ns1 address add 192.0.2.21/32 dev lo
  $ ip -netns ns1 route add 192.0.2.10/32 tos 4 dev veth10 src 192.0.2.21
  $ ip netns exec ns1 sysctl -wq net.ipv4.icmp_echo_ignore_broadcasts=0

With TOS 4 and ECT(1), ns1 replies using source address 192.0.2.21
(ping uses -Q to set all TOS and ECN bits):

  $ ip netns exec ns0 ping -c 1 -b -Q 5 192.0.2.255
  [...]
  64 bytes from 192.0.2.21: icmp_seq=1 ttl=64 time=0.544 ms

But with TOS 4 and ECT(0), ns1 replies using source address 192.0.2.11
because the "tos 4" route isn't matched:

  $ ip netns exec ns0 ping -c 1 -b -Q 6 192.0.2.255
  [...]
  64 bytes from 192.0.2.11: icmp_seq=1 ttl=64 time=0.597 ms

After this patch the ECN bits don't affect the result anymore:

  $ ip netns exec ns0 ping -c 1 -b -Q 6 192.0.2.255
  [...]
  64 bytes from 192.0.2.21: icmp_seq=1 ttl=64 time=0.591 ms

Fixes: 35ebf65e851c ("ipv4: Create and use fib_compute_spec_dst() helper.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/fib_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index cdf6ec5aa45d..84bb707bd88d 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -292,7 +292,7 @@ __be32 fib_compute_spec_dst(struct sk_buff *skb)
 			.flowi4_iif = LOOPBACK_IFINDEX,
 			.flowi4_oif = l3mdev_master_ifindex_rcu(dev),
 			.daddr = ip_hdr(skb)->saddr,
-			.flowi4_tos = RT_TOS(ip_hdr(skb)->tos),
+			.flowi4_tos = ip_hdr(skb)->tos & IPTOS_RT_MASK,
 			.flowi4_scope = scope,
 			.flowi4_mark = vmark ? skb->mark : 0,
 		};
-- 
2.21.3

