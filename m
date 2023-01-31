Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C946836E1
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 20:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjAaTzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 14:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjAaTzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 14:55:38 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2113.outbound.protection.outlook.com [40.107.93.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0655E45884;
        Tue, 31 Jan 2023 11:55:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ub24v3w4+r6naqE7kGZWALr59jQTg/fniEta+sX6Ni/4hW4Qu4FfyOIu1ltnXaq1T1uB6wdO7yQVKtV83hoRK21ENh4ijU5xlS01hp6LhTd2Toi1yQ/Hh3fIEumNZMeoCBVAf0jG0w27VEKj4elmvZAr6VsNFyOpXKbfefDC50Knq864I3KVv3Io9a5Dfv4K5Wr2P1fZcpGOcdCgy9YU8WdaVcZrB5jh0UeTX0qLWjTVoSkXUbU0L7Utpi03Lr7fKTzjgmt/Jfh41OprsKtltgJ6MUnWBqgMLO0WlKTlub/7wa28WKfvra79oKkTTPzII15Ee6fUa3H1JTX16dQPVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4h3yjyUDrIHpyWhl/yh+v3RNlIAH9MVetI2cjh7zNs=;
 b=UCfDDv6kPEuQMTQeCDjk3oSfmBmfuAVXJyJ2pr49p5XFw/upUDJdpjOM6LeiDhp3HUrjamas6kUDPGPPeo6oSeCavd/6BKnNKgSUDAQghA+CLsJMPu45ZfaP975BlyYZ7z1RzFK1B0rzSfjKzfGX/e7V5Dn74lsfjBVZUng2RJcMzxhkLcvsn0/mewbzqoKwlFBaf9KvxcNMx8jXoXlr2HeELUapsG8Aipz5D4ayyatqcAyHrFAVxGgzSi5hXmIwF3SrlBrXM6LwXnm9njP9DI8XR4NMOsLyYs8wMuSvn3tnex7h8yeP/0oiU3cBTQB0UfbTC3lN1oPtgH+bipr2lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4h3yjyUDrIHpyWhl/yh+v3RNlIAH9MVetI2cjh7zNs=;
 b=o3NTEt5QlbiN0/tNK7p3UaKimlxJzoxqtIanT2I/wKzfidWnYTtYG3Fu1huRaywegy0SqNQHVxF1xzJTuO3lQBCKQl4KrDyaNkjbC1TXGsd9mo277i54X17IxyHjYP6nSQacpLY4q1eCdYZYtL1Yvp+24gXucyaBZ9FfqG+cd70=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB4283.namprd10.prod.outlook.com
 (2603:10b6:5:219::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Tue, 31 Jan
 2023 19:55:34 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6064.019; Tue, 31 Jan 2023
 19:55:33 +0000
Date:   Tue, 31 Jan 2023 11:55:28 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lee Jones <lee@kernel.org>, patchwork-bot+netdevbpf@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        richardcochran@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com, pabeni@redhat.com,
        edumazet@google.com, davem@davemloft.net,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Subject: Re: [PATCH v5 net-next 00/13] add support for the the vsc7512
 internal copper phys
Message-ID: <Y9lyMEDfvQQybtor@COLIN-DESKTOP1.localdomain>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
 <167514242005.16180.6859220313239539967.git-patchwork-notify@kernel.org>
 <Y9jaDvtvzPxIrgFi@google.com>
 <20230131114538.43e68eb3@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131114538.43e68eb3@kernel.org>
X-ClientProxiedBy: SJ0PR13CA0020.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DM6PR10MB4283:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b90ae0c-ed77-4204-259a-08db03c51d42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7lCAyJxoN3oYGSnxkwJjJI06Gyb4WG+xcBtvebfbRfS+tonFMMJ5DwuLX4wKjguP7Q5/1KIeTzbR9o1N9SoqbV+hIvA0i1EtAfYu5huUaVM48eaMecOjjQgtiBNw0CeF0ExmlL8XTP1mVmtmKZhDP9xVK8UTEEeRrUXu9RMBtXig80YgH6iT6o1Kf565Im8jHwbs4qcfkWd0JMFjB5DXVYjmZeZmQU0qFCnAjASuSsL6CzFmcrdvqyGyTplus5tbArMEtMuUxoI0E9c82FaS5KxGkqOW4wBL7rHrNztyCJYMhxkPf9ktaBAblrMPr4HQdwgi03DpASdhjJJ12/q/9knnGnRsa8G5r9sMWaCq20hZ3fCG1Wyb8fi8sUETMC2nVcUCdkxehmANJEDJxiHXKKBGyz67y4BVQ0uUb/X6NemtAGg+yI9HPipa4byCO1U9KmROLP0S7muL+vMh3iNUkv6VJbhWtvXp6bq6nNBV5O8pLAF31JauubrrNdTq6acxjWpiMHSw14sxoF7cy+1kROyV78SSRKAb0xTXUIiG09c1a/W6b92+MdgFIMt+hUQGSVQO8wEx2V/o2KWmeS8J03FoRVXvsIeCvj3RhwntGTw7qJjpyH/aFcBh+/a2f5+lJ3tPG06dSuUwbZ9IIqOOdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(396003)(376002)(39830400003)(366004)(451199018)(4744005)(44832011)(7416002)(5660300002)(2906002)(8936002)(83380400001)(86362001)(4326008)(41300700001)(8676002)(6506007)(6666004)(6916009)(66476007)(66556008)(66946007)(26005)(186003)(6512007)(9686003)(6486002)(478600001)(38100700002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1PY74pgwMHZjPMx5JfLgOOb/KvcLc95ESomjshPLSsVpfIS2Dj9Liv/yKYc9?=
 =?us-ascii?Q?SIwe0BISyNSwBUvgcpz8LIWLnBBAH3K/6RnJyukYpvmfiAIFhQPByyYN5IxZ?=
 =?us-ascii?Q?CcM9NOX1tglRQSsw13gYGQM44hzB0U4esqwSGxD8VbUiujvOLiLrxb3UTUnf?=
 =?us-ascii?Q?qlO+w+RQSmXnSBO1WYbT4RRUiW0vzA4g5+eJVJAq6xjyzeRuZYcDpRg0ic67?=
 =?us-ascii?Q?kg8/KkI9QB9i4nXkAjB4L2h86NIEDwQ1C/4JnLjJ+ctKeoaJPGfjLrpwCir5?=
 =?us-ascii?Q?cnp2TXf1JegIS1/zqMw0SP7PiJiGrDlsfHWqy3YSPAYO6EZtondTSHnkB1fz?=
 =?us-ascii?Q?MExatm54zgJok+pwiFTea9MUCDtgWCeUgFpHof2ql9RdxeEJC9DTKJe5CEkZ?=
 =?us-ascii?Q?paKQZwN9LE2WyjvtvYuOiOzUXb+HB2dzlorQm2BUGnqVa44Cdz1R3+g3t5eO?=
 =?us-ascii?Q?kxcv/7SW+aU2dO9VYzKMGKUpotBNZIIX2vouZqmbJVdqdhPwMKdhMXXzeMna?=
 =?us-ascii?Q?rN09Ka9SjQpR2jAnIEsJZJaMhIHbWnL9vwrNIjb5kokFwvW7YkqckIbPfF/r?=
 =?us-ascii?Q?kN0NMa+2NbixU+czJIxSyoDKt+AralLUUmmjDEeWg4SB85HOI5ItC+u6akxf?=
 =?us-ascii?Q?7aJ07c/Rppaqszvq+cjVKacOl74bRjQuVXQQOgHbWOGR0pXJMGYD60LFXvDy?=
 =?us-ascii?Q?8+neBP1mUiku+5w0utpvx2gLf3XLDu2l8rAs74KQrsciGU9cmvO9PMMnVTrC?=
 =?us-ascii?Q?UAzhX1x3Ss4A+F0RMEs1J/Ey67sx6ZNgukklrjmEgPBgtiF1ySC0le51Fy02?=
 =?us-ascii?Q?Mc0TSuAZEn//kwSr4PLCcROeg+JM0cfiCfaAFVMhFjUFLyvGA2De7XqBLwRy?=
 =?us-ascii?Q?WMD5LK7HBxUke/J46gRXyo3ZhbehpsR8poA/kq5NkJTvzL+Bda9vM3pj8bn4?=
 =?us-ascii?Q?b0P2YELkuWG+Ti8j6YSgZhy1l+MhxDhRoRtD6Bh41KgL1+enpvhYLgmSff5X?=
 =?us-ascii?Q?ntspP6vUot6CCh2HcuxoPk5NdDIk8ZuSMgWDsWmg6zDedVu57MH7KK3yEENG?=
 =?us-ascii?Q?dJyZWjeXSGUpDBb8bQlT+ssxCf7bhHxCSEgYM8QC7jjLZbHGPs5mvUqauV/5?=
 =?us-ascii?Q?Haqb46lKzqV8jUkuWxtymvUbG1EvFreayA6Luni2dVhKgWQpCSsTe2zMdF+3?=
 =?us-ascii?Q?dqfL5rIQAmME19KIVqRToCJ5Db0CyzHGU2n0RqjSASIaKL/cQuKaSwqEB4QN?=
 =?us-ascii?Q?q2c7yBi0hx/W1amuc1HUFWunOkZI1j2chI1QIbgZiBXCDiU0dHhzdOXHKOrB?=
 =?us-ascii?Q?fpcBnDpb3Q379ZfLkwa7xTg+emQDXsq/YsWQ5b385CitSUnXalPKtyWeAS1K?=
 =?us-ascii?Q?qrX8KSb6HxDHifviKUH2SPEhV41MuBaw9BouW+1OMTzOboXrZhh/F1fuu5KJ?=
 =?us-ascii?Q?UBwdYcKNCle069tMMf+TbadbTaUGUTPuSM+/oRT1rYgktdtjOj5dOLt+ZAHk?=
 =?us-ascii?Q?dLU4GGuFfj9s7ydlWx78jTgi+n3lhItc2a92H96BxnrrGJEoj/S5ENf63QPE?=
 =?us-ascii?Q?B5Ouw5GfoxnbvWseM3KJj36yCBRSGShWPjjdaa/eqfltuAphpjPpjPWUjUz0?=
 =?us-ascii?Q?2WGpf8onGjFJeimlQoq+b+w=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b90ae0c-ed77-4204-259a-08db03c51d42
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 19:55:33.8778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XuWzQhvq96UNzXxXUnxM10k+FWvaa2XW2E50uvCeWXvilkykrzPDNmtMZ+kAl7AhllqeZW0WbjBG6hN2oF5I0GW7hihtKvnoU5nQxLyfLbA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4283
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 11:45:38AM -0800, Jakub Kicinski wrote:
> On Tue, 31 Jan 2023 09:06:22 +0000 Lee Jones wrote:
> > Please don't do that.  The commits do not have proper Acked-by tags.
> > 
> > The plan is to merge these via MFD and send out a pull-request to an
> > immutable branch.  However, if you're prepared to convert all of the:
> > 
> >   Acked-for-MFD-by: Lee Jones <lee@kernel.org>
> > 
> > to
> > 
> >   Acked-by: Lee Jones <lee@kernel.org>
> 
> Sorry, I must have been blind yesterday because I definitely double
> checked this doesn't touch mfd code. And it does :/
> 
> The patches should not be sent for net-next if they are not supposed 
> to be applied directly. Or at the very least says something about
> merging in the cover letter!

My apologies. I wasn't sure how these cross-tree syncs would be done
(and I recognize Lee even asked during a previous submission.) I'll be
more verbose in cover letters moving forward, should I ever be
submitting against multiple trees like this.

