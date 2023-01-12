Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26850667DE0
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 19:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240286AbjALSVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 13:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240611AbjALSVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 13:21:08 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F136BBE3C;
        Thu, 12 Jan 2023 09:56:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JsTSCd+wONXXHvmtPrb9906Dr9NSF7/Q2r8d1+8w1EqGhA3OUkj4ypqmNrOKjDOjzzSi1W/l9Xi1JkftWmkIhsqYuq2Hp731WXXn78L8lZpss5QryowoYgblsp5flhr6R1TymmZupFTHLONnT4Rf4b6mXZrYCvx5JH0Fm6EDGgpEP1e5s9XAIu6T3qoSfXVAkFM+7ABvojI2sBivXarPvD+HtolXZEMlD9vSAD8wU+yHD8LBueBbAVkby2oYxRqFw5VOGe8fUkXPLa7B6EhjLhypLHsWWPrOxgEZ+kmkPs1yBzsOy4oriPyoIt/d012HNmMmI1QazUl1YN1wXK5lXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vuRJYGVT/Vh49Xb904JLBrCmEXn3TP7z+ALpsSWKcjM=;
 b=Cu7uyRu8eUlEcU/SD3SDSuiutiRnka9AO3dAoWofwumhr/UUGjOiXAmUiKjkN5gNg+CtNCKpYSd9QI9WJBb7n39hAmo8AXoWYPEkWGht2lLK6sYPUQnHzP33Wm11c6otSpQEJG5UJf0oUINzyVGTnefEH19/+tDU8DabBQJjuNjU1QMpM3+/jqdQh3JQpAGHG5ZHGPESmLlAnQxvzai84CxNU9tD3a9ykW49/sTmli9ltNTYz1H0ds+o+4iyHduaT+VEdlmjrEiT8HgLj3Xr70uRj326aSn9YtIdbDjILiUDvowmfNQ9jWjCDMJFMXYslXYZkJunjVrRWHeHLVoyKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuRJYGVT/Vh49Xb904JLBrCmEXn3TP7z+ALpsSWKcjM=;
 b=V5Rw+HTfn0Mu83QQJ3As7F05N7tTqEVDf/47nGlntvCM+mnLQFZj0kEzO82qrvhO5eyMRFUSrZ8Bh3EIJwqPQKY0/Hv3STAnTSoDSeoD4bN2V/iQQdo3vysknuFFEAlyuKSpuDW20Ny8NTAs7ETlrEpapfNxv43Y0S04EeKyi/E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SN7PR10MB6548.namprd10.prod.outlook.com
 (2603:10b6:806:2ab::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 17:56:29 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6002.012; Thu, 12 Jan 2023
 17:56:28 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v7 net-next 00/10] dt-binding preparation for ocelot switches
Date:   Thu, 12 Jan 2023 07:56:03 -1000
Message-Id: <20230112175613.18211-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::7) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SN7PR10MB6548:EE_
X-MS-Office365-Filtering-Correlation-Id: e1771c84-3c66-41ba-c0e6-08daf4c6548b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nk/B+jlyoDc+uNeCGAfJq71wyv59XHQ/Thbxj+DEhWnReROg5KbF0OSiOGxTHXaomAhRVHQIpKQGKGFoycwGNndV5oCC/QGs/5ym23n1ytvCqh3EfaSG6a6k6R/BMtLmlXdTXNActThqvVeVcciFL5k1Mgn9P5s3vEEvFyUcc9Hd7Mkobrs5NErEJAxowOa4y5aFCWhiSrykx1N8PRUMGpB7aYDPP3RQhmydU93Yv4nhA3WtYmYh+APljdXHyKaBgYCLbeMy6J2vSZGmErlUCVxbnRuw9BmAVmTHhno2Y6UWpPc1IQQn4LE7rKphli/Mh5ByRI4v95wQTLWuqbWzucBeyIsvWnS1hV+qkQ8iin0qq8FPcvThmgGK4w4CRu2TVujFmhJWmrPmpgonDQBboH7WEFprHBKlKbkIntj8qgGm83Qk+jrA7VS0eDCaT1N/YLhzmvpoQPvYnKbQ9HpXgEImoSFGyNi7Vdvp5VH8UA7i0vMdQ5Ra6TkL4PVEmOb8immVfFck5zyl2yTaFhqDtkLWWHkGkd1lS7oOGkPfbTh/tmOdh7LsT5tNx5OfKRxmlbH1EVurebsem+90BOFH85YNTVNNMbhE2zE8hfzpQDlSY0d8FJb4Bnmz2DRu81ZIzrQWfr8giPbXzBuuGxFOQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(39830400003)(346002)(451199015)(66476007)(41300700001)(66556008)(66946007)(8676002)(7406005)(5660300002)(7416002)(316002)(44832011)(54906003)(66899015)(4326008)(8936002)(2906002)(86362001)(38100700002)(478600001)(36756003)(6486002)(52116002)(6666004)(186003)(6506007)(1076003)(2616005)(6512007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnpWY00zZTlmZTJSeWNOa01peTZxakV2ZnEyVzJyd0p5UzRVWlF3cXlEdjNl?=
 =?utf-8?B?UXFyakQ2UUNWZUdSWFU1QUxXMjBPSyt3OERXd1VyS29XVW1HbnhodjViOWVr?=
 =?utf-8?B?Q0tsY0R3K2FPQjFiQWFXOXVsdmFRWXp4WDZROEZDYndZMGV4SEt3N2p0QVBB?=
 =?utf-8?B?cHBHQ2w3MUV1QThMNGJyYks0QTNabHMxN016RGx0c1pBQlptdEliaVl1QzVS?=
 =?utf-8?B?SHd2bTZLNVgrNTZSMFdYWWtNY21MMzJocFpGYXIrY1QxVFM2aHBLSlJrbmpY?=
 =?utf-8?B?MEVTOHIvcXp6MDFKNXFpdnI1L05sbS9PVFpsSUk3cWN6cmZISmZ5UHEyRjMy?=
 =?utf-8?B?ck5nS2NFaGtnUEdyVGRzdndpdGwrT2pTUzNKVG1OQlpaRjNhdGZKdWZ0Z1d0?=
 =?utf-8?B?YTlSNG9QSmFxTVlhVjZQWjlEc2YvVUxQc2UyL1AxbXo0Yzh2cEhlZms4ZVFN?=
 =?utf-8?B?cmhvcEF6MmRJL1pXckVjbDNuRjRNaXlRUW1DUXRTbVNodXNHazg5UzVIY0c5?=
 =?utf-8?B?ZnpJSFVqVFdLR3F5K2lJT3ZaZkRLbkFWSVYvV2szanJ2Q2p6TWUrSk5iWWJS?=
 =?utf-8?B?OHdOeVFOUEtuQ3kxNWwrUDR6VVNxWFBsK0VRdjEwblErbjkyV09ad2lSdSty?=
 =?utf-8?B?UFN6TDNDY2FxdzArUitTRDRoMzhKMmY1b2V2QXhKR2lKZmFZVFpRbEVyeHhj?=
 =?utf-8?B?SFBqdEZRVE4zTjBZUUwydlVDNS9NWWRsdFVmOFFvN1RqSlVqTkJjYTZKUHVI?=
 =?utf-8?B?UEw4R216SW9ISDd6a0ROdEVFMXpDRUpQVVhyL2tDYW0xWEZnMXl5N2ZaL0VP?=
 =?utf-8?B?TlJMT1N2VjFxTG0zSVNPZy9JY1ZLQlNwYVNZeHJVeTJ2L1BTMGdlV1U4Q2R3?=
 =?utf-8?B?MXJwQmFvNzJHY2dqaHdBQkxOVmU5N1pLMHR2VXZkOC81Q0tpR0V1MitpSVpS?=
 =?utf-8?B?cmZ0VXgrYjh4aU5YV2hQakU3MkI0V2t3c0NRVk1SbU5kR24zckRNVTV0b2s4?=
 =?utf-8?B?Ykpnc2N3SXpUakUxQXZvVnJtdzczait5U2NwWWJQVm9qT0ZuRytoemhETUFj?=
 =?utf-8?B?dkhkL1gvZnBTMHpHNnVEMWJMYm1xd1lBbERhVDhjdWZRT0pPT05jZjF0THUv?=
 =?utf-8?B?R3picWNlYk1FQlFoVjY5cjg5Ym9UbUF0ai9jZXRkeW43Q3dNNEhzaDQ4WHha?=
 =?utf-8?B?M2pGY3ZRcDRqTFFRZDBaa0Y4Yk1RaXAyWWJiNmk1TFp0RFFXdDdONE5xS0J2?=
 =?utf-8?B?RlE5NWtNclBRTHU1M2pxMkNWSklmd0dzNG5Qc3hVWExQdnJUVkc5UUE5ay9x?=
 =?utf-8?B?aU5kTVQyam9LMEphZXZUZ2RVMnpydkovcEVPM2xGVkg0TVVKSUo1NkFscVJx?=
 =?utf-8?B?bnorZWN2UkFiZ29URmJUemZjRkhPWlE2RVFNWUF4SndHNEd6UWNJS01TL1pI?=
 =?utf-8?B?bTcrazJOcVlmNUcxU3VaL1ZNMUo4YnphdGkvRVVBc2Q5b1JhaVVTQkZsbUp4?=
 =?utf-8?B?MURlbUEyOG43WkQzcVMrSXRvd1ZyMGs4czdHK28vZFJ5ZENnTFQ5Ry9YN0kr?=
 =?utf-8?B?YjdleFdwTVloanhjdGdNdnlMemVMT3JmazZXdlNiaTlKcVZPM1FwbDV4Z1Fx?=
 =?utf-8?B?OVNaaUhaK1N3VjRpYlpXNk1OUFo1d3JUZmpnUUdndnd4aXREclQxcGc5c3BW?=
 =?utf-8?B?Z1FEVVY4NVMvYUtxMjNYR0pnYzJDZWs2UVR1SkxkdUVlZjhhdHJMSU5aZXN6?=
 =?utf-8?B?SmpFOXZsK1FmUml3VTJvZXVZLzVwOW5BUkIxOW5iRk9vY0U1bUhvNnd2Vms3?=
 =?utf-8?B?RHhYR3A3dFF2WkNpNDlqNm8yZ0JYdFRSaVdmcTh3UUJZK2FhS1g2QTcrN3dF?=
 =?utf-8?B?QU9CeFpZcmNWdGY2eUZFL1g0WEI4ZW1sdXF1UStNeFVKQ0dRdmJTNmZreG1o?=
 =?utf-8?B?eWovazlIWmx2UFEwZnUycWNYdDRGOUpuZ2VSRXhheXBVT2M0U3VvM2NMamJo?=
 =?utf-8?B?Z3Z3SDBWT0ZVdzlrYXVLY3BpNWp3dTNuOHRGNVRQdEUzYkJtd2hsUjY4dUlD?=
 =?utf-8?B?dzA2eTNZZWE2eUNhT0poL1p5dWdaWkFESjRIR3VUcmtIL05IanJsM2tqR0ow?=
 =?utf-8?B?NS9sMS9WN2lyTGlYL2RwVWl6K1lWS2RUcXNkNVFZRUZndFR6QjlOcmdhMEQv?=
 =?utf-8?B?N0FUWGw4UE90L0FKZGcxUjNUZXNacDJITzlOVlRmclkvYlgzaXNCY281b2da?=
 =?utf-8?Q?+xQ+RkV2MfAPb1skRGSeFq2opJThTQuivQ0anB1HEw=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1771c84-3c66-41ba-c0e6-08daf4c6548b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 17:56:28.8462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FdDB5/vxWA8qf9EIEUg/aUJcX23+kDqH+52mi/X51QsVRvXxs90n5Fiq9DFyjaQqH2BhnC4W6XLlkwNUqN3ePRJe4Tr4WJ3EVw0M7BwgEgE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6548
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot switches have the abilitiy to be used internally via
memory-mapped IO or externally via SPI or PCIe. This brings up issues
for documentation, where the same chip might be accessed internally in a
switchdev manner, or externally in a DSA configuration. This patch set
is perparation to bring DSA functionality to the VSC7512, utilizing as
much as possible with an almost identical VSC7514 chip.

This patch set changed quite a bit from v2, so I'll omit the background
of how those sets came to be. Rob offered a lot of very useful guidance.
My thanks.

At the end of the day, with this patch set, there should be a framework
to document Ocelot switches (and any switch) in scenarios where they can
be controlled internally (ethernet-switch) or externally (dsa-switch).

---

v6 -> v7
  * Add Reviewed / Acked on patch 1
  * Clean up descriptions on Ethernet / DSA switch port bindings

v5 -> v6
  * Rebase so it applies to net-next cleanly.
  * No other changes - during the last submission round I said I'd
    submit v6 with a change to move $dsa-port.yaml to outside the allOf
    list. In retrospect that wasn't the right thing to do, because later
    in the patch series the $dsa-port.yaml is removed outright. So I
    believe the submission in v5 to keep "type: object" was correct.

v4 -> v5
  * Sync DSA maintainers with MAINTAINERS file (new patch 1)
  * Undo move of port description of mediatek,mt7530.yaml (patch 4)
  * Move removal of "^(ethernet-)?switch(@.*)?$" in dsa.yaml from patch 4
    to patch 8
  * Add more consistent capitalization in title lines and better Ethernet
    switch port description. (patch 8)

v3 -> v4
  * Renamed "base" to "ethernet-ports" to avoid confusion with the concept
    of a base class.
  * Squash ("dt-bindings: net: dsa: mediatek,mt7530: fix port description location")
    patch into ("dt-bindings: net: dsa: utilize base definitions for standard dsa
    switches")
  * Corrections to fix confusion about additonalProperties vs unevaluatedProperties.
    See specific patches for details.

v2 -> v3
  * Restructured everything to use a "base" iref for devices that don't
    have additional properties, and simply a "ref" for devices that do.
  * New patches to fix up brcm,sf2, qca8k, and mt7530
  * Fix unevaluatedProperties errors from previous sets (see specific
    patches for more detail)
  * Removed redundant "Device Tree Binding" from titles, where applicable.

v1 -> v2
  * Two MFD patches were brought into the MFD tree, so are dropped
  * Add first patch 1/6 to allow DSA devices to add ports and port
    properties
  * Test qca8k against new dt-bindings and fix warnings. (patch 2/6)
  * Add tags (patch 3/6)
  * Fix vsc7514 refs and properties

---

Colin Foster (10):
  dt-bindings: dsa: sync with maintainers
  dt-bindings: net: dsa: sf2: fix brcm,use-bcm-hdr documentation
  dt-bindings: net: dsa: qca8k: remove address-cells and size-cells from
    switch node
  dt-bindings: net: dsa: utilize base definitions for standard dsa
    switches
  dt-bindings: net: dsa: allow additional ethernet-port properties
  dt-bindings: net: dsa: qca8k: utilize shared dsa.yaml
  dt-bindings: net: dsa: mediatek,mt7530: remove unnecessary dsa-port
    reference
  dt-bindings: net: add generic ethernet-switch
  dt-bindings: net: add generic ethernet-switch-port binding
  dt-bindings: net: mscc,vsc7514-switch: utilize generic
    ethernet-switch.yaml

 .../bindings/net/dsa/arrow,xrs700x.yaml       |  2 +-
 .../devicetree/bindings/net/dsa/brcm,b53.yaml |  2 +-
 .../devicetree/bindings/net/dsa/brcm,sf2.yaml | 15 +++--
 .../devicetree/bindings/net/dsa/dsa-port.yaml | 30 ++-------
 .../devicetree/bindings/net/dsa/dsa.yaml      | 49 +++++++--------
 .../net/dsa/hirschmann,hellcreek.yaml         |  2 +-
 .../bindings/net/dsa/mediatek,mt7530.yaml     |  6 +-
 .../bindings/net/dsa/microchip,ksz.yaml       |  2 +-
 .../bindings/net/dsa/microchip,lan937x.yaml   |  2 +-
 .../bindings/net/dsa/mscc,ocelot.yaml         |  2 +-
 .../bindings/net/dsa/nxp,sja1105.yaml         |  2 +-
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 14 +----
 .../devicetree/bindings/net/dsa/realtek.yaml  |  2 +-
 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |  2 +-
 .../bindings/net/ethernet-switch-port.yaml    | 26 ++++++++
 .../bindings/net/ethernet-switch.yaml         | 62 +++++++++++++++++++
 .../bindings/net/mscc,vsc7514-switch.yaml     | 31 +---------
 MAINTAINERS                                   |  2 +
 18 files changed, 145 insertions(+), 108 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch.yaml

-- 
2.25.1

