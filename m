Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DA62A666F
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730126AbgKDOcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729990AbgKDObo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:31:44 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA85CC0613D3
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 06:31:43 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id b8so22292659wrn.0
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 06:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ISdFe78IibjR0mRAQ86gBh/OHzTQrxaMboYtkFYsqpE=;
        b=eE8ak1TBDVXreX9muVNGINPPTvKoQUGUD0knZOHr+4cKU7tAK22S3ATaMp2kFxsxRy
         iiMxKWeDrIIOa6dXxEZmheaPMa7hXUAh4/BjqpaQDfLRVHSgPI+YYSvcYhpHfTHoLA5P
         wg2kho8HjLlH0ER5waUhPXWL7UvsSE/j6+h1ICFXEvcwE6nHlhA71k0EPzEyI4BEh8fE
         D9/Dw9aV15WdZbgs+6dF6oHQjVZPrvMdmqR3hbfxTeupHkARuPGWI/STHjm52TLbn2A3
         A3o4CVot3uA6ift59ypoE8kihX6cQlGv+OlXIPXLyF1MrYHykPZPGay7CfdBE1+FMAZc
         IRyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ISdFe78IibjR0mRAQ86gBh/OHzTQrxaMboYtkFYsqpE=;
        b=Jkc9axOGA1sf3rrP86ceB2bd9ilGZHdnJ3zX6/PqSGVeSOa30PBheGKWAHaE4tiFc5
         YJ/JFBKg5ln94+MgYDoHg42842VlkpDENoTKAZiRJLQqVz1GLR3r6NOC98z2MXpbvF/d
         6qQB9HsYzUasLyWT9oHSToW4w7ijdnWE2WM6z2iO9vqaAF1GBfE7tPfL4wSfyfq2d/NV
         gWBAFsPAmQ0+CmdY5wOd7ZnjPETZHNscqwcfyWmXURen6YpoYzl6J+B5khJ1rJZlRWm/
         uqJ/FQnFPs6uVSPi9FRkVkFi9gYIwl+CLwfRO3ynwmOnvvZU4BdNnROFIZXC0pjrimR9
         bFzA==
X-Gm-Message-State: AOAM532K0pZOGIQIuk6DIU5FmTfR0Ou879UzjziCXSwxTMHPp6va97bI
        pdwKe9sjkDW2zD6Fi9++Y44=
X-Google-Smtp-Source: ABdhPJyTmgp2E3e/UB8WuI4mAejZD7B4seUjChiV1gJQIko6Xt6GU+2OLu3kC+3iK9h4fWeGCnAcTA==
X-Received: by 2002:adf:fa8a:: with SMTP id h10mr32097178wrr.336.1604500302448;
        Wed, 04 Nov 2020 06:31:42 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:d177:63da:d01d:cf70? (p200300ea8f232800d17763dad01dcf70.dip0.t-ipconnect.de. [2003:ea:8f23:2800:d177:63da:d01d:cf70])
        by smtp.googlemail.com with ESMTPSA id f17sm2938117wrm.27.2020.11.04.06.31.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 06:31:42 -0800 (PST)
Subject: [PATCH net-next v2 07/10] wireguard: switch to dev_get_tstats64
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        osmocom-net-gprs@lists.osmocom.org, wireguard@lists.zx2c4.com,
        Steffen Klassert <steffen.klassert@secunet.com>
References: <059fcb95-fba8-673e-0cd6-fb26e8ed4861@gmail.com>
Message-ID: <4f731535-2a51-a673-5daf-d9ec2536a8f8@gmail.com>
Date:   Wed, 4 Nov 2020 15:28:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <059fcb95-fba8-673e-0cd6-fb26e8ed4861@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace ip_tunnel_get_stats64() with the new identical core fucntion
dev_get_tstats64().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/wireguard/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index c9f65e96c..a3ed49cd9 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -215,7 +215,7 @@ static const struct net_device_ops netdev_ops = {
 	.ndo_open		= wg_open,
 	.ndo_stop		= wg_stop,
 	.ndo_start_xmit		= wg_xmit,
-	.ndo_get_stats64	= ip_tunnel_get_stats64
+	.ndo_get_stats64	= dev_get_tstats64
 };
 
 static void wg_destruct(struct net_device *dev)
-- 
2.29.2


