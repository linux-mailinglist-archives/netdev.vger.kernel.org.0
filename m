Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BDC1E5075
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387563AbgE0V0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387412AbgE0V0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:26:10 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3741C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:26:09 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 131so4065453pfv.13
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W6vatV0mvvrqwbvSWrarzUt8Jg9KpoDo83UO+GzNTrQ=;
        b=XlQZ9y2FJ5RGwLyIkChlsXW9mHkOED6xJjHN1t8bF+SogVPsfAIKb9cMk29PeWYY+Z
         d0/b6eqk+O7EcYUrMDUdTqExplIHcfnpKByVAOfiF7Y7KW+zY5q2fW3q+BIdsthtYmPU
         hY0kC3SNGC5zLMYhI9Zt5tRVSdyfiPPaSnicI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W6vatV0mvvrqwbvSWrarzUt8Jg9KpoDo83UO+GzNTrQ=;
        b=dkpTpxpGZ9mj+h0xXzTLyygNZRsDQV4q3BgAaWNzmV7rx7C2w4aFbl25ghgWaok4ZS
         MKj5XQ3Lkv2BiFkM2g5ek44HQrC/FGrQzjUfoIOyaabj+rYa8nN4m4iz2YTSXApGsrdo
         tCXxpjdxAxBABjDnZHPtE5s9hmPLAdBXqVSni1/umuomDympGKX8jXN8FPD8ECqdt7eU
         mySwcJNAMd463YOlEbN9pYW0eSroD7Q5NBbYjYGM4aCJxOASED1C7IgilkGlxtuAJf20
         I6kolRyHhg0lT+B+8ITxJRUUMaD2/8RPUoezDTyYL78FlrE9DULy0LSqr+JljnE6CvjX
         isxQ==
X-Gm-Message-State: AOAM533KLYKr4ebsvi3nKjbwU8ARTSPkQah0pUyrAPX2ie+ljHztG9Sv
        2yDuGlDVYEfcFBjXnk6YQfi288oiFzAR2v6mrAC5QE8mL+5zgroXpb5r6KjYizvrz0CzQ+wdHXo
        bqOQduQn67dFfXONo2lnY2QsRIpmnSs1Jw3vaBxIMynO4IvegNzqtBiznd/Rf87XFLibKOyBw
X-Google-Smtp-Source: ABdhPJwXeqjzQdeE+KH7e0Kr51gRUNBF9ay82rsWxhNkMgjDPb+T++jKfYFi3q+qizPoyDDWcUP39g==
X-Received: by 2002:a63:3c0a:: with SMTP id j10mr6062578pga.35.1590614768610;
        Wed, 27 May 2020 14:26:08 -0700 (PDT)
Received: from localhost.localdomain ([2600:8802:202:f600::ddf])
        by smtp.gmail.com with ESMTPSA id c4sm2770344pfb.130.2020.05.27.14.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 14:26:08 -0700 (PDT)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Edwin Peer <edwin.peer@broadcom.com>, edumazet@google.com,
        linville@tuxdriver.com, shemminger@vyatta.com,
        mirq-linux@rere.qmqm.pl, jesse.brandeburg@intel.com,
        jchapman@katalix.com, david@weave.works, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, sridhar.samudrala@intel.com,
        jiri@mellanox.com, geoff@infradead.org, mokuno@sm.sony.co.jp,
        msink@permonline.ru, mporter@kernel.crashing.org,
        inaky.perez-gonzalez@intel.com, jwi@linux.ibm.com,
        kgraul@linux.ibm.com, ubraun@linux.ibm.com,
        grant.likely@secretlab.ca, hadi@cyberus.ca, dsahern@kernel.org,
        shrijeet@gmail.com, jon.mason@intel.com, dave.jiang@intel.com,
        saeedm@mellanox.com, hadarh@mellanox.com, ogerlitz@mellanox.com,
        allenbh@gmail.com, michael.chan@broadcom.com
Subject: [RFC PATCH net-next 09/11] net: ntb_netdev: support VLAN using IFF_NO_VLAN_ROOM
Date:   Wed, 27 May 2020 14:25:10 -0700
Message-Id: <20200527212512.17901-10-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527212512.17901-1-edwin.peer@broadcom.com>
References: <20200527212512.17901-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not clear how useful VLANs layered over Ethernet emulated over NTB
transport are, but they are presently allowed. The L2 emulation exposed
by NTB does not account for possible VLAN tags in the space allocated
for Ethernet headers when configured for maximal MTU.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
---
 drivers/net/ntb_netdev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index a5bab614ff84..839414afa175 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -52,6 +52,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/ntb.h>
+#include <linux/if_vlan.h>
 #include <linux/ntb_transport.h>
 
 #define NTB_NETDEV_VER	"0.7"
@@ -299,14 +300,16 @@ static int ntb_netdev_close(struct net_device *ndev)
 static int ntb_netdev_change_mtu(struct net_device *ndev, int new_mtu)
 {
 	struct ntb_netdev *dev = netdev_priv(ndev);
+	unsigned int max_mtu = ntb_transport_max_size(dev->qp) - ETH_HLEN;
 	struct sk_buff *skb;
 	int len, rc;
 
-	if (new_mtu > ntb_transport_max_size(dev->qp) - ETH_HLEN)
+	if (new_mtu > max_mtu)
 		return -EINVAL;
 
 	if (!netif_running(ndev)) {
 		ndev->mtu = new_mtu;
+		__vlan_constrain_mtu(ndev, max_mtu);
 		return 0;
 	}
 
@@ -336,6 +339,7 @@ static int ntb_netdev_change_mtu(struct net_device *ndev, int new_mtu)
 	}
 
 	ndev->mtu = new_mtu;
+	__vlan_constrain_mtu(ndev, max_mtu);
 
 	ntb_transport_link_up(dev->qp);
 
@@ -422,7 +426,7 @@ static int ntb_netdev_probe(struct device *client_dev)
 	dev->pdev = pdev;
 	ndev->features = NETIF_F_HIGHDMA;
 
-	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE | IFF_NO_VLAN_ROOM;
 
 	ndev->hw_features = ndev->features;
 	ndev->watchdog_timeo = msecs_to_jiffies(NTB_TX_TIMEOUT_MS);
-- 
2.26.2

