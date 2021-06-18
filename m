Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED3A3AC2A1
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 06:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhFRE6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 00:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231365AbhFRE6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 00:58:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E17E161209;
        Fri, 18 Jun 2021 04:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623992159;
        bh=oc+F/51ADNA1oJ04fuvzmyyxtCUt64XObWd70sDA4es=;
        h=From:To:Cc:Subject:Date:From;
        b=WOxVzAKJZX+gSJIQjBetBrqWQPfqVXR9zWlN3rOrHeNutdmZLpUJ2MsXUS1P3YD7d
         uRiYcIhESwQGKxMBV1fdsJELRQXvgtGr48RbIpqRnaA4/mnNfMwMJtx65g/y+N1eXR
         9eR9pRtjXPSjXWjmk59kw9hIy57OtBu6k5bGUKYtSYU7Siej4tk9CixETVKu0VI6Tr
         me5wXuXC6XRjHEyLOtI5mlQvDc+2l5BZcWpT+aiFoEkPsicrOW3XlrSL4+2G11+8kb
         9Vg7funkF8SdFB22WaaDDv5kiOe7ejJ4R9vCNk66Hiq1PU7504fg6YAeB59JcPf3dj
         CV95RadlYFGTg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     dcaratti@redhat.com, netdev@vger.kernel.org, willemb@google.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: vlan: pass thru all GSO_SOFTWARE in hw_enc_features
Date:   Thu, 17 Jun 2021 21:55:56 -0700
Message-Id: <20210618045556.1260832-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently UDP tunnel devices on top of VLANs lose the ability
to offload UDP GSO. Widen the pass thru features from TSO
to all GSO_SOFTWARE.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/8021q/vlan.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index fa3ad3d4d58c..edb6acde6b6f 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -108,7 +108,8 @@ static inline netdev_features_t vlan_tnl_features(struct net_device *real_dev)
 	netdev_features_t ret;
 
 	ret = real_dev->hw_enc_features &
-	      (NETIF_F_CSUM_MASK | NETIF_F_ALL_TSO | NETIF_F_GSO_ENCAP_ALL);
+	      (NETIF_F_CSUM_MASK | NETIF_F_GSO_SOFTWARE |
+	       NETIF_F_GSO_ENCAP_ALL);
 
 	if ((ret & NETIF_F_GSO_ENCAP_ALL) && (ret & NETIF_F_CSUM_MASK))
 		return (ret & ~NETIF_F_CSUM_MASK) | NETIF_F_HW_CSUM;
-- 
2.31.1

