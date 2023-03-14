Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C987D6B9E39
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjCNSY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjCNSYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:24:25 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2043.outbound.protection.outlook.com [40.107.105.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3547326C02;
        Tue, 14 Mar 2023 11:24:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6y/ViertNUgf7jrhyOaclij2eWI3hd6LsCRbKVWg/ytnZy2FyEn0gvqq2qenjNOOwWJzfFfOmgeLK2yuA+97F90l791H37IWYMYfies85uA2wR+JmiSiIReO/EQmuF/xmZkYyuU2GbnkDUP6qwuOYq+/EuXXkeGsw36Whia01/Bntffr5dvaFIG/yvA/5Zf2Fqo+jbTZU/mhdLMxX2z6k9g9AFlk5Pod4Z+AeicOACDG9yzFHO7bXyaTp37qajdCWEmEjdlo+yToX+coRVGZy45MGEpBgxss5ucQhjzDKbrjaoOmMGzqn2huVw/gqWoxi+JRTGwTZD3aROoN8IaDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zTE+O8CPT4M4Dh2ipX6y2fS6CrkQicsI4hEQUu4dNgo=;
 b=QuhbwtdSW3MxF78IwaV+XBrtGQIy2DgvuSbjYa1cUHpEHhTHdYjJmbQjlocAYfHx4hjKMcLrDH/KfWQ8AxipWRZTvXHN/0B56xDyjnAiMlN8pLnLgqzlGY2NLT048CUMXusNZsBNMvK1smwpEiZpc1eGnSSMklsuogX54bLVGhY9SGL8kGr2JiPZDWAEnihIKYInuddiFoWjNtlQNKpkjRTBz6rsZWgRyFP8ZW8h4Ihu//LnQ21IUSWdRndhG3S7jZhxBm3UlbXAyN8+bNHHj6wVy4EXaclhiDPQZuyRwZm7k/ZZSXTHAsMEuyI6oOR/Udd8pzoQ7x/iR5WGsBN2og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTE+O8CPT4M4Dh2ipX6y2fS6CrkQicsI4hEQUu4dNgo=;
 b=jJv1Chos4Q2dkMEQVppaXdBAMuZ1ResFB5kTXh/oq3uicnHVH0uwFntlF1EOfXcYlzrV9AJMZ8OJhpj0XMQs5lbY2BRnJtfKlwhc0xaqLIno6jQt0u24DYBR5cITmID/s7nxtj5nTksmltMO8YpO10r2koZh54wMt3oUxLX3Nos=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8253.eurprd04.prod.outlook.com (2603:10a6:102:1bf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 18:24:19 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 18:24:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Lukasz Majewski <lukma@denx.de>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] Fix MTU reporting for Marvell DSA switches where we can't change it
Date:   Tue, 14 Mar 2023 20:24:03 +0200
Message-Id: <20230314182405.2449898-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0032.eurprd05.prod.outlook.com (2603:10a6:205::45)
 To AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8253:EE_
X-MS-Office365-Filtering-Correlation-Id: 13dc8af2-528e-4f45-1833-08db24b9536b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I/4R4dEqFqR49YVbyZ4BgyUmDasV95r4wtm6nH0N7yj26VLr/0bi/h6puhupCEXUnIUV/HTSqHJ54rLpTNqPs3Zxt1pv/GvA+CfBaIrQWKJS4OSpAjeYer1U5VGEPU09PCM1a60F3Z3zy1PGQG45BFBgVgfps8q1q4tbF1qYwprQCdCkXEP13rJ+XgUhiAzUC78WZtrCiO/0UJuxxx/prdk26v1Lav4KPe2lIwSokNUSoWdidYOpCkT+RJhquiYIkUFje/g1U4gL2Bmjxr9Z9Pg0XrGcCIYt4egJvk8+5O8C/+Ld/e5/dPoCS4jhdixQ1iYBTzpy06d+wGRr/zL+i0CNh4GzkRMn8g0Wxxy5GshQBohnKY4FJ5mo21oqJfgzIBpl9nTvrO6C+L0ouo9GGiinHRCZzGgX0TS/UcwV3w/wE1NiNMj8Atmw8d7oRHsxk5RRG3ONk5Z+a6oPdEtW+p+fLEQheWhnNWooSgU7ZLvekBJ2BuuW3MCwlGFqfH+pSbRc5+bCo5ssBKe1NH19wBSdz0ydARSzPjHqCnxPiZJP7CYTb992przhfzNB6iez5FqsHGKj2UnxxOU2Nn4HVjD0A4V5OVoK6/1bKgfod/Y5913QssAg7d1N3+jw2jG8Acjz4oFcypjc7t+jzq3mRkAHpGc+1SPEpsKRTUw2YogkD+7l4dC/ICXmy+Arf+/pVT84mKBarmCOBfQ0CM0aUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199018)(38350700002)(66476007)(66556008)(66946007)(4326008)(6916009)(38100700002)(41300700001)(8936002)(316002)(54906003)(83380400001)(8676002)(478600001)(5660300002)(86362001)(7416002)(44832011)(6666004)(6486002)(36756003)(2616005)(6506007)(6512007)(186003)(2906002)(52116002)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rzn88GZ91NnEhsdDIztCZDkYwEuSvYWeBxmxRpnUDYtQNyV+IYHSwO+WEH4V?=
 =?us-ascii?Q?WrDpXD56lBzDrbcEW4+WXdiGhadK1c/1zda7q6/odraxIS7XUCGAVK4eMAAH?=
 =?us-ascii?Q?xmpZS/ekS24wD2M7CGgymEEdS48FXpkgK14vFjD7AgFbqHOwk8z0NZ2Gg+YS?=
 =?us-ascii?Q?jhPQvimh1KkAmiTDtru18dyuuY3PoORQdhXQAKO623EZqfahLJFkzMTjTODf?=
 =?us-ascii?Q?ezE4NV2Wxud5HrZoeqHdF63MUlJbq199ccEJ58NxfCB0YsonoHgYFb/Ofkyf?=
 =?us-ascii?Q?WKsSkVuCvR0wvCS6Re01K/7kSbgWB9KxADf/MIHWlsUJLpTcM1RL27A0ZMwv?=
 =?us-ascii?Q?kcrn9Uo0UurVysOfOZ8c1+2W8T/YQ44//u4AoCWntRJgcTVDa2bdIkc1PGsS?=
 =?us-ascii?Q?eWXiztbY2Vcgo9r1bl2nsO6kmFzqU68x5JTvc3njk+vlhfLbnv48smDI4yPp?=
 =?us-ascii?Q?Hz3Fb7F+VnQwNBsc+xAVrkxdVfJBEJcYtaVgdxafNnhsIC7PI3KMjEiIZ9FW?=
 =?us-ascii?Q?+7wL7iJTsfNq+QCEwmWreaLyYuVoxVWD5ts3h6kQ2Keogg6mx8UPwDgVTw8x?=
 =?us-ascii?Q?eIoaEiJ1Zbp0HDAELCTeXtmjzXHaygYrw59/AyoXVvPhGLram28OZH5rBCr1?=
 =?us-ascii?Q?NNVCWweY8JG23/GEZdqzGxMUrZ8VcTSzoReTGoFFhoYYia0VEwxv225H8iNa?=
 =?us-ascii?Q?mCxK5JgF4rsy47+Pmvj0bHghCzSo0RiyV2lDonHXLXF8vpnkz+Ki+9i3+v8L?=
 =?us-ascii?Q?d57g/KqaNFr/RfYIwiCzkiFDGPc02JyKoxC+RzlE0NoUXtkN2Z7p30kTBVEg?=
 =?us-ascii?Q?QwAGhXi4D47JpqFCEJJJVzy6RDkxy0OYsJ55oHV/rXcWpjeycTknFYD39jJZ?=
 =?us-ascii?Q?AtIK6pz1XwimzRg0eSPvMzqekZX6ACkKPzlgXAW4liJ1oPx6vPQFaDmGDiSl?=
 =?us-ascii?Q?Bzb3WsH1jGsLhTXw6k72t9l+/M1I5HcUifMFffSi7bVd/EDf2meV3B5x5eSW?=
 =?us-ascii?Q?A4dnr1WggLEYtXYvi6ILXKsUxpUgkTlTYQmMvak1CIKahNTa7wpDMKM/D5zm?=
 =?us-ascii?Q?pE0EPKhv7i6Beq22GOW+RqffWCYo6oY0LeqXhmqdKo+fNmXazWYid+vcQ/eP?=
 =?us-ascii?Q?0NUjlTnU5uAFFLGEOFIMe3XJODqvTK/GQR3MBDMMfYbC0jh4tCuLYUeja/Yh?=
 =?us-ascii?Q?exBdjsNvVK+BjgZ/+iHj6ljfi2BMIm1pl/zJfFThWP5eARDVaKkkb7uR76oE?=
 =?us-ascii?Q?9N/ysTfyoKT5ifDIN1DPf4+SQNgc/IvoDotv1blL2rmb/k2m85POrfVmGn3y?=
 =?us-ascii?Q?rEQp+QiBrLrRdDXCt6B6z5ZEF3JIfeKnQJcnUYZB3RkRm/GUlUG7ojnQ0h8w?=
 =?us-ascii?Q?7gO8iJmiYF3PufMDUlvvrshAaf5Sbq9h3qe2Ry7o3ZwoCmd2fWDmqD8vCEjN?=
 =?us-ascii?Q?iWWFd0LYRh2gTE51v/Y85Tkl3x2+/hI93ebeteTvLsqJtZ8XTozIAJgbLDsv?=
 =?us-ascii?Q?qKUr0vN8CDZzsYfLCN4TTSJW00pvV8oikfJ6T5v7hBTuCkLG97glF62O0qkt?=
 =?us-ascii?Q?hiDwZgelVxKmFDiZ9M5G6G/MtdS9rjYaS9pdGSNUyNrDhrCb4DLG5pPDnndF?=
 =?us-ascii?Q?cQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13dc8af2-528e-4f45-1833-08db24b9536b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 18:24:19.2321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YLevEUIdhc+liO4McANIvZbkLbNbwJFkIWpBYKxUTtlU0u6vCthOr/SlF2Z0R57CcIs8fFqrTlPehplMLaUqZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8253
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As explained in patch 2, the driver doesn't know how to change the MTU
on MV88E6165, MV88E6191, MV88E6220, MV88E6250 and MV88E6290, and there
is a regression where it actually reports an MTU value below the
Ethernet standard (1500).

Fixing that shows another issue where DSA is unprepared to be told that
a switch supports an MTU of only 1500, and still errors out. That is
addressed by patch 1.

Testing was not done on "real" hardware, but on a different Marvell DSA
switch, with code modified such that the driver doesn't know how to
change the MTU on that, either.

A key assumption is that these switches don't need any MTU configuration
to pass full MTU-sized, DSA-tagged packets, which seems like a
reasonable assumption to make. My 6390 and 6190 switches, with
.port_set_jumbo_size commented out, certainly don't seem to have any
problem passing MTU-sized traffic, as can be seen in this iperf3 session
captured with tcpdump on the DSA master:

$MAC > $MAC, Marvell DSA mode Forward, dev 2, port 8, untagged, VID 1000,
	FPri 0, ethertype IPv4 (0x0800), length 1518:
	10.0.0.69.49590 > 10.0.0.1.5201: Flags [.], seq 81088:82536,
	ack 1, win 502, options [nop,nop,TS val 2221498829 ecr 3012859850],
	length 1448

I don't want to go all the way and say that the adjustment made by
commit b9c587fed61c ("dsa: mv88e6xxx: Include tagger overhead when
setting MTU for DSA and CPU ports") is completely unnecessary, just that
there's an equally good chance that the switches with unknown MTU
configuration procedure "just work".

Vladimir Oltean (2):
  net: dsa: don't error out when drivers return ETH_DATA_LEN in
    .port_max_mtu()
  net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220, 6250,
    6290

 drivers/net/dsa/mv88e6xxx/chip.c | 16 ++++++++++++----
 net/dsa/slave.c                  |  9 +++++----
 2 files changed, 17 insertions(+), 8 deletions(-)

-- 
2.34.1

