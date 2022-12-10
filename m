Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701C2648CC5
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 04:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiLJDay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 22:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLJDaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 22:30:52 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2103.outbound.protection.outlook.com [40.107.102.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983C78AAC5;
        Fri,  9 Dec 2022 19:30:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7zi0pPyPKqvuG9y+HlK6k42R0g42lNdAt+N72DdsmlfutqwqEynNF+t6lheidEzBcCjXVFLn1wc5McAt9uEcIpkpZU45XDbAHw+IqB2q4pkNgutwL3IFExjxlx4A7QX2ZfOB6dSVXITA9Bls15ERpPIv+XMVQ2/WgT7IXw9GnKurwbJZ5mKNgxigmgtD9fxNMeBkI6Nm/VwNZsH9ok11/z9lCRf3CA1xsRC5H27zCC2wTX5+Z9MUBcNCFyCVDkQUOw7q5mhaJ8jvoFhe9bgwSKgcY8CHmL58FIBuTstSCw6jHb7M/w2aTb6ur0DdR06Sy6q0B5wFMqiUkHpih7DHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MfyIuXlv74z102EP810TFkCdgXV3xIbzuIuDaf9QWF0=;
 b=mjhXvvg0vOuuU2jNkt4jEwQ9UkY2EPXDt4roqkWrwcZ/cp4CntjQvKd7Ond5n8iOfs1T6tyZot901pvVE2awf+vVx5ux1XiahuAvgOq28hcr361Ns5qUnWVb5TC8OBHrUG0twc6k1IN+oXhbGW0JP/ORnIGRIa6g4kw4VmdIixZdIUJYHxZ89QmD73kE7aqXZ6QSJN0t9H0u7adzEEJaupHMmgqlxbrLl9D0XA11xZT2DAgW2RqOFrdDCO/KpB3ce/9EdBlIhLIvSBuiM2y5rRE7PQmkpVwiUHY9brD9Hmd7lzrUEE9NebfNYc3CdKXHsJaofeV+Po1GCp9npxxzRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MfyIuXlv74z102EP810TFkCdgXV3xIbzuIuDaf9QWF0=;
 b=K9UnNCZQ3Fpt+D5pzEtVyvD5j9XXKgUYnlw3w2iYts36Maishdcb7zTnjWPZwExkPUUlFr2nYwzuk6Vd4UKm7WklcUtwMKDBtJ1c65s5bLDtIxc7r1ey+saap9FBsqKhTZy6jEZaXlEBGopubxXMwHM/+z5N9ccN99HFZbcmT9g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB5084.namprd10.prod.outlook.com
 (2603:10b6:610:dc::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Sat, 10 Dec
 2022 03:30:47 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 03:30:47 +0000
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
        Vivien Didelot <vivien.didelot@gmail.com>,
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
Subject: [PATCH v5 net-next 00/10] dt-binding preparation for ocelot switches
Date:   Fri,  9 Dec 2022 19:30:23 -0800
Message-Id: <20221210033033.662553-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH0PR10MB5084:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a229552-0e18-45eb-d2c6-08dada5eed2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8i7WG/IQqYvSFALwRJBDE6sP9NDt6GA8y6tYR96PCbvR04zvDkk5kcPOTv2jHyl3+Buo5RYpbATJzvfVBZmZUQuVFdm6B9NFVdFfn9A2/fF6Vo0BccfFfJ1y3+53JDmjwAO4QZ/+rVW/uEtfFp9Ed7m+IS6lmJxcQrJANFAKbo8tOpzudjGvpqoVebg7VeBMbWQkXYqbPUjWyKcIxkZY80T4M4tkXNys2CQfZqatDy9MPgVftRHULkNnWcCOdQcmFc04ebOq7HpDAOFs724/Gero7KBpF0nOZqEFVJOxaYCiE8nKsIXch1Vl5FgHegd/hW7S84vdI7LBG/76xqSxvfHEzfIRsL5egjAgRd81/f1J5E4FYahExpWLwowq/MwznCH4vBrsVLYwNXvp3M1jhVXJzqMXvo8RNftEANFKceQDrG4CGwOy1a0XMVamNnfaHNriqjtnSSuEBn4ke6KpSh8YcT9F220CEESL159YIAAR3epYsBmT05qIkilQ2ICFUjlV2a4jdHNR3RaVppPx7NTBLYqmp9+2jG3g3gnnwR0t7ogzcsxRscTV72IUvqDlGiqu91LqS2uVXdK7iiuj/dU4tGHdSoPwUTjwLMqSgdIcnT3vAcL8wwTwAk7s4BL85fLKQh3aesFGMkklWu4K/fgsUOrZp5Eu8hcjXjUXqUeF/Y99uV8Ujo+cCuPNsHFQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(346002)(136003)(396003)(376002)(366004)(451199015)(66899015)(2906002)(6506007)(44832011)(7416002)(5660300002)(7406005)(83380400001)(36756003)(66556008)(8936002)(66476007)(4326008)(8676002)(41300700001)(86362001)(316002)(186003)(1076003)(6512007)(26005)(52116002)(6666004)(2616005)(54906003)(66946007)(38100700002)(478600001)(38350700002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q003VGxzWlNjOFhsTldERmtackVXMGU3TG04cDhUOVZwRUNCK3JhQXpzbnl6?=
 =?utf-8?B?a3ZIMlhJOWlKMENuL01mTXFpZnhEQU1MUGEvbDN6bTNLV0hlWm1TK0dpZENm?=
 =?utf-8?B?dFo5OTVnSEJDMVBpVklNemVBWkIvUmxJbWFGd3c1cGVHMWV5UDdLOWdza0o4?=
 =?utf-8?B?Vmh2bnF3Uys2a3VmTkxQYjNpc3FyZ1JzSXR2Q0tUc1YwR0JaQWFxcDBKVUNu?=
 =?utf-8?B?WEpLbFR5SWVnOFU4RXMrbnVoeWcrYXhPUGpWQnIzcUhvMUJMV1FNN0VMVFZB?=
 =?utf-8?B?SnhzMHhFSmNsYUZTVktYRTRWbVZEcU5vU0I2aGJuUi9NSXM4MklwMUF2eG53?=
 =?utf-8?B?Y3V3SmdtaGF6NW9WSm5LSkxoKzVCc3l4emhTcGVQTE5LZWhhSkd0YTZWQXgw?=
 =?utf-8?B?a1NkUlNNYU9GVFUzQ3VhQ1h6L0YzV2lSb3NlUTN1dm9Cak1QMDFyc3JVSC9h?=
 =?utf-8?B?WnlUb1lUbGhqdjd2NHpIL0xjSHM2dGhocHZ1dnFvOVFOQTdDWTJLVEdCcE45?=
 =?utf-8?B?K1FNV3ZUNmJ5cHRwVFFIKzZjeFNrS1NUdVhpVXA4VWFHdkVXYTk3M3ZpOVNB?=
 =?utf-8?B?S3lHbHFnZ2FVVnZmSnMybStRR2N4T2x3NiszU1NrZFFKLzVFSTdFbk9YTGMw?=
 =?utf-8?B?dzNRSDE3d3d2RmlJbzdCUGRRakdjTFZ5c3F6amtHQW92M1dNWG1DU1Y3UXc3?=
 =?utf-8?B?VnE2NnJPNlQ1WXhQSzJ4eHpqYUo5SnBISmFaa2I2aDMvbUgzamVVdXlFOEh2?=
 =?utf-8?B?MzcvcmUrTkFrajBpOEZONmZwd29RNkhUTUtXdnFocVAwQmN3eUtlU2tRWGxJ?=
 =?utf-8?B?OWxiM1hjeEpLRmJwTFM1S3hXTnJ6RlEzNy9tUEI2Y1dSMkpBR3VPYW4yUFds?=
 =?utf-8?B?QjRkWVN6ZEpPRk1uWFJGeGlVcW95TmpINGhCMTdMTk02MlQvVzNrUGprYnND?=
 =?utf-8?B?SmtLSEFmT3VpV0t0UXJRdkdjakdaZzFyTmpSR0lUUDc4NTdXd1NZaFkxR21L?=
 =?utf-8?B?MFJjL3JTNE9ReEg2c2FoNDlrU2kyZ1JUWmV4ZDVFM3VTUUFIdmI3c3YvZkhB?=
 =?utf-8?B?V3Vmb25SNGdWcmNOS2I0YlVqWWIwSlFueUFIV3NKZmlocStva3lGYkpyc3h5?=
 =?utf-8?B?aWRjcGRrbzJoWUxLL3c3OUdrNWk4cXgxWVJqdTlxamc0bnlPN1lEeTErNTMx?=
 =?utf-8?B?dm9NZXFCclI0dDZ5SzZwSG9FQWNtU1RXUUEyU00xc0VRL3NJeE5YbE9Ga0w5?=
 =?utf-8?B?c2g2TWZuWG1kc0dNbkRmZTdIS3VKbVlPOVBjaEgrVzdKUGZmdVZyTU5UK0JD?=
 =?utf-8?B?Y1kySEoxMjVUc0YyelJxNkNkQnhHZXdwQ0w2Y0NXQyt3OEZLMVR0eGt4RVVs?=
 =?utf-8?B?MEx2T1NPcmp0bkEzeDA1MFp0K04xNnY5YVJJZFFERThVNEJFL2FHL3I4MTRZ?=
 =?utf-8?B?dXNkSzYyN3RBS3Y0U2pJSHVhVVM1aXlWZHdodjNPQ3hvYXpuaitSNkJWNWk0?=
 =?utf-8?B?eTFlOE5VSjRmK3B5akJVQk5XUUx0MHllM044ZU9jWFJiVFZWeWxrU3dpNko5?=
 =?utf-8?B?YlVyY0t0Nm1jZTRYWkRxeG1KdlMwd21vRHN1OUJYWmF5SlNxZ2JteGttK2wv?=
 =?utf-8?B?ayswcnk0SE1VbmJpRHk2dE5lUXNCNHBaS2tuMUZRV1NtQTkzRTRmcjhvL1JL?=
 =?utf-8?B?MCtGbW8vZnBVS2VwbHV6UUU0YVVNNFM5bFQxUmRkM2hjdkp5WUMvV1JiekNO?=
 =?utf-8?B?L0ZvQTVJWFlHempwR1NiOFBNZnNKS0VPeDM4T2t0K2xEd3M5b3I5cVJTMWhu?=
 =?utf-8?B?NXNTaitOR09mZ2huaUR4Z1Z6U1NiUlNjU25QQVNEdjFhdWg2amZ4UmZxNVIr?=
 =?utf-8?B?b2JIQ1N1QmJRTE1NcjJ4cGRES2w3YWJXblYrRDMxdUZ1cXBtNG05MlZJNDZv?=
 =?utf-8?B?eU5aRU5PUXU0TlZoZ0dmbjI5UC82WCtiRU52cGlmYmwzMW52aVRiNFJVTFp1?=
 =?utf-8?B?NmEvN0NuWlozTUo3cXZlSTV6M29OUnhRRXlZNUJkM2ZPS3FZcERPSnYybjJQ?=
 =?utf-8?B?YnV0aUZGblUxc3lXQUhxdzVRNDM5MVcxSENoalBtKzZWOFFqU2VTd2QzaGh5?=
 =?utf-8?B?NzVLOHpYWFNDMC8yK2REYkdNVUdYZVRUN3BJRllqcDRZSnpSNExydllnYnh2?=
 =?utf-8?B?YXc9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a229552-0e18-45eb-d2c6-08dada5eed2d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 03:30:47.1392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H8yvUowUnffVg4cuJeGf0Oqmmj1v9+Xh6S+X5jwIWaFgtFcMCZ7hXAeMvYtdvKDh+PM3ellGLnYCfyAoARUxPDKn7YL7jUxDYlLxMUXMqgU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5084
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

