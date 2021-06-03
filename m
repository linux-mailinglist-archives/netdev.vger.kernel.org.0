Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800FC39A050
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 13:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhFCL4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 07:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhFCL4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 07:56:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA0EC06174A;
        Thu,  3 Jun 2021 04:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rMmMb8lDL1Xd3cp2GLBOgmQ/e6xZ8Wp6BwX8zqPGsUg=; b=uxINjj+JqutERZb2g/HO5UqB+j
        tsoa81rI9VZPpREVTTfKmIyZYUSKaTPS0xV8dyDrWVpwwEsSSFqGrYEvvZoVScFHaEdXU1KdvURd/
        +ptMq8/ODkTUe3Dq5OAT4J5foc3sj/2sS1aOHMJdKRq/WgLkVqREhETtBD91WiLtiUQLDOXMb6osE
        4RtjeWHtsuxdLvu9Ax032vOQit+TU6lRh+bXfHX8cdxvMHwf6Ykbd2wXkkXW+NCmLde8vS4tgyM0f
        MUFerQlyFi5KYhckAan8WxHOCbGWcZjy9swY2mH56AtpZRc+QQT/XQiKvca2YxBeLGeDRJEl5An6m
        bLOEJ1KQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:56918 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1lolvd-0002du-6K; Thu, 03 Jun 2021 12:54:25 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1lolvc-0003RM-VE; Thu, 03 Jun 2021 12:54:25 +0100
In-Reply-To: <20210603115316.GR30436@shell.armlinux.org.uk>
References: <20210603115316.GR30436@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH wireless-drivers-next 3/4] net: wlcore: fix bug reading fwlog
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1lolvc-0003RM-VE@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 03 Jun 2021 12:54:24 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With logging enabled, it has been observed that the driver spews
messages such as:

wlcore: ERROR Calculate of clear addr Clear = 204025b0, write = 204015b0

The problem occurs because 204025b0 is the end of the buffer, and
204015b0 is the beginning, and the calculation for "clear"ing the
buffer does not take into account that if we read to the very end
of the ring buffer, we are actually at the beginning of the buffer.

Fix this.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/wireless/ti/wlcore/event.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 875198fb1480..8a67a708c96e 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -84,6 +84,8 @@ int wlcore_event_fw_logger(struct wl1271 *wl)
 	len = min(actual_len, available_len);
 	wl12xx_copy_fwlog(wl, &buffer[start_loc], len);
 	clear_ptr = addr_ptr + start_loc + actual_len;
+	if (clear_ptr == buff_end_ptr)
+		clear_ptr = buff_start_ptr;
 
 	/* Copy any remaining part from beginning of ring buffer */
 	len = actual_len - len;
-- 
2.20.1

