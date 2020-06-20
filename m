Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3177E20266E
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 22:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgFTUlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 16:41:17 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45124 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728851AbgFTUlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 16:41:08 -0400
Received: by mail-wr1-f66.google.com with SMTP id c3so12903080wru.12
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 13:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iLtQTzUGDzz0+ZAHaTXEYjZL3GPDc0BZiL2YU9EKvqk=;
        b=Gayh1feTSQn5aMiucUaEIESoROBx6te79ZxpgOzVCSFkna6H33w3anpQFVChhUkGAA
         tGohYX09yS3+EmTaLNkqKrad440meuzjZJU8O+RNlhvk/JO2XQSa17lPi82u/wtorzuo
         HFCMLOZ2sz6jOdpxj4erP2T5cV8D0oprgevUzuu58PaKtQxEpDkHFF6IQGDSzJjOludG
         iT6Kh3NtBh6k8EG56CRMBBn/YDpLLw1fpuYWY6jdnVI5pH3oUpcnJOuutcHdVgv+yu4d
         Ayjprx3MbbT7AYZkRrnQO3j3maBBnAyvVJ3dGREAb124QfYtwpv0rHggzNXQj5nSHf8j
         q1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iLtQTzUGDzz0+ZAHaTXEYjZL3GPDc0BZiL2YU9EKvqk=;
        b=ikuyP50/EYlx94e0/18pJsWjA0i0yRO/FfNk6bjAvfEhUBngeyTKTuoB5xIAmqHl+e
         88dnlSZ5ZC2Va2BlfwisyK/TUyYsbto43rhFdJ2YJp//iy2n1RLbGyerAZ+xInT0n03i
         nTe4OjLVT2QXwbMsL4H97FDsfzoXM2SQydUIJ/j81MBbnTsiO8OG4i0n/7ueX1wJeiAg
         eSA2TRBFSvY1XauaNcaDI/9MYRu/24IbkJlM0e5L+4n4T6UcQSY92asYDiUFgcMqol98
         +F7VDj61mka7m916cUAI6sL/gqpCgEorXgOxPWzoAmXUphjzWGrcu+0eoBigbM1YKu/C
         5ETw==
X-Gm-Message-State: AOAM531SXCGsO0mGsBhdEGEc40MOU4avoxpiJG+VvgDvuLgGdmPWTetF
        4ZXemNEWJQLyVJcYPDicWiv/7N9j
X-Google-Smtp-Source: ABdhPJwciQlCSryrQOkUOMtbyEDbnn0Q/MG+aebbOZe7EhAeEVfTCOZcquMXTPhBcT52QPPPZETl+w==
X-Received: by 2002:adf:afc3:: with SMTP id y3mr10489634wrd.277.1592685605072;
        Sat, 20 Jun 2020 13:40:05 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:b4cc:8098:204b:37c5? (p200300ea8f235700b4cc8098204b37c5.dip0.t-ipconnect.de. [2003:ea:8f23:5700:b4cc:8098:204b:37c5])
        by smtp.googlemail.com with ESMTPSA id v11sm1118wmb.3.2020.06.20.13.40.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 13:40:05 -0700 (PDT)
Subject: [PATCH net-next 5/7] r8169: use RTNL to protect critical sections
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <2e68df85-4f64-d45b-3c4c-bb8cb9a4411d@gmail.com>
Message-ID: <5816fd36-55fb-d51c-c320-a7e338b40c40@gmail.com>
Date:   Sat, 20 Jun 2020 22:38:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <2e68df85-4f64-d45b-3c4c-bb8cb9a4411d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most relevant ops (open, close, ethtool ops) are protected with RTNL
lock by net core. Make sure that such ops can't be interrupted by
e.g. (runtime-)suspending by taking the RTNL lock in suspend ops
and the PCI error handler.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 2414df29c..e70797311 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4527,6 +4527,7 @@ static void rtl_task(struct work_struct *work)
 	struct rtl8169_private *tp =
 		container_of(work, struct rtl8169_private, wk.work);
 
+	rtnl_lock();
 	rtl_lock_work(tp);
 
 	if (!netif_running(tp->dev) ||
@@ -4539,6 +4540,7 @@ static void rtl_task(struct work_struct *work)
 	}
 out_unlock:
 	rtl_unlock_work(tp);
+	rtnl_unlock();
 }
 
 static int rtl8169_poll(struct napi_struct *napi, int budget)
@@ -4791,7 +4793,9 @@ static int __maybe_unused rtl8169_suspend(struct device *device)
 {
 	struct rtl8169_private *tp = dev_get_drvdata(device);
 
+	rtnl_lock();
 	rtl8169_net_suspend(tp);
+	rtnl_unlock();
 
 	return 0;
 }
@@ -4819,11 +4823,13 @@ static int rtl8169_runtime_suspend(struct device *device)
 		return 0;
 	}
 
+	rtnl_lock();
 	rtl_lock_work(tp);
 	__rtl8169_set_wol(tp, WAKE_PHY);
 	rtl_unlock_work(tp);
 
 	rtl8169_net_suspend(tp);
+	rtnl_unlock();
 
 	return 0;
 }
@@ -4885,7 +4891,9 @@ static void rtl_shutdown(struct pci_dev *pdev)
 {
 	struct rtl8169_private *tp = pci_get_drvdata(pdev);
 
+	rtnl_lock();
 	rtl8169_net_suspend(tp);
+	rtnl_unlock();
 
 	/* Restore original MAC address */
 	rtl_rar_set(tp, tp->dev->perm_addr);
-- 
2.27.0


