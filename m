Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 675EE108EC
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfEAOTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:19:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48450 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfEAOTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:19:52 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hLq5J-000340-G4; Wed, 01 May 2019 14:19:45 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] rtw88: fix shift of more than 32 bits of a integer
Date:   Wed,  1 May 2019 15:19:45 +0100
Message-Id: <20190501141945.22522-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the shift of an integer value more than 32 bits can
occur when nss is more than 32.  Fix this by making the integer
constants unsigned long longs before shifting and bit-wise or'ing
with the u64 ra_mask to avoid the undefined shift behaviour.

Addresses-Coverity: ("Bad shift operation")
Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtw88/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 9893e5e297e3..6304082361a7 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -363,13 +363,13 @@ static u64 get_vht_ra_mask(struct ieee80211_sta *sta)
 		vht_mcs_cap = mcs_map & 0x3;
 		switch (vht_mcs_cap) {
 		case 2: /* MCS9 */
-			ra_mask |= 0x3ff << nss;
+			ra_mask |= 0x3ffULL << nss;
 			break;
 		case 1: /* MCS8 */
-			ra_mask |= 0x1ff << nss;
+			ra_mask |= 0x1ffULL << nss;
 			break;
 		case 0: /* MCS7 */
-			ra_mask |= 0x0ff << nss;
+			ra_mask |= 0x0ffULL << nss;
 			break;
 		default:
 			break;
-- 
2.20.1

