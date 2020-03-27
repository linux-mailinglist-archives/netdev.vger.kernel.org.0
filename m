Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 007ED194DC7
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 01:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgC0ALz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 20:11:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:42446 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727600AbgC0ALy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 20:11:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1E5EAB1DF;
        Fri, 27 Mar 2020 00:11:53 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id C5857E00A5; Fri, 27 Mar 2020 01:11:52 +0100 (CET)
Message-Id: <d76ac0a1a45b8a91471a92f2db99e78e5a42ae32.1585267388.git.mkubecek@suse.cz>
In-Reply-To: <cover.1585267388.git.mkubecek@suse.cz>
References: <cover.1585267388.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 01/12] ethtool: fix reference leak in
 ethnl_set_privflags()
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Fri, 27 Mar 2020 01:11:52 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew noticed that some handlers for *_SET commands leak a netdev
reference if required ethtool_ops callbacks do not exist. One of them is
ethnl_set_privflags(), a simple reproducer would be e.g.

  ip link add veth1 type veth peer name veth2
  ethtool --set-priv-flags veth1 foo on
  ip link del veth1

Make sure dev_put() is called when ethtool_ops check fails.

Fixes: f265d799596a ("ethtool: set device private flags with PRIVFLAGS_SET request")
Reported-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/ethtool/privflags.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/privflags.c b/net/ethtool/privflags.c
index e8f03b33db9b..77447dceb109 100644
--- a/net/ethtool/privflags.c
+++ b/net/ethtool/privflags.c
@@ -175,9 +175,10 @@ int ethnl_set_privflags(struct sk_buff *skb, struct genl_info *info)
 		return ret;
 	dev = req_info.dev;
 	ops = dev->ethtool_ops;
+	ret = -EOPNOTSUPP;
 	if (!ops->get_priv_flags || !ops->set_priv_flags ||
 	    !ops->get_sset_count || !ops->get_strings)
-		return -EOPNOTSUPP;
+		goto out_dev;
 
 	rtnl_lock();
 	ret = ethnl_ops_begin(dev);
@@ -204,6 +205,7 @@ int ethnl_set_privflags(struct sk_buff *skb, struct genl_info *info)
 	ethnl_ops_complete(dev);
 out_rtnl:
 	rtnl_unlock();
+out_dev:
 	dev_put(dev);
 	return ret;
 }
-- 
2.25.1

