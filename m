Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF572A1945
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgJaSOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:14:50 -0400
Received: from correo.us.es ([193.147.175.20]:48016 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727967AbgJaSOs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 14:14:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 92C217B551
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 19:14:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8351EDA78A
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 19:14:46 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 78E45DA730; Sat, 31 Oct 2020 19:14:46 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26AD7DA73F;
        Sat, 31 Oct 2020 19:14:44 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 31 Oct 2020 19:14:44 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 0070242EF42B;
        Sat, 31 Oct 2020 19:14:43 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH net 2/5] wireguard: selftests: check that route_me_harder packets use the right sk
Date:   Sat, 31 Oct 2020 19:14:34 +0100
Message-Id: <20201031181437.12472-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201031181437.12472-1-pablo@netfilter.org>
References: <20201031181437.12472-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

If netfilter changes the packet mark, the packet is rerouted. The
ip_route_me_harder family of functions fails to use the right sk, opting
to instead use skb->sk, resulting in a routing loop when used with
tunnels. With the next change fixing this issue in netfilter, test for
the relevant condition inside our test suite, since wireguard was where
the bug was discovered.

Reported-by: Chen Minqiang <ptpt52@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.20.1

