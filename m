Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE62433C9C
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 18:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhJSQoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 12:44:55 -0400
Received: from mga07.intel.com ([134.134.136.100]:41260 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229991AbhJSQox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 12:44:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="292034121"
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="292034121"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 09:42:40 -0700
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="567039888"
Received: from jbrandeb-saw1.jf.intel.com ([10.166.28.56])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 09:42:40 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next] net-core: use netdev_* calls for kernel messages
Date:   Tue, 19 Oct 2021 09:42:28 -0700
Message-Id: <20211019164228.338538-1-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While loading a driver and changing the number of queues, I noticed this
message in the kernel log:

"[253489.070080] Number of in use tx queues changed invalidating tc
mappings. Priority traffic classification disabled!"

But I had no idea what interface was being talked about because this
message used pr_warn().

After investigating, it appears we can use the netdev_* helpers already
defined to create predictably formatted messages, and that already handle
<unknown netdev> cases, in more of the messages in dev.c.

After this change, this message (and others) will look like this:
"[  170.181093] ice 0000:3b:00.0 ens785f0: Number of in use tx queues
changed invalidating tc mappings. Priority traffic classification
disabled!"

One goal here was not to change the message significantly from the
original format so as to not break user's expectations, so I just
changed messages that used pr_* and generally started with %s ==
dev->name.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 net/core/dev.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 26cdf971ca95..4e3d19a06de4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1296,8 +1296,8 @@ int dev_change_name(struct net_device *dev, const char *newname)
 			old_assign_type = NET_NAME_RENAMED;
 			goto rollback;
 		} else {
-			pr_err("%s: name change rollback failed: %d\n",
-			       dev->name, ret);
+			netdev_err(dev, "name change rollback failed: %d\n",
+				   ret);
 		}
 	}
 
@@ -2351,7 +2351,7 @@ static void netif_setup_tc(struct net_device *dev, unsigned int txq)
 
 	/* If TC0 is invalidated disable TC mapping */
 	if (tc->offset + tc->count > txq) {
-		pr_warn("Number of in use tx queues changed invalidating tc mappings. Priority traffic classification disabled!\n");
+		netdev_warn(dev, "Number of in use tx queues changed invalidating tc mappings. Priority traffic classification disabled!\n");
 		dev->num_tc = 0;
 		return;
 	}
@@ -2362,8 +2362,8 @@ static void netif_setup_tc(struct net_device *dev, unsigned int txq)
 
 		tc = &dev->tc_to_txq[q];
 		if (tc->offset + tc->count > txq) {
-			pr_warn("Number of in use tx queues changed. Priority %i to tc mapping %i is no longer valid. Setting map to 0\n",
-				i, q);
+			netdev_warn(dev, "Number of in use tx queues changed. Priority %i to tc mapping %i is no longer valid. Setting map to 0\n",
+				    i, q);
 			netdev_set_prio_tc_map(dev, i, 0);
 		}
 	}
@@ -3416,7 +3416,7 @@ EXPORT_SYMBOL(__skb_gso_segment);
 #ifdef CONFIG_BUG
 static void do_netdev_rx_csum_fault(struct net_device *dev, struct sk_buff *skb)
 {
-	pr_err("%s: hw csum failure\n", dev ? dev->name : "<unknown>");
+	netdev_err(dev, "hw csum failure\n");
 	skb_dump(KERN_ERR, skb, true);
 	dump_stack();
 }
@@ -7012,8 +7012,8 @@ static int __napi_poll(struct napi_struct *n, bool *repoll)
 	}
 
 	if (unlikely(work > weight))
-		pr_err_once("NAPI poll function %pS returned %d, exceeding its budget of %d.\n",
-			    n->poll, work, weight);
+		netdev_err_once(n->dev, "NAPI poll function %pS returned %d, exceeding its budget of %d.\n",
+				n->poll, work, weight);
 
 	if (likely(work < weight))
 		return work;
@@ -8567,8 +8567,7 @@ static int __dev_set_promiscuity(struct net_device *dev, int inc, bool notify)
 			dev->flags &= ~IFF_PROMISC;
 		else {
 			dev->promiscuity -= inc;
-			pr_warn("%s: promiscuity touches roof, set promiscuity failed. promiscuity feature of device might be broken.\n",
-				dev->name);
+			netdev_warn(dev, "promiscuity touches roof, set promiscuity failed. promiscuity feature of device might be broken.\n");
 			return -EOVERFLOW;
 		}
 	}
@@ -8638,8 +8637,7 @@ static int __dev_set_allmulti(struct net_device *dev, int inc, bool notify)
 			dev->flags &= ~IFF_ALLMULTI;
 		else {
 			dev->allmulti -= inc;
-			pr_warn("%s: allmulti touches roof, set allmulti failed. allmulti feature of device might be broken.\n",
-				dev->name);
+			netdev_warn(dev, "allmulti touches roof, set allmulti failed. allmulti feature of device might be broken.\n");
 			return -EOVERFLOW;
 		}
 	}
-- 
2.31.1

