Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320615850CD
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 15:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbiG2NV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 09:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236264AbiG2NVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 09:21:55 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2078.outbound.protection.outlook.com [40.107.22.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340CC6393E
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 06:21:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8Ep0lAe4QxYk10EaClpXnPw74FQxdZljW3sP9V4BhlrFBqA1kLiV/T5V91N+AkfuP8aXZjfVI7+OVB21qx04ozG5HdT+k97aEX2D4Bh4A/Nr7Er7ihxTGof2Ylefl337Se9aVt8r0CraCFDv0UYyiUDq8B82jJ63Bnr2ubEoLWwNTKTB4X0LCSgQPidGQwU8Agz8VwXZO+T3cw1nNo54ZCEz5taTo2cGoNwcY6mIkSsw0KkKcmvoPBHoZximfY6m7B7J+fsRAlY4EHMGAGm22g0OYzjXKTaEBh1anwuqF9acN1H42BWW6ylEheT/1AbtH2M86WAXod/VSt+eiuyKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bPIj9g+7xB+ZK1PaDd3mhwFp+t9PmHerfn2Vyh2ONz4=;
 b=gzEhCJGc8yQE1aHCrKvf6Od7+IQSZ4QxPdHmlc/RLyF9TXwiuk+S747Gt+k7hcyoG9KdYSkFR4oPWRrLtLctadvqpH1vPt9qh5Rw87FIs6wG1AoTo3GhnHs+VQwR9kpy96x6uH/WUZCcy+KKv+QMIDsL/P6PcltZOlOVZh8xBLkWHeausaDAWwb9AZHor2b9S9qZ2snCA2+2+OGN+7mAfHihq7RnBbkuKSl/lmvXZ7CTxUMofF5D0Ws8vs6AY76hTzuCYcZASyKxuGwXxdx77dfTzIHbIjqrlQCQQWS7SxfDBvcYwluV3s/qjEz0RM90PHXYcb90Dsy9w414jA8vrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bPIj9g+7xB+ZK1PaDd3mhwFp+t9PmHerfn2Vyh2ONz4=;
 b=szhExg4HtmVUmaKCcErbNUkEqkmGNI01wMXAqWVWFQRRXBwjRkhuCPDLyEzYWxUc/P5zO1tfvTFVE25KZ6GnIcYwEVElYcFAYYoD+Jd/PMVuPNBXeflLKyFZ9yIM4YaVyALRkERWrPVxEdR8JHhfIVqwTSKG3kyVXmGi6ktAhoY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7497.eurprd04.prod.outlook.com (2603:10a6:10:204::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Fri, 29 Jul
 2022 13:21:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.011; Fri, 29 Jul 2022
 13:21:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Subject: [PATCH v2 net-next 4/4] net: dsa: validate that DT nodes of shared ports have the properties they need
Date:   Fri, 29 Jul 2022 16:21:19 +0300
Message-Id: <20220729132119.1191227-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
References: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM8P251CA0022.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc863551-5e5a-4b13-33da-08da716549c5
X-MS-TrafficTypeDiagnostic: DBBPR04MB7497:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GKkb+mwGXhjVeagyZnbC7xpwABC/YeJ9cv2Orne/NGhe870L4xPcf0SrDwQmXCt1HcFu41GvYbYo2fWD5XN8+0hCRd/aat2evitA73Y70xdh9mpnx8yDiIhXmLq6VYWnN++ozgm/Eg4jGr0F091tfkaWH9hlcpEYw5FiN3RaSUjLcg5jg5aQseIQlYoMnBOzrp1094ltG4zro3UIPqjd7jOiRSih3K9tWrau47Em4Pl0ES+AThRTpuvHAjmiUC7dJzW9bXfahK7+Oo8ZQVu3pvHys/2msyPW3HfRXQW+lNHzY4Eb/ONMa9K+loxFtN3fNHPh/k0STLW2BErdUjTB7yj5YFA5VIfS0OoAM63273gxm/mojO6HG33+GQMP6f7bg2+i3bdgETO8GQPWhCqFBPxx3Vw0mqHFkD7Gpa/5cvqSMFHDP650C9gNrxT99zYBkOIGQYmcPW+DcFb84BRpsjhs1KlGP80v2Eezck73CVYICA1mSC55fyAhocvY3Y30hmNf/aAP/H/O+eUNY6mILpEhrQR38YvJZhPeIrB4YFnE5dYGZU1myazQDy2y87XPmYZf0vBhZ2pTk1L2JoF4AJ/kmOehtTa9k/cwO3AFbue4jXF7Bi1HegviFxr5XloEEF59SMs/GImunHXxWdmdU8I1SBYwZO7DUkjh0HDU5ejfy5C4G7yZExEyoL14loJsLQ4wg21x+P82FyJuLWtsvzYWJeyl6arC84rx8bjBnVpSox5TcDXTAFvIxwXqi1BtJffTW0/PE0PZnq6XdjiHhts+9FHfsTTI9U5YFsm3gKg/gL67MNUVcysevwQxOM+uLryWPJwH2CH6wzI9T/zvGCZ90Bv0ctqUloY+e0+V1+4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(1076003)(6486002)(2616005)(478600001)(52116002)(6512007)(6506007)(26005)(66574015)(966005)(38350700002)(186003)(38100700002)(41300700001)(83380400001)(7406005)(66476007)(5660300002)(4326008)(66556008)(8936002)(66946007)(30864003)(7416002)(36756003)(44832011)(6666004)(8676002)(15650500001)(54906003)(6916009)(316002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHI3aUJpclJUZDdiTVRsS3NFaTBsOW1oaXlyQTF2cExKeEpKWnlWa3orQjk0?=
 =?utf-8?B?S0xhR0hZckVmOVhaZFE2RTNadGViNmF6c0NndVpnM2dXYTB1bGFYKzNNRCtO?=
 =?utf-8?B?SkVnNFlwdERTUXIxdTVzUUN3SHBDM1FHS1RYVkJVazJ3NThRZUlFY3hXaUc5?=
 =?utf-8?B?cEVpcy9vNmlzSU9kYUx6VTFKNmI0blkyZWs2WUZyTkNmSTcvRkMrNnJ6VDhh?=
 =?utf-8?B?SlBtb0Rpb1Z1cENDdEhTNDdrallyYVVHMUtwZDhLWUhSNGoyTVpGSnFtUGR5?=
 =?utf-8?B?Vk12eE1lNFY1VVl0UER4NXNxS1A0L3dtcW5ReW0yazN1SzdWYW80QklJT0Rl?=
 =?utf-8?B?dmpydi9QTVBMK2x1OHBZZGhCN1MvTHpKekJuTkJQOTh2cmxoNjBOQzdPdkFi?=
 =?utf-8?B?Z0pzaWJPNFp2cm1nUUZIcVNRbXRKR2lOaWNRSWg4K21ETzJlQ3NJaFZNSEd4?=
 =?utf-8?B?NlB1T2wvU3hNUkxMa0FhcHQrRVk5c2lBR1JrMzZRV1gxY0grN2lzazdLeDVp?=
 =?utf-8?B?aEJqL2t3dlFWUUptZmhkamFZRFJYNURkQ0xQU1AwZzdUZDBCMDhGdnZKc2Fn?=
 =?utf-8?B?aExaUWtuTDlYUWhoVjBPdlZYa3ZJRGxSMzJCeldGTmk3WHVnYlBITkhVK2pa?=
 =?utf-8?B?aEl1QVNvWUpoNVV6NlM1ekRTa0pnZjdnbk04SHY4VUVwUUo3M3dzU3p1YjNI?=
 =?utf-8?B?U2w1MVFsUVVQNVMzeGV5Y2ZhNDdTdjBxeXIvaHE3dm9ERSsvS0FrOG85b2lv?=
 =?utf-8?B?NmlaOWxLTnl4RkZ1emR4cHRYa0VzZ25vbEV5N29BekdjN2wydVFUbnNjSllB?=
 =?utf-8?B?N2ZCWDE5aS9sTGpxK0Z1eXgvdWFZaGROVDlRRTE5UXYzQXJKN2xTV0s4bldC?=
 =?utf-8?B?NndwcTZvdWdpL005Rkl2MG9ZK1NXbUg1S2JrYjFWdldOeldGTFNsVU5VWEE4?=
 =?utf-8?B?OHJBeStCZUtnU2NINEZWM3M4UjBaRTNYSmZCaldkbEZudlhyZVdTbkM5RFM4?=
 =?utf-8?B?c3dTTEJoT2R2bXUzUldrUDY0UDZCY3EvTTAxSnZnMmtUNFVDbjVWMmR6T2g0?=
 =?utf-8?B?b05YTFl6MGtQNVZlNmJNTW1FN0RZcE9WUmc3WnlJdVV6RCtEQ00yQU5yVHBO?=
 =?utf-8?B?Zm9YbEtVOC84UEpMcmdWWTVkckNHSTFGcEQrU3BmQWV6L2hlaDE0cFp6K3VU?=
 =?utf-8?B?M3RpOHZFQW9FcmVTMTBkdEJkT3B0QmxZK1NUeUNQaldUclZ6bW1GQjZSckdD?=
 =?utf-8?B?SjhsRVhHZXdlWkdMbk1HbnRsT1grbGNRRS9jQW9FczY1aDBGYldiVUhXK0ZP?=
 =?utf-8?B?SGZIbUl3RW9wbGtpNmpHelFGZU55TDVOWmx2ZEFQQ2plWVkxQlBHV3pHdGZs?=
 =?utf-8?B?ZHNRVWYvMlNrZGNqV1I4YnNkNnFtSmIwQk5MNDEza3hGTWhCKzZyUW50eVdh?=
 =?utf-8?B?S0tiMXpOL1ljSlU2SzlTUTMrM2toUTFnOUhqcFRMcm5oNSs2YUpQRjNmaXBI?=
 =?utf-8?B?S2IwVU9ySWFCYVVDN3diWnErajQzenh4MUdlQUJiL2x0ODVyelNaTlg0bjdK?=
 =?utf-8?B?bU1heDlCZm9xdmlycUd0dDZURGo4WWQ0cjZOV0xlUW9WYngrcHZWZzRobXBi?=
 =?utf-8?B?Tk12ZzlPcDhJcms4UjBoWmlNcjh4UTVrZUNoRmZ5cE1mazVFR3pTZmdoSmZY?=
 =?utf-8?B?cS9wU0hNM1V5NHdSdENGRStJOFdiakVZMHJUd0RDeExrWkRNOVlNNy9CYjZs?=
 =?utf-8?B?RC9RZEJkaGZ1c3IvK2k0WFFGeU1IM1NrcVRHSngyTmw3QnprVU5FZmpwWWFE?=
 =?utf-8?B?TDZJVUtEMlI4TExnSFpNUlBtVWhuRWR2Z0FxMHZCZU9EY0hlc1k5azdQRzlE?=
 =?utf-8?B?djh6N1EzaXo1SGdDczVFWHlyNjZKeHZHMEZkRnZaZ2JpNzBCMEtaMHpKZlpx?=
 =?utf-8?B?dDhpbzgvNk1xMlpydjJ2WnozOG9pUytoMUR1Zm9lK2czUFN3ZzByTzBGb2pZ?=
 =?utf-8?B?eTJhdlFicmRjRHIrU0Z0Q05lVEszZXlqdVNuWUI1TDZ1eU1EQlJtdzVTbUVO?=
 =?utf-8?B?eVEwMzJhT1FwQlAxb0drOXVBNmhFdXg1OW9pYlBJSzFHOXVEaTFjWU9nSS96?=
 =?utf-8?B?WUVub1NZQjVxSHVIY0V1N3RtQlNKZ0VnTnhuR3hGaUY5VHVVeTMvT09sNXhS?=
 =?utf-8?B?L2c9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc863551-5e5a-4b13-33da-08da716549c5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 13:21:47.1517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zH26Q4F1Znwc2Z9uyKrrkR74Yu+/oS0SK5UoPRIHRTcEReamz/E0ZXH26l9YEF7pch/JMKGY2/l6pnUI0xxlZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7497
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a desire coming from Russell King to make all DSA drivers
register unconditionally with phylink, to simplify the code paths:
https://lore.kernel.org/netdev/YtGPO5SkMZfN8b%2Fs@shell.armlinux.org.uk/

However this is not possible today without risking to break drivers
which rely on a different mechanism, that where ports are manually
brought up to the highest link speed during setup, and never touched by
phylink at runtime.

This happens because DSA was not always integrated with phylink, and
when the early drivers were converted from platform data to the new DSA
bindings, there was no information kept in the platform data structures
about port link speeds, so as a result, there was no information
translated into the first DT bindings.

https://lore.kernel.org/all/YtXFtTsf++AeDm1l@lunn.ch/

Today we have a workaround in place, introduced by commit a20f997010c4
("net: dsa: Don't instantiate phylink for CPU/DSA ports unless needed"),
where shared ports would be checked for the presence of phy-handle/
fixed-link/managed OF properties, and if missing, phylink registration
would be skipped.

We modify the logic of this workaround such as to stop the proliferation
of more port OF nodes with lacking information, to put an upper bound to
the number of switches for which a link management description must be
faked in order for phylink registration to become possible for them.

Today we have drivers introduced years after the phylink migration of
CPU/DSA ports, and yet we're still not completely sure whether all new
drivers use phylink, because this depends on dynamic information
(DT blob, which may very well not be upstream, because why would it).
Driver maintainers may even be unaware about the fact that omitting
fixed-link/phy-handle for CPU/DSA ports is legal, and even works with
some of the old pre-phylink drivers.

Add central validation in DSA for the OF properties required by phylink,
in an attempt to sanitize the environment for future driver writers, and
as much as possible for existing driver maintainers.

Technically no driver except sja1105 and felix (partially) validates
these properties, but perhaps due to subtle reasons, some of the
other existing drivers may not actually work properly with a port OF
node that lacks a complete description. There isn't any way to know
except by deleting the fixed-link (or phy-mode or both) on a CPU port
and trying.

We can't fully know what is the situation with downstream DT blobs,
but we can guess the overall trend by studying the DT blobs that were
submitted upstream. If there are upstream blobs that have lacking
descriptions, we take it as very likely that there are many more
downstream blobs that do so too. If all upstream blobs have complete
descriptions, we take that as a hint that the driver is a candidate for
strict validation (considering that most bindings are copy-pasted).
If there are no upstream DT blobs, we take the conservative route of
skipping validation, unless the driver maintainer instructs us
otherwise.

The driver situation is as follows:

ar9331
~~~~~~

    compatible strings:
    - qca,ar9331-switch

    1 occurrence in mainline device trees, part of SoC dtsi
    (arch/mips/boot/dts/qca/ar9331.dtsi), description is not problematic.

    Verdict: opt into validation.

b53
~~~

    compatible strings:
    - brcm,bcm5325
    - brcm,bcm53115
    - brcm,bcm53125
    - brcm,bcm53128
    - brcm,bcm5365
    - brcm,bcm5389
    - brcm,bcm5395
    - brcm,bcm5397
    - brcm,bcm5398

    - brcm,bcm53010-srab
    - brcm,bcm53011-srab
    - brcm,bcm53012-srab
    - brcm,bcm53018-srab
    - brcm,bcm53019-srab
    - brcm,bcm5301x-srab
    - brcm,bcm11360-srab
    - brcm,bcm58522-srab
    - brcm,bcm58525-srab
    - brcm,bcm58535-srab
    - brcm,bcm58622-srab
    - brcm,bcm58623-srab
    - brcm,bcm58625-srab
    - brcm,bcm88312-srab
    - brcm,cygnus-srab
    - brcm,nsp-srab
    - brcm,omega-srab

    - brcm,bcm3384-switch
    - brcm,bcm6328-switch
    - brcm,bcm6368-switch
    - brcm,bcm63xx-switch

    I've found at least these mainline DT blobs with problems:

    arch/arm/boot/dts/bcm47094-linksys-panamera.dts
    - lacks phy-mode
    arch/arm/boot/dts/bcm47189-tenda-ac9.dts
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/bcm47081-luxul-xap-1410.dts
    arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts
    arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dts
    arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts
    arch/arm/boot/dts/bcm4708-luxul-xap-1510.dts
    arch/arm/boot/dts/bcm953012er.dts
    arch/arm/boot/dts/bcm4708-netgear-r6250.dts
    arch/arm/boot/dts/bcm4708-buffalo-wzr-1166dhp-common.dtsi
    arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts
    arch/arm/boot/dts/bcm47094-luxul-abr-4500.dts
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/bcm53016-meraki-mr32.dts
    - lacks phy-mode

    Verdict: opt all switches out of strict validation.

bcm_sf2
~~~~~~~

    compatible strings:
    - brcm,bcm4908-switch
    - brcm,bcm7445-switch-v4.0
    - brcm,bcm7278-switch-v4.0
    - brcm,bcm7278-switch-v4.8

    A single occurrence in mainline
    (arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi), part of a SoC
    dtsi, valid description. Florian Fainelli explains that most of the
    bcm_sf2 device trees lack a full description for the internal IMP
    ports.

    Verdict: opt the BCM4908 into strict validation, and opt out the
    rest. Note that even though BCM4908 has strict DT bindings, it still
    does not register with phylink on the IMP port due to it implementing
    ->adjust_link().

hellcreek
~~~~~~~~~

    compatible strings:
    - hirschmann,hellcreek-de1soc-r1

    No occurrence in mainline device trees. Kurt Kanzenbach confirms
    that the downstream device tree lacks phy-mode and fixed link, and
    needs work.

    Verdict: opt out of validation.

lan9303
~~~~~~~

    compatible strings:
    - smsc,lan9303-mdio
    - smsc,lan9303-i2c

    1 occurrence in mainline device trees:
    arch/arm/boot/dts/imx53-kp-hsc.dts
    - no phy-mode, no fixed-link

    Verdict: opt out of validation.

lantiq_gswip
~~~~~~~~~~~~

    compatible strings:
    - lantiq,xrx200-gswip
    - lantiq,xrx300-gswip
    - lantiq,xrx330-gswip

    No occurrences in mainline device trees. Martin Blumenstingl
    confirms that the downstream OpenWrt device trees lack a proper
    fixed-link and need work, and that the incomplete description can
    even be seen in the example from
    Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt.

    Verdict: opt out of validation.

microchip ksz
~~~~~~~~~~~~~

    compatible strings:
    - microchip,ksz8765
    - microchip,ksz8794
    - microchip,ksz8795
    - microchip,ksz8863
    - microchip,ksz8873
    - microchip,ksz9477
    - microchip,ksz9897
    - microchip,ksz9893
    - microchip,ksz9563
    - microchip,ksz8563
    - microchip,ksz9567
    - microchip,lan9370
    - microchip,lan9371
    - microchip,lan9372
    - microchip,lan9373
    - microchip,lan9374

    5 occurrences in mainline device trees, all descriptions are valid.
    But we had a snafu for the ksz8795 and ksz9477 drivers where the
    phy-mode property would be expected to be located directly under the
    'switch' node rather than under a port OF node. It was fixed by
    commit edecfa98f602 ("net: dsa: microchip: look for phy-mode in port
    nodes"). The driver still has compatibility with the old DT blobs.
    The lan937x support was added later than the above snafu was fixed,
    and even though it has support for the broken DT blobs by virtue of
    sharing a common probing function, I'll take it that its DT blobs
    are correct.

    Verdict: opt lan937x into validation, and the others out.

mt7530
~~~~~~

    compatible strings
    - mediatek,mt7621
    - mediatek,mt7530
    - mediatek,mt7531

    Multiple occurrences in mainline device trees, one is part of an SoC
    dtsi (arch/mips/boot/dts/ralink/mt7621.dtsi), all descriptions are
    fine.

    Verdict: opt into strict validation.

mv88e6060
~~~~~~~~~

    compatible string:
    - marvell,mv88e6060

    no occurrences in mainline, nobody knows anybody who uses it.

    Verdict: opt out of strict validation.

mv88e6xxx
~~~~~~~~~

    compatible strings:
    - marvell,mv88e6085
    - marvell,mv88e6190
    - marvell,mv88e6250

    Device trees that have incomplete descriptions of CPU or DSA ports:
    arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi
    - lacks phy-mode
    arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
    - lacks phy-mode
    arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
    - lacks phy-mode
    arch/arm/boot/dts/vf610-zii-spb4.dts
    - lacks phy-mode
    arch/arm/boot/dts/vf610-zii-cfu1.dts
    - lacks phy-mode
    arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
    - lacks phy-mode on CPU port, fixed-link on DSA ports
    arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
    - lacks phy-mode on CPU port
    arch/arm/boot/dts/armada-381-netgear-gs110emx.dts
    - lacks phy-mode
    arch/arm/boot/dts/vf610-zii-scu4-aib.dts
    - lacks fixed-link on xgmii DSA ports and/or in-band-status on
      2500base-x DSA ports, and phy-mode on CPU port
    arch/arm/boot/dts/imx6qdl-gw5904.dtsi
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dts
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
    - lacks phy-mode
    arch/arm/boot/dts/kirkwood-dir665.dts
    - lacks phy-mode
    arch/arm/boot/dts/kirkwood-rd88f6281.dtsi
    - lacks phy-mode
    arch/arm/boot/dts/orion5x-netgear-wnr854t.dts
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/armada-388-clearfog.dts
    - lacks phy-mode
    arch/arm/boot/dts/armada-xp-linksys-mamba.dts
    - lacks phy-mode
    arch/arm/boot/dts/armada-385-linksys.dtsi
    - lacks phy-mode
    arch/arm/boot/dts/imx6q-b450v3.dts
    arch/arm/boot/dts/imx6q-b850v3.dts
    - has a phy-handle but not a phy-mode?
    arch/arm/boot/dts/armada-370-rd.dts
    - lacks phy-mode
    arch/arm/boot/dts/kirkwood-linksys-viper.dts
    - lacks phy-mode
    arch/arm/boot/dts/imx51-zii-rdu1.dts
    - lacks phy-mode
    arch/arm/boot/dts/imx51-zii-scu2-mezz.dts
    - lacks phy-mode
    arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi
    - lacks phy-mode
    arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dts
    - lacks phy-mode and fixed-link

    Verdict: opt out of validation.

ocelot
~~~~~~

    compatible strings:
    - mscc,vsc9953-switch
    - felix (arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi) is a PCI
      device, has no compatible string

    2 occurrences in mainline, both are part of SoC dtsi and complete.

    Verdict: opt into strict validation.

qca8k
~~~~~

    compatible strings:
    - qca,qca8327
    - qca,qca8328
    - qca,qca8334
    - qca,qca8337

    5 occurrences in mainline device trees, none of the descriptions are
    problematic.

    Verdict: opt into validation.

realtek
~~~~~~~

    compatible strings:
    - realtek,rtl8366rb
    - realtek,rtl8365mb

    2 occurrences in mainline, both descriptions are fine, additionally
    rtl8365mb.c has a comment "The device tree firmware should also
    specify the link partner of the extension port - either via a
    fixed-link or other phy-handle."

    Verdict: opt into validation.

rzn1_a5psw
~~~~~~~~~~

    compatible strings:
    - renesas,rzn1-a5psw

    One single occurrence, part of SoC dtsi
    (arch/arm/boot/dts/r9a06g032.dtsi), description is fine.

    Verdict: opt into validation.

sja1105
~~~~~~~

    Driver already validates its port OF nodes in
    sja1105_parse_ports_node().

    Verdict: opt into validation.

vsc73xx
~~~~~~~

    compatible strings:
    - vitesse,vsc7385
    - vitesse,vsc7388
    - vitesse,vsc7395
    - vitesse,vsc7398

    2 occurrences in mainline device trees, both descriptions are fine.

    Verdict: opt into validation.

xrs700x
~~~~~~~

    compatible strings:
    - arrow,xrs7003e
    - arrow,xrs7003f
    - arrow,xrs7004e
    - arrow,xrs7004f

    no occurrences in mainline, we don't know.

    Verdict: opt out of strict validation.

Because there is a pattern where newly added switches reuse existing
drivers more often than introducing new ones, I've opted for deciding
who gets to skip validation based on an OF compatible match table in the
DSA core. The alternative would have been to add another boolean
property to struct dsa_switch, like configure_vlan_while_not_filtering.
But this avoids situations where sometimes driver maintainers obfuscate
what goes on by sharing a common probing function, and therefore
making new switches inherit old quirks.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Acked-by: Alvin Šipraga <alsi@bang-olufsen.dk> # realtek
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- sort drivers alphabetically, and other rewordings in the commit
  message
- move validation inside dsa_shared_port_link_register_of(), where it is
  better placed considering the future work that might take place here
- perform validation for everyone, just don't enforce it for the
  switches listed, as suggested by Andrew Lunn

 net/dsa/port.c | 175 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 170 insertions(+), 5 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 4b6139bff217..c07a7c69d5e0 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1650,22 +1650,187 @@ static int dsa_shared_port_phylink_register(struct dsa_port *dp)
 	return err;
 }
 
+/* During the initial DSA driver migration to OF, port nodes were sometimes
+ * added to device trees with no indication of how they should operate from a
+ * link management perspective (phy-handle, fixed-link, etc). Additionally, the
+ * phy-mode may be absent. The interpretation of these port OF nodes depends on
+ * their type.
+ *
+ * User ports with no phy-handle or fixed-link are expected to connect to an
+ * internal PHY located on the ds->slave_mii_bus at an MDIO address equal to
+ * the port number. This description is still actively supported.
+ *
+ * Shared (CPU and DSA) ports with no phy-handle or fixed-link are expected to
+ * operate at the maximum speed that their phy-mode is capable of. If the
+ * phy-mode is absent, they are expected to operate using the phy-mode
+ * supported by the port that gives the highest link speed. It is unspecified
+ * if the port should use flow control or not, half duplex or full duplex, or
+ * if the phy-mode is a SERDES link, whether in-band autoneg is expected to be
+ * enabled or not.
+ *
+ * In the latter case of shared ports, omitting the link management description
+ * from the firmware node is deprecated and strongly discouraged. DSA uses
+ * phylink, which rejects the firmware nodes of these ports for lacking
+ * required properties.
+ *
+ * For switches in this table, DSA will skip enforcing validation and will
+ * later omit registering a phylink instance for the shared ports, if they lack
+ * a fixed-link, a phy-handle, or a managed = "in-band-status" property.
+ * It becomes the responsibility of the driver to ensure that these ports
+ * operate at the maximum speed (whatever this means) and will interoperate
+ * with the DSA master or other cascade port, since phylink methods will not be
+ * invoked for them.
+ *
+ * If you are considering expanding this table for newly introduced switches,
+ * think again. It is OK to remove switches from this table if there aren't DT
+ * blobs in circulation which rely on defaulting the shared ports.
+ */
+static const char * const dsa_switches_dont_enforce_validation[] = {
+#if IS_ENABLED(CONFIG_NET_DSA_XRS700X)
+	"arrow,xrs7003e",
+	"arrow,xrs7003f",
+	"arrow,xrs7004e",
+	"arrow,xrs7004f",
+#endif
+#if IS_ENABLED(CONFIG_B53)
+	"brcm,bcm5325",
+	"brcm,bcm53115",
+	"brcm,bcm53125",
+	"brcm,bcm53128",
+	"brcm,bcm5365",
+	"brcm,bcm5389",
+	"brcm,bcm5395",
+	"brcm,bcm5397",
+	"brcm,bcm5398",
+	"brcm,bcm53010-srab",
+	"brcm,bcm53011-srab",
+	"brcm,bcm53012-srab",
+	"brcm,bcm53018-srab",
+	"brcm,bcm53019-srab",
+	"brcm,bcm5301x-srab",
+	"brcm,bcm11360-srab",
+	"brcm,bcm58522-srab",
+	"brcm,bcm58525-srab",
+	"brcm,bcm58535-srab",
+	"brcm,bcm58622-srab",
+	"brcm,bcm58623-srab",
+	"brcm,bcm58625-srab",
+	"brcm,bcm88312-srab",
+	"brcm,cygnus-srab",
+	"brcm,nsp-srab",
+	"brcm,omega-srab",
+	"brcm,bcm3384-switch",
+	"brcm,bcm6328-switch",
+	"brcm,bcm6368-switch",
+	"brcm,bcm63xx-switch",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_BCM_SF2)
+	"brcm,bcm7445-switch-v4.0",
+	"brcm,bcm7278-switch-v4.0",
+	"brcm,bcm7278-switch-v4.8",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_HIRSCHMANN_HELLCREEK)
+	"hirschmann,hellcreek-de1soc-r1",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_LANTIQ_GSWIP)
+	"lantiq,xrx200-gswip",
+	"lantiq,xrx300-gswip",
+	"lantiq,xrx330-gswip",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_MV88E6060)
+	"marvell,mv88e6060",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_MV88E6XXX)
+	"marvell,mv88e6085",
+	"marvell,mv88e6190",
+	"marvell,mv88e6250",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON)
+	"microchip,ksz8765",
+	"microchip,ksz8794",
+	"microchip,ksz8795",
+	"microchip,ksz8863",
+	"microchip,ksz8873",
+	"microchip,ksz9477",
+	"microchip,ksz9897",
+	"microchip,ksz9893",
+	"microchip,ksz9563",
+	"microchip,ksz8563",
+	"microchip,ksz9567",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_SMSC_LAN9303_MDIO)
+	"smsc,lan9303-mdio",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_SMSC_LAN9303_I2C)
+	"smsc,lan9303-i2c",
+#endif
+	NULL,
+};
+
+static void dsa_shared_port_validate_of(struct dsa_port *dp,
+					bool *missing_phy_mode,
+					bool *missing_link_description)
+{
+	struct device_node *dn = dp->dn, *phy_np;
+	struct dsa_switch *ds = dp->ds;
+	phy_interface_t mode;
+
+	*missing_phy_mode = false;
+	*missing_link_description = false;
+
+	if (of_get_phy_mode(dn, &mode)) {
+		*missing_phy_mode = true;
+		dev_err(ds->dev,
+			"OF node %pOF of %s port %d lacks the required \"phy-mode\" property\n",
+			dn, dsa_port_is_cpu(dp) ? "CPU" : "DSA", dp->index);
+	}
+
+	/* Note: of_phy_is_fixed_link() also returns true for
+	 * managed = "in-band-status"
+	 */
+	if (of_phy_is_fixed_link(dn))
+		return;
+
+	phy_np = of_parse_phandle(dn, "phy-handle", 0);
+	if (phy_np) {
+		of_node_put(phy_np);
+		return;
+	}
+
+	*missing_link_description = true;
+
+	dev_err(ds->dev,
+		"OF node %pOF of %s port %d lacks the required \"phy-handle\", \"fixed-link\" or \"managed\" properties\n",
+		dn, dsa_port_is_cpu(dp) ? "CPU" : "DSA", dp->index);
+}
+
 int dsa_shared_port_link_register_of(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
-	struct device_node *phy_np;
+	bool missing_link_description;
+	bool missing_phy_mode;
 	int port = dp->index;
 
+	dsa_shared_port_validate_of(dp, &missing_phy_mode,
+				    &missing_link_description);
+
+	if ((missing_phy_mode || missing_link_description) &&
+	    !of_device_compatible_match(ds->dev->of_node,
+					dsa_switches_dont_enforce_validation))
+		return -EINVAL;
+
 	if (!ds->ops->adjust_link) {
-		phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
-		if (of_phy_is_fixed_link(dp->dn) || phy_np) {
+		if (missing_link_description) {
+			dev_warn(ds->dev,
+				 "Skipping phylink registration for %s port %d\n",
+				 dsa_port_is_cpu(dp) ? "CPU" : "DSA", dp->index);
+		} else {
 			if (ds->ops->phylink_mac_link_down)
 				ds->ops->phylink_mac_link_down(ds, port,
 					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
-			of_node_put(phy_np);
+
 			return dsa_shared_port_phylink_register(dp);
 		}
-		of_node_put(phy_np);
 		return 0;
 	}
 
-- 
2.34.1

