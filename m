Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC322AA7FB
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 21:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgKGU4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 15:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728693AbgKGU4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 15:56:11 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CE5C0613CF
        for <netdev@vger.kernel.org>; Sat,  7 Nov 2020 12:56:10 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id v5so4660556wmh.1
        for <netdev@vger.kernel.org>; Sat, 07 Nov 2020 12:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=9u7gkvbf7OAMj3VbHYAxPHRbbiyrawvYfgWlZZDK0zE=;
        b=fJEhCtHmlnLGk1K+M8mWEvAED1FqUFenR/e+JruBYbUZ+Ky5AnTDD3+ZidHthDuGjb
         Vo/SxgBXLRzxL/hEu974GnftkbsgbK5pqXtxcpH1wsSVLMb9n/5xxj+BcgOvxsneoSM1
         WD7KO8UypAPuCLDsweZsKXSJYY5xSKSDf4EOA29lYUoLfSms1H7FUL/WkH7OyvomMn0U
         +PqquUNlMeOsYY0AyT4YHUBeBZ3nMur06FSzkosUv8frTTjHImfhVQUnLFNaCHAWLzS3
         D7uErdJijTD9+q75MaHjg5QQuSbjcAvvBhC64U5bwqJBEovDmt1CiCEAg/TNC5nBoq8w
         EnAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=9u7gkvbf7OAMj3VbHYAxPHRbbiyrawvYfgWlZZDK0zE=;
        b=rhXfbKun28tn5ea97STIp8qCe15ILdB9xUhbT7WCNnT+hQ23L6pk50l/OQ9siUfWts
         09fNhsTG1Me6x7pzDAlezNtjdgd4qQ38V4VoFIeKA+3Ogb7fUzmrUSUinrwRMnqqXIRR
         8YZcVFduD8htzbYrwum1JNeGxlchQg+mFLpMfqIgTyD6QFl7jHbk9lwjtx9sWpWfl6Px
         y9fEaNSGMWJ9jXSuWu1b+aBuBAbiZjFX8QBnzCabbs5XEn1AasofoXs158kjYygti8vl
         EJ+9SkmgzmCRXvIy/vQMdenVoZ2KI9fBZJWsYVhN6OSTjTLNMCBfFviU0CsJNjWXqhRw
         eddQ==
X-Gm-Message-State: AOAM533uX8rlq6h3wfhfMldo20G0NDGSjN5DzRRXXVxG4n/qGcptauD+
        gYU85XWDLJEIxEVjATwjcmM=
X-Google-Smtp-Source: ABdhPJwEwwyfYVztu4FFL23KSdp10USFTuqtpP6crdBu6ZsT0zxjx2DhnceuzpR9h8nB60bGHAbyFg==
X-Received: by 2002:a7b:c8c9:: with SMTP id f9mr6112537wml.3.1604782568997;
        Sat, 07 Nov 2020 12:56:08 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:7051:31d:251f:edd6? (p200300ea8f2328007051031d251fedd6.dip0.t-ipconnect.de. [2003:ea:8f23:2800:7051:31d:251f:edd6])
        by smtp.googlemail.com with ESMTPSA id t2sm8347163wrq.56.2020.11.07.12.56.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 12:56:08 -0800 (PST)
Subject: [PATCH net-next v3 05/10] net: switch to dev_get_tstats64
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
Message-ID: <0f7cd95e-896d-2313-88e8-e0af23d011bb@gmail.com>
Date:   Sat, 7 Nov 2020 21:52:06 +0100
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
 drivers/net/bareudp.c | 2 +-
 drivers/net/geneve.c  | 2 +-
 drivers/net/vxlan.c   | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index ff0bea155..28257bcce 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -510,7 +510,7 @@ static const struct net_device_ops bareudp_netdev_ops = {
 	.ndo_open               = bareudp_open,
 	.ndo_stop               = bareudp_stop,
 	.ndo_start_xmit         = bareudp_xmit,
-	.ndo_get_stats64        = ip_tunnel_get_stats64,
+	.ndo_get_stats64        = dev_get_tstats64,
 	.ndo_fill_metadata_dst  = bareudp_fill_metadata_dst,
 };
 
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index d07008a81..a3c8ce6de 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1138,7 +1138,7 @@ static const struct net_device_ops geneve_netdev_ops = {
 	.ndo_open		= geneve_open,
 	.ndo_stop		= geneve_stop,
 	.ndo_start_xmit		= geneve_xmit,
-	.ndo_get_stats64	= ip_tunnel_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_change_mtu		= geneve_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 876679af6..0de912729 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3211,7 +3211,7 @@ static const struct net_device_ops vxlan_netdev_ether_ops = {
 	.ndo_open		= vxlan_open,
 	.ndo_stop		= vxlan_stop,
 	.ndo_start_xmit		= vxlan_xmit,
-	.ndo_get_stats64	= ip_tunnel_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_rx_mode	= vxlan_set_multicast_list,
 	.ndo_change_mtu		= vxlan_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
@@ -3230,7 +3230,7 @@ static const struct net_device_ops vxlan_netdev_raw_ops = {
 	.ndo_open		= vxlan_open,
 	.ndo_stop		= vxlan_stop,
 	.ndo_start_xmit		= vxlan_xmit,
-	.ndo_get_stats64	= ip_tunnel_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_change_mtu		= vxlan_change_mtu,
 	.ndo_fill_metadata_dst	= vxlan_fill_metadata_dst,
 };
-- 
2.29.2


