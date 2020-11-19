Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E392B9947
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgKSR0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:26:06 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:38966 "EHLO smtp6-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727195AbgKSR0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 12:26:05 -0500
Received: from mail.corsac.net (unknown [IPv6:2a01:e34:ec2f:4e20::5])
        by smtp6-g21.free.fr (Postfix) with ESMTPS id 9968E7803BF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 18:25:33 +0100 (CET)
Received: from scapa.corsac.net (unknown [IPv6:2a01:e34:ec2f:4e20:6af7:28ff:fe8d:2119])
        by mail.corsac.net (Postfix) with ESMTPS id 6F82597
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 18:24:55 +0100 (CET)
Received: from corsac (uid 1000)
        (envelope-from corsac@corsac.net)
        id a024c
        by scapa.corsac.net (DragonFly Mail Agent v0.12);
        Thu, 19 Nov 2020 18:24:55 +0100
From:   Yves-Alexis Perez <corsac@corsac.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Habets <mhabets@solarflare.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yves-Alexis Perez <corsac@corsac.net>,
        Matti Vuorela <matti.vuorela@bitfactor.fi>,
        stable@vger.kernel.org
Subject: [PATCH] usbnet: ipheth: fix connectivity with iOS 14
Date:   Thu, 19 Nov 2020 18:24:39 +0100
Message-Id: <20201119172439.94988-1-corsac@corsac.net>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <CAAn0qaXmysJ9vx3ZEMkViv_B19ju-_ExN8Yn_uSefxpjS6g4Lw@mail.gmail.com>
References: <CAAn0qaXmysJ9vx3ZEMkViv_B19ju-_ExN8Yn_uSefxpjS6g4Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Starting with iOS 14 released in September 2020, connectivity using the
personal hotspot USB tethering function of iOS devices is broken.

Communication between the host and the device (for example ICMP traffic
or DNS resolution using the DNS service running in the device itself)
works fine, but communication to endpoints further away doesn't work.

Investigation on the matter shows that UDP and ICMP traffic from the
tethered host is reaching the Internet at all. For TCP traffic there are
exchanges between tethered host and server but packets are modified in
transit leading to impossible communication.

After some trials Matti Vuorela discovered that reducing the URB buffer
size by two bytes restored the previous behavior. While a better
solution might exist to fix the issue, since the protocol is not
publicly documented and considering the small size of the fix, let's do
that.

Tested-by: Matti Vuorela <matti.vuorela@bitfactor.fi>
Signed-off-by: Yves-Alexis Perez <corsac@corsac.net>
Link: https://lore.kernel.org/linux-usb/CAAn0qaXmysJ9vx3ZEMkViv_B19ju-_ExN8Yn_uSefxpjS6g4Lw@mail.gmail.com/
Link: https://github.com/libimobiledevice/libimobiledevice/issues/1038
Cc: stable@vger.kernel.org
---
 drivers/net/usb/ipheth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index b09b45382faf..207e59e74935 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -59,7 +59,7 @@
 #define IPHETH_USBINTF_SUBCLASS 253
 #define IPHETH_USBINTF_PROTO    1
 
-#define IPHETH_BUF_SIZE         1516
+#define IPHETH_BUF_SIZE         1514
 #define IPHETH_IP_ALIGN		2	/* padding at front of URB */
 #define IPHETH_TX_TIMEOUT       (5 * HZ)
 
-- 
2.29.2

