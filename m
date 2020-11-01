Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D7F2A2233
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 23:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgKAWay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 17:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbgKAWax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 17:30:53 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423DEC0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 14:30:53 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id p9so16328782eji.4
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 14:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=JjhRx57l4Oojmhnhgh6EoyLLRtGGdKyUSkBRJKdATP8=;
        b=DXSS3tzsBkUkeuqxjMbBn8zHJSWPNS+UqBRHVQ2TzbGgtOu0vChuwEZHSHpBjHXoML
         HaoPma8MM8t4UfEYt5mYNTuHiBpadVw8tyOCYYP7Ui8DrBPCX5Q/Oz1Bv2z3YiMw6+iK
         CZhntRhiVdFD9PDd0tFUfXSq41L6FbM2vclVPo++P8GtNDxRdhUOWkM13hOsFNXFSIxN
         +bIrg2JMDPSgVMbqLY79kjuKddOQpmLzivd93uQ2lsh6qyCw29LEKPZAZQgqsngjZknW
         lS8Hw6pfil2f87mh8lJCduPn9hyxGGobEWOfVWQ3EnEplDzhSoodYwhSeCg8iBEw3gtl
         /k1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=JjhRx57l4Oojmhnhgh6EoyLLRtGGdKyUSkBRJKdATP8=;
        b=J0xtqc5wVpC0k77xmxxTwBktB/BDKEOvIHA0VYl7HHh4795ZeQPy/fyJV3wppEsQ0E
         5N4lR8+Zh6CZ4GS68gOYkip2TM6Pc/Y+5ojyCpEvTVhjVHbGvFeaoXJt1z9PvegSoUju
         HgY/yS0XQN1ph9sJDKAD8W4l6mFp6EZc0dba3uneu17aE/o1Ofug+KpUKFLsHupMSyb2
         SRRnhNlvnNZu6Sr/T6EcttRgIYPL+ZUGrE7ze27UkHspsU/Pbe9WbzLuaufs1/SG7Jk3
         z1Ebj22su6dl5d5J2Aw8Is02bxxqBf0l88rz1zxdv03NZNLAzitaQWMa3l0vnj0vQx/O
         vHxA==
X-Gm-Message-State: AOAM532sr50FwLBus8wGiEroPHAABZ4Hqy/y1vViZQhZWT6ZyKpT0sJh
        vO2R6g5XvlMIZ6REnN/b/kXW1ZNETAg=
X-Google-Smtp-Source: ABdhPJxrkWnSFxzQww3U75MktXl4Y+//ozOIBvBpG91ubq+eaY+ffx+f5RJ82wnV8OToRq/yg0R2FQ==
X-Received: by 2002:a17:906:d1c3:: with SMTP id bs3mr12149518ejb.246.1604269851715;
        Sun, 01 Nov 2020 14:30:51 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:3050:ca03:432d:4900? (p200300ea8f2328003050ca03432d4900.dip0.t-ipconnect.de. [2003:ea:8f23:2800:3050:ca03:432d:4900])
        by smtp.googlemail.com with ESMTPSA id cx6sm2665439edb.61.2020.11.01.14.30.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2020 14:30:51 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: set IRQF_NO_THREAD if MSI(X) is enabled
Message-ID: <446cf5b8-dddd-197f-cb96-66783141ade4@gmail.com>
Date:   Sun, 1 Nov 2020 23:30:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We had to remove flag IRQF_NO_THREAD because it conflicts with shared
interrupts in case legacy interrupts are used. Following up on the
linked discussion set IRQF_NO_THREAD if MSI or MSI-X is used, because
both guarantee that interrupt won't be shared.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://www.spinics.net/lists/netdev/msg695341.html
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 319399a03..4d6afaf7c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4690,6 +4690,7 @@ static int rtl_open(struct net_device *dev)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 	struct pci_dev *pdev = tp->pci_dev;
+	unsigned long irqflags;
 	int retval = -ENOMEM;
 
 	pm_runtime_get_sync(&pdev->dev);
@@ -4714,8 +4715,9 @@ static int rtl_open(struct net_device *dev)
 
 	rtl_request_firmware(tp);
 
+	irqflags = pci_dev_msi_enabled(pdev) ? IRQF_NO_THREAD : IRQF_SHARED;
 	retval = request_irq(pci_irq_vector(pdev, 0), rtl8169_interrupt,
-			     IRQF_SHARED, dev->name, tp);
+			     irqflags, dev->name, tp);
 	if (retval < 0)
 		goto err_release_fw_2;
 
-- 
2.29.2

