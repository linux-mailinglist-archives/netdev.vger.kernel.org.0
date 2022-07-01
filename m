Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491E05635BF
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiGAOga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbiGAOfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:35:43 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB8340E43;
        Fri,  1 Jul 2022 07:31:22 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D7B81FF817;
        Fri,  1 Jul 2022 14:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656685881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fsJtIZ9CnqfwxgZ1RajapMDjIVAhlGKcRhjs05Cdx0Q=;
        b=ixpuR/3LjpY9eaj4JaYCD02zCHaFWn39oWqQwZjupm1G9Sjl9rKIglRJ94K4fJ6vwqGwiM
        9P8nzcq0bluLouP5NY9GQOEiroHcPiCH1+0LcQ1vcWL2jsNBPyehIIcwMPCwkkukoDoGtl
        hXMLPDX7iFOViQRX2io7iSTwA5G1YHWGz/Kz4QQF2zFcGO8MW5xUpSDjE8AKnd1V9MDxXb
        Iwa7k+eFMAjiIJgVPxT5NawGRX1JbTGD9Tt8eitKDqHwIcf0Oazi1DOKo+wnu4M4z5kZKb
        h/jxKjWZ7ee0hrYoRMHaJCsPnHDTZeCAW4JhXtBoV9GnnaSiXkEZcLgVH7JRxQ==
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
Subject: [PATCH wpan-next 13/20] net: ieee802154: Add support for user active scan requests
Date:   Fri,  1 Jul 2022 16:30:45 +0200
Message-Id: <20220701143052.1267509-14-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case a passive scan could not discover any PAN, a device may decide
to perform an active scan to force coordinators to send a BEACON
"immediately". Allow users to request to perform an active scan.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/ieee802154/nl802154.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index ff8069415e67..9505e17e7ce7 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1413,6 +1413,7 @@ static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 
 	type = nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE]);
 	switch (type) {
+	case NL802154_SCAN_ACTIVE:
 	case NL802154_SCAN_PASSIVE:
 		request->type = type;
 		break;
-- 
2.34.1

