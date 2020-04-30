Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F211C0737
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgD3UAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbgD3UAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:00:16 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3418C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:00:15 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g12so3575125wmh.3
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m/z3pQ3DUBxVgJ+cnZWVOh7UmSQTTtMSGiNh0lbgWXY=;
        b=lpt0ysMS/NHBjPRT1AW8XjNEoKXoD4ZOKRBxE6frR1e5NE+yi9UEfHBuFw6qda5oKW
         V34FyNPWqUbH9rYgq/GQ1UMvHBKzAFcqjmckELnkeK4JcY06hX0him9Tviw4K23FF4gl
         ozzOGAJCTRBKb7YZo9UD2AlWYXzc9p+xFUemblqH/2cVQ7EBBeygUSIIGYqNAUScmKmR
         VMDG8u/P9Kwyf+gJp9KheL6hM05+Uy/2MY4SlUjV7/PyHBy/uES6GLJjMb7E58HVyvSz
         t42ihqZptOI+QMhgF385zzg5EWkH6tP99WoiM7ziT+V4wdW59Ob45O1QwDbOfvFlgR7Q
         N6Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m/z3pQ3DUBxVgJ+cnZWVOh7UmSQTTtMSGiNh0lbgWXY=;
        b=PZMXJ5eUucOpeOl2pVeI4Y5a4TSIuzVuX+pbUr+euIJS/jsG/4+rtmNhGnmtBrE6+O
         NGjsGoIU015mcMXd3NQESktZHINh7xO7rJiM+TlrJQH9HHQJv+QH1+7izpQXbqFuqD7M
         zhWuJ9BNreHkLcZPPk+2/ZRuke0xmWKJ5b5TyAHEP+J2STJOEsTOUGnavDJG5kyfMkMM
         nqALxdBipvDJGg+6SHWSBSPC4pTvAg1b2wvMeJiYGvKtUrp7LixrdMXpxHS2xtIcteKT
         uk4iaShJvBIKtGnbYpv7iNvMtalArpMtSGKOPEF7SiuhQwgw7HLWF0yIgT6hI0CupRWH
         fzRg==
X-Gm-Message-State: AGi0PubH/IM9PbatvwODM/9uK0CA6ATH4Kp0Zpd25xvuXE5MQ7IAnYbC
        1baSsuY4Vj1I8l5dYFHPuoMv8BCK
X-Google-Smtp-Source: APiQypIU6xRl4XT1OeKhYqw9cElNUlracEp68G9+QEWARj7EzW0T2N/CvZKtUflo2x7iTlA9U0dOBA==
X-Received: by 2002:a7b:cb88:: with SMTP id m8mr241564wmi.103.1588276814349;
        Thu, 30 Apr 2020 13:00:14 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f0e:e300:b04f:e17d:bb1a:140e? (p200300EA8F0EE300B04FE17DBB1A140E.dip0.t-ipconnect.de. [2003:ea:8f0e:e300:b04f:e17d:bb1a:140e])
        by smtp.googlemail.com with ESMTPSA id k9sm1207877wrd.17.2020.04.30.13.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 13:00:13 -0700 (PDT)
Subject: [PATCH net-next 7/7] r8169: add check for invalid parameter
 combination in rtl_set_coalesce
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d660cf81-2d8d-010e-9d5c-3f8c71c833ed@gmail.com>
Message-ID: <14b4a80a-fb2c-f669-be09-4092bfc6cd57@gmail.com>
Date:   Thu, 30 Apr 2020 21:59:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <d660cf81-2d8d-010e-9d5c-3f8c71c833ed@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Realtek provided information about a HW constraint that time limit must
not be set to 0 if the frame limit is >0. Add a check for this and
reject invalid parameter combinations.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3fef1b254..0ac3976e3 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1908,6 +1908,11 @@ static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 	if (tx_fr == 1)
 		tx_fr = 0;
 
+	/* HW requires time limit to be set if frame limit is set */
+	if ((tx_fr && !ec->tx_coalesce_usecs) ||
+	    (rx_fr && !ec->rx_coalesce_usecs))
+		return -EINVAL;
+
 	w |= FIELD_PREP(RTL_COALESCE_TX_FRAMES, DIV_ROUND_UP(tx_fr, 4));
 	w |= FIELD_PREP(RTL_COALESCE_RX_FRAMES, DIV_ROUND_UP(rx_fr, 4));
 
-- 
2.26.2


