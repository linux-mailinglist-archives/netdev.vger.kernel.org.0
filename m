Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33102ACC3F
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732312AbgKJDx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:53:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732269AbgKJDx5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 22:53:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D82320731;
        Tue, 10 Nov 2020 03:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980436;
        bh=vggjhxlZ0nTVehZ6/y+P9Re4mUYV/sXpTjZQ/ky4jjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcSBE3aUyFVlBkLXt6UBZ5YLM9oimBvcHUC9txUZ4o3rLwTHYVQK39R/wjcwmhJiH
         4z1Q5E1H6+igdU/zRzXhIhssM1/Zi68n+zl/gM+5UXKqXW+HzgbdFigbJb982ATy5J
         DgUO0/5KS12wJKNsfuLZtVQd7WnyYNCGvM+QOETs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Chen Minqiang <ptpt52@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 26/55] wireguard: selftests: check that route_me_harder packets use the right sk
Date:   Mon,  9 Nov 2020 22:52:49 -0500
Message-Id: <20201110035318.423757-26-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit af8afcf1fdd5f365f70e2386c2d8c7a1abd853d7 ]

If netfilter changes the packet mark, the packet is rerouted. The
ip_route_me_harder family of functions fails to use the right sk, opting
to instead use skb->sk, resulting in a routing loop when used with
tunnels. With the next change fixing this issue in netfilter, test for
the relevant condition inside our test suite, since wireguard was where
the bug was discovered.

Reported-by: Chen Minqiang <ptpt52@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/wireguard/netns.sh           | 8 ++++++++
 tools/testing/selftests/wireguard/qemu/kernel.config | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/tools/testing/selftests/wireguard/netns.sh b/tools/testing/selftests/wireguard/netns.sh
index d77f4829f1e07..74c69b75f6f5a 100755
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
index d531de13c95b0..4eecb432a66c1 100644
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
2.27.0

