Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26124285C0B
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 11:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbgJGJsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 05:48:40 -0400
Received: from mail-eopbgr80048.outbound.protection.outlook.com ([40.107.8.48]:16619
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726411AbgJGJsk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 05:48:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTVMmIckbvS+a/lJMzdhZVhtM0ZbLd2qbqNJ1JCoQu5ygNF12WfGyZCsHTb7Zh41TIU5XdUzyg3aM9LMPxxnqprxalpH2jJf6Z9ZJBHbqJ36AEauABqHLLV/XlZifTraJ1zbAG0KSfU6GL2lkApB5UIMvFYEX2fOosv8JbaKtO7eVnHBOtL1BnbqT9yVundPj78vO3WWDAP1ZlRCFLvZGenf6b7+IX1n0iGmKUl3HoctV7Atnm3P06SKRIHNNfEDx57TZng6OlhOBtcSUjeUiCSw4WzblflM2kOLTK+09okBa09Kxs/V61nqWaolNDl7HITvB9MzqCqOSyogKqv6zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K82owvIAyzXrn938M9z1PgoE4L3gmVY6McYT9uaAyeo=;
 b=PXMXkEtDR2bZ8C5GKEL3gUJgrXxML918VJ0QhXcPTlQvc6aGwmzPr0EN07QBUdLQumXkackgZh/23yf7xd022OJtvd41cNpOj5YofHQoILedCSyACEuypNbnHS2w50/R5DGkFEdt/9L9FynbderyhphC+gAI06nHnUxHJ7JZDJbzncsWO+kaX/5mXygYDdL9bG1zTgHkCWIEWcR5UnOvTG5ipS5ZLvtSplFYmsImSFu1ksHpbIEHA0tD9FjDxnE75XKD+I99dqoraF6D4KPjcLuumuGG9qx7RUvTCbHa4gZVjzr6M2xo4BHW4tr6LdYefYhkzpwVpeIQBR0g8Dv38A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K82owvIAyzXrn938M9z1PgoE4L3gmVY6McYT9uaAyeo=;
 b=nW2whuxLhWVeBX6vD0un7U1p120DEafEsQG2+ZoDejWuoepcJHSx3X+/wLTPC5Rq6R4tfGTgDZJmEmP1OK3FH9ENhZwKyxwPoJ7V2uTvWP0W8i7ejYVBlHn5czlulSlTb4/1ZPxmzubXZx1xqVfRvgvh0yEduPcPdx3CInAa0zI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB7169.eurprd04.prod.outlook.com (2603:10a6:208:19a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Wed, 7 Oct
 2020 09:48:36 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3455.022; Wed, 7 Oct 2020
 09:48:36 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 0/4] enetc: Migrate to PHYLINK and PCS_LYNX
Date:   Wed,  7 Oct 2020 12:48:19 +0300
Message-Id: <20201007094823.6960-1-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR03CA0013.eurprd03.prod.outlook.com
 (2603:10a6:208:14::26) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR03CA0013.eurprd03.prod.outlook.com (2603:10a6:208:14::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Wed, 7 Oct 2020 09:48:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c7762aa7-66db-4532-989d-08d86aa62980
X-MS-TrafficTypeDiagnostic: AM0PR04MB7169:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB7169F98995A73A9FC2A9E0D2960A0@AM0PR04MB7169.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sUtLSouDCWf8nGkFz6D2ye6vxuQ5Onnd32PE2Sj4Iu2q1hapCVhFsdAtohHgb07BoZ3N5WUfEabivZgdfFoXI6iOwg4GYvVG/2n/0cpL41by+txBK64+N5zpjSv1+RuRD8/CNXRpFzhE0aHCcTg+ah4u4ipoGkVpWxDIu2XgALXuV0nL3DYO3aKqg4c5JzWSn1mqRFRazvzOtcgWGQm90i7DaSoJzLiT0/e8seIwtR5ZFE6nuYdpkMIKhuX0oQh4JudcsMxib3/f/Uj0yocABsnygFsTeAsH1/FhpRTZ3tFxaszGH2P6rsUw0BhIUk2tvJqhafHB1eOMGk6hzSfcZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(478600001)(186003)(83380400001)(8936002)(26005)(6486002)(16526019)(6916009)(44832011)(36756003)(8676002)(86362001)(2906002)(316002)(1076003)(5660300002)(6666004)(4326008)(54906003)(66556008)(66476007)(66946007)(52116002)(2616005)(956004)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mwCt0dDd33VtIWKYLq+G5FZ3IfRoBpnYoMiDG4p1dYSmtbhZH8BpJgICai5fLBvvCopfs/MH9yKwLnbwUjzKsRZ4HpaNYDkHej4jh8wc0AYJ4mlwjCYBwifEOiknCxrE6bou6akwGQ5VzVNPzoKqTmZJajB8OZGYKsLEmOfJ5sz1QHu8rASDf/FP6/pWrdQB2HL3kW5oSpk8VFZ37yu8J37QUARsSECxm3AZW1fWyIak4W7MIbNs/BgsO9RFXM43j5E3CEOcRGTdcty7TeMTjEMZepb3u6IRCrnbQKWydVrioafoQR0ksrHmDaNmwrUXQOC9+haOxTo7GRmfZ3FB1qYjXuR6Rg7vvcdihZaRBLxJcZ/UWMetqeiY5QFiBtbXxmj7pbWYm3TFezcW3C54qncqk3itHsWq/9PxGBnyAFZqclYUuCWYeXYfAucLjoMT4MZq5yS/sxWcIn1htNNIIe8MTjA/zOT0D5rxCmZT3mSx5iDGOqdwK+aE5NjnNEIx/I7JxelWIBVws/9p7nVzhYFg8zJ1p4nT8cM0GgSACEl66ZmV9zjzsKSNafItoCxX4PyUMg1wP87KRWGi6DlMf9C0F4rkgD+PUSKqtuAT8Q9PnEKey+byd9T2uNcOsbkseq/9hLW9D4jbOhD7XiUREw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7762aa7-66db-4532-989d-08d86aa62980
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 09:48:36.7953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q8niR8Hj1WiN6CYkD1pqROlNnmyQpY3sJELZdI7o+wnsMro/a9MoRCAphfzcuXgNA9qAs2C0hbinvCEvnIQ3sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7169
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Transitioning the enetc driver from phylib to phylink.
Offloading the serdes configuration to the PCS_LYNX
module is a mandatory part of this transition. Aiming
for a cleaner, more maintainable design, and better
code reuse.
The first 2 patches are clean up prerequisites.

Tested on a p1028rdb board.

v2: validate() explicitly rejects now all interface modes not
supported by the driver instead of relying on the device tree
to provide only supported interfaces, and dropped redundant
activation of pcs_poll (addressing Ioana's findings)

Claudiu Manoil (4):
  enetc: Clean up MAC and link configuration
  enetc: Clean up serdes configuration
  arm64: dts: fsl-ls1028a-rdb: Specify in-band mode for ENETC port 0
  enetc: Migrate to PHYLINK and PCS_LYNX

 .../boot/dts/freescale/fsl-ls1028a-rdb.dts    |   1 +
 drivers/net/ethernet/freescale/enetc/Kconfig  |   5 +-
 drivers/net/ethernet/freescale/enetc/enetc.c  |  53 ++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   9 +-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  26 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 335 ++++++++++--------
 .../net/ethernet/freescale/enetc/enetc_pf.h   |   8 +-
 .../net/ethernet/freescale/enetc/enetc_qos.c  |   9 +-
 8 files changed, 243 insertions(+), 203 deletions(-)

-- 
2.17.1

