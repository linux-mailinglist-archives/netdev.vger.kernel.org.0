Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEE82A85C2
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731813AbgKESLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731740AbgKESLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:11:11 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00A1C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 10:11:10 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id w14so2839723wrs.9
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 10:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nuviainc-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s5LSMB+TyTM2xlf60SYdhlpCj4oc87epI00cKZYjqqE=;
        b=jaDSiJqlIHL667GQqE6Oy1mQhmwU4o9EUfD2YJgMX3F5ZIwlPyUzpzLp6W8v2twWxw
         snXfVB9xHu49az0t/ENMUcxzsnWBW50pUrElB8ASRhCSAv58z16Iik2CwkRyroOoJahV
         oun1NahWt93E/D0VxllaXKPfLp2FsZfREv4FSy8C5/I7E8eUx8rt1945V3z9cGqrUSLI
         Xco9xWy1orMB2diHeuqM+yjLFPHExTPzHj0zUNgynZkxKC2BPcwUDBYxpTUmmeMPac18
         Eh+9gnORg17El13oWP9dKsF5UnEC38iREtwHqXNQXSUB9n6OeHUL/S/YS0BGIeKLvd/U
         Ov8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s5LSMB+TyTM2xlf60SYdhlpCj4oc87epI00cKZYjqqE=;
        b=e3EuXB9W2no50T5v6CVNzku3ASo/cCgNpPO8qnOpqX79u6vwjt5gM1sqpFHn1Pq+vC
         Z7912Htjc9okt4RQtTm8YHStIWlrXAW94KHl6OsAQQBe/t92xknpUABlPP53GY2aYOrM
         on7HjhNlC2tPfp5eBUTqie+86Nf5IRy66TtVJGJ8/UYM8ukASSDnr3EzmrX9zKQrJWMm
         3s+YzQNGyytCO2kaz5/Rco6MC2YT6WMxgrW+Z0Hc4/lzEf3HRzDDy2g3gJccixB1ut6l
         MPVox8o3ocrjJ1t+C6Z7GvhvA+NEX3DMKCQnTHgptBP6OmEpQRtIbEc9N6qm/8vH7hjk
         tsgw==
X-Gm-Message-State: AOAM533wnxBwpH+kMkrpbewXewNWAuJyAQgJcmdjmfNmKlzq01Lp7HYA
        H6wtCA1iGehPOcOga6Jqf/D2Sc6C2x8i0esp
X-Google-Smtp-Source: ABdhPJwSNz9sudYKXTHcFsIytl9Qll0U0uPvtXkL8BfGbZDrWPwdnYSnmlIP0MAIPKeDSNfgGFKo8g==
X-Received: by 2002:adf:9204:: with SMTP id 4mr4585432wrj.241.1604599869684;
        Thu, 05 Nov 2020 10:11:09 -0800 (PST)
Received: from localhost ([82.44.17.50])
        by smtp.gmail.com with ESMTPSA id h4sm3615212wrq.3.2020.11.05.10.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 10:11:09 -0800 (PST)
Date:   Thu, 5 Nov 2020 18:11:08 +0000
From:   Jamie Iles <jamie@nuviainc.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jamie Iles <jamie@nuviainc.com>, netdev@vger.kernel.org,
        Qiushi Wu <wu000273@umn.edu>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [RESEND PATCH] bonding: wait for sysfs kobject destruction
 before freeing struct slave
Message-ID: <20201105181108.GA2360@poplar>
References: <20201105084108.3432509-1-jamie@nuviainc.com>
 <89416a2d-8a9b-f225-3c2a-16210df25e61@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89416a2d-8a9b-f225-3c2a-16210df25e61@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Thu, Nov 05, 2020 at 01:49:03PM +0100, Eric Dumazet wrote:
> On 11/5/20 9:41 AM, Jamie Iles wrote:
> > syzkaller found that with CONFIG_DEBUG_KOBJECT_RELEASE=y, releasing a
> > struct slave device could result in the following splat:
> > 
> >
> 
> > This is a potential use-after-free if the sysfs nodes are being accessed
> > whilst removing the struct slave, so wait for the object destruction to
> > complete before freeing the struct slave itself.
> > 
> > Fixes: 07699f9a7c8d ("bonding: add sysfs /slave dir for bond slave devices.")
> > Fixes: a068aab42258 ("bonding: Fix reference count leak in bond_sysfs_slave_add.")
> > Cc: Qiushi Wu <wu000273@umn.edu>
> > Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> > Cc: Veaceslav Falico <vfalico@gmail.com>
> > Cc: Andy Gospodarek <andy@greyhouse.net>
> > Signed-off-by: Jamie Iles <jamie@nuviainc.com>
> > ---
...
> This seems weird, are we going to wait for a completion while RTNL is held ?
> I am pretty sure this could be exploited by malicious user/syzbot.
> 
> The .release() handler could instead perform a refcounted
> bond_free_slave() action.

Okay, so were you thinking along the lines of this moving the lifetime 
of the slave to the kobject?

Thanks,

Jamie

diff --git i/drivers/net/bonding/bond_main.c w/drivers/net/bonding/bond_main.c
index 84ecbc6fa0ff..ea8ecc6e87c2 100644
--- i/drivers/net/bonding/bond_main.c
+++ w/drivers/net/bonding/bond_main.c
@@ -1481,7 +1481,7 @@ static struct slave *bond_alloc_slave(struct bonding *bond)
 	return slave;
 }
 
-static void bond_free_slave(struct slave *slave)
+void bond_free_slave(struct slave *slave)
 {
 	struct bonding *bond = bond_get_bond_by_slave(slave);
 
@@ -1691,6 +1691,10 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	 */
 	new_slave->queue_id = 0;
 
+	res = bond_slave_kobj_init(new_slave);
+	if (res)
+		goto err_free;
+
 	/* Save slave's original mtu and then set it to match the bond */
 	new_slave->original_mtu = slave_dev->mtu;
 	res = dev_set_mtu(slave_dev, bond->dev->mtu);
@@ -1912,7 +1916,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		if (bond_dev->flags & IFF_PROMISC) {
 			res = dev_set_promiscuity(slave_dev, 1);
 			if (res)
-				goto err_sysfs_del;
+				goto err_upper_unlink;
 		}
 
 		/* set allmulti level to new slave */
@@ -1921,7 +1925,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			if (res) {
 				if (bond_dev->flags & IFF_PROMISC)
 					dev_set_promiscuity(slave_dev, -1);
-				goto err_sysfs_del;
+				goto err_upper_unlink;
 			}
 		}
 
@@ -1961,9 +1965,6 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	return 0;
 
 /* Undo stages on error */
-err_sysfs_del:
-	bond_sysfs_slave_del(new_slave);
-
 err_upper_unlink:
 	bond_upper_dev_unlink(bond, new_slave);
 
@@ -2007,7 +2008,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	dev_set_mtu(slave_dev, new_slave->original_mtu);
 
 err_free:
-	bond_free_slave(new_slave);
+	bond_slave_kobj_put(new_slave);
 
 err_undo_flags:
 	/* Enslave of first slave has failed and we need to fix master's mac */
@@ -2066,8 +2067,6 @@ static int __bond_release_one(struct net_device *bond_dev,
 
 	bond_set_slave_inactive_flags(slave, BOND_SLAVE_NOTIFY_NOW);
 
-	bond_sysfs_slave_del(slave);
-
 	/* recompute stats just before removing the slave */
 	bond_get_stats(bond->dev, &bond->bond_stats);
 
@@ -2187,7 +2186,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 	if (!netif_is_bond_master(slave_dev))
 		slave_dev->priv_flags &= ~IFF_BONDING;
 
-	bond_free_slave(slave);
+	bond_slave_kobj_put(slave);
 
 	return 0;
 }
diff --git i/drivers/net/bonding/bond_sysfs_slave.c w/drivers/net/bonding/bond_sysfs_slave.c
index 9b8346638f69..67732078ef26 100644
--- i/drivers/net/bonding/bond_sysfs_slave.c
+++ w/drivers/net/bonding/bond_sysfs_slave.c
@@ -136,24 +136,35 @@ static const struct sysfs_ops slave_sysfs_ops = {
 	.show = slave_show,
 };
 
+static void slave_release(struct kobject *kobj)
+{
+	struct slave *slave = to_slave(kobj);
+
+	bond_free_slave(slave);
+}
+
 static struct kobj_type slave_ktype = {
+	.release = slave_release,
 #ifdef CONFIG_SYSFS
 	.sysfs_ops = &slave_sysfs_ops,
 #endif
 };
 
+int bond_slave_kobj_init(struct slave *slave)
+{
+	int err = kobject_init_and_add(&slave->kobj, &slave_ktype,
+				       &(slave->dev->dev.kobj), "bonding_slave");
+	if (err)
+		kobject_put(&slave->kobj);
+
+	return err;
+}
+
 int bond_sysfs_slave_add(struct slave *slave)
 {
 	const struct slave_attribute **a;
 	int err;
 
-	err = kobject_init_and_add(&slave->kobj, &slave_ktype,
-				   &(slave->dev->dev.kobj), "bonding_slave");
-	if (err) {
-		kobject_put(&slave->kobj);
-		return err;
-	}
-
 	for (a = slave_attrs; *a; ++a) {
 		err = sysfs_create_file(&slave->kobj, &((*a)->attr));
 		if (err) {
@@ -165,7 +176,7 @@ int bond_sysfs_slave_add(struct slave *slave)
 	return 0;
 }
 
-void bond_sysfs_slave_del(struct slave *slave)
+void bond_slave_kobj_put(struct slave *slave)
 {
 	const struct slave_attribute **a;
 
diff --git i/include/net/bonding.h w/include/net/bonding.h
index 7d132cc1e584..ccb07e3e495e 100644
--- i/include/net/bonding.h
+++ w/include/net/bonding.h
@@ -622,10 +622,12 @@ int bond_create(struct net *net, const char *name);
 int bond_create_sysfs(struct bond_net *net);
 void bond_destroy_sysfs(struct bond_net *net);
 void bond_prepare_sysfs_group(struct bonding *bond);
+int bond_slave_kobj_init(struct slave *slave);
 int bond_sysfs_slave_add(struct slave *slave);
-void bond_sysfs_slave_del(struct slave *slave);
+void bond_slave_kobj_put(struct slave *slave);
 int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		 struct netlink_ext_ack *extack);
+void bond_free_slave(struct slave *slave);
 int bond_release(struct net_device *bond_dev, struct net_device *slave_dev);
 u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb);
 int bond_set_carrier(struct bonding *bond);
