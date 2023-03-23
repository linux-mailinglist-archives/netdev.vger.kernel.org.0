Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9047B6C6503
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 11:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbjCWK35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 06:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbjCWK3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 06:29:21 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377A21C5BB;
        Thu, 23 Mar 2023 03:27:08 -0700 (PDT)
Received: (Authenticated sender: herve.codina@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPA id 2138B40002;
        Thu, 23 Mar 2023 10:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1679567227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Bb2LaA5oKhmmtAZYLmsiQ/YaU0jciVROXMb0QSlP0Wg=;
        b=VxFDk1btpm3I+lY27gnNS2ZFS9MfFuK69w+dHpGJzWzpWR45gsxG/km5LiGA2wHJLBaLg5
        VK+K97/DL86knDX6Mke46XFjzerXEVRH/Zb93FgpPBaY8F7wk6J1AgSvyMu1tzuk8dHWz6
        xrEgKll+w/M4VK1OG85PKzR2sOgHEFTx9oc+ivV39IX8d7A+Kx1+d0/2wBwB2dPZ3ZQdte
        O+duzsRYbMcdgNBtMQpKLou3uaJu7N2ahGwixQe8z+OWcf1e6cGnb37vdxOxH8ZCklBNVI
        VeYlf21rudf7mc+B1N60Wt0NTfnjRYXw13T+M37jn2YthgvBxNvOGQ6CArHBmg==
From:   Herve Codina <herve.codina@bootlin.com>
To:     Herve Codina <herve.codina@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [RFC PATCH 0/4] Hi,
Date:   Thu, 23 Mar 2023 11:26:51 +0100
Message-Id: <20230323102655.264115-1-herve.codina@bootlin.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have a system where I need to handle an HDLC interface.

The HDLC data are transferred using a TDM bus on which a PEF2256 is
present. The PEF2256 transfers data from/to the TDM bus to/from E1 line.
This PEF2256 is also connected to a PowerQUICC SoC for the control path
and the TDM is connected to the SoC (QMC component) for the data path.

From the HDLC driver, I need to handle data using the QMC and carrier
detection using the PEF2256 (E1 line carrier).

The HDLC driver consider the PEF2256 as a generic PHY.
So, the design is the following:

+----------+          +-------------+              +---------+
| HDLC drv | <-data-> | QMC channel | <-- TDM -->  | PEF2256 |
+----------+          +-------------+              |         | <--> E1
   ^   +---------+     +---------+                 |         |
   +-> | Gen PHY | <-> | PEF2256 | <- local bus -> |         |
       +---------+     | PHY drv |                 +---------+
                       +---------+

In order to implement this, I had to:
 1 - Extend the generic PHY API to support get_status() and notification
     on status change.
 2 - Introduce a new kind of generic PHY named "basic phy". This PHY
     familly can provide a link status in the get_status() data.
 3 - Support the PEF2256 PHY as a "basic phy"

The purpose of this RFC series is to discuss this design.

The QMC driver code is available on linux-next. In this series:
- patch 1: driver HDLC using the QMC channel
- patch 2: Extend the generic PHY API
- patch 3: Use the "basic phy" in the HDLC driver
- patch 4: Implement the PEF2256 PHY driver

I did 2 patches for the HDLC driver in order to point the new PHY family
usage in the HDLC driver. In the end, these two patches will be squashed
and the bindings will be added.

Hope to have some feedback on this proposal.

Best regards,
Hervé

Herve Codina (4):
  net: wan: Add support for QMC HDLC
  phy: Extend API to support 'status' get and notification
  net: wan: fsl_qmc_hdlc: Add PHY support
  phy: lantiq: Add PEF2256 PHY support

 drivers/net/wan/Kconfig                 |  12 +
 drivers/net/wan/Makefile                |   1 +
 drivers/net/wan/fsl_qmc_hdlc.c          | 558 ++++++++++++++++++++++++
 drivers/phy/lantiq/Kconfig              |  15 +
 drivers/phy/lantiq/Makefile             |   1 +
 drivers/phy/lantiq/phy-lantiq-pef2256.c | 131 ++++++
 drivers/phy/phy-core.c                  |  88 ++++
 include/linux/phy/phy-basic.h           |  27 ++
 include/linux/phy/phy.h                 |  89 +++-
 9 files changed, 921 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wan/fsl_qmc_hdlc.c
 create mode 100644 drivers/phy/lantiq/phy-lantiq-pef2256.c
 create mode 100644 include/linux/phy/phy-basic.h

-- 
2.39.2

