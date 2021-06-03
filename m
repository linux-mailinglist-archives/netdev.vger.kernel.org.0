Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C8E39A04C
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 13:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhFCL4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 07:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhFCL4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 07:56:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CBBC06174A;
        Thu,  3 Jun 2021 04:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=O2cdUi/niT9ziA8Lks2lUYRIHDeA3nWLHeK7WjaSfxc=; b=GWffGhs65KnQIoeNIeKbwNTHVF
        LF9/9vy0I/sGi2P3vhr/G3K6Sma7VHSa9/e4OR5C0HMvpPvEK1U7qWAVzLjqYxxM/epUQ2DuW1iMM
        YZCPuBU1+T/OStPO4Fg6dqOSvlImsGxQURNz0mEf36DK2VQG2xPkAep/0H39ijh0z0dJxLfy85msZ
        iBiWTmGBdakPhVOWu1ILfPKqcFW74eHcmA3a3N1kbPX1AYRFboHRsyf+BGvju8tnTJRL98V3n1eW+
        poKMl7qBZrj3BrCYUKDxmuTptGKz/DQtRTQPtmrNs7Qdx9pmJlzDfTxHClwxnP8flWVX1JIECh7yE
        zOwO+UfA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:56914 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1lolvS-0002dR-UG; Thu, 03 Jun 2021 12:54:15 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1lolvS-0003Ql-NJ; Thu, 03 Jun 2021 12:54:14 +0100
In-Reply-To: <20210603115316.GR30436@shell.armlinux.org.uk>
References: <20210603115316.GR30436@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH wireless-drivers-next 1/4] net: wlcore: tidy up use of
 fw_log.actual_buff_size
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1lolvS-0003Ql-NJ@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 03 Jun 2021 12:54:14 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tidy up the use of fw_log.actual_buff_size - rather than reading it
multiple times and applying the endian conversion, read it once into
actual_len and use that instead.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/wireless/ti/wlcore/event.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index a68bbadae043..a5c261affdc7 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -40,7 +40,7 @@ int wlcore_event_fw_logger(struct wl1271 *wl)
 	buffer = kzalloc(WL18XX_LOGGER_SDIO_BUFF_MAX, GFP_KERNEL);
 	if (!buffer) {
 		wl1271_error("Fail to allocate fw logger memory");
-		fw_log.actual_buff_size = cpu_to_le32(0);
+		actual_len = 0;
 		goto out;
 	}
 
@@ -49,30 +49,30 @@ int wlcore_event_fw_logger(struct wl1271 *wl)
 	if (ret < 0) {
 		wl1271_error("Fail to read logger buffer, error_id = %d",
 			     ret);
-		fw_log.actual_buff_size = cpu_to_le32(0);
+		actual_len = 0;
 		goto free_out;
 	}
 
 	memcpy(&fw_log, buffer, sizeof(fw_log));
 
-	if (le32_to_cpu(fw_log.actual_buff_size) == 0)
+	actual_len = le32_to_cpu(fw_log.actual_buff_size);
+	if (actual_len == 0)
 		goto free_out;
 
-	actual_len = le32_to_cpu(fw_log.actual_buff_size);
 	start_loc = (le32_to_cpu(fw_log.buff_read_ptr) -
 			internal_fw_addrbase) - addr;
 	end_buff_addr += le32_to_cpu(fw_log.max_buff_size);
 	available_len = end_buff_addr -
 			(le32_to_cpu(fw_log.buff_read_ptr) -
 				 internal_fw_addrbase);
-	actual_len = min(actual_len, available_len);
-	len = actual_len;
 
+	/* Copy initial part from end of ring buffer */
+	len = min(actual_len, available_len);
 	wl12xx_copy_fwlog(wl, &buffer[start_loc], len);
-	clear_addr = addr + start_loc + le32_to_cpu(fw_log.actual_buff_size) +
-			internal_fw_addrbase;
+	clear_addr = addr + start_loc + actual_len + internal_fw_addrbase;
 
-	len = le32_to_cpu(fw_log.actual_buff_size) - len;
+	/* Copy any remaining part from beginning of ring buffer */
+	len = actual_len - len;
 	if (len) {
 		wl12xx_copy_fwlog(wl,
 				  &buffer[WL18XX_LOGGER_BUFF_OFFSET],
@@ -93,7 +93,7 @@ int wlcore_event_fw_logger(struct wl1271 *wl)
 free_out:
 	kfree(buffer);
 out:
-	return le32_to_cpu(fw_log.actual_buff_size);
+	return actual_len;
 }
 EXPORT_SYMBOL_GPL(wlcore_event_fw_logger);
 
-- 
2.20.1

