Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30475F5A28
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732655AbfKHVgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:36:32 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:40285 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731657AbfKHVgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:36:32 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MHXSD-1ig8Ef1y1B-00DYFh; Fri, 08 Nov 2019 22:36:12 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ander Juaristi <a@juaristi.eus>, wenxu <wenxu@ucloud.cn>,
        Thomas Gleixner <tglx@linutronix.de>,
        Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH 09/16] netfilter: nft_meta: use 64-bit time arithmetic
Date:   Fri,  8 Nov 2019 22:32:47 +0100
Message-Id: <20191108213257.3097633-10-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191108213257.3097633-1-arnd@arndb.de>
References: <20191108213257.3097633-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:8e4BtkTZhkDHnhj4em5WE6DJ2Vkq2Wh8mzdxKAtzODBb4B8f/ed
 1DGYs7ESWLEtqmT/CcVkHt+/jTl1TdrlCbYVhmDWsfDO6ZSQ/WOUgNlu6NcnJYc1TIxaznY
 ICGDL51il9EAV1ONkEj2C3NvH/5CeXp/Ah0RZdx3J8g4pFdkn0H2eqIASfMU4ZCCfw4FYqq
 mIeUVaqKsjByJJ274lYZw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:BXMIyk7bYig=:/XFifkUlnyQ21O7sbEHUKu
 Nd04r+p1qEyeBSJA6OQQIt0C0EEJhrJu5ULg7ArJrDLL6Sc+zGcRT2eBCMuyKOVu2pbT3y/KO
 Qjz3kLq+YSfMw05N8pByhJ5Sgk6lAhl+XHfMQJ47ws5al9fl6GCjo6LjmhfQj6KLsM+hiIxBk
 7MdHAuoWEcT39E81h/0I9+oL89nPaFCLqPnZwTmSF/FWjpqM8nOSRaiwqQ3i4wCeLjz5qpSK/
 Xlz8ivOmvP6eDQybCUGKiusaZob3Qu5J1HT+iCkdwbkCW7VezbiowHMrx6+YAaoWZ7oGqMCjI
 WNzx2cn+FrVgdxhuePz8qk4yxVoexAwMSYFO8tqcSk2NNCPR+l98/Typ+IDnPBTB6/aYvvFTc
 FLnYlQSfhTbqhm7CRlSAD/Jn2cZr4mJFwenXeyx9jqGvK0epNm3bI4T1s8AXxUdDpZOtAmxsN
 ytctvQbk+kMS6sen/4zxK+MYwgkH4dA1S1tCPAcGk6OnxFcf5hVGCU5G3Oa8gD1SlOelgFWuh
 3k44ZAjp5/YcrPu3k0aytdVAsWbsZGtej2QVB3mX67/nuj7nS+U6fsqXFr2WEiIFCw2B7cThx
 ZEYPdBFwbvKL8mL9h+2pzE2OpEcIW6u5gIxgnJCyNPHK5LD4DWbgvmyq65jrxITTE7ZKx3e43
 G4moguidGfoX3WGwk4MIoD2sLEVWdV0CW5uafFnB/gUYt9Glob0OWX1xCp8kE4ecBHLbTw1be
 QRiyX7UFJf7QgjYwIpVuhdzqNhLTUyjg8kL8LUDxKbM9tKn/s6AOmtXzmJCtRnnPNXq/G3bxT
 4DDfDS0cJZl/SuY3dszyqTxUmYYoADpxh/WaDiqwS6tX5SK+eGIVmXzM1p/bDz9QrQ3o4OdXn
 +8OEInWfu8d0Wk8i3ssw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 32-bit architectures, get_seconds() returns an unsigned 32-bit
time value, which also matches the type used in the nft_meta
code. This will not overflow in year 2038 as a time_t would, but
it still suffers from the overflow problem later on in year 2106.

Change this instance to use the time64_t type consistently
and avoid the deprecated get_seconds().

The nft_meta_weekday() calculation potentially gets a little slower
on 32-bit architectures, but now it has the same behavior as on
64-bit architectures and does not overflow.

Fixes: 63d10e12b00d ("netfilter: nft_meta: support for time matching")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/netfilter/nft_meta.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 317e3a9e8c5b..dda1e55d5801 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -33,19 +33,19 @@
 
 static DEFINE_PER_CPU(struct rnd_state, nft_prandom_state);
 
-static u8 nft_meta_weekday(unsigned long secs)
+static u8 nft_meta_weekday(time64_t secs)
 {
 	unsigned int dse;
 	u8 wday;
 
 	secs -= NFT_META_SECS_PER_MINUTE * sys_tz.tz_minuteswest;
-	dse = secs / NFT_META_SECS_PER_DAY;
+	dse = div_u64(secs, NFT_META_SECS_PER_DAY);
 	wday = (4 + dse) % NFT_META_DAYS_PER_WEEK;
 
 	return wday;
 }
 
-static u32 nft_meta_hour(unsigned long secs)
+static u32 nft_meta_hour(time64_t secs)
 {
 	struct tm tm;
 
@@ -250,10 +250,10 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		nft_reg_store64(dest, ktime_get_real_ns());
 		break;
 	case NFT_META_TIME_DAY:
-		nft_reg_store8(dest, nft_meta_weekday(get_seconds()));
+		nft_reg_store8(dest, nft_meta_weekday(ktime_get_real_seconds()));
 		break;
 	case NFT_META_TIME_HOUR:
-		*dest = nft_meta_hour(get_seconds());
+		*dest = nft_meta_hour(ktime_get_real_seconds());
 		break;
 	default:
 		WARN_ON(1);
-- 
2.20.0

