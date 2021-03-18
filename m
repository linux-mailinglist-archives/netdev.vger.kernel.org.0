Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7B334079C
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbhCROQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbhCROQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:16:15 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AEBC06175F
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:16:14 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 15so7758980ljj.0
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=kY/zRgZtVSmQ9x3rkAtUL3LZBddp1dUIHUnDZROHtsQ=;
        b=kgTthgNFqIuhbkq60fhMSYUKq/BD1H8bTEmDYLeQa9w+apMg1WR+am+y18VzDejyyr
         IHWkd4E6UjtNG9rytGVGhuBT4ceqDKEpAOsvs2xkYS7Pb4rVEkOE/7DjnF3cEAkVsm4U
         UuYMhGozN+vHOES+f5hAel0lzpDqDa9vjBIa8t3pVRVfDC3FCKJiz7xXUsidwvsXb7Oc
         C5qX7Le8a8fu9JdHy8VlvwAUXmo/80piDVsr9uRwhpdb/9YyOZLaaOM/b3K8p21B+w/U
         7jlkryuZbZ7SXAuBu5xT29JXMDrWiq+q8RjEp+VnZsGlCQ/nbyf5RYOunoAI5sGa2Np6
         9VJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=kY/zRgZtVSmQ9x3rkAtUL3LZBddp1dUIHUnDZROHtsQ=;
        b=YPSCZlyMGmvS2iCuJ/SPGDsDmOl8ime4um3SvWT0Gk0fxHUvQZmxKqwEV2L99SRvjr
         0G60Rb10B4Bq9xAh0phWwjw0bG+K0UrSIItyI32X6OmKggMsRG5OuWQqBrOn7Wsqq/Cn
         nth5gMkExzgz6/8ITf3mIk6NidLbYXAaqyUnOn64s+hAbC+zMMVi6PWWi1yGgy1Re0jj
         qawE+YHeSeSkdr+jRDfCLKII+t8Yf13ojqccb3fSoY7lLQb//XSLbp5Wg77i3kaOTX7p
         atuJY9RiZBwrCNTtuFWvfOVQZxWuxiB0nrJycfhfIs40s6KqPxOnYN+SG1O27XtIwxit
         CmNw==
X-Gm-Message-State: AOAM530YnZXhY4Ic1q8OGA54xyytzmlKLdIsQamHDJZvnvI/tYUmHrwu
        5uv4Kz2k4pF2klM1ckWnFl3b7g==
X-Google-Smtp-Source: ABdhPJy7sFJ8KWns8Xr966PWuqkpT+eNDqezumXhe/yVVOf5kxa/nEjbxcIG3Z8Gwq5AFxVYaqmaJQ==
X-Received: by 2002:a2e:9d14:: with SMTP id t20mr5577231lji.391.1616076973024;
        Thu, 18 Mar 2021 07:16:13 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w26sm237382lfr.186.2021.03.18.07.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 07:16:12 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 1/8] net: dsa: Add helper to resolve bridge port from DSA port
Date:   Thu, 18 Mar 2021 15:15:43 +0100
Message-Id: <20210318141550.646383-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318141550.646383-1-tobias@waldekranz.com>
References: <20210318141550.646383-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for a driver to be able to query a bridge for information
about itself, e.g. reading out port flags, it has to use a netdev that
is known to the bridge. In the simple case, that is just the netdev
representing the port, e.g. swp0 or swp1 in this example:

   br0
   / \
swp0 swp1

But in the case of an offloaded lag, this will be the bond or team
interface, e.g. bond0 in this example:

     br0
     /
  bond0
   / \
swp0 swp1

Add a helper that hides some of this complexity from the
drivers. Then, redefine dsa_port_offloads_bridge_port using the helper
to avoid double accounting of the set of possible offloaded uppers.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/net/dsa.h  | 14 ++++++++++++++
 net/dsa/dsa_priv.h | 14 +-------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index dac303edd33d..5c4340ecfeb2 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -493,6 +493,20 @@ static inline bool dsa_port_is_vlan_filtering(const struct dsa_port *dp)
 		return dp->vlan_filtering;
 }
 
+static inline
+struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
+{
+	if (!dsa_is_user_port(dp->ds, dp->index))
+		return NULL;
+
+	if (dp->lag_dev)
+		return dp->lag_dev;
+	else if (dp->hsr_dev)
+		return dp->hsr_dev;
+
+	return dp->slave;
+}
+
 typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
 			      bool is_static, void *data);
 struct dsa_switch_ops {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 9d4b0e9b1aa1..4c43c5406834 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -233,19 +233,7 @@ extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
 static inline bool dsa_port_offloads_bridge_port(struct dsa_port *dp,
 						 struct net_device *dev)
 {
-	/* Switchdev offloading can be configured on: */
-
-	if (dev == dp->slave)
-		/* DSA ports directly connected to a bridge, and event
-		 * was emitted for the ports themselves.
-		 */
-		return true;
-
-	if (dp->lag_dev == dev)
-		/* DSA ports connected to a bridge via a LAG */
-		return true;
-
-	return false;
+	return dsa_port_to_bridge_port(dp) == dev;
 }
 
 static inline bool dsa_port_offloads_bridge(struct dsa_port *dp,
-- 
2.25.1

