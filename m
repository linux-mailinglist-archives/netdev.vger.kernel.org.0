Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894BE6E32B9
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 19:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjDORGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 13:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbjDORGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 13:06:16 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2051.outbound.protection.outlook.com [40.107.105.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A88B30C6;
        Sat, 15 Apr 2023 10:06:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgGpYkWVzmYwabqg/1WYzdhPwqfyRVQNArLDwF60u05x2dHsaC41Eb+NclXiymJ5AcgqSZR1TWJclmJDuSSfOgZSSHn8csBXfEsLmJh1T5IT80lPR2RHjc5CE73s31t+gX55vWedaIpz3PAVzTcE8gYTYl7dp8mwXaMGXkELki8Z5IE0lXM+9Jr2JZw9/fKbDYbJLEm403dgEwFY1/dQx8b4QJSsRtcEhk5ms785Fukg7ejN/PLlAtXHZhjID8efd0OVi1Ej3Vf3KSygrL5eHAX+z+MyvJ++37Z/REZpYPfLz2jMGbrn3xJ/KrBeFRmvKuEppgN+MmjlV8pHlBQXpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7XO6Vv3Pdc+N+MCXSftnkk0NDi/KSFwnsmEPh6i+7A=;
 b=muG0TLHQlxUGhekyU60PPL33uzJQpp1L5ddJ7Mn6uJxOfB28hLqG2KLJ1yOR9/l2EJdBN42zU3MBnUb1myx+J6hnEjgnNFVcCXu9IM8F4oIf/1fuQmo22oApcPAquXtDvcpJOvsbGX+0be4BZrqd1rukQ8tHqrDJcn+WwDm5BCZwpg56ulo0ud+v+eEyVBeAfU7Wr5SzusZuZaPt1+thfLfAIad5OiALNoVtN7XWqz7D3xfZqEU2IA2a4xvr/DW97nqNJdO5UBWSsl3Hp3y5JMOGUme8qLoAGcUL+kUR5VdViLTTH+YX7/J1C+hAqhUOQg+/iVT5FDEBNA60B9pu/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7XO6Vv3Pdc+N+MCXSftnkk0NDi/KSFwnsmEPh6i+7A=;
 b=OTlUpyO4OEVWyqbA1ZJguYyBlVoj4geH+JTZMwdmZxvmPllpPbSbEnVO3ImP96dWBnst+VGNwBPBnMoE7J57wuM6ecZZs24gP8+29RKn1RBOSC6wByoWArmfIPNSkDyAA6T9CwLiloPZU/2y55jQL1hpu2vZhdlJC1GY1HghNyQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8158.eurprd04.prod.outlook.com (2603:10a6:102:1c3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sat, 15 Apr
 2023 17:06:07 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Sat, 15 Apr 2023
 17:06:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/7] net: mscc: ocelot: don't rely on cached verify_status in ocelot_port_get_mm()
Date:   Sat, 15 Apr 2023 20:05:48 +0300
Message-Id: <20230415170551.3939607-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
References: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::6) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f5aeac5-eba5-41f7-605b-08db3dd3b3fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VBrHHg/eUkVh/WCtBwtKNRiFlCCQqxLa4uX/PkyItxjL6a7mBwZuCqF84P0SAZUDhVF9pfl+rWgv7BLgmIVhDN7w6iSMLlqnVcY0LLI0/Qt/c3RJsm5xSyW9WkZKepnI2/+rTl2edDqXqGMdDa09wuL61ybXhjn6kwEHlCzZQnxI7efc3NLkixyROrloy0KXs+fQZJnfThASUAtm7UJ3i3o50VgX4axDxoDyIe8042aNb++9oaMhfMzLLmCSvmKpNkyuJSeXYeP8YoDr2QbnCwEkJm6lfr43YWCcmMxZwNvVGeOWZunVb/jV3mirAIJQCiTQhsTBk04YYvQT2vabG9B87nqXEWgYyeKDdMZCal13TDxuurleTbWV1kaH4suKixOeIBVFbYRgVh4N8Ls5PHcpfHJmwxPSS4GfpyMsX2PenGpe/HsdZcgQL/GR83nNHP861yjJgJUZmjz953FKD5cBM4pmCDDLLKCdzuPHuhdnwaMWwvpdfEEHN3VURKvEUx5cjC9Vrt8XOnzWIknPFuZQ789Zyzp1WRF6B/ZKTKN1ishESqeh0FsfNQ4jlPgz7+BlhT2nG067CpzwC7SUrfjU4SGTEbWcJDMyvaF3GNgq4YDaMJ/Jw1yg/q5wIV4d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199021)(316002)(4326008)(38100700002)(38350700002)(6916009)(66556008)(66946007)(66476007)(5660300002)(44832011)(2616005)(6666004)(52116002)(36756003)(86362001)(6486002)(41300700001)(54906003)(1076003)(186003)(6506007)(26005)(6512007)(66899021)(2906002)(8676002)(7416002)(8936002)(83380400001)(15650500001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mESD1yvV6b8ZtZIHgqzPqEqWIlYoUJiLLfL4bfxI3eCJVfD7xB7ZnCECTu4c?=
 =?us-ascii?Q?yFpjdjMCI9sbTFC8W51HXfOAK8I7wdYVnOrAEZV4rMmCz5pnZQFdaMn+yYAJ?=
 =?us-ascii?Q?OkJ+N6JC5crKDNIx+/d5uJeuOoGMT612pw220vFvADrw912R1LPqLtw01B3E?=
 =?us-ascii?Q?Sz6GzWdrUOkS1/h5owLjwQ4JQLseulo3k5X3B/KlKK1kiZ9D+xIexK+orPqV?=
 =?us-ascii?Q?bI2vhnXgY2mPSIBOEeDIbFKVqdttjRoboUjjTb/W1UZ5pd0IGsnTn0HMhThG?=
 =?us-ascii?Q?nhsWN5IEvlyomnU3dKHUBdP0va3QmqJVJQ56MnoFBnQJ1KojyS+HThh9xC92?=
 =?us-ascii?Q?CjHQiAhWdDRJDz36pZ5xQCM9D0YOVs860+HLswuTDAmRY7s94cOm7WSy4pLt?=
 =?us-ascii?Q?nNdg6+oyEaHjcRnexLLHx8moBKqKnIcszooAA+t4leg1c7K8Ncg3TOd/nSZO?=
 =?us-ascii?Q?87bOFnfrcw54fY+L62fgqYRl06rjfhz06xfXMBbOFvYTtgep8n2tHZsDxJw7?=
 =?us-ascii?Q?2lL+iRAfTNMM9Z0wkSvU7Zn1r2hDnT5ZQd39QUoIkb1M1kcrkJ0g8qUHCSOP?=
 =?us-ascii?Q?ouS6zVegXKXxB6iVBDcSFDht4stYD3eS9/sQ1OYxHfAcah66nk5bWfSwjvvF?=
 =?us-ascii?Q?/P5qkUr1nr0uzDhYE1Qtle4Ub+ETLF7Em/KSu6/gADnpEBzJx4hPr6XKJQIW?=
 =?us-ascii?Q?0ziwSw1c9KqP8pP1I5/KuRoupXzLD6fjkcW1DW3a+GTHt4YSely/xkg1FB87?=
 =?us-ascii?Q?mp6jg616guYECUmMRQiurJmtNAK44GfsrVpSR2GrXQ8JP6U6Y85rT/PutIsO?=
 =?us-ascii?Q?aHVIG1ZRNAAFKwuf4lu3Jaj6cw1iES1PE4Ma2SbvEwV90icCJUX+qY4o7rUA?=
 =?us-ascii?Q?vKlJbHFwgZ11IT7/jv8wYA/H7kNZ8O6nOgx0bGmDSehZg537l51AqNBqsohE?=
 =?us-ascii?Q?fmIwc8uFZiXm/Ii6Tls9mf3WJmKMkBRFjr/oDpJsQbqRRz9MQb0p747CorgF?=
 =?us-ascii?Q?AFLhMMIRZpkdEuuFv6vZ6w2HdfoZdBVOixs1uZPNmcp50cFfA734mBm9JFzw?=
 =?us-ascii?Q?+Z44JCTtTJd2Bm1Jp7Nav0d7XoKjKF7gja+m83Hc+60mhzEICFRhtJs26MP5?=
 =?us-ascii?Q?T7iVAzy9i94fqQ+OYbRWeTQdjinRqqBqRMes2QDWSqQT5lxk1Fqp/WfCPTrJ?=
 =?us-ascii?Q?QBWVec9NXqosijXkOi0+wYsDC4BAYiXCymm2cEsQEabnWr+G9/WTjxXkGEi9?=
 =?us-ascii?Q?eJpO0m/dR9km3HLoISz3GHVmj/MuYsBmq7bdaHJTWFWl31DNhVllI2bwinB9?=
 =?us-ascii?Q?11lmz3EOJXgFxRG1F0DS17nBPZNMQYSXfS4ydJnD62+AOuDkcqocw0nkmRV4?=
 =?us-ascii?Q?y2xCGIZpXfugRTAyU/m1Fs262yEf+Mt33Kjv25eDmm1zRX1z4Wp9c5LcUGHK?=
 =?us-ascii?Q?7BDAH7uoKV8axSCG4bZHrKMbVXIhFAE1/zsZ4ha1QRptY6XTqb1fqybeSOj3?=
 =?us-ascii?Q?SRyQBmu3whBc7NAN4RltSp4epN15fdeo6esEbHoP6FvL4qUWgVBW7OMqQ0re?=
 =?us-ascii?Q?0qvAuirfY0p/NKdEQvWJdVNBuU6WYVtM3WGMxsbqbcXLb8bXsyPNfZCGa80s?=
 =?us-ascii?Q?KQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f5aeac5-eba5-41f7-605b-08db3dd3b3fb
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2023 17:06:07.1686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8h1JB32CE59SiZ4ttXjyZcESPbbldgJmqqheqEYwx+3oP2YNSdq1N1v+MpR7aYkyttYwyZdIVtsSvWaaj3xtPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8158
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ocelot_mm_update_port_status() updates mm->verify_status, but when the
verification state of a port changes, an IRQ isn't emitted, but rather,
only when the verification state reaches one of the final states (like
DISABLED, FAILED, SUCCEEDED) - things that would affect mm->tx_active,
which is what the IRQ *is* actually emitted for.

That is to say, user space may miss reports of an intermediary MAC Merge
verification state (like from INITIAL to VERIFYING), unless there was an
IRQ notifying the driver of the change in mm->tx_active as well.

This is not a huge deal, but for reliable reporting to user space, let's
call ocelot_mm_update_port_status() synchronously from
ocelot_port_get_mm(), which makes user space see the current MM status.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Diff: patch is new.

 drivers/net/ethernet/mscc/ocelot_mm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_mm.c b/drivers/net/ethernet/mscc/ocelot_mm.c
index ce6429d46814..3e458f72f645 100644
--- a/drivers/net/ethernet/mscc/ocelot_mm.c
+++ b/drivers/net/ethernet/mscc/ocelot_mm.c
@@ -205,6 +205,7 @@ int ocelot_port_get_mm(struct ocelot *ocelot, int port,
 	state->tx_min_frag_size = ethtool_mm_frag_size_add_to_min(add_frag_size);
 	state->rx_min_frag_size = ETH_ZLEN;
 
+	ocelot_mm_update_port_status(ocelot, port);
 	state->verify_status = mm->verify_status;
 	state->tx_active = mm->tx_active;
 
-- 
2.34.1

