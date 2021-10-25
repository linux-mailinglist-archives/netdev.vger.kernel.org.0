Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EF2439591
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbhJYMIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:08:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232007AbhJYMIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 08:08:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FD4360FBF;
        Mon, 25 Oct 2021 12:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635163549;
        bh=xMgdwVXq0vxWAes60ObugLczjbLvXB6DiTFQdTU8JmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A73Y1ZC7P/77NgTxYISIXh4lHXLBq/YPKLqcl0BJPKYPdpu01/NRDyx2Ds6kPmAVk
         9wG5AkiQVLt7OSH1MSb3PY+sDbu6aFLk1l5uQLc/6RIAMFuveMRdtzdCiWDgzQ5rpp
         Pt763W+GZPQ5qxm/oBT/ik056y0WJz5jhq7vG+3nS+of5GWL1R61VnQA61bDif6Eqs
         ic4pz3KEvuAJdvJFSV3XvQk1caWFqKdqf2Dm4zABfgyUL6rNXw1tR43v/Lu4ntCCJ9
         42YvNuUwm15e062RPcn5LIrcm1awsXxN5laK1/PGrETA/M2QWGnZCn8BDYS2c9IX95
         IdnTiMvNNiCNw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyjL-0001aT-Sz; Mon, 25 Oct 2021 14:05:31 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/4] ath6kl: fix control-message timeout
Date:   Mon, 25 Oct 2021 14:05:20 +0200
Message-Id: <20211025120522.6045-3-johan@kernel.org>
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

Fixes: 241b128b6b69 ("ath6kl: add back beginnings of USB support")
Cc: stable@vger.kernel.org      # 3.4
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index 5372e948e761..bd367b79a4d3 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -907,7 +907,7 @@ static int ath6kl_usb_submit_ctrl_in(struct ath6kl_usb *ar_usb,
 				 req,
 				 USB_DIR_IN | USB_TYPE_VENDOR |
 				 USB_RECIP_DEVICE, value, index, buf,
-				 size, 2 * HZ);
+				 size, 2000);
 
 	if (ret < 0) {
 		ath6kl_warn("Failed to read usb control message: %d\n", ret);
-- 
2.32.0

