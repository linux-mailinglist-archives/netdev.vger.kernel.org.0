Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5A65635D3
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbiGAOhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbiGAOgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:36:09 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CB570E7B;
        Fri,  1 Jul 2022 07:31:35 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2DCF7FF80F;
        Fri,  1 Jul 2022 14:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656685894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ad0eLL0zxK/CuoU7ZK3TMgFEUpOTB87/kRNCjMNjmtQ=;
        b=N8cPeZVRacVUN4V53+6gDLGfg3AMNPsKehx+BMn7g2ZmVNpdFExbcXN9xS5vNaWHgqEHCW
        FInxYoNlrGV1LfLRL3T64He7M258+H0jVOQQKtEu1/gDwZ2iRrbYHEDackb2MvOeoymKXY
        ib/+mb9DD7ddESUA7GVIvYrno7kTGNac/SnHXqCWFk7Hecb6/RCH0JIIhi/qbCuK2mDbMr
        fulJpmpb7J+f3alLZyuVrgzHqDWdjFeZ1veMS3nnNyLR8KrO2T97mSIsqWRNBZBrir75Jg
        LsoLSbzCl58r+nkk7Ehr9FhltjCgR1rHZtmsZA2gMh7NbmkV/6smbFS41xy9hw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 20/20] ieee802154: hwsim: Allow devices to be coordinators
Date:   Fri,  1 Jul 2022 16:30:52 +0200
Message-Id: <20220701143052.1267509-21-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to be able to create coordinator interfaces, we need the
drivers to advertize that they support this type of interface. Fill in
the right bit in the hwsim capabilities to allow the creation of these
coordinator interfaces.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index a5b9fc2fb64c..a678ede07219 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -776,6 +776,8 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 	/* 950 MHz GFSK 802.15.4d-2009 */
 	hw->phy->supported.channels[6] |= 0x3ffc00;
 
+	hw->phy->supported.iftypes |= BIT(NL802154_IFTYPE_COORD);
+
 	ieee802154_random_extended_addr(&hw->phy->perm_extended_addr);
 
 	/* hwsim phy channel 13 as default */
-- 
2.34.1

