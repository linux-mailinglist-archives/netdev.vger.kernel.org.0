Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6454BFAFA
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 15:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbiBVOfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 09:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiBVOfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 09:35:54 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074F615D3AF
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 06:35:29 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id d23so25143059lfv.13
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 06:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:organization:mime-version
         :content-disposition;
        bh=zNK+BBd+9xLxBCeZ7XYmIY2VC7pziZMi3zRjDynKCwI=;
        b=jcFUtaK4e3cgMEuNHYKtNYJ8hvAbADYMSvPXUgQK4WYz17BUABTwyMl5H/ub9+QX5l
         H+vpOFp5bi0RErrJdvvErPmLqIuoW7aAqzGfsF71IOjUMLmCQYBoUDc9HWUr+QsU+dR1
         vrVaqtqssZPtkFVTePIwIc9o9aSZmfui0jO9UTwt3hvanAE283dYsNwVfIdkKTfRD8XC
         /85+aeOQndORrG2kCEZydyxsqSJecSj10Qkbav0A+wVoVwVIRVFe0vbm3gjyNBu97xKq
         J1O9M57Og7p95wDKB60uPPsPSU1xW9lAv9dvWtTGOVrc0oM1+F+cq1Gx1bNgcF936A2A
         FD1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:organization
         :mime-version:content-disposition;
        bh=zNK+BBd+9xLxBCeZ7XYmIY2VC7pziZMi3zRjDynKCwI=;
        b=weLOVP/8ULNRu2dqUl1Ro8f3p1RmcfKuqqvUag8I3LxlcGl2c0ze7ZlLCbnqsXgv9t
         yMygKKUTUGuhkINAdhF6GC1aUeiwqrt+xaZE/1WFN2lOzplA16xOD5QZnTFYbqVbI2WJ
         GxwTSEYWaPHmyLUBBKEO2ZXs3+zB+3WJ74aIyyG6pizRsh3AOHAEu0cQC0QdxH7KOQbW
         hPFMQorQO2haJU40NyRgkXy6JDNAaKoc9xAL9lfiCjuoOA0OgFvj0wp/oJXGu8SrZ6Gs
         zak22Jk5YXlxopU/X6gZf24uXD4pnD4wmHtzRnxyUsQAjJDHuxUeAXj8coEv8hxBJJE6
         f8Gw==
X-Gm-Message-State: AOAM530kCxN3AZzmrfjbg/3zJE4DsSXg0jC38DR+p0G7nbOTNuaye45A
        PlC7LZ3YXYSWWssQ/fNukbw=
X-Google-Smtp-Source: ABdhPJxHXvCQvRjiyFPVXTN+JifddVgV0fedum9lCihsIrI4PcilntXzb8+hVnwVQjZ/pvOx8s4VWg==
X-Received: by 2002:ac2:508a:0:b0:443:169a:b27 with SMTP id f10-20020ac2508a000000b00443169a0b27mr17364743lfm.257.1645540527011;
        Tue, 22 Feb 2022 06:35:27 -0800 (PST)
Received: from wse-c0155 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id m17sm1396575lfr.124.2022.02.22.06.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 06:35:26 -0800 (PST)
Date:   Tue, 22 Feb 2022 15:35:25 +0100
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2] net: sparx5: Support offloading of bridge port
 flooding flags
Message-ID: <20220222143525.ubtovkknjxfiflij@wse-c0155>
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
---
Since Protonmail apparently caused issues with certain email clients
I have now switched to using gmail. Hopefully, there will be no issues
this time.

Changes in v2:
 - Added SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS callback

 .../microchip/sparx5/sparx5_switchdev.c       | 21 ++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 649ca609884a..dc79791201d8 100644
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

