Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0690B39A04E
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 13:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhFCL4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 07:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhFCL4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 07:56:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FBDC06174A;
        Thu,  3 Jun 2021 04:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iCZgyxm1paQyg/jkZZSAfP4vkHnjKLLkPB9H0ede8xA=; b=dYBJxB5fn/2z3aPUKQkcQ/KgX/
        5r7SAqAEL95Me3HSN2YNgcLQ45dBEsVEBYBBnwxkbZHuIIP18V1nLF767nG4vSaa4N5HJw+DYuh75
        ZYZ+L22iSLIt4ZExdo+kCLHkSG3h8OwJw3IzHKfyFH7PEgj9klXH4mHCQ0rDRHMQbgLEct3sG4Nf3
        i0z4Y6V4Ez4jnk8u54h03I/Gzp3k/PjtTWFXZU2+OclNx2hi9SKSnp/jJAk4s40YfDSc5JCiUbz14
        nD8PRF06m6Q9EZ7hBlPEmfT9yKThyVsXWz9ApkpgK6QJ65rBR7xv3emRBTB6l7BEre+Hn7ab/tgpg
        ltnWKcZA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:56916 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1lolvY-0002df-1s; Thu, 03 Jun 2021 12:54:20 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1lolvX-0003R3-RE; Thu, 03 Jun 2021 12:54:19 +0100
In-Reply-To: <20210603115316.GR30436@shell.armlinux.org.uk>
References: <20210603115316.GR30436@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH wireless-drivers-next 2/4] net: wlcore: make some of the fwlog
 calculations more obvious
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1lolvX-0003R3-RE@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 03 Jun 2021 12:54:19 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make some of the fwlog calculations more obvious by calculating bits
that get used and documenting what they are. Validate the read pointer
while we're at it to ensure we do not overflow the data block we have
allocated and read.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/wireless/ti/wlcore/event.c | 43 +++++++++++++++++---------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index a5c261affdc7..875198fb1480 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -29,11 +29,13 @@ int wlcore_event_fw_logger(struct wl1271 *wl)
 	u8  *buffer;
 	u32 internal_fw_addrbase = WL18XX_DATA_RAM_BASE_ADDRESS;
 	u32 addr = WL18XX_LOGGER_SDIO_BUFF_ADDR;
-	u32 end_buff_addr = WL18XX_LOGGER_SDIO_BUFF_ADDR +
-				WL18XX_LOGGER_BUFF_OFFSET;
+	u32 addr_ptr;
+	u32 buff_start_ptr;
+	u32 buff_read_ptr;
+	u32 buff_end_ptr;
 	u32 available_len;
 	u32 actual_len;
-	u32 clear_addr;
+	u32 clear_ptr;
 	size_t len;
 	u32 start_loc;
 
@@ -59,17 +61,29 @@ int wlcore_event_fw_logger(struct wl1271 *wl)
 	if (actual_len == 0)
 		goto free_out;
 
-	start_loc = (le32_to_cpu(fw_log.buff_read_ptr) -
-			internal_fw_addrbase) - addr;
-	end_buff_addr += le32_to_cpu(fw_log.max_buff_size);
-	available_len = end_buff_addr -
-			(le32_to_cpu(fw_log.buff_read_ptr) -
-				 internal_fw_addrbase);
+	/* Calculate the internal pointer to the fwlog structure */
+	addr_ptr = internal_fw_addrbase + addr;
 
-	/* Copy initial part from end of ring buffer */
+	/* Calculate the internal pointers to the start and end of log buffer */
+	buff_start_ptr = addr_ptr + WL18XX_LOGGER_BUFF_OFFSET;
+	buff_end_ptr = buff_start_ptr + le32_to_cpu(fw_log.max_buff_size);
+
+	/* Read the read pointer and validate it */
+	buff_read_ptr = le32_to_cpu(fw_log.buff_read_ptr);
+	if (buff_read_ptr < buff_start_ptr ||
+	    buff_read_ptr >= buff_end_ptr) {
+		wl1271_error("buffer read pointer out of bounds: %x not in (%x-%x)\n",
+			     buff_read_ptr, buff_start_ptr, buff_end_ptr);
+		goto free_out;
+	}
+
+	start_loc = buff_read_ptr - addr_ptr;
+	available_len = buff_end_ptr - buff_read_ptr;
+
+	/* Copy initial part up to the end of ring buffer */
 	len = min(actual_len, available_len);
 	wl12xx_copy_fwlog(wl, &buffer[start_loc], len);
-	clear_addr = addr + start_loc + actual_len + internal_fw_addrbase;
+	clear_ptr = addr_ptr + start_loc + actual_len;
 
 	/* Copy any remaining part from beginning of ring buffer */
 	len = actual_len - len;
@@ -77,14 +91,13 @@ int wlcore_event_fw_logger(struct wl1271 *wl)
 		wl12xx_copy_fwlog(wl,
 				  &buffer[WL18XX_LOGGER_BUFF_OFFSET],
 				  len);
-		clear_addr = addr + WL18XX_LOGGER_BUFF_OFFSET + len +
-				internal_fw_addrbase;
+		clear_ptr = addr_ptr + WL18XX_LOGGER_BUFF_OFFSET + len;
 	}
 
 	/* double check that clear address and write pointer are the same */
-	if (clear_addr != le32_to_cpu(fw_log.buff_write_ptr)) {
+	if (clear_ptr != le32_to_cpu(fw_log.buff_write_ptr)) {
 		wl1271_error("Calculate of clear addr Clear = %x, write = %x",
-			     clear_addr, le32_to_cpu(fw_log.buff_write_ptr));
+			     clear_ptr, le32_to_cpu(fw_log.buff_write_ptr));
 	}
 
 	/* indicate FW about Clear buffer */
-- 
2.20.1

