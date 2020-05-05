Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901E91C5956
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729349AbgEEONs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:13:48 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:36933 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729146AbgEEONr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:13:47 -0400
Received: from localhost.localdomain ([149.172.19.189]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M9WeC-1jSePQ0bES-005d0q; Tue, 05 May 2020 16:13:32 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, wireguard@lists.zx2c4.com,
        clang-built-linux@googlegroups.com
Subject: [PATCH] net: wireguard: avoid unused variable warning
Date:   Tue,  5 May 2020 16:13:17 +0200
Message-Id: <20200505141327.746184-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:j5rBKEs2EZ2wBWucgw3jP/snV64xmxjwf5JSJRK1981/0aQIMOW
 fEF0VkodfzvUsiuEQUDo7kxlEFs3xdtHubS7l8i8Gk1lEj/6nOgXOAI7UbeAobG1OrqBrcG
 GVJlqLnzIGLXPiv/nvBYUAcfTh4xKECz/6lRIBaCKcqauCArBacxGzmbeG17O3z256yLxp7
 bPL+EwTM3HZElCMzzbHdg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Dk/GUQ/t1Bc=:yEMm/AYZhCfPtA9HWgU3/6
 NpaeDf8tJN2PXbUfTPSlKnW7zxCFyXGgCxtknT8672D1Ri8glQ0ejXiFdUI0VLfBoZxCu5ZDq
 Clbq9XIaw4vcoS70Z2oe1OASZcipm0xIj+Zd/sSDeKE8gTibGvA7lKu5AMxc3kJh2lauU4eO0
 2VZryiFexozDS0SJoW6iZ6r2J2I7RNXCG9q5S3XNMZEHyPZxOUTh7XKocmbX2dBzzUCYOYkob
 ImIbtdgQxuidwLOPtuVokmY/B19rUsAtrBJQavK1pXZUX9zUsmDM1rl6/9jg9JmEWtZYQdHJj
 +3AnWXN2FG9EqRAhc3HC73C63I/UyhuLDh2+lBinSTdkgGdPQ1TNh58+2id0y4BPR06U8R23C
 CAB8mOJeJI1VXb2BGa7qb8GxLRBTBqGJotvhWYSel4/A+YrG7hjLIlsAvodsTEb0dEV61D5l5
 INqNgLWCH3tuiIYBOTpfgiCSB8qU83C9eMU5oClxOZAEpyJjjsLdxi+qSrpIUixWyJbMjM25b
 NjnrlxnZUtn2Z3CAdaNw786GgKxn3jw80kwrk6Onysd02XylVd4HeN6QAUsczkoyc1CD4L9zK
 2ktIYnX4devlUErlwVSGJzrPp+U9YNrHIcGTuM/KMRD3KzIH9+zjoDIVQ3AtpjcnZnuR4NQnt
 oYRKBcLtwnw/1EJFvNfQsdavWNOOzKnjXIa8BXi8RM980R6bmIOG3PRpoR/waCc+FYsBccfA6
 xLLw98YqKlcnpnG0+v8pwD98Lv0jX+sbOtb4b3JZeVJm0LO7sik3VgKCtlEjzeXI8AbKWOwCk
 bvmJu2G6jNC4yXyi8EScJuTfM7t46CimQURKtQRg4qvTNma43E=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang points out a harmless use of uninitialized variables that
get passed into a local function but are ignored there:

In file included from drivers/net/wireguard/ratelimiter.c:223:
drivers/net/wireguard/selftest/ratelimiter.c:173:34: error: variable 'skb6' is uninitialized when used here [-Werror,-Wuninitialized]
                ret = timings_test(skb4, hdr4, skb6, hdr6, &test_count);
                                               ^~~~
drivers/net/wireguard/selftest/ratelimiter.c:123:29: note: initialize the variable 'skb6' to silence this warning
        struct sk_buff *skb4, *skb6;
                                   ^
                                    = NULL
drivers/net/wireguard/selftest/ratelimiter.c:173:40: error: variable 'hdr6' is uninitialized when used here [-Werror,-Wuninitialized]
                ret = timings_test(skb4, hdr4, skb6, hdr6, &test_count);
                                                     ^~~~
drivers/net/wireguard/selftest/ratelimiter.c:125:22: note: initialize the variable 'hdr6' to silence this warning
        struct ipv6hdr *hdr6;
                            ^

Shut up the warning by ensuring the variables are always initialized,
and make up for the loss of readability by changing the "#if IS_ENABLED()"
checks to regular "if (IS_ENABLED())".

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireguard/selftest/ratelimiter.c | 32 +++++++++++---------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireguard/selftest/ratelimiter.c b/drivers/net/wireguard/selftest/ratelimiter.c
index bcd6462e4540..f408b936e224 100644
--- a/drivers/net/wireguard/selftest/ratelimiter.c
+++ b/drivers/net/wireguard/selftest/ratelimiter.c
@@ -153,19 +153,22 @@ bool __init wg_ratelimiter_selftest(void)
 	skb_reset_network_header(skb4);
 	++test;
 
-#if IS_ENABLED(CONFIG_IPV6)
-	skb6 = alloc_skb(sizeof(struct ipv6hdr), GFP_KERNEL);
-	if (unlikely(!skb6)) {
-		kfree_skb(skb4);
-		goto err_nofree;
+	if (IS_ENABLED(CONFIG_IPV6)) {
+		skb6 = alloc_skb(sizeof(struct ipv6hdr), GFP_KERNEL);
+		if (unlikely(!skb6)) {
+			kfree_skb(skb4);
+			goto err_nofree;
+		}
+		skb6->protocol = htons(ETH_P_IPV6);
+		hdr6 = (struct ipv6hdr *)skb_put(skb6, sizeof(*hdr6));
+		hdr6->saddr.in6_u.u6_addr32[0] = htonl(1212);
+		hdr6->saddr.in6_u.u6_addr32[1] = htonl(289188);
+		skb_reset_network_header(skb6);
+		++test;
+	} else {
+		skb6 = NULL;
+		hdr6 = NULL;
 	}
-	skb6->protocol = htons(ETH_P_IPV6);
-	hdr6 = (struct ipv6hdr *)skb_put(skb6, sizeof(*hdr6));
-	hdr6->saddr.in6_u.u6_addr32[0] = htonl(1212);
-	hdr6->saddr.in6_u.u6_addr32[1] = htonl(289188);
-	skb_reset_network_header(skb6);
-	++test;
-#endif
 
 	for (trials = TRIALS_BEFORE_GIVING_UP;;) {
 		int test_count = 0, ret;
@@ -206,9 +209,8 @@ bool __init wg_ratelimiter_selftest(void)
 
 err:
 	kfree_skb(skb4);
-#if IS_ENABLED(CONFIG_IPV6)
-	kfree_skb(skb6);
-#endif
+	if (IS_ENABLED(CONFIG_IPV6))
+		kfree_skb(skb6);
 err_nofree:
 	wg_ratelimiter_uninit();
 	wg_ratelimiter_uninit();
-- 
2.26.0

