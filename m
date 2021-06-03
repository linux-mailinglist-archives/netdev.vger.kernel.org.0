Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F229F39A052
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 13:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhFCL4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 07:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhFCL4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 07:56:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E9BC06174A;
        Thu,  3 Jun 2021 04:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xfMTUMgFb19K+951nvw9QxbgQohrI+jLDgQ/1t2aBP0=; b=vNfIjQX4uAJDatTmvDdBotIBpy
        0ZzsJpSfuq1qzFhQ1DgOmGqF48evrb6aqO9NGitJvit8OsQqMHwQEhQSdrq7ErSzXFv2JChUF71E9
        s1kBkCN4OCXwj4OIj12jCW8enBG1K2CnMxdFcbpOBnMxf7962M1Yuvp4Y/NWaqeTmpmY2yiwLfJ3E
        XVCCEfZN8O7Mk+PYxHGCkkqmosQD9FERc80Gu0sViwbmrm8FgNF85aB8v4y/jhLmNautgKsiAszgr
        t3YSo7mA2dqLzL4HEiCCSmIQogN5KgO0aTpkUIEbUJQQgSo8TJ+xQnv1FGttPFkBk7Q2/tol5IoaG
        vJ0wBaAQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:56920 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1lolvi-0002e9-Ck; Thu, 03 Jun 2021 12:54:30 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1lolvi-0003Ri-39; Thu, 03 Jun 2021 12:54:30 +0100
In-Reply-To: <20210603115316.GR30436@shell.armlinux.org.uk>
References: <20210603115316.GR30436@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH wireless-drivers-next 4/4] net: wlcore: fix read pointer
 update
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1lolvi-0003Ri-39@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 03 Jun 2021 12:54:30 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When reading the fw_log structure from the device's memory, we could
race with the firmware updating the actual_buff_size and buff_write_ptr
members of this structure. This would lead to bytes being dropped from
the log.

Fix this by writing back the actual - now fixed - clear_ptr which
reflects where we read up to in the buffer.

This also means that we must not check that the clear_ptr matches the
current write pointer, so remove that check.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/wireless/ti/wlcore/event.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 8a67a708c96e..46ab69eab26a 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -96,15 +96,9 @@ int wlcore_event_fw_logger(struct wl1271 *wl)
 		clear_ptr = addr_ptr + WL18XX_LOGGER_BUFF_OFFSET + len;
 	}
 
-	/* double check that clear address and write pointer are the same */
-	if (clear_ptr != le32_to_cpu(fw_log.buff_write_ptr)) {
-		wl1271_error("Calculate of clear addr Clear = %x, write = %x",
-			     clear_ptr, le32_to_cpu(fw_log.buff_write_ptr));
-	}
-
-	/* indicate FW about Clear buffer */
+	/* Update the read pointer */
 	ret = wlcore_write32(wl, addr + WL18XX_LOGGER_READ_POINT_OFFSET,
-			     fw_log.buff_write_ptr);
+			     clear_ptr);
 free_out:
 	kfree(buffer);
 out:
-- 
2.20.1

