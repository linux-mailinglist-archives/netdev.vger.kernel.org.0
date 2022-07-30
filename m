Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59875585B37
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 18:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbiG3QD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 12:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbiG3QDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 12:03:53 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B340175AB;
        Sat, 30 Jul 2022 09:03:52 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id e12so3108769qkl.2;
        Sat, 30 Jul 2022 09:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zRKN74TQjwEeR1MXdcsMHUkpi1gfgBWwqBLJHY0W5pg=;
        b=e8obaoeKKLn4nDRJrPnpp+Nx91jHsh+5jGuLA3o7/VXte2H4xHqwCTGOn7N/ElemPK
         MFg6uCb2jlRoLX9GgA24VUIL1lnmH4D+w+C33UK9+pNXxer39+llNCC+Wr02JgR2Llw3
         Ran1qCCSgTh1O1r7SV95sNfZwjKyeZ1ogrlIUio3i9j98DyrUGqHbDhQU8GOD58+m2Kd
         /j5dUOQpykwJ/1eOkbrFTOeEdXCow4cXUi0V5K19/nkBL8e27mePsdpTwmt0yz6Vn8bS
         O+pKMBzosX+WPPzrYaxvj7oNz1b58i+aAP980qMehS8gGMkahcHDtrfQNj1DfE41DY6n
         f8jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zRKN74TQjwEeR1MXdcsMHUkpi1gfgBWwqBLJHY0W5pg=;
        b=S4I4MbT4FvIvtgIjuuTt9AbmKwtKVlbuiujodCOb3UoKESxj2kKfERQ/G9iBXn0fuV
         SUsAQm23wv0Ef3VAQXX19JZMfJP6WFwpcXQJLYE3EF5UG0e+MI5NQAs/gu9kRmY8neOe
         qPjoh8iJtSBAXBxqoCXp9qPggX+tZCK24xkeJW7m0tGk3JkVzufvN3usPW/d2el2CTkR
         9MUgx1JCmhcGWBcEK7onJvNSJpBQa5aFoaj2O7Bi8wTEUbvrf8hMpr7Ef0IlMCzAYeeW
         QCVeR2D6lR6He8clyJmjJ7u16NAzA23vtDRmzP1R9DuGyaImmfu8KWSKKIdAghpEg10X
         ReTg==
X-Gm-Message-State: AJIora/xs06LCFaarn8BYlR02W1qvZb+BuRQuR+YgePefWQCdoFXsWOV
        /BD+cOuwVLB7Qj/y6pmWjpQ=
X-Google-Smtp-Source: AGRyM1tQF4ZDhWXmr4879jKeaqsCfxS0+QIrYK0Pb8ySlm3tndMJl7qWrMdy9M/hl4hg1/I5gQJxBw==
X-Received: by 2002:a05:620a:2453:b0:6b6:104a:b9b4 with SMTP id h19-20020a05620a245300b006b6104ab9b4mr6449215qkn.713.1659197031240;
        Sat, 30 Jul 2022 09:03:51 -0700 (PDT)
Received: from ada ([71.58.109.160])
        by smtp.gmail.com with ESMTPSA id h3-20020a05620a400300b006b5da3c8d81sm4986651qko.73.2022.07.30.09.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 09:03:50 -0700 (PDT)
From:   Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
To:     aroulin@nvidia.com
Cc:     sbrivio@redhat.com, roopa@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Subject: [PATCH net-next 2/3] net: 8021q: fix bridge binding behavior for vlan interfaces
Date:   Sat, 30 Jul 2022 12:03:31 -0400
Message-Id: <2b09fbacde7e8818f4ada4829818fdf015e36b58.1659195179.git.sevinj.aghayeva@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659195179.git.sevinj.aghayeva@gmail.com>
References: <cover.1659195179.git.sevinj.aghayeva@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when one creates a vlan interface with the bridge binding
flag disabled (using ip link add... command) and then enables the
bridge binding flag afterwards (using ip link set... command), the
second command has no effect. In other words, the vlan interface does
not follow the status of the ports in its vlan.

The root cause of this problem is as follows. The correct bridge
binding behavior depends on two flags being set: a per vlan interface
flag (VLAN_FLAG_BRIDGE_BINDING) and global per bridge flag
(BROPT_VLAN_BRIDGE_BINDING); the ip link set command calls
vlan_dev_change_flags function, which sets only the per vlan interface
flag.

The correct behavior is to set/unset per bridge flag as well,
depending on whether there are other vlan interfaces with bridge
binding flags set. The logic for this behavior is already captured in
br_vlan_upper_change function. This patch fixes the bridge binding
behavior by calling the br_vlan_upper_change function whenever the per
interface flag is changed via vlan_dev_change_flags function.

Signed-off-by: Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Reviewed-by: Andy Roulin <aroulin@nvidia.com>
Reviewed-by: Roopa Prabhu <roopa@nvidia.com>
---
 net/8021q/vlan.h     |  2 +-
 net/8021q/vlan_dev.c | 21 ++++++++++++++++++---
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 5eaf38875554..71947cdcfaaa 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -130,7 +130,7 @@ void vlan_dev_set_ingress_priority(const struct net_device *dev,
 int vlan_dev_set_egress_priority(const struct net_device *dev,
 				 u32 skb_prio, u16 vlan_prio);
 void vlan_dev_free_egress_priority(const struct net_device *dev);
-int vlan_dev_change_flags(const struct net_device *dev, u32 flag, u32 mask);
+int vlan_dev_change_flags(struct net_device *dev, u32 flag, u32 mask);
 void vlan_dev_get_realdev_name(const struct net_device *dev, char *result,
 			       size_t size);
 
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 035812b0461c..93680bac60b3 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -30,6 +30,7 @@
 #include "vlan.h"
 #include "vlanproc.h"
 #include <linux/if_vlan.h>
+#include <linux/if_bridge.h>
 #include <linux/netpoll.h>
 
 /*
@@ -211,10 +212,11 @@ int vlan_dev_set_egress_priority(const struct net_device *dev,
 /* Flags are defined in the vlan_flags enum in
  * include/uapi/linux/if_vlan.h file.
  */
-int vlan_dev_change_flags(const struct net_device *dev, u32 flags, u32 mask)
+int vlan_dev_change_flags(struct net_device *dev, u32 flags, u32 mask)
 {
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
 	u32 old_flags = vlan->flags;
+	struct net_device *br_dev;
 
 	if (mask & ~(VLAN_FLAG_REORDER_HDR | VLAN_FLAG_GVRP |
 		     VLAN_FLAG_LOOSE_BINDING | VLAN_FLAG_MVRP |
@@ -223,19 +225,32 @@ int vlan_dev_change_flags(const struct net_device *dev, u32 flags, u32 mask)
 
 	vlan->flags = (old_flags & ~mask) | (flags & mask);
 
-	if (netif_running(dev) && (vlan->flags ^ old_flags) & VLAN_FLAG_GVRP) {
+	if (!netif_running(dev))
+		return 0;
+
+	if ((vlan->flags ^ old_flags) & VLAN_FLAG_GVRP) {
 		if (vlan->flags & VLAN_FLAG_GVRP)
 			vlan_gvrp_request_join(dev);
 		else
 			vlan_gvrp_request_leave(dev);
 	}
 
-	if (netif_running(dev) && (vlan->flags ^ old_flags) & VLAN_FLAG_MVRP) {
+	if ((vlan->flags ^ old_flags) & VLAN_FLAG_MVRP) {
 		if (vlan->flags & VLAN_FLAG_MVRP)
 			vlan_mvrp_request_join(dev);
 		else
 			vlan_mvrp_request_leave(dev);
 	}
+
+	if ((vlan->flags ^ old_flags) & VLAN_FLAG_BRIDGE_BINDING &&
+	    netif_is_bridge_port(dev)) {
+		br_dev = vlan->real_dev;
+		if (vlan->flags & VLAN_FLAG_BRIDGE_BINDING)
+			br_vlan_upper_change(br_dev, dev, true);
+		else
+			br_vlan_upper_change(br_dev, dev, false);
+	}
+
 	return 0;
 }
 
-- 
2.25.1

