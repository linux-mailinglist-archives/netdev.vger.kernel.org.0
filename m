Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B492F27F35E
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbgI3Uc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3Uc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 16:32:57 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8F3C061755;
        Wed, 30 Sep 2020 13:32:57 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id q123so2081066pfb.0;
        Wed, 30 Sep 2020 13:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3LuZlvNy3ggiD9uof21qZJxBoN+uubQpiJaQlUZV0tQ=;
        b=Ol8mExBTTOYnj6tzAyYWffJGTGvDOaKnZXMsSR/IJ77sPHQ0WVJaCH5VfzPgu5WZjf
         phLMoIpxTk3vjTBoiBxGV+oIH8sfFAf1Mm7VImeaUk+wEQhP4VMMQmQtvo0PwR1sNCrI
         Pv2/47e/lZg7aFgVCEFwxhUvBjNniyOgdtbEAYDWhS3fbSDgvuSaP3aCTPpjUVVA/aEX
         hs1PzyV22o5xvsCdxrLbu+BUOPYy8lVW8+1Tr+6/l9z6lKminCPtjceRWqSo5MDBO7eo
         bbfoX3HbAG8Z25G4QTqpvoee0WmoMM6gnfgz3Y810AFaYCHq9WYrsv7E8PjwXZilkwhj
         xJmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3LuZlvNy3ggiD9uof21qZJxBoN+uubQpiJaQlUZV0tQ=;
        b=oa/eW6m5II9wXaEn9RBxftlCWHb4Ljj7kA3DYscH5fZNjXz5zo4oBbRFMseKmksmMO
         0NAYUb6EZpVecYXWuKSHyROeg6zdLBY4WyVdDqnn96mUjdMnD/yaYIbSHqWg0OUr9qWS
         NivVHZAtdguM9N8Qt59YJg6/4cS9vsK+RHCzAzW0AS22Npu5TXylAb+PCGYcEfUC5i0c
         H1BueY3/1brzBdb7eOuMnT+oHhaixY1jIKA6fmtPxP83+1iwq0xs+pE56bnhZiB5zFqX
         Y0p1y6JsSlkjjC0ZD5wG8auAmstan9lJ5DLkguN7yWkrgbgvWUBWM+2QwWbDqbzViE0L
         s+6Q==
X-Gm-Message-State: AOAM531NYfydSllICEJBkAqdP5n5sccVGsMPBXt+t5lIZSU+O4F9Yanb
        Kg9vsviNB7j+kG4g2VZ+3U3ZgajcGDaZBQ==
X-Google-Smtp-Source: ABdhPJxTjUUlc0jT3Pvvzr5Gvp1pg7yZ7pwzPqcw68QBQ2rRR7E7gZKiC/l+ds1I18RTNQh2oxFoQw==
X-Received: by 2002:aa7:9f81:0:b029:142:2501:34d9 with SMTP id z1-20020aa79f810000b0290142250134d9mr3772330pfr.50.1601497976817;
        Wed, 30 Sep 2020 13:32:56 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b11sm3322010pfo.15.2020.09.30.13.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 13:32:56 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: Support bridge 802.1Q while untagging
Date:   Wed, 30 Sep 2020 13:31:03 -0700
Message-Id: <20200930203103.225677-1-f.fainelli@gmail.com>
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

ip link add name br0 type bridge vlan_filtering=0
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
 net/dsa/dsa_priv.h | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 0348dbab4131..3456b53d4d53 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -247,12 +247,10 @@ static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
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

