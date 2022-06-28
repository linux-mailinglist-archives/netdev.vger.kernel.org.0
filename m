Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B00255EAE1
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbiF1RU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiF1RUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:20:54 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B1F37A83;
        Tue, 28 Jun 2022 10:20:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jle95ocj/QWBrVs0Zr1z02xHrMleihffyTY1gSgmAGrgAVVcQmWBrVbO7XlWXrM3AJYiUjQryWY2cR1BgmQWK5WLcc/w1odo0+75oCcv2Q6PVBckbGaij7o69SEyuEYaNLYKiC7Wxziokcm7GT621LANJ5xAiUNZycedVzW51b7OemBZS+o98kEaFT+s62wc1v8I7j0grWIYBHGw+o/oVinfWCZts8WTH7hQox1GBbDSR237e181a3SsBPdkP+wrdsNflQeF4Eqbg6H8BPUUkgKIeGubwkxNgB9zt35Nqbcb5oOD71tBYtbnPtW7BgHttd8MKHlnnVlmZq2cKnbp/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JaDX4anXzt92WOCA9ErzORsbpTYpvfRZKNIqhPivwJI=;
 b=azPk2s9Zf5EDW4wyURe8iXAKhAl/VDkagsDkQqMTFmqpjZQXLSHYzEGJV4JqbevoTTk5Qe8tlyy+X8bghAoDY6hjFHx9pO2X4Mo6YgNG1HA4QYdEFt2jZJPUwOTzLhcuT+jQBBFfwf219fNk21/098QqhI6XtrkwMLf/MZONHdAiF3sd61jyxhMBH0SNoViONioUlLRSkLmPn2JwKme11QHanlTFWrprPYxbe/CMdGwWoRIbFjSmUmTrzQu6WSv0KsKxwG2Kg7Gej/GlmNhYzCHbpBcRZHVpBk403okais/358u+iM48D5oC+KtmytwIOJCEhHoTdiVTh5l6g0hQaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JaDX4anXzt92WOCA9ErzORsbpTYpvfRZKNIqhPivwJI=;
 b=EU3yEAtw7NRRmF2Hz6vQf6m4JlaSr/8Ghjzt6chY6tgVm5xr/b0ECNLjODnyaKCeURuGo8uoQs5bfvIWGIcxViItOJrRswIiPHs4KMiEUNmbKsLnUiAGegfrAjz0iNre9p6CjaL777dN/L0PVn29AVfOkQmdIUo5EXfM+pOZT1s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4337.eurprd04.prod.outlook.com (2603:10a6:208:62::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 17:20:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 17:20:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH stable 0/4] net: mscc: ocelot: allow unregistered IP multicast flooding
Date:   Tue, 28 Jun 2022 20:20:12 +0300
Message-Id: <20220628172016.3373243-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0012.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::22)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85068f15-a01c-44b1-34b0-08da592a8cb5
X-MS-TrafficTypeDiagnostic: AM0PR04MB4337:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ADaldR41xl/ajf+/o2N+evoauP2f2wzWDb0bYMKL206B7hbk8xVbqfY2WOMmPL1PFT3gGoTsl2Kr0Xn6j7IuuCajIlhZMGYRpamuocLzuZ0LO5A9QaucrTGU/lidx+ciMU2JONRdZi6pHt6dtJiIs2F8MZmNZUWKjFewX8+hG3uFEeOGKsOe7p+eu/u1Yskm2/9TSbhDUUAQOoa/EyYzgx8AEtbqpuvCHfkSBo52oMb1S91ZgOad3FG7RqqNgKisGABn88bv0kuwQ0XX56z3Rq9ac7pw/0W4hcSg6s8dI6GBJS/78DxPsVbtc+3EW0eq47zVijTHPHAY033M6iq/raInqvl8vQ1+qwe+qZH4E/+ZSwwi/pK8MS5+qgebiob1L47pQ+bVZOzB3yUDzqR39wbAu/I6554C5szD0nK45Rw+AvoR771ddGcsvvQqUU2iqbYbpeI9zlGNuKMjEjFn9Cwu7DlK3KAgyxUhmkd0oP2WqwKIVTPkbCWInkDUpLlh8dvUgbfrJ7jxMHlItxC9BKtsOyFZ7U3wAe68hh0CCII6FoXR0ScOxuueIjIBaQcZoDMVm1sEqfBc+rSXn9eXx8t87qiAGggg8qZmDStg/ZadHnmEIpWMvb8URA5YxeCUzlTjLx4T70Bvv/3SvUg+eemmdWDI/5RByhRfnXLDKcfGQBFCjy8WLcMFhLolUHh8+soCJA+MIrB4GX6UjBpu4IczMaHFAhP+DsLZlnRw18NTsPa07GWlho2qDv8Gct4R/5fHAoF0cKXFRIWeiymXFfioU1X9RMvoCiYe1VXxg0s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(2616005)(110136005)(38100700002)(36756003)(38350700002)(5660300002)(54906003)(2906002)(316002)(186003)(41300700001)(4326008)(8676002)(52116002)(6506007)(26005)(86362001)(6666004)(66946007)(6512007)(7416002)(4744005)(478600001)(66556008)(44832011)(6486002)(8936002)(66476007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UTQ2htAGURVG8MnWCfKodyzq+PHMTfJrizdGYiJ8FZt2RHLZQTApCizOrYwR?=
 =?us-ascii?Q?vM4r+mbb+QcIM/hy6h0kKPDjfH87bp+y2E+FIBRM7GUXYf/yjfwzRDVRKWGR?=
 =?us-ascii?Q?UFcGvkjEFSurw8XSnMiXSE77/k8Y5hRC96vYmhWdzcnE2NlvL6O2epW19xeN?=
 =?us-ascii?Q?2RfC3KG7CcyXkW0FfdFYZMmiDg2Wek4abVewbY0tKhhz1Y9/5jW/wuOlSOf5?=
 =?us-ascii?Q?DuV9a3se1aN6/fGgw9TV0j0UCBSBoe+8A8tsuQ7QvmGeUVQtV80VYkqUKCyJ?=
 =?us-ascii?Q?da67b5DzRaULxhFNKWXalG4SMJCRNWVEspnn2jc9g2fkBz/xExPcA/BAw1wJ?=
 =?us-ascii?Q?ezK9gfMHwOIBIp+euGe/6HUxDmn9QP7nZTQazssy+HkjF40lzSu5M9q+gGxI?=
 =?us-ascii?Q?HZ4nG1uA34sXMuDxuSyJvDQdgKz4jgXqCEKAK8Ed8v0USYKm5Fzh3Cba7Cky?=
 =?us-ascii?Q?DIL+b1e0v7Ad+wwekCip6UOFw/o3E+3WPIgHI9Rb9qVbM13LlK2SdwiGV+3y?=
 =?us-ascii?Q?zkvQpRPD+UgNIfocA/OhLI6cKAV25EyRuLTfiZvWXHSVwELuj00aSP6zkN26?=
 =?us-ascii?Q?/z1u1v1adAMxne0vdeG7+BfAgB/+f+1gCffbLQrmFZhrmUAkShfuAuLtJwq8?=
 =?us-ascii?Q?ZL9x1hwR/IXS+0q0eO5B6LH2bAGW0x5fN6H+wAy3rZ0SV7lmlqH0q/so5/mG?=
 =?us-ascii?Q?BgVDGIe5DdB7r9zgYYS9A4Vg61O20TZIAWWA8y6mTO/6H56CVW7R+W6dwdoh?=
 =?us-ascii?Q?SZbCs2qJ+e/CS9WIIIQZ9Rn6E6b4lTVAf3DtV9cFhIP+9RzkX2pgSozn+Njb?=
 =?us-ascii?Q?KstnNmacsW+X4VN74UNhVxaF0m4adR9x44W9YJM7hGenguC5yTQFmhandpM9?=
 =?us-ascii?Q?8K+xn16y+PGRGJ9p+288zyF9ovOduhWRBAxSc2UJp3YAyhaRM4tdYyE8gz7g?=
 =?us-ascii?Q?XHttdBnRqTXfixbPqv8gayjJsF7glUgnd8Qny4FLGrjhQ+p1e7rEpJUrzAOk?=
 =?us-ascii?Q?P5v924rYA4vOQeDqxwvubjk/erByY2jNuS+DStIKcBLJapibbWjVVmH9uZc8?=
 =?us-ascii?Q?57MJLwdou6DAbIwIMX3B3w6bpEXSmJB9Y2kph4fF8hma7enJnIs9kj81omPT?=
 =?us-ascii?Q?ayQcWLuVgKjIVR0tyiPSEpzKDe6sQIeweX5Ibaj5UVy1d0BthO6mGMDqgwq7?=
 =?us-ascii?Q?+p/nwe4UXL54NWMH9z1O5e3osAJj3GLI5W5Ii81GpkpC9GLSgooA0B6oFls/?=
 =?us-ascii?Q?ZkHs/n9jsg/92GyLeGjr/WiTDs2DI1VU6I8sp3mqsEiY6E5BtBUOsO9Pi4QS?=
 =?us-ascii?Q?99a0JRkQFhagaD/xY7vJO0++k9MH/QuOiXDwcHifVgHrn6kykEOYIj6pBSD+?=
 =?us-ascii?Q?otCK58c23xeFS+x3xEzV0fZuYdrg5r/LO4x9Gf6VPO+jeU5UuluR+5/HFt0V?=
 =?us-ascii?Q?ZPE2ggQ9VyjK/HyPYvU2OioA+72o+cdrPK52r0qvZBA2Dzq9nkHNAtvawBfY?=
 =?us-ascii?Q?obcTLY+w7hUG/KQ2AIB4AmdunkeEHFANGWDcdlxfIb/U5IsGN47ZvqlOn2ml?=
 =?us-ascii?Q?M2/hWMnChUjYk9K3S283Qun+RgSijgmCk1bi9/7cWrHgE0lADwNs+0CuoLzf?=
 =?us-ascii?Q?Yw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85068f15-a01c-44b1-34b0-08da592a8cb5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 17:20:51.2718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CgLidjyh5GcmDBqxyBE9TDpvmfJReAIulVN8EtfTWbmlDW3bWepFaczgQFJyMerSLT/As0mHUrEe3ljXkUlfOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4337
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains 4 patches (1 for each stable branch: 4.19, 5.4, 5.10 and 5.15)
which fix 2 variations of the same problem:

- Between kernels 4.18 and 5.12, IP multicast flooding on ocelot ports
  is completely broken, both for autonomous forwarding and for local CPU
  termination. The patches for 4.19 and for 5.10 fix this.

- Between kernels 5.12 and 5.18, the flooding problem has been fixed for
  autonomously forwarded IP multicast flows via a new feature commit
  which cannot be backported, but still remains broken for local CPU
  termination. The patch for 5.15 fixes this.

After kernel 5.18, the CPU flooding problem has also been fixed via a
new feature commit which also cannot be backported. So in the current
"net" tree, both kinds of IP multicast flooding work properly, and this
is the reason why these patches target just the "stable" trees.
