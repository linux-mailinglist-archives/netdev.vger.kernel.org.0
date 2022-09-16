Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9D05BB0FE
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiIPQPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiIPQPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:15:43 -0400
Received: from simonwunderlich.de (simonwunderlich.de [IPv6:2a01:4f8:c17:e8c0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9AC67C94
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 09:15:42 -0700 (PDT)
Received: from kero.packetmixer.de (p200300C5973C57d0711f6270F7f2cd25.dip0.t-ipconnect.de [IPv6:2003:c5:973c:57d0:711f:6270:f7f2:cd25])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 25D58FA29F;
        Fri, 16 Sep 2022 18:09:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=simonwunderlich.de;
        s=09092022; t=1663344576; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TALuOfVa+seOrky7V+Hq5lLBNa/KjchPIIZ4gveoG5E=;
        b=NRz+hPFndTET5A6ib6EYtblSXBWFumWxOH7AThpBafgeP9jmvK9tdtATj4R+7mMNWkbH61
        pDJVJZaSZ0z16BQD6c1P9JR00TuZQYuoKVSZJaxiNN8PjPyZw0iRtpOnxKB9M25gsjfMiS
        12sqs5ZACphdPFGRQ0U6HMS8DkWNuRldlxaY4M3Tj0KUVujxiJVUss+RxCZXq1gfX7wb9y
        fRUrkbflrhoVa5KoG3sIjY8t7WoPHfuw6gWrHJ1U4F09BbdjhRymqNik1+aQGp/eD2oAlj
        I9sxgMysJi7UdBuiG4CDOKXcCzhbEIC2VlBhEZBhvhOJwakHNPvmegWsE5OfhA==
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Shigeru Yoshida <syoshida@redhat.com>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 1/1] batman-adv: Fix hang up with small MTU hard-interface
Date:   Fri, 16 Sep 2022 18:09:31 +0200
Message-Id: <20220916160931.1412407-2-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220916160931.1412407-1-sw@simonwunderlich.de>
References: <20220916160931.1412407-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=simonwunderlich.de; s=09092022; t=1663344576;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TALuOfVa+seOrky7V+Hq5lLBNa/KjchPIIZ4gveoG5E=;
        b=ASBtFTffQ/8tYkPcG/Pv5OwNlPn+4RtJzIWeWyhB7yjmGPOJZkQZlvL9k8//MGPAz5IAXu
        uhYlbCusMCBhHRR2ZrDJ7J2s3GppkpXNJDi4QQoSFBBWUUKNdfnRkJPH9Qs7262tdOTBZM
        rZV7ClSwgVO0rvzmK779n/WaVh2n5i7Pa3WsDXzxIuojDAqhnWOVOV5F9eepSGwT0MOoN7
        e6gN822ECF5z7S73jsEGspT/Gg8y0OIEonwUdcRGnKM2pPrXDeo6wzxFMZ1Vwfq0GFYyBs
        l2cyTr8Kzt6zZgRRQnpPnC3bfMPSHxcZOJLi6RXQqUSBP2hJeKN/3i1TQUZE2g==
ARC-Seal: i=1; s=09092022; d=simonwunderlich.de; t=1663344576; a=rsa-sha256;
        cv=none;
        b=Yy/ByGTAEg6o/NCCxwWRErBwTLzGRL3+VfgAWIBbYb7nP1W0hZyHlQq5Xkpbm4B/x3H8CAi2q3B9MciSeRh/J1qOoLU1YXShN82gflENE8qGou+dTzJVzzQoS+oYW7AdJOCNLkFiYK1CyUAdil8IViEs0Eh49HHpiFym+FYWmocQeBAifaJyRAinEDy+tWCWsRtiiiLSfiMB841I8ugDpzkLhg0mtIHudsGlwR2lDl0xY4w6hE86txy4qXymhn54LRVzZrgD6Re2NqQ46H/uwybgwghJ769/Rz19u6wDJEJKUMJaY6QDn9lrDC8hk13c3R/XIEbUdtXFShcqDKK8nQ==
ARC-Authentication-Results: i=1;
        simonwunderlich.de;
        auth=pass smtp.auth=sw@simonwunderlich.de smtp.mailfrom=sw@simonwunderlich.de
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shigeru Yoshida <syoshida@redhat.com>

The system hangs up when batman-adv soft-interface is created on
hard-interface with small MTU.  For example, the following commands
create batman-adv soft-interface on dummy interface with zero MTU:

  # ip link add name dummy0 type dummy
  # ip link set mtu 0 dev dummy0
  # ip link set up dev dummy0
  # ip link add name bat0 type batadv
  # ip link set dev dummy0 master bat0

These commands cause the system hang up with the following messages:

  [   90.578925][ T6689] batman_adv: bat0: Adding interface: dummy0
  [   90.580884][ T6689] batman_adv: bat0: The MTU of interface dummy0 is too small (0) to handle the transport of batman-adv packets. Packets going over this interface will be fragmented on layer2 which could impact the performance. Setting the MTU to 1560 would solve the problem.
  [   90.586264][ T6689] batman_adv: bat0: Interface activated: dummy0
  [   90.590061][ T6689] batman_adv: bat0: Forced to purge local tt entries to fit new maximum fragment MTU (-320)
  [   90.595517][ T6689] batman_adv: bat0: Forced to purge local tt entries to fit new maximum fragment MTU (-320)
  [   90.598499][ T6689] batman_adv: bat0: Forced to purge local tt entries to fit new maximum fragment MTU (-320)

This patch fixes this issue by returning error when enabling
hard-interface with small MTU size.

Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/hard-interface.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index b8f8da7ee3de..41c1ad33d009 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -10,6 +10,7 @@
 #include <linux/atomic.h>
 #include <linux/byteorder/generic.h>
 #include <linux/container_of.h>
+#include <linux/errno.h>
 #include <linux/gfp.h>
 #include <linux/if.h>
 #include <linux/if_arp.h>
@@ -700,6 +701,9 @@ int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
 	int max_header_len = batadv_max_header_len();
 	int ret;
 
+	if (hard_iface->net_dev->mtu < ETH_MIN_MTU + max_header_len)
+		return -EINVAL;
+
 	if (hard_iface->if_status != BATADV_IF_NOT_IN_USE)
 		goto out;
 
-- 
2.30.2

