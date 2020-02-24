Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE3D16B272
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgBXVaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:30:19 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41703 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728285AbgBXV3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:29:47 -0500
Received: by mail-wr1-f66.google.com with SMTP id c9so12178238wrw.8;
        Mon, 24 Feb 2020 13:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eyXZbYhJwbPUHpTlxOFb8ilZjqXa8eHWzE7fBgVE9Xk=;
        b=n7n8imi7gQdweDLiDbFnhIcUUDtEaLFXj2qeQNp6pTvAIy1EcLsZkYYJZpVnbMG2gn
         M7s2XTjaZ5/jsuBQ373r3+inBxMUszQI3B/SqABEcg6KjtGd9GSuo6lwW5H9us9ad3vW
         nNnxZv63TicKwc4nsNFFfxUTLLVT4vZ3kIzw8QF/zvSKNj+YXdMjD4yZswK/laS21u7Q
         Z2Lql0DAF7MB7VH1qvSDkOOi5iOrgh5JfW/FXWg3PgK4DfiW3LL39Juh5zg5a8Fjgae1
         9MOTWSkWDGvfMB/aLvhFsfPObiv9r8pZWIQxFz/3dVEjv2vYKZEsk7ObpmsXt0Qb0TlK
         Q25A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eyXZbYhJwbPUHpTlxOFb8ilZjqXa8eHWzE7fBgVE9Xk=;
        b=pQxM122Z8nyJlJz/vemNV9Y+VIAfZoaMrXvJlJo4TUK3GdnpQxm7lG4vVIVer3xaQ3
         qBuqF/FH7VDG4sZ4cGOAzF8FyLZ0gNAe6cEebUpFz1u+adbjesiN7YRRiabyAGGV5W/y
         HI48vj7k8xPJNoxoYuMt/vF5CenT2bG7VyBLcLuulkGaK9bTmBIpG7VNxnr4p+sVN0FF
         QltdTvGxoVouU4UHTuH7o1nL//YSy/FOvyy8A9Ja3gpfS705/uO/uAqUWXCGz96PVtaC
         7ecK6uMVD8Nr1M7hFixrA2MhjUXjQ4pyE5IysTp3UFF3eZbb+JIbxC9mIWMZBRNJCeju
         yjpQ==
X-Gm-Message-State: APjAAAUF0suY3rQz+ldddwm4olCG7+JnaaK2DqWZIg7gRqoVK0xc2KwG
        bxSEqTKgTk4oDHobTg2suXx7qmsL
X-Google-Smtp-Source: APXvYqy4xhSEVIXkYIT9EM3xBwNhaWhl3HZlWy1rd1Lo6RoOnb2NsXoKMtkujwZ7+opfnF5B0zDNug==
X-Received: by 2002:a5d:6082:: with SMTP id w2mr68730558wrt.300.1582579784965;
        Mon, 24 Feb 2020 13:29:44 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:3d90:eff:31bc:c6a9? (p200300EA8F2960003D900EFF31BCC6A9.dip0.t-ipconnect.de. [2003:ea:8f29:6000:3d90:eff:31bc:c6a9])
        by smtp.googlemail.com with ESMTPSA id a13sm3041882wrt.55.2020.02.24.13.29.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 13:29:44 -0800 (PST)
Subject: [PATCH 3/8] r8169: use pci_status_get_and_clear_errors
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <5939f711-92aa-e7ed-2a26-4f1e4169f786@gmail.com>
Message-ID: <de35cc1c-39a1-9750-962b-cca832d98901@gmail.com>
Date:   Mon, 24 Feb 2020 22:24:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <5939f711-92aa-e7ed-2a26-4f1e4169f786@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new helper pci_status_get_and_clear_errors() to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index f081007a2..4495a3cf9 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4357,13 +4357,15 @@ static void rtl8169_pcierr_interrupt(struct net_device *dev)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 	struct pci_dev *pdev = tp->pci_dev;
-	u16 pci_status, pci_cmd;
+	int pci_status_errs;
+	u16 pci_cmd;
 
 	pci_read_config_word(pdev, PCI_COMMAND, &pci_cmd);
-	pci_read_config_word(pdev, PCI_STATUS, &pci_status);
 
-	netif_err(tp, intr, dev, "PCI error (cmd = 0x%04x, status = 0x%04x)\n",
-		  pci_cmd, pci_status);
+	pci_status_errs = pci_status_get_and_clear_errors(pdev);
+
+	netif_err(tp, intr, dev, "PCI error (cmd = 0x%04x, status_errs = 0x%04x)\n",
+		  pci_cmd, pci_status_errs);
 
 	/*
 	 * The recovery sequence below admits a very elaborated explanation:
@@ -4380,11 +4382,6 @@ static void rtl8169_pcierr_interrupt(struct net_device *dev)
 
 	pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
 
-	pci_write_config_word(pdev, PCI_STATUS,
-		pci_status & (PCI_STATUS_DETECTED_PARITY |
-		PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_REC_MASTER_ABORT |
-		PCI_STATUS_REC_TARGET_ABORT | PCI_STATUS_SIG_TARGET_ABORT));
-
 	rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_PENDING);
 }
 
-- 
2.25.1


