Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C41568447
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 11:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbiGFJwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 05:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiGFJv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 05:51:57 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC4C237FA;
        Wed,  6 Jul 2022 02:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657101116; x=1688637116;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hIrJs9ihsTLQ0p0bXK5jE65wktLVv5IEhLVWqw8Slew=;
  b=jjjbehWLpmDZnqQy+DTsNCppJBgXbZ7hJcG0DzXltocjJvU7xk+OeM+g
   4D+rt8dUrqORFVDJeWa1bjV3nR07opnh3hUA5eh+1W+Vu20EJslRC7M0y
   l4ErhHamB8heIWZWANtGnRMuUroxbgGAg05/4GAjsuT2Uuy7eMzHKe8o6
   SmqzVfhmPQPfVz6HLdakVcqCJteAips21or4JutpohcX/uJxeIAax3KdO
   TltK1jZjFM3ezeI6jUar9K68r4IGy1O1GoJ02aPfEonM0p7oksYiaLpKP
   H0MzMOnAoYrWI/CqB6WdhLGo4lyej1rZWaKJdq38NZ/lEIOFT7DKKVmid
   g==;
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="163537819"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2022 02:51:55 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 6 Jul 2022 02:51:53 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 6 Jul 2022 02:51:50 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Conor Dooley" <conor.dooley@microchip.com>
Subject: [net-next PATCH v3 0/5] PolarFire SoC macb reset support
Date:   Wed, 6 Jul 2022 10:51:24 +0100
Message-ID: <20220706095129.828253-1-conor.dooley@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey all,
Jakub requested that these patches be split off from the series
adding the reset controller itself that I sent ~yesterday~ last
week [0].

The Cadence MACBs on PolarFire SoC (MPFS) have reset capability and are
compatible with the zynqmp's init function. I have removed the zynqmp
specific comments from that function & renamed it to reflect what it
does, since it is no longer zynqmp only.

MPFS's MACB had previously used the generic binding, so I also added
the required specific binding.

For v2, I noticed some low hanging cleanup fruit so there are extra
patches added for that:
moving the init function out of the config structs, aligning the
alignment of the zynqmp & default config structs with the other dozen
or so structs & simplifing the error paths to use dev_err_probe().

Feel free to apply as many or as few of those as you like.

Thanks,
Conor.

Changes since v2:
- Fix a commit message typo

Changes since v1:
- added the 3 aforementioned cleanup patches
- fixed two stylistic complaints from Claudiu


Conor Dooley (5):
  dt-bindings: net: cdns,macb: document polarfire soc's macb
  net: macb: add polarfire soc reset support
  net: macb: unify macb_config alignment style
  net: macb: simplify error paths in init_reset_optional()
  net: macb: sort init_reset_optional() with other init()s

 .../devicetree/bindings/net/cdns,macb.yaml    |   1 +
 drivers/net/ethernet/cadence/macb_main.c      | 106 +++++++++---------
 2 files changed, 56 insertions(+), 51 deletions(-)

-- 
2.36.1

