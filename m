Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A684B280C53
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 04:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387581AbgJBCmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 22:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387485AbgJBCme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 22:42:34 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E76C0613D0;
        Thu,  1 Oct 2020 19:42:33 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k13so230270pfg.1;
        Thu, 01 Oct 2020 19:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=odFd5HP3SrWjbzeDvFMjd47wiKSJOjEU0D88/qTJTVI=;
        b=uAqnAgxkUY/UrVdDabt8vA0fjYMREHfTZfbYcFAGDMqUIPNiwNVyv0yPHQvkJ69K4B
         TkxEUb3bBF3ZK6K7PpIlKIVkfBBDzklz2VZP0aG9K7tFjMlpw9Wvnd3mRcVlxLXfBeas
         +2k8n3ruZrdTHEclfdVh1pQaiTw+4T4TsLnYzEYFTr88mztbC8g1KFnRTJVXT4Px6oFy
         3vZQIrN3/etersVmBGV0MUE9KKWW9wV9swyrTPk3FP36QkVkKL1lMJdfYrC/Ceq07cR0
         DqrOyEGXHbeAJXfnr65qkiqm3Vvn8qZj7z7aH/Prwn4fY9A5ofWSG7Ow71fgRbNoiGIZ
         A5cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=odFd5HP3SrWjbzeDvFMjd47wiKSJOjEU0D88/qTJTVI=;
        b=mc+uO7bkmOQeunYo/YufqOn9TNSaVpv/j5ZkAJKFN1al8grqGXDCI7RCIijVNIO6hM
         IeoeHThfaMYpNrU5EEhm3H1prBcgECNcjqKT25QoeFugUAhb7u//EqLH1cOGxE8aTKrn
         6tKdDABciz1meq31YTcAGvFXs7SNt0UHLLjk8B/UaZAxOD8TxOQm42Td7D17I62pWNnk
         h+9bC8xTudM7vm4+pDAY2EZcj7A6qanijLsF+WD3Y/3o0ACT7VVWIClwDD5WrH32B7zO
         dNkHw6N/eauYeTF827Cja8bNNnMdm3b/8BIysGGmpYC3DEr6GAHcugqcOdk2jem8Ut/y
         vgOg==
X-Gm-Message-State: AOAM53059o/FBDDSso49xoRN48w+6u6x/Lsc5CSG1xdyN64jSljuGstv
        t0kTg8xhj6le3eYOtnGqFR5cgL8A50Uj4g==
X-Google-Smtp-Source: ABdhPJx+BKNzjXZOlCBR2SmJyxmtWkplyGOTBO/0nS47RliLDmvuMMBoJ+NXZVHqjTpngBm1YDf7mA==
X-Received: by 2002:a65:6487:: with SMTP id e7mr8486945pgv.409.1601606552344;
        Thu, 01 Oct 2020 19:42:32 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gt11sm150185pjb.48.2020.10.01.19.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 19:42:31 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        vladimir.oltean@nxp.com, olteanv@gmail.com
Subject: [PATCH net-next 1/4] net: dsa: Call dsa_untag_bridge_pvid() from dsa_switch_rcv()
Date:   Thu,  1 Oct 2020 19:42:12 -0700
Message-Id: <20201002024215.660240-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201002024215.660240-1-f.fainelli@gmail.com>
References: <20201002024215.660240-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a DSA switch driver needs to call dsa_untag_bridge_pvid(), it can
set dsa_switch::untag_brige_pvid to indicate this is necessary.

This is a pre-requisite to making sure that we are always calling
dsa_untag_bridge_pvid() after eth_type_trans() has been called.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/net/dsa.h | 8 ++++++++
 net/dsa/dsa.c     | 9 +++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index b502a63d196e..8b0696e08cac 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -308,6 +308,14 @@ struct dsa_switch {
 	 */
 	bool			configure_vlan_while_not_filtering;
 
+	/* If the switch driver always programs the CPU port as egress tagged
+	 * despite the VLAN configuration indicating otherwise, then setting
+	 * @untag_bridge_pvid will force the DSA receive path to pop the bridge's
+	 * default_pvid VLAN tagged frames to offer a consistent behavior
+	 * between a vlan_filtering=0 and vlan_filtering=1 bridge device.
+	 */
+	bool			untag_bridge_pvid;
+
 	/* In case vlan_filtering_is_global is set, the VLAN awareness state
 	 * should be retrieved from here and not from the per-port settings.
 	 */
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 5c18c0214aac..dec4ab59b7c4 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -225,6 +225,15 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 	skb->pkt_type = PACKET_HOST;
 	skb->protocol = eth_type_trans(skb, skb->dev);
 
+	if (unlikely(cpu_dp->ds->untag_bridge_pvid)) {
+		nskb = dsa_untag_bridge_pvid(skb);
+		if (!nskb) {
+			kfree_skb(skb);
+			return 0;
+		}
+		skb = nskb;
+	}
+
 	s = this_cpu_ptr(p->stats64);
 	u64_stats_update_begin(&s->syncp);
 	s->rx_packets++;
-- 
2.25.1

