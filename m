Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B396F9FAC
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 01:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfKMA6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 19:58:35 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42572 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbfKMA6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 19:58:35 -0500
Received: by mail-pl1-f194.google.com with SMTP id j12so282136plt.9
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 16:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wtf4tEXNRPFn/5BW+zWiHNiUI7IacNZ8AQ3ioE6MO8g=;
        b=edAPCHnv7NPYhNea7NPMLMwQUqRI4LZYIv+/gMYnbqxt7dZsFJQTWgXWWWI1D7ilpO
         un2/eQe93iI6HOfW55rY106m3spgMGPYOVZaybghHH5YhPqvAGapAm0IYpnVs+XXN8wu
         /kUjVukqikUk2P4Mws3PYm0ix5Dc1Wl1Otjck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wtf4tEXNRPFn/5BW+zWiHNiUI7IacNZ8AQ3ioE6MO8g=;
        b=GJU1SX5aynwN/tweHkDqTO5iVxzOyf/o1lvckb8eiad/RjbNUWCC2Phb8AItg1B3Bd
         1JoQC6XhbkIXb0NoD9si/vqr4frDWmlJcHhdEjkJOcrmEa5Xsohfu/0Hu7fvLQsu9J9L
         U953nAF5EHkevzB/WmwFXbulmTMwfGTc8reTH8c3lA4yIRxBcKflZmtoedxhCBOVx4+S
         TYLAMdN78IIHP3YnQf5yIfXrt/nvOOFGbqzbxydakC4MFC5xrsUdbezOfZgh4GkrjX1c
         XxDPZgEhEvx9YXkTzO9eop0jLJMoX1NRsjN18s70ma9SwgSVQLwMVBxll0YDqwkd/3Sz
         qeeg==
X-Gm-Message-State: APjAAAWxkNZXPtMwmdntP1BaJR8wpryf0FwHORQYAjUOsNEwOr6eFozm
        4o/EJCNwiVdDao8XAIWWs5Q2Kw==
X-Google-Smtp-Source: APXvYqyevxTtdWEuDOk9Qy55ZJEOn6FrL+cJ/ZfQv6kJ8tNlBb5Cy7o7jr7vpACfNHVIyr1Dl82VwQ==
X-Received: by 2002:a17:902:b28b:: with SMTP id u11mr718853plr.207.1573606714514;
        Tue, 12 Nov 2019 16:58:34 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id p3sm175519pfb.163.2019.11.12.16.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 16:58:33 -0800 (PST)
From:   Brian Norris <briannorris@chromium.org>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>,
        Chun-Hao Lin <hau@realtek.com>
Subject: [PATCH] [RFC] r8169: check for valid MAC before clobbering
Date:   Tue, 12 Nov 2019 16:58:16 -0800
Message-Id: <20191113005816.37084-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have some old systems with RTL8168g Ethernet, where the BIOS (based on
Coreboot) programs the MAC address into the MAC0 registers (at offset
0x0 and 0x4). The relevant Coreboot source is publicly available here:

https://review.coreboot.org/cgit/coreboot.git/tree/src/mainboard/google/jecht/lan.c?h=4.10#n139

(The BIOS is built off a much older branch, but the code is effectively
the same.)

Note that this was apparently the recommended solution in an application
note at the time (I have a copy, but it's not marked for redistribution
:( ), with no mention of the method used in rtl_read_mac_address().

The result is that ever since commit 89cceb2729c7 ("r8169:add support
more chips to get mac address from backup mac address register"), my MAC
address changes to use an address I never intended.

Unfortunately, these commits don't really provide any documentation, and
I'm not sure when the recommendation actually changed. So I'm sending
this as RFC, in case I can get any tips from Realtek on how to avoid
breaking compatibility like this.

I'll freely admit that the devices in question are currently pinned to
an ancient kernel. We're only recently testing newer kernels on these
devices, which brings me here.

I'll also admit that I don't have much means to test this widely, and
I'm not sure what implicit behaviors other systems were depending on
along the way.

Fixes: 89cceb2729c7 ("r8169:add support more chips to get mac address from backup mac address register")
Fixes: 6e1d0b898818 ("r8169:add support for RTL8168H and RTL8107E")
Cc: Chun-Hao Lin <hau@realtek.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c4e961ea44d5..94067cf30514 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -7031,11 +7031,14 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
 	if (!rc)
 		goto done;
 
-	rtl_read_mac_address(tp, mac_addr);
+	/* Check first to see if (e.g.) bootloader already programmed
+	 * something.
+	 */
+	rtl_read_mac_from_reg(tp, mac_addr, MAC0);
 	if (is_valid_ether_addr(mac_addr))
 		goto done;
 
-	rtl_read_mac_from_reg(tp, mac_addr, MAC0);
+	rtl_read_mac_address(tp, mac_addr);
 	if (is_valid_ether_addr(mac_addr))
 		goto done;
 
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

