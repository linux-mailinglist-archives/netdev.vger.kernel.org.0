Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A162356F3
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 14:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgHBMut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 08:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727914AbgHBMus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 08:50:48 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398E9C06174A
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 05:50:48 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id bs17so6600295edb.1
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 05:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x10urBDzl/1yXhZ8GCaxKLSPxTgXwMHg2Y0MjkjC5Qs=;
        b=eb6qJ9msfsxDPfqxmJe+ctSp7WX2cpWSq5V+Vim2tYDvkRtrfpibqTlwyk7YXW7KUF
         fxHPJ3UtznwDuY7xShHVE3BaqDw8yqWyrUoseoN7FqMXrglt12ruFKfvm/Pc9vrutITQ
         wN240TJGQZ6bBxGMPdxgkKICikQEieaqses2U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x10urBDzl/1yXhZ8GCaxKLSPxTgXwMHg2Y0MjkjC5Qs=;
        b=OmgR0N0obkoF6iS5rP2dxo50+2eXknAEmQrp991+pOeA+w0VfDv9FG+dgTmD3cD5zO
         eQtiBnl9Bo/14GZStP+7y4KnBKOifyJQNCFOWKfl16MZyAQ4ibWwShiWAj0d+2RKUE8H
         SSG0cPPAWQlx57ghvuP2t5UP/9NpB6RDNsp8pbioEXD/O94rMTk9pVHWkP4RzorkwcAA
         eBMaW3jfDD7fENA/2Hz9nD2uEQHk0mCp2BKzdW4YO1SEBge8qodC5Xq4VQhwuETOqVpJ
         YOnHlJ3hT6Z1Iqs5HsVLIzj8cLusVyULlILs44wyyRipd9RGzei6Uf99wqQ4XTM249Co
         pQ9w==
X-Gm-Message-State: AOAM532Z9Ku7S3Ni5UCp3W6sb2XtHpqbkoJw+dE1tyCZa+aqz5/zyqDZ
        ocEF+Sdhhl9s8rtv+lPgl6uqsrrguKU=
X-Google-Smtp-Source: ABdhPJzOwTgsFFdDzGh08UM7ypKAKtHe3igoMWEAvrLnI/jXSyAwVlEfmLf3MNZD7KXreu3SzYxrZg==
X-Received: by 2002:aa7:cf19:: with SMTP id a25mr11334050edy.67.1596372646378;
        Sun, 02 Aug 2020 05:50:46 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x21sm13382416edq.84.2020.08.02.05.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2020 05:50:45 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net v2] net: bridge: clear skb private space on bridge dev xmit
Date:   Sun,  2 Aug 2020 15:50:39 +0300
Message-Id: <20200802125039.648571-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <39736ed8-8565-ab64-5163-da6f2acba68a@cumulusnetworks.com>
References: <39736ed8-8565-ab64-5163-da6f2acba68a@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to clear all of the bridge private skb variables as they can be
stale due to the packet having skb->cb initialized earlier and then
transmitted through the bridge device. Similar memset is already done on
bridge's input. We've seen cases where proxyarp_replied was 1 on routed
multicast packets transmitted through the bridge to ports with neigh
suppress and were getting dropped. Same thing can in theory happen with the
port isolation bit as well. We clear only the struct part after the bridge
pointer (currently 8 bytes) since the pointer is always set later.
We can now remove the redundant zeroing of frag_max_size.
Also add a BUILD_BUG_ON to make sure we catch any movement of the bridge
dev pointer.

Fixes: 821f1b21cabb ("bridge: add new BR_NEIGH_SUPPRESS port flag to suppress arp and nd flood")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
v2: clear only the second half of the struct which contains the
fields that are used in various bridge parts, this replaced the rep stos
instruction with a single movq on my x86 and in general reduces
the clear area to 8 bytes, and in addition we can remove the now
redundant zeroing of frag_max_size as it will be already cleared,
add a build_bug_on to make sure we catch any movement of the bridge
dev pointer

 net/bridge/br_device.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 8c7b78f8bc23..4f7880c99d3c 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -36,6 +36,12 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	const unsigned char *dest;
 	u16 vid = 0;
 
+	/* clear all private fields after the bridge dev pointer */
+	BUILD_BUG_ON(offsetof(struct br_input_skb_cb, brdev) > 0);
+	memset(skb->cb + sizeof(struct net_device *),
+	       0,
+	       sizeof(struct br_input_skb_cb) - sizeof(struct net_device *));
+
 	rcu_read_lock();
 	nf_ops = rcu_dereference(nf_br_ops);
 	if (nf_ops && nf_ops->br_dev_xmit_hook(skb)) {
@@ -50,7 +56,6 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	br_switchdev_frame_unmark(skb);
 	BR_INPUT_SKB_CB(skb)->brdev = dev;
-	BR_INPUT_SKB_CB(skb)->frag_max_size = 0;
 
 	skb_reset_mac_header(skb);
 	skb_pull(skb, ETH_HLEN);
-- 
2.25.4

