Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033D76E034E
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 02:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjDMApq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 20:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjDMApp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 20:45:45 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2105.outbound.protection.outlook.com [40.107.237.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CB240C5;
        Wed, 12 Apr 2023 17:45:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQABQoJipTh94uCiaZyCF7wSplcsuebEAMoRHYKU6/RkNMgOhCiIbQ7Qe3HJsbM8vRp2cVDvPi7MUkVJHJiwDq56b4+JqSNfO94xcT1SDNZ8pmMXR0ccgQxF9VsvPcxxzdGt6l2D/ZFgrz9LsgKGNUY1g11V+GkGutnC3OSlnC179FgjGn2oh3U2k+zHuoMcJwvMo4D2MsJYuWyoxs7NmZwqC3uHkyxuVXdNDWQugKxSLH1y2GJWPb6OWOo/AMv+fcZRlN+aYbr+1NCv9Vh07+E9NwvAYPU1s0JA6lYFFFH8OJzYZ6GjyPXvX2fHDnfM9a+Y3ev72FlbuzKJ3low2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=idxIuwcF9ICzDYmuZcpTBoev/VWvp2yIL89oAE76UZI=;
 b=oOCdj5Xj7vD0+Chb7h0ysQiuPPP+QBvSq+8o7OcZLqMmkTf0GAU0ImVsJ6xz6dLdlZC8dhxHvjxq2jiYZxmTBD6Wqv3vidHyY8x6r+uVB0ODgm/pOuG2xT6oTMv6yCV4SSF3EfKeLyu1AYvyyKwERxKzKmDRA4YCbIYw4+8G3Jf3kzY1ngVHGazPD70NF5FYugIDDNLULC3E8qFwONxLUJvEUj/YEIDkLrMYkVI5r5aY2Q9iJFVMyxCoXHeyjYRf6AlBFRvGGLHWOs5+5OHoKiKzpRb0e7zTWGLPlVS9uBrd0x9p9i5L6rLo3RV/Rdmi7Y0EoT3ufUtsSdH/SfQp/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idxIuwcF9ICzDYmuZcpTBoev/VWvp2yIL89oAE76UZI=;
 b=gdj/IkyAfHhh7mvC2ThypqspjPggaHUKxyCEfq6j3JoWlasJMKXjQWPxuwWcTkBFg2SjzzgTIPZhoLvPjC+a+bE8uoCLJfcaWvnO4GaLsb8amcK4CNCmQuvTPkfTmmul92H8da4JFGjoiRSfsAdLNCpe/DCg29ktplE/vHmfDrU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB4217.namprd10.prod.outlook.com
 (2603:10b6:5:218::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Thu, 13 Apr
 2023 00:45:37 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2e97:b62d:a858:c5af]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2e97:b62d:a858:c5af%4]) with mapi id 15.20.6277.038; Thu, 13 Apr 2023
 00:45:36 +0000
Date:   Wed, 12 Apr 2023 17:45:34 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/8] Ocelot/Felix driver cleanup
Message-ID: <ZDdQrmtqa8eYiRbX@MSI.localdomain>
References: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: BY5PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DM6PR10MB4217:EE_
X-MS-Office365-Filtering-Correlation-Id: 288706b9-389b-4e58-893d-08db3bb864ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2CTgX1gBZ9Hjp8wXZRd4B+WkngktD3CSmDJY6+0hfScmWQniw/PeGFt2spcMwHLVz0Xzsi6byW9i/RtQf9UihlUpo2SnGypadf2YeojY+FMiz7J9+qLRJ82fJy3IvUFgC7yly/QegxTz/DN9UOnBlk4d5tncW3FewetG608Lt1W7JrZEp/dHlGAwSYHv0PA66MP6mQMAr/2iDRvw42r84J8FsRXyNLaW536peszk+k/tNTe/h1MY8HqQpoIKPPutmB61UR+GILTq03MIpySGQiymqV+TmPllrByF+96jE55ZKjGlYpOL5esvwfwrzQjd/cnBVtVpd0CDzvrcrh1kynThjXu/RmX7sW+cPyPrwjM82NRBsNL7vU2s36wgCjtBZdfLSF+RkmKJ3PFArj1kopTRziMs5ylyOnBZaqgqRXEq2KQ/d1aAmAQAZLIE+VOKqQQKmO43dCDPi6HSin5yuDdGIPbX+1CKWG6zLVAhyEP/JDTE4QewQaNf6g5MY8ai4EFY3dysPahwEn8pLVTOT7QtWZ1EmKkJ3HoB8i9+CPA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(39830400003)(366004)(376002)(451199021)(478600001)(6512007)(26005)(186003)(6506007)(9686003)(5660300002)(44832011)(54906003)(4744005)(316002)(966005)(2906002)(66946007)(4326008)(6916009)(6486002)(66476007)(7416002)(8676002)(8936002)(41300700001)(66556008)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VVwxrlFBs4YsiAdlVWc3/oM9f4Y9igCD+OiHqVrkdfy6A1T7J21nR2nfgvkY?=
 =?us-ascii?Q?OMgFxQuv7qZIhfHH+FTnb1Zu8oH4jEVuwKZYjDqo6sgEaNRwcAVNfzpuMywJ?=
 =?us-ascii?Q?vzlBXmgu68UH9GtarOh4YrlGNLZjPUI7bSLyHiBGaqPazJG+EwIPEriXyZlt?=
 =?us-ascii?Q?yJBQA1tIFbwb0P7hEcuVJfIxVzYuYdHSFEVaXtEgL0ZTNsBzFCyomVS4kTm4?=
 =?us-ascii?Q?JtQ4FwaMvtCT73pTBquUyN5GmEhQPrhSglJf48+duG9SVjJiNhdKG1hFUfBs?=
 =?us-ascii?Q?JgjU4pVmvbN9c9oFJcd/KfExyBmzGLu2lcBMQsNDvdubR5Kz0qPPTKM3SpdU?=
 =?us-ascii?Q?N0+cGdBItWdj0TCYeUkIW++E4PU0djTTb+OLGQk4fjXi+VuVGeONpHxcpvvG?=
 =?us-ascii?Q?QDaBYIzU4uPe1C1VzKHhrSof/PT+uzd1F1qqb49ps2zplok70T9AnayCxwsi?=
 =?us-ascii?Q?5H5B9qXv0lVwhKKQrb9AygI91MbBGhO/NbC5IJ3XeAOOtZK7Eue0RQpd5flT?=
 =?us-ascii?Q?2XkTS+hbSiZpBbtKZyeiF85hPCVctHtCew7R95NKVV7jMAtykuMU67N4N3+S?=
 =?us-ascii?Q?PCFofUWwO93RF+w/3Wi2jDhL0NzM1rTYgnraTQgr4B0hOGc2m1snJF7+53gt?=
 =?us-ascii?Q?OKezcK3onE81ry/Z/3LNy26jlo9AqpKHyh/dDBAVSFYO2yb0SRRPLUgbAQEX?=
 =?us-ascii?Q?Y0pnTBlqLQT+lvvZjwJH2Izq4u8X7Pft6dSotNyixaiP2Vo0V3n1yXShF+Go?=
 =?us-ascii?Q?cslczXZcsoqm1C6tTWp9AKlHKnppRlNSQOIsU2pRjaGDvMI2JVKMAK0A7xtH?=
 =?us-ascii?Q?9X7q2mvvSwqYAWA3B7LmXsN60p1Sz0+qPYE8eTTDGjXW4QvUdyazX1OAiNPK?=
 =?us-ascii?Q?8uTBGVJS/dyBt8KmRpnxgCMz/vZw5Wfc74iW+CQOLxBUhbBti+RmdVjcf7ko?=
 =?us-ascii?Q?wAhbPB2Wmj9FsDeVP4lDqzinyWUtF7phsBlSI+Y9ZAyFKHfQMbFViIjUN7mU?=
 =?us-ascii?Q?7JKt+jKnNfYyAV9Rk1GZkkAPjn75k++W7AnrJDgMksq5dQXqLUO/nZeQy56l?=
 =?us-ascii?Q?K7T7G9Kres7z6+7o8+fnKn9hyC5nqHuAnM6AIH1UQ1EPA9MLH8Dx2FkIxn95?=
 =?us-ascii?Q?ajZ1ZnHH6Jr8ycF3om/ptZIqBoWeogu7SHYS5xtC/aJeaGpWE5PbF7odY+7W?=
 =?us-ascii?Q?kFrfNMHxVXBxSfsUByNsnESB9WHAD3GzG5DhhCMwODi2xWJPHOpr1u39FBOd?=
 =?us-ascii?Q?sNNa3q2CDWXzYwvrBC7dKy30Qw5o2dreEQlbeZnWH6/RixNl23Dy10Cp0dT8?=
 =?us-ascii?Q?BXdbPQU5CL9/tgbncU9oSiAAfpy9EyX2GC+LCOgCa6xrFwrPt5/l9l1UUDHH?=
 =?us-ascii?Q?S0NX/JQXQPJIyzotwCg/R2QyAhGAzJoSaYKKWPMr3l26WIEWp6vcOnkstrd7?=
 =?us-ascii?Q?CJxHeqJqobBs2sEjBlf9O7qWn0d4/Unsom5v0aTKxAcaBPHZe3RI3KvHEp4z?=
 =?us-ascii?Q?6+ApG7Zt1v3y+B11lde4xz/9lqgqAwALBzLdguUDUxMRcU/UJ6biEPTxmiqP?=
 =?us-ascii?Q?FH00+vgFrbOCOpg+SN4JmgGYlRIyNptkOIO0FX3oehoHRs9Ta4YIAKHSVH0R?=
 =?us-ascii?Q?aQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 288706b9-389b-4e58-893d-08db3bb864ed
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 00:45:36.1151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JVU7HZNhs7+s/NgMJwzoLxAk5Kb9GUMuZCjPYoqkEKxpleRqWAyqNk7GMWgEfPe3kPD5xUz59F5ZNW4wMfTMoqgy8ZWio66ZJdd8gvXv7WA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4217
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Wed, Apr 12, 2023 at 03:47:29PM +0300, Vladimir Oltean wrote:
> The cleanup mostly handles the statistics code path - some issues
> regarding understandability became apparent after the series
> "Fix trainwreck with Ocelot switch statistics counters":
> https://lore.kernel.org/netdev/20230321010325.897817-1-vladimir.oltean@nxp.com/
> 
> There is also one patch which cleans up a misleading comment
> in the DSA felix_setup().

Sorry I won't have access to hardware until next week, so I can't add
any tested-bys. But this whole set is straightforward, it probably
isn't too necessary. Let me know if there's anything you want from me on
this set.


Colin
