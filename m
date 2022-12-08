Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E13647639
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 20:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiLHTcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 14:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLHTcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 14:32:01 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2079.outbound.protection.outlook.com [40.107.8.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6689A9B2A0
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 11:32:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SY6WseicW0CiIlPQFE4gsj2OkHd9y+auU+OZwkz+OVn5aSfuchft//uaVcxUFP88C4Du7GzSfHBpXKSf4VB9s13EO9qOoyv3BrgUwsgghdr8YkSbvFWrPsdrU3vro0W/QWYQpOe3y7euyBivMoN/j47yNGQVvNoCYra3UHhlaaDU4b3uig9z3erqQoOuHZzm73viTuGpJsp4B298FS6eYrIWPerRaAQt7O27ZAxGHfa9K7xks4sWnLsxcbQvpaobnROsKekPOzOasMEfNpFecz964XItWBr9RXC5h1S2cKWdSt+kDGJsPGjPxUE/gpA2xtzRo9IJttxnv5WtzC/ylw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1fCL7MVelhQoaHK6EYequLjHXCjOZAiUdYDmWyQUNM=;
 b=Pkb8bkXvjga1kFYDFUJ2x79fAGd/JRJpeF1hBN+zJZ/oC802FbkoZ5MIfzjbWZpEk0UZ08uNneZp9sIcuNORfakrqlbXftZ4sRqNXVdb80jAB4L/LCuh1zfGY1+iXnnoQjvInysVTCdILxRgJMWQEJ/eZyHZpagN+WTWIx0ZpNLej9T+6h0/ydFyED4PNJV4Y6XUQl8Hc+/5DXfejdPsKVtfKjsE70fzQckumqOOO9lICRdO9ccLQhQReB75of2GjepkE8ZKlx1l2nsE8KpmOFjgYDIf7Pntal0lDFBv+bDqemVyUHHeX6Z8CjbNtTWcC+W+wB8MyAqOiwBQoiRJGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1fCL7MVelhQoaHK6EYequLjHXCjOZAiUdYDmWyQUNM=;
 b=dEtkvf+8W08NtbuLmV+sArNdbG7UH08ubb/YyQ4zx4A6vdZZ55ACyoSA9X6UC7Crpalb8hW1saYzwJbRN2STjB8eVhWIV0r/yn5DOBMewIEvlw2X8K/beHB7lI4/ja4x+GDkHxXQZ0Bi05oIn2OsXo9HYCcDBt75jAcgshBMLLQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6861.eurprd04.prod.outlook.com (2603:10a6:803:13c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Thu, 8 Dec
 2022 19:31:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 19:31:58 +0000
Date:   Thu, 8 Dec 2022 21:31:54 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@kapio-technology.com
Cc:     Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: replace ATU violation
 prints with trace points
Message-ID: <20221208193154.3gmkd5us4egm4cqm@skbuf>
References: <20221207233954.3619276-1-vladimir.oltean@nxp.com>
 <20221207233954.3619276-3-vladimir.oltean@nxp.com>
 <Y5EsWNfVQrl8Nb71@x130>
 <20221208144901.tgdhp73n7g5uh7qj@skbuf>
 <9e58ec7e00a4432b1c72df300f9d0222@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e58ec7e00a4432b1c72df300f9d0222@kapio-technology.com>
X-ClientProxiedBy: AM0PR05CA0076.eurprd05.prod.outlook.com
 (2603:10a6:208:136::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB6861:EE_
X-MS-Office365-Filtering-Correlation-Id: ade58c06-59c3-41db-16bf-08dad952df12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BHptvuhPmQXwngeYJUg8AaNzIlw1vV6PlQ1bbRe8T37oN8Ul8FV/eVc9CwIt7djlgioLNMba0Y6fOh95bzQLMFRAPdSynVyWsVTBOvq8LkxrqODKP1ZMDJMX87W3jO8sslr9NZ0vjmMPmfABI5FpkJ6x0zjBlXSguYDohmUvYmftPz7dOH2i5Zhfb4v84NOoc5k5z2cCTGV+yqgAY+hkBRN/UXR9bBInxiTXaitmGINWL7YCZteTiGL8myyGrxb8uPsCAnCqps7PawpENvNJUyQ/UkY+nQmn1bdoD8RhYLGshiTiUqupPm1MF+D1t2/soK6C4HIG8t7XQoqri6YvB76jDYPzG3FXnbuafL5uvu2QotTB4wTuqCClBEdpwKyPnhO+t3vp5mN+Mqs6qKBS7FWWNnOM7WK4DqK6s0CyeNTlWhDmMjPoaElHdvuSO+cApK0psZXv21/g38nTVONxwJlzHIVDnej7GPvDafNVYGcm8BTekUkP8CN/K7MTDvrcMX0UCo5GOkugEwjHuHdj1PnMCDCuyswuWFhyhkvGvCNxs1YIl5wWR9o+OPKJ+/0JGJBhq1KaCHvWJpGXaX8IjwF7nYESTdVg2Zmssf4/spfW5O3L8LCe58VuaOt7k3C9iwHZl5IxQ2YXo81cDOBJJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(451199015)(6506007)(86362001)(478600001)(6486002)(186003)(38100700002)(33716001)(558084003)(1076003)(44832011)(6666004)(8676002)(41300700001)(26005)(9686003)(8936002)(6512007)(66476007)(316002)(66946007)(5660300002)(66556008)(6916009)(54906003)(2906002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BFSwbDXAugYq31/FCLHe7y5I7bdmUOWJoOKiVBZfDBpKsXp8fxYa7PSF43iY?=
 =?us-ascii?Q?6MFsNwFcmoFZFi4YRMaCFAf3WgCagFGNpCT1N0iX47SrhwwqSHSQbVp0yRMv?=
 =?us-ascii?Q?qHs8Q8iLx7xTQhUPDQ4OJYt6w4VUJz/1iuEN5FRUnfCDHDeHvLVcC1djXuB9?=
 =?us-ascii?Q?MhTg46JmT7inOpmRGJgKfCbRsBomrHaCHhBG7XoBp8g5zw7Z4/hpSoGLZY9S?=
 =?us-ascii?Q?bKGNi0EogIdnY/mAmm0etAqIL2/+8Wo+Q2fj5rAu7zu8I0jvq9mg5KzmXLTY?=
 =?us-ascii?Q?BWmLIl28lc9M+7rNPlDrrIuxGdUEz6Co9Z4B7MLKg5Mt7lG7F14GdcEwLKMK?=
 =?us-ascii?Q?aR+utbfJDoEGr/t+uO6MVEt7b+qwCDMCDc27bq7rYrQ3tKxLQbezHDDQpWlr?=
 =?us-ascii?Q?daRdRDad8Vf4V5HliqdX7GHffAd/YEI0HSVodYNqLxwVq30gtrW2ETOJbdUK?=
 =?us-ascii?Q?yQHJauul3nhug2DqqP7B93AEnHJ2UiTkyEysSjZbHglq18XggMRgril9uY5T?=
 =?us-ascii?Q?cYvPVBAfArnNLDQPZ1EiaeM7wjU5JQEICzOxNjsMOjzXWfweMV8TuAsHa4ml?=
 =?us-ascii?Q?T+35o1oNxLbWwNjbKXZkFfPeNKsERvC938Jqyd4HfCZlRyp6BAhz1qZJpv3q?=
 =?us-ascii?Q?Uuc/xT2tHbRgbIxPJw3smcabyHNmwwkPNqaideUgYefeuQyvCZQmc8aRPRX5?=
 =?us-ascii?Q?CrISUymtbmOCBf7zKAe/oBm+jWZER3NHFpr9GDcW4uSZhZgie5FHRpvzXsOJ?=
 =?us-ascii?Q?mAsId+4S/VX18snxuR8wb6LuCUGhddcoA/FfykC8984n16tEQj/74t0G0US/?=
 =?us-ascii?Q?LQJERnCPSmQDtG1p0MCWVQaOu5pZR3722r2quzoQf/QSMehkSYsEs2L7CH6o?=
 =?us-ascii?Q?PKHelDIuuWqtbewvpLiZTT+35xQvLloNnjFyPIbvm43DUpYfCXFJHAWTdk3W?=
 =?us-ascii?Q?7sehAVfkUq3IqUxoh8lD67vjjHQZd+ZX4Pq/CPw3U8R4Zeh4Q29oknqfx8zX?=
 =?us-ascii?Q?xk7gcUVFD2hr9r2DbQ2JEa34ZOrDf6hYaO2kRGy8qhr/MZz6tD4pXteVOoLT?=
 =?us-ascii?Q?9Q/dLH4yAGVJS5MbgCgdQunjDrxsNKzTNvD9wYIS3GgsNPCh89HLNQO/teUS?=
 =?us-ascii?Q?mzZCJIHNcpoX5mUzzUiai36zmFXRNS/6XRr4uyFzzk/0CTLcINKuxHkMRgte?=
 =?us-ascii?Q?1GsJWsWiWLuyYpHFq3WWRj3Dn18b3Ap5LJdTxFoY7G93HZBlworB33JWUX6x?=
 =?us-ascii?Q?RLdG/dsIkboLAC348fBFzx9KoLJQZ/3IZiiQPEiAWtoEjf3oepCD/6eoSfVk?=
 =?us-ascii?Q?XOFfa3ppDXOJTEdS/XCsTEfKJOz+XBzD3mzyDRYBydcNp95i5WUmRinEIgvK?=
 =?us-ascii?Q?OQd6iHXmB/w/LYv7zqQAZ1zY2pI33qhOC/0hBQq4nCCWcuSjOA18ybi0lRJv?=
 =?us-ascii?Q?2qwJzGwNaJ6NuIy8U9IEx6TFVO3wk3cvLgqNOsv2JYptRH1wuG82duWZPi86?=
 =?us-ascii?Q?yfEZof3whUv7Bdu9LFtyj3TTWDJGjAf7FIoR9uJoaWac9QVfyRhfsxyH1qi6?=
 =?us-ascii?Q?IkgJKpFcKdrx3lAITu3PZEnxZcluKsFP5q06RIG86uQK09b10tOdeU87Gi3w?=
 =?us-ascii?Q?YA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ade58c06-59c3-41db-16bf-08dad952df12
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 19:31:58.1115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j2MYBoDtJ3BLqbqx4iwXD+0ZB3fF0Zt7bLybPFdyQ9sr3Ipy2dueVXNxFe3pebbPVC2596V3wZhB364RlZRTSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6861
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 07:33:50PM +0100, netdev@kapio-technology.com wrote:
> If I am not mistaken, I will have to wait for your patch set to be accepted before
> I can send the next version of the MAB patch set.

Yes, you are not mistaken.
