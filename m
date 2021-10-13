Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F2D42CDC6
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhJMW0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:26:24 -0400
Received: from mail-db8eur05on2069.outbound.protection.outlook.com ([40.107.20.69]:19889
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230363AbhJMW0X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 18:26:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqiOW7VmkgXLCwj8YS9068G/uFeZ7IvjnAG5HV/pfi6Gew55Gw1Xnsgbo+ptspEIVdg8DeYJXOwDZcXJaV8dwkCQGjoLtL8d3KIbf5gKeh7iJ+Qvfe0mhoQzmmJcZlw3WXZXSVq5FA7loFqj/ETTIrUmrIJ7ZZnY0FBVbOlZYWBQtmAws+nrjCpYGzYJjVbWjZ56VZnJzjlyH7WjwlkLpeoDJ4bJ1h7cgPAHX77N5jDvzhvVIglPcOcaiOcPDQf3yzO3Uf3koJVSY1cC4/ZNKQ3TW8Vcr/WIkzKtuPpeH3B6nfdKM+OHc9QCifkt9awmdmALyHTd17eFz2zpVhd2HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oH3Cf0+kDwHP8HUqIRwf3yb965tCxPp+sCnKRScxRww=;
 b=g5HMo0xARwMZTlOYmlYzj6eMm6HRuznRZ4bF32cxOVRG+t43H436SpXwiRJ7khS3WFL35uH6vCqM3frYQpLOChFEdZsru0yx5KARISw6M6EHPYn9evhiQGo6gYHNH7uRyfFwU1aYOmz+q2v/2e089lez6xWmNfhygIQ1qS22WYRQs3sIbgz9t3Yxmp7BWl/Cw5Z39mTECrnCU0D4NYtxTrtw1z39esJYMCPJqFkGYC0GAifR9yxPeL5GsS/ZDWck5Pu5O3v7oDmXOBX3mnPaaKoXzkELC/Skscfpe2j/AKwQOh/eZBfXxFjZ7t1UWpLOIHqrrm4JuFNCIGaN3Ka6Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oH3Cf0+kDwHP8HUqIRwf3yb965tCxPp+sCnKRScxRww=;
 b=COjqUNQHNymt8Ubl84hg0+NoKd7xMmDx0VnAzrJGLtmPxm+Dg5K1AVgwhl8DTS3WEGri3mCKanPzKsGVEmaKT93E4l/Z1vfDjc4eYVwiS8l/OYRsONPiF1SuCyoZWrWD4a3xC+zJP2HsQZhXxvPBsL4arzgbUnkVKILuUTpMQLs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4816.eurprd04.prod.outlook.com (2603:10a6:803:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Wed, 13 Oct
 2021 22:24:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 22:24:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 0/6] New RGMII delay DT bindings for the SJA1105 DSA driver
Date:   Thu, 14 Oct 2021 01:23:07 +0300
Message-Id: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0154.eurprd05.prod.outlook.com
 (2603:10a6:207:3::32) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM3PR05CA0154.eurprd05.prod.outlook.com (2603:10a6:207:3::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 13 Oct 2021 22:24:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9ccdfc6-1b91-459e-6aa5-08d98e9831a3
X-MS-TrafficTypeDiagnostic: VI1PR04MB4816:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4816D04DC2AA8FEB90412E45E0B79@VI1PR04MB4816.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w0uKt0wn8MOgs6XSIws8YEdAcwXi3yCl5GscyR4ipa/viR9ei6RxkEhFuWkhHB30Rzqk9bHUCpDNn36+5IO1L9u4LVNukDkSxNQfyuAuAVyncRSwyl6ciwMHa7zrRu8r1VojU3O5QWw8foKExRuIbfSyf/tw7tIRwNXCWdoQHmz68fOz/tTWZYovvIPQcBQ+IQPQr2Qwd1IRHcBOnA+OKEVRABpQf81eSZK6+C6euu/bZ4GqzgDKNKivgLLXmKZ4LonUafh70AKrGrvHrj0nCOk87RKErOpc/M93/HMLkjUvP4tlHtbPkqPj73bDyZJawZx1JZXhcoXpEEOtuQdoXSfpdggeNV3tcoAzSLES9ogOZK+qkjJ0wZlL/d7wtKV9EA8EUFRdTxLde4NkOGH7eN483aLT6lRui+b7r3L3iBF6A2FyVAwsj/Xrh6zHI4RbxsN2kNzKY8EysjebOZGhYBbepfn+DMdGYaE43SJqzsgpZVn+YSZSC3Gw/EU5ejUhJkL5LsanrpqhmBco4FJjaaviitXfT1ix8pBzOH/tvJfzJHI+yf7h2DWyMic8mirh/KvCEa/KUF/U7hugDpAxLf/P89IBiAu8FgK0Jx93xVTyAbuXV//S+1dFJnTLatIE65jXYo3vLeOKxpgtUOYGgfNwQx8ljv5g1N8+tMheiHyVKlCO7UoMp0zNqf/z7ZEfwY/DqIl0bUv2V/MB93PoFKLHOmikD/dDocfA1FYiPL2G8pBCbGwC6VvDSfKqG3cKByd2qDQPNVvE0bqmZgcAQzOxYBQUDzWtrbsMARFBKkU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(956004)(38350700002)(1076003)(38100700002)(6666004)(2616005)(6486002)(26005)(316002)(54906003)(110136005)(2906002)(8676002)(6506007)(36756003)(66946007)(6512007)(66556008)(66476007)(8936002)(186003)(4326008)(83380400001)(86362001)(508600001)(44832011)(5660300002)(52116002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L/6E3LJpqeyP7wQ3uVBWxfU6TPo7pgE3u6b91mbdcjQipUFy+UitfPPICmm+?=
 =?us-ascii?Q?RunrZirR/WEyYWCFaOd8u3u3xnpl9A+DmmctozOkPagxvK1ZYj8NcSWrXpCF?=
 =?us-ascii?Q?glLT1DqQKlGmhf4iHuW6Ecrew4iahIWRthJA/pVgOaPB+oyPWB0oPREBfU23?=
 =?us-ascii?Q?pB243q4aqvy0U2BOZvhgAVfHaNbG6yKEw/EswckugsXtNrdpKsD7AOB+ZyUW?=
 =?us-ascii?Q?hggSEVoKFaLJzQ5nBDjWk2tFv3suMbp2zhpR55TDwyjhxrxGbEIwfj3B0Bk3?=
 =?us-ascii?Q?ImtEUX9u34XEQCwv8iZF2h+nrtH1CTlOj9uIbb7ix+7FSPnkT/7ZSxsIf5gJ?=
 =?us-ascii?Q?748Bc3z5JRfZqs83AF7Qqxa9f13ufeAQmu83hd6JTGlGSIb3qFbdFbnbsw7i?=
 =?us-ascii?Q?k/twYvkLIjmJ9jH9nRwL3tGHx7Ojttx/x2qQEBAd3ttzG8e42CJIC8hIRb5X?=
 =?us-ascii?Q?jawX0h/Ghlj4k7Ex/PGC02fKFgJinSr+BtU4yRe0bEHvCgAwfJ67wZ8KvPKs?=
 =?us-ascii?Q?9d32w5EO+rxlcyh1CaOb0S0fmqBqd8ScSUuUKJe9Hgtr9Z1Z33zvZL7Wbk+o?=
 =?us-ascii?Q?zFuxlp0KW/KnGBaWiPIyKlnVzdudKUvY+RvqDWMx94emBLR5UJb0GbpDv389?=
 =?us-ascii?Q?Abtc9zqbTsmGxNfgqC/8OSII+g4v6RZf+TyY7LnYHvSMhTqMuJq0C52wD1Si?=
 =?us-ascii?Q?c1t4ypZotmS1iVIPytnD8ToCdjI2uHJ8IMpLu2c2GX5cn9tXiZpDlvGNhtbR?=
 =?us-ascii?Q?q6qMbE2aBZ3ArKtbVgSwvJy+XLItPlaLKt3FBle6SB5ed/TtT8aS5QbGqnT+?=
 =?us-ascii?Q?VN8ztg32pDLf9xs0EWBi78AIp3Ir3tKuYHQJtKqgoHPy6BLo1pZAntvoXO+D?=
 =?us-ascii?Q?YYp8gOkerRytmkR4c0szr7OmI6Z4Qb/wBpuuRBvI/9/oCc2Dgyd81n4zKrRu?=
 =?us-ascii?Q?b6iLYvVXjYLP2S/6qQ8rQwXxtCc4J5szKlj2iR7xZ8aYQouDZPj2i4l7+wXt?=
 =?us-ascii?Q?SPkICTt+ySxB0rJLeQhQGMSgBGMZtO02wRUAi1OQW7n+Uk1BBzHCIW+AMbsg?=
 =?us-ascii?Q?e41ouCEBKemio7y9yQcgjHKYZxqqL3DFyMI/7WE2qKzA62dVQXvVOE9KrKVW?=
 =?us-ascii?Q?prdqlB0mfm6dyO4e9y1wkihsczQWB78R8lWa5aBmjCHqTeANTsOIYo7zFEbr?=
 =?us-ascii?Q?BaLRapSj53GTejwzWlbGITaCxnkhpt1zG8LiNud57okMEadFt1awRUIoFrr4?=
 =?us-ascii?Q?g6ElyVqWAAdS9ukP7zYU4Fch5BC4PmaHhkOEvcgrNqKCv+PDArEhH9xgliKw?=
 =?us-ascii?Q?BhpbwJbxFrtqXcFmt6iTeV/f?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ccdfc6-1b91-459e-6aa5-08d98e9831a3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 22:24:17.0491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d0Wbu7tLWgCbHQc1sEjpTaLZHCtL0Ms9sEc4+J3bhWyzz/5Y+sY6VTIR7yt3DQmvCWMcHNOnwELTXp6Coe9sBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4816
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During recent reviews I've been telling people that new MAC drivers
should adopt a certain DT binding format for RGMII delays in order to
avoid conflicting interpretations. Some suggestions were better received
than others, and it appears we are still far from a consensus.

Part of the problem seems to be that there are still drivers that apply
RGMII delays based on an incorrect interpretation of the device tree,
and these serve as a bad example for others.
I happen to maintain one of those drivers and I am able to test it, so I
figure that one of the ways in which I can make a change is to stop
providing a bad example.

Therefore, this series adds support for the "rx-internal-delay-ps" and
"tx-internal-delay-ps" properties inside sja1105 switch port DT nodes,
and if these are present, they will decide what RGMII delays will the
driver apply.

The in-tree device trees are also updated to follow the new format, as
well as the schema validator.

I assume it's okay to get all changes merged in through the same tree
(net-next). Although the DTS changes could be split, if needed - the
driver works with or without them. There is one more DTS which should be
changed, which is in Shawn's tree but not in net-next:
https://git.kernel.org/pub/scm/linux/kernel/git/shawnguo/linux.git/tree/arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts?h=for-next
For that, I'd have to send a separate patch.

Vladimir Oltean (6):
  ARM: dts: imx6qp-prtwd3: update RGMII delays for sja1105 switch
  ARM: dts: ls1021a-tsn: update RGMII delays for sja1105 switch
  dt-bindings: net: dsa: sja1105: fix example so all ports have a
    phy-handle of fixed-link
  dt-bindings: net: dsa: inherit the ethernet-controller DT schema
  dt-bindings: net: dsa: sja1105: add {rx,tx}-internal-delay-ps
  net: dsa: sja1105: parse {rx,tx}-internal-delay-ps properties for
    RGMII delays

 .../devicetree/bindings/net/dsa/dsa.yaml      |  7 ++
 .../bindings/net/dsa/nxp,sja1105.yaml         | 43 +++++++++
 arch/arm/boot/dts/imx6qp-prtwd3.dts           |  2 +
 arch/arm/boot/dts/ls1021a-tsn.dts             |  2 +
 drivers/net/dsa/sja1105/sja1105.h             | 25 ++++-
 drivers/net/dsa/sja1105/sja1105_clocking.c    | 35 +++----
 drivers/net/dsa/sja1105/sja1105_main.c        | 94 ++++++++++++++-----
 7 files changed, 161 insertions(+), 47 deletions(-)

-- 
2.25.1

