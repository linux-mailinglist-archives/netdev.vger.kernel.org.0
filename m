Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58614C4204
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 11:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237598AbiBYKPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 05:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiBYKPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 05:15:52 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6D01C2DAD
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 02:15:19 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id b11so8490756lfb.12
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 02:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:organization:mime-version
         :content-disposition;
        bh=maCmEARgfbOax79V/LLsxxN+Ff0FLztWL/cvolVbzOI=;
        b=ApgmRMeusYfVtcyqfLOgQMIRYhegtqt2yUgB/ux/zSDRtdYw5sLTvzF/m4Ps4D+9jg
         6U23VSzJkXkyO5RVn9Nw+Luton6gD3+BI/NxySuxTQC0FA+EzobrF2LRzbEnGr94nUIO
         bNb7myqbLFnvJj4RGUW5OHYLg9/EVvDo9in92ThdSMAq/czVm2uXiwkdPcLJgq3GMS54
         cq3D7gDLHrEY/+F0vGbU7eW7iNQE10K26k669OOUv2eWrjFtf3aQr4fifwogR0o2l/oj
         OcrVWvUvzz0KdaGK4HOn3j69FvLTUW0adAo50WFvqQivF4fjHiXuSgw9g2uC+kN/3eSc
         NXXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:organization
         :mime-version:content-disposition;
        bh=maCmEARgfbOax79V/LLsxxN+Ff0FLztWL/cvolVbzOI=;
        b=Mlb4WH8BQI8qejfbPVDZSG4n76g0AsLg6cq8Po7AnZwcdHe4HyB/FCfg67fCL7Tb28
         JA9HJpSLs6jm5iWJX2PwPVn2HMEXpr2Kt+Z9zvgbC6toGW01RDp2AmBAQUEEzl+p6BxF
         ZhZX25HkkZl53xRpAn+EbftuE1LLMBNU5Xx5L2KqbD33ENSCxdIhMfSOScE3od4mEaKB
         u4AeMHHG/m6Ibn1MOj8KK1pgdl9XN7lnILFf6gOnuhUV7F9pZ4YSLtSeWS7f4HCUqem0
         O+wUP/JoZmQDYtkVsdihPpxt3NylZ2kScSjed9fE6nvUYo2e2jbMr4eWEWh15hLW46jy
         KYCg==
X-Gm-Message-State: AOAM530n/Qa47aXECoKzw4DkOGT0Z3IJO5srHP5HuGo0CDouE4rLGWvO
        MQFet9fOCiYiT1rebFQhsK0=
X-Google-Smtp-Source: ABdhPJynoSJgFa5aZWYR0F0/XrY5JKfJue59hLvvyfCKWkalYZE6Kmp8/wryBmClHJN32RXAEOPGFw==
X-Received: by 2002:a05:6512:10d0:b0:42a:543f:7d26 with SMTP id k16-20020a05651210d000b0042a543f7d26mr4688720lfg.676.1645784117392;
        Fri, 25 Feb 2022 02:15:17 -0800 (PST)
Received: from wse-c0155 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id d6-20020ac25446000000b00443f15de8basm165934lfn.43.2022.02.25.02.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 02:15:17 -0800 (PST)
Date:   Fri, 25 Feb 2022 11:15:16 +0100
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] net: sparx5: Fix add vlan when invalid operation
Message-ID: <20220225101516.mhafzkt3mlgmdafc@wse-c0155>
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

Check if operation is valid before changing any
settings in hardware. Otherwise it results in
changes being made despite it not being a valid
operation.

Fixes: 78eab33bb68b ("net: sparx5: add vlan support")

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
Maybe not obvious from the code changes, but the code is moved down
a couple lines to after check for if it tries to add a second untagged
VLAN to a port. Multiple untagged VLANs on a port is not allowed, but
the changes were made to the hardware anyways.

 .../ethernet/microchip/sparx5/sparx5_vlan.c   | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
index 4ce490a25f33..8e56ffa1c4f7 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
@@ -58,16 +58,6 @@ int sparx5_vlan_vid_add(struct sparx5_port *port, u16 vid, bool pvid,
 	struct sparx5 *sparx5 = port->sparx5;
 	int ret;
 
-	/* Make the port a member of the VLAN */
-	set_bit(port->portno, sparx5->vlan_mask[vid]);
-	ret = sparx5_vlant_set_mask(sparx5, vid);
-	if (ret)
-		return ret;
-
-	/* Default ingress vlan classification */
-	if (pvid)
-		port->pvid = vid;
-
 	/* Untagged egress vlan classification */
 	if (untagged && port->vid != vid) {
 		if (port->vid) {
@@ -79,6 +69,16 @@ int sparx5_vlan_vid_add(struct sparx5_port *port, u16 vid, bool pvid,
 		port->vid = vid;
 	}
 
+	/* Make the port a member of the VLAN */
+	set_bit(port->portno, sparx5->vlan_mask[vid]);
+	ret = sparx5_vlant_set_mask(sparx5, vid);
+	if (ret)
+		return ret;
+
+	/* Default ingress vlan classification */
+	if (pvid)
+		port->pvid = vid;
+
 	sparx5_vlan_port_apply(sparx5, port);
 
 	return 0;
-- 
2.30.2

