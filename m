Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D831B310F3D
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 18:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbhBEQOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 11:14:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39774 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbhBEQMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 11:12:17 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1l85Im-0004k3-Ez; Fri, 05 Feb 2021 17:53:52 +0000
From:   Colin King <colin.king@canonical.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W . Linville" <linville@tuxdriver.com>,
        Luis Carlos Cobo <luisca@cozybit.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mac80211: fix potential overflow when multiplying to u32 integers
Date:   Fri,  5 Feb 2021 17:53:52 +0000
Message-Id: <20210205175352.208841-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The multiplication of the u32 variables tx_time and estimated_retx is
performed using a 32 bit multiplication and the result is stored in
a u64 result. This has a potential u32 overflow issue, so avoid this
by casting tx_time to a u64 to force a 64 bit multiply.

Addresses-Coverity: ("Unintentional integer overflow")
Fixes: 050ac52cbe1f ("mac80211: code for on-demand Hybrid Wireless Mesh Protocol")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/mac80211/mesh_hwmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 313eee12410e..3db514c4c63a 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -356,7 +356,7 @@ u32 airtime_link_metric_get(struct ieee80211_local *local,
 	 */
 	tx_time = (device_constant + 10 * test_frame_len / rate);
 	estimated_retx = ((1 << (2 * ARITH_SHIFT)) / (s_unit - err));
-	result = (tx_time * estimated_retx) >> (2 * ARITH_SHIFT);
+	result = ((u64)tx_time * estimated_retx) >> (2 * ARITH_SHIFT);
 	return (u32)result;
 }
 
-- 
2.29.2

