Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBFC637761
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiKXLQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiKXLQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:16:38 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19345146F8D;
        Thu, 24 Nov 2022 03:16:21 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BB3351C0019;
        Thu, 24 Nov 2022 11:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669288580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s42uM41w9ysmCNZE9IaonrxU6NJPatbC7hYnvHselLY=;
        b=HCXhEKvsJrrzmpZ6OKhK9SABZxwycYvZjnfneAz5D7wWn4u74NVgS6KdAXFKxJbpDp2/z7
        r65VnNGRgNSxE5YVkr8TvbkzUBcoHyLc0+xtGQGfHNIE8INTy3fKN+7VDEBb8Ugmf0OaHY
        /NFcd5FDP4v8zxfCoMxMaOEkWfs2E6PUUUUQseKALeXpwSq1JjYnFN1uy3Qg+OogXpJH7w
        8lIJsNRNci3dc11gMMqiitnnrVp4V43sRQTMi41gkAnAAy6voQeUvLOafpB2Fm4QPaFSn5
        yeRUm/AhHBjeBMx2vY9bV1PHXtlYId5m0LZqQoczoTIRPQnTeKg+csxB3042uQ==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org, Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Marcin Wojtas <mw@semihalf.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH net-next v2 7/7] net: mvpp2: Consider NVMEM cells as possible MAC address source
Date:   Thu, 24 Nov 2022 12:15:56 +0100
Message-Id: <20221124111556.264647-8-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124111556.264647-1-miquel.raynal@bootlin.com>
References: <20221124111556.264647-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ONIE standard describes the organization of tlv (type-length-value)
arrays commonly stored within NVMEM devices on common networking
hardware.

Several drivers already make use of NVMEM cells for purposes like
retrieving a default MAC address provided by the manufacturer.

What made ONIE tables unusable so far was the fact that the information
where "dynamically" located within the table depending on the
manufacturer wishes, while Linux NVMEM support only allowed statically
defined NVMEM cells. Fortunately, this limitation was eventually tackled
with the introduction of discoverable cells through the use of NVMEM
layouts, making it possible to extract and consistently use the content
of tables like ONIE's tlv arrays.

Parsing this table at runtime in order to get various information is now
possible. So, because many Marvell networking switches already follow
this standard, let's consider using NVMEM cells as a new valid source of
information when looking for a base MAC address, which is one of the
primary uses of these new fields. Indeed, manufacturers following the
ONIE standard are encouraged to provide a default MAC address there, so
let's eventually use it if no other MAC address has been found using the
existing methods.

Link: https://opencomputeproject.github.io/onie/design-spec/hw_requirements.html
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index eb0fb8128096..12f0b5ad8cee 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6104,6 +6104,13 @@ static void mvpp2_port_copy_mac_addr(struct net_device *dev, struct mvpp2 *priv,
 		}
 	}
 
+	/* Only valid on OF enabled platforms */
+	if (!of_get_mac_address_nvmem(to_of_node(fwnode), fw_mac_addr)) {
+		*mac_from = "nvmem cell";
+		eth_hw_addr_set(dev, fw_mac_addr);
+		return;
+	}
+
 	*mac_from = "random";
 	eth_hw_addr_random(dev);
 }
-- 
2.34.1

