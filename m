Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495CF4B8299
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 09:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbiBPIJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 03:09:14 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiBPIJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 03:09:12 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC806243A21
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 00:09:00 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 139so1498465pge.1
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 00:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T8395C4Zt/itBPDUlxCmZCS1JqZ7KGNXLRy5c3B3VMM=;
        b=oqZ5mftdNx3KAaVTimpKd1gINNmCAMEeQqbL2zT8fQcLJ/Jym1qGbrpcegtQvi0K+g
         hy1fPNjxVD0R24yTMXXCDBrLCFjmZATSCSde8TjnJmu3NYxGaHK+aL6zTmoXFj8qYgol
         SdhmAbAa9Q5wUrTHOu53EIM/MQJ6nG0VnU8OFmj0k9sUv2LixpGNb2/96RCYAro4BkWB
         byQMACsbUJvSNu4K8SZJYE0Okt+fzg/t9oLkjYuTfUpaw0j2fprBOlaKLoFHXmhOxIe3
         0XyXZcgc1eTmYEbWoUXdKoRByflJMWIyFphxBKBmnmHKl06tcwzjPVzD1hudlOYkWCTl
         OW8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T8395C4Zt/itBPDUlxCmZCS1JqZ7KGNXLRy5c3B3VMM=;
        b=0ayjGExLQaGLp40mdBoREP0I/+PBXVSkF+Rkj58ssw2mDCYRieNbXn65rcFBA6lPNx
         VH+BbjJ4JJORz+/uKxbXZwa5GoYpM3LPKUkb3pAhBzwgDgtKYuSTcVbGwKEh8PazPgdn
         JVXeaiwyG9IrRGK3TDY7XBIJmH5hHAB/7xI57A83+ZvNaReU/BQqtuanPsoaBSVHmCEF
         DHt3tyKwbggjspv/g4jfp8qwOlAgMj6m/8Wi27CGEhcLw1roZhw12xE9kybFPbUhKJ5V
         PYTTA9bz2uBXn0BHieeZ0HSPC7JP75IVRXeJp66iXvit8ur3tBKQqU3QwgJ+jR94p4jM
         rAWw==
X-Gm-Message-State: AOAM532Gh7GGcwOgNohRBzNo6MEVsQ8eQQAVa7W+R0xZM0bAIbcn8ULe
        GVX8TrE9vWZWGry8VNJMu857qCE3RmI=
X-Google-Smtp-Source: ABdhPJy5xHketvgJGmxXJHXEV6PE5kwlV3N+OfIVwKqtzjnMhG+8/uHdLfEHtprr1lrKhVVCNEYibQ==
X-Received: by 2002:a05:6a00:148f:b0:4bc:fb2d:4b6f with SMTP id v15-20020a056a00148f00b004bcfb2d4b6fmr2051336pfu.62.1644998940180;
        Wed, 16 Feb 2022 00:09:00 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s15sm4635662pgn.30.2022.02.16.00.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 00:08:59 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next 2/5] Bonding: split bond_handle_vlan from bond_arp_send
Date:   Wed, 16 Feb 2022 16:08:35 +0800
Message-Id: <20220216080838.158054-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220216080838.158054-1-liuhangbin@gmail.com>
References: <20220216080838.158054-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function bond_handle_vlan() is split from bond_arp_send() for later
IPv6 usage.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c | 58 +++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 617c2bf8c5a7..00621c523276 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2794,31 +2794,15 @@ static bool bond_has_this_ip(struct bonding *bond, __be32 ip)
 	return ret;
 }
 
-/* We go to the (large) trouble of VLAN tagging ARP frames because
- * switches in VLAN mode (especially if ports are configured as
- * "native" to a VLAN) might not pass non-tagged frames.
- */
-static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
-			  __be32 src_ip, struct bond_vlan_tag *tags)
+static bool bond_handle_vlan(struct slave *slave, struct bond_vlan_tag *tags,
+			     struct sk_buff *skb)
 {
-	struct sk_buff *skb;
-	struct bond_vlan_tag *outer_tag = tags;
-	struct net_device *slave_dev = slave->dev;
 	struct net_device *bond_dev = slave->bond->dev;
-
-	slave_dbg(bond_dev, slave_dev, "arp %d on slave: dst %pI4 src %pI4\n",
-		  arp_op, &dest_ip, &src_ip);
-
-	skb = arp_create(arp_op, ETH_P_ARP, dest_ip, slave_dev, src_ip,
-			 NULL, slave_dev->dev_addr, NULL);
-
-	if (!skb) {
-		net_err_ratelimited("ARP packet allocation failed\n");
-		return;
-	}
+	struct net_device *slave_dev = slave->dev;
+	struct bond_vlan_tag *outer_tag = tags;
 
 	if (!tags || tags->vlan_proto == VLAN_N_VID)
-		goto xmit;
+		return true;
 
 	tags++;
 
@@ -2835,7 +2819,7 @@ static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
 						tags->vlan_id);
 		if (!skb) {
 			net_err_ratelimited("failed to insert inner VLAN tag\n");
-			return;
+			return false;
 		}
 
 		tags++;
@@ -2848,8 +2832,34 @@ static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
 				       outer_tag->vlan_id);
 	}
 
-xmit:
-	arp_xmit(skb);
+	return true;
+}
+
+/* We go to the (large) trouble of VLAN tagging ARP frames because
+ * switches in VLAN mode (especially if ports are configured as
+ * "native" to a VLAN) might not pass non-tagged frames.
+ */
+static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
+			  __be32 src_ip, struct bond_vlan_tag *tags)
+{
+	struct net_device *bond_dev = slave->bond->dev;
+	struct net_device *slave_dev = slave->dev;
+	struct sk_buff *skb;
+
+	slave_dbg(bond_dev, slave_dev, "arp %d on slave: dst %pI4 src %pI4\n",
+		  arp_op, &dest_ip, &src_ip);
+
+	skb = arp_create(arp_op, ETH_P_ARP, dest_ip, slave_dev, src_ip,
+			 NULL, slave_dev->dev_addr, NULL);
+
+	if (!skb) {
+		net_err_ratelimited("ARP packet allocation failed\n");
+		return;
+	}
+
+	if (bond_handle_vlan(slave, tags, skb))
+		arp_xmit(skb);
+	return;
 }
 
 /* Validate the device path between the @start_dev and the @end_dev.
-- 
2.31.1

