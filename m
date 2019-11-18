Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6995100E59
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfKRVuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:50:01 -0500
Received: from correo.us.es ([193.147.175.20]:45714 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbfKRVte (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 16:49:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5D212EB497
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5060AA7EC8
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 44189A7EC2; Mon, 18 Nov 2019 22:49:31 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3753221FE5;
        Mon, 18 Nov 2019 22:49:26 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 22:49:26 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0739542EE38F;
        Mon, 18 Nov 2019 22:49:25 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 08/18] netfilter: nft_meta: use 64-bit time arithmetic
Date:   Mon, 18 Nov 2019 22:49:04 +0100
Message-Id: <20191118214914.142794-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191118214914.142794-1-pablo@netfilter.org>
References: <20191118214914.142794-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

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
Acked-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 8fd21f436347..8fbea031bd4a 100644
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
2.11.0

