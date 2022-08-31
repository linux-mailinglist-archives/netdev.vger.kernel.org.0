Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F94F5A7C1B
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 13:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiHaLTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 07:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiHaLTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 07:19:06 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38D9CC314;
        Wed, 31 Aug 2022 04:19:04 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id A86F62010;
        Wed, 31 Aug 2022 13:19:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661944741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X7mCDy9QYi5qoq+ya8RweTlaPGnN3dnHkWi7lO6NuVg=;
        b=riWaNiacezQiSPxBD4dMmy8S0z9MNWArpj+CBWmynnbQCHyW+AGCq5gLggaqSQleGCedoW
        IdIpQHpSTnX3jZl6olZvcLLC7DMTZPAWOdZB99paYGglXZdPpjM+MRQI2okWBV/AG9oraX
        NT3N17ags2M7PvPtjgJLSl+2e9lilJk5aOFUQrtrSQooZuxmGfYytRbUnCTNurIJ0mwEOg
        IwzHTvCJ2zDs4/Z9TtUeb+rGE/Jyjlenrojnkwq+Ie8Cmn53B5cNOsqRLbzuLUiwRdKu90
        Gdvq8DTkQrYXXDqoTzpWXzKLT52wI4DBiEsNcYbZi21liT/P1O1ZM1R0Cc6e5Q==
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     UNGLinuxDriver@microchip.com,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 2/2] net: lan966x: make reset optional
Date:   Wed, 31 Aug 2022 13:18:55 +0200
Message-Id: <20220831111855.1749646-3-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220831111855.1749646-1-michael@walle.cc>
References: <20220831111855.1749646-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no dedicated reset for just the switch core. The reset which
is used up until now, is more of a global reset, resetting almost the
whole SoC and cause spurious errors by doing so. Make it possible to
handle the reset elsewhere and make the reset optional.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 2ad078608c45..e2c77f954a3d 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -971,7 +971,8 @@ static int lan966x_reset_switch(struct lan966x *lan966x)
 	int val = 0;
 	int ret;
 
-	switch_reset = devm_reset_control_get_shared(lan966x->dev, "switch");
+	switch_reset = devm_reset_control_get_optional_shared(lan966x->dev,
+							      "switch");
 	if (IS_ERR(switch_reset))
 		return dev_err_probe(lan966x->dev, PTR_ERR(switch_reset),
 				     "Could not obtain switch reset");
-- 
2.30.2

