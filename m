Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6319221D6F8
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 15:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbgGMNZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 09:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729927AbgGMNWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 09:22:55 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3C3C061794;
        Mon, 13 Jul 2020 06:22:55 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id p20so17106900ejd.13;
        Mon, 13 Jul 2020 06:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4mtRlJQaHePxtEmxgJ4wlQxNn5L43q/Zka7616zruI8=;
        b=kMSP5L5Flpc6NQRlZYtnLBolHIuDM831m9PhJvg2LNyM/twJSV5iJ8UbM+6MQsdE5M
         CLml5IDPqOPYg6ZN757vdGZAeRzeO8W4v9K37fUtLv49qnF2JfdQKGdreBg10qenXt7f
         brY7Xfw8BL3Hiq4f+z4Ak0QDisXul8aNqNa1gbx8IfSJDXUB4GS7hj3jucg2WpedWTIp
         6t21q38GNrpKaAwB7fXFVRrY9h0regwcQxnbtdfMUz5GL4WX5ij2p1/Q+NVL76aXremr
         WqFYo+vasH+aRxaKKYbzhnAMuMyWzWEAL0HKxZnL226nb5mt6T8dUWFj3y7//RY8J7ss
         bigQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4mtRlJQaHePxtEmxgJ4wlQxNn5L43q/Zka7616zruI8=;
        b=C2K40KXlO4OTFKOjMPDkSVk63FNMIz4kEq3xmHaPzJz/xruc9LAONSP8vLtUEW8jPs
         x3udjglnNgI4QTRto0+jR7WpGxkewmkPcM8Si4B5Tkl3Ok7VspdEw4xDmTkumLFcGoEi
         GhzjEvjEK7/96oQg+lyK26YRyDUPciL9h+1LnpFkh26oukNhDaD4M8qqBgtTDcMx/mXH
         0qDYfV9iL/fi+y7aD16M/zBaha4WVhu6AtEUlHN9MXtcJA3PGBIA5nXHBwoOg9HATcUI
         wl8ufPfMqqkT60OTlfF7cavGMpPSLyZBbV/dY7U1OPhaNotznlT9Pd9lb/KOg2bWMpul
         XSUw==
X-Gm-Message-State: AOAM530KpbpzkzinnEBtmL01bN6antQFu/AinXLUYvT0CmJ9TEFBsT/L
        IaQR15eHvh9WgHyxPd5QVo3f4BFgScCLPQ==
X-Google-Smtp-Source: ABdhPJxBg6NeDOYmyTW5DNO1P5saMhEnmdJjfVEe5tJAB3i+dRIhgcPYOfBUSf1/IW9C6Yjeq+b0UQ==
X-Received: by 2002:a17:906:2b52:: with SMTP id b18mr75601756ejg.158.1594646573741;
        Mon, 13 Jul 2020 06:22:53 -0700 (PDT)
Received: from net.saheed (54007186.dsl.pool.telekom.hu. [84.0.113.134])
        by smtp.gmail.com with ESMTPSA id n9sm11806540edr.46.2020.07.13.06.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 06:22:53 -0700 (PDT)
From:   "Saheed O. Bolarinwa" <refactormyself@gmail.com>
To:     helgaas@kernel.org,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        bjorn@helgaas.com, skhan@linuxfoundation.org,
        linux-pci@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH 12/35] r8169: Tidy Success/Failure checks
Date:   Mon, 13 Jul 2020 14:22:24 +0200
Message-Id: <20200713122247.10985-13-refactormyself@gmail.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200713122247.10985-1-refactormyself@gmail.com>
References: <20200713122247.10985-1-refactormyself@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unnecessary check for 0.

Signed-off-by: "Saheed O. Bolarinwa" <refactormyself@gmail.com>
---
This patch depends on PATCH 11/35

 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 206dac958cb2..79edbc0c4476 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2656,7 +2656,7 @@ static void rtl_csi_access_enable(struct rtl8169_private *tp, u8 val)
 	 * first and if it fails fall back to CSI.
 	 */
 	if (pdev->cfg_size > 0x070f &&
-	    pci_write_config_byte(pdev, 0x070f, val) == 0)
+	    !pci_write_config_byte(pdev, 0x070f, val))
 		return;
 
 	netdev_notice_once(tp->dev,
-- 
2.18.2

