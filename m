Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C133A27F81F
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 05:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730357AbgJADG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 23:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJADG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 23:06:29 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CC6C061755;
        Wed, 30 Sep 2020 20:06:29 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id v14so1078164pjd.4;
        Wed, 30 Sep 2020 20:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JpA4mEMdIMQkUgcqLmQKDXhuGQnqErnzJNy5+Hgc68M=;
        b=EdzmHns5Ys9SYSQBrQ4OCbXe5lPCgoPiDWjOAtayXKHCMASFFa23Q+IbQMhfLMLwrM
         N4URGoVlD/hIRgGYh21OQ3dyoin15IeNvlb78R2qsAk0ruDhf63vaEUrVBSpIrjH7wsw
         TWlY5pHNBMR1Vb9RTkdojCfNAvRR1hHAknxAAtbLLRIhSw7OHixlU006QxRgl+BKqtDO
         zrY/PunwpXSY69OhuK+3oXvYag/c6h1qMSLFMaxxk1XKmAuEA0s1NVYaD9ifqY2l5iBP
         GPmiQGcM5e3XjHrKHp3VO8MaCKUwgGeQaLQ49wjAU9TJDcj7AfukUDhsAITMqiO1tJSr
         DypQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JpA4mEMdIMQkUgcqLmQKDXhuGQnqErnzJNy5+Hgc68M=;
        b=Po80BE2SWxrchjhUXZC7iADLmkYUx41qo7/sHVTLM++gnPCGT+0utQNq3EVAAJQhxH
         ft1gSCbrpGgHLAXbecZtwfiok61PxDrYkWYS1MwpSH9pRfsS7R7QOi/OvqHCz6csZGPI
         ZrePhe+jn0jzkYXNdYwNroHqoNztFdzwX8fyS8H90UUy+AR/uWgEiEte5p5oXT8vrdDV
         eqFdEAW8gV7SZPLtD/HwtT4tglQnls466zgIeLjAm1ep2V+CvmEaT9ojz8jcdaTTE5eN
         TkfrikK5UenLObkiQhPSCmwGAkPuN3Rbja/me7D8gI5NKeTnfnLkocIUItKZJdrfes/t
         mI+Q==
X-Gm-Message-State: AOAM530z4fSy18TtxTH+47w850j7dBpg1c8Id2uaBNkhG0c1sJ5pzu1D
        pXZROO48FHWDPFEWZFfM1bVwSe9zuBBLmQ==
X-Google-Smtp-Source: ABdhPJxv/ARbgeuzFASrMrhos8n/vIRXWnYkn3WwENF3n0SYKdg2okH0lV4utlSjpXvCJxb98xZ5/A==
X-Received: by 2002:a17:90b:715:: with SMTP id s21mr4880625pjz.113.1601521588052;
        Wed, 30 Sep 2020 20:06:28 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x4sm4056271pfm.86.2020.09.30.20.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 20:06:27 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2] net: dsa: Support bridge 802.1Q while untagging
Date:   Wed, 30 Sep 2020 20:06:23 -0700
Message-Id: <20201001030623.343535-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The intent of 412a1526d067 ("net: dsa: untag the bridge pvid from rx
skbs") is to transparently untag the bridge's default_pvid when the
Ethernet switch can only support egress tagged of that default_pvid
towards the CPU port.

Prior to this commit, users would have to configure an 802.1Q upper on
the bridge master device when the bridge is configured with
vlan_filtering=0 in order to pop the VLAN tag:

ip link add name br0 type bridge vlan_filtering 0
ip link add link br0 name br0.1 type vlan id 1

After this commit we added support for managing a switch port 802.1Q
upper but those are not usually added as bridge members, and if they do,
they do not actually require any special management, the data path would
pop the desired VLAN tag accordingly.

What we want to preserve is that use case and to manage when the user
creates that 802.1Q upper for the bridge port.

While we are it, call __vlan_find_dev_deep_rcu() which makes use the
VLAN group array which is faster.

As soon as we return the VLAN tagged SKB though it will be used by the
following call path:

netif_receive_skb_list_internal
  -> __netif_receive_skb_list_core
    -> __netif_receive_skb_core
      -> vlan_do_receive()

which uses skb->vlan_proto, if we do not set it to the appropriate VLAN
protocol, we will leave it set to what the DSA master has set
(ETH_P_XDSA).

Fixes: 412a1526d067 ("net: dsa: untag the bridge pvid from rx skbs")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:

- removed unused list_head iter argument

 net/dsa/dsa_priv.h | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 0348dbab4131..b4aafb2e90fa 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -205,7 +205,6 @@ static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
 	struct net_device *br = dp->bridge_dev;
 	struct net_device *dev = skb->dev;
 	struct net_device *upper_dev;
-	struct list_head *iter;
 	u16 vid, pvid, proto;
 	int err;
 
@@ -247,12 +246,10 @@ static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
 	 * supports because vlan_filtering is 0. In that case, we should
 	 * definitely keep the tag, to make sure it keeps working.
 	 */
-	netdev_for_each_upper_dev_rcu(dev, upper_dev, iter) {
-		if (!is_vlan_dev(upper_dev))
-			continue;
-
-		if (vid == vlan_dev_vlan_id(upper_dev))
-			return skb;
+	upper_dev = __vlan_find_dev_deep_rcu(br, htons(proto), vid);
+	if (upper_dev) {
+		skb->vlan_proto = vlan_dev_vlan_proto(upper_dev);
+		return skb;
 	}
 
 	__vlan_hwaccel_clear_tag(skb);
-- 
2.25.1

