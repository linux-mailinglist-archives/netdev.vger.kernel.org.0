Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A99A665AB8
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 12:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjAKLrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 06:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbjAKLq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 06:46:26 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522B5192A1;
        Wed, 11 Jan 2023 03:44:54 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30BBiaDi030624;
        Wed, 11 Jan 2023 05:44:36 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1673437476;
        bh=j+h4JevHnwLFduKRSkeB5LMLLoTDYPUgl2/FrQXToy8=;
        h=From:To:CC:Subject:Date;
        b=n7jLSB52OEMEjjH8H89vZdiNEZYkKUuR8HDlUvY9KQTDZQgB+4+w6fuzU7F8Pi8Ro
         LSkjs/fO1lT6sBhs19OuBJSHVlTKWT7EZUW13q3u8VJv4h8GdvDojWwi3/wZop+mzF
         iWZQkNnv2SOvMMuA02D5fCC1asLrVVyTzGlPcaK0=
Received: from DLEE101.ent.ti.com (dlee101.ent.ti.com [157.170.170.31])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30BBiaIW011889
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Jan 2023 05:44:36 -0600
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 11
 Jan 2023 05:44:35 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 11 Jan 2023 05:44:35 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30BBiUkH093892;
        Wed, 11 Jan 2023 05:44:31 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <nm@ti.com>,
        <kristo@kernel.org>, <vigneshr@ti.com>, <rogerq@kernel.org>,
        <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next 0/5] Add PPS support to am65-cpts driver
Date:   Wed, 11 Jan 2023 17:14:24 +0530
Message-ID: <20230111114429.1297557-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CPTS hardware doesn't support PPS signal generation. Using the GenFx
(periodic signal generator) function, it is possible to model a PPS signal
followed by routing it via the time sync router to the CPTS_HWy_TS_PUSH
(hardware time stamp) input, in order to generate timestamps at 1 second
intervals.

This series adds driver support for enabling PPS signal generation.
Additionally, the documentation for the am65-cpts driver is updated with
the bindings for the "ti,pps" property, which is used to inform the
pair [CPTS_HWy_TS_PUSH, GenFx] to the cpts driver. The PPS example is
enabled for AM625-SK board by default, by adding the timesync_router node
to the AM62x SoC, and configuring it for PPS in the AM625-SK board dts.

Grygorii Strashko (3):
  dt-binding: net: ti: am65x-cpts: add 'ti,pps' property
  net: ethernet: ti: am65-cpts: add pps support
  net: ethernet: ti: am65-cpts: adjust pps following ptp changes

Siddharth Vadapalli (2):
  arm64: dts: ti: k3-am62-main: Add timesync router node
  arm64: dts: ti: k3-am625-sk: Add cpsw3g cpts PPS support

 .../bindings/net/ti,k3-am654-cpts.yaml        |   8 +
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi      |   9 ++
 arch/arm64/boot/dts/ti/k3-am625-sk.dts        |  20 +++
 drivers/net/ethernet/ti/am65-cpts.c           | 144 ++++++++++++++++--
 4 files changed, 166 insertions(+), 15 deletions(-)

-- 
2.25.1

