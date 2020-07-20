Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C932322583B
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 09:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgGTHML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 03:12:11 -0400
Received: from linux.microsoft.com ([13.77.154.182]:40956 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgGTHML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 03:12:11 -0400
Received: by linux.microsoft.com (Postfix, from userid 1070)
        id 2541920B4909; Mon, 20 Jul 2020 00:12:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2541920B4909
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1595229130;
        bh=fCB4mM57CeHhDg63/nP/QH+XUmyf9zBGFqIcnNAb8e8=;
        h=Date:From:To:cc:Subject:From;
        b=YFjXE+OoPS3f0w9chLPvaPXRK0njBem2/vKcqOoRlZghvz0nw9zBO7dz+wAn8vyYZ
         82UqaFqGGF059pVUCXgJJvvtYmE+O73rptxLDwJ0DyFUJMr/96r+CHjA6SXFFH7xtF
         rCZZDoyrsLHXFFO0Kz9XRZctXguaCus1bM2TkkMA=
Received: from localhost (localhost [127.0.0.1])
        by linux.microsoft.com (Postfix) with ESMTP id 2348F307056B;
        Mon, 20 Jul 2020 00:12:10 -0700 (PDT)
Date:   Mon, 20 Jul 2020 00:12:10 -0700 (PDT)
From:   Chi Song <chisong@linux.microsoft.com>
X-X-Sender: chisong@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next] net: hyperv: Add attributes to show TX indirection
 table
Message-ID: <alpine.LRH.2.23.451.2007192357400.30908@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An imbalanced TX indirection table causes netvsc to have low
performance. This table is created and managed during runtime. To help
better diagnose performance issues caused by imbalanced tables, add
device attributes to show the content of TX indirection tables.

Signed-off-by: Chi Song <chisong@microsoft.com>
---
v2: remove RX as it's in ethtool already, show single value in each file,
 and update description.

Thank you for comments. Let me know, if I miss something.

---
 drivers/net/hyperv/netvsc_drv.c | 53 +++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c
b/drivers/net/hyperv/netvsc_drv.c
index 6267f706e8ee..222c2fad9300 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2370,6 +2370,55 @@ static int netvsc_unregister_vf(struct net_device
*vf_netdev)
 	return NOTIFY_OK;
 }

+static struct device_attribute
dev_attr_netvsc_dev_attrs[VRSS_SEND_TAB_SIZE];
+static struct attribute *netvsc_dev_attrs[VRSS_SEND_TAB_SIZE + 1];
+
+const struct attribute_group netvsc_dev_group = {
+	.name = NULL,
+	.attrs = netvsc_dev_attrs,
+};
+
+static ssize_t tx_indirection_table_show(struct device *dev,
+					 struct device_attribute
*dev_attr,
+					 char *buf)
+{
+	struct net_device *ndev = to_net_dev(dev);
+	struct net_device_context *ndc = netdev_priv(ndev);
+	ssize_t offset = 0;
+	int index = dev_attr - dev_attr_netvsc_dev_attrs;
+
+	offset = sprintf(buf, "%u\n", ndc->tx_table[index]);
+
+	return offset;
+}
+
+static void netvsc_attrs_init(void)
+{
+	int i;
+	char buffer[32];
+
+	for (i = 0; i < VRSS_SEND_TAB_SIZE; i++) {
+		sprintf(buffer, "tx_indirection_table_%02u", i);
+		dev_attr_netvsc_dev_attrs[i].attr.name =
+			kstrdup(buffer, GFP_KERNEL);
+		dev_attr_netvsc_dev_attrs[i].attr.mode = 0444;
+		sysfs_attr_init(&dev_attr_netvsc_dev_attrs[i].attr);
+
+		dev_attr_netvsc_dev_attrs[i].show =
tx_indirection_table_show;
+		dev_attr_netvsc_dev_attrs[i].store = NULL;
+		netvsc_dev_attrs[i] = &dev_attr_netvsc_dev_attrs[i].attr;
+	}
+	netvsc_dev_attrs[VRSS_SEND_TAB_SIZE] = NULL;
+}
+
+static void netvsc_attrs_exit(void)
+{
+	int i;
+
+	for (i = 0; i < VRSS_SEND_TAB_SIZE; i++)
+		kfree(dev_attr_netvsc_dev_attrs[i].attr.name);
+}
+
 static int netvsc_probe(struct hv_device *dev,
 			const struct hv_vmbus_device_id *dev_id)
 {
@@ -2396,6 +2445,7 @@ static int netvsc_probe(struct hv_device *dev,
 			   net_device_ctx->msg_enable);

 	hv_set_drvdata(dev, net);
+	netvsc_attrs_init();

 	INIT_DELAYED_WORK(&net_device_ctx->dwork, netvsc_link_change);

@@ -2410,6 +2460,7 @@ static int netvsc_probe(struct hv_device *dev,

 	net->netdev_ops = &device_ops;
 	net->ethtool_ops = &ethtool_ops;
+	net->sysfs_groups[0] = &netvsc_dev_group;
 	SET_NETDEV_DEV(net, &dev->device);

 	/* We always need headroom for rndis header */
@@ -2533,6 +2584,7 @@ static int netvsc_remove(struct hv_device *dev)

 	rtnl_unlock();

+	netvsc_attrs_exit();
 	hv_set_drvdata(dev, NULL);

 	free_percpu(ndev_ctx->vf_stats);
@@ -2683,6 +2735,7 @@ static int __init netvsc_drv_init(void)
 		return ret;

 	register_netdevice_notifier(&netvsc_netdev_notifier);
+
 	return 0;
 }

-- 
2.25.1


