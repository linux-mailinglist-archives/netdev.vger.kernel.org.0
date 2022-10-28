Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437CD610D0B
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 11:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiJ1JYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 05:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJ1JYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 05:24:06 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A56B1C7135;
        Fri, 28 Oct 2022 02:23:51 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B14E4100006;
        Fri, 28 Oct 2022 09:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666949029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N0LdsNh6jfmS3zzQ/1xHfQe2PU60JuVsRUd6fVEbmxM=;
        b=D0y+uY9CbRgJcHkbTj4anF+Q3fpTaD1HgKcDQBeSwkB2QpkCnKJdxmTwn/aPVfzqSOp0fA
        GaKLWZmlNl3NA/sAgOWwCZcMLvCeGvmGWB8KicS7ABa9Bh3NQRNeuf30uCKPPfgue61JZY
        MmhuiPHYjxEHJWiNPWWWOUoKCAR8Rvd4wkxQ2lynjAszgraXCjXjQe8QSyuRmu0pp+QHcD
        yK82vRThI3NONBYV/s3x+7YVvm1e0MSjYZMGQzUMp12frGfWwjQv/Jdb4WXKGh/P4Wk9qi
        Ymu0Ob9EMIapvE9wI9NQo+/LYxkSJKfpBuDlDyKEcn7lpYSPRxiDle+NB9wGrw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Robert Marko <robert.marko@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5/5] net: mvpp2: Consider NVMEM cells as possible MAC address source
Date:   Fri, 28 Oct 2022 11:23:37 +0200
Message-Id: <20221028092337.822840-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221028092337.822840-1-miquel.raynal@bootlin.com>
References: <20221028092337.822840-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Hello, I suppose my change is safe but I don't want to break existing
setups so a review on this would be welcome!

 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index eb0fb8128096..7c8c323f4411 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6104,6 +6104,12 @@ static void mvpp2_port_copy_mac_addr(struct net_device *dev, struct mvpp2 *priv,
 		}
 	}
 
+	if (!of_get_mac_address(to_of_node(fwnode), hw_mac_addr)) {
+		*mac_from = "nvmem cell";
+		eth_hw_addr_set(dev, hw_mac_addr);
+		return;
+	}
+
 	*mac_from = "random";
 	eth_hw_addr_random(dev);
 }
-- 
2.34.1

