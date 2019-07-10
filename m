Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8AE6415B
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 08:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfGJGZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 02:25:20 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40432 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfGJGZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 02:25:20 -0400
Received: by mail-pg1-f195.google.com with SMTP id w10so700154pgj.7
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 23:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wcpl0XLRpCjaSCxXow32w/BWxBMtdYG2Hk4yghbRTdg=;
        b=diGVTxwiZ6lHuhIfaOt3hBMzgbkaUvpqGPMLSZ/ztYu+ND/aDZgq3ti+DaI9sLjXws
         oJM8Hnnts/RSkH0dqMOt0lBH/4kAgZv7OiPc4/VfotKhxA27FVoBHVoBOKjO6s3nPwHR
         A9limjvImZpW9u3u1JHF6Shuy9VVwLUhzl8Vhye9ZLRrNQTQ6kU1zchKFesxznzR5tWR
         Ks7hPBn/uk5obEN+HhuFG9+btwGPER19BhQdfE49jjLI+KyKbKU2V3SN2XtEgkOcXgbW
         yLrtRvv1SdCpKTWTLuL+pdgAueYV5FXeEX4XIL0UzrgVqg4w93IFkKhqZUzHfAWj7Bku
         UwsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wcpl0XLRpCjaSCxXow32w/BWxBMtdYG2Hk4yghbRTdg=;
        b=tJOJVMNK0UZCnpBCrWlENip2bdejGMJ6R57BQfG97Mu/bD9Imgu+x5C9dkmG7j0RLe
         dWlVxOaTznuli8NfU/lmmPkOeZE7X5phHCgDk4e+6jzAJvQQGWaTX/tCcPGnhlJbn/V+
         H5+kRdJLJ90iIZWUtK8PHzF8+sNPXMkvYERkay/GLP4/7YliTfwhqA7t6hYHZF5F+gXx
         mToNZLd6bh7CD3IFblGXv43f1qqDPmmL9VwPx4tYtnhvgUqZ2Oh3fChxcv9Z6lOO3A3v
         71a4nwY2EHyS1TDEv7SKuDECmkpT+4mZ6hbHt3oyMQP4m1thwh++MZWX1N2nVzcRisxT
         6JKg==
X-Gm-Message-State: APjAAAWqRBzfXKV09Vov7Sa1wNXaBkOid3oqmTo7u9kkSM5qdQ+kcpPb
        arUm/AYWVsQFTtrPqJ8wY6vt4KNKXgw=
X-Google-Smtp-Source: APXvYqxKfJsRmA+pDy0PaTGjZ+belA8wTeRsQzQnxV1jGw80WKVBTLzopBD1Fv77Wqqy4p9ghZh+4g==
X-Received: by 2002:a17:90b:8c8:: with SMTP id ds8mr4963821pjb.89.1562739919242;
        Tue, 09 Jul 2019 23:25:19 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id j15sm1008263pfe.3.2019.07.09.23.25.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 23:25:18 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+097ef84cdc95843fbaa8@syzkaller.appspotmail.com,
        Arvid Brodin <arvid.brodin@alten.se>
Subject: [Patch net] hsr: switch ->dellink() to ->ndo_uninit()
Date:   Tue,  9 Jul 2019 23:24:54 -0700
Message-Id: <20190710062454.16386-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switching from ->priv_destructor to dellink() has an unexpected
consequence: existing RCU readers, that is, hsr_port_get_hsr()
callers, may still be able to read the port list.

Instead of checking the return value of each hsr_port_get_hsr(),
we can just move it to ->ndo_uninit() which is called after
device unregister and synchronize_net(), and we still have RTNL
lock there.

Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")
Fixes: edf070a0fb45 ("hsr: fix a NULL pointer deref in hsr_dev_xmit()")
Reported-by: syzbot+097ef84cdc95843fbaa8@syzkaller.appspotmail.com
Cc: Arvid Brodin <arvid.brodin@alten.se>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/hsr/hsr_device.c  | 18 ++++++++----------
 net/hsr/hsr_device.h  |  1 -
 net/hsr/hsr_netlink.c |  7 -------
 3 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index f0f9b493c47b..f509b495451a 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -227,13 +227,8 @@ static int hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct hsr_port *master;
 
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
-	if (master) {
-		skb->dev = master->dev;
-		hsr_forward_skb(skb, master);
-	} else {
-		atomic_long_inc(&dev->tx_dropped);
-		dev_kfree_skb_any(skb);
-	}
+	skb->dev = master->dev;
+	hsr_forward_skb(skb, master);
 	return NETDEV_TX_OK;
 }
 
@@ -348,7 +343,11 @@ static void hsr_announce(struct timer_list *t)
 	rcu_read_unlock();
 }
 
-void hsr_dev_destroy(struct net_device *hsr_dev)
+/* This has to be called after all the readers are gone.
+ * Otherwise we would have to check the return value of
+ * hsr_port_get_hsr().
+ */
+static void hsr_dev_destroy(struct net_device *hsr_dev)
 {
 	struct hsr_priv *hsr;
 	struct hsr_port *port;
@@ -364,8 +363,6 @@ void hsr_dev_destroy(struct net_device *hsr_dev)
 	del_timer_sync(&hsr->prune_timer);
 	del_timer_sync(&hsr->announce_timer);
 
-	synchronize_rcu();
-
 	hsr_del_self_node(&hsr->self_node_db);
 	hsr_del_nodes(&hsr->node_db);
 }
@@ -376,6 +373,7 @@ static const struct net_device_ops hsr_device_ops = {
 	.ndo_stop = hsr_dev_close,
 	.ndo_start_xmit = hsr_dev_xmit,
 	.ndo_fix_features = hsr_fix_features,
+	.ndo_uninit = hsr_dev_destroy,
 };
 
 static struct device_type hsr_type = {
diff --git a/net/hsr/hsr_device.h b/net/hsr/hsr_device.h
index d0fa6b0696d2..6d7759c4f5f9 100644
--- a/net/hsr/hsr_device.h
+++ b/net/hsr/hsr_device.h
@@ -14,7 +14,6 @@
 void hsr_dev_setup(struct net_device *dev);
 int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 		     unsigned char multicast_spec, u8 protocol_version);
-void hsr_dev_destroy(struct net_device *hsr_dev);
 void hsr_check_carrier_and_operstate(struct hsr_priv *hsr);
 bool is_hsr_master(struct net_device *dev);
 int hsr_get_max_mtu(struct hsr_priv *hsr);
diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index 160edd24de4e..8f8337f893ba 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -69,12 +69,6 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
 	return hsr_dev_finalize(dev, link, multicast_spec, hsr_version);
 }
 
-static void hsr_dellink(struct net_device *hsr_dev, struct list_head *head)
-{
-	hsr_dev_destroy(hsr_dev);
-	unregister_netdevice_queue(hsr_dev, head);
-}
-
 static int hsr_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
 	struct hsr_priv *hsr;
@@ -119,7 +113,6 @@ static struct rtnl_link_ops hsr_link_ops __read_mostly = {
 	.priv_size	= sizeof(struct hsr_priv),
 	.setup		= hsr_dev_setup,
 	.newlink	= hsr_newlink,
-	.dellink	= hsr_dellink,
 	.fill_info	= hsr_fill_info,
 };
 
-- 
2.21.0

