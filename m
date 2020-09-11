Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFBA2657FA
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 06:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbgIKETU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 00:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgIKETO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 00:19:14 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08E4C061573;
        Thu, 10 Sep 2020 21:19:12 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id fa1so1088276pjb.0;
        Thu, 10 Sep 2020 21:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3GKrvUiFlFciRX7VQdx8esQeBBFrNeZILayTSwTWG9g=;
        b=O/twqk4z0+Ftxyy+kfi7ndIejydgPDPb7gfaVqjXEOnQEUq5VNVC4hlcd5cH9Vnp/4
         E5H3b7OCINXOcu8PI6b103VXApOcIzphPdrhGGlYWu7BDji7L3TCJd5GT87fQ1MqZx7L
         pOJZrf18tyrIGe84p/VfjbYgka1B99sVEBCFntut+2s7YkTGEE5xfgNreRc/K+3m3Gvr
         JI7mC+Gr/9jCU6m1a8Visc+5n+uv2zE4rsLqljBKoQ+/qnC7HMwZFdHqIdbRZgBo4Q52
         g9i3L+IsLG/v3vm9ekHoLGwVbGCZB7ecaWx5Re4orxJC2TEZweHfeqnQCokiKteIOFi0
         si/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3GKrvUiFlFciRX7VQdx8esQeBBFrNeZILayTSwTWG9g=;
        b=smDho3sMGTPiLITzspjSRig6CW9tAKM66oCe7tr5IZV3a1Pep8sqMfNZEOA4IbgaNs
         17wrZDpiLdixipkLeui7Omxl2uYkQQo3YMTEbsCGnSRZn6d+AP6uOpn+01w6hqDH/LcF
         GTB3fgdAH5w2rwmHfh7OpfnI0Jm5GFZ0yezOjgntwMbFOLVmTSHxK/crIC+/1DKBKUEu
         cLdQvgzWWI26YtA5E6t6dGEppVC8OecX6786ZBmzF7Qy4RxaM5XmwmriKKzFls8U+vt3
         GcGXoYypcRYtilGvFMrhKFpmhWkOd6ygHHzq3D8GBm64NANhmnYrfB0oama45vFAhGuD
         d/wg==
X-Gm-Message-State: AOAM530khIHdS8LZJF/xkc9dRjpUU5fsRnuUAsHpeJYTBqQ4Dxn5oXYb
        p8odOJ8nCPweHGbsNg+h5w07KDVZQw0=
X-Google-Smtp-Source: ABdhPJxm8ZAn4MLLQXmqYeEclMvS7tgMlxh0wah1WLYGH8L+tUn4lLA/u5kH+I5qeVM4paD5/9ti9Q==
X-Received: by 2002:a17:90a:f407:: with SMTP id ch7mr489565pjb.142.1599797951051;
        Thu, 10 Sep 2020 21:19:11 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s9sm493201pgm.40.2020.09.10.21.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 21:19:10 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: b53: Configure VLANs while not filtering
Date:   Thu, 10 Sep 2020 21:19:05 -0700
Message-Id: <20200911041905.58191-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the B53 driver to support VLANs while not filtering. This
requires us to enable VLAN globally within the switch upon driver
initial configuration (dev->vlan_enabled).

We also need to remove the code that dealt with PVID re-configuration in
b53_vlan_filtering() since that function worked under the assumption
that it would only be called to make a bridge VLAN filtering, or not
filtering, and we would attempt to move the port's PVID accordingly.

Now that VLANs are programmed all the time, even in the case of a
non-VLAN filtering bridge, we would be programming a default_pvid for
the bridged switch ports.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 6a5796c32721..46ac8875f870 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1377,23 +1377,6 @@ EXPORT_SYMBOL(b53_phylink_mac_link_up);
 int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
 {
 	struct b53_device *dev = ds->priv;
-	u16 pvid, new_pvid;
-
-	b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &pvid);
-	if (!vlan_filtering) {
-		/* Filtering is currently enabled, use the default PVID since
-		 * the bridge does not expect tagging anymore
-		 */
-		dev->ports[port].pvid = pvid;
-		new_pvid = b53_default_pvid(dev);
-	} else {
-		/* Filtering is currently disabled, restore the previous PVID */
-		new_pvid = dev->ports[port].pvid;
-	}
-
-	if (pvid != new_pvid)
-		b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port),
-			    new_pvid);
 
 	b53_enable_vlan(dev, dev->vlan_enabled, vlan_filtering);
 
@@ -1444,7 +1427,7 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
 			untagged = true;
 
 		vl->members |= BIT(port);
-		if (untagged && !dsa_is_cpu_port(ds, port))
+		if (untagged)
 			vl->untag |= BIT(port);
 		else
 			vl->untag &= ~BIT(port);
@@ -1482,7 +1465,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
 		if (pvid == vid)
 			pvid = b53_default_pvid(dev);
 
-		if (untagged && !dsa_is_cpu_port(ds, port))
+		if (untagged)
 			vl->untag &= ~(BIT(port));
 
 		b53_set_vlan_entry(dev, vid, vl);
@@ -2619,6 +2602,8 @@ struct b53_device *b53_switch_alloc(struct device *base,
 	dev->priv = priv;
 	dev->ops = ops;
 	ds->ops = &b53_switch_ops;
+	ds->configure_vlan_while_not_filtering = true;
+	dev->vlan_enabled = ds->configure_vlan_while_not_filtering;
 	mutex_init(&dev->reg_mutex);
 	mutex_init(&dev->stats_mutex);
 
-- 
2.25.1

