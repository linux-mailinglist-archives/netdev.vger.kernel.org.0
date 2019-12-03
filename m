Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E77110098
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 15:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfLCOtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 09:49:10 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34086 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfLCOtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 09:49:10 -0500
Received: by mail-lj1-f195.google.com with SMTP id m6so4170874ljc.1
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 06:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1JlQBMxxT3n3gAP2JXiQSbnDJJNfheSAcd5t6AqVGSo=;
        b=ZNiepIuLIrtejAWnmFt5t5qitJU02H4vfzlitq8/B/tjRfr3LDvPFFcJedFPx4QBj4
         lR9ECyCtLEfeXUwSAaC0s9+RJwXzI8+eRhLfOQF2EGiFfT26AgqdP7Eh6fJCwbAYuzKg
         ZGevXGPdnqQ1mOo+pkzDA+h/Z8Yf+kcd0D9hI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1JlQBMxxT3n3gAP2JXiQSbnDJJNfheSAcd5t6AqVGSo=;
        b=E78Da5RtqWdZni0G1lmkOn1YXEGW9bDzCP9HzynhOsfu/lWhAk1eoKovVNNd8Af61/
         l2k24NX6uScnQ401rfUWzxgKQ1b0ZfrlChlWJrjFSGV9Ci8vYhSa5X0y0UJIFP8iwMlY
         afqiR8asIPgU/017K8FLl251BvoMXW08ZO2Z+OTvPD0W9I1jfhz7tKT8j6+2SmvLBkY/
         8L5Gr5xF9F02T4RSB0/YXA+tC0vgfh0pKon8ntsIn3ks7e65mEcUrQ38meonG8doeVrI
         NPKCiZGMQWMIfi6urYwNeAPWqdbaL+ETBrPpcKilmXX/GPNFhHeprrkqDoY4IkLWEpDO
         MMsQ==
X-Gm-Message-State: APjAAAXcdnIXxDzJjnkYvud6Hy+0S4PIfy/+/SpCOEi6RzpfB7YMNQa7
        xFtlkDhWJ5bKXDDE+MR0qJgr0NsYViQ=
X-Google-Smtp-Source: APXvYqyeQS+jeZDXUd6p39xVya9AaTVQ/U1VEDHu8kGWPuGimAh0A5V8dmgxf8JLz9ZMx27PX7MYfQ==
X-Received: by 2002:a2e:9e55:: with SMTP id g21mr2758124ljk.245.1575384548149;
        Tue, 03 Dec 2019 06:49:08 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id c19sm1460976lff.79.2019.12.03.06.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 06:49:07 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, syzkaller-bugs@googlegroups.com,
        stephen@networkplumber.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        syzbot+2add91c08eb181fea1bf@syzkaller.appspotmail.com
Subject: [PATCH net] net: bridge: deny dev_set_mac_address() when unregistering
Date:   Tue,  3 Dec 2019 16:48:06 +0200
Message-Id: <20191203144806.10468-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have an interesting memory leak in the bridge when it is being
unregistered and is a slave to a master device which would change the
mac of its slaves on unregister (e.g. bond, team). This is a very
unusual setup but we do end up leaking 1 fdb entry because
dev_set_mac_address() would cause the bridge to insert the new mac address
into its table after all fdbs are flushed, i.e. after dellink() on the
bridge has finished and we call NETDEV_UNREGISTER the bond/team would
release it and will call dev_set_mac_address() to restore its original
address and that in turn will add an fdb in the bridge.
One fix is to check for the bridge dev's reg_state in its
ndo_set_mac_address callback and return an error if the bridge is not in
NETREG_REGISTERED.

Easy steps to reproduce:
 1. add bond in mode != A/B
 2. add any slave to the bond
 3. add bridge dev as a slave to the bond
 4. destroy the bridge device

Trace:
 unreferenced object 0xffff888035c4d080 (size 128):
   comm "ip", pid 4068, jiffies 4296209429 (age 1413.753s)
   hex dump (first 32 bytes):
     41 1d c9 36 80 88 ff ff 00 00 00 00 00 00 00 00  A..6............
     d2 19 c9 5e 3f d7 00 00 00 00 00 00 00 00 00 00  ...^?...........
   backtrace:
     [<00000000ddb525dc>] kmem_cache_alloc+0x155/0x26f
     [<00000000633ff1e0>] fdb_create+0x21/0x486 [bridge]
     [<0000000092b17e9c>] fdb_insert+0x91/0xdc [bridge]
     [<00000000f2a0f0ff>] br_fdb_change_mac_address+0xb3/0x175 [bridge]
     [<000000001de02dbd>] br_stp_change_bridge_id+0xf/0xff [bridge]
     [<00000000ac0e32b1>] br_set_mac_address+0x76/0x99 [bridge]
     [<000000006846a77f>] dev_set_mac_address+0x63/0x9b
     [<00000000d30738fc>] __bond_release_one+0x3f6/0x455 [bonding]
     [<00000000fc7ec01d>] bond_netdev_event+0x2f2/0x400 [bonding]
     [<00000000305d7795>] notifier_call_chain+0x38/0x56
     [<0000000028885d4a>] call_netdevice_notifiers+0x1e/0x23
     [<000000008279477b>] rollback_registered_many+0x353/0x6a4
     [<0000000018ef753a>] unregister_netdevice_many+0x17/0x6f
     [<00000000ba854b7a>] rtnl_delete_link+0x3c/0x43
     [<00000000adf8618d>] rtnl_dellink+0x1dc/0x20a
     [<000000009b6395fd>] rtnetlink_rcv_msg+0x23d/0x268

Fixes: 43598813386f ("bridge: add local MAC address to forwarding table (v2)")
Reported-by: syzbot+2add91c08eb181fea1bf@syzkaller.appspotmail.com
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
An alternative is to move the fdb flush to br_dev_uninit() but that
would ruin the symmetry with br_dev_init(). Since this is an extremely
unlikely case I think this fix is safer and easier for backports.

 net/bridge/br_device.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 434effde02c3..539d55baae78 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -245,6 +245,12 @@ static int br_set_mac_address(struct net_device *dev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
+	/* dev_set_mac_addr() can be called by a master device on bridge's
+	 * NETDEV_UNREGISTER, but since it's being destroyed do nothing
+	 */
+	if (dev->reg_state != NETREG_REGISTERED)
+		return -EBUSY;
+
 	spin_lock_bh(&br->lock);
 	if (!ether_addr_equal(dev->dev_addr, addr->sa_data)) {
 		/* Mac address will be changed in br_stp_change_bridge_id(). */
-- 
2.21.0

