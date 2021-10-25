Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70FB1439592
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbhJYMIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:08:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231512AbhJYMIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 08:08:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D49560F46;
        Mon, 25 Oct 2021 12:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635163549;
        bh=XbL8XaQ+j8qWJFr6k5TpoWRzAyQkgL31WLDyiJCm/xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFYvITElZXPr2Gj3rMTxDsABNP4KwYOghn8z318gs124G+vc+pO7kVpAGRpKKN0oM
         yj3RMK9U8vEFtzrpwkbWrURFnUyTi5RJ9rRZGHzfukuRAvWbeLw3opE7o/D2qqJP5N
         4eCQ4AaX2Mw7dHnzy/MWuvKnwz3shqs0Bi38VFRjG0wxRXx72zCPQacU9bnZXnMDYJ
         XVMfNy+tMTp8JN4Iyre5moqu3+ADXXN/zQ/po9XDc3RHqX0Bea9HOXAdyc42h5AQuu
         xzy6ZM22sRwhJbP9pzFzD5SOmbs1Pxe0+QynG3XTe3D12bOmj07YUmMkohDe3vb+Mb
         3jvqGqjmFE/Iw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyjL-0001aR-Q3; Mon, 25 Oct 2021 14:05:31 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 1/4] ath10k: fix control-message timeout
Date:   Mon, 25 Oct 2021 14:05:19 +0200
Message-Id: <20211025120522.6045-2-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025120522.6045-1-johan@kernel.org>
References: <20211025120522.6045-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 4db66499df91 ("ath10k: add initial USB support")
Cc: stable@vger.kernel.org      # 4.14
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/ath/ath10k/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index 19b9c27e30e2..6d831b098cbb 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -525,7 +525,7 @@ static int ath10k_usb_submit_ctrl_in(struct ath10k *ar,
 			      req,
 			      USB_DIR_IN | USB_TYPE_VENDOR |
 			      USB_RECIP_DEVICE, value, index, buf,
-			      size, 2 * HZ);
+			      size, 2000);
 
 	if (ret < 0) {
 		ath10k_warn(ar, "Failed to read usb control message: %d\n",
-- 
2.32.0

