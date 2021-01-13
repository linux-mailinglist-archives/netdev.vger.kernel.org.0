Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E736D2F4F03
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 16:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbhAMPmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 10:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbhAMPmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 10:42:31 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF7CC061795
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 07:41:50 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id jx16so3676210ejb.10
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 07:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TvkS6i4Fyjzn1ikKAEuAkoStATy8hbPW+VQB7jOQ0kU=;
        b=eCNUIkpcJv/737U2dz6PTiX88o5c4NodTvoL51QO6SD7kTUvu68Ir+SQUpOBUKEZ7D
         YQUvukIwJM5ACHUFuyxUCk2F/zm9ikp726cHaAlP+Nl/eo03afsy46EFIDQ6iQQyhOJv
         5XSLAiof1flW7zIjMK2weC3sCZffwsaLkD5mbo3Y0yKEq6cTkr157Net01IURjb+6X5o
         R+au1X/grs3tjpritL44+UhCqeybCZAFxL4w16VESvdWtJfydbospVe/9dwhasAEdpar
         8Y+H5QAcRdIQHxby1Q/T5ceM8WW+Snw0pKGIPFHreBEbb3B4UlnRO49/AL7fwulO8mxi
         OZjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TvkS6i4Fyjzn1ikKAEuAkoStATy8hbPW+VQB7jOQ0kU=;
        b=FdDaukT2kZBwhVCzpncN6UHpfBeUWtsRlMBh50p9bRBjv72cTjrxHp5zHC042JYc9h
         BU5RHlqZ1k+lBvWEaKtbwmb9q/lLcufJIYW4sk+Qd/cfLGutXIkCgIvNAOKZ+u6iS2sw
         Wp0gc24lZjq49Yp1UzZdmyODjwC9sjQgxwQSc9Pp4qLpdU9rZBLXliHnc/bk519k2NHX
         ZK3ppRJYaDo7gpyT/gjqW1lIZ/vEpw+7hhtawlHAhJ27qlL765c8iCHinME/RoHs+2AX
         VLu7YJweBwAcE+LB2Mn5/urhvqUJi3xndb1jxMbZYeO8V3r9tE4hFeCC4/gvPpQ8RdRl
         HX4w==
X-Gm-Message-State: AOAM530Exjo4Bs4bFOeAEKEu5NCS/9Pjb3ecNDfQidbaY7GocuCDwX23
        C+NfBQHtf+g2rpwZDIvSZcI=
X-Google-Smtp-Source: ABdhPJzr1L1qtW1R6kbxMBI81mEKKmU6RYdQMhvrAjTox4rtFrBElokwLq7TKZHHvDJU4WsqJnPOJg==
X-Received: by 2002:a17:907:3d90:: with SMTP id he16mr2076443ejc.235.1610552509569;
        Wed, 13 Jan 2021 07:41:49 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id bn21sm852499ejb.47.2021.01.13.07.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 07:41:48 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com
Subject: [RFC PATCH net-next 2/2] net: dsa: felix: offload port priority
Date:   Wed, 13 Jan 2021 17:41:39 +0200
Message-Id: <20210113154139.1803705-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210113154139.1803705-1-olteanv@gmail.com>
References: <20210113154139.1803705-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Even though we should really share the implementation with the ocelot
switchdev driver, that one needs a little bit of rework first, since its
struct ocelot_port_tc only supports one tc matchall action at a time,
which at the moment is used for port policers. Whereas DSA keeps a list
of port-based actions in struct dsa_slave_priv::mall_tc_list, so it is
much more easily extensible. It is too tempting to add the implementation
for the port priority directly in Felix at the moment, which is what we
do.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 768a74dc462a..5cc42c3aaf0d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -739,6 +739,20 @@ static void felix_port_policer_del(struct dsa_switch *ds, int port)
 	ocelot_port_policer_del(ocelot, port);
 }
 
+static int felix_port_priority_set(struct dsa_switch *ds, int port,
+				   struct dsa_mall_skbedit_tc_entry *skbedit)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_rmw_gix(ocelot,
+		       ANA_PORT_QOS_CFG_QOS_DEFAULT_VAL(skbedit->priority),
+		       ANA_PORT_QOS_CFG_QOS_DEFAULT_VAL_M,
+		       ANA_PORT_QOS_CFG,
+		       port);
+
+	return 0;
+}
+
 static int felix_port_setup_tc(struct dsa_switch *ds, int port,
 			       enum tc_setup_type type,
 			       void *type_data)
@@ -786,6 +800,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_max_mtu		= felix_get_max_mtu,
 	.port_policer_add	= felix_port_policer_add,
 	.port_policer_del	= felix_port_policer_del,
+	.port_priority_set	= felix_port_priority_set,
 	.cls_flower_add		= felix_cls_flower_add,
 	.cls_flower_del		= felix_cls_flower_del,
 	.cls_flower_stats	= felix_cls_flower_stats,
-- 
2.25.1

