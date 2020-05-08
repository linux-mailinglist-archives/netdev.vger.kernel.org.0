Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9673E1CB7FA
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 21:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgEHTLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 15:11:21 -0400
Received: from 12.mo4.mail-out.ovh.net ([178.33.104.253]:57003 "EHLO
        12.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbgEHTLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 15:11:20 -0400
Received: from player773.ha.ovh.net (unknown [10.108.57.43])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id B3ACA235074
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 14:05:19 +0200 (CEST)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
        (Authenticated sender: steve@sk2.org)
        by player773.ha.ovh.net (Postfix) with ESMTPSA id C44C5123D2ECB;
        Fri,  8 May 2020 12:05:13 +0000 (UTC)
From:   Stephen Kitt <steve@sk2.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Joe Perches <joe@perches.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Stephen Kitt <steve@sk2.org>
Subject: [PATCH v2] net: Protect INET_ADDR_COOKIE on 32-bit architectures
Date:   Fri,  8 May 2020 14:04:57 +0200
Message-Id: <20200508120457.29422-1-steve@sk2.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 5404038079545232676
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrkedvgdegjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepufhtvghphhgvnhcumfhithhtuceoshhtvghvvgesshhkvddrohhrgheqnecuggftrfgrthhtvghrnhepteegudfgleekieekteeggeetveefueefteeugfduieeitdfhhedtfeefkedvfeefnecukfhppedtrddtrddtrddtpdekvddrieehrddvhedrvddtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejjeefrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepshhtvghvvgesshhkvddrohhrghdprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit c7228317441f ("net: Use a more standard macro for
INET_ADDR_COOKIE") added a __deprecated marker to the cookie name on
32-bit architectures, with the intent that the compiler would flag
uses of the name. However since commit 771c035372a0 ("deprecate the
'__deprecated' attribute warnings entirely and for good"),
__deprecated doesn't do anything and should be avoided.

This patch changes INET_ADDR_COOKIE to declare a dummy struct so that
any subsequent use of the cookie's name will in all likelihood break
the build. It also removes the __deprecated marker.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
Changes since v1:
  - use a dummy struct rather than a typedef

 include/net/inet_hashtables.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index ad64ba6a057f..889d9b00c905 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -301,8 +301,9 @@ static inline struct sock *inet_lookup_listener(struct net *net,
 	  ((__sk)->sk_bound_dev_if == (__sdif)))		&&	\
 	 net_eq(sock_net(__sk), (__net)))
 #else /* 32-bit arch */
+/* Break the build if anything tries to use the cookie's name. */
 #define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
-	const int __name __deprecated __attribute__((unused))
+	struct {} __name __attribute__((unused))
 
 #define INET_MATCH(__sk, __net, __cookie, __saddr, __daddr, __ports, __dif, __sdif) \
 	(((__sk)->sk_portpair == (__ports))		&&		\
-- 
2.20.1

