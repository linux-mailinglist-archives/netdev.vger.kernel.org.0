Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC50F5D1E7
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 16:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfGBOkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 10:40:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53878 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfGBOkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 10:40:31 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hiJxK-0004Hn-VT; Tue, 02 Jul 2019 14:40:27 +0000
From:   Colin King <colin.king@canonical.com>
To:     Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] wil6210: fix wil_cid_valid with negative cid values
Date:   Tue,  2 Jul 2019 15:40:26 +0100
Message-Id: <20190702144026.13013-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are several occasions where a negative cid value is passed
into wil_cid_valid and this is converted into a u8 causing the
range check of cid >= 0 to always succeed.  Fix this by making
the cid argument an int to handle any -ve error value of cid.

An example of this behaviour is in wil_cfg80211_dump_station,
where cid is assigned -ENOENT if the call to wil_find_cid_by_idx
fails, and this -ve value is passed to wil_cid_valid.  I believe
that the conversion of -ENOENT to the u8 value 254 which is
greater than wil->max_assoc_sta causes wil_find_cid_by_idx to
currently work fine, but I think is by luck and not the
intended behaviour.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/wil6210/wil6210.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 6f456b311a39..25a1adcb38eb 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -1144,7 +1144,7 @@ static inline void wil_c(struct wil6210_priv *wil, u32 reg, u32 val)
 /**
  * wil_cid_valid - check cid is valid
  */
-static inline bool wil_cid_valid(struct wil6210_priv *wil, u8 cid)
+static inline bool wil_cid_valid(struct wil6210_priv *wil, int cid)
 {
 	return (cid >= 0 && cid < wil->max_assoc_sta);
 }
-- 
2.20.1

