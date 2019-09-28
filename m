Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1586C116B
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 18:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbfI1Quv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 12:50:51 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45283 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfI1Quv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 12:50:51 -0400
Received: by mail-pl1-f194.google.com with SMTP id u12so2248687pls.12;
        Sat, 28 Sep 2019 09:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WGmCj+EzADgagaHq4m2frUsV7PtkZi9w2xNwBqjwIs4=;
        b=Zd/viF3M74FYZdxWNCEMdS1eJiNqHacTIY7qye+XdyRfI63Ah6BONEOS3RbJaRd7uX
         k/MwEckjfIIFdY9uScGpoTqmYHsL2/xpZBDGEz4TjTo7W6UiNaesrPgFhzaq7fPezxCA
         Bk5MlDeB1Jcd6zTIi2ZRUqmdwAUV2OrxW9c+ZA0QvlOvX7kOnaSRAwrxl0AeFFpOTnZ5
         1F1quqkmSoDodH6rrxTeVcAjKZu+Xo3sBaHEffEKLghSHWIk7Oa02bL4xNW3hPDJbvuk
         mvnSFOAh9A+wPvmMt0HDYp0x/k8l8R/1xMXm1dZn9I4pnd0t3CjUEAyr5K3CDrQ2KyAn
         IxRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WGmCj+EzADgagaHq4m2frUsV7PtkZi9w2xNwBqjwIs4=;
        b=YgNYdyJ222XE1Z/OL9aKvsFfRrl9Y+yle1CzQD3VMlpEOvScXx3rM+ixsDPv5uGz6t
         sHi6ZERIFglPci+4ndS6J2XH4uWAAQSkMxje+/uidUYVtayQE3aB+i7JDDCqycbxVSY0
         37vcxhgTBKk1jF4/RfUdluQAE5le1pgJ+u3ZslOD1FtHPu8kqfXI2nFfRBbjlQfZHeMT
         AVwNBvSn0AdMdDym0XiKJe3TPs2SwDTI835cpjhleQI/Bm2xMNAUf7BR3BFpr1BzmSv7
         yJesZghbzb9QZ8z9wUezvfg2Ng/8Z3fJf56wS47uvRXU8M8KIu+A/tx0siPswEWrkuna
         HtPA==
X-Gm-Message-State: APjAAAXfnXa7YUcPTtIG3XjRibCgSS28w/ccJ0IPIj7rl4Qn6m87wLtR
        iPOh+CRC5TSR7BSp8Pt95B0=
X-Google-Smtp-Source: APXvYqy0uIJBZ2GOlmjZwL3ywOkJNx5QSNg9GPATY8XC9xI9xordaY7vGafPPhNLy3j4NOHDuqFYnA==
X-Received: by 2002:a17:902:222:: with SMTP id 31mr11582519plc.167.1569689450181;
        Sat, 28 Sep 2019 09:50:50 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id 30sm8663092pjk.25.2019.09.28.09.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 09:50:49 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, jakub.kicinski@netronome.com,
        johannes@sipsolutions.net, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jiri@resnulli.us, sd@queasysnail.net,
        roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Cc:     ap420073@gmail.com
Subject: [PATCH net v4 12/12] virt_wifi: fix refcnt leak in module exit routine
Date:   Sat, 28 Sep 2019 16:48:43 +0000
Message-Id: <20190928164843.31800-13-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190928164843.31800-1-ap420073@gmail.com>
References: <20190928164843.31800-1-ap420073@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virt_wifi_newlink() calls netdev_upper_dev_link() and it internally
holds reference count of lower interface.

Current code does not release a reference count of the lower interface
when the lower interface is being deleted.
So, reference count leaks occur.

Test commands:
    ip link add dummy0 type dummy
    ip link add vw1 link dummy0 type virt_wifi

Splat looks like:
[  182.001918][ T1333] WARNING: CPU: 0 PID: 1333 at net/core/dev.c:8638 rollback_registered_many+0x75d/0xda0
[  182.002724][ T1333] Modules linked in: virt_wifi cfg80211 dummy veth openvswitch nsh nf_conncount nf_nat nf_conntrack6
[  182.002724][ T1333] CPU: 0 PID: 1333 Comm: ip Not tainted 5.3.0+ #370
[  182.002724][ T1333] RIP: 0010:rollback_registered_many+0x75d/0xda0
[  182.002724][ T1333] Code: 0c 00 00 48 89 de 4c 89 ff e8 6f 5a 04 00 48 89 df e8 c7 26 fd ff 84 c0 0f 84 a5 fd ff ff 40
[  182.002724][ T1333] RSP: 0018:ffff88810900f348 EFLAGS: 00010286
[  182.002724][ T1333] RAX: 0000000000000024 RBX: ffff88811361d700 RCX: 0000000000000000
[  182.002724][ T1333] RDX: 0000000000000024 RSI: 0000000000000008 RDI: ffffed1021201e5f
[  182.002724][ T1333] RBP: ffff88810900f4e0 R08: ffffed1022c3ff71 R09: ffffed1022c3ff71
[  182.002724][ T1333] R10: 0000000000000001 R11: ffffed1022c3ff70 R12: dffffc0000000000
[  182.002724][ T1333] R13: ffff88810900f460 R14: ffff88810900f420 R15: ffff8881075f1940
[  182.002724][ T1333] FS:  00007f77c42240c0(0000) GS:ffff888116000000(0000) knlGS:0000000000000000
[  182.002724][ T1333] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  182.002724][ T1333] CR2: 00007f77c3706240 CR3: 000000011139e000 CR4: 00000000001006f0
[  182.002724][ T1333] Call Trace:
[  182.002724][ T1333]  ? generic_xdp_install+0x310/0x310
[  182.002724][ T1333]  ? check_chain_key+0x236/0x5d0
[  182.002724][ T1333]  ? __nla_validate_parse+0x98/0x1ad0
[  182.002724][ T1333]  unregister_netdevice_many.part.123+0x13/0x1b0
[  182.002724][ T1333]  rtnl_delete_link+0xbc/0x100
[  182.002724][ T1333]  ? rtnl_af_register+0xc0/0xc0
[  182.002724][ T1333]  rtnl_dellink+0x2e7/0x870
[ ... ]

[  192.874736][ T1333] unregister_netdevice: waiting for dummy0 to become free. Usage count = 1

This patch adds notifier routine to delete upper interface before deleting
lower interface.

Fixes: c7cdba31ed8b ("mac80211-next: rtnetlink wifi simulation device")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v4:
 - Add this new patch to fix refcnt leaks in the virt_wifi module

 drivers/net/wireless/virt_wifi.c | 51 ++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/virt_wifi.c b/drivers/net/wireless/virt_wifi.c
index be92e1220284..aadbacb01c8d 100644
--- a/drivers/net/wireless/virt_wifi.c
+++ b/drivers/net/wireless/virt_wifi.c
@@ -590,6 +590,42 @@ static struct rtnl_link_ops virt_wifi_link_ops = {
 	.priv_size	= sizeof(struct virt_wifi_netdev_priv),
 };
 
+static inline bool netif_is_virt_wifi_dev(const struct net_device *dev)
+{
+	return rcu_access_pointer(dev->rx_handler) == virt_wifi_rx_handler;
+}
+
+static int virt_wifi_event(struct notifier_block *this, unsigned long event,
+			   void *ptr)
+{
+	struct net_device *lower_dev = netdev_notifier_info_to_dev(ptr);
+	struct virt_wifi_netdev_priv *priv;
+	struct net_device *upper_dev;
+	LIST_HEAD(list_kill);
+
+	if (!netif_is_virt_wifi_dev(lower_dev))
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case NETDEV_UNREGISTER:
+		priv = rtnl_dereference(lower_dev->rx_handler_data);
+		if (!priv)
+			return NOTIFY_DONE;
+
+		upper_dev = priv->upperdev;
+
+		upper_dev->rtnl_link_ops->dellink(upper_dev, &list_kill);
+		unregister_netdevice_many(&list_kill);
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block virt_wifi_notifier = {
+	.notifier_call = virt_wifi_event,
+};
+
 /* Acquires and releases the rtnl lock. */
 static int __init virt_wifi_init_module(void)
 {
@@ -598,14 +634,24 @@ static int __init virt_wifi_init_module(void)
 	/* Guaranteed to be locallly-administered and not multicast. */
 	eth_random_addr(fake_router_bssid);
 
+	err = register_netdevice_notifier(&virt_wifi_notifier);
+	if (err)
+		return err;
+
 	common_wiphy = virt_wifi_make_wiphy();
 	if (!common_wiphy)
-		return -ENOMEM;
+		goto notifier;
 
 	err = rtnl_link_register(&virt_wifi_link_ops);
 	if (err)
-		virt_wifi_destroy_wiphy(common_wiphy);
+		goto destroy_wiphy;
 
+	return 0;
+
+destroy_wiphy:
+	virt_wifi_destroy_wiphy(common_wiphy);
+notifier:
+	unregister_netdevice_notifier(&virt_wifi_notifier);
 	return err;
 }
 
@@ -615,6 +661,7 @@ static void __exit virt_wifi_cleanup_module(void)
 	/* Will delete any devices that depend on the wiphy. */
 	rtnl_link_unregister(&virt_wifi_link_ops);
 	virt_wifi_destroy_wiphy(common_wiphy);
+	unregister_netdevice_notifier(&virt_wifi_notifier);
 }
 
 module_init(virt_wifi_init_module);
-- 
2.17.1

