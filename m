Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F107248EFA
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgHRTqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgHRTov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:44:51 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC50C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:44:51 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id f5so13565261pfe.2
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=NWdyNvsC5gPH455/7zlQJ4yPgaW+4MtM61fOXZENfYI=;
        b=jHAPxQxGdtHPcEjR+anN3sEjeI3+XbwGlk/rmjQDuflOqRChCP0Kn6lH3mPZtVEGIQ
         YdYdGynTeoolLIWbwnp6Elc3N4v990K+YH/UJSyZy1lO95QZ7Fapi2DnyvsTbxQNSkPs
         pQ/K/g1ozU3ee7tqydSO7LH7ghsyqBP7kIhdHxOLKxTCKR8bd3hx1NR3gU7WLiC1OqaF
         wR6PT5OydJkqCzBAbLbUSSAlmZnYt+UM9SieMr+h60r6rC1JDd0vQBzJMrew3KtIZ7Iv
         IZ/6Fy9wV8MEp2+MjYOxWzyMDy38uQHsXEtumNpQnJhZRv40gn3H0IlTXqVQfdCS04Pj
         ygOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NWdyNvsC5gPH455/7zlQJ4yPgaW+4MtM61fOXZENfYI=;
        b=DX73tJrWiED54OLbXRYwlNe0JH73ZInfK8mwE+hk0KU2zKUuFLSPg/CBysDpqBj8CZ
         t5L1I6275UpMJbHzNcdyRZP215HO10m04JhHgRvXzLETAGiCzdGhJFeoy/5b41ABfy9R
         en/DiWU961NxMovdS+qAGNEBwEldy8mLZiUuQCliAP1qbFP1NhUN/vaikluSz/5+E/9I
         KVcZ9gOMKV/aiibbB0FLey2nOde8VF5nYaHxfFsgSPbCmyFtCFsR6u/qtpBZCi3TM2Y5
         7kRM1V8A64tfJqcVV7QqZ2eKiNipRMzlyzVe8vmoErArQbMjCJrMmO8FahDKpSgNq+hP
         f+6g==
X-Gm-Message-State: AOAM5313w/MCa2x3f7oKvyusFky/BMa2xzraJXHGg9M3KVQTXnePkKXQ
        aj02YPQOcb/wWTAkLf5VUFjKDA2Xtq1g481lNPnjccbL1iVgqTeHNKf/1hrHEhQHStVnvq7LkNf
        2CohStjql6J7eJ/Ah/FRz1TLVdDGs5OPiaRiaYx/C3jLQy7e512EJh9Ax6x1qElLo+Il7Xqba
X-Google-Smtp-Source: ABdhPJwJorN+tuQ805EX2+PCx5musL5ZS2H98VVf8SLY5wN0uUt1G8rSfn1gd91HynWst7Xl76j7x7HBOb3GvLl+
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a17:90a:ccd:: with SMTP id
 13mr1165138pjt.123.1597779890733; Tue, 18 Aug 2020 12:44:50 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:44:07 -0700
In-Reply-To: <20200818194417.2003932-1-awogbemila@google.com>
Message-Id: <20200818194417.2003932-9-awogbemila@google.com>
Mime-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net-next 08/18] gve: Enable Link Speed Reporting in the driver.
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change allows the driver to report the device link speed
when the ethtool command:
	ethtool <nic name>
is run.
Getting the link speed is done via a new admin queue command:
ReportLinkSpeed.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         |  3 +++
 drivers/net/ethernet/google/gve/gve_adminq.c  | 27 +++++++++++++++++++
 drivers/net/ethernet/google/gve/gve_adminq.h  |  9 +++++++
 drivers/net/ethernet/google/gve/gve_ethtool.c | 11 ++++++++
 4 files changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index bc54059f9b2e..0f5871af36af 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -252,6 +252,9 @@ struct gve_priv {
 	unsigned long service_timer_period;
 	struct timer_list service_timer;
 
+	/* Gvnic device link speed from hypervisor. */
+	u64 link_speed;
+
   /* Gvnic device's dma mask, set during probe. */
 	u8 dma_mask;
 };
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 023e6f804972..cf5eaab1cb83 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -596,3 +596,30 @@ int gve_adminq_report_stats(struct gve_priv *priv, u64 stats_report_len,
 	return gve_adminq_execute_cmd(priv, &cmd);
 }
 
+int gve_adminq_report_link_speed(struct gve_priv *priv)
+{
+	union gve_adminq_command gvnic_cmd;
+	dma_addr_t link_speed_region_bus;
+	u64 *link_speed_region;
+	int err;
+
+	link_speed_region =
+		dma_alloc_coherent(&priv->pdev->dev, sizeof(*link_speed_region),
+				   &link_speed_region_bus, GFP_KERNEL);
+
+	if (!link_speed_region)
+		return -ENOMEM;
+
+	memset(&gvnic_cmd, 0, sizeof(gvnic_cmd));
+	gvnic_cmd.opcode = cpu_to_be32(GVE_ADMINQ_REPORT_LINK_SPEED);
+	gvnic_cmd.report_link_speed.link_speed_address =
+		cpu_to_be64(link_speed_region_bus);
+
+	err = gve_adminq_execute_cmd(priv, &gvnic_cmd);
+
+	priv->link_speed = be64_to_cpu(*link_speed_region);
+	dma_free_coherent(&priv->pdev->dev, sizeof(*link_speed_region), link_speed_region,
+			  link_speed_region_bus);
+	return err;
+}
+
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index 784830f75b7c..281de8326bc5 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -22,6 +22,7 @@ enum gve_adminq_opcodes {
 	GVE_ADMINQ_DECONFIGURE_DEVICE_RESOURCES	= 0x9,
 	GVE_ADMINQ_SET_DRIVER_PARAMETER		= 0xB,
 	GVE_ADMINQ_REPORT_STATS			= 0xC,
+	GVE_ADMINQ_REPORT_LINK_SPEED	= 0xD
 };
 
 /* Admin queue status codes */
@@ -181,6 +182,12 @@ struct gve_adminq_report_stats {
 
 static_assert(sizeof(struct gve_adminq_report_stats) == 24);
 
+struct gve_adminq_report_link_speed {
+	__be64 link_speed_address;
+};
+
+static_assert(sizeof(struct gve_adminq_report_link_speed) == 8);
+
 struct stats {
 	__be32 stat_name;
 	__be32 queue_id;
@@ -228,6 +235,7 @@ union gve_adminq_command {
 			struct gve_adminq_unregister_page_list unreg_page_list;
 			struct gve_adminq_set_driver_parameter set_driver_param;
 			struct gve_adminq_report_stats report_stats;
+			struct gve_adminq_report_link_speed report_link_speed;
 		};
 	};
 	u8 reserved[64];
@@ -255,4 +263,5 @@ int gve_adminq_unregister_page_list(struct gve_priv *priv, u32 page_list_id);
 int gve_adminq_set_mtu(struct gve_priv *priv, u64 mtu);
 int gve_adminq_report_stats(struct gve_priv *priv, u64 stats_report_len,
 			    dma_addr_t stats_report_addr, u64 interval);
+int gve_adminq_report_link_speed(struct gve_priv *priv);
 #endif /* _GVE_ADMINQ_H */
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 9d778e04b9f4..8bc8383558d8 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -509,6 +509,16 @@ static int gve_set_priv_flags(struct net_device *netdev, u32 flags)
 	return 0;
 }
 
+static int gve_get_link_ksettings(struct net_device *netdev,
+				  struct ethtool_link_ksettings *cmd)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+	int err = gve_adminq_report_link_speed(priv);
+
+	cmd->base.speed = priv->link_speed;
+	return err;
+}
+
 const struct ethtool_ops gve_ethtool_ops = {
 	.get_drvinfo = gve_get_drvinfo,
 	.get_strings = gve_get_strings,
@@ -525,4 +535,5 @@ const struct ethtool_ops gve_ethtool_ops = {
 	.set_tunable = gve_set_tunable,
 	.get_priv_flags = gve_get_priv_flags,
 	.set_priv_flags = gve_set_priv_flags,
+	.get_link_ksettings = gve_get_link_ksettings
 };
-- 
2.28.0.220.ged08abb693-goog

