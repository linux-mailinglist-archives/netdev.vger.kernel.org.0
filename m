Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADEF6C7CFE
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 12:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbjCXLGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 07:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCXLGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 07:06:10 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65692471A;
        Fri, 24 Mar 2023 04:06:08 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3F3CB1C0004;
        Fri, 24 Mar 2023 11:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1679655966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MUwKIUMVcH6NEMxhxlTDFnrPGXUpI+fLMcYc8IqnvIA=;
        b=PJw/zhFUKmHkSlgVpj6VFjXRe5jVPHC06lgHTKGogCFk/IKedOv0oYzHNsMzbXf+bzTKw8
        dO+VQWMXkZftOPkd9RCsap9wcfdvfItsQmvlDKMxYW9pRxjelOcbY21+5toMqehi5LOp7M
        hMAYDIulSIRuoRt62UReAnwaq26zbGRT1fElwVA62gsJumk1/v9HpyZRKMqHg4Gqa/221t
        X6Y5yAkn56C42x5lmmwSOM+gchLbziUFuaGYMrZHjhm5v9R/6rC8ZuyQ3QuevWaMFV9ITN
        15jwWGMF3TerNZWl0R+DrDrbPr5stoBHb8cUDk7tMU8YEttellxGIueCFD/8Xg==
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
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 2/2] ieee802154: ca8210: Flag the driver as being limited
Date:   Fri, 24 Mar 2023 12:05:58 +0100
Message-Id: <20230324110558.90707-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324110558.90707-1-miquel.raynal@bootlin.com>
References: <20230324110558.90707-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a hardMAC device wired to Linux 802154 softMAC
implementation. It is a bit limited in the sense that it cannot handle
anything else that datagrams. Let's flag it like this to prevent using
unsupported features such as scan/beacons handling.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/ca8210.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 450b16ad40a4..bd5eeccc2fd2 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2943,7 +2943,8 @@ static void ca8210_hw_setup(struct ieee802154_hw *ca8210_hw)
 	ca8210_hw->phy->flags =
 		WPAN_PHY_FLAG_TXPOWER |
 		WPAN_PHY_FLAG_CCA_ED_LEVEL |
-		WPAN_PHY_FLAG_CCA_MODE;
+		WPAN_PHY_FLAG_CCA_MODE |
+		WPAN_PHY_FLAG_DATAGRAMS_ONLY;
 }
 
 /**
-- 
2.34.1

