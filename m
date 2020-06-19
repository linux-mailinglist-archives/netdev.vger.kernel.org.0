Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32108201E4E
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 00:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbgFSW4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 18:56:53 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:33338 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729898AbgFSW4r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 18:56:47 -0400
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 05JMuRJD014086
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 20 Jun 2020 00:56:28 +0200
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
        Stephen Hemminger <stephen@networkplumber.org>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next,v1,3/5] vrf: add sysctl parameter for strict mode
Date:   Sat, 20 Jun 2020 00:54:45 +0200
Message-Id: <20200619225447.1445-4-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200619225447.1445-1-andrea.mayer@uniroma2.it>
References: <20200619225447.1445-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add net.vrf.strict_mode sysctl parameter.

When net.vrf.strict_mode=0 (default) it is possible to associate multiple
VRF devices to the same table. Conversely, when net.vrf.strict_mode=1 a
table can be associated to a single VRF device.

When switching from net.vrf.strict_mode=0 to net.vrf.strict_mode=1, a check
is performed to verify that all tables have at most one VRF associated,
otherwise the switch is not allowed.

The net.vrf.strict_mode parameter is per network namespace.

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 drivers/net/vrf.c | 118 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 098fdabaa4c5..c53e57354d2c 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -103,6 +103,7 @@ struct netns_vrf {
 	bool add_fib_rules;
 
 	struct vrf_map vmap;
+	struct ctl_table_header	*ctl_hdr;
 };
 
 struct net_vrf {
@@ -246,6 +247,52 @@ static void vrf_map_unlock(struct vrf_map *vmap) __releases(&vmap->vmap_lock)
 	spin_unlock(&vmap->vmap_lock);
 }
 
+static bool vrf_strict_mode(struct vrf_map *vmap)
+{
+	bool strict_mode;
+
+	vrf_map_lock(vmap);
+	strict_mode = vmap->strict_mode;
+	vrf_map_unlock(vmap);
+
+	return strict_mode;
+}
+
+static int vrf_strict_mode_change(struct vrf_map *vmap, bool new_mode)
+{
+	bool *cur_mode;
+	int res = 0;
+
+	vrf_map_lock(vmap);
+
+	cur_mode = &vmap->strict_mode;
+	if (*cur_mode == new_mode)
+		goto unlock;
+
+	if (*cur_mode) {
+		/* disable strict mode */
+		*cur_mode = false;
+	} else {
+		if (vmap->shared_tables) {
+			/* we cannot allow strict_mode because there are some
+			 * vrfs that share one or more tables.
+			 */
+			res = -EBUSY;
+			goto unlock;
+		}
+
+		/* no tables are shared among vrfs, so we can go back
+		 * to 1:1 association between a vrf with its table.
+		 */
+		*cur_mode = true;
+	}
+
+unlock:
+	vrf_map_unlock(vmap);
+
+	return res;
+}
+
 /* called with rtnl lock held */
 static int
 vrf_map_register_dev(struct net_device *dev, struct netlink_ext_ack *extack)
@@ -1702,19 +1749,90 @@ static int vrf_map_init(struct vrf_map *vmap)
 	return 0;
 }
 
+static int vrf_shared_table_handler(struct ctl_table *table, int write,
+				    void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct net *net = (struct net *)table->extra1;
+	struct vrf_map *vmap = netns_vrf_map(net);
+	int proc_strict_mode = 0;
+	struct ctl_table tmp = {
+		.procname	= table->procname,
+		.data		= &proc_strict_mode,
+		.maxlen		= sizeof(int),
+		.mode		= table->mode,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	};
+	int ret;
+
+	if (!write)
+		proc_strict_mode = vrf_strict_mode(vmap);
+
+	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+
+	if (write && ret == 0)
+		ret = vrf_strict_mode_change(vmap, (bool)proc_strict_mode);
+
+	return ret;
+}
+
+static const struct ctl_table vrf_table[] = {
+	{
+		.procname	= "strict_mode",
+		.data		= NULL,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= vrf_shared_table_handler,
+		/* set by the vrf_netns_init */
+		.extra1		= NULL,
+	},
+	{ },
+};
+
 /* Initialize per network namespace state */
 static int __net_init vrf_netns_init(struct net *net)
 {
 	struct netns_vrf *nn_vrf = net_generic(net, vrf_net_id);
+	struct ctl_table *table;
+	int res;
 
 	nn_vrf->add_fib_rules = true;
 	vrf_map_init(&nn_vrf->vmap);
 
+	table = kmemdup(vrf_table, sizeof(vrf_table), GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+
+	/* init the extra1 parameter with the reference to current netns */
+	table[0].extra1 = net;
+
+	nn_vrf->ctl_hdr = register_net_sysctl(net, "net/vrf", table);
+	if (!nn_vrf->ctl_hdr) {
+		res = -ENOMEM;
+		goto free_table;
+	}
+
 	return 0;
+
+free_table:
+	kfree(table);
+
+	return res;
+}
+
+static void __net_exit vrf_netns_exit(struct net *net)
+{
+	struct netns_vrf *nn_vrf = net_generic(net, vrf_net_id);
+	struct ctl_table *table;
+
+	table = nn_vrf->ctl_hdr->ctl_table_arg;
+	unregister_net_sysctl_table(nn_vrf->ctl_hdr);
+	kfree(table);
 }
 
 static struct pernet_operations vrf_net_ops __net_initdata = {
 	.init = vrf_netns_init,
+	.exit = vrf_netns_exit,
 	.id   = &vrf_net_id,
 	.size = sizeof(struct netns_vrf),
 };
-- 
2.20.1

