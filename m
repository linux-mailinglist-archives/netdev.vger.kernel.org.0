Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4819932B
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388346AbfHVMUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 08:20:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34283 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728952AbfHVMUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 08:20:38 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i0m4x-00083J-2M; Thu, 22 Aug 2019 12:20:35 +0000
From:   Colin King <colin.king@canonical.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] mac80211: minstrel_ht: fix infinite loop because supported is not being shifted
Date:   Thu, 22 Aug 2019 13:20:34 +0100
Message-Id: <20190822122034.28664-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the for-loop will spin forever if variable supported is
non-zero because supported is never changed.  Fix this by adding in
the missing right shift of supported.

Addresses-Coverity: ("Infinite loop")
Fixes: 48cb39522a9d ("mac80211: minstrel_ht: improve rate probing for devices with static fallback")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index a01168514840..0ef2633349b5 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -634,7 +634,7 @@ minstrel_ht_rate_sample_switch(struct minstrel_priv *mp,
 		u16 supported = mi->supported[g_idx];
 
 		supported >>= mi->max_tp_rate[0] % MCS_GROUP_RATES;
-		for (i = 0; supported; i++) {
+		for (i = 0; supported; supported >>= 1, i++) {
 			if (!(supported & 1))
 				continue;
 
-- 
2.20.1

