Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946EC5A1B6A
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244009AbiHYVov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbiHYVom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:44:42 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAF0C22A1;
        Thu, 25 Aug 2022 14:44:39 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id A48467F2D;
        Thu, 25 Aug 2022 23:44:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661463876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3M/JEtjOWHXcAAVISD2wWeYzWC5769Xb3W2JMAix6aw=;
        b=EMYs8YloD0YG9HprcuieuNQJQ1NTu5wI0/7jZYVFyDVrsE/g5X/r1iCaH33yCCT0XIywNf
        TzZpiXAfnXr+nAlfHYKbXxV/4qGvz5ChdIKqNVxqwg8G32XmigPolWF4yI6pKjWcR0K+iP
        Frl2YK5gxW/H4elSZ9Ysp7Xim1feXqXEYuQlwA90VRkJXrA6kJ7Ezg1I9PnqlFPWuwYAKI
        zlEcUkC9wYqXIrEP7iXyxPKMlTUI6owAS8nVoEiazFfp9V3djTcn3ZFHLgcvakE3eskORk
        wLrB2eMkE81vD4hEEaL+MFcqoixh6S2qgk6G3Ppih8/QrIXw0HQcIRSDSwzVow==
From:   Michael Walle <michael@walle.cc>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH v1 00/14] nvmem: core: introduce NVMEM layouts
Date:   Thu, 25 Aug 2022 23:44:09 +0200
Message-Id: <20220825214423.903672-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is now the third attempt to fetch the MAC addresses from the VPD
for the Kontron sl28 boards. Previous discussions can be found here:
https://lore.kernel.org/lkml/20211228142549.1275412-1-michael@walle.cc/


NVMEM cells are typically added by board code or by the devicetree. But
as the cells get more complex, there is (valid) push back from the
devicetree maintainers to not put that handling in the devicetree.

Therefore, introduce NVMEM layouts. They operate on the NVMEM device and
can add cells during runtime. That way it is possible to add complex
cells than it is possible right now with the offset/length/bits
description in the device tree. For example, you can have post processing
for individual cells (think of endian swapping, or ethernet offset
handling). You can also have cells which have no static offset, like the
ones in an u-boot environment. The last patches will convert the current
u-boot environment driver to a NVMEM layout and lifting the restriction
that it only works with mtd devices. But as it will change the required
compatible strings, it is marked as RFC for now. It also needs to have
its device tree schema update which is left out here.

For now, the layouts are selected by a specifc compatible string in a
device tree. E.g. the VPD on the kontron sl28 do (within a SPI flash node):
  compatible = "kontron,sl28-vpd", "user-otp";
or if you'd use the u-boot environment (within an MTD patition):
  compatible = "u-boot,env", "nvmem";

The "user-otp" (or "nvmem") will lead to a NVMEM device, the
"kontron,sl28-vpd" (or "u-boot,env") will then apply the specific layout
on top of the NVMEM device.

NVMEM layouts as modules?
While possible in principle, it doesn't make any sense because the NVMEM
core can't be compiled as a module. The layouts needs to be available at
probe time. (That is also the reason why they get registered with
subsys_initcall().) So if the NVMEM core would be a module, the layouts
could be modules, too.

Michael Walle (14):
  net: add helper eth_addr_add()
  of: base: add of_parse_phandle_with_optional_args()
  nvmem: core: add an index parameter to the cell
  nvmem: core: drop the removal of the cells in nvmem_add_cells()
  nvmem: core: add nvmem_add_one_cell()
  nvmem: core: introduce NVMEM layouts
  nvmem: core: add per-cell post processing
  dt-bindings: mtd: relax the nvmem compatible string
  dt-bindings: nvmem: add YAML schema for the sl28 vpd layout
  nvmem: layouts: add sl28vpd layout
  nvmem: core: export nvmem device size
  nvmem: layouts: rewrite the u-boot-env driver as a NVMEM layout
  nvmem: layouts: u-boot-env: add device node
  arm64: dts: ls1028a: sl28: get MAC addresses from VPD

 .../devicetree/bindings/mtd/mtd.yaml          |   7 +-
 .../nvmem/layouts/kontron,sl28-vpd.yaml       |  52 +++++
 .../fsl-ls1028a-kontron-kbox-a-230-ls.dts     |   8 +
 .../fsl-ls1028a-kontron-sl28-var1.dts         |   2 +
 .../fsl-ls1028a-kontron-sl28-var2.dts         |   4 +
 .../fsl-ls1028a-kontron-sl28-var4.dts         |   2 +
 .../freescale/fsl-ls1028a-kontron-sl28.dts    |  13 ++
 drivers/nvmem/Kconfig                         |   2 +
 drivers/nvmem/Makefile                        |   1 +
 drivers/nvmem/core.c                          | 183 +++++++++++----
 drivers/nvmem/imx-ocotp.c                     |   4 +-
 drivers/nvmem/layouts/Kconfig                 |  22 ++
 drivers/nvmem/layouts/Makefile                |   7 +
 drivers/nvmem/layouts/sl28vpd.c               | 144 ++++++++++++
 drivers/nvmem/layouts/u-boot-env.c            | 147 ++++++++++++
 drivers/nvmem/u-boot-env.c                    | 218 ------------------
 include/linux/etherdevice.h                   |  14 ++
 include/linux/nvmem-consumer.h                |  11 +
 include/linux/nvmem-provider.h                |  47 +++-
 include/linux/of.h                            |  25 ++
 20 files changed, 649 insertions(+), 264 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
 create mode 100644 drivers/nvmem/layouts/Kconfig
 create mode 100644 drivers/nvmem/layouts/Makefile
 create mode 100644 drivers/nvmem/layouts/sl28vpd.c
 create mode 100644 drivers/nvmem/layouts/u-boot-env.c
 delete mode 100644 drivers/nvmem/u-boot-env.c

-- 
2.30.2

