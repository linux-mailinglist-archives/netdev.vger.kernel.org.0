Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B241F7BF2
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 19:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgFLRDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 13:03:01 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:43544 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgFLRDA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 13:03:00 -0400
X-Greylist: delayed 670 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jun 2020 13:02:58 EDT
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 05CGpXZt019363
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 12 Jun 2020 18:51:34 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Donald Sharp <sharpd@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Dinesh Dutt <didutt@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [RFC,net-next, 4/5] vrf: add l3mdev registration for table to VRF device lookup
Date:   Fri, 12 Jun 2020 18:49:36 +0200
Message-Id: <20200612164937.5468-5-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200612164937.5468-1-andrea.mayer@uniroma2.it>
References: <20200612164937.5468-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the initialization phase of the VRF module, the callback for table
to VRF device lookup is registered in l3mdev.

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 drivers/net/vrf.c | 59 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index bac118b615bc..65d5f5ff4c67 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -182,6 +182,19 @@ static struct vrf_map *netns_vrf_map_by_dev(struct net_device *dev)
 	return netns_vrf_map(dev_net(dev));
 }
 
+static int vrf_map_elem_get_vrf_ifindex(struct vrf_map_elem *me)
+{
+	struct list_head *me_head = &me->vrf_list;
+	struct net_vrf *vrf;
+
+	if (list_empty(me_head))
+		return -ENODEV;
+
+	vrf = list_first_entry(me_head, struct net_vrf, me_list);
+
+	return vrf->ifindex;
+}
+
 static struct vrf_map_elem *vrf_map_elem_alloc(gfp_t flags)
 {
 	struct vrf_map_elem *me;
@@ -383,6 +396,34 @@ static void vrf_map_unregister_dev(struct net_device *dev)
 	vrf_map_unlock(vmap);
 }
 
+/* returns the vrf device index associated with the table_id */
+static int vrf_ifindex_lookup_by_table_id(struct net *net, u32 table_id)
+{
+	struct vrf_map *vmap = netns_vrf_map(net);
+	struct vrf_map_elem *me;
+	int ifindex;
+
+	vrf_map_lock(vmap);
+
+	if (!vmap->strict_mode) {
+		ifindex = -EPERM;
+		goto unlock;
+	}
+
+	me = vrf_map_lookup_elem(vmap, table_id);
+	if (!me) {
+		ifindex = -ENODEV;
+		goto unlock;
+	}
+
+	ifindex = vrf_map_elem_get_vrf_ifindex(me);
+
+unlock:
+	vrf_map_unlock(vmap);
+
+	return ifindex;
+}
+
 /* by default VRF devices do not have a qdisc and are expected
  * to be created with only a single queue.
  */
@@ -1847,14 +1888,24 @@ static int __init vrf_init_module(void)
 	if (rc < 0)
 		goto error;
 
+	rc = l3mdev_table_lookup_register(L3MDEV_TYPE_VRF,
+					  vrf_ifindex_lookup_by_table_id);
+	if (rc < 0)
+		goto unreg_pernet;
+
 	rc = rtnl_link_register(&vrf_link_ops);
-	if (rc < 0) {
-		unregister_pernet_subsys(&vrf_net_ops);
-		goto error;
-	}
+	if (rc < 0)
+		goto table_lookup_unreg;
 
 	return 0;
 
+table_lookup_unreg:
+	l3mdev_table_lookup_unregister(L3MDEV_TYPE_VRF,
+				       vrf_ifindex_lookup_by_table_id);
+
+unreg_pernet:
+	unregister_pernet_subsys(&vrf_net_ops);
+
 error:
 	unregister_netdevice_notifier(&vrf_notifier_block);
 	return rc;
-- 
2.20.1

