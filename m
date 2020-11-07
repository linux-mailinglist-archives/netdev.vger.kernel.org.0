Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3162AA7F7
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 21:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgKGU4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 15:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGU4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 15:56:05 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC28C0613CF
        for <netdev@vger.kernel.org>; Sat,  7 Nov 2020 12:56:05 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id p19so3183215wmg.0
        for <netdev@vger.kernel.org>; Sat, 07 Nov 2020 12:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=DYRIQMTMgtclfC11ma0PcCZtnRPkZKmVXTdnNGEHpbU=;
        b=R9SDmQWkuWHnfgtqv7Ufkk2HRy0GaLhEEYkHaTvRjlowbgX0La+ML68VcuQOHxhjNN
         PcX5tkZKLnlrWLIN6Q6IcrTUrWcOyWc60GQNr4LVonFEBgs1nDaNFHJ9pIIeJRb5vS5+
         pc1oWRBO4ZPnGcw+xeRIXW8hCRBqVEMvp/nPFe3p1S0H5nknnXRVx1aMl+B6SMeU5zUS
         r79fPNCRov3Y10SRZt9msJhE1PeaPBSHnGb33PZK3RosLrWEOK0XMP8sMac68OtNHIJV
         PxcNkv+P4097VC9S2B4s0j93aTrSv7sliC1kuodARUkD9K0dfgR76eWjlsKAysUYcbXn
         EL2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=DYRIQMTMgtclfC11ma0PcCZtnRPkZKmVXTdnNGEHpbU=;
        b=pHeBaZUsQIAKO/C5Uz6yGIQxEsSg0qocE1TZXCMiL0keczLXd25sikNNP9JIrimcmL
         aeBunvlfuxK/8wdH/cHP+hN7VN2njj4mQoiAKVNqOqKCf0hxeVmvRhH+7C79cs7IN2yW
         6Zkd5lL3HTQywg6PwgI7NDY4xu5y/GTauYIPiKTJr3Je42RvwDz51sblSjRbdThaTgxh
         JBb6zM2iqigOnbTOYEoZ5bxgsF4VkwAttECRMZu7yJm8f8np4RMH8vkeQyuGJYxJSLaH
         Itj+dTfWj9wKO/I0Q/xkgnStKKVRODtsXDApFk1OkrIyHsevOAYgGbF8INxsH28DGZtS
         d3cA==
X-Gm-Message-State: AOAM533aFDp/GZI4y8kV7E+v7sLEn8JJ/SiRuQo4JAxaehdvOf4gu116
        si4hcpGxUClepiluJZOx1jFlxuh1rTwdoQ==
X-Google-Smtp-Source: ABdhPJwZYHop1A1l8S0GAY1Ccs9RLvW4wC3U+CFi/wgoe1MRqwMrnejznW8okpPfxgKH5UbwYcLWOw==
X-Received: by 2002:a1c:6284:: with SMTP id w126mr6532465wmb.145.1604782563027;
        Sat, 07 Nov 2020 12:56:03 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:7051:31d:251f:edd6? (p200300ea8f2328007051031d251fedd6.dip0.t-ipconnect.de. [2003:ea:8f23:2800:7051:31d:251f:edd6])
        by smtp.googlemail.com with ESMTPSA id p4sm7611551wrm.51.2020.11.07.12.56.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 12:56:02 -0800 (PST)
Subject: [PATCH net-next v3 01/10] net: core: add dev_get_tstats64 as a
 ndo_get_stats64 implementation
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
Message-ID: <484218db-e035-dba4-dfb7-93c2cf177cec@gmail.com>
Date:   Sat, 7 Nov 2020 21:49:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <99273e2f-c218-cd19-916e-9161d8ad8c56@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's a frequent pattern to use netdev->stats for the less frequently
accessed counters and per-cpu counters for the frequently accessed
counters (rx/tx bytes/packets). Add a default ndo_get_stats64()
implementation for this use case.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a53ed2d1e..7ce648a56 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4527,6 +4527,7 @@ void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
 			     const struct net_device_stats *netdev_stats);
 void dev_fetch_sw_netstats(struct rtnl_link_stats64 *s,
 			   const struct pcpu_sw_netstats __percpu *netstats);
+void dev_get_tstats64(struct net_device *dev, struct rtnl_link_stats64 *s);
 
 extern int		netdev_max_backlog;
 extern int		netdev_tstamp_prequeue;
diff --git a/net/core/dev.c b/net/core/dev.c
index bd6100da6..60d325bda 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10366,6 +10366,21 @@ void dev_fetch_sw_netstats(struct rtnl_link_stats64 *s,
 }
 EXPORT_SYMBOL_GPL(dev_fetch_sw_netstats);
 
+/**
+ *	dev_get_tstats64 - ndo_get_stats64 implementation
+ *	@dev: device to get statistics from
+ *	@s: place to store stats
+ *
+ *	Populate @s from dev->stats and dev->tstats. Can be used as
+ *	ndo_get_stats64() callback.
+ */
+void dev_get_tstats64(struct net_device *dev, struct rtnl_link_stats64 *s)
+{
+	netdev_stats_to_stats64(s, &dev->stats);
+	dev_fetch_sw_netstats(s, dev->tstats);
+}
+EXPORT_SYMBOL_GPL(dev_get_tstats64);
+
 struct netdev_queue *dev_ingress_queue_create(struct net_device *dev)
 {
 	struct netdev_queue *queue = dev_ingress_queue(dev);
-- 
2.29.2


