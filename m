Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A971D4CC524
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbiCCS0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235735AbiCCS0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:26:10 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8927B1A58C5;
        Thu,  3 Mar 2022 10:25:21 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DCF612000A;
        Thu,  3 Mar 2022 18:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1646331918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u5GsCepptVoX2JZ38pEAvAndTHAQRn+3mkA9ZcZ09z8=;
        b=pE3kKY2aAAIb0XR6e6tbtfmo6AyXrOq8LvqMx8ItDi6dVB7jisEwYSB0urqnd/lhccmNXT
        wCN7bGsaRvt6xDLp6Iz/UTmPwfV2ZjH7o/veJ4O+8pVcDgSdIl5Yb/FVtPV2waFzMbQmln
        d7bHQjjEMh5eqxO2cQ6SPIWgKuWBJ9z7MPlsMhQML0LkLdVZs+RpODQJal2HlzP6N+MR9o
        +c0GcjMx0dykphRREwXF+qJU9aVh0q1I8SdH2tAf/5Is5CCFVBg6a7ZfZE9X7A3OxPBgsy
        EYtFrwRsoZrzzZc/NR/JbDw07ImNHdEGVIoI24aGJdLEtteeJrrxcJ+fggLiFA==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v3 05/11] net: ieee802154: at86rf230: Assume invalid TRAC if not recognized
Date:   Thu,  3 Mar 2022 19:25:02 +0100
Message-Id: <20220303182508.288136-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220303182508.288136-1-miquel.raynal@bootlin.com>
References: <20220303182508.288136-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TRAC register gives the MAC error codes if any. If the TRAC register
reports a value that is unknown, we should probably assume that it is
invalid.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/at86rf230.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 563031ce76f0..616acfa8cd28 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -694,6 +694,7 @@ at86rf230_tx_trac_check(void *context)
 			break;
 		default:
 			WARN_ONCE(1, "received tx trac status %d\n", trac);
+			lp->trac.invalid++;
 			break;
 		}
 	}
-- 
2.27.0

