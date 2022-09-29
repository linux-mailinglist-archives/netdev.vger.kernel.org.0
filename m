Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6CC5EEEFD
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbiI2H3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234939AbiI2H3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:29:14 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD4213572D
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:29:13 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id e10-20020a05600c4e4a00b003b4eff4ab2cso2667832wmq.4
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=afxhdEeIWZKBb7fbjvmfLtmjQY+YpZyKcmvAKwBHZIU=;
        b=MoyGVR/AzxppFX+vloCtGJN0OhTgZ35MCfp8jHhDCeuZtHRocHrNoAfys6sFc6zdVS
         KvwFaY51Y000eaEy8Aw922RwDeHDQ0tcivgjHQwlddJHR8Ax1Sb6t4RcTMHoxEWaVePS
         hHV9IpBHrMGruF1ImkmTIm09VPW5wvDhn3PGYPI3nOUvEoMa/eTRzXgRD5OvGPMrxr1x
         2cCRmpEyF0sMcbqRPXdfvSjXLLOZwGCXywi/AIwJdbF0+q1C5TJSHdjdF5nEdRle4cRB
         reZGFutITfXXmSub3zo2k3e/0iUNN4l4+4ZiqEv5hfMzVzUZMqD0A+uIA1Hh0vy8Ckhj
         bnDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=afxhdEeIWZKBb7fbjvmfLtmjQY+YpZyKcmvAKwBHZIU=;
        b=eMx2Nd/q9uoSHYMVSREie8Wf4XteMaK2U/zK/XQShhG9Z1lYMGszL/4wjWW41PLNni
         ojnMsq8KGqCJIdHxdLTK+I8lRmhNJZRUefI023ouztYCBVs2iGxycgTYc+aLWPqpMWOc
         Ksq5bp/haTMVlXkWpcMa5NlYCUM1KY77DXM0BMFiDlh4TX9slz67G0yKHog42jO44BA5
         9uB3lQQcUCpRtTs1hPlsQW5qHU56Ruu7Yl2bRA7rrNCYSN92cJMqu3cFpcemsv1yxKu0
         hfaGh9SAFXV1HqxbzP5OcefcUFE31up6UNROVGJwv5a8BHowZpkdoROLw3/phA5u6u6N
         dYzA==
X-Gm-Message-State: ACrzQf1Jyd0B/6gr5i6roz2nLJuSQWCyY4xKcKJnPBL0bRr7YNqMnRrr
        TpfWA5Fju+FKSL4GvBZUzz6a0HJSjitrK6iA
X-Google-Smtp-Source: AMsMyM4dw2pXEHye4QWnjOb1LOjADPl4jVIps5atuUcZdXYJCLRm7+XZNEH7gVgC2TLfefsEjnN6IQ==
X-Received: by 2002:a7b:c447:0:b0:3b4:8977:4186 with SMTP id l7-20020a7bc447000000b003b489774186mr1193812wmi.74.1664436551767;
        Thu, 29 Sep 2022 00:29:11 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e9-20020adfe389000000b00228daaa84aesm5857210wrm.25.2022.09.29.00.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 00:29:11 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next v3 5/7] net: dsa: don't leave dangling pointers in dp->pl when failing
Date:   Thu, 29 Sep 2022 09:29:00 +0200
Message-Id: <20220929072902.2986539-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220929072902.2986539-1-jiri@resnulli.us>
References: <20220929072902.2986539-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is a desire to simplify the dsa_port registration path with
devlink, and this involves reworking a bit how user ports which fail to
connect to their PHY (because it's missing) get reinitialized as UNUSED
devlink ports.

The desire is for the change to look something like this; basically
dsa_port_setup() has failed, we just change dp->type and call
dsa_port_setup() again.

-/* Destroy the current devlink port, and create a new one which has the UNUSED
- * flavour.
- */
-static int dsa_port_reinit_as_unused(struct dsa_port *dp)
+static int dsa_port_setup_as_unused(struct dsa_port *dp)
 {
-	dsa_port_devlink_teardown(dp);
 	dp->type = DSA_PORT_TYPE_UNUSED;
-	return dsa_port_devlink_setup(dp);
+	return dsa_port_setup(dp);
 }

For an UNUSED port, dsa_port_setup() mostly only calls dsa_port_devlink_setup()
anyway, so we could get away with calling just that. But if we call the
full blown dsa_port_setup(dp) (which will be needed to properly set
dp->setup = true), the callee will have the tendency to go through this
code block too, and call dsa_port_disable(dp):

	switch (dp->type) {
	case DSA_PORT_TYPE_UNUSED:
		dsa_port_disable(dp);
		break;

That is not very good, because dsa_port_disable() has this hidden inside
of it:

	if (dp->pl)
		phylink_stop(dp->pl);

Fact is, we are not prepared to handle a call to dsa_port_disable() with
a struct dsa_port that came from a previous (and failed) call to
dsa_port_setup(). We do not clean up dp->pl, and this will make the
second call to dsa_port_setup() call phylink_stop() on a dangling dp->pl
pointer.

Solve this by creating an API for phylink destruction which is symmetric
to the phylink creation, and never leave dp->pl set to anything except
NULL or a valid phylink structure.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/dsa/dsa_priv.h |  1 +
 net/dsa/port.c     | 22 +++++++++++++++-------
 net/dsa/slave.c    |  6 +++---
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 129e4a649c7e..6e65c7ffd6f3 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -294,6 +294,7 @@ int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
 int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
 			       const struct switchdev_obj_ring_role_mrp *mrp);
 int dsa_port_phylink_create(struct dsa_port *dp);
+void dsa_port_phylink_destroy(struct dsa_port *dp);
 int dsa_shared_port_link_register_of(struct dsa_port *dp);
 void dsa_shared_port_link_unregister_of(struct dsa_port *dp);
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index e6289a1db0a0..e4a0513816bb 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1661,6 +1661,7 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	phy_interface_t mode;
+	struct phylink *pl;
 	int err;
 
 	err = of_get_phy_mode(dp->dn, &mode);
@@ -1677,16 +1678,24 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	if (ds->ops->phylink_get_caps)
 		ds->ops->phylink_get_caps(ds, dp->index, &dp->pl_config);
 
-	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
-				mode, &dsa_port_phylink_mac_ops);
-	if (IS_ERR(dp->pl)) {
+	pl = phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
+			    mode, &dsa_port_phylink_mac_ops);
+	if (IS_ERR(pl)) {
 		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(dp->pl));
-		return PTR_ERR(dp->pl);
+		return PTR_ERR(pl);
 	}
 
+	dp->pl = pl;
+
 	return 0;
 }
 
+void dsa_port_phylink_destroy(struct dsa_port *dp)
+{
+	phylink_destroy(dp->pl);
+	dp->pl = NULL;
+}
+
 static int dsa_shared_port_setup_phy_of(struct dsa_port *dp, bool enable)
 {
 	struct dsa_switch *ds = dp->ds;
@@ -1781,7 +1790,7 @@ static int dsa_shared_port_phylink_register(struct dsa_port *dp)
 	return 0;
 
 err_phy_connect:
-	phylink_destroy(dp->pl);
+	dsa_port_phylink_destroy(dp);
 	return err;
 }
 
@@ -1983,8 +1992,7 @@ void dsa_shared_port_link_unregister_of(struct dsa_port *dp)
 		rtnl_lock();
 		phylink_disconnect_phy(dp->pl);
 		rtnl_unlock();
-		phylink_destroy(dp->pl);
-		dp->pl = NULL;
+		dsa_port_phylink_destroy(dp);
 		return;
 	}
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index aa47ddc19fdf..1a59918d3b30 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2304,7 +2304,7 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 	if (ret) {
 		netdev_err(slave_dev, "failed to connect to PHY: %pe\n",
 			   ERR_PTR(ret));
-		phylink_destroy(dp->pl);
+		dsa_port_phylink_destroy(dp);
 	}
 
 	return ret;
@@ -2476,7 +2476,7 @@ int dsa_slave_create(struct dsa_port *port)
 	rtnl_lock();
 	phylink_disconnect_phy(p->dp->pl);
 	rtnl_unlock();
-	phylink_destroy(p->dp->pl);
+	dsa_port_phylink_destroy(p->dp);
 out_gcells:
 	gro_cells_destroy(&p->gcells);
 out_free:
@@ -2499,7 +2499,7 @@ void dsa_slave_destroy(struct net_device *slave_dev)
 	phylink_disconnect_phy(dp->pl);
 	rtnl_unlock();
 
-	phylink_destroy(dp->pl);
+	dsa_port_phylink_destroy(dp);
 	gro_cells_destroy(&p->gcells);
 	free_percpu(slave_dev->tstats);
 	free_netdev(slave_dev);
-- 
2.37.1

