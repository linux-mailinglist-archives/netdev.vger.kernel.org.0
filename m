Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940FF3113E3
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 22:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhBEVtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 16:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbhBEVto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 16:49:44 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FE0C06174A
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 13:49:04 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id u14so9337590wri.3
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 13:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=WORFReddpnV6GJa/j4pVo2tdv6pMAGvr6jqrgaloMuY=;
        b=cu08zRKudQPdA5LPt0ZHZgggIevrzSb4fTlhSaRjiAaNWUVIbl3WBmTyoK5PVYtFin
         +nh3K6Ol32BYwXoOb6iXka7WciumO6ahwfcsypD5hh/LWoyiYHF7mpRO7VQEJ3bIWUxX
         rkJo++DbwbZK0+49/ca0jBmOSdui9itdsprd/rjrqr9moyuZws8hqbzYMo5VAm7OAZD+
         JYLoBtYn7OQD2mgyV3mk7CftMg7Oby44ip/VEiqQD1ZYmf97JdOqzK7sTF2c+Co1jHLr
         NzJpx8P9IXc2XbGKWhB5d726cjlUYUTZifr1x+i3EjurD+jWWfuZiquEmpNmPQqHyi1U
         APHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=WORFReddpnV6GJa/j4pVo2tdv6pMAGvr6jqrgaloMuY=;
        b=kxSWK3/EJBJ6DZwbriwO0mkoXR78k8CgDZ3Fu5dZFxGpdehVxhr3v0+v+fp35MA28Z
         uorqF7zwi8YaRhdT87jBiLDzcNkM5nGWTUZ+S6CCoihoEZXSFmY+m5BbYJTySwLfDJ5k
         Oxjr2uwAt/zvjQB7cGINGnALAYpaqpiF0TT1z+4+zHRteWBMYulkOQ91EC24tqFdQ4mU
         /fs+YYF1y66Cp4Ox20iOAnG/izYLgL4sayU5JGqEETcBx8vzA+6iVQHuC64FprW+PzxB
         SvCwmLxvzC5zzI5nA79GA/+whp8KI8IPeOqlqaEiX/DcXADgXgpCo/kWJqCjVYqbWJ/k
         vSHw==
X-Gm-Message-State: AOAM5312Vi0IXd7NwMNbEvmdUzkEF9wqJPMcG1yGjjtEEHS7dQJ3gsn3
        dKaBl8DLSOqLQ9TwvSV9MRpg3ZfO+VDxSw==
X-Google-Smtp-Source: ABdhPJxBZ3bPL0FVM0LmhKWeJ2hIWRs8kuT9h1D0MM3OlDWTUEgOgF08dLocwep7OKrt4Eh7rt+D9w==
X-Received: by 2002:a5d:53c3:: with SMTP id a3mr6925244wrw.43.1612561742567;
        Fri, 05 Feb 2021 13:49:02 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:11de:46a1:319f:d28? (p200300ea8f1fad0011de46a1319f0d28.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:11de:46a1:319f:d28])
        by smtp.googlemail.com with ESMTPSA id h14sm9981702wmq.45.2021.02.05.13.48.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 13:49:02 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: don't try to disable interrupts if NAPI is
 scheduled already
Message-ID: <78c7f2fb-9772-1015-8c1d-632cbdff253f@gmail.com>
Date:   Fri, 5 Feb 2021 22:48:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no benefit in trying to disable interrupts if NAPI is
scheduled already. This allows us to save a PCI write in this case.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index eb4c2e678..c15c285a0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4544,8 +4544,10 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 		rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_PENDING);
 	}
 
-	rtl_irq_disable(tp);
-	napi_schedule(&tp->napi);
+	if (napi_schedule_prep(&tp->napi)) {
+		rtl_irq_disable(tp);
+		__napi_schedule(&tp->napi);
+	}
 out:
 	rtl_ack_events(tp, status);
 
-- 
2.30.0


