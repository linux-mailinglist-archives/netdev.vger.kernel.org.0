Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5572033FDDF
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 04:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhCRDnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 23:43:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:37116 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhCRDmz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 23:42:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DEBD1ACC6;
        Thu, 18 Mar 2021 03:42:53 +0000 (UTC)
Date:   Thu, 18 Mar 2021 04:42:53 +0100
From:   Jiri Bohac <jbohac@suse.cz>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH] net: check all name nodes in  __dev_alloc_name
Message-ID: <20210318034253.w4w2p3kvi4m6vqp5@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__dev_alloc_name(), when supplied with a name containing '%d',
will search for the first available device number to generate a
unique device name.

Since commit ff92741270bf8b6e78aa885f166b68c7a67ab13a ("net:
introduce name_node struct to be used in hashlist") network
devices may have alternate names.  __dev_alloc_name() does take
these alternate names into account, possibly generating a name
that is already taken and failing with -ENFILE as a result.

This demonstrates the bug:

    # rmmod dummy 2>/dev/null
    # ip link property add dev lo altname dummy0
    # modprobe dummy numdummies=1
    modprobe: ERROR: could not insert 'dummy': Too many open files in system

Instead of creating a device named dummy1, modprobe fails.

Fix this by checking all the names in the d->name_node list, not just d->name.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Fixes: ff92741270bf ("net: introduce name_node struct to be used in hashlist")

diff --git a/net/core/dev.c b/net/core/dev.c
index 6c5967e80132..7cbcd8d37e91 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1184,6 +1184,18 @@ static int __dev_alloc_name(struct net *net, const char *name, char *buf)
 			return -ENOMEM;
 
 		for_each_netdev(net, d) {
+			struct netdev_name_node *name_node;
+			list_for_each_entry(name_node, &d->name_node->list, list) {
+				if (!sscanf(name_node->name, name, &i))
+					continue;
+				if (i < 0 || i >= max_netdevices)
+					continue;
+
+				/*  avoid cases where sscanf is not exact inverse of printf */
+				snprintf(buf, IFNAMSIZ, name, i);
+				if (!strncmp(buf, name_node->name, IFNAMSIZ))
+					set_bit(i, inuse);
+			}
 			if (!sscanf(d->name, name, &i))
 				continue;
 			if (i < 0 || i >= max_netdevices)

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, Prague, Czechia

