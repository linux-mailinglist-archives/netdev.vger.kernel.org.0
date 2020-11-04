Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DBE2A6669
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbgKDObr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729972AbgKDObm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:31:42 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C8CC0613D3
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 06:31:42 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id x7so22293125wrl.3
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 06:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xp6oy8hFijEmY9NkC9fHkoFa4aR3nW13I4ZttL2CY1s=;
        b=gydV31gZS7M+j5E46kP9AIaz8+BM5M32QpZbH/YNlCKoV/ZpmW6d81ZlDl2VCcdXas
         tKYGkBIlQGA4J/CbWlOD8h++H0zwu4ZMdKjneqQBTk6hR54YzL6GFu2A2dc4UAKXFEIU
         BAW+1cFOjFLDoecjZWP9OJcXLKm3C07PCk8C6MmUXxJE+c8pytKWDMQ1VuYizJNkaiKS
         DxOaZ4BIo72zZ0QtJ+JPj5v5eu8sRpTOynCk2lo5W0guQPj9DoTFQom2CXoQBP74e2w6
         4c3ALEpoidWzuDh9nyOiIDPnpPTeDpp+rxcN9yTFS8ajTAUcfCVRP/P5YKsoIWfD2nRS
         ZX8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xp6oy8hFijEmY9NkC9fHkoFa4aR3nW13I4ZttL2CY1s=;
        b=AKwD0QbrRpFj6TnTCiSGiFNrJTr0t/PuSTRngdi4YWmyozln5UMh4kCtA7Er1oX0ME
         l2iezvn893shLCBNKZkAhIdvS/3eTpBmhVtHyCgfDcd7snB69l0K/qWcx/A3LAMjqapX
         SgnIxJvvflRi1gIOPSNriyFP1RIQ5Rsk5oxNEr49EsyXDTpKTg4vBVRGBBlKHsDIQ5Sq
         gCv6mXEpbVZ6jiOV6MynQlGfBf+WCi6e+069gJWxkZGsQ2kvSDKLsUWzR23sD0weAM49
         xYdmjaLFXcnc2Bz/8ku58iTRjMqf+K72ZDTfJ07lJMvQf/zkeLdOfb2lz1BxcjqgLwfH
         ff0g==
X-Gm-Message-State: AOAM532fr3oJ0vreD44gNSv1fO89b7k7+2+YE1f/K4g/cTBdbnm07iZt
        sux2b7YQbcyjbHWwzZJjcAM=
X-Google-Smtp-Source: ABdhPJyvvhuRWzQmFq7CIZ0Iq/4dBo0VuuTGRZ7iy05CIxTO7DdreWemTSw/gAg+68JIxl2poVPGKA==
X-Received: by 2002:adf:dec1:: with SMTP id i1mr30822590wrn.50.1604500301068;
        Wed, 04 Nov 2020 06:31:41 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:d177:63da:d01d:cf70? (p200300ea8f232800d17763dad01dcf70.dip0.t-ipconnect.de. [2003:ea:8f23:2800:d177:63da:d01d:cf70])
        by smtp.googlemail.com with ESMTPSA id t12sm2976964wrm.25.2020.11.04.06.31.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 06:31:40 -0800 (PST)
Subject: [PATCH net-next v2 06/10] gtp: switch to dev_get_tstats64
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
Message-ID: <52d228fe-9ed3-7cd0-eebc-051c38b5e45f@gmail.com>
Date:   Wed, 4 Nov 2020 15:27:47 +0100
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
 drivers/net/gtp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index dc668ed28..4c04e271f 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -607,7 +607,7 @@ static const struct net_device_ops gtp_netdev_ops = {
 	.ndo_init		= gtp_dev_init,
 	.ndo_uninit		= gtp_dev_uninit,
 	.ndo_start_xmit		= gtp_dev_xmit,
-	.ndo_get_stats64	= ip_tunnel_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 };
 
 static void gtp_link_setup(struct net_device *dev)
-- 
2.29.2


