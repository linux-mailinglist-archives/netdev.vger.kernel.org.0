Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42BCA13304C
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 21:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgAGUHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 15:07:50 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:55461 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728379AbgAGUHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 15:07:50 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MhULz-1jKQPM1LcJ-00eay6; Tue, 07 Jan 2020 21:07:43 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Oleksandr Natalenko <oleksandr@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: wext: avoid gcc -O3 warning
Date:   Tue,  7 Jan 2020 21:07:35 +0100
Message-Id: <20200107200741.3588770-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:OJr2mJSwCElifh7i0B7h1tOzyHAQp2FUNVpAYKr3i1g/pntO5sP
 eZUXHLCDl+k4KqZkBByoHwxeVT/CASxI1iuyW7d2UHnbMxpb2p0+ZG2LqktoShycU9cgl7V
 B0Fq6xQ683cgyVPNqEyOVutBUacfbrL14QHnwv7uuG68Jxih0I0mjsEH9ki37cxRsKWagLJ
 OKQkHehfch217Xf3Twl9g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/elu+XAKXtw=:DQXqmMWVs2DUnsIjgF110Z
 yUQA7xIPowjY/T9udFmw2ijdOwVLH1JoeZLdytihWjXv3ogHwI8v230dSkEaVeggcEI0r1Bn/
 rsHzV2grVlYmEGZ0tqczENFYarIf1KDmAK77++IxutnzHBRuR9kJEAlver5xlITrtlfUoFS1N
 cSkRkQPwszAY0PVa45gfg5S8sbllKkHxq5wAhrLX1n9SQiyAd5h1Q0ASc3tX5QdiEz3urbOX1
 S2xFKf1nAla7OV32ePpzalCY1LJ662ORqaFPl2KLRBB7XwCg9jaQjN5uyRc2JIpsY19a/TbCf
 8ysPWPWPn05cNI3IA2aWgrCToJ0R0RkiONtKNBzr1E2dEe88+Fyr1TDzIB1OZdezcNLladNnP
 EDhbnYm99nQPsiGlJr+LJq4QWe4helWPOPK8S6uBU3cjtYnlo/qRNV7ZG7XLUDb2dRILLC368
 qYHvHUcL5RltRO1IhSzU18GB0NNYHNwUK8JwKmJi+UyUgfjb9tsf40sIG+xHVJNjBfhwtNJ0W
 kxLBYfdhfdnPbYO1CvFzRQbJjxEiZri7hUwtjB5ybPjT+gavSktqNWDAu/jfULVwI8AoK3DM2
 2oEy4YqAYoboT2yYbYvW+x/vXtqTmrGweqxxeOCs0CoW4wuip3B4El+dx/EL50fXoJVQId0zB
 Bi029kDPPOCfrF2V4vMXs0GWNlWGyOvKT4N9H0XQ2z3nssalXkTsEa7BJt8LmI8rMPOnYdwLj
 A2jyzb1dIzEKFJKxkMKr0ZDZoA3hXNySoKWNGu+798c727qf6jJ+fVMlifcVoEBtA0QiiIKUe
 GSoCYi/XnFZp0xTZg9cQaE4XwxURywfposLTFnSY9R5bi7K2bRDGH6oFqkT0Qbr67baI++AWy
 5ez5Lm3fU/M2WeWciIEw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the introduction of CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE_O3,
the wext code produces a bogus warning:

In function 'iw_handler_get_iwstats',
    inlined from 'ioctl_standard_call' at net/wireless/wext-core.c:1015:9,
    inlined from 'wireless_process_ioctl' at net/wireless/wext-core.c:935:10,
    inlined from 'wext_ioctl_dispatch.part.8' at net/wireless/wext-core.c:986:8,
    inlined from 'wext_handle_ioctl':
net/wireless/wext-core.c:671:3: error: argument 1 null where non-null expected [-Werror=nonnull]
   memcpy(extra, stats, sizeof(struct iw_statistics));
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from arch/x86/include/asm/string.h:5,
net/wireless/wext-core.c: In function 'wext_handle_ioctl':
arch/x86/include/asm/string_64.h:14:14: note: in a call to function 'memcpy' declared here

The problem is that ioctl_standard_call() sometimes calls the handler
with a NULL argument that would cause a problem for iw_handler_get_iwstats.
However, iw_handler_get_iwstats never actually gets called that way.

Marking that function as noinline avoids the warning and leads
to slightly smaller object code as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/wireless/wext-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index 5e677dac2a0c..69102fda9ebd 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -657,7 +657,8 @@ struct iw_statistics *get_wireless_stats(struct net_device *dev)
 	return NULL;
 }
 
-static int iw_handler_get_iwstats(struct net_device *		dev,
+/* noinline to avoid a bogus warning with -O3 */
+static noinline int iw_handler_get_iwstats(struct net_device *	dev,
 				  struct iw_request_info *	info,
 				  union iwreq_data *		wrqu,
 				  char *			extra)
-- 
2.20.0

