Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A4B6892DB
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbjBCI4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjBCI4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:56:07 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041B170D63
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 00:56:03 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id hn2-20020a05600ca38200b003dc5cb96d46so5486970wmb.4
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 00:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=c5BVg8U3tuiRfrdtUHAvCm4031GkNX9r1RMNE3b5I6o=;
        b=Io2+w6NOfchIKRP/Nz4owEox6IKqIG/ARF34p/6WCAAwhOQqg+zzaZo91UDnVVl5tU
         SIFco2hXvueutUWrpT7c6OdkZUROu5iph6dABi9LUHb8u4dD6SYHHWL6Vr8zc3bxiIS8
         RP1yTLLB4NujVGD/QbxI3YZA4FADBhO4Hxb6TssFc5KkpotMDKpOrE8vCi4YwyVWrXc1
         80za4Kz/svioSbc1omVmv8KM9tnRYVQlLyr9z19qziNXm3bLwksKsQvGDPjJvLdT3PXn
         JNIoIW0CMrVdSGamH36AdIVfHaNMcM2KHKeROD0dhwp/WjrkYP+yRYIIfJRWPggSfFTW
         AoRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c5BVg8U3tuiRfrdtUHAvCm4031GkNX9r1RMNE3b5I6o=;
        b=ov11pqGQv5GHEU7vKPNVkOWIdq1Bbm3LBpQINQdo97gRcjNsQ74XZ9yRTNrVtXWJx5
         B7cg9zG4vX1yBrCar3Iwd2WLbBpQBRcCe61gUARHkpRxGFu4Jw3ShUZ+JTMRda/CwSxO
         be8njEsoE3Tt+fP4QxpcYS71k95pVkHVuTEDZX+oO1y79o6pnpXp5QRvUr/Pnp4DcWZ6
         xppUsOVk1dfYyIWUW28X0TTqTjdysLHFZzoIQ65LLYeOgwKrLgUMVleMR9Vqsd9THTdl
         CbeKUlrQydo3anVLdlGHQiCuKsBQP4UONOjUP6xfaueTG1FNpQvKHPxUaIGAWv2/niC5
         C9kA==
X-Gm-Message-State: AO0yUKUorBrnNw0pG1d+KIUI+yzj2I531kXwolO5UVhMJDSksj5T+NEP
        kdscJrsXx6bPeQIKpGqsjv0=
X-Google-Smtp-Source: AK7set+h7qVBJm6pILWiaA8HinkVmSkOoQBrQEFSY+BalOsEWAgH9B6fsYeSf/TdOQ1jWsfOnj4eWg==
X-Received: by 2002:a05:600c:3514:b0:3df:ead3:c6fc with SMTP id h20-20020a05600c351400b003dfead3c6fcmr738268wmq.17.1675414561465;
        Fri, 03 Feb 2023 00:56:01 -0800 (PST)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id bg35-20020a05600c3ca300b003dc4fd6e624sm2267865wmb.19.2023.02.03.00.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 00:56:00 -0800 (PST)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Richard Cochran <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org
Subject: [PATCH net] net: microchip: sparx5: fix PTP init/deinit not checking all ports
Date:   Fri,  3 Feb 2023 09:55:57 +0100
Message-Id: <20230203085557.3785002-1-casper.casan@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check all ports instead of just port_count ports. PTP init was only
checking ports 0 to port_count. If the hardware ports are not mapped
starting from 0 then they would be missed, e.g. if only ports 20-30 were
mapped it would attempt to init ports 0-10, resulting in NULL pointers
when attempting to timestamp. Now it will init all mapped ports.

Fixes: 70dfe25cd866 ("net: sparx5: Update extraction/injection for timestamping")
Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
index 0ed1ea7727c5..69e76634f9aa 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
@@ -633,7 +633,7 @@ int sparx5_ptp_init(struct sparx5 *sparx5)
 	/* Enable master counters */
 	spx5_wr(PTP_PTP_DOM_CFG_PTP_ENA_SET(0x7), sparx5, PTP_PTP_DOM_CFG);
 
-	for (i = 0; i < sparx5->port_count; i++) {
+	for (i = 0; i < SPX5_PORTS; i++) {
 		port = sparx5->ports[i];
 		if (!port)
 			continue;
@@ -649,7 +649,7 @@ void sparx5_ptp_deinit(struct sparx5 *sparx5)
 	struct sparx5_port *port;
 	int i;
 
-	for (i = 0; i < sparx5->port_count; i++) {
+	for (i = 0; i < SPX5_PORTS; i++) {
 		port = sparx5->ports[i];
 		if (!port)
 			continue;
-- 
2.34.1

