Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D396F67D1F0
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbjAZQlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjAZQlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:41:08 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2061.outbound.protection.outlook.com [40.107.104.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E771C4DBD2;
        Thu, 26 Jan 2023 08:40:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCedKCTKH8cNdT/eU20lDYthhT5SQkNHqpc610xhc2s8CWTA/G8LKDJIR8pSS9H9yzTIMp+mlv1woaUQcXIds0bV9YhCiwx144d8uHDZTpobCGizHCdJV3mE84oxhf8wVXi3Rz/dPWh3zJ0w7WdzjAuyBjKaFu/2+QXaAVWhmKAnxqHP70cT8NXZxt3zkQGkKcUChlqXeivvl0JuDBHWhMFajmO5ExtdZAMDg0kqX2KDJUyZEnltnBlUVk96NmwBM7hPKSbRp48GD3MBoFMT0kCIg+24gGSo2JMlpVUpi5WyTRy1nM0gmeZumSRlFd1CH0nBUhfiG/c13uWSbGfHSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=69M+rqyAD24ENZGnwy0Fs6447mPizigfkZ7UDt921qI=;
 b=Vgd8uRpzhPYxLhXp8LgWmWJrWzZcZ3Q9WE/KADGqlVyg7pn8/eckC8p3POvkXnxXLQS4K07ril834oZti/3MS3s3LI01Yt2NDVMH9M2oUSbyXFUxvSpK066SusyRQ/qi4mNCOpnNI0ShXHFTklx3cxzMUHEpOw8bKPYFngdZlIE919IMYsbOQ0EJfg3gzL6vfQPS2PJrni6VI6bG+4Zyc/t2+bTR9sEGthyhIBYOs1VadmLDo6M6MQjw8xDRbPKR+sxZihiEfr0LdWVluPnMIi76qosLv1Ou3GkclB0WFeFuX/CfngTkw2KERxyYI1BUHBfxD/LQVAzGb5cL9J5GcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69M+rqyAD24ENZGnwy0Fs6447mPizigfkZ7UDt921qI=;
 b=JQeO88lmqrDgW1WWky0LrN520k61ji//1lxLmJ3CJL6CWzHYMThBC0Ryy7+J0pxRXPuRK5PGC1jxNfh83tlySWohe1gG8aSNtu+Y5jJ4sZdyRBm0yUk7xmaiw0+onekrXMTNM+vX6rH2PCfyhV+shmQiW7kn7XSLL2zaRHpv+SA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS1PR04MB9240.eurprd04.prod.outlook.com (2603:10a6:20b:4c4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 16:40:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 16:40:51 +0000
Date:   Thu, 26 Jan 2023 18:40:46 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mscc: ocelot: add ETHTOOL_NETLINK dependency
Message-ID: <20230126164046.4sk5qaqiwgygt2cg@skbuf>
References: <20230126163647.3554883-1-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126163647.3554883-1-arnd@kernel.org>
X-ClientProxiedBy: FR0P281CA0097.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::10) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS1PR04MB9240:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dc034e3-2405-4d80-f4ff-08daffbc15b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rsW4myjwFtNnBIsuOkGedPL+r6RX8CWLUbOp6/f70VB3r85abfZ8VmkT7nL1fLMITlohn8UkUvRqoIUUxEkODkfhsxA3boYAVwUpe/xSblCmTvfOsxDp1pUevXq27RhW6OqpXoeaJvlq7aVEEXaaGzE22GuEFIhcZ2IyBcf1No+Wut+FRnX26DqOcRiLvIRFn3ff0+OAXchOtwgOaDHG+SLyCuEP8hD+2CQXYaw5hgGC93MxyA57BPA7wdv638uxE6org1Fe8HTNxLS9oJIXUSCrjQOM24Qvr2Woq5u1z8qsHRcnn44oiL+XZ39DNmg8oUDsDyUzdR5qvQepC/RjU7CYIRfPW985SJ6x4fE5xjW1ZdFeUx6dKwk+eo9x9mtcFbcCDg4NHVrTuXH2wxppMuC40BlhniOToZf6Ut35lZYkC/AsdbpITu2Df/nPSAth9CUdkAWl27Veh75O/gdk7FxNZlrSWdwN5LhjIbNXXwzofFc/7WXoJStt831aNWhyR2vwgFJTDihlKk/z+M+csN0D0vWNCEN9h6cXBOGv9Cq2PqVzFb5LABdVJ755hpj1Xhpke+DKtGtooVX2IDCOLUWqGGloCQf3iE9bn5ZkV501AjVXVOMafBTBGvDdl6RAU7poXviyGb1qsIco143vDmHwir0cPef3KzenAPfQoOM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(451199018)(66556008)(6916009)(41300700001)(8936002)(66476007)(5660300002)(44832011)(2906002)(7416002)(33716001)(38100700002)(8676002)(54906003)(478600001)(6486002)(66946007)(86362001)(4326008)(6506007)(83380400001)(316002)(186003)(9686003)(1076003)(26005)(6512007)(966005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PWVT4VGGbNY9NG9rM8GLqqVHp79ZURd2KPOq1mSef6kziI/aO+h6Qcw1SSph?=
 =?us-ascii?Q?skjentAFQOaTxkQbaV/niaOUVWMPd8YlbafCBXAsOxJJ1zWioBhhZBRpNWWI?=
 =?us-ascii?Q?n3gWgrXTb8fss5cdyyQLZ8nUfuosUU6OAkHUlrOr8iPnIgDwt8OpUEI1a62s?=
 =?us-ascii?Q?c3PP84lUV6BPTThtxuWzF4A2rT7JyM13uCTFfrCE9zWNCl4knbuVBmhDL+gY?=
 =?us-ascii?Q?1kZmbFjQqgtTY3l65RM4Pa8y07Pc+xmlsdu/k3HhX7SrIvcxSe/dt7J6RHb3?=
 =?us-ascii?Q?skwsBEdfDTqzzn0dzXVVdVHsxG1zC5SOU2DRnn+iA7pJB50iBK63ZSs/T4kd?=
 =?us-ascii?Q?zW8jOAcqIJqjvPcCmAjZpqGe56FNGW5N2lTFYAAws+ctlgF2ebk6QZMOrj57?=
 =?us-ascii?Q?YuRCpdLg62orP3m44NwD9TSYRnWFEz9SlUpwvNtzecsGRi/2pxA+yyDlKM4H?=
 =?us-ascii?Q?+15utbWXdcuyzuRqGM+bcwOkRkzZFRdgKFh5/Jc5b3PwTuKwvYReg6JkDExn?=
 =?us-ascii?Q?BKhL6uCLrprP/heQLIM8gO6yCBeNL9L6Sw8tCTT6arz9N3IkrRKaaRFvf1ia?=
 =?us-ascii?Q?nyJnAdTAHpRWfYXqY9ioN5QG7uZdvGAAYVcRgp98lsJ7Rl9GpFYkD+2Tki4V?=
 =?us-ascii?Q?HOcYvpjNL2OvUN+M1wIqgcRNvx0quHLEz5izVgTR7BnRRbj1nMZTewfoiAHL?=
 =?us-ascii?Q?hGn2VO6unGUEI8qKOgV5EeP6UImvo+BVERQNn0H01/Q+pm9ZX0b6kyRy9wl1?=
 =?us-ascii?Q?kMiYOHPK7oZ/24Ywtn9VAZRRkID2KdtFs3O0uCB/iCKteBCx3I4WYFt1kFZv?=
 =?us-ascii?Q?yWWhuUex0GugbVdNQCnp7DQOD/n/BUX0yho49+25kDY2otIxHUzBIRK//3aj?=
 =?us-ascii?Q?lK1MeW/5UNG6hSV4/TTuAUz2rjDwLLfYhMRcrBsOD4nDwMPe28cA6hskIGbR?=
 =?us-ascii?Q?tWM1HhgS0lX2yt+0i8CPUkOkz1hA9Mm/doZe6d3OI3TmHY5w/gF7OWYnonsf?=
 =?us-ascii?Q?EmVHSykq/xBqa1esd1nfHn/PJubaRrnlf5VkMSQLbhbgUKEHw53VWdOxM8PK?=
 =?us-ascii?Q?UQkseeApDJHmSkfXVUgSjjOM0cWBau9Ja8DCLwYfrjeYl3HkeBuufBFG0kJW?=
 =?us-ascii?Q?zWrLbhQNP6PTIW4NzhJLoJkHdTP9iKLdZr84N/ib9JjsbVQC5adRKXbZBd5H?=
 =?us-ascii?Q?tIhKjIx1soPSYNXLNM9nsBpg0O/AtkMrsSTq9gQuwnHswQuAEGNNMmCItkp8?=
 =?us-ascii?Q?FS/rZsE+O55P+BvBCo1S2YmK6SnUzRrQYQMO1VE9bKnV+fl43e3uwkqP8iEw?=
 =?us-ascii?Q?Pv1JYiIaz8iBhePvaDmjXuyAqtmuFnPmLUl8fE2As2kwui3ZSXuYE/sPllpa?=
 =?us-ascii?Q?3S1DByfCoOOUfY+eo4oq+pleK+td3bG8WWIlgyle/BkgIP8K+vKcIFx5hYSY?=
 =?us-ascii?Q?dpcgLxgp65EzEQR8wtDrjQNiCjfCMuRc4+wAoMxcS0hFsljrtvtlvPQUDFJ2?=
 =?us-ascii?Q?5+BEvlznSrhc9rM+ykDnozHnmkFLythEiD/rZjKoxtRwni9gYOnKtXw43DCl?=
 =?us-ascii?Q?BlwCLNC6Hh26jqM8AlzkRWxp+QvEcqgIZNS1X8MPwz1CqiMFmuwtqveZISBm?=
 =?us-ascii?Q?3Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dc034e3-2405-4d80-f4ff-08daffbc15b6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:40:51.4592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YBFViJGJ/8gZJ9nBoSe/hlBljuCtG1fAdlWn4l322hK9W8zELUVz0TNAjW6SZEx1laBJsSekbAq0qK4KR6O4nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9240
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On Thu, Jan 26, 2023 at 05:36:36PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The driver now directly calls into ethtool code, which fails if
> ethtool is disabled:
> 
> arm-linux-gnueabi-ld: drivers/net/ethernet/mscc/ocelot_stats.o: in function `ocelot_port_get_pause_stats':
> ocelot_stats.c:(.text+0xe54): undefined reference to `ethtool_aggregate_pause_stats'
> arm-linux-gnueabi-ld: drivers/net/ethernet/mscc/ocelot_stats.o: in function `ocelot_port_get_rmon_stats':
> ocelot_stats.c:(.text+0x1090): undefined reference to `ethtool_aggregate_rmon_stats'
> arm-linux-gnueabi-ld: drivers/net/ethernet/mscc/ocelot_stats.o: in function `ocelot_port_get_eth_ctrl_stats':
> ocelot_stats.c:(.text+0x1228): undefined reference to `ethtool_aggregate_ctrl_stats'
> arm-linux-gnueabi-ld: drivers/net/ethernet/mscc/ocelot_stats.o: in function `ocelot_port_get_eth_mac_stats':
> ocelot_stats.c:(.text+0x13a8): undefined reference to `ethtool_aggregate_mac_stats'
> arm-linux-gnueabi-ld: drivers/net/ethernet/mscc/ocelot_stats.o: in function `ocelot_port_get_eth_phy_stats':
> ocelot_stats.c:(.text+0x1540): undefined reference to `ethtool_aggregate_phy_stats'
> 
> Add a dependency on ETHTOOL_NETLINK, since that controls the
> compilation of the ethtool stats code. It would probably be possible
> to have a more fine-grained symbol there, but in practice this is
> already required.
> 
> Fixes: 6505b6805655 ("net: mscc: ocelot: add MAC Merge layer support for VSC9959")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Thanks for the patch and sorry for the breakage. This is now fixed by commit:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=9179f5fe4173
