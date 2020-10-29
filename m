Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2344E29F7CE
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbgJ2WYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:24:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43943 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2WYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 18:24:14 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kYGL1-0004wp-S8; Thu, 29 Oct 2020 22:24:07 +0000
From:   Colin King <colin.king@canonical.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tova Mussai <tova.mussai@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] nl80211/cfg80211: fix potential infinite loop
Date:   Thu, 29 Oct 2020 22:24:07 +0000
Message-Id: <20201029222407.390218-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The for-loop iterates with a u8 loop counter and compares this
with the loop upper limit of request->n_ssids which is an int type.
There is a potential infinite loop if n_ssids is larger than the
u8 loop counter, so fix this by making the loop counter an int.

Addresses-Coverity: ("Infinite loop")
Fixes: c8cb5b854b40 ("nl80211/cfg80211: support 6 GHz scanning")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 8d0e49c46db3..3409f37d838b 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -694,7 +694,7 @@ static  void cfg80211_scan_req_add_chan(struct cfg80211_scan_request *request,
 static bool cfg80211_find_ssid_match(struct cfg80211_colocated_ap *ap,
 				     struct cfg80211_scan_request *request)
 {
-	u8 i;
+	int i;
 	u32 s_ssid;
 
 	for (i = 0; i < request->n_ssids; i++) {
-- 
2.27.0

