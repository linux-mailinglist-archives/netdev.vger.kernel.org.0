Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39CB4F83CA
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 17:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344992AbiDGPqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 11:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiDGPqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 11:46:03 -0400
X-Greylist: delayed 1888 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Apr 2022 08:43:58 PDT
Received: from scorn.kernelslacker.org (scorn.kernelslacker.org [IPv6:2600:3c03:e000:2fb::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57068B6E5A
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 08:43:57 -0700 (PDT)
Received: from [2601:196:4600:6634:ae9e:17ff:feb7:72ca] (helo=wopr.kernelslacker.org)
        by scorn.kernelslacker.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <davej@codemonkey.org.uk>)
        id 1ncTo1-007UlS-SV; Thu, 07 Apr 2022 11:12:17 -0400
Received: by wopr.kernelslacker.org (Postfix, from userid 1026)
        id 30428560206; Thu,  7 Apr 2022 11:12:17 -0400 (EDT)
Date:   Thu, 7 Apr 2022 11:12:17 -0400
From:   Dave Jones <davej@codemonkey.org.uk>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        bridge@lists.linux-foundation.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] decouple llc/bridge
Message-ID: <20220407151217.GA8736@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Note: SpamAssassin invocation failed
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was wondering why the llc code was getting compiled and it turned out
to be because I had bridging enabled. It turns out to only needs it for
a single function (llc_mac_hdr_init).

Converting this to a static inline like the other llc functions it uses
allows to decouple the dependency

Signed-off-by: Dave Jones <davej@codemonkey.org.uk>

diff --git include/net/llc.h include/net/llc.h
index e250dca03963..edcb120ee6b0 100644
--- include/net/llc.h
+++ include/net/llc.h
@@ -13,6 +13,7 @@
  */
 
 #include <linux/if.h>
+#include <linux/if_arp.h>
 #include <linux/if_ether.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
@@ -100,8 +101,34 @@ extern struct list_head llc_sap_list;
 int llc_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt,
 	    struct net_device *orig_dev);
 
-int llc_mac_hdr_init(struct sk_buff *skb, const unsigned char *sa,
-		     const unsigned char *da);
+/**
+ *      llc_mac_hdr_init - fills MAC header fields
+ *      @skb: Address of the frame to initialize its MAC header
+ *      @sa: The MAC source address
+ *      @da: The MAC destination address
+ *
+ *      Fills MAC header fields, depending on MAC type. Returns 0, If MAC type
+ *      is a valid type and initialization completes correctly 1, otherwise.
+ */
+static inline int llc_mac_hdr_init(struct sk_buff *skb,
+				   const unsigned char *sa, const unsigned char *da)
+{
+	int rc = -EINVAL;
+
+	switch (skb->dev->type) {
+	case ARPHRD_ETHER:
+	case ARPHRD_LOOPBACK:
+		rc = dev_hard_header(skb, skb->dev, ETH_P_802_2, da, sa,
+				     skb->len);
+		if (rc > 0)
+			rc = 0;
+		break;
+	default:
+		break;
+	}
+	return rc;
+}
+
 
 void llc_add_pack(int type,
 		  void (*handler)(struct llc_sap *sap, struct sk_buff *skb));
diff --git net/802/Kconfig net/802/Kconfig
index aaa83e888240..8bea5d1d5118 100644
--- net/802/Kconfig
+++ net/802/Kconfig
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config STP
 	tristate
-	select LLC
 
 config GARP
 	tristate
diff --git net/bridge/Kconfig net/bridge/Kconfig
index 3c8ded7d3e84..c011856d3386 100644
--- net/bridge/Kconfig
+++ net/bridge/Kconfig
@@ -5,7 +5,6 @@
 
 config BRIDGE
 	tristate "802.1d Ethernet Bridging"
-	select LLC
 	select STP
 	depends on IPV6 || IPV6=n
 	help
diff --git net/llc/llc_output.c net/llc/llc_output.c
index 5a6466fc626a..ad66886ed141 100644
--- net/llc/llc_output.c
+++ net/llc/llc_output.c
@@ -13,34 +13,6 @@
 #include <net/llc.h>
 #include <net/llc_pdu.h>
 
-/**
- *	llc_mac_hdr_init - fills MAC header fields
- *	@skb: Address of the frame to initialize its MAC header
- *	@sa: The MAC source address
- *	@da: The MAC destination address
- *
- *	Fills MAC header fields, depending on MAC type. Returns 0, If MAC type
- *	is a valid type and initialization completes correctly 1, otherwise.
- */
-int llc_mac_hdr_init(struct sk_buff *skb,
-		     const unsigned char *sa, const unsigned char *da)
-{
-	int rc = -EINVAL;
-
-	switch (skb->dev->type) {
-	case ARPHRD_ETHER:
-	case ARPHRD_LOOPBACK:
-		rc = dev_hard_header(skb, skb->dev, ETH_P_802_2, da, sa,
-				     skb->len);
-		if (rc > 0)
-			rc = 0;
-		break;
-	default:
-		break;
-	}
-	return rc;
-}
-
 /**
  *	llc_build_and_send_ui_pkt - unitdata request interface for upper layers
  *	@sap: sap to use
