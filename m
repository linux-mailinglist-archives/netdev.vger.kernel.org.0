Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DA022BA33
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgGWXXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbgGWXXM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 19:23:12 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E88D820792;
        Thu, 23 Jul 2020 23:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595546591;
        bh=KifX/qbNzlhzDqyVmEqg7mmK8CsV9G7WuJum1sEE3a0=;
        h=From:To:Cc:Subject:Date:From;
        b=LEL6lB7wM6nzJGMr4L49z48fVMJYMY19/0lo5ZPHMoCIf81otQ6+U1TUm10rEANX8
         ZG1aCHowI8zKPvurFlBFclCVGE9WbLH51bcdShoBydEgG7ORK+9WI2hLxNizpot7LY
         kaxoZITv6WMxeWgA8TIHRCVd0KA6ZHawz7X6fLlw=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     David Ahern <dsahern@kernel.org>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH net] vrf: Handle CONFIG_SYSCTL not set
Date:   Thu, 23 Jul 2020 17:23:09 -0600
Message-Id: <20200723232309.48952-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Randy reported compile failure when CONFIG_SYSCTL is not set/enabled:

ERROR: modpost: "sysctl_vals" [drivers/net/vrf.ko] undefined!

Fix by splitting out the sysctl init and cleanup into helpers that
can be set to do nothing when CONFIG_SYSCTL is disabled. In addition,
move vrf_strict_mode and vrf_strict_mode_change to above
vrf_shared_table_handler (code move only) and wrap all of it
in the ifdef CONFIG_SYSCTL.

Update the strict mode tests to check for the existence of the
/proc/sys entry.

Fixes: 33306f1aaf82 ("vrf: add sysctl parameter for strict mode")
Cc: Andrea Mayer <andrea.mayer@uniroma2.it>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: David Ahern <dsahern@kernel.org>
---
 drivers/net/vrf.c                             | 138 ++++++++++--------
 .../selftests/net/vrf_strict_mode_test.sh     |   6 +
 2 files changed, 83 insertions(+), 61 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 46599606ff10..60c1aadece89 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -260,52 +260,6 @@ static void vrf_map_unlock(struct vrf_map *vmap) __releases(&vmap->vmap_lock)
 	spin_unlock(&vmap->vmap_lock);
 }
 
-static bool vrf_strict_mode(struct vrf_map *vmap)
-{
-	bool strict_mode;
-
-	vrf_map_lock(vmap);
-	strict_mode = vmap->strict_mode;
-	vrf_map_unlock(vmap);
-
-	return strict_mode;
-}
-
-static int vrf_strict_mode_change(struct vrf_map *vmap, bool new_mode)
-{
-	bool *cur_mode;
-	int res = 0;
-
-	vrf_map_lock(vmap);
-
-	cur_mode = &vmap->strict_mode;
-	if (*cur_mode == new_mode)
-		goto unlock;
-
-	if (*cur_mode) {
-		/* disable strict mode */
-		*cur_mode = false;
-	} else {
-		if (vmap->shared_tables) {
-			/* we cannot allow strict_mode because there are some
-			 * vrfs that share one or more tables.
-			 */
-			res = -EBUSY;
-			goto unlock;
-		}
-
-		/* no tables are shared among vrfs, so we can go back
-		 * to 1:1 association between a vrf with its table.
-		 */
-		*cur_mode = true;
-	}
-
-unlock:
-	vrf_map_unlock(vmap);
-
-	return res;
-}
-
 /* called with rtnl lock held */
 static int
 vrf_map_register_dev(struct net_device *dev, struct netlink_ext_ack *extack)
@@ -1790,6 +1744,53 @@ static int vrf_map_init(struct vrf_map *vmap)
 	return 0;
 }
 
+#ifdef CONFIG_SYSCTL
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
 static int vrf_shared_table_handler(struct ctl_table *table, int write,
 				    void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -1830,15 +1831,9 @@ static const struct ctl_table vrf_table[] = {
 	{ },
 };
 
-/* Initialize per network namespace state */
-static int __net_init vrf_netns_init(struct net *net)
+static int vrf_netns_init_sysctl(struct net *net, struct netns_vrf *nn_vrf)
 {
-	struct netns_vrf *nn_vrf = net_generic(net, vrf_net_id);
 	struct ctl_table *table;
-	int res;
-
-	nn_vrf->add_fib_rules = true;
-	vrf_map_init(&nn_vrf->vmap);
 
 	table = kmemdup(vrf_table, sizeof(vrf_table), GFP_KERNEL);
 	if (!table)
@@ -1849,19 +1844,14 @@ static int __net_init vrf_netns_init(struct net *net)
 
 	nn_vrf->ctl_hdr = register_net_sysctl(net, "net/vrf", table);
 	if (!nn_vrf->ctl_hdr) {
-		res = -ENOMEM;
-		goto free_table;
+		kfree(table);
+		return -ENOMEM;
 	}
 
 	return 0;
-
-free_table:
-	kfree(table);
-
-	return res;
 }
 
-static void __net_exit vrf_netns_exit(struct net *net)
+static void vrf_netns_exit_sysctl(struct net *net)
 {
 	struct netns_vrf *nn_vrf = net_generic(net, vrf_net_id);
 	struct ctl_table *table;
@@ -1870,6 +1860,32 @@ static void __net_exit vrf_netns_exit(struct net *net)
 	unregister_net_sysctl_table(nn_vrf->ctl_hdr);
 	kfree(table);
 }
+#else
+static int vrf_netns_init_sysctl(struct net *net, struct netns_vrf *nn_vrf)
+{
+	return 0;
+}
+
+static void vrf_netns_exit_sysctl(struct net *net)
+{
+}
+#endif
+
+/* Initialize per network namespace state */
+static int __net_init vrf_netns_init(struct net *net)
+{
+	struct netns_vrf *nn_vrf = net_generic(net, vrf_net_id);
+
+	nn_vrf->add_fib_rules = true;
+	vrf_map_init(&nn_vrf->vmap);
+
+	return vrf_netns_init_sysctl(net, nn_vrf);
+}
+
+static void __net_exit vrf_netns_exit(struct net *net)
+{
+	vrf_netns_exit_sysctl(net);
+}
 
 static struct pernet_operations vrf_net_ops __net_initdata = {
 	.init = vrf_netns_init,
diff --git a/tools/testing/selftests/net/vrf_strict_mode_test.sh b/tools/testing/selftests/net/vrf_strict_mode_test.sh
index 5274f4a1fba1..18b982d611de 100755
--- a/tools/testing/selftests/net/vrf_strict_mode_test.sh
+++ b/tools/testing/selftests/net/vrf_strict_mode_test.sh
@@ -379,6 +379,12 @@ if [ ! -x "$(command -v ip)" ]; then
 	exit 0
 fi
 
+modprobe vrf &>/dev/null
+if [ ! -e /proc/sys/net/vrf/strict_mode ]; then
+	echo "SKIP: vrf sysctl does not exist"
+	exit 0
+fi
+
 cleanup &> /dev/null
 
 setup
-- 
2.17.1

