Return-Path: <netdev+bounces-6820-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B97971851F
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:38:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE58B1C20E50
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:38:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0A9714AAF;
	Wed, 31 May 2023 14:38:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94ED01C11
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:38:50 +0000 (UTC)
Received: from mta-65-227.siemens.flowmailer.net (mta-65-227.siemens.flowmailer.net [185.136.65.227])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3775BE2
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:38:48 -0700 (PDT)
Received: by mta-65-227.siemens.flowmailer.net with ESMTPSA id 20230531143844c7a89a96d0416faea4
        for <netdev@vger.kernel.org>;
        Wed, 31 May 2023 16:38:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm1;
 d=siemens.com; i=alexander.sverdlin@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc;
 bh=Q5MncjXbUhGj9SPEdiG5OjpwELpZmxsuNDM0CyWnhpo=;
 b=Jet+87efV8bUdoa02xDT4dcyiIkIgPVfZh8m+0Y0+qs4fZ75RPUTbxk1zcXpexpFERIRQx
 LBejygdXaqbtjc9SfsSJg/FgOGaGDCyiBI1Z2RvxH9J9cRfWSkdi8WyER757m36r109J/EUf
 Fq3Iuy99Dh0jkdwahvxNB+hR1Jgic=;
From: "A. Sverdlin" <alexander.sverdlin@siemens.com>
To: netdev@vger.kernel.org
Cc: Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	linux-kernel@vger.kernel.org,
	Egil Hjelmeland <privat@egil-hjelmeland.no>
Subject: [PATCH] net: dsa: lan9303: allow vid != 0 in port_fdb_{add|del} methods
Date: Wed, 31 May 2023 16:38:26 +0200
Message-Id: <20230531143826.477267-1-alexander.sverdlin@siemens.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Flowmailer-Platform: Siemens
Feedback-ID: 519:519-456497:519-21489:flowmailer
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,
	RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

LAN9303 doesn't associate FDB (ALR) entries with VLANs, it has just one
global Address Logic Resolution table [1].

Ignore VID in port_fdb_{add|del} methods, go on with the global table. This
is the same semantics as hellcreek or RZ/N1 implement.

Visible symptoms:
LAN9303_MDIO 5b050000.ethernet-1:00: port 2 failed to delete 00:xx:xx:xx:xx:cf vid 1 from fdb: -2
LAN9303_MDIO 5b050000.ethernet-1:00: port 2 failed to add 00:xx:xx:xx:xx:cf vid 1 to fdb: -95

[1] https://ww1.microchip.com/downloads/en/DeviceDoc/00002308A.pdf

Fixes: 0620427ea0d6 ("net: dsa: lan9303: Add fdb/mdb manipulation")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
---
 drivers/net/dsa/lan9303-core.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index cbe831875347..c0215a8770f4 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1188,8 +1188,6 @@ static int lan9303_port_fdb_add(struct dsa_switch *ds, int port,
 	struct lan9303 *chip = ds->priv;
 
 	dev_dbg(chip->dev, "%s(%d, %pM, %d)\n", __func__, port, addr, vid);
-	if (vid)
-		return -EOPNOTSUPP;
 
 	return lan9303_alr_add_port(chip, addr, port, false);
 }
@@ -1201,8 +1199,6 @@ static int lan9303_port_fdb_del(struct dsa_switch *ds, int port,
 	struct lan9303 *chip = ds->priv;
 
 	dev_dbg(chip->dev, "%s(%d, %pM, %d)\n", __func__, port, addr, vid);
-	if (vid)
-		return -EOPNOTSUPP;
 	lan9303_alr_del_port(chip, addr, port);
 
 	return 0;
-- 
2.40.1


