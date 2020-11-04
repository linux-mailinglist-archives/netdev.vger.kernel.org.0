Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0192A6663
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgKDObf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgKDObe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:31:34 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97722C0613D3
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 06:31:34 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id y12so22262865wrp.6
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 06:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aw1qKrJDVTVGc9+faF8YMpoPIqDGI/C6NZGeaxcJruY=;
        b=QrI9H99CnOXLE9YZ52vL/jd7vSPJ7YbbQ+/GEz94K8jHJym6M/yW6n7dju4xj5lqvL
         5hPJigkMUPqI6te9DzILj1mVuLFH+niifOTv0c2T6V0eTSsbPZcuiNSsCl3/ijjcClQu
         bUR/gdg03fgrzruEuihWf7Wk8TATNkMygT5n3WM59gUq7r1Z2t7apZLRn+WRi61CSFi8
         5AjFr42vhN7BZhd53pz0xL5hkjD31ut3FEyPiTAD0EL9NukVbMfUQ0fxqExCPQwen50y
         iFVw20oY6bErmKuFp2yv1UG6O77jPSu5fgQ4+O73BmrronAtNcS3LCyis5A2LI2s62Zw
         C89Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aw1qKrJDVTVGc9+faF8YMpoPIqDGI/C6NZGeaxcJruY=;
        b=VXe68nvY6WJz1eRw5DV4xA5METCVMCKmQ8HG4+zgEXUu1TbTqRxIZjh2irGZd4RtsF
         U9oa9v/LuJ15McI8jM9TnmdAdzP1LnhWrN1fDEkSMjlQGeNsfUhMfkem5VH/ap8SKW3r
         lIiveUQvyjssHyAkPedIgIruBvYvYbnVLg44SCw8g1U1x+eHg05tNwzSfyDTr//byGs0
         5iEqe9J/dcMfSwUgAUGUdKZvctq8qHskvdM8Z87FE1icAVKOyABpWVJNmT507DzRaHim
         lxDamc2t2vYI4HVgWpxj8O7c7KzTW9FTtCyARpiFkXhiiSfPLVBL/0/Ww7oUhL+t1XII
         GaDA==
X-Gm-Message-State: AOAM533QqzOXc5+ctqbczAYyfizRsiIqc3Npa9acwNqAOn5M2GxeVG5R
        Z+EGVn9tB04W6KCMiu67Pbk=
X-Google-Smtp-Source: ABdhPJz307ULmxdDn5V8kkb2G/YjE3mN/nyh2Kax26+h4TOoNX1k539hzKbqFhhOjkZL0yu4Tvw5cQ==
X-Received: by 2002:adf:fe48:: with SMTP id m8mr32046522wrs.127.1604500293328;
        Wed, 04 Nov 2020 06:31:33 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:d177:63da:d01d:cf70? (p200300ea8f232800d17763dad01dcf70.dip0.t-ipconnect.de. [2003:ea:8f23:2800:d177:63da:d01d:cf70])
        by smtp.googlemail.com with ESMTPSA id g17sm2849624wrw.37.2020.11.04.06.31.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 06:31:32 -0800 (PST)
Subject: [PATCH net-next v2 01/10] net: core: add dev_get_tstats64 as a
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
References: <059fcb95-fba8-673e-0cd6-fb26e8ed4861@gmail.com>
Message-ID: <91133597-bd18-20ab-2a98-fd061ff90fed@gmail.com>
Date:   Wed, 4 Nov 2020 15:24:01 +0100
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
index 9e7f071b8..88acc03fa 100644
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


