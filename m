Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486EA2EBCFB
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 12:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbhAFLHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 06:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbhAFLHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 06:07:19 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514CAC06134D;
        Wed,  6 Jan 2021 03:06:39 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id lt17so4535739ejb.3;
        Wed, 06 Jan 2021 03:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LMhEikvRUZQaIKyyHYQPd9FehVZ9OCrs1+Guuen9CX0=;
        b=X4hGYmXPkT7Y/gFWjq2R6usf6mtSbqmYvDxFIVpAsyNrdel18QRQ9NKh0HrcZf2JND
         KO+7W1KfW/rMUox9uRp4D9cNWB3ft0Sv1vCO9rJaAE8BShbC0aqQncL6yqBAAeGV7sOQ
         ewL4CpLiRVfd6qelJ0pJlakxNKDC9hSHPvabsHiTeVk3Un7PkdoAqYa3IcPeMHceYJkJ
         dExoZRtYYyYisFh/1CQTxNUcDVa12tvTPjmRm5pSr3GVzwbMMyntvxAdDLcWKfFsP3nf
         A7y4eBftUUsxTmgrfKopE8TiCZ0/hEvQOkBu230ZSKKmVUrRglEniQDXLE82Qlu2VEcu
         +N1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LMhEikvRUZQaIKyyHYQPd9FehVZ9OCrs1+Guuen9CX0=;
        b=OMayDP+FFJQ7giIdv/VJtWiOD1K1dN5YTetovhZ+zyD50jZz4v+9FvGhiXU0wrH8W1
         rWfGYSYW0g4TemlV5RRwfXUV2nDjd8jeFVOQus5QV+OhtgQ5ci/G2j8jJqKranpm1/+j
         v382ww3u6tTX4JPpE9zpPh60TxEm/+MlUhjvdcoBPYRLJAFoR7O2HoRXas4P0ZeHf82d
         HYnAYRXAurN9E7A8wq0ZmtfhsvorlXFa/jZUNMsC3CbglkpK9Ja3nmGPUGQA5SPnTa8n
         envTzrTANACmFslQRqpnMB7ePvSnmn3G9RDCNuXFtS/nm2o5uBaJAtCUQKzaH91Ahuio
         5UBw==
X-Gm-Message-State: AOAM530tUjjpIal5+05ibGjPW4G93QeBxOv2JN5BPOuvsww7U7arEGoq
        1QFbk7lqwEHnUbALN5tTIGdyGRlnyxg=
X-Google-Smtp-Source: ABdhPJxWTZ5/H6x9x1nURlGcN1s3NA5QJ6dGN5bNgAW7aPmczyiNhSd4mzPg43C0epaDGwiI2Xj2vA==
X-Received: by 2002:a17:906:cd06:: with SMTP id oz6mr2526596ejb.25.1609931197807;
        Wed, 06 Jan 2021 03:06:37 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id m7sm1090983ejr.119.2021.01.06.03.06.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 03:06:37 -0800 (PST)
Subject: [PATCH v2 3/3] r8169: simplify broken parity handling now that PCI
 core takes care
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
References: <bbc33d9b-af7c-8910-cdb3-fa3e3b2e3266@gmail.com>
Message-ID: <c9fab472-83a4-3258-e459-abf76abb65a2@gmail.com>
Date:   Wed, 6 Jan 2021 12:06:29 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <bbc33d9b-af7c-8910-cdb3-fa3e3b2e3266@gmail.com>
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
index c9abc7ccb..024042f37 100644
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


