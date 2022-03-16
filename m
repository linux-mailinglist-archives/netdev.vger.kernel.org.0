Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CEF4DB468
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346002AbiCPPLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357044AbiCPPKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:10:49 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C5266FBF
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:16 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id bn33so3536753ljb.6
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=76757SLn2m3kynx16q8kTjn2S8FyWnl1tPy4d5M2WAU=;
        b=fOo4unQQPl/kO4jXHli7n90QN01vhns0vLZqV98YC5kcPh3XSV4992TiZQhGEWLRkO
         4kQIWapNT6BhIwx1qJMnISKt1aVfLh+wmFCjRFNnyo87bfUqDdyQXxi4JyoyVi7jVrdY
         AS70kYTbecf/dmgzPTY/g6vBo8hAUwaLrQ71P4J6OIdGUmvi25LuDBqaP0i32eXebJh2
         XZ11KLYwSgtlweOgOO+6geRrcVtKd3XWEKWuFGTV9QaA1TAbExBR1NiZF8tk3narzKcH
         D6X2aS7K94orJvwQlXXN0/WKsgPPGoPEBS7nVyFdP86HCRk8hZFSU57Le42G3Y0afvAu
         H1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=76757SLn2m3kynx16q8kTjn2S8FyWnl1tPy4d5M2WAU=;
        b=01+2Pgeaa1K/2R7AWStth5KEV/QR0sA9Vmd6GXwHl/qwfqkf8Nw1KAB1lTZORpnC4L
         TnUJocXzfosgFxUCMudMhwGX3eVex3emes87vVacrczsZ2VedpP7f/EPwr2FktPbl0dv
         xhQZHb5dKt6U9b95vLB0hTcbERM/mj3SCyKMTofAjjNz5cL1yKansv4QFDWvwcUm5POp
         Q3kcxUsqVKTEQsfxGPT8Rcocw/yUqJuK7O0USLu3O15cC4Vr7C49eVVJd/lUeODYUU00
         Wf2/Y6EpaUnarXkcOi8t/9nfYAouH/7wmc5kfT4xCCsfQuQbFlcbf4FI+H+fbIulbprD
         O7eg==
X-Gm-Message-State: AOAM532661SHqaQ9Ihm09oKWrWhHKkaRiBispXigjTIsmUjDKhvbOmM3
        Lo1UJ3Gu8UtTyvGoOobyt/u4/w==
X-Google-Smtp-Source: ABdhPJzEsCMh5g9BO8NN8Iqwc1t6E2YmNjvMLJFHxbt292Q6BiPJ4ktUOEzR47lkrBf3I78m/9p78g==
X-Received: by 2002:a2e:9847:0:b0:244:4deb:70d1 with SMTP id e7-20020a2e9847000000b002444deb70d1mr91331ljj.146.1647443354786;
        Wed, 16 Mar 2022 08:09:14 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id d2-20020a194f02000000b00448b915e2d3sm176048lfb.99.2022.03.16.08.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:09:14 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [PATCH v5 net-next 08/15] net: bridge: mst: Add helper to check if MST is enabled
Date:   Wed, 16 Mar 2022 16:08:50 +0100
Message-Id: <20220316150857.2442916-9-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316150857.2442916-1-tobias@waldekranz.com>
References: <20220316150857.2442916-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is useful for switchdev drivers that might want to refuse to join
a bridge where MST is enabled, if the hardware can't support it.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/linux/if_bridge.h | 6 ++++++
 net/bridge/br_mst.c       | 9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 1cf0cc46d90d..4efd5540279a 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -119,6 +119,7 @@ int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo);
 int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
 			 struct bridge_vlan_info *p_vinfo);
+bool br_mst_enabled(const struct net_device *dev);
 int br_mst_get_info(const struct net_device *dev, u16 msti, unsigned long *vids);
 #else
 static inline bool br_vlan_enabled(const struct net_device *dev)
@@ -153,6 +154,11 @@ static inline int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
 	return -EINVAL;
 }
 
+static inline bool br_mst_enabled(const struct net_device *dev)
+{
+	return false;
+}
+
 static inline int br_mst_get_info(const struct net_device *dev, u16 msti,
 				  unsigned long *vids)
 {
diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
index 00b36e629224..830a5746479f 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -13,6 +13,15 @@
 
 DEFINE_STATIC_KEY_FALSE(br_mst_used);
 
+bool br_mst_enabled(const struct net_device *dev)
+{
+	if (!netif_is_bridge_master(dev))
+		return false;
+
+	return br_opt_get(netdev_priv(dev), BROPT_MST_ENABLED);
+}
+EXPORT_SYMBOL_GPL(br_mst_enabled);
+
 int br_mst_get_info(const struct net_device *dev, u16 msti, unsigned long *vids)
 {
 	const struct net_bridge_vlan_group *vg;
-- 
2.25.1

