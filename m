Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884676EFB44
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 21:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbjDZTnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 15:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238479AbjDZTnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 15:43:15 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2054.outbound.protection.outlook.com [40.107.6.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353BB30E3
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 12:43:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRUBDmVuF4vyWUeBWcabeL7rIx5BX+cJf9+ztT2GU6iAmMLe/g+lYfiCQRBX7kVv7OEG+SJmd5y68XAMa3bkhR4KKyYkwrwgYfszZs9Vun/xk1Szs4WzG53IL3PZ9BN5yN0L5bZphABqvcV/vI484OzbF0HwMEyqXLADy7GuCEUIqcEeh1aybeV/eEnepnuo1Q44GWIIHl92U3t6tdIJXY4BLzM53E9464TsCda8pgcv8lEz4a+ZksXlMrkXsSExGg1xxjgPLvLuIltBHNk5WO56gKNiPRqHcOKKTZiscq+BhGYHhUGpmQL7E+XGSzB6NUapJmzWnxyKZ62/9TbKog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rnPEZeZ/uSZZf4C7O8vfAedgyUHWqZBYmA+MVBIbcO8=;
 b=K5sjQeX9nbRNRjnQY+TMK7iXCPqR6FnTLuaSSxSGwez9haHSvGP5C4lfef/boqb/hVGyp+9TVIKhw2BplLaQMN1IIQza8mnJwqIhseCI/vpTIMba+TPmEut5jO8VzU2XE3QAhJwVB7SVq464sfjBzMgbYTWz3MmmgyEikKY7olsLxOxfL8PB6v8QUSzW+ue6xfyOLkbqQKLPFPaRy2MqXxYt3sJt41ThTuULP61Kl/u556AV4rtRENxnmSqWpxOfgpBATKa50LMnX/akKr9xVrP0KF/yjn9u3myXoVXUtxYlpDEHKD3seFeyN4V0Idud3zRJTKVwJ8HyjYXOeFkf7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rnPEZeZ/uSZZf4C7O8vfAedgyUHWqZBYmA+MVBIbcO8=;
 b=G4XMmbafnwi1nQ7work0WOGaJcZnzwZVNf5ZKc4YKzvnf3v4ENs90muISTXBz9uY2gvduKDjuA6LaLmS6AulEp7Uth8Ikq6KzA5xQnbQmaUnFYqLCLLjgLyA+wVvztRtAY393LcQTFkqSaGR8cytF6hcwyCenqcILA7+Q3PJqLQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8526.eurprd04.prod.outlook.com (2603:10a6:102:211::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Wed, 26 Apr
 2023 19:43:05 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6340.021; Wed, 26 Apr 2023
 19:43:05 +0000
Date:   Wed, 26 Apr 2023 22:43:01 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Steven Rostedt <rostedt@goodmis.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 0/2] DSA trace events
Message-ID: <20230426194301.mtw2d5ooi3ywtxad@skbuf>
References: <20230407141451.133048-1-vladimir.oltean@nxp.com>
 <d1e4a839-6365-44ef-b9ca-157a4c2d2180@lunn.ch>
 <20230412095534.dh2iitmi3j5i74sv@skbuf>
 <20230421213850.5ca0b347e99831e534b79fe7@kernel.org>
 <20230421124708.tznoutsymiirqja2@skbuf>
 <20230424182554.642bc0fc@rorschach.local.home>
 <20230426191336.kucul56wa4p7topa@skbuf>
 <20230426152345.327a429d@gandalf.local.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426152345.327a429d@gandalf.local.home>
X-ClientProxiedBy: FR3P281CA0176.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::11) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8526:EE_
X-MS-Office365-Filtering-Correlation-Id: df217d2b-a4e2-4643-1498-08db468e741e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 33iqCUEZuzalv+iVSnLsLKYHLuQoye97cXyYHNedYghR3QN6qBuk3p9DEh2UGnj41XoaYZ7s8nqqOXb+Xg4YD6TZtQ1pirIiD23y9NwqkxpOTIoaLVr8z4aUgkr5Jgkk+nVZrkkptYMTV3+XNGy4EcOhYt5H3LmJkt3XXrTaZQJqF7ZI4EF7fVqfAJYDUmrwiHoEWUF4vzfx819MaW62kT+zpYdRvIimqQqQz4zwtc9bCe8Wh5BdNLn80RpHmRZTZJ8p6/eOhjy32SwvT4hPBqFi8pKrnuXUYbkX7kFDw4c6nhKRVJLhawtLje0iRMgAfdWI2/RcSIWvejJEdErIsK1x/iu96RRFwGu9k69gHHTTBAsHSCIDj2wk9V76172CYxCwXlK2MmgZCJx9fYdncuLbFD3ps9x40GdqeYLhuCg7bX7taWOStkzPCzA81aXftI93bl/0uVfechXZuxaHCaafWhVD+eMTNqEipWx7o0HhYvOZQmnlRf1PxqcaSJHjBFJW56lHxu5UVNlFCclKnDNkfbuOzOt1px/U3sj8BEhQuDsDo3G0VPjFuDfIAdVD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(451199021)(33716001)(26005)(1076003)(6506007)(6512007)(38100700002)(6486002)(478600001)(66476007)(66556008)(66946007)(41300700001)(4326008)(86362001)(6666004)(54906003)(110136005)(316002)(83380400001)(9686003)(186003)(8676002)(8936002)(2906002)(5660300002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RbrZSzbpo0oTrki74st/1UkD9M11EoTcod6ye8/SMDU7wN7NL4QsrevXRObh?=
 =?us-ascii?Q?TrIbeOJYvLQoZ3eAlU+S3G8LtjlfV6D8cwvGPut8eHmOUPctUHKrLfgRlr/g?=
 =?us-ascii?Q?p/kaj5q/6uT2xGD0mPr8w1qawjM93vZ7ldOk8TGdsxz9oklf4rN0rUm5EU7R?=
 =?us-ascii?Q?dMnSqNiWVLDOKDlOzzcwcL/c9l8oWZf/yQ+i9GC8n1RpV0u9YEOkcIlQziFS?=
 =?us-ascii?Q?jkGk2r4RsN8n7thzVrvGmwAwmOPgjPwegGC/kvZJl0ENUERi/MUZBtFJ0uEm?=
 =?us-ascii?Q?KLfB3NTse36gQFIWkYrDYfOFnPMg9aimG2B+zbfBUDWowccHsQGU1EoHYKiU?=
 =?us-ascii?Q?VEOVM0YknB1o2uFUISJxNaa/VHaq4XDJHG6GqSnaILztOzyGGe6W8t9hNf0p?=
 =?us-ascii?Q?xQoOfspnqDw+aK2slMjlxOykAcb2FH/hKptKyHjGrQCIN4iq9v2myt6PykcX?=
 =?us-ascii?Q?l9AyCv/yZnxO6XYp1zDQ/dNAq+LrxA0BEWo0HlGkD9MgXYox5hqHpmnFftKq?=
 =?us-ascii?Q?L4H3qF0o3FZAjDQdnNvVPHa2kW+Ykhqvr8634i9po4xugdpyJ8gj5AEBB74u?=
 =?us-ascii?Q?+YKj5D0d2b6XPEQa+dck9mTHbpS7zYEhgMPeaLkHMh41EVtYPMsSkt5GzYL1?=
 =?us-ascii?Q?O3oJI/gPrpyptglaSeSB19oyo9+DNLSOapV9f/4XRXl7Wp9JAhRZAI204Mnb?=
 =?us-ascii?Q?n6Hy4rCbkGC7k5o+H/FnBCKYKgpHW9Rb046PUCHgcfQ20ciq5AApYy1pOEeq?=
 =?us-ascii?Q?/VsUcxCGKuwev3YsE8D3YHIIKZwH0iQwa6Ukj06nQyiEOJVG9/4aeCBECJ9K?=
 =?us-ascii?Q?llsL0cOc8iW+sfD9HTAneaLM2uAGFoGpA/ny4pdytt6VIz0voxJ6eNzamUL/?=
 =?us-ascii?Q?rqH0EVSFe761wuxfFZjsS3e4/HuqvBz/6HC/mU5zwgB6SYfZwzBIqALxt4HP?=
 =?us-ascii?Q?Djs50q4hbW4V7s8jPgSIqaa+WrtYJpwLdDnWT/U7NuDCJsO+fuVu4rG7uSer?=
 =?us-ascii?Q?yc23T5K5xrjIupaTOR8O8r2BbAQb1v30bFTRbHzEDEJxDq411t1hARhEqx2l?=
 =?us-ascii?Q?MCtlZK4pbsK9APydEahgWVrMxC8lbcAj13gS28p6I2KfWYDI2uxfD8QPMB8R?=
 =?us-ascii?Q?HA0bTnGvmo+sZ0Ly2wEinlKdPrl+Dmf0wsnIe70051+kGGhmis3XS5AvLYUx?=
 =?us-ascii?Q?QQkS7CkSH+30F2cWhq0Mk8bLxicIR/1DbA7jq5bh62DdQUIqroE6tMtdlpIN?=
 =?us-ascii?Q?Iqcn8aczpGp+dFJDz1R0pCrsjkBGjyVxJM4YU35Qbzgt6EDBkFOjP9n/xRh6?=
 =?us-ascii?Q?FZRdZ33w0NV9CO3NXDIRuZRPps1FOXFbFKfB1GFtrwPeELoq5QDlpZZ4333J?=
 =?us-ascii?Q?2pnPC/9Zn0eDuc2LoO2IX6nt2p82EidQdI63w3c/PnrnoRGZRskOukgaMdvi?=
 =?us-ascii?Q?D5rEabMqSR8pGazNw2vZokB4/zbtHTDlePvBaX/rk84zvK0VQZZr7OgRRbZg?=
 =?us-ascii?Q?ujPYHrNFkAlq3uqM9DBMdb7+0g6xtCeW3VbhMijsc78V2VHJMrTbVrnqtkcl?=
 =?us-ascii?Q?vzvCiYnRg1nfwPulmwufD1FdI3MwcFUFuz9ZcEN4AKjLePZBjYqPDX5OrO1r?=
 =?us-ascii?Q?8Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df217d2b-a4e2-4643-1498-08db468e741e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 19:43:05.1857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UXfRG3QmabUPOD8QtkMR5oDBRTPOP22GFctFciMeJygXnsNqiZaKnmkRPkeXk82B9SmHwH8vTY3rbx6TmcfYtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8526
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 03:23:45PM -0400, Steven Rostedt wrote:
> There's lots of events in the kernel that no tools use. Do you expect
> anyone to create a tool that uses these events?
> 
> We break user space API all the time. As long as nothing notices, it's OK.
> We take the "tree in the forest" approach. If user space API breaks, but no
> tool uses it, did it break? The answer according to Linus, is "no".
> 
> Al Viro refuses to have trace events in VFS, because there's lots of places
> that could become useful for tooling, and he doesn't want to support it.
> But if the events are not useful for user space tooling, they should be
> generally safe to keep.
> 
> There's tons of events in the wifi code, because they are very useful for
> debugging remote applications out in the world, that the wifi maintainers
> have tooling for. But those are not considered "stable", because the only
> tools are the ones that the maintainer of the trace events, created.
> 
> If you don't see anything using these events for useful tooling outside
> your own use, then I'd just keep them. There's a thousand other events in
> the kernel that are not used by tools, I doubt these will be any different.
> 
> If you think that a tool that will end up in a distribution will start
> using them, then you need to take care.

Well, there's one thing that could become useful for tooling, and
that's determining the resource utilization of the hardware (number of
dsa_fdb_add_hw events minus dsa_fdb_del_hw, number of dsa_vlan_add_hw
minus dsa_vlan_del_hw, etc) relative to some hardcoded maximum capacity
which would be somehow determined by userspace for each driver. There
have been requests for this in the not so distant past.

Instead of living in fear that this might happen, I think what would be
the most productive thing to do would be to just create a proper API in
the next kernel development cycle to expose just that information, and
point other people to that other API, and keep the trace events just for
debugging.

Andrew, Florian, what do you think?
