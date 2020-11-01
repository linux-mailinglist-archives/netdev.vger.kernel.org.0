Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A272A1DEA
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgKAMi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgKAMiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:38:25 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF9DC0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 04:38:24 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id c9so5270457wml.5
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 04:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gdegWtgslZzv1oOGs9jNw16Oe2fIU6dIwUXJctoYspc=;
        b=mkiM6PUSqWq6mvYotOlVKCJoH3zKe9k1r60nCoNJw9bXdGowgnaNRtQGHl7Yl7RZmc
         d62w3j/zIel1yAlx/hxDHIQE/RCkuIAKoBRlnNLe+cj/74EBmf2LXuYrL3ksjS7B6sx8
         tplxqoYgQPWks0IpXs32N2YZEjxNsvYLhhR9eZwx9nU21PxZJBOzo1EM/zSapknPHaXb
         8LDScE6WtzUKn+eU3GspaFOsQgkW9jnCR2qCP2NigaTvUjQ9HO/AmMXpKUkBn1ciAU4f
         n4exGZNGG0sU6A9xcNF6BPyThJ8sg5I3Qn0Ru6dUCrDRT+XQKm65FmhvA9wf3Wj+xlDz
         dzKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gdegWtgslZzv1oOGs9jNw16Oe2fIU6dIwUXJctoYspc=;
        b=C8iERupfHUswPmuf/4EHRKTGCd7+fG7BjjL+yA5tAHwp5duRV3VTEzBr8QFY4iQjvM
         JJjdNQLZqWSrSRa8u6v5xwIawC35TuGSKRaiTNckCc9LteyMnGIfZXzCEVx5R0GspDiT
         eCScHmvO804yU51EWF2SMpkk83L48n+VtAZn1elXHhPyFe4f4LRgMmk1UmyAWLgTY5jN
         f9dG33OabTSPmT00c0fQTJnQkTv7fvEetzeo4eC8DnjIAOHnJbX1m/edOE2UC6AB00qN
         JBjNMEgJv0saHqcsWq8onC6AIhATFOp1XeojsAJ9T7eoCgit7hDKgoSjpgpC79pk+rDM
         a3JA==
X-Gm-Message-State: AOAM533cg8gKiYQQcyqjU9PjZ6o1hR+2/lOkZKOI/emKeTZgJw8/FNRg
        c8lD4/x6zuG9L/IsUyTg9Leocn0X5NQ=
X-Google-Smtp-Source: ABdhPJwXN91E3xAg/uapn4V7DT31NhFvjQN3gtvQqv4ScuG3sYceATbgp26pCYdqSFkm1QLozaxmJw==
X-Received: by 2002:a1c:b18a:: with SMTP id a132mr13074917wmf.59.1604234303250;
        Sun, 01 Nov 2020 04:38:23 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:dc4f:e3f6:2803:90d0? (p200300ea8f232800dc4fe3f6280390d0.dip0.t-ipconnect.de. [2003:ea:8f23:2800:dc4f:e3f6:2803:90d0])
        by smtp.googlemail.com with ESMTPSA id h12sm2009185wrw.70.2020.11.01.04.38.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2020 04:38:22 -0800 (PST)
Subject: [PATCH net-next 1/5] net: core: add dev_get_tstats64 as a
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
        Russell King <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <25c7e008-c3fb-9fcd-f518-5d36e181c0cb@gmail.com>
Message-ID: <4580e187-9c2f-dfdf-d135-a5c420451428@gmail.com>
Date:   Sun, 1 Nov 2020 13:34:10 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <25c7e008-c3fb-9fcd-f518-5d36e181c0cb@gmail.com>
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

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6e06fef32..72643c193 100644
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
index 82dc6b48e..81abc4f98 100644
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


