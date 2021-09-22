Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C687F414C34
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 16:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236251AbhIVOjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 10:39:23 -0400
Received: from mail-eopbgr60064.outbound.protection.outlook.com ([40.107.6.64]:12042
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236178AbhIVOjS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 10:39:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZadMSscRBnwFK1alrbzZmEn6Sor6KY2bELMrGXKTAtXtvqQLh7WHLoYY3BRJrkhmDhbUrVEHEI8yTvzmuUDwDwtq3EV3/rE/KPuofPg29TsmojPQBvneQpK8hJ/4HkyILdkF0z7v8YDrxpIfRzbF1RSMeqHdUNqyewHWgH6FYEMfEs0doPMcxNXyxcGLyt4zwXeNPerpfOjC9JI3ZkQ0niLziPe9jntFGFa/RW7aId08essJfs8PNldAwLZq9rhaTl3t2NWCXlrNQ/YqinxfZY1e+jvp2kYnQ0t7Is4Ry3twY4hJIzHK3b89XlAqh+jn0OXUYeMpXbpzEh4E5V6CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SZ1RE86Lcfodhf/i8pVE3ewWUAR9gVSU2iyxfjiHCFQ=;
 b=DZuWB7xP79DZsWR/GhPJ4kVgkV8FyAW9PTyRwpWmba0BBVxbLdqgrsby5F1yztEVOKwS7ZSbkTlGQab4dniaQHdC0qsAI6l/5OJQRUDz3ExIsewuyCcz6ZSViyDvLNyuo3XHI4gXLqcfqr6FcCcpsio02EicThZ9BNdjYLRtqfoF0JPqBXgLNiKTmcZsZWrDWQyyJu1oIqwmr66yG1OOoNUiZcXY6T6Z3xWcs01kETaO3cjbRq/OsgEoIOnU0nkE0IfhOa1kuW3300gqRU4zHWahYgyFckly5Sua2jgEaW7DP4ywWtLKRhPF9P4s4ypiMKTI+4DFrHIZc7YXdJAbsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZ1RE86Lcfodhf/i8pVE3ewWUAR9gVSU2iyxfjiHCFQ=;
 b=X6ePgsLnWTuocaItiSjrvDzR4OZJyLCGAIGRd/EaANGhjZe/Fs0gLLgq2//8StBDIDLatODC48blxoD+OHsN/0pvL98CRsoQBLMgpLOjLgWJQNkrSQBOuY/zgiS4JijwImBxVXWshKH17+XvB+D+heiSPF7WORmO74zprvRt+YA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4431.eurprd04.prod.outlook.com (2603:10a6:803:6f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 14:37:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 14:37:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 0/2] Fix circular dependency between sja1105 and tag_sja1105
Date:   Wed, 22 Sep 2021 17:37:24 +0300
Message-Id: <20210922143726.2431036-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0207.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.53.217) by PR0P264CA0207.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Wed, 22 Sep 2021 14:37:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f9f40cd-174c-4429-701a-08d97dd68b3a
X-MS-TrafficTypeDiagnostic: VI1PR04MB4431:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4431A529903AFAB8F1B3EA2EE0A29@VI1PR04MB4431.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gHpZhqghMlAj9ZbJ5lURr7/sD1/uEHrzSffxBS4xit6PRX7Yryrh65uRHhZwuFRPtsOxP0LT92kyRfV88Y495WNei7IMXhfTAuanz0BQyUC0WBEBD9TA1thQvjc7RgRp3EgsBqYmhjN6fs8wyXkW4BT/YoHYt/R4+1lMiIvqYY8IpVAbZXEgnDkHXRMi6/8zsAhpF+MSicf4VVPb+QG7HWWdluKAmrjR1BPPUW9m6SP+EuISLCGCQp7PxSG6F48h6CXVRHCN0TBuhUtYv8fFMctWq5xbAkN1RZoI3Q/AZWx/hhEPxgSsz+DGuOjeh6KUXurlDcgqni+xw7q/mcDud8nyhLGYunnGBp7iwzqIrCySOiDoD0KvEA6f8XOc5oj1wRpMl4jt6Jt1NmAfeGxrpOJvEAuPfadzyrj5Db+38LunCdnm0WThkn4MTBl2ECrusyXBKljucSYtLn8Z3ZfhpAkT95ac8I1oZngsO0GPtS3+Ft4YINuclld59b9gnqFrrcI2bljMWk6epg4kJj/V4TLuWf1hPzdi8cyi4fbFDJFAISqgUmAa/aKUxfswxrUoRamil6qAcL/A/H2A2LJDvZpd/bHrYPLSLtsh/4C86cPjeIpaNPYsH0actdiKqta61rG2MVPgwbSki+VhjKxnWJMglf5+ZAG9X/jVcIvUHTIRBM9VVrZZ37CZPKY6yNKluzLUe1eEiWUhh+XOwaEM1ZsReZ8JFcWM91PFIGZv+uRXoegvWpas+t5Y7qZOocFe5AdEfxEKo1cgqZgjrBzD+erJl9JgtoyKexgSQ4DAr4U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(83380400001)(4744005)(316002)(110136005)(44832011)(2616005)(508600001)(52116002)(26005)(86362001)(4326008)(66556008)(186003)(36756003)(5660300002)(66476007)(1076003)(6486002)(2906002)(6506007)(6512007)(6666004)(966005)(8936002)(38100700002)(38350700002)(8676002)(66946007)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CC98grOwaLCLZdfmMXLth95bbnhtSENwdJ1o8MZOM+Nes6oKHlsxhxB5QXKY?=
 =?us-ascii?Q?FXOFs65evONzLgfJLVKxBbyi4wNB3lDeCMaTMEKAX14ONeNEnIUp58jm6LZs?=
 =?us-ascii?Q?2w7XztrdUvyFLz5WXHjDfNk7rcPLLyqG/uW/osuZfqf5Q7eUSCUNWd1CSAlr?=
 =?us-ascii?Q?FGSyr0YrTcwUUttHC76z4KUuKtqOg+tBVc/y98uobuzc+rx/LRO96niK7Fk7?=
 =?us-ascii?Q?SK5xORxRa8meL7ghdkHsW2mOQHJH/BDT9X8Tyilf1/HUwsQVJ46NNGM9yoAG?=
 =?us-ascii?Q?SxrMRp8HMTy3qA72OHE8DLsvyppQhWpvv+1OrYfHqrHwTV8bdLlNpuULC/w/?=
 =?us-ascii?Q?HiICfzC0cjknvpE1U6V5xHzsY2Gc20KzB8jhTtpHvREQvyRJy4JdM7XHE/sU?=
 =?us-ascii?Q?ZHJQ3mzV19uIFFubg1TBaD6hHIbeL6ymImhA7EwkGHaFoLeiafWieV8J1R2t?=
 =?us-ascii?Q?+8VEubAhuJGFLk0Q7nKK1+bUxC1MMzHFGWZx/OEgBhTrQTiCImOFwsN2fRnT?=
 =?us-ascii?Q?MG+ddYJm+zjWHTzjFuZssEuIr/vg/7CvtvWMfWCUuE5MMa2oIrc0+XB31+qG?=
 =?us-ascii?Q?kf/Vo3x5n5EE+/QrQUe35G3vMWHTiUkmsmY1lHf891DS1NcLTc7FBuGSXhaV?=
 =?us-ascii?Q?+LQ4Wat0EUkXa5bwK1L/PWtEl22fSbVIInjWkYCM4pJbrMe4cOo0xpBOOpTO?=
 =?us-ascii?Q?Us04xjawgMFUSLhrbOs+vc6SVxUlaTssVUWgtKCqzUAJdFgCcS2LXBAFWce0?=
 =?us-ascii?Q?n/OQBYQQC+7yhYEQpcBJg3X3Y7kVzEihgZlUlIm99eVZvsBouRGGKZxepN74?=
 =?us-ascii?Q?fHqotGnO1hD7dgmlXn7zqLvOPkETHF8m6ep+iw0kY1UX38kiMtpujbcLeqAK?=
 =?us-ascii?Q?RjDZ5cj1FclajGk1TGO5XxIJx5gaO0hd7y2TXEP6PKN3IYfX/kIXXp8z0kzT?=
 =?us-ascii?Q?z3vhExQTxCGP5bOr6XtC6dvvSiB7VxFwD2OwetwJ4WApW7XUYpOZ+z6jDRO5?=
 =?us-ascii?Q?iLjsTj9NMuDbpmPpvvk2gXIZmi+6x+EhP+XpwQjf+FREUl/TIX3tO2ESm9Ob?=
 =?us-ascii?Q?gQN5IF/9gXM+QlA4Hqdn287tGSyG5Al01Zpqnz01BdrehoiruhDWI26A7OLH?=
 =?us-ascii?Q?pr41mKl3rE+b5lk3X+s5Te9YfQzfAa2e96oa4CzKePLnlA5oYxRZ+1NYKS25?=
 =?us-ascii?Q?CcXihfBdLb4XwKOo4anKUm+F9m7AmYOtso+rFZWb4bBnAGK4L++dGYzZX8ai?=
 =?us-ascii?Q?Yj15h070M5BNoZWeSqV6O/+J/uZ7nhs/z/Ipvf6+sgSJUT2K7Uj4XOII8mH7?=
 =?us-ascii?Q?FrGMFsMCYdL4js1AMyQYm237?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f9f40cd-174c-4429-701a-08d97dd68b3a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 14:37:46.3431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zm4qGsVlwB/VyEZ3H4BVjk5tCYU6pTawU8JlHnFdHEbB9txwfTDi/QIajVb9eSXTNsQynAWwMVyka1Hi3IKEyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4431
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As discussed here:
https://lore.kernel.org/netdev/20210908220834.d7gmtnwrorhharna@skbuf/
DSA tagging protocols cannot use symbols exported by switch drivers.

Eliminate the two instances of that from tag_sja1105, and that allows us
to have a working setup with modules again.

Vladimir Oltean (2):
  net: dsa: move sja1110_process_meta_tstamp inside the tagging protocol
    driver
  net: dsa: sja1105: break dependency between dsa_port_is_sja1105 and
    switch driver

 drivers/net/dsa/sja1105/sja1105_main.c |  3 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 45 ++++----------------------
 drivers/net/dsa/sja1105/sja1105_ptp.h  | 19 -----------
 include/linux/dsa/sja1105.h            | 40 ++++++++---------------
 net/dsa/Kconfig                        |  1 -
 net/dsa/tag_sja1105.c                  | 43 ++++++++++++++++++++++++
 6 files changed, 63 insertions(+), 88 deletions(-)

-- 
2.25.1

