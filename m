Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40F21C9695
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 18:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgEGQcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 12:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727822AbgEGQcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 12:32:35 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FC6C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 09:32:35 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id r124so217785qkf.1
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 09:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6aeC9/qLfTlvNH/AATWvERpkIvP/I32i5HF3svwjmx8=;
        b=eLK4lQoFOH5a4wv/yrFr5MqYDImbQYHJ8zjH5XvVw72bd4+KK6Fb4gRMPCxSWUX8p0
         SHv3bf5GIMfqtWFwQP069lmZdc0Y4qWN3zi1JUJXBQ2HYAOxavJQzb9yr1NoUMi88ax7
         6u0DQoXAzXKohhae8Q7nVy8q3bIaOPLWLaXgcclkse8/mrzyA44rnLJ/cS6T9b9XSLfu
         T5oDxUuL+WB45xMEHYOriZlHJEErbw1ES05Catm0ewDDxaZFbyj3TcmYT5O57qPKd7RM
         mFsFmsYQgfpe77xT/Ri3vlo9t0OB7adbEUh5rnqS3dCcQigM3+cSdcKaHdmOz26iiQ4y
         BNlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6aeC9/qLfTlvNH/AATWvERpkIvP/I32i5HF3svwjmx8=;
        b=n6sr5TlY5j4pWRMjJ7xvVFcrQFogJKyW+nCxAOy6zN06nyBRcSkBgiNZtLRAowMK05
         CzF9sGcPbpkn7LsoM3R1DQWdH2inp4GXrPofHHWChREOI2NfhLbbODfEoNKCMJ4N4Kpj
         xKR9bRWbVORQDWcQAhxvDNMC9iAiY/gD6wwY9gXOfXS7pph0/wmvaFFUJOfkGQp3H2Ir
         f+ESmY2gv+gcmi+Ozn7rZefR/26z4Uho0sOIA8+UBnlVoFTzNdVYuNDB7DGpNPdjL1/W
         /Q8tRgnLP3mfhN1N/UWV1p7qf31dzuYhdQ9n9yyEq2Yj3C3Xb0pQkx9uzmCILw8JeYPh
         /qSQ==
X-Gm-Message-State: AGi0PubWpcvjqC//VmQAeIyCAY4CXIjFSMrZw3gObMINVaAApwAjn0dD
        ZLb9a3fTDh1L39UVkQE0KtCrIkDx83WQgA==
X-Google-Smtp-Source: APiQypJOsezfxzUir34BuApFQpM0/PtHE5+mHb5RSRXaycMifxUxGmBGmGxvls6UWFsZZuTvCbCb4RtFXDsVuw==
X-Received: by 2002:a05:6214:114d:: with SMTP id b13mr8001939qvt.44.1588869154905;
 Thu, 07 May 2020 09:32:34 -0700 (PDT)
Date:   Thu,  7 May 2020 09:32:21 -0700
In-Reply-To: <20200507163222.122469-1-edumazet@google.com>
Message-Id: <20200507163222.122469-5-edumazet@google.com>
Mime-Version: 1.0
References: <20200507163222.122469-1-edumazet@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net-next 4/5] netpoll: accept NULL np argument in netpoll_send_skb()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netpoll_send_skb() callers seem to leak skb if
the np pointer is NULL. While this should not happen, we
can make the code more robust.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/macvlan.c   |  5 ++---
 include/linux/if_team.h |  5 +----
 include/net/bonding.h   |  5 +----
 net/8021q/vlan_dev.c    |  5 ++---
 net/bridge/br_private.h |  5 +----
 net/core/netpoll.c      | 11 ++++++++---
 net/dsa/slave.c         |  5 ++---
 7 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 34eb073cdd744fd00e59b0ab46f465721e5b71c3..9a419d5102ce5319424e5b62291e35ca11660069 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -542,12 +542,11 @@ static int macvlan_queue_xmit(struct sk_buff *skb, struct net_device *dev)
 static inline netdev_tx_t macvlan_netpoll_send_skb(struct macvlan_dev *vlan, struct sk_buff *skb)
 {
 #ifdef CONFIG_NET_POLL_CONTROLLER
-	if (vlan->netpoll)
-		netpoll_send_skb(vlan->netpoll, skb);
+	return netpoll_send_skb(vlan->netpoll, skb);
 #else
 	BUG();
-#endif
 	return NETDEV_TX_OK;
+#endif
 }
 
 static netdev_tx_t macvlan_start_xmit(struct sk_buff *skb,
diff --git a/include/linux/if_team.h b/include/linux/if_team.h
index ec7e4bd07f825539c21c74e87bd2f675a72fac9a..537dc2b8c8798594848c39a176a5969227b7230e 100644
--- a/include/linux/if_team.h
+++ b/include/linux/if_team.h
@@ -102,10 +102,7 @@ static inline bool team_port_dev_txable(const struct net_device *port_dev)
 static inline void team_netpoll_send_skb(struct team_port *port,
 					 struct sk_buff *skb)
 {
-	struct netpoll *np = port->np;
-
-	if (np)
-		netpoll_send_skb(np, skb);
+	netpoll_send_skb(port->np, skb);
 }
 #else
 static inline void team_netpoll_send_skb(struct team_port *port,
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 0b696da5c1157b8f5b84fc79babc404840fd67fd..f211983cd52a81804f0ad555eaaa876ad927b40b 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -507,10 +507,7 @@ static inline unsigned long slave_last_rx(struct bonding *bond,
 static inline void bond_netpoll_send_skb(const struct slave *slave,
 					 struct sk_buff *skb)
 {
-	struct netpoll *np = slave->np;
-
-	if (np)
-		netpoll_send_skb(np, skb);
+	netpoll_send_skb(slave->np, skb);
 }
 #else
 static inline void bond_netpoll_send_skb(const struct slave *slave,
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 319220b2341ddbda5471ba2dba88a44ca874a75a..f00bb57f0f600b2366eb8ac06da0f1f6d8590099 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -88,12 +88,11 @@ static int vlan_dev_hard_header(struct sk_buff *skb, struct net_device *dev,
 static inline netdev_tx_t vlan_netpoll_send_skb(struct vlan_dev_priv *vlan, struct sk_buff *skb)
 {
 #ifdef CONFIG_NET_POLL_CONTROLLER
-	if (vlan->netpoll)
-		netpoll_send_skb(vlan->netpoll, skb);
+	return netpoll_send_skb(vlan->netpoll, skb);
 #else
 	BUG();
-#endif
 	return NETDEV_TX_OK;
+#endif
 }
 
 static netdev_tx_t vlan_dev_hard_start_xmit(struct sk_buff *skb,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 78d3a951180ddab3b0c2ee4f042ccfe71958275d..4dc21e8f7e33bc20d980a2c143a96a2bfdee4bb5 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -598,10 +598,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev);
 static inline void br_netpoll_send_skb(const struct net_bridge_port *p,
 				       struct sk_buff *skb)
 {
-	struct netpoll *np = p->np;
-
-	if (np)
-		netpoll_send_skb(np, skb);
+	netpoll_send_skb(p->np, skb);
 }
 
 int br_netpoll_enable(struct net_bridge_port *p);
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 40d2753aa47dd0b83a10a97bb4bacccbc1aaf085..093e90e52bc25411806fe2f3d04ca27cab47ec32 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -367,9 +367,14 @@ netdev_tx_t netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 	unsigned long flags;
 	netdev_tx_t ret;
 
-	local_irq_save(flags);
-	ret = __netpoll_send_skb(np, skb);
-	local_irq_restore(flags);
+	if (unlikely(!np)) {
+		dev_kfree_skb_irq(skb);
+		ret = NET_XMIT_DROP;
+	} else {
+		local_irq_save(flags);
+		ret = __netpoll_send_skb(np, skb);
+		local_irq_restore(flags);
+	}
 	return ret;
 }
 EXPORT_SYMBOL(netpoll_send_skb);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ea0fcf7bf78625cf68329a2f4ac0c05e06f3c59b..07c3580e8a7523e0c5c1acb9892a5c7a81b91949 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -445,12 +445,11 @@ static inline netdev_tx_t dsa_slave_netpoll_send_skb(struct net_device *dev,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	struct dsa_slave_priv *p = netdev_priv(dev);
 
-	if (p->netpoll)
-		netpoll_send_skb(p->netpoll, skb);
+	return netpoll_send_skb(p->netpoll, skb);
 #else
 	BUG();
-#endif
 	return NETDEV_TX_OK;
+#endif
 }
 
 static void dsa_skb_tx_timestamp(struct dsa_slave_priv *p,
-- 
2.26.2.526.g744177e7f7-goog

