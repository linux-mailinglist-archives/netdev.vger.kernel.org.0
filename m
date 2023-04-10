Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75AF66DC9B4
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 19:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjDJRHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 13:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjDJRHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 13:07:15 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2043.outbound.protection.outlook.com [40.107.15.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9771FEC
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 10:07:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oa5lMUmn8au5jPvjZDnsode/Yx2tAAYE38MvJYhCXcggn1lW23GTSjtTAn+FdqpCfWlLlcNN89aMc3V6nzuJsAmFVnq1++05VPQnhUX+1xl/XD9BnoW+Gra3NZuhO0x/GmsZF/3IROARw63PuwDJCxYbM4Gm5q136MS2JF4k6PJV7ugDP76H+vOrssZuE98h8PrST86CmhkFShJyaip3yQAwGyizF9XkQ2aqqvPDmUQVMLyXmHyLRmOrJq9mRJ7CSdYM7gtIaLhLX11Q3umOeiL1aedv/NXCZim7aHr6bnYy0aPT7NUvWtHVA53zAkV4xLO7IU8SkGkEKPi3dLCIIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ow5xJ11Oex/Op8TJhBvT2q7sEo8OxocBzAyZ5aFTE0I=;
 b=D4R6bgjto+57JmCRZDFAxVr/fErWcR8EL/RFrUSR40WhDdetGsxLfZHOjavETPpKOeLaCkBfoocXSxRdxtqFeO831j+ectkGWzD2TESbYrMB8S31cZEiyYCIa+yDHqUHXHZiuMl15SEtPyJ48eb1D4XOoiyQ/Ir9r69XZdaVLHTfQ/vH58W6Ld4vhcX+L/XvkI4KFItMbAkFk+YUD3klrdKh92WC8+dtZMY0+QVC3535v1WoVVJpw0/ihhj0Yx+leXmP+07+0LtlX9AU990Oz3xn5d2P5ShYbDDGsq/HVLpBh6/vvWLg8IR1hW+dIrjSFqGANCJhZdlmuDu164Tenw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ow5xJ11Oex/Op8TJhBvT2q7sEo8OxocBzAyZ5aFTE0I=;
 b=SFdq7PspA8jDb6sK7tZMb3CBulid2Jvx7ss5SCXHdE/Jmaa6xgmASJLUJBaoVJF0Mv81c6kiaKA3QdroaiZe2Mopa/qHpKWX04gjb1nRLihc4Pu10PrOSe4cQuKaHNjze+X1dspwEJkdd/Htwl1SDaXGJb6mndWkaA6cooYWmqc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7525.eurprd04.prod.outlook.com (2603:10a6:20b:29b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Mon, 10 Apr
 2023 17:07:11 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Mon, 10 Apr 2023
 17:07:11 +0000
Date:   Mon, 10 Apr 2023 20:07:08 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [RFC PATCH net] net: ipv4/ipv6 addrconf: call
 igmp{,6}_group_dropped() while dev is still up
Message-ID: <20230410170708.5owdbmwj727sl3zl@skbuf>
References: <20230406233058.780721-1-vladimir.oltean@nxp.com>
 <febbbc75-2cf5-1cf9-8ed9-6a42ff295ab9@kernel.org>
 <ZDPA1pv7tqOvKHqe@shredder>
 <20230410100958.4o3ub7yy7gxnzzpy@skbuf>
 <ZDP2bxXGbHX8C4BC@shredder>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDP2bxXGbHX8C4BC@shredder>
X-ClientProxiedBy: VI1PR04CA0116.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::14) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7525:EE_
X-MS-Office365-Filtering-Correlation-Id: e7ffb555-43c4-43ea-3194-08db39e60651
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lRtPyS38QCwF961YZDvehQJ06TwTjm3tFL1jx837dud9x2fg9IeV4zNeMbg18RhImqi1itTF/L0uhqGD5bA6wF8KboLcOh9zlGa1b6Ai+t4p9pGN5cP1eK3QqI1LmaqMdFQHSUj7QPVVXiK90ux5VQQK5dAairZqmCPjj1mGMotv3MyQFANTFYVaDvE2KTxzmUoHz5KOW6Fjt5MwQnPN+n4pI2lUQYlRV7sCRuwkQieDCKnr1Cl5Kre3Q3Ue+2wwp2x4Cg8Loo1AWReGLfr1QjtA03t3xhFHKaYIb2hkwt6uH+MiHsj5YKAyu1/g8T1Q9cEQhTC/bg0zHJ7PRSCdzflMqYLYASEX0KN5tDh/39/ZmI6cQ1G2dbk3VRS0bCFU1K1Z+om87piELzyQjOhiGTiOYOpgAtGijwidY99CuwpTNQlNdBwJo2cUFmdudiEOe0+QvKAT9BO1kjBnhc8/a/+s/TZVNCKAZzGuwLoNZGK4N+3gWFVNBulRNeDIyHOr33QuoKHlZK1Dmfjk0EbOqOiO4/2yYelkmvRYPTACvVmgzdCo9MBxIlVK0I6oHpCJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(376002)(396003)(346002)(39860400002)(136003)(451199021)(4326008)(186003)(8676002)(66946007)(66556008)(66476007)(6916009)(316002)(54906003)(4744005)(44832011)(8936002)(38100700002)(41300700001)(5660300002)(6486002)(83380400001)(6512007)(1076003)(26005)(6666004)(9686003)(478600001)(6506007)(86362001)(33716001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G1FaQxJtmrF00ArNHCQDx6ORNlVOnFaVD4g+WCALG8ykRMO9wWtV/yYwvS20?=
 =?us-ascii?Q?AI0Q1PHL/zSsTQy9HREuOiQIE6JSUbbpxCAq2lY5LXePhRPLvB/8and2quZt?=
 =?us-ascii?Q?3UXM5eSHIlHsbpTAmbLJPcmNsynal4WajEmdsNANaeP6Fp8lPFMxuO2R3Fy2?=
 =?us-ascii?Q?lPamdRh3DpmYuEYmL3IIgJqB9JlMTAompr2oqhed6ZryZ8gR103H6gm69cCE?=
 =?us-ascii?Q?GrEHpXcwGucfb9fMWTsY13U0xndk9/KGn6iqJ+RK5DtW3l0Qg5QhvylP0MRp?=
 =?us-ascii?Q?dMUTs8S9FEPGshJPRZWdzXfxpGE5ZWuEr5nNDLWNQXz6pKKQpfQ2CucW8tBP?=
 =?us-ascii?Q?wd9uyKMvJ3cHnnD5ynCwRyWL5gEpERvefCvj4DyqZPhgdBCplsRIPhehxWeJ?=
 =?us-ascii?Q?h2j4kwaf2KHl0yD8SLm9GKEp3rSrJwgAgpFd+6CbpOXUvyFjQZrMVpba9Hss?=
 =?us-ascii?Q?MUz7mcH6flWbbF87KZ51PzIewxrW5tZZRbP+pheqCM+iz8JWbqgnPYhNb7us?=
 =?us-ascii?Q?GiufXYnNtxq42RpBDmv7ZsLBJttLpaOrusrrvtT76EZtlXxXakC3VNJtMaqD?=
 =?us-ascii?Q?FIxcp+Y73abke/6te8M8W6ngEellbxFvXrzSTlMAy5f6030fBDzXRQutlvdC?=
 =?us-ascii?Q?30wx6NNi0A4nTkxqqd+7FtcmwGDaV3KCRwZDwksxxN6q3Sq5+TMSpDEtFkA4?=
 =?us-ascii?Q?kgf6VuTYaN7hnC70OSnQpJTsu7bjt62gvxqjAh3Stj4J9v0zN3ngd8f9Eybp?=
 =?us-ascii?Q?E3iV+WYRt0nn+rMYJqLNJ0BzKuBdUgl5IWhCuQCD4gJZqv+zo5ZKZUQGZryv?=
 =?us-ascii?Q?9jfBVIm5Bj7tD15T4bfCJyeFEoisjTeocaDgeQ5DzkbXw9cvQiL49Xw75uee?=
 =?us-ascii?Q?lAxR13UHHSa95yVFDhH4ZVih/W79fDfUAfXGSboGIEPpi+IJo2WcmuIG9AJ2?=
 =?us-ascii?Q?IIPtgOhFWZDOo8XVQ3ZwJon2VaQZszLNftBjP37cMlHlknxhwphm4Lv/jbhs?=
 =?us-ascii?Q?T31yhiFJMwX3du/OiGURt0meecC0xNskRrAEVuEFb1K4gAS4/mnipvJty6F/?=
 =?us-ascii?Q?NMcFSj6oQ75ALsDIpGVVt72kLM97iGcOAB5u6zCJ6+yzZe49aVDnVpbHsGiQ?=
 =?us-ascii?Q?woq/4vGLfjAUmOZVrU+XAla2XtBz3MRCpaEUXzRL4UgKpbKDukyRt03MYcvC?=
 =?us-ascii?Q?CAR2BzWUzb1yc62avoy80jab6C4n/3shlJz+a65rSMjV0Hd+Sksv7BO+rprm?=
 =?us-ascii?Q?VWEx0dpW+pzfgeCfq+ye2V28Ky7vSEIZYqHLT3aByu/HLCvSIrSu+a+kIFvP?=
 =?us-ascii?Q?9pu+/HZ18gkeYPu8OK4+Z/FgTVqOvpkiVSAfPBkrnGQvXyyQaSYibXNObhY5?=
 =?us-ascii?Q?0kDu5W/yfnaSJUt+qL9u7DFhbOMYc0S0xzIEERdmF4kGx4sVNvPRQY+HtDJ+?=
 =?us-ascii?Q?sHCekXtG/VeRbqrj5F7PDD3Ab3FOLnDI8UzgKtWYx4GlFUBVTRNLU/DdeQhk?=
 =?us-ascii?Q?jw1ho0UOs0H+4mxYlMdL5F+JZdOYnqXW+2sd3qsiZ8C5i+yz0wzBGsjit+Zc?=
 =?us-ascii?Q?No2qZETIJBeAkcD2BUzHuTlj+oIHfkmEcZIXl0qvboyTwN9GgtCqT5XUGrhY?=
 =?us-ascii?Q?jw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7ffb555-43c4-43ea-3194-08db39e60651
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 17:07:11.6235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VeCNG7T3aHFWGAaWbSrsL09cF/BnzR3dTNAvlufV9KIDrThC3e5XoBCwDY+1gjWDMIQYnDkE2dfsGR48wZCZTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7525
X-Spam-Status: No, score=1.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 02:43:43PM +0300, Ido Schimmel wrote:
> On Mon, Apr 10, 2023 at 01:09:58PM +0300, Vladimir Oltean wrote:
> > So, how do you think I should proceed with this? One patch or two
> > (for IPv4 and IPv6)? Is the Fixes: tag ok?
> 
> Fixes tag looks OK and one patch is fine by me. However, given the
> problem is the check you mentioned in __dev_set_rx_mode(), wouldn't it
> be better to simply remove it? From the comment above this check it
> seems to assume that there is no need to update the Rx filters of the
> device when it's down because they will be synced when it's put back up,
> but it fails to consider the case where one wants to clear the filters
> of the device as part of device dismantle.

Yes, I can do this.
