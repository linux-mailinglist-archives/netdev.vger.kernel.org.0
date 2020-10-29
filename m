Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CBF29E650
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 09:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbgJ2IXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 04:23:03 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:33561 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbgJ2IW6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 04:22:58 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 04f582de;
        Thu, 29 Oct 2020 02:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=Z15U21J32JldQJKjikJUG5UGb
        XI=; b=dIIz1u2vlxmpnlNj4fDhEmqXNZhJV0Rvzz6me0nxp7ZKnBtPJ+JTvo1YI
        CDSnD6cGoPhGdCFZeyhq8NqwdYMEXUWYwyOshJrIPiEJUmvqWy0pw+G86CumzZ38
        Vtd4jP7kZMScfm5sI7pNLPdowKqvifDR8tSTb3/yzcPrN3N4IN0dbDql/dR/zCdw
        hDocTDGiexnx/XSdTG7iABviY1Y7CaBlbtVkIadWbueFEZde3ksCl5GXCiC8Thzc
        TwhgI/a3GlRvizhRTnouLgxepOoWDIb4NYN/xji9OT10ZDmNId9eKnQlrKzmiKZe
        5PdqISvn8TvY4o6lK2gNTEtZ19wjg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 03a08836 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 29 Oct 2020 02:54:56 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Chen Minqiang <ptpt52@gmail.com>
Subject: [PATCH nf 1/2] wireguard: selftests: check that route_me_harder packets use the right sk
Date:   Thu, 29 Oct 2020 03:56:05 +0100
Message-Id: <20201029025606.3523771-2-Jason@zx2c4.com>
In-Reply-To: <20201029025606.3523771-1-Jason@zx2c4.com>
References: <20201029025606.3523771-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If netfilter changes the packet mark, the packet is rerouted. The
ip_route_me_harder family of functions fails to use the right sk, opting
to instead use skb->sk, resulting in a routing loop when used with
tunnels. With the next change fixing this issue in netfilter, test for
the relevant condition inside our test suite, since wireguard was where
the bug was discovered.

Reported-by: Chen Minqiang <ptpt52@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/netns.sh           | 8 ++++++++
 tools/testing/selftests/wireguard/qemu/kernel.config | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/tools/testing/selftests/wireguard/netns.sh b/tools/testing/selftests/wireguard/netns.sh
index d77f4829f1e0..74c69b75f6f5 100755
--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -316,6 +316,14 @@ pp sleep 3
 n2 ping -W 1 -c 1 192.168.241.1
 n1 wg set wg0 peer "$pub2" persistent-keepalive 0
 
+# Test that sk_bound_dev_if works
+n1 ping -I wg0 -c 1 -W 1 192.168.241.2
+# What about when the mark changes and the packet must be rerouted?
+n1 iptables -t mangle -I OUTPUT -j MARK --set-xmark 1
+n1 ping -c 1 -W 1 192.168.241.2 # First the boring case
+n1 ping -I wg0 -c 1 -W 1 192.168.241.2 # Then the sk_bound_dev_if case
+n1 iptables -t mangle -D OUTPUT -j MARK --set-xmark 1
+
 # Test that onion routing works, even when it loops
 n1 wg set wg0 peer "$pub3" allowed-ips 192.168.242.2/32 endpoint 192.168.241.2:5
 ip1 addr add 192.168.242.1/24 dev wg0
diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/testing/selftests/wireguard/qemu/kernel.config
index d531de13c95b..4eecb432a66c 100644
--- a/tools/testing/selftests/wireguard/qemu/kernel.config
+++ b/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -18,10 +18,12 @@ CONFIG_NF_NAT=y
 CONFIG_NETFILTER_XTABLES=y
 CONFIG_NETFILTER_XT_NAT=y
 CONFIG_NETFILTER_XT_MATCH_LENGTH=y
+CONFIG_NETFILTER_XT_MARK=y
 CONFIG_NF_CONNTRACK_IPV4=y
 CONFIG_NF_NAT_IPV4=y
 CONFIG_IP_NF_IPTABLES=y
 CONFIG_IP_NF_FILTER=y
+CONFIG_IP_NF_MANGLE=y
 CONFIG_IP_NF_NAT=y
 CONFIG_IP_ADVANCED_ROUTER=y
 CONFIG_IP_MULTIPLE_TABLES=y
-- 
2.29.1

