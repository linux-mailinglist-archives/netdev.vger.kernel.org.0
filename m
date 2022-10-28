Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6844B610CFE
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 11:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiJ1JXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 05:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiJ1JXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 05:23:44 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883D11C5A44;
        Fri, 28 Oct 2022 02:23:41 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C85B6100002;
        Fri, 28 Oct 2022 09:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666949020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Jww1jZHfX37j9j9H8HluQYHHsI/avrLn3u/se6AG/Gc=;
        b=oejV7wmBrFRUuBlrdDVx4138UjHAHRkm/brCmKzw+/i++jYWUv0oaU3C6oQr4l49+Q9+gA
        RGwqml+sRlTfQ5CFPb75SNz+tITOGVfSknavoJ8BHUHAEynoYIiFfXnBh2woug+Q4R/Fpw
        RvQCVDnr2OReCrT8OnBqMVaXuqLu8d+R1BfJa1EfhY3xW4eRUg83+X4bx/rTlvr+HZttMr
        /R0ndw844/qpgphcLtJpdnycVJ3fb4TemK2qYFkbY4L8QZ24UdU77JoldelLwfS3eNI7oF
        qx6q+rLhRx0atS7QJBr74ATmcJoAOYFH7tLsiRwG5hSvrX2pdLjkV9xFhQpclA==
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
Subject: [PATCH 0/5] ONIE tlv nvmem layout support
Date:   Fri, 28 Oct 2022 11:23:32 +0200
Message-Id: <20221028092337.822840-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Here is a series bringing support for an NVMEM layout parser. The table
that will get processed has been standardized by the ONIE project [1]
and its content is highly dependent on the manufacturer choices. There
is a dedicated process to read it, but in no case we can define the
nvmem cells location/length statically in the DT like other NVMEM
cells. Instead, we need what the "layout" abstraction proposed here [2]
brings: a dynamic way to find and export NVMEM cells. So this series is
actually dependent on [2] and cannot be merged without it.

The mvpp2 patch is an example of use which was useful to me during my
test runs, so I figured out it might make sense to upstream it. I am not
100% convinced this is the right way so reviews there are welcome.

[1] https://opencomputeproject.github.io/onie/design-spec/hw_requirements.html
[2] https://lore.kernel.org/linux-arm-kernel/20220921115813.208ff789@xps-13/T/

Cheers,
Miquèl

Miquel Raynal (5):
  dt-bindings: vendor-prefixes: Add ONIE
  dt-bindings: nvmem: add YAML schema for the ONIE tlv layout
  nvmem: layouts: Add ONIE tlv layout driver
  MAINTAINERS: Add myself as ONIE tlv NVMEM layout maintainer
  net: mvpp2: Consider NVMEM cells as possible MAC address source

 .../nvmem/layouts/onie,tlv-layout.yaml        |  96 +++++++
 .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
 MAINTAINERS                                   |   6 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   6 +
 drivers/nvmem/layouts/Kconfig                 |   9 +
 drivers/nvmem/layouts/Makefile                |   1 +
 drivers/nvmem/layouts/onie-tlv.c              | 240 ++++++++++++++++++
 7 files changed, 360 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/nvmem/layouts/onie,tlv-layout.yaml
 create mode 100644 drivers/nvmem/layouts/onie-tlv.c

-- 
2.34.1

