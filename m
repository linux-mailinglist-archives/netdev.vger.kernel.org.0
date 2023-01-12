Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F81667DF5
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 19:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240364AbjALSWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 13:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240313AbjALSVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 13:21:23 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E6B140FE;
        Thu, 12 Jan 2023 09:56:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJTZarWaoKsJHulIKgLpaed9kY01ou280WwJLdddi8bhV7568s865Et43eq6jFDJQmQM+etXoRy3dxBLkhqUNtBl8V2d5r+9BqsMgRx0O0AQSIN5Q9NvPIJPllpKsolb4lpxRmaYMz96qXVBisRbUCuxMTp3KPf5g2EEoWhUAV0gJE76DXJVEArWePbV8EgJmaylLwvGt9kkt7SYBMGSDZlpBdWhdvnJIAPPLk3NCnCSZMdPj2/SaZQGJN0wwKl7Z0KbATclklQxA2DnDiYKgz+db401mLEPHex4HRNMsLZh3WwAoMrOc9ZVa5IXRPiz3hqFHzOOuNUJY8Ed14cM9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L9No1CGaAX6oJczw7gY4fqsz4RLNzX1qUr0FD+GZuH8=;
 b=hyTKmc9HYwq+SLddTgf+S2Sw+5m3VLcmwQ3mmRTlnXwKx8+gZgUJXOQjwXSUOqRm9LHZ+b0LrhpH1IJ35s5QjeHsWVqFJJXO/UknMJghLi+DeHJd60pNzBtJ4cnX5MihDaANc4YktUdDKpZoEqr4uGvDfkIvnXu+c6NYImWrWsSsClxgxa4127mXlupuf7Y4odbzb4vjY4VWMA/GJECJyeBQfom7xHEKwfvyzxicpAQnqrJQLkS137RcblWc8hVyF7dds0hzrK9vpBPi1gAscCWPZESbFIBqxHO//2LPNi17+dATiirY7aMtoX6Lu1VSMfL7kuYvCE49ruAG2VL3pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9No1CGaAX6oJczw7gY4fqsz4RLNzX1qUr0FD+GZuH8=;
 b=U4lpfV6FAe5vRw2zJ9gXacY/YMg14e1rcIHeWPyoBcsNzGp2S0gD7QQOcY5WAg5yIOdy2r7LC7pBclOgKToJlfyFBJ9I0tkqeA8i0q5G1LIZg5rVv8e0Ms6SlVbA0rlottTjMiHROgX13hNE6cSpZlE9TUPDzVcoIRwZvGY3OT0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SN7PR10MB6548.namprd10.prod.outlook.com
 (2603:10b6:806:2ab::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 17:56:43 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6002.012; Thu, 12 Jan 2023
 17:56:43 +0000
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
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v7 net-next 04/10] dt-bindings: net: dsa: utilize base definitions for standard dsa switches
Date:   Thu, 12 Jan 2023 07:56:07 -1000
Message-Id: <20230112175613.18211-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112175613.18211-1-colin.foster@in-advantage.com>
References: <20230112175613.18211-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::7) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SN7PR10MB6548:EE_
X-MS-Office365-Filtering-Correlation-Id: b281a153-d04b-43b1-4a98-08daf4c65cf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DtQTfhXbJJYrzwlf0F7Xbfh7vJgqNiUJNKHg2xkK1PyESIOVNmD2KrFwFHAWVRmEwzDnCWDJfo+FZyAmIgvcTrQk7xM+1/c1k27ihuCSurfzTZvvtA/2bXI29LWYRtfIBX1blpvF5CpWIIbrSEBiWPO/wVFRh6pSNTYGrbKDzgTpg/5WV9clEzPCl2QaySnrKQ81MgOj3HNjWZrDEyACDJdjnvPN8YKD3hLxpVRfJG0/kcESf7jNZu7Jy3M7z7tuPGxqlPiqmkm2rtc1iXsr6zMIoLH8e+fnCu4xV2ned+U5DUnogzeTurWLbnifTwfc5mVAOWn/Va1qXaZNb7XkH0YP9QlUJk/0HCk+wWcST5agHu7g6deYQ7KqgUK45xQU9QR8wy9VW9Oo9F8zBKQqUEzlbX2egofXzc5EA13V83N+Kwkjql+Y9JY5AqXoNCksOTBC5SK3V41yX1xVLv28g4Yj7Ov+s/tosTTzyAw3RGLiLaYupmpXuDtL3ujX9SqJyWPXtesj2byFWPovNhBA0Smo0D5Dure1LcoqwT1rocRdRAj60KNxGe+tQCwceysoHavnD6XHGnAzI/BH/cuzq6UWiDXUL/PIBzdmfZJxkO5jVz3spC25RsIsiIZQxy0nTJ+nN1Y2onzM8SKRbTYcLEszIllVBAkPQ+D1KVByg8U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(39840400004)(366004)(346002)(451199015)(66476007)(41300700001)(66556008)(66946007)(8676002)(7406005)(5660300002)(7416002)(316002)(44832011)(54906003)(4326008)(8936002)(2906002)(86362001)(38100700002)(966005)(478600001)(36756003)(6486002)(52116002)(6666004)(186003)(6506007)(1076003)(2616005)(6512007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2diR0YvcFFoSG10VHpNVUZvSzM5TjZHSHhQUmlwTGswR3ZVbHRVcGNQcHNx?=
 =?utf-8?B?Y0lzVDk3Y3lCSW1HbVYzTnA2NWtIM2VYK3pVVC9kNXZHTnBnQ3RkeE1SRTBj?=
 =?utf-8?B?NVZrZmQ0RTlueU9qU25pRG1oaFdTSFpTYzFrb1RuaGc3RDBIMGVIVS9leXdZ?=
 =?utf-8?B?QmMyOTVvMkhSc200dTVJbWwxaklBN3F1aEFqN0cva0llZkNxc1JrN1FCamFv?=
 =?utf-8?B?Wjc3bmZFRTZDWVQ5eEJJazlEOWdiNGFUcjExdGpWSzlYQTIzR0Zlb3lYMjhV?=
 =?utf-8?B?VWJ3WnFNMkZnRFo3T0NSRE1MZGRFL2gzaHdSelFMcHNHbVY0K2wvK3J0WkI4?=
 =?utf-8?B?cXJ4RU1BcFJxZ083TXBMQk5kbGlkczgzUnRlaDRxVlJvVXc5TGZhN1dPaGdw?=
 =?utf-8?B?WDhJVkZwWnZLdXluL3N4dTJtZjNjSXB5NVpOODdUb3dKR2xjYVVmUWVxM0l4?=
 =?utf-8?B?c05IQ0liQjQyU0hOQVdHQzgvTmh6ZHlXeXdscVFCL1JTcFdTL2Q3UlJuQnhP?=
 =?utf-8?B?MHRIb3RPb1NNNjg1b0lhMUZXYm1kWXVDV08rd0EyMmUrc01YWGRQRlpBeDJm?=
 =?utf-8?B?eVVJWmRjZkthMm5vMk9qdkJkVHllM28wdjFCOXFQeHNrQXNFc3IvOWhmR3hE?=
 =?utf-8?B?TVpVcnE0V2ZpZEw3UUxwZnNjdXROTU1meFdvaWIrOWVOcndrMExUNm82bEtp?=
 =?utf-8?B?bWgzRlo0WkVyMnQ4dXlJMlhCVGRjNXU5c09PTUxnYlRweWh0VXUrYlpMb3R2?=
 =?utf-8?B?TkJtM1UrcW02TFlNeWJkUUkxT0ZpSXFmaEUwcnVIbk5jWmw0ZTNzK3pyY2Z4?=
 =?utf-8?B?NHV1bGF0TGdVWnhsczhkNEdTUXJ2VGp3N21xUlNVdkpaN1lrVU1md1pyWmpp?=
 =?utf-8?B?ZUlDRXBUYmJTcG8wU2dZaDIrN3lKYSs4K3BiQnpUV0ZsaTZzOTZYeEJDSVBn?=
 =?utf-8?B?MFZFdUdNbmZWTStlQ3B2WDdIckpqME01NmUrNlNFc0NBdWVsNVdxdjU0cm02?=
 =?utf-8?B?c0taR3I5S0VsQjRIbmdtTW5LSi9iLzRPUjludnpibWJGMVI2UXJYNWF2N3JC?=
 =?utf-8?B?dEpjcTk0UThkZTYvTWY0RFlNU3hMQllRSllVNGwwUGpwamRNa0k2cnh5c2xO?=
 =?utf-8?B?OWQzMDYrNWt1Ny9wUS90UHZjRDI3WTlMYjlUOHFwN2hOcVlvVk1scjVxdUJn?=
 =?utf-8?B?bGJrZGI2TnplYzBSUFk1aGpORUdaTUlGK24vSVh4L3RnR21xU0dFSGI3OGZh?=
 =?utf-8?B?a0Jtc24wczdrZG42UHVSZUM1bHU0MUFubGFNaGNEZWRHUTlqWEZzd1BuaFhD?=
 =?utf-8?B?NmY0SlkyM2ZJMSsxTHljS0ZHT1ZVazF6RGFEUWVvSng1azhUblJpSS90T0RP?=
 =?utf-8?B?SndEUHREUHIvME9MUVpNOWR6eTRaS0QxQTBMY0lLYkdSY2I4cHhOQUpSdWNr?=
 =?utf-8?B?bUZrOW9OREhhdHdNNTRZa1VncVc3OHRYeGN1bFVSaHlwc3RDSEYwa3hOQXR6?=
 =?utf-8?B?SDZacWxJekhuMkZFSnNuV2ZCaFJ6Y3dITk5TcXM2ZjJuZTdzallrSDNBcGh1?=
 =?utf-8?B?eU9LN21EYWd2Z1k5RTV4NFMzaHdiL3h1U2lxeG5HVytkNGRqUTJsVFQzcVBr?=
 =?utf-8?B?TzhGaG5jcG95U0I5VTN2a1VCSWRyK2lKZmVQOElSMjN4UkZndS9GdDJvOUxo?=
 =?utf-8?B?Q1JMck5lTnl6QWFpTTBVNWxpWUxkWE1ycmYyMzUrMm9MZ2dFZitCZnp0UTBD?=
 =?utf-8?B?MU9OWSt1Z3MyeVVNYnUyV1RsMDNUejllMmZDTCt3L3lFQXRQUnlvaW9IN3Bs?=
 =?utf-8?B?ZzVuK1VQMkprdXJxWTVtU1hWWm5BQSs2NkgxckN5K0VvMkVKc2JkbDhDckZa?=
 =?utf-8?B?dFkvU0x3aWt0cDNMU3Z0M2sycTBLNVh4MXd1RGlpZjcxbjZJNWRaazBDYzA2?=
 =?utf-8?B?alM0cmxRNytPSTE1YmthSjNXeXdRV3NVWXpmekdQWFlVZVZMbjZocVJzWG1O?=
 =?utf-8?B?bWI3OFdNWjNhSnNld1hPM05PNnlOYnA3Q2pCbWxxTEk0bFBqTC9RV2JGWnlu?=
 =?utf-8?B?THI1cFd0U0YvU1kxRW9tUitUVHhRakR2d2dweG5MYXZ5Wnk3cFhYTkRlcFBN?=
 =?utf-8?B?N1RHK2t3QWl1UCtGQlpvemhEV0R2b3JnTWZHWHhBcFRKMjYyOFNGeksyY0dP?=
 =?utf-8?B?Y2NKNkd1czBCMWwxSGJiZ3AvKzlqd3BFT3ExSGR1ek9xa2RPZjJrWGN4OE1G?=
 =?utf-8?Q?Yxz8D5jtQERj/IAg7Lt/iG14Dynj5Ha4eiDviC7M5I=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b281a153-d04b-43b1-4a98-08daf4c65cf9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 17:56:42.9545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0m2W3LTtPRdXj+g3Psy6Z9NmRqAF+UxQniCGQtDZ0+1eQKs8UOFnvhcoIU0/OieE54Q030/Rf+9j4XIzOohqDCzjdV/Ga6jN/yqMRiVbMwA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6548
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA switches can fall into one of two categories: switches where all ports
follow standard '(ethernet-)?port' properties, and switches that have
additional properties for the ports.

The scenario where DSA ports are all standardized can be handled by
switches with a reference to the new 'dsa.yaml#/$defs/ethernet-ports'.

The scenario where DSA ports require additional properties can reference
'$dsa.yaml#' directly. This will allow switches to reference these standard
definitions of the DSA switch, but add additional properties under the port
nodes.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Alvin Šipraga <alsi@bang-olufsen.dk> # realtek
Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---

v5 -> v7
  * No change

v4 -> v5
  * Add Rob Reviewed, Arınç Acked
  * Defer the removal of "^(ethernet-)?switch(@.*)?$" in dsa.yaml until a
    later patch
  * Undo the move of ethernet switch ports description in mediatek,mt7530.yaml
  * Fix typos in commit message

v3 -> v4
  * Rename "$defs/base" to "$defs/ethernet-ports" to avoid implication of a
    "base class" and fix commit message accordingly
  * Add the following to the common etherent-ports node:
      "additionalProperties: false"
      "#address-cells" property
      "#size-cells" property
  * Fix "etherenet-ports@[0-9]+" to correctly be "ethernet-port@[0-9]+"
  * Remove unnecessary newline
  * Apply changes to mediatek,mt7530.yaml that were previously in a separate patch
  * Add Reviewed and Acked tags

v3
  * New patch

---
 .../bindings/net/dsa/arrow,xrs700x.yaml       |  2 +-
 .../devicetree/bindings/net/dsa/brcm,b53.yaml |  2 +-
 .../devicetree/bindings/net/dsa/dsa.yaml      | 22 +++++++++++++++++++
 .../net/dsa/hirschmann,hellcreek.yaml         |  2 +-
 .../bindings/net/dsa/mediatek,mt7530.yaml     |  5 +----
 .../bindings/net/dsa/microchip,ksz.yaml       |  2 +-
 .../bindings/net/dsa/microchip,lan937x.yaml   |  2 +-
 .../bindings/net/dsa/mscc,ocelot.yaml         |  2 +-
 .../bindings/net/dsa/nxp,sja1105.yaml         |  2 +-
 .../devicetree/bindings/net/dsa/realtek.yaml  |  2 +-
 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |  2 +-
 11 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
index 2a6d126606ca..9565a7402146 100644
--- a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Arrow SpeedChips XRS7000 Series Switch
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
 
 maintainers:
   - George McCollister <george.mccollister@gmail.com>
diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
index 1219b830b1a4..5bef4128d175 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
@@ -66,7 +66,7 @@ required:
   - reg
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index e189fcc83fc4..efaa94cb89ae 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -58,4 +58,26 @@ oneOf:
 
 additionalProperties: true
 
+$defs:
+  ethernet-ports:
+    description: A DSA switch without any extra port properties
+    $ref: '#/'
+
+    patternProperties:
+      "^(ethernet-)?ports$":
+        type: object
+        additionalProperties: false
+
+        properties:
+          '#address-cells':
+            const: 1
+          '#size-cells':
+            const: 0
+
+        patternProperties:
+          "^(ethernet-)?port@[0-9]+$":
+            description: Ethernet switch ports
+            $ref: dsa-port.yaml#
+            unevaluatedProperties: false
+
 ...
diff --git a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
index 447589b01e8e..4021b054f684 100644
--- a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Hirschmann Hellcreek TSN Switch
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
 
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index f2e9ff3f580b..20312f5d1944 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -157,9 +157,6 @@ patternProperties:
     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
         type: object
-        description: Ethernet switch ports
-
-        unevaluatedProperties: false
 
         properties:
           reg:
@@ -238,7 +235,7 @@ $defs:
                       - sgmii
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
   - if:
       required:
         - mediatek,mcm
diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
index 4da75b1f9533..a4b53434c85c 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -11,7 +11,7 @@ maintainers:
   - Woojung Huh <Woojung.Huh@microchip.com>
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
   - $ref: /schemas/spi/spi-peripheral-props.yaml#
 
 properties:
diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
index b34de303966b..8d7e878b84dc 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
@@ -10,7 +10,7 @@ maintainers:
   - UNGLinuxDriver@microchip.com
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
index 347a0e1b3d3f..fe02d05196e4 100644
--- a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
@@ -78,7 +78,7 @@ required:
   - reg
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index df98a16e4e75..9a64ed658745 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -13,7 +13,7 @@ description:
   depends on the SPI bus master driver.
 
 allOf:
-  - $ref: "dsa.yaml#"
+  - $ref: dsa.yaml#/$defs/ethernet-ports
   - $ref: /schemas/spi/spi-peripheral-props.yaml#
 
 maintainers:
diff --git a/Documentation/devicetree/bindings/net/dsa/realtek.yaml b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
index 1a7d45a8ad66..cfd69c2604ea 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Realtek switches for unmanaged switches
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
 
 maintainers:
   - Linus Walleij <linus.walleij@linaro.org>
diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
index 0a0d62b6c00e..833d2f68daa1 100644
--- a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
@@ -14,7 +14,7 @@ description: |
   handles 4 ports + 1 CPU management port.
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
 
 properties:
   compatible:
-- 
2.25.1

