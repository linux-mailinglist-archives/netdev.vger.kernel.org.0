Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 441DF140940
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 12:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgAQLte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 06:49:34 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37998 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbgAQLte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 06:49:34 -0500
Received: by mail-oi1-f195.google.com with SMTP id l9so21903023oii.5
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 03:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.org; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=4CZYUggXjSVACFUgrFQV4I7E9cPHhzA2Am1eliCYB4U=;
        b=PBBTEXuLXIPaWaYXk/JJmdHpSvHI2VWOgTB1+P/ZIlCEpou+sCZAozndXtEKu19U8v
         C9blUFc6pa13Dl7Mm2fBNHQERFhNXw4E9/H7Z/7NHGutZAYRO2R7egZJAjyrimCJn5Ie
         LWTsW55OX7jT1X+UIBo7xMm0wFmNDQlVbQgWiArID4lcuNRM7taBAuIHGXlGHmZMHpLp
         m1Cd9NcohOJc9gU0hxh8n1GkGThVjqqlfjpX97rul/jmYAx8pHoKylF52dIQKDUtI7Vr
         k3zM5cWQFyrFd1hZfzoFSA4G16QUSuQO7KeAt5h0AJ+ajh331CBnK8zYhf487aqO3EPP
         y3VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=4CZYUggXjSVACFUgrFQV4I7E9cPHhzA2Am1eliCYB4U=;
        b=Xakb0NiOr68bksbrBJEHeWQi6Lx675YYfWdrj9Ter1T0RfPs9/VkeEfCG2Oru4Vi0x
         7pdK+jqa4UnjlkXNGhhAjeHWyG0xaUTxyR1962+1g61l34quxOa82Gd15jJrtZYZOU0p
         vuO4Ejq4/7gQL/ONbmwyRG1EtXLH7eA8r8Avi+97ECN2ibgbgAYSZm+iCWW1r7bRdn7X
         0YyBXCkJsoogUJEpkrTE/NNoaEPbquHQkF/6eQhqpsIqQ9HvHHXcjDYAYXSXjNBUIaKq
         aWFU9lOasKuAw69j10ZnetZp4ZkD50ERfHCP/At1Aw1aSoQPlydG0rklnD73MbDEoH3V
         fjJQ==
X-Gm-Message-State: APjAAAVYZtnFSgvW3IHF8bShn0F7xp9XiRzRbcuvuuwsITaDE2DzuNKB
        TsFLg9pWrICy/WVWZlPWbfGz6cTsvcSvTDYxCkcQVABhED0=
X-Google-Smtp-Source: APXvYqye4OnNAjdBk8e3hWYzcZBAo/6qJrNxaE7P7ryB4tzq6B4H/Rmqv/OJVf7GiA3gw1tvwXUfrZiDiHXOcLNKA6k=
X-Received: by 2002:a05:6808:9b4:: with SMTP id e20mr2908222oig.37.1579261773220;
 Fri, 17 Jan 2020 03:49:33 -0800 (PST)
MIME-Version: 1.0
From:   James Hughes <james.hughes@raspberrypi.org>
Date:   Fri, 17 Jan 2020 11:49:23 +0000
Message-ID: <CAE_XsMLw5xnwGv6vjMqWnHqy7KjsgooujbTz+dEzNCdVrve9Nw@mail.gmail.com>
Subject: [PATCH net] net: usb: lan78xx : implement .ndo_features_check
To:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As reported by Eric Dumazet, there are still some outstanding
cases where the driver does not handle TSO correctly when skb's
are over a certain size. Most cases have been fixed, this patch
should ensure that forwarded SKB's that are greater than
MAX_SINGLE_PACKET_SIZE - TX_OVERHEAD are software segmented
and handled correctly.

Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
Reported-by: Eric Dumazet <edumazet@google.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
---
 drivers/net/usb/lan78xx.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index bc572b921fe1..a01c78d8b9a3 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -31,6 +31,7 @@
 #include <linux/mdio.h>
 #include <linux/phy.h>
 #include <net/ip6_checksum.h>
+#include <net/vxlan.h>
 #include <linux/interrupt.h>
 #include <linux/irqdomain.h>
 #include <linux/irq.h>
@@ -3733,6 +3734,19 @@ static void lan78xx_tx_timeout(struct net_device *net)
  tasklet_schedule(&dev->bh);
 }

+static netdev_features_t lan78xx_features_check(struct sk_buff *skb,
+ struct net_device *netdev,
+ netdev_features_t features)
+{
+ if (skb->len + TX_OVERHEAD > MAX_SINGLE_PACKET_SIZE)
+ features &= ~NETIF_F_GSO_MASK;
+
+ features = vlan_features_check(skb, features);
+ features = vxlan_features_check(skb, features);
+
+ return features;
+}
+
 static const struct net_device_ops lan78xx_netdev_ops = {
  .ndo_open = lan78xx_open,
  .ndo_stop = lan78xx_stop,
@@ -3746,6 +3760,7 @@ static const struct net_device_ops lan78xx_netdev_ops = {
  .ndo_set_features = lan78xx_set_features,
  .ndo_vlan_rx_add_vid = lan78xx_vlan_rx_add_vid,
  .ndo_vlan_rx_kill_vid = lan78xx_vlan_rx_kill_vid,
+ .ndo_features_check = lan78xx_features_check,
 };

 static void lan78xx_stat_monitor(struct timer_list *t)
-- 
2.17.1
