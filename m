Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF8D167E42
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 14:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgBUNRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 08:17:24 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52322 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728396AbgBUNRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 08:17:24 -0500
Received: by mail-wm1-f65.google.com with SMTP id p9so1768625wmc.2
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 05:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FTc1rk10cnfX4J56GZzu97M6l5mIGBSmD8V4smten6E=;
        b=XrlEaORzQNN9gwm5Fv43fsuSqd84waTsOCCEvR/+V2Lxj8YFJgo8NMRHDkgR1QrUnR
         vMD4KtNGHfbiTvA9OAfkMsLcq52woZXbKpNZCroX/BJP3rPK9COhJXuaHLl/VF5VVxC0
         OleWjP4R4R+rHidRCeRunE8paOgIy49dxVKwvumUhW8ij3dKM2cfq/bO8qoyOVeaH5QS
         91zi68UremHchMW8dqErXYutEjULt51D6vuzv0SKtuM4/CDpGNautlqYlfydZ4p54HoN
         DihuevNbeTg9Znnp5fd3vgOkdnIJFVe8xZcSMJL04CrgfvTLyHvLbhoRojKjTbnFuS2e
         DYTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FTc1rk10cnfX4J56GZzu97M6l5mIGBSmD8V4smten6E=;
        b=Aud90GlLle+9647vGyzc8vZzZ+J0zrHaGdpunm0+5MHM4GOVG6EwDMrccwaZV3FM5u
         PVjRuV91r0yG1hOK+C3ZZKnTJQKi5uY8uDgyONYdjNK/LrJEj6738HTX3BxvRZqSAHmN
         D3UYNtWLISL/q2JgPC7PW6VBBx7I+dTh3vyt5UxZzgDOinfJ//uPdRKR+qwLtI7GXbnK
         gMy4Z9Di6wuILRes/uEZoPAYMzYh2MrzUhRNIR4HjqecEnNPxb7q1EX2MJqGoIgYb7mb
         lFkEJWDx/J3pRDXCMdyEb4OPSjcOKOKQAbyMjibchEgUuDm1j1K0Sf8Zl971Rw3SHBTc
         Ec6A==
X-Gm-Message-State: APjAAAWnp3mgZmNbnZSszPA99IPYLaiEcKucCUbb5xZYNsg+f20FBgxB
        tU/lQiiDmodLa20oR6kMLJSVxHNBUG4=
X-Google-Smtp-Source: APXvYqx4+/cPeDaM12nmbCU+VmG/s7K8nw515O2solCSH20fpPpJJDvQoXSMbOnKN6KbHIHInvORjg==
X-Received: by 2002:a05:600c:2503:: with SMTP id d3mr3776505wma.84.1582291042721;
        Fri, 21 Feb 2020 05:17:22 -0800 (PST)
Received: from danielepa-ThinkCentre-M93p.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id z25sm3742131wmf.14.2020.02.21.05.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 05:17:21 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH 1/1] net: usb: qmi_wwan: restore mtu min/max values after raw_ip switch
Date:   Fri, 21 Feb 2020 14:17:05 +0100
Message-Id: <20200221131705.26053-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

usbnet creates network interfaces with min_mtu = 0 and
max_mtu = ETH_MAX_MTU.

These values are not modified by qmi_wwan when the network interface
is created initially, allowing, for example, to set mtu greater than 1500.

When a raw_ip switch is done (raw_ip set to 'Y', then set to 'N') the mtu
values for the network interface are set through ether_setup, with
min_mtu = ETH_MIN_MTU and max_mtu = ETH_DATA_LEN, not allowing anymore to
set mtu greater than 1500 (error: mtu greater than device maximum).

The patch restores the original min/max mtu values set by usbnet after a
raw_ip switch.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
 drivers/net/usb/qmi_wwan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 3b7a3b8a5e06..5754bb6ca0ee 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -337,6 +337,9 @@ static void qmi_wwan_netdev_setup(struct net_device *net)
 		netdev_dbg(net, "mode: raw IP\n");
 	} else if (!net->header_ops) { /* don't bother if already set */
 		ether_setup(net);
+		/* Restoring min/max mtu values set originally by usbnet */
+		net->min_mtu = 0;
+		net->max_mtu = ETH_MAX_MTU;
 		clear_bit(EVENT_NO_IP_ALIGN, &dev->flags);
 		netdev_dbg(net, "mode: Ethernet\n");
 	}
-- 
2.17.1

