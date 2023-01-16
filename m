Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB2F66B97D
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 09:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbjAPI4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 03:56:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232328AbjAPIz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 03:55:58 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67A6F777;
        Mon, 16 Jan 2023 00:55:56 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30G8teAd064470;
        Mon, 16 Jan 2023 02:55:40 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1673859340;
        bh=BiIyJEi0pp6Nt7svGW9SqzoYZ1kZspHk47MZdNhzGyE=;
        h=From:To:CC:Subject:Date;
        b=WQyY+RGp8XwPkF0Ivu8mw76qXxYR7/+dsz18PggXIqLogDQy7MiwvODkR5TcFtMDI
         ODBaGevk0FnZf2WtBDFoFw8Xegxhxxeri72PJWjZimmx+WUsSxW4i5NsvZwXUefdbl
         hS5ZmLrKrSjYOBYh9AxH2Cx6ASor/IaieURgOvAk=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30G8teci076507
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 16 Jan 2023 02:55:40 -0600
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 16
 Jan 2023 02:55:40 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 16 Jan 2023 02:55:40 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30G8tZwH040368;
        Mon, 16 Jan 2023 02:55:36 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <vigneshr@ti.com>,
        <rogerq@kernel.org>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next v2 0/3] Add PPS support to am65-cpts driver
Date:   Mon, 16 Jan 2023 14:25:31 +0530
Message-ID: <20230116085534.440820-1-s-vadapalli@ti.com>
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
pair [CPTS_HWy_TS_PUSH, GenFx] to the cpts driver.

Changes from v1:
1. Drop device-tree patches.
2. Address Roger's comments on the:
   "net: ethernet: ti: am65-cpts: add pps support" patch.
3. Collect Reviewed-by tag from Rob Herring.

v1:
https://lore.kernel.org/r/20230111114429.1297557-1-s-vadapalli@ti.com/

Grygorii Strashko (3):
  dt-binding: net: ti: am65x-cpts: add 'ti,pps' property
  net: ethernet: ti: am65-cpts: add pps support
  net: ethernet: ti: am65-cpts: adjust pps following ptp changes

 .../bindings/net/ti,k3-am654-cpts.yaml        |   8 +
 drivers/net/ethernet/ti/am65-cpts.c           | 155 ++++++++++++++++--
 2 files changed, 148 insertions(+), 15 deletions(-)

-- 
2.25.1

