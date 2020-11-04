Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153D52A666C
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgKDOby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729972AbgKDObu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:31:50 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA98DC040203
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 06:31:45 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id k18so2504919wmj.5
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 06:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4rfiet18ZS0o4KG/dtF63+kbk0+HAV5dp9bIiGOx7/A=;
        b=sfcMSso4ZIjtzw+Jqb8eHi5oFWOCYuHZedzoLVlBFMW/sxgG00Nc+1+kdXJtQ1wFeK
         5AZmIvNBcO6P68XQ9UvidKMYuZImUVIQTLZHHMsyaYUVJ1yikHF5Hd9x9yPrTZfffgTm
         XqLF3s03M6QC1cRYtX716btEvouYkcwrKZZhzTYAYNARPONfVdTiIirM0Gvcj0sdjOXF
         tQQ8Qr7Q/ktvp0DJY50hyPUyPFfa8Esgm9ZqFiVD7j1P69NgsJ7+xlsow/SiOhFmlzkM
         daPqYy5+nrlehTHr520j0YUbEll5KpaLxnjHNCV3AsoYlHpiNv/cHIaLVSmiunqQwDvY
         5C7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4rfiet18ZS0o4KG/dtF63+kbk0+HAV5dp9bIiGOx7/A=;
        b=skx73XPLyumBCD8Q38IQLjknOCnEtNBL8WzeLHu/ATM/TzO3auMgwDIanVVusO0jJ0
         YisSuq+Yswd8JirxkISNn7hL5Io7Z5F6kO0OkqOORsoxul/bDylUkZV5iiroyQaOF0VK
         bUWI9pWpl0yuXRQsNkGE5NyjxPz4N5UmYWz0blNTNtnFIyhq/M0FzsZtQjwWJ3Qw0J8q
         mnhW1PS3ZxChiewB7uMQoIwdSV67fQtwQbYGuil4rz/YaUUCorkChHPTRM0xR3BLNgO+
         PLvoIGcFUEHvwQ4LumfcX8nfT/0Ukx5COGvW1pMFiVPoA4m7dvwJITdnOY+qcIy+0gql
         hSNg==
X-Gm-Message-State: AOAM533hU+qx2cLfcaYcmj5dICI4DEvseNN27khzeywCpdtvcVyHQxsY
        Jk86Kc0sfU+jZrdTvp+t9xc=
X-Google-Smtp-Source: ABdhPJxI7VpXKJmZPAAzWLeHi6wM4l7xKzxiHLBrCNzzFeW86JBey7HQ+giLzYO7y6Ko67W2NU36yQ==
X-Received: by 2002:a1c:b387:: with SMTP id c129mr5161673wmf.66.1604500304441;
        Wed, 04 Nov 2020 06:31:44 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:d177:63da:d01d:cf70? (p200300ea8f232800d17763dad01dcf70.dip0.t-ipconnect.de. [2003:ea:8f23:2800:d177:63da:d01d:cf70])
        by smtp.googlemail.com with ESMTPSA id 205sm2493118wme.38.2020.11.04.06.31.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 06:31:44 -0800 (PST)
Subject: [PATCH net-next v2 08/10] vti: switch to dev_get_tstats64
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
Message-ID: <fa3534fa-6f15-0dd1-c9f9-9598e6d1d0ea@gmail.com>
Date:   Wed, 4 Nov 2020 15:28:57 +0100
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
 net/ipv4/ip_vti.c  | 2 +-
 net/ipv6/ip6_vti.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index b957cbee2..abc171e79 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -404,7 +404,7 @@ static const struct net_device_ops vti_netdev_ops = {
 	.ndo_start_xmit	= vti_tunnel_xmit,
 	.ndo_do_ioctl	= ip_tunnel_ioctl,
 	.ndo_change_mtu	= ip_tunnel_change_mtu,
-	.ndo_get_stats64 = ip_tunnel_get_stats64,
+	.ndo_get_stats64 = dev_get_tstats64,
 	.ndo_get_iflink = ip_tunnel_get_iflink,
 	.ndo_tunnel_ctl	= vti_tunnel_ctl,
 };
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 5f9c4fdc1..b7b2bb27d 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -889,7 +889,7 @@ static const struct net_device_ops vti6_netdev_ops = {
 	.ndo_uninit	= vti6_dev_uninit,
 	.ndo_start_xmit = vti6_tnl_xmit,
 	.ndo_do_ioctl	= vti6_ioctl,
-	.ndo_get_stats64 = ip_tunnel_get_stats64,
+	.ndo_get_stats64 = dev_get_tstats64,
 	.ndo_get_iflink = ip6_tnl_get_iflink,
 };
 
-- 
2.29.2


