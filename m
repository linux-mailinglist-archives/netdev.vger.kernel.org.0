Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3701D2EA7D2
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 10:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbhAEJpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 04:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbhAEJou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 04:44:50 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B2EC061795;
        Tue,  5 Jan 2021 01:44:10 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id i24so30366757edj.8;
        Tue, 05 Jan 2021 01:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zpRBjTwwbttmw1T4jYOjshcbes1jvp4oKN+HYKTlNQQ=;
        b=F817bh2h/kwTTJY838KD3QDVXnYpZakUnx0VvrVUNsKtvIe0fwdKIVXVXcIo5tqZDm
         MYTa7PP0iDHkedCRo2UJ/VdX1E3OoBVmbDUivU8sm+T3v0/78hq0A1a7JiJWzBvAGcN+
         pkWE5t95lLBFoFT6XN2qiW5XDDkCjyq3sTVFJjnNcfTi0kbq7PPXMG7uyvl2SfCbeJxL
         9rk2WBpc64ElEkPUmTSccBNsSYT//2tGliPejz0D0dmFk8kHX0laCMepY/u2JSG9o1Ia
         HQNIyKFaSUmG5JcVIsBaHDwxYCf+Rr43+psMUa2GGRjWLnv30Y54oPDx44it6u6vobNz
         Z0Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zpRBjTwwbttmw1T4jYOjshcbes1jvp4oKN+HYKTlNQQ=;
        b=QU17W4LkBFZfSPw4PTswHmwiYgCxYYsWCHFlggmXmflQlKBcbe5sRa5NzIaKqNGvmr
         UC3rzkqhzoA5GaN9kepyKVQ4N7EpYawuPmJHHM+EA8TSXuzwo9zwWNKwscuj3OnctIv+
         UUStFVXyxiyjc85iTKY6q3jQkiN/AUyqt8CXFib52DaPserlxPms/gbkKQsi2RXN44Sa
         TBTdQO5VdVI8Ib6kf5+gmWPZcmswK9sD68GXU/mMnC45xCoa5I714PbNwsWhPZS3vZLG
         /O7NTTCftHuEBKc6MX+oDdxnDrkv+MXi8b8mvLYCZUOUpFCCJy3yKlQdUZrmr+jGT21E
         cGSw==
X-Gm-Message-State: AOAM533Q5B8//Vud4fGGRey5QF1wUAEz1o9W8ZVNLM4BT8/dpsElvOJN
        G7XCnrMt9C1mFthvFQL/vkJPZrG+PFg=
X-Google-Smtp-Source: ABdhPJz8/t2oP8zuzYTHR+26DncWBAiGdOujOw9lfva2XU/CVQllvloNkBjbzcR14HhiOPedOj7V+g==
X-Received: by 2002:a05:6402:3546:: with SMTP id f6mr50292986edd.242.1609839848892;
        Tue, 05 Jan 2021 01:44:08 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:5ee:6bfd:b6c9:8fa1? (p200300ea8f06550005ee6bfdb6c98fa1.dip0.t-ipconnect.de. [2003:ea:8f06:5500:5ee:6bfd:b6c9:8fa1])
        by smtp.googlemail.com with ESMTPSA id f8sm44959266eds.19.2021.01.05.01.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 01:44:08 -0800 (PST)
Subject: [PATCH 3/3] r8169: simplify broken parity handling now that PCI core
 takes care
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a6f09e1b-4076-59d1-a4e3-05c5955bfff2@gmail.com>
Message-ID: <0357b4f8-ca14-766c-ba0d-3cd83bdda578@gmail.com>
Date:   Tue, 5 Jan 2021 10:44:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <a6f09e1b-4076-59d1-a4e3-05c5955bfff2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Meanwhile the PCI core disables parity checking for a device that has
broken_parity_status set. Therefore we don't need the quirk any longer
to disable parity checking on the first parity error interrupt.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a8284feb4..1e26b47f5 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4329,20 +4329,6 @@ static void rtl8169_pcierr_interrupt(struct net_device *dev)
 	if (net_ratelimit())
 		netdev_err(dev, "PCI error (cmd = 0x%04x, status_errs = 0x%04x)\n",
 			   pci_cmd, pci_status_errs);
-	/*
-	 * The recovery sequence below admits a very elaborated explanation:
-	 * - it seems to work;
-	 * - I did not see what else could be done;
-	 * - it makes iop3xx happy.
-	 *
-	 * Feel free to adjust to your needs.
-	 */
-	if (pdev->broken_parity_status)
-		pci_cmd &= ~PCI_COMMAND_PARITY;
-	else
-		pci_cmd |= PCI_COMMAND_SERR | PCI_COMMAND_PARITY;
-
-	pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
 
 	rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_PENDING);
 }
-- 
2.30.0


