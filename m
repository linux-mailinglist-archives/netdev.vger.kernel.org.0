Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241D42F251F
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387674AbhALAtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730281AbhALAtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 19:49:20 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6F0C061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 16:48:39 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id jx16so1010513ejb.10
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 16:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/EZeN1Iljg8Kh5+a3eVjNv/MulH7ZnSS2UBjRaJIoVw=;
        b=Yt0eJbrgnBCafb/fYv3ZgVq9GO9tVfiiBlIyBbwktbMHlULYKk2wMN/Lh94jEADMeg
         2y8goiI4YMI5b8cPLzSn3DgQO3+4Wj+JIJxDdRTuNe6B/Gdr+0omaB0XZgFeOUWKPgxs
         09kVH5o1JW+SSVHmVRZXucT0lIG/sXc7vNJOPPw/Ww1DbO3zzjXZP88XMqOE6stov5Kp
         Z6wAiu7B3f5A8vGRwpJuiCoS/zm9UrcKUrr/1sd9a3UhLdSTuIDItNJMSm/dBYdx/7fS
         UtHuUCjiDnkDsHIrvk57i6QyKKtYe43deJs06vGMzyw+FD/sLuRzoMfSxUQwNqi91r24
         d7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/EZeN1Iljg8Kh5+a3eVjNv/MulH7ZnSS2UBjRaJIoVw=;
        b=QyLA7uwTM3oNrPAGPC2qBx428pi0iQ3DWGiodb02taXlAji2xhfDs+/bNUaK4c1K8C
         BinPw0oYsl2B/TTc0Uk615hyBgCm9XMXVh+E+79WCM9Pgl43m2RdPaL3IGFFh8oahHya
         sxMJKtS7Dzl4m07vv2p1xsDycK5oZP7O8ELapOIw7MotOkHoSLR8cCAXpWXCOjUf+CPg
         zn8xrsJux1ka/5wDkMWn8h770//vskLCI1bI3LlQLspNv09BLrUGpxcnJOy/1p0ej5/T
         GV4JPkuvKd3mMLOpmOdFlhBNbIkOGOU0PAiBgmZ5hBxNi8sYmrpHPhQxTRR4nKr4d6mo
         C9fQ==
X-Gm-Message-State: AOAM533G7vmmKoDx0WpOLBpXy67RYa9cgA32R2Gu6Z++O4bhu7FkKa8V
        nJCR8uC7tO19xy3UZMKcaIwAPrSxhGo=
X-Google-Smtp-Source: ABdhPJzAd89DLYCyT4W705WpRlPZmKlpCishgbgNC/HKIeWjFeRabdbeVG19CObWs+Ybc1TFthAZKw==
X-Received: by 2002:a17:906:ce51:: with SMTP id se17mr1355282ejb.314.1610412518644;
        Mon, 11 Jan 2021 16:48:38 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id p22sm500791ejx.59.2021.01.11.16.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 16:48:38 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: [PATCH net] net: dsa: clear devlink port type before unregistering slave netdevs
Date:   Tue, 12 Jan 2021 02:48:31 +0200
Message-Id: <20210112004831.3778323-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Florian reported a use-after-free bug in devlink_nl_port_fill found with
KASAN:

(devlink_nl_port_fill)
(devlink_port_notify)
(devlink_port_unregister)
(dsa_switch_teardown.part.3)
(dsa_tree_teardown_switches)
(dsa_unregister_switch)
(bcm_sf2_sw_remove)
(platform_remove)
(device_release_driver_internal)
(device_links_unbind_consumers)
(device_release_driver_internal)
(device_driver_detach)
(unbind_store)

Allocated by task 31:
 alloc_netdev_mqs+0x5c/0x50c
 dsa_slave_create+0x110/0x9c8
 dsa_register_switch+0xdb0/0x13a4
 b53_switch_register+0x47c/0x6dc
 bcm_sf2_sw_probe+0xaa4/0xc98
 platform_probe+0x90/0xf4
 really_probe+0x184/0x728
 driver_probe_device+0xa4/0x278
 __device_attach_driver+0xe8/0x148
 bus_for_each_drv+0x108/0x158

Freed by task 249:
 free_netdev+0x170/0x194
 dsa_slave_destroy+0xac/0xb0
 dsa_port_teardown.part.2+0xa0/0xb4
 dsa_tree_teardown_switches+0x50/0xc4
 dsa_unregister_switch+0x124/0x250
 bcm_sf2_sw_remove+0x98/0x13c
 platform_remove+0x44/0x5c
 device_release_driver_internal+0x150/0x254
 device_links_unbind_consumers+0xf8/0x12c
 device_release_driver_internal+0x84/0x254
 device_driver_detach+0x30/0x34
 unbind_store+0x90/0x134

What happens is that devlink_port_unregister emits a netlink
DEVLINK_CMD_PORT_DEL message which associates the devlink port that is
getting unregistered with the ifindex of its corresponding net_device.
Only trouble is, the net_device has already been unregistered.

It looks like we can stub out the search for a corresponding net_device
if we clear the devlink_port's type. This looks like a bit of a hack,
but also seems to be the reason why the devlink_port_type_clear function
exists in the first place.

Fixes: 3122433eb533 ("net: dsa: Register devlink ports before calling DSA driver setup()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index c05b1b54c4f7..839c3a770d23 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -353,9 +353,13 @@ static int dsa_port_devlink_setup(struct dsa_port *dp)
 
 static void dsa_port_teardown(struct dsa_port *dp)
 {
+	struct devlink_port *dlp = &dp->devlink_port;
+
 	if (!dp->setup)
 		return;
 
+	devlink_port_type_clear(dlp);
+
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
 		break;
-- 
2.25.1

