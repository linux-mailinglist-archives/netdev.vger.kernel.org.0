Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAFC104040
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 17:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732052AbfKTQCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 11:02:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:40976 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728345AbfKTQCw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 11:02:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 12B67B2CAE;
        Wed, 20 Nov 2019 16:02:51 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: ipconfig: Wait for deferred device probes
Date:   Wed, 20 Nov 2019 17:02:36 +0100
Message-Id: <20191120160236.4459-1-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If network device drives are using deferred probing, it was possible
that waiting for devices to show up in ipconfig was already over,
when the device eventually showed up. By calling wait_for_device_probe()
we now make sure deferred probing is done before checking for available
devices.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 net/ipv4/ipconfig.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 9bcca08efec9..49b2381e857e 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1412,6 +1412,9 @@ static int __init wait_for_devices(void)
 		struct net_device *dev;
 		int found = 0;
 
+		/* make sure deferred device probes are finished */
+		wait_for_device_probe();
+
 		rtnl_lock();
 		for_each_netdev(&init_net, dev) {
 			if (ic_is_init_dev(dev)) {
-- 
2.16.4

