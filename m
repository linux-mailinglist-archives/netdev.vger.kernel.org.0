Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C1B65BA2F
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 06:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbjACFOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 00:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjACFOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 00:14:21 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2108.outbound.protection.outlook.com [40.107.93.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6262B869;
        Mon,  2 Jan 2023 21:14:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MtxGf2atddvU1S/U9s67wSsdVFvg/A2LqxIDiz5v4SpPB8rNP9rPhChNSdVts/ulc1AeJr42UZUH56pjfrUAP/9voUOnuNoMf5RbIQOugChzeaynmE7QVT0x3AkgJVYRO+wmHDYZRG6CDOuSn5MED6yllXE1SFWAGT6YJaGoIEGlVokJ2SoDDgsgQyqv4V/QK0NqRhH4DeGcj38nLOBj+BL/FWN0pvFzqA8AhpQU0h503ndMG2juKvU2mEddnzHTsLVKkdjK35BtKdOvk0vdSEqK2VlsDAKNTIxJKkgANlY3Hvz8d+4sxGsO54oSRR2joTim2pl5y+5XLRO3UZrcmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0FooWDq6tpnap13ItYOSXnBKJcASDQ7lbmf78/BGReM=;
 b=guvOSDYjWMvA6bIY14wuQ5DJQ6AxPFbpnczOSgzwFv9T9i0NaPEhdP3YVnoRmblkJixgfRFii7i+QArWcckdp8uYRoE4gGDzN0psdKda6Y2TH3tnmSsBeYfekkoy21KR9ahspkHn+YH9NAUeznerQDTOF23sLofeJPorRQqNhuN7gsCzzTebQexUOdW9gRBdNsMfo/4IpUgEHhWDR5PZ1EPIk0BzebhGlzpKiS3DFQU7cehpF3PsVyJlDc/ttmO+hGBXZTwN5P3Wh9nLXw1huYH10p5Pda5wNC9nQBd8hNlXI7NJxr26xy+gdeYqfn9jjS9zVRLYXskqtnh4vgTtGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FooWDq6tpnap13ItYOSXnBKJcASDQ7lbmf78/BGReM=;
 b=F523EI3Wo/di1OxdxM2bsTCnO8GQOxFl/9uDZSBgqh6RjOfRzep6eMkoZB6GiJQ+0xYRt371SX4QVocoj+yq0rbINpMqpzwVkrqV2/KEYls7mNy9I9zLyckPkf+hwoe4fAk0Tk9kQyQz8UgDO8nuGvM/aWyYfUyGJ11XE7Pn0qQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA1PR10MB5823.namprd10.prod.outlook.com
 (2603:10b6:806:235::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 05:14:15 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 05:14:14 +0000
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
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v6 net-next 00/10] dt-binding preparation for ocelot switches
Date:   Mon,  2 Jan 2023 21:13:51 -0800
Message-Id: <20230103051401.2265961-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA1PR10MB5823:EE_
X-MS-Office365-Filtering-Correlation-Id: 8836967d-9a3f-4ebc-b13e-08daed495b29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cfz7koniny7/GllPSlzrjS4aVGGiiDRXvdFKA+NUgbZ4TajNaghuytzf0z5C9bWEQZH/+z+pSPzuufn0JGO60kkKY3FMVEHusFFgY7nVuA5ydmsq8BtS5Kkle8ztHPf7R6I5PW2/KnsvexEJpzkI/uPZsIEUU1Eck4TXqaAnPSAn7ESdEW78TDektoweAmC1i10Zrp9Rxs8KFNEVfIKsVIp4Yd18K+RUnmt+SjlaEtDAJ/vxuP+1jxbXis7FoSg1xXvVkJPkMF0XRyyJ074pnURH0YpqY5IRTY4MJNUgqyPTRV0AuSXKP6KxhyBd2mvUXIGLHQx4rS0X9ZY8/pUQ//H1TPRHgnHQHoNCDJzkUPIEUVQnF0R2Ao8+apbr+FktKAy5RpLV0GBaocCaUs8ewgZPg3AcCA++0uJcdfUxgPxXdbmLGZcwO7NbF9tDMgMD9q/tGETKz7zncHya6IeveVZPmWs0OCqh63eF4LzNXoRWvtw3uV3CDx9sqrqzYpDivV+0qCWu0P5cxRX+/7TUPdE4k6q4BOpkytMn2dnN5Uv5wAR8TcRbn54akMy2lqY/8GwrIylZhTec0DNrruromRxEDgyUexVlOv7B+8vMZ9b09T35+l2l9qaKP0UVTwrjnJ6fw4BOIt3B+N+0RET2JFcllyThOiJKkR3P6IRFeTnFtQhfF1YMJlOT9tZtt64FdF93cRRjzhnJI0uJF7cNkK+9vFXfsgYaVTAx52sNdwA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(376002)(366004)(136003)(396003)(346002)(451199015)(54906003)(26005)(186003)(52116002)(6666004)(2616005)(66556008)(66476007)(6486002)(1076003)(316002)(66946007)(478600001)(6512007)(66899015)(4326008)(8936002)(8676002)(7416002)(83380400001)(5660300002)(41300700001)(7406005)(44832011)(2906002)(38100700002)(38350700002)(86362001)(6506007)(36756003)(22166006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDN3ZHppcGNvOWtNM3l4a016KzV4TFdNTUJOUG4weTk1cWVrZlZQNmtVbkRC?=
 =?utf-8?B?VHBGMjZvVHU4dkdydGNvb3hnKzRTcXZ2eUo0RFlMUUxMeW5TL1RUajV4UVdv?=
 =?utf-8?B?algrU3l1elp6R01MU1dreWExUjhxdGRoRDFtNXR6OThQZW5FN2VWUXBSTlZK?=
 =?utf-8?B?Mzg2TGJHK1NaekpJKysyVElGNVZDdG9CU1hnS25LKzZsWTFTSERYazBhSmxk?=
 =?utf-8?B?RFFRS0FKYVl1djZNR0VmQzZCb3AxYllRU1JtaE1qUnJSa0YyTXAxcjJtUFlQ?=
 =?utf-8?B?dUJScThCQmNxaHpIN0tUNXNYNmtvTlZxeEdCV3FlWmRWUUdoZW9TNEMxTS9N?=
 =?utf-8?B?TVprb0poQTlvZndpTkNBbVVQY1VWTVFjcVAzK1hZcnpaUExPeHQ2cmNHZWdp?=
 =?utf-8?B?bVhwUzhncHJTZVhGR3BBS1NpQ0pYSXE0blNmbU1ZbjhIK1plVTZqMmtidm5w?=
 =?utf-8?B?bWNScm9LSVhCVVRhWDhCSjBJRDJYZXNjeVhkS1NhcVZUWGQ0aTg0aWMwUlJw?=
 =?utf-8?B?UGJJSjR6VzFhZUNNaVprdGVaUUpiT3hDUEVyRUtMNHZiV2VuSkk3VWlCQWVp?=
 =?utf-8?B?Umtzek05NnpSelNzM3RsYnczQ01NUlJqSzhMYUpHcUswN3pJWFdlMUx0L3Vw?=
 =?utf-8?B?UGNBTFBkMWtuZExXYXJtWjNDOE83UERrbXErR0lMNUhoMEJTK3lEL1cwOGtw?=
 =?utf-8?B?bmdlUkxDYVNESnVVLzY1aDRrd3h5eVBtK2NXNFVoMnN5blp2K1lMVjdpRG1u?=
 =?utf-8?B?ZHNsMFdvYjBXb3BqQWRNL3ozanV4Vy94L0JRaFNIbDJjOFpVNndmeXVucHd3?=
 =?utf-8?B?MDg1T0xueGxvUmtkcHBmVml3WTlYd0h4eThlaTJUM2dxRDJzb3B2bHpvdk9r?=
 =?utf-8?B?QVJtbFMvRWtQblFRRUNHeFIyc1YyclFQczNSbXl1ak0vNE5oenZYNzZ6MFZO?=
 =?utf-8?B?OElwaVBVMTYvR2NGL1JIL25KUzllVDZQaGFBZHpUZXc4ZjJJOVZuMDMrWm1l?=
 =?utf-8?B?SXNTdFJIRkoyQTNNTWhsZUNtbTVzeHBWeGtBM21Ra1UzUVJrVWpmQXVPTzFq?=
 =?utf-8?B?TnVXR0ttSE5kNFVaMDFUVEl4VlIzR0h0enJXWXRUbGxDUlp2dWdxT2pwUHIz?=
 =?utf-8?B?WEx3M2xacW5ERm8xVlBEUzZTSEl6cEtzb1RBUnNQenphNmg1a2UzVDhGM3lO?=
 =?utf-8?B?aDREMVBTUGFzM0cwNEtBaXR4bFN6blJvVWpxUjJaSkFka0NCM29pSWlseTRT?=
 =?utf-8?B?cVF1VTU2MWJkVnRGcm4xTGtKK3ZJTU5rYmY0VXQxZDhrNTVHRVEzZXlheG8x?=
 =?utf-8?B?ckI0ZjBNaGREK1hDVlN1WGlzYzZJcEtWSTVkQSt0WkhKZDhCcHJLQ0tqTS9Z?=
 =?utf-8?B?a2ttL2ZJMUdmdzNwaHVYUHMvK3VRR2NSWC94bnlvRGpWU24wY3lqQzhmSzRs?=
 =?utf-8?B?Zm5PKzliZDJIOEFmWTNubWdVYlpyVnBXSEtNK08zWU5XMkFwTGNqZjZySk0v?=
 =?utf-8?B?dkdiSk9lR3NjM2RPbWpTeThTZjhRajZzQ1pQWUVMM3NJcnJpSk0xY2dlai9H?=
 =?utf-8?B?UzU0VGxqV1VySjBFcnFuOXF4YVdoREg2b09ib1d4eFFKOVVYN1RJTkYrOTBL?=
 =?utf-8?B?TmZHN1BBTTdQakE2cS9aWDc5WENDc21QRm5pN2hrSWtqbGpHWFZhS1o4bCtv?=
 =?utf-8?B?UXo0YUljZmd2VXRMdzJUbTdJYWd0REJiSzBENFhPMmROazJNYkFzMndDa2lL?=
 =?utf-8?B?d2dBNkJVMmsrV2JjMXFjWm9WV1N1TWg2WkVNeXJ3OFpTWDFRRFRvY2ZxL3px?=
 =?utf-8?B?Z0FUS2M5c3NuTlduZFM5aGhvTjRpVERxRzF3VGJTL0RZS2ZRVVlhK1dxQ2dL?=
 =?utf-8?B?dVFBYmRVYmJTSXNEbFFxVFdYeHRpYTVOeDg0aUFIY0ZUZ29veDI4RTFUOE53?=
 =?utf-8?B?a2NxSjNzV0MwZFZCeEltN0M5TWZReDNNbTlGWjYrME9RK3JaMlVqWEdpWW5Z?=
 =?utf-8?B?Z0c2VjViWEtDSUZhckxRcUFBanJDYXR5MVNFYzIvYmdWYTk1akpIRUF5NHJk?=
 =?utf-8?B?c0tZRnN5YTNqZ01EWEo0ekVDU0x5WkVoUVBjMHl0MFlSemVQYkRjVldIK0Ro?=
 =?utf-8?B?MzhBSnRGM3o0Uk4yTE9aenBRNXNmS2d5U2xYQ3pkZlZDMnV4Vm4wMkxxYkI4?=
 =?utf-8?B?ZEE9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8836967d-9a3f-4ebc-b13e-08daed495b29
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 05:14:14.6544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GCeRWpkLlAmGgzLjyGamhVO8dv8MXRBGgEduUojLgQmrP5CLDF6bi+qtwyDycNX0864T5Wc82jmaZeh8zMp7jpwZIenu0z6qrynWpr9ckX8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5823
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
 .../devicetree/bindings/net/dsa/dsa-port.yaml | 29 ++-------
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
 .../bindings/net/ethernet-switch-port.yaml    | 25 ++++++++
 .../bindings/net/ethernet-switch.yaml         | 62 +++++++++++++++++++
 .../bindings/net/mscc,vsc7514-switch.yaml     | 31 +---------
 MAINTAINERS                                   |  2 +
 18 files changed, 143 insertions(+), 108 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch.yaml

-- 
2.25.1

