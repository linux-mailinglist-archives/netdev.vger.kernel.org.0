Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19F02AA7FE
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 21:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbgKGU4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 15:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728729AbgKGU4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 15:56:15 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49D8C0613CF
        for <netdev@vger.kernel.org>; Sat,  7 Nov 2020 12:56:14 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id g12so4811715wrp.10
        for <netdev@vger.kernel.org>; Sat, 07 Nov 2020 12:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=yvM2zg5ut8RUlOVk41NO5JTWXGYDPLj6ZinwUBXZBNs=;
        b=YRzVwR3VOYv79vPIg8b5EIMmKfgP9mn6DbFAnIRAS1gmfNezyjCF4Gp2ABv/iexY3a
         dKnhzyqA48zVqgBgGCmQei1DZ8f9ASml4KMnqwLfEJpWlOMwSmuP5jOsALlsXJafzAjD
         zuBbbALWsNykrRr2QmM4AzSRGDDjOfmFo1Esj7ImMCkohjQdAJQb379jo0AV7iO2yD3X
         ifDXNDILYUmNb1GJ7t7N2m03O3aIaSTWC1vQewDKZUD6hi9tiN9g4UZ5VBZB9MKcqQu0
         Lv21zMIYq7RAq7ugKnUMH4PYEz7op6bSiqGx1MzWNZTEhIwLuBfAkIA8WMhxK/3r9jFN
         umbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=yvM2zg5ut8RUlOVk41NO5JTWXGYDPLj6ZinwUBXZBNs=;
        b=CbcAZAjocQvPKfzRL2GA0UhwVmb9ENuCYePpGOW8VNxVU1gySQXwhZCrfj3u7t72R3
         QUGqyqG5cKgypizIzCbMKn6vR7d/3oh7xZ3G+raL/XquD9IPdZsbz1LJZM+Sbasg/cpL
         hAHwMbc1L9A725Uht+HlAqecrTu0he6UDzPIMZ0MYSQWLHmarCrrrkgM5niCDtm8wkHi
         yBHjYdqsQDq+b2AL8VGVMPKFQdVsIJbcsytlsUe98ECQ2+oDb3E55AXjO3cWagsV3Uyv
         CLXIz6mkEO0gLQDKi7zgBUgTT/lDYKFSby4nyzC7evKMQhdDNaCrggLT69lEWSmJsWaq
         8VCw==
X-Gm-Message-State: AOAM532pX0qkMcYH0HxfvVyZ+OS3puQ3x2Oq0eQOS212oN3Z5fE9ugvu
        Ho/m4QG6DpQj1JuHu4AW+YY=
X-Google-Smtp-Source: ABdhPJzPITSO0TWNyqU0r8yAlKSviyXbqz+nk7MVBML4BCNfoFAcyBZ0IWsUQ0/EoAtu4hmMZ4NIvg==
X-Received: by 2002:adf:9069:: with SMTP id h96mr10064659wrh.358.1604782573402;
        Sat, 07 Nov 2020 12:56:13 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:7051:31d:251f:edd6? (p200300ea8f2328007051031d251fedd6.dip0.t-ipconnect.de. [2003:ea:8f23:2800:7051:31d:251f:edd6])
        by smtp.googlemail.com with ESMTPSA id q7sm7128217wrg.95.2020.11.07.12.56.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 12:56:12 -0800 (PST)
Subject: [PATCH net-next v3 08/10] vti: switch to dev_get_tstats64
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
Message-ID: <f8d8efd4-1bb7-a37f-1c64-23e06538f66a@gmail.com>
Date:   Sat, 7 Nov 2020 21:53:53 +0100
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
index 46d137a69..0225fd694 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -890,7 +890,7 @@ static const struct net_device_ops vti6_netdev_ops = {
 	.ndo_uninit	= vti6_dev_uninit,
 	.ndo_start_xmit = vti6_tnl_xmit,
 	.ndo_do_ioctl	= vti6_ioctl,
-	.ndo_get_stats64 = ip_tunnel_get_stats64,
+	.ndo_get_stats64 = dev_get_tstats64,
 	.ndo_get_iflink = ip6_tnl_get_iflink,
 };
 
-- 
2.29.2


