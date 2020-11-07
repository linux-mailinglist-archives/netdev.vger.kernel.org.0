Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801762AA7FD
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 21:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbgKGU4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 15:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728717AbgKGU4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 15:56:13 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2744EC0613D4
        for <netdev@vger.kernel.org>; Sat,  7 Nov 2020 12:56:13 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id w24so1994297wmi.0
        for <netdev@vger.kernel.org>; Sat, 07 Nov 2020 12:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=AqDWLm8KXcv4xkeQId6Y5dIQy0TCTVRseOitm1HQ4jk=;
        b=o5FYj6ZmqzBJ/ivWXmw0usJBDgDyyPssyFiWvYojyryyHUVaxlpBIQhvTj0d2Jq46B
         D4l6vk4/QpxizZ6JJIf4O+b9j9HczFpBN9Dp+3gjzE+KhmPmswcwvzRV2ii2pGLFA+EA
         E7G3Dbvisgrnj9ADNpesPuq+eZ2nC2ZGAeyvXy6oYtn4C0/ZFEoQH+TjIZ/l3LwXgLah
         vPICg7OrR0m4VJFzt5Sss0lLh9jYwlhwLyjOM1jdjADV559ro+xLH9PxXGoCCLXXXkgG
         slazgJif12aQ9AHHPTuSTpsKyr7QyeihdsP1HuT+fte/J8U/393MV7tBDF3ETCI5AiD2
         75xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=AqDWLm8KXcv4xkeQId6Y5dIQy0TCTVRseOitm1HQ4jk=;
        b=Cu/gizL5cutHYMkDm0gKrCJIQ+VzGa4oIYfTOaMNacV1zUwaEVD4+xZi4cbB8gTeTa
         SKP5oZHdDGbvUxZQVNneeUO21kwBKRL4rn6F5VNu2O3IqdpwS6hBjWUnG7DEPv4f1wfE
         HlFWvn1SU1sb/csmkLCYsnEtBPMbESe5gXIUWpjR9B0gXcMoiU7dutM7qf4bmBegmzyS
         n/GHHK1FbKYLg2L0cs+HZWjs2iEkFMqxtx9iOKffxyglr3sToYkNDghwwXMyT6lMpPgi
         cedXDgao6yyhetFMHHY1VAng8NIIK4Tu5pGL0C9UJAsVdnyzr9+9d4Ra1DVK3/q9etSf
         amzg==
X-Gm-Message-State: AOAM53158u2Nll+TRHfnghz8PSzaoArVkztiYCZKHifs1SBUJn1zA6ak
        3njJnTY2EM8m3xWFoWDnuVY=
X-Google-Smtp-Source: ABdhPJxKbOxtoWrYoXQo5USaK5yvt3T+8kM2r5oGGLK/j28grM6DP89KLS6rfO4/loYh1jJmON/rnA==
X-Received: by 2002:a1c:8145:: with SMTP id c66mr6258741wmd.75.1604782571875;
        Sat, 07 Nov 2020 12:56:11 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:7051:31d:251f:edd6? (p200300ea8f2328007051031d251fedd6.dip0.t-ipconnect.de. [2003:ea:8f23:2800:7051:31d:251f:edd6])
        by smtp.googlemail.com with ESMTPSA id 71sm7973217wrm.20.2020.11.07.12.56.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 12:56:11 -0800 (PST)
Subject: [PATCH net-next v3 07/10] wireguard: switch to dev_get_tstats64
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
References: <99273e2f-c218-cd19-916e-9161d8ad8c56@gmail.com>
Message-ID: <79e9a040-c097-1d33-8de1-4833f1c68828@gmail.com>
Date:   Sat, 7 Nov 2020 21:53:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <99273e2f-c218-cd19-916e-9161d8ad8c56@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace ip_tunnel_get_stats64() with the new identical core function
dev_get_tstats64().

Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
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


