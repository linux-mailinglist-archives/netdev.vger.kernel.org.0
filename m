Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD076408FA
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 16:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbiLBPMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 10:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiLBPMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 10:12:12 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1130398546;
        Fri,  2 Dec 2022 07:12:11 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 33E8B75;
        Fri,  2 Dec 2022 16:12:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1669993930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=AoR22NNNAndyCaq3UZNGcaHIXGT1dDHwyAlvzL5H/bs=;
        b=kzb8zWgJS+2nK1RnOmo5Iezx1yWv9lI/k4YZQQhbkCdZMxx1LcUod87b+Hrg+GtR1KJBpW
        5vly+jGlZ6tfKumop6UniShEtsQRgCYkNEqGnDiNWLi/nsqdTKhy9yfUy86cioIDtJu1vI
        BZXtgZxdh8jqtiymqvNZyzwWe+Z0UY+LMntk3lGC5jVgddBTELnRmh5D6aOB74Q1DocDSc
        d6JVi0lAdsqAQttIEvfRk+YsA+p0jlrXr4gpaE/QTX4lcBaaICmmsAq2gz/3/7I3qvV+Uf
        wmXkbOdbUizgfsApxMObFgrO0UZu9nP8vpb5J4M2Magk+5fbX26jqKLg3DDgYg==
From:   Michael Walle <michael@walle.cc>
To:     Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v1 0/4] net: phy: mxl-gpy: broken interrupt fixes
Date:   Fri,  2 Dec 2022 16:12:00 +0100
Message-Id: <20221202151204.3318592-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GPY215 has a broken interrupt pin. This patch series tries to
workaround that and because in general that is not possible, disables the
interrupts by default and falls back to polling mode. There is an opt-in
via the devicetree.

net vs net-next: I'm not sure. No one seems to have noticed it so far.
My board I care about has no support for older kernel. Apart from that,
the first patch might be for net. The last one would need a new device
tree property, so it might only apply for net-next? Also it will disable
interrupts by default now.
Let me know what you think. I can send the first patch independently with a
Fixes tag and resend the last ones after the merge window. (The last one
depends on the first).

Btw. I just noticed that this series won't apply cleanly, because it
references patch context changed by
https://lore.kernel.org/netdev/20221202144900.3298204-1-michael@walle.cc/
:(

Michael Walle (4):
  net: phy: mxl-gpy: add MDINT workaround
  dt-bindings: vendor-prefixes: add MaxLinear
  dt-bindings: net: phy: add MaxLinear GPY2xx bindings
  net: phy: mxl-gpy: disable interrupts on GPY215 by default

 .../bindings/net/maxlinear,gpy2xx.yaml        | 47 ++++++++++
 .../devicetree/bindings/vendor-prefixes.yaml  |  2 +
 drivers/net/phy/mxl-gpy.c                     | 88 +++++++++++++++++++
 3 files changed, 137 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml

-- 
2.30.2

