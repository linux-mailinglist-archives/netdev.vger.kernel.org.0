Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C388C29E718
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 10:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgJ2JTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 05:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2JTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 05:19:01 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBEDC0613D2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 02:19:00 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id k21so808251wmi.1
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 02:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=3QZARK0cUqVtpaWQExOpKpTYGADGFy/wd0osB3S4KCE=;
        b=Kv3en3Xzif5y/JfPJJwV6ZK23FoedKCMeRqkO9IFhzOLid5t96gzM4LDt5hRVfXiM4
         wViPMrGMya5x93Xbc0JI36XEvb4g5iJdLHwf2jyxNI4/2OJusP04pr7COcwr8YhV8a02
         7oa1flY3X6MRKWacooNR+fGrVwny1vTMqQETKm/5W+Eb1tQkqBYi8R8svRw9eKfrk3KB
         ibzYCQ4/ivOPK9bW9PrXv3JeYvUe3bsN9V/UfaUckglreoW4d1E7N+ATQMKYTqDy8gCk
         Xwobz/sNkg1B9Trilbf1KdvEF+P3bMehUZT+4lzDG7hPg91shDO5pMNczTSkON894tvb
         44FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=3QZARK0cUqVtpaWQExOpKpTYGADGFy/wd0osB3S4KCE=;
        b=nuH/8qv37ZGp3N5NhBVhqMroZAaA7qpyKLzB8doWB3zOiMQjpsmB5gHy2mSZG5cUGy
         t3SK4o2MFr2N3So6TyNo0WyWydGZSADLOY6x9jg1R5QtEcEYONIIXyOkUAee7lZJ5zuZ
         M1XtL2tgNYIa8v0/TJKWXbaJljhIzqzL710DrlbF/zqLEkC8qnVjyUueiuIuFFWbKVC+
         WxLzhLFf182mKoBHiHtcITxs/rOQ1WPIuse8a/BliCEzwtjIVkd2jI3oOuWm4uvJfN/G
         wrGh/AFxBRl4flgmsnjcy6sLSvsF2lu2VmTDCSDBcZ5Jjfi6lY4ZNvy1NuujegXgjy4d
         vsxQ==
X-Gm-Message-State: AOAM532J5iFYmMpx4pyc0FH6ubvMVGs3vE4WOcMp2tSt+mxaroQ5UrtU
        noxgeTvcFJKGpWp/WlPgi0uu6Kec2tg=
X-Google-Smtp-Source: ABdhPJzKsEgXVC51XiGOltlIs2Ih3w/7KtyNlunxXVzBdKmXFTeZ4mluYWS1laKXSCfykku0KmTTug==
X-Received: by 2002:a05:600c:28b:: with SMTP id 11mr289112wmk.47.1603963139402;
        Thu, 29 Oct 2020 02:18:59 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:c8fb:cb3e:2952:c247? (p200300ea8f232800c8fbcb3e2952c247.dip0.t-ipconnect.de. [2003:ea:8f23:2800:c8fb:cb3e:2952:c247])
        by smtp.googlemail.com with ESMTPSA id b5sm3723290wrs.97.2020.10.29.02.18.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 02:18:58 -0700 (PDT)
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     Serge Belyshev <belyshev@depni.sinp.msu.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: fix issue with forced threading in combination
 with shared interrupts
Message-ID: <b5b53bfe-35ac-3768-85bf-74d1290cf394@gmail.com>
Date:   Thu, 29 Oct 2020 10:18:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As reported by Serge flag IRQF_NO_THREAD causes an error if the
interrupt is actually shared and the other driver(s) don't have this
flag set. This situation can occur if a PCI(e) legacy interrupt is
used in combination with forced threading.
There's no good way to deal with this properly, therefore we have to
remove flag IRQF_NO_THREAD. For fixing the original forced threading
issue switch to napi_schedule().

Fixes: 424a646e072a ("r8169: fix operation under forced interrupt threading")
Link: https://www.spinics.net/lists/netdev/msg694960.html
Reported-by: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3b6ddc706..00f13805c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4573,7 +4573,7 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 	}
 
 	rtl_irq_disable(tp);
-	napi_schedule_irqoff(&tp->napi);
+	napi_schedule(&tp->napi);
 out:
 	rtl_ack_events(tp, status);
 
@@ -4746,7 +4746,7 @@ static int rtl_open(struct net_device *dev)
 	rtl_request_firmware(tp);
 
 	retval = request_irq(pci_irq_vector(pdev, 0), rtl8169_interrupt,
-			     IRQF_NO_THREAD | IRQF_SHARED, dev->name, tp);
+			     IRQF_SHARED, dev->name, tp);
 	if (retval < 0)
 		goto err_release_fw_2;
 
-- 
2.29.1

