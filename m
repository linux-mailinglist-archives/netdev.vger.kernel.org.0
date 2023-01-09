Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311E5662596
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 13:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbjAIMaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 07:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237265AbjAIMaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 07:30:23 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726F01BCBF;
        Mon,  9 Jan 2023 04:30:22 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 3AD5A38;
        Mon,  9 Jan 2023 13:30:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673267420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=upyrZdolmsIaz/3ipKAYE7vsFiNeP/xhZA94dw1O1dc=;
        b=aCz1+DyWw+ecXR5EeHHM/sgINUpWBxrv00H8HNBpDuTdDOlVacW6yFGFgxmc6pWpWLFfd8
        dRSyZDuafeafjh0GCf1ui2ctG2jtJhSHenSeo5ip4wVkrSp9SNEE0g/yT5Gm0veqa8xB2K
        lGZkRwXtgPYr2oNBIVVFh03+hwh0Vq+VAoykwk2Da2OVWfKNZFiMxtL6lBUPiaHJEEQUOK
        J4Q5Xp1aKyoqHzEIi6zxjjQVo+iZxglZU644X7HZtLwxxCl9bDLW1EMBK8GVEp5OREEwVz
        MJd7Z/NyvqQax2/mjqyTDMmx1qZk7L+xYV6EXMIYAwhlAKVtpRmXBUy/lgu/LA==
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v3 0/4] net: phy: mxl-gpy: broken interrupt fixes
Date:   Mon,  9 Jan 2023 13:30:09 +0100
Message-Id: <20230109123013.3094144-1-michael@walle.cc>
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

v3:
 - move phy_device::dev_flags after the struct phy_device definition.
   also add a comment. Thanks Russell.
 - add a rationale for the new devicetree property in the commit
   message

v2:
 - new handling of how to disable the interrupts

Michael Walle (4):
  dt-bindings: vendor-prefixes: add MaxLinear
  dt-bindings: net: phy: add MaxLinear GPY2xx bindings
  net: phy: allow a phy to opt-out of interrupt handling
  net: phy: mxl-gpy: disable interrupts on GPY215 by default

 .../bindings/net/maxlinear,gpy2xx.yaml        | 47 +++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.yaml  |  2 +
 drivers/net/phy/mxl-gpy.c                     |  5 ++
 drivers/net/phy/phy_device.c                  |  7 +++
 include/linux/phy.h                           |  3 ++
 5 files changed, 64 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml

-- 
2.30.2

