Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF75BA056F
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfH1O6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:58:18 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37703 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfH1O6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 10:58:17 -0400
Received: by mail-wr1-f68.google.com with SMTP id z11so138124wrt.4
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 07:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nA1t6hIpZCFd0iG4w43rTL1Fyg561GbLFe0cwUNcQfY=;
        b=DcsMq/re6gIrVuQl5OTZyJ3b6vAQfIq+FybfzuwcE0aktn6HW2pJBJ59Eh4zlXLSWS
         5z9tYyAtBSVyMCWstk5tXZPPpILsSzgn5BI6ZOw/FfRbcQc4Ec6nuG6TShfxjIFA6swp
         StkfI+I9VrbW7ke9XpIPcnk9FwhKLivoN3ljNooJGNeE3Hj+E7wcYGA3OCBW5yqDpZz3
         ir1Sm4eN5G7iMZQgiJ95Yu0I+b+1IIwJ4LjA4nAfQwz3Omad9qbmlWeZcl8lBU2hX6jP
         Ni+6EP4aL5J89JQhfxIXGQYEEVP12aI7d6GmlrdRt0fUElBASFQh6rBq9dLAFmPChwTq
         MXnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nA1t6hIpZCFd0iG4w43rTL1Fyg561GbLFe0cwUNcQfY=;
        b=TCZ8kENYb2nyU87yrOH39fJLrkV/mLfE8ZFjVmIzRcFw+MqeToIqtV9vyZxsBURCms
         xQGcv5eFgozudymR/eO9EvEOgCECPvzM6BXHWNlG/b6RzdEhPBdqYk1/9yo+mhX84mRk
         crhdq1sGf2mrsUZdljQk7Pm+3w/lE5R8S8B6EABnm9nnWGEViHYFon844y/AzE68nI9G
         d0OfZdZDxsg3YZolYZvRc42H/E2FQRfXT7eeIOVaDkRbo24nIa6BKUjunqQhlXng6yua
         BkX7UkVb2jz+zsDaGQciWEKfYb8nH9AbnQtky1EqjBloFMC2W8LxIxyQL9A5JWZZMW7r
         IKew==
X-Gm-Message-State: APjAAAXAIw1IbF/d/FW4awpF+OAZTl2GREEOdMp/YFTKR6C8Y87SCxI9
        nbippbW7w4trgFpWw9mH+Yc=
X-Google-Smtp-Source: APXvYqxbayafR+/wiB/wFxOPH8pKJD9yn+6EAYWiIkqnwQ17lv066TUYetubQQrAaYd4IRRzCp3Uig==
X-Received: by 2002:adf:e444:: with SMTP id t4mr4996086wrm.262.1567004294074;
        Wed, 28 Aug 2019 07:58:14 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id o2sm3284190wmh.9.2019.08.28.07.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 07:58:13 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        asolokha@kb.kras.ru
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [RFC PATCH 1/1] phylink: Set speed to SPEED_UNKNOWN when there is no PHY connected
Date:   Wed, 28 Aug 2019 17:58:02 +0300
Message-Id: <20190828145802.3609-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190828145802.3609-1-olteanv@gmail.com>
References: <20190828145802.3609-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phylink_ethtool_ksettings_get can be called while the interface may not
even be up, which should not be a problem. But there are drivers (e.g.
gianfar) which connect to the PHY in .ndo_open and disconnect in
.ndo_close. While odd, to my knowledge this is again not illegal and
there may be more that do the same. But PHYLINK for example has this
check in phylink_ethtool_ksettings_get:

	if (pl->phydev) {
		phy_ethtool_ksettings_get(pl->phydev, kset);
	} else {
		kset->base.port = pl->link_port;
	}

So it will not populate kset->base.speed if there is no PHY connected.
The speed will be 0, by way of a previous memset. Not SPEED_UNKNOWN.
It is arguable whether that is legal or not. include/uapi/linux/ethtool.h
says:

	All values 0 to INT_MAX are legal.

By that measure it may be. But it sure would make users of the
__ethtool_get_link_ksettings API need make more complicated checks
(against -1, against 0, 1, etc). So far the kernel community has been ok
with just checking for SPEED_UNKNOWN.

Take net/sched/sch_taprio.c for example. The check in
taprio_set_picos_per_byte is currently not robust enough and will
trigger this division by zero, due to PHYLINK not setting SPEED_UNKNOWN:

	if (!__ethtool_get_link_ksettings(dev, &ecmd) &&
	    ecmd.base.speed != SPEED_UNKNOWN)
		picos_per_byte = div64_s64(NSEC_PER_SEC * 1000LL * 8,
					   ecmd.base.speed * 1000 * 1000);

[   27.109992] Division by zero in kernel.
[   27.113842] CPU: 1 PID: 198 Comm: tc Not tainted 5.3.0-rc5-01246-gc4006b8c2637-dirty #212
[   27.121974] Hardware name: Freescale LS1021A
[   27.126234] [<c03132e0>] (unwind_backtrace) from [<c030d8b8>] (show_stack+0x10/0x14)
[   27.133938] [<c030d8b8>] (show_stack) from [<c10b21b0>] (dump_stack+0xb0/0xc4)
[   27.141124] [<c10b21b0>] (dump_stack) from [<c10af97c>] (Ldiv0_64+0x8/0x18)
[   27.148052] [<c10af97c>] (Ldiv0_64) from [<c0700260>] (div64_u64+0xcc/0xf0)
[   27.154978] [<c0700260>] (div64_u64) from [<c07002d0>] (div64_s64+0x4c/0x68)
[   27.161993] [<c07002d0>] (div64_s64) from [<c0f3d890>] (taprio_set_picos_per_byte+0xe8/0xf4)
[   27.170388] [<c0f3d890>] (taprio_set_picos_per_byte) from [<c0f3f614>] (taprio_change+0x668/0xcec)
[   27.179302] [<c0f3f614>] (taprio_change) from [<c0f2bc24>] (qdisc_create+0x1fc/0x4f4)
[   27.187091] [<c0f2bc24>] (qdisc_create) from [<c0f2c0c8>] (tc_modify_qdisc+0x1ac/0x6f8)
[   27.195055] [<c0f2c0c8>] (tc_modify_qdisc) from [<c0ee9604>] (rtnetlink_rcv_msg+0x268/0x2dc)
[   27.203449] [<c0ee9604>] (rtnetlink_rcv_msg) from [<c0f4fef0>] (netlink_rcv_skb+0xe0/0x114)
[   27.211756] [<c0f4fef0>] (netlink_rcv_skb) from [<c0f4f6cc>] (netlink_unicast+0x1b4/0x22c)
[   27.219977] [<c0f4f6cc>] (netlink_unicast) from [<c0f4fa84>] (netlink_sendmsg+0x284/0x340)
[   27.228198] [<c0f4fa84>] (netlink_sendmsg) from [<c0eae5fc>] (sock_sendmsg+0x14/0x24)
[   27.235988] [<c0eae5fc>] (sock_sendmsg) from [<c0eaedf8>] (___sys_sendmsg+0x214/0x228)
[   27.243863] [<c0eaedf8>] (___sys_sendmsg) from [<c0eb015c>] (__sys_sendmsg+0x50/0x8c)
[   27.251652] [<c0eb015c>] (__sys_sendmsg) from [<c0301000>] (ret_fast_syscall+0x0/0x54)
[   27.259524] Exception stack(0xe8045fa8 to 0xe8045ff0)
[   27.264546] 5fa0:                   b6f608c8 000000f8 00000003 bed7e2f0 00000000 00000000
[   27.272681] 5fc0: b6f608c8 000000f8 004ce54c 00000128 5d3ce8c7 00000000 00000026 00505c9c
[   27.280812] 5fe0: 00000070 bed7e298 004ddd64 b6dd1e64

Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/phy/phylink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index a45c5de96ab1..3522eaf3e80c 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1112,6 +1112,7 @@ int phylink_ethtool_ksettings_get(struct phylink *pl,
 	if (pl->phydev) {
 		phy_ethtool_ksettings_get(pl->phydev, kset);
 	} else {
+		kset->base.speed = SPEED_UNKNOWN;
 		kset->base.port = pl->link_port;
 	}
 
-- 
2.17.1

