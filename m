Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7D92AFA16
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 21:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgKKU4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 15:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgKKU4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 15:56:18 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02385C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 12:56:18 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id t9so3765307edq.8
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 12:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=0/KKpH3B4lHx3pgxOOzqHzJj6OUY1rYiLih/Lmvwi8I=;
        b=F4CQIVnDeNn4+LNVFHegnFcKEaXVyzywEASdmcPbmg24GM0OBeBSycQ/40L829qh8W
         goY3/GGZiAwBIaGOoa0DPI6DOI1/doNyErmV5xj7XaZlTn/m1OAwSZhXQ/JNLr2THdO+
         UMcEIEikiTJ3hqU8TiwUp2J+h+tSrmqV7WIFCdTXD8icWfvLziEmEaG5/iHqfu/Pwuay
         PfFoWOu5Ty0bHt4PvCAE/IaV8Ihn4uGx/cYm3lJ0FRWAvh83pXJlsqzFee3Ur28PczDe
         e5h8dh7g1Qnjg+GH8BNj4b4b9vGbrDpAwc+3mMla8HX0DcBg0VG59pKYpy9x49TW6Lwu
         A/Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=0/KKpH3B4lHx3pgxOOzqHzJj6OUY1rYiLih/Lmvwi8I=;
        b=p7AZNEfhkPQXvUWMpMT0H01JqjCrft0NPKuvGhubgVTTJRuH5kp7f/2dzVxmXoHXoP
         JK0/R2W/BqNEuPkaGyOtJwWdwatPiHrrqoU0TGkSI5N7EUbiJcyrRJ93NsdVir8UDg4D
         AnQTHUiE2al74Edb4cPJCxg8TJuU74tJM9Y6JJJLLCMMch7+P2wNpdeSBcle/lKxPJiI
         9D2NJxHN1nUefYvy+C8G7F8/RN9vWq0bhKH3U67r7n4g8YpwUPV+OouvobET6xsmpkoH
         a2ILYPfyOx6oEPDiUU2jDUXVYu0WgoEYFaSq8QATdCmKHPRR2ozjK7nhAD86Rrjq/kfJ
         wOmw==
X-Gm-Message-State: AOAM5301wxsYsJkdmlpIe6g2C/V+elA/eq1375qV36/+DUXzqzY0fCXY
        6DgWVhmCV8Za3yzGC09PeG8qrhGxIXd+Ow==
X-Google-Smtp-Source: ABdhPJx7NkssOkSG6hMdk/owb8R8w/i72pJ5lLGKoZ0+dgtEIqY8B0hxpybu3w8GB1nwNd/CVZ3EcA==
X-Received: by 2002:a50:d587:: with SMTP id v7mr1486894edi.38.1605128176350;
        Wed, 11 Nov 2020 12:56:16 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:b8a2:2ad2:2cb8:3612? (p200300ea8f232800b8a22ad22cb83612.dip0.t-ipconnect.de. [2003:ea:8f23:2800:b8a2:2ad2:2cb8:3612])
        by smtp.googlemail.com with ESMTPSA id x2sm1302276ejb.86.2020.11.11.12.56.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 12:56:15 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH RFC] net: core: support managed resource allocation in
 ndo_open
Message-ID: <1151799e-7faa-3d86-c610-9b9ebbd62637@gmail.com>
Date:   Wed, 11 Nov 2020 21:56:10 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quite often certain resources (irq, bigger chunks of memory) are
allocated not at probe time but in ndo_open. This requires to relaese
such resources in the right order in ndo_stop(), and in ndo_open()
error paths. Having said that the requirements are basically the same
as for releasing probe-time allocated resources in remove callback
and probe error paths.
So why not use the same mechanism to faciliate this? We have a big
number of device-managed resource allocation functions, so all we
need is a device suited for managed ndo_open resource allocation.
This RFC patch adds such a device to struct net_device. All we need
is a dozen lines of code. Resources then can be allocated with e.g.

struct device *devm = &dev->devres_up;
devm_kzalloc(devm, size, gfp);

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 15 +++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 72643c193..1fd2c1f3d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1803,6 +1803,7 @@ enum netdev_priv_flags {
  *	@garp_port:	GARP
  *	@mrp_port:	MRP
  *
+ *	@devres_up:	for managed resource allocation in ndo_open()
  *	@dev:		Class/net/name entry
  *	@sysfs_groups:	Space for optional device, statistics and wireless
  *			sysfs groups
@@ -2121,6 +2122,7 @@ struct net_device {
 	struct mrp_port __rcu	*mrp_port;
 #endif
 
+	struct device		devres_up;
 	struct device		dev;
 	const struct attribute_group *sysfs_groups[4];
 	const struct attribute_group *sysfs_rx_queue_group;
diff --git a/net/core/dev.c b/net/core/dev.c
index 81abc4f98..f2c345579 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1488,6 +1488,11 @@ void netdev_notify_peers(struct net_device *dev)
 }
 EXPORT_SYMBOL(netdev_notify_peers);
 
+static void netdev_release_devres_up(struct device *dev)
+{
+	memset(dev, 0, sizeof(*dev));
+}
+
 static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
@@ -1519,14 +1524,18 @@ static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 	if (ops->ndo_validate_addr)
 		ret = ops->ndo_validate_addr(dev);
 
+	device_initialize(&dev->devres_up);
+	dev->devres_up.release = netdev_release_devres_up;
+
 	if (!ret && ops->ndo_open)
 		ret = ops->ndo_open(dev);
 
 	netpoll_poll_enable(dev);
 
-	if (ret)
+	if (ret) {
+		put_device(&dev->devres_up);
 		clear_bit(__LINK_STATE_START, &dev->state);
-	else {
+	} else {
 		dev->flags |= IFF_UP;
 		dev_set_rx_mode(dev);
 		dev_activate(dev);
@@ -1606,6 +1615,8 @@ static void __dev_close_many(struct list_head *head)
 		if (ops->ndo_stop)
 			ops->ndo_stop(dev);
 
+		put_device(&dev->devres_up);
+
 		dev->flags &= ~IFF_UP;
 		netpoll_poll_enable(dev);
 	}
-- 
2.29.2

