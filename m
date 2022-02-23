Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27CA4C0E38
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 09:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238889AbiBWI1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 03:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238866AbiBWI1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 03:27:31 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE1349CA7
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 00:27:03 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id i11so29703922lfu.3
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 00:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:organization:mime-version
         :content-disposition;
        bh=lZI8MSVW2tWWsa6fqN9PMDj/ctaa5MGPHbotbrYZ/H4=;
        b=leNZ+zxJ4n1ZDprN8CCY783WFbvvcs5laW6eXeaL7062zrQPDOfkiYVhurWGZIoBNm
         9sxjS4sWfhhL+KOB9fB9BdFA4CaZL3V2FCRpgBTHQA7k0jQIruYKbU2ehXK4X/MaM1rz
         rtw8O5XVoSQvvm+d+JEb9tIEKOJuVNs+8HphNQJ+Osh1t4q6HnvBaMoDaKEYCYbyJuOJ
         AnExhkq4ITBjnGVQcvUljHlLFwlzzkIc1KyLZ+dlLFlyde3IJr0c0hi/Bs/5GUlykSsR
         Oy3+SCDlG+yLFmL5dfLxVMDqeS4/T8uhmaM8RNH8SsmQl6WvfRt82mqotQJ7vHv98aQg
         tD5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:organization
         :mime-version:content-disposition;
        bh=lZI8MSVW2tWWsa6fqN9PMDj/ctaa5MGPHbotbrYZ/H4=;
        b=xMRznpixiMTBUSmZz6cR0JX8Avd4G+kW3zUGKWje5Fn7ppbleWnk1CNervlxAYs/gO
         MUJqgSq4yQIcEUQRrVb2Q+f76BNpv+mL3JsM3Jv8THl8vtlTiETLVFFDq5wMYkZMsbr6
         dGEiucxTLXaf5gtxftyX6bCyV2lrgH4YH6U2ZZEDrEfAL+fZUJdqBJdVdaS4a8y4Z4pc
         os4WcFsxIMGOqnPGIcHZ0Eice/FUc253q3K3+OMnAch1h48louvyH7eR7uSurwAB9KKO
         Tvpp1nZoKjldw2Fc7B/c04ibmUklrXZUjv34niPq/M4Mof1gHRwSj/IYoXIMDRvbhgrK
         FDNA==
X-Gm-Message-State: AOAM5315o/CGV1zQKuvi88QcZv8sQ7Di7nJvJRjWh+5bec0q61W+E9h8
        9vJm55zajgT3ZPB2myXs5nPUGb8b03FIlzC++14=
X-Google-Smtp-Source: ABdhPJzObzbz3gJ7F+AglnG1nVNfk0RmcfNQFgx/D5GNcfn7rB2smGbGfNO4dce1MygLhmjscZ8ETQ==
X-Received: by 2002:a05:6512:398b:b0:443:3b11:a985 with SMTP id j11-20020a056512398b00b004433b11a985mr19292370lfu.211.1645604821796;
        Wed, 23 Feb 2022 00:27:01 -0800 (PST)
Received: from wse-c0155 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id l1sm1464700ljq.39.2022.02.23.00.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 00:27:01 -0800 (PST)
Date:   Wed, 23 Feb 2022 09:27:00 +0100
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v3] net: sparx5: Support offloading of bridge port
 flooding flags
Message-ID: <20220223082700.qrot7lepwqcdnyzw@wse-c0155>
Organization: Westermo Network Technologies AB
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Though the SparX-5i can control IPv4/6 multicasts separately from non-IP
multicasts, these are all muxed onto the bridge's BR_MCAST_FLOOD flag.

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
Changes in v2:
 - Added SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS callback
Changes in v3:
 - Removed trailing whitespace

 .../microchip/sparx5/sparx5_switchdev.c       | 21 ++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 649ca609884a..c6cfe652bf88 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -19,11 +19,27 @@ struct sparx5_switchdev_event_work {
 	unsigned long event;
 };
 
+static int sparx5_port_attr_pre_bridge_flags(struct sparx5_port *port,
+					     struct switchdev_brport_flags flags)
+{
+	if (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD))
+		return -EINVAL;
+
+	return 0;
+}
+
 static void sparx5_port_attr_bridge_flags(struct sparx5_port *port,
 					  struct switchdev_brport_flags flags)
 {
+	int pgid;
+
 	if (flags.mask & BR_MCAST_FLOOD)
-		sparx5_pgid_update_mask(port, PGID_MC_FLOOD, true);
+		for (pgid = PGID_MC_FLOOD; pgid <= PGID_IPV6_MC_CTRL; pgid++)
+			sparx5_pgid_update_mask(port, pgid, !!(flags.val & BR_MCAST_FLOOD));
+	if (flags.mask & BR_FLOOD)
+		sparx5_pgid_update_mask(port, PGID_UC_FLOOD, !!(flags.val & BR_FLOOD));
+	if (flags.mask & BR_BCAST_FLOOD)
+		sparx5_pgid_update_mask(port, PGID_BCAST, !!(flags.val & BR_BCAST_FLOOD));
 }
 
 static void sparx5_attr_stp_state_set(struct sparx5_port *port,
@@ -72,6 +88,9 @@ static int sparx5_port_attr_set(struct net_device *dev, const void *ctx,
 	struct sparx5_port *port = netdev_priv(dev);
 
 	switch (attr->id) {
+	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
+		return sparx5_port_attr_pre_bridge_flags(port,
+							 attr->u.brport_flags);
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
 		sparx5_port_attr_bridge_flags(port, attr->u.brport_flags);
 		break;
-- 
2.30.2

