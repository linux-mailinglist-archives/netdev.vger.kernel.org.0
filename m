Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475163B5336
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 13:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhF0L5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 07:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbhF0L5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 07:57:10 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606B5C061766
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 04:54:45 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id m14so20899134edp.9
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 04:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Edf+tNNF3bAWLChiP/XQGcKno3Pvtq/MrCmR6QJoexs=;
        b=CvJK1waDZsD1by/0+/hQtINXYBssR1XKzsZrE73MO/U0tPN/MKduRJwBaXtQM69Jlq
         ZneIiuPUfZGyHJVwO46UrjddD2o7DwczbJmFYVY4E44yEMW3zEEdWPa2Okn1xNgs3AGE
         FEKmHr8v5vgDpGYzJZ2/qHrTrnnKE2Chl7ZrsAJIT1DU2i95zxcjLmaOi0RoTElXBcBL
         mkcA80J4XBbspZtTQFbJiKAj6ghy7QiF1CKGsKZQRpP3+HOIbOL4J7lemNlMthJGA56F
         XLN+3a0CSHyNkmH6Fms0uyrHmk/ujABYqaEqnjcfEQorj7oe0TQwIebKEvxKtfgSRxBV
         MNFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Edf+tNNF3bAWLChiP/XQGcKno3Pvtq/MrCmR6QJoexs=;
        b=J4G1oAYFywZ5HL0BMbKHCr0YCz9M3fWwp/fM9ma9OVvvGE6YsE7fWdG/JNAcmRRjkf
         KQBEIeU5kb08yaf1WTY7ILIn1ob29OSsnKPBnYAGkNH59uzt9Vlw4nW3+t51HekXc858
         F6BuE1ytY85DDh9tCiEsJ4c1XSrnZipKaJAl1PfKdp+3KtUPePdvsBJ9EF9ihQuRmfkJ
         6Hz/VSZ8mIqt2s8SQyPkgFv/mLcwG4pV6P5VKpgIQLqH7L48Y9drFIenSw3yiCkybxTt
         HMhIRZo15KxCfwjzP/rAy2y3gF3B7++anWTqS5W1bNP/2Q3hy9iYLPtqRmARDoCbthLv
         Q6uA==
X-Gm-Message-State: AOAM533lyziI7TYEYsjkfnVfZzLul0qH6sDlxBKejN0u82TvamL3xLXL
        qv/ZUIWZaK+ZXGlkkUznww4=
X-Google-Smtp-Source: ABdhPJzdIgKRtT0tLrJGxZUz+poq+oWE8G2omSX3L+hQjezzzVormf0UYjaHY6gTQAHeZqCOXAdAbw==
X-Received: by 2002:a05:6402:1d56:: with SMTP id dz22mr27182877edb.376.1624794884034;
        Sun, 27 Jun 2021 04:54:44 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7683688edu.49.2021.06.27.04.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 04:54:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 7/8] net: dsa: refactor the prechangeupper sanity checks into a dedicated function
Date:   Sun, 27 Jun 2021 14:54:28 +0300
Message-Id: <20210627115429.1084203-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627115429.1084203-1-olteanv@gmail.com>
References: <20210627115429.1084203-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

We need to add more logic to the DSA NETDEV_PRECHANGEUPPER event
handler, more exactly we need to request an unsync of switchdev objects.
In order to fit more code, refactor the existing logic into a helper.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 net/dsa/slave.c | 44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 2f0d0a6b1f9c..20d8466d78f2 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2166,6 +2166,32 @@ dsa_slave_check_8021q_upper(struct net_device *dev,
 	return NOTIFY_DONE;
 }
 
+static int
+dsa_slave_prechangeupper_sanity_check(struct net_device *dev,
+				      struct netdev_notifier_changeupper_info *info)
+{
+	struct dsa_switch *ds;
+	struct dsa_port *dp;
+	int err;
+
+	if (!dsa_slave_dev_check(dev))
+		return dsa_prevent_bridging_8021q_upper(dev, info);
+
+	dp = dsa_slave_to_port(dev);
+	ds = dp->ds;
+
+	if (ds->ops->port_prechangeupper) {
+		err = ds->ops->port_prechangeupper(ds, dp->index, info);
+		if (err)
+			return notifier_from_errno(err);
+	}
+
+	if (is_vlan_dev(info->upper_dev))
+		return dsa_slave_check_8021q_upper(dev, info);
+
+	return NOTIFY_DONE;
+}
+
 static int dsa_slave_netdevice_event(struct notifier_block *nb,
 				     unsigned long event, void *ptr)
 {
@@ -2174,24 +2200,12 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER: {
 		struct netdev_notifier_changeupper_info *info = ptr;
-		struct dsa_switch *ds;
-		struct dsa_port *dp;
 		int err;
 
-		if (!dsa_slave_dev_check(dev))
-			return dsa_prevent_bridging_8021q_upper(dev, ptr);
-
-		dp = dsa_slave_to_port(dev);
-		ds = dp->ds;
-
-		if (ds->ops->port_prechangeupper) {
-			err = ds->ops->port_prechangeupper(ds, dp->index, info);
-			if (err)
-				return notifier_from_errno(err);
-		}
+		err = dsa_slave_prechangeupper_sanity_check(dev, info);
+		if (err != NOTIFY_DONE)
+			return err;
 
-		if (is_vlan_dev(info->upper_dev))
-			return dsa_slave_check_8021q_upper(dev, ptr);
 		break;
 	}
 	case NETDEV_CHANGEUPPER:
-- 
2.25.1

