Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9DE567D62
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 06:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiGFEem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 00:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiGFEel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 00:34:41 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2136.outbound.protection.outlook.com [40.107.93.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B151C112;
        Tue,  5 Jul 2022 21:34:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eX9w2ik9c9iNgTH6QkZUbW6IP76UxkeoMJuyxC8z3UTm3+jljLUk69KHSU5urDkGkY1isyJ7yRQq5b9BgFAm4VyaAqOMHXLQ0dN23M7AHYhMqNtq18dhcgY4CbNpf/WPX65jDJl/cV40gZGwLgebWjibx48dETXfDdQMl2iApF1ZesFeIDOYECPbQ9yR0sVtL834dYsM5fDYzZqQyKadkWfD3CHWmCLc7LXsQn0nzULaWp493QDarv73+nd/gr3wncH3BLnHuax1XXr4yUU1N+rvrekmcJa9+JY1E8M63gbmZOxUf0B+yGYLV2ZGn6Pj4JfT3zueaxoNiofxKSogcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uBsTuvUXx8JQySRs4ebHoLE4aTY/Juc9qHEWtoRGQm0=;
 b=ax4LvBe0nwjpWcMWvolrY8MMZpbjJFcL3DtiFCHnaBihm9CLpB0wOFpcOfsdupwyNmsagclOcyFcSwHwj00y379fpFaFYn2Ff7txeQ1J6jDHu55fxTeYYVFNPiYiKmIowcQXoMtcvWqOssYni3EaberuM5zmUm+rRz+ubeAmTvlHe0DiBGH8Q6h5Sw4xvR3K6MAujX5Ad0uGXf4Hf00eL6FnNB7yQw0GVWOUsgfvdq7W6o7763mUJC/iCsz6Vs8bhYj1UNUnh9LGPKPQg7Gp1jKjjwyP76UJKgLvX4xuHZA+LKjzaLr7FSVMm6R/LBnTgIMhe0/ADjPQBYlH38viUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBsTuvUXx8JQySRs4ebHoLE4aTY/Juc9qHEWtoRGQm0=;
 b=k6q65hM+WfIVzn66GMaOeUMeLxCgqm1KHUEuTifHdgRCJb8Lf3d9Uy/0OWMhlRoYT4a1vXQQHKaBk1LelIyyoQQDOV2QpM5ZqDvWLbPo5N8oTklSCGB+upNzPFAKwLQlLcONwClZPkxMYk9FSsbMWMJaAMnYajgxCLbmKKhSUl4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4428.namprd10.prod.outlook.com
 (2603:10b6:806:fa::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Wed, 6 Jul
 2022 04:34:36 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5395.020; Wed, 6 Jul 2022
 04:34:36 +0000
Date:   Tue, 5 Jul 2022 21:34:33 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Rob Herring <robh@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [PATCH v12 net-next 0/9] add support for VSC7512 control over SPI
Message-ID: <20220706043433.GB2830056@euler>
References: <20220701192609.3970317-1-colin.foster@in-advantage.com>
 <20220705202422.GA2546662-robh@kernel.org>
 <20220705203015.GA2830056@euler>
 <20220705220432.4mgtqeuu3civvn5l@skbuf>
 <20220705225625.k42jjsdusf7ivaot@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705225625.k42jjsdusf7ivaot@skbuf>
X-ClientProxiedBy: MW4PR03CA0305.namprd03.prod.outlook.com
 (2603:10b6:303:dd::10) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b59fca17-65dc-47a7-c47c-08da5f08d4ed
X-MS-TrafficTypeDiagnostic: SA2PR10MB4428:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T27NcY8WOKVJ9RLK8WJ0Mo2v32xL/hR7FKoe5u2ymrFGnlRJgeC23E7rD3nHGttn8FrjHyBRCZwdjxOChYZV9DMuPwWRMaqa3BE4FJRN0wTeS+rI7R/AzAdF1+keV6sBS1x6uTE2TX89iqM18D29sbSCI3qlaWhEec2rGdr8g9AqDgWN6a3ctA6b9OfgQVBe99Rhjf9XPYmcAChCprw7NlwLtCvX1yTKEYjY9RMlG2+sJJeYZj3WJzyXR0BkbNFIim/a5gkC+FtMHeTHoVwlG43d0svsOQPv0HIF6phfmNpNBg29g+EaxKR1uJE2HMwo5W0HRaQJiJ5SPg5ug5PwulKYTET2Co+MoTKD7pb0BoDsthiNURZlgm7l0LPeLQmVG1BanpL8hdBAMZGMHra8kmjt0DuWjt1vNJVVQX9jUazLk15DV1tPaxgxfAbFv7JFBWqbkhfDjTj90KiwIYj5nyfsftEZRX7irQZgildbhQz4pZ1sPIuhkRacpBGWCrGvFPxhuAvh2oTxTYRfVbAcXbx8lKo/EawUofLF00TZrc0DzVxryQ9XglgMbh9006BdJ8nLwGumIyUKrnxJWjT/jrOS6qCu26CQwhMIm2t9XrWGRjs0u1vEHAD5ovWqoRwoMOHCJl2ty9XrQ8miiMdoa7L3ZCTJx7Gb++wTg09vUmojO9orcjawS731aINm539nWFOyB6Mb7YyMJsRL1IFT23jpHgMnaBXgscGbhyltGUXW7nuZR21Cn+YnyP413KgbkxOfmD23ToEDaT+dTmL6u03Eeu9h4DUVSSmfc3GWv70Wk6n7otGvG0Sv5O4u1vvp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(39840400004)(346002)(366004)(376002)(136003)(107886003)(186003)(1076003)(38350700002)(38100700002)(316002)(54906003)(6916009)(8676002)(4326008)(66476007)(66556008)(66946007)(6486002)(33656002)(5660300002)(8936002)(86362001)(6506007)(9686003)(7416002)(44832011)(52116002)(478600001)(33716001)(26005)(6512007)(41300700001)(2906002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yl0cNATp71EZ98jm6pjAYhgvNiM8cXv3flBDZM6NiiaYovA5GlIf6M/Rui+E?=
 =?us-ascii?Q?czzlJGYyPsg0iNdeiQR5F/mEzaBVDqQT/7INavMmeiVgmCipjSftMhrVdMKO?=
 =?us-ascii?Q?X3uQN4vn9iXz8UNvEldJhS8Tt079RrpweLrEM+H1YhirVikhMifl8ponGubL?=
 =?us-ascii?Q?aqrfAk0e6AEOGvirhk8ImbJRxE9oCi6Hp9catYr+QrjH/PnMUm1PDWUJ1DQn?=
 =?us-ascii?Q?5HzPsu0FrVLg9uzhB4ee96arhkJBq6UPWVCrDH9kEmJ6ILolrb6fj5hnQluK?=
 =?us-ascii?Q?GAhYnrnmPoLhIVn6BPnY2WtHrTIEhSOqinSHlZK+Xr2kcraTCyCAJL/XMQlg?=
 =?us-ascii?Q?2MExCkmSwTaq68nKC+39oDgUYaKOAWEmfFi84p8cc7Lpy6dbAkEd8XW8n+tC?=
 =?us-ascii?Q?ZyjpJala/ZUPRXgAVHM9/8yuQ2CVPVsjzG0y4vsMowmBTddBBufEyDl51SfJ?=
 =?us-ascii?Q?a15E8gHxJmgqrlbvWwXMh02hHa3VJK3hFoDi0DRgpSvqfVmCWfyKMlPyvdPV?=
 =?us-ascii?Q?RXM0zDhmQXM/M9LN3s0RkTrst4quBdQMmVIBMdCX6TJUOlWhjTx1KE6MwRw/?=
 =?us-ascii?Q?Pz0QKEpxUtLfSh1oiVkHXa+TFPfHOXwqFrRQ2Ysf+WL0GSr2Cq07ldNdGOSW?=
 =?us-ascii?Q?maUqn2zca1ybJunHGef/Qd5krFNRTDSk86klPHDR3qEYDRO47rsM83RP6WV1?=
 =?us-ascii?Q?CpcWRJf1AdcQATEk5DSaaKi8SPsGJ9MIN2/nGfD4jzHqEyNim6YOf2hb5Pt1?=
 =?us-ascii?Q?S5zILBp5p0D/mXug8G/aOOE7Vp7l38wdbRWMx1vxJv1E8nCNILwvr20e0Lfn?=
 =?us-ascii?Q?4Yz9tvjDO9buE9jqNdsYkTaMOwgJauNO+1JNMYtbFWtgbr0Bgm22OU/R/og4?=
 =?us-ascii?Q?NYIsQrMGc8uVZ67Z5pygYKb6vUtcXT/ImGRw4AUXAphqnvHHKNG3oBE4gPQP?=
 =?us-ascii?Q?XpNs0hzXyRwWjBM48kbAYmq+u8VRorOJkqxdF9UdizlaitZJXbIwPT1+f95h?=
 =?us-ascii?Q?0ZPZ0JbHhaUAMhGVXpjyJVQr1efZfBpjVt2WzdMcScoSIaidmHCQOmUhJU34?=
 =?us-ascii?Q?8KnFGvBot/Mt1DDL5AZIRg4hiK/eaoT1XYIDIaeoYn0qqvwZ23aesEHFLjyI?=
 =?us-ascii?Q?QDkSef8Fw5viCALIJzTiqh1NgvNQ6Mr+BTC8pKGQ+sKf/Y5UACL+ThJu9Osa?=
 =?us-ascii?Q?rQwTy5zWAJpon2/6GUxOZEDCluZ/ofV11inEqdECcsyI/+evh5C5qlhGuUkX?=
 =?us-ascii?Q?T61iT0N4KUV/DpyD8TTmI+6EYmNZXn5WZc4op8YGYQMtVbcy2N2MOrYON8CW?=
 =?us-ascii?Q?ra1i/chMXViHjbaPUTdXnqOFsJ23IHJNZw6GzA/H/69RsNznkXJYKDz4UhJd?=
 =?us-ascii?Q?9+dKgEsNjau/7xtQDJ8sVHXafCfmHpJrLIIPjbDUag4iiYQF6Sy5Y2g6YJ5F?=
 =?us-ascii?Q?pV2t+MV303RfHpsz21xvt/HzCfPGdRsw8RiGcveXcoGvP/jpScuD/SRG91mw?=
 =?us-ascii?Q?fkg1vqIhHnxThVaZ2oUWTFoqnimSinDLztksiq9R2HXNDXJxg6G5+8nNaRzR?=
 =?us-ascii?Q?5AAE8jpLp5gUZE+PNPBuLnRzK/gaVdWO0LLhtShO+f0NkERk+xRMmzUG8FB3?=
 =?us-ascii?Q?5mQ33vCV8hSd99OU5m5hbAc=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b59fca17-65dc-47a7-c47c-08da5f08d4ed
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 04:34:36.7137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pZLvUiJpDauCpZloQj7p3YZbOpSWENjyOLyB29CpiXMLC5xocOLhQOehSh1AslRSaK0+tIXa8kOxDBVCZxkOkdiLILDfhxQUCIxp3O6W0es=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4428
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 10:56:26PM +0000, Vladimir Oltean wrote:
> On Wed, Jul 06, 2022 at 01:04:32AM +0300, Vladimir Oltean wrote:
> > You got some feedback at v11 (I believe) from Jakub about reposting too
> > soon. The phrasing was relatively rude and I'm not sure that you got the
> > central idea right. Large patch sets are generally less welcome when
> > submitted back to back compared to small ones, but they still need to be
> > posted frequent enough to not lose reviewers' attention. And small
> > fixups to fix a build as module are not going to make a huge difference
> > when reviewing, so it's best not to dig your own grave by gratuitously
> > bumping the version number just for a compilation fix. Again, replying
> > to your own patch saying "X was supposed to be Y, otherwise please go on
> > reviewing", may help.
> 
> I hope I'm not coming off as a know-it-all by saying this, and I didn't
> intend to make you feel bad. Ask me how do I know, and the answer will
> be by making the same mistakes, of course.

No worries, but thanks for the concern. I understand the v10 fiasco
was my fault - I'm alright with being put in my place. This is very much
a learning experience for me, so all this feedback helps.

And I also am recognizing a difference being past the RFC stage. The
changes are becoming more subtle, while the initial RFCs had pretty
significant rewrites / restructures. I'll be mindful of this going
forward, and call out any changes I come across in self-review.

> 
> Not sure if he's already on your radar, but you can watch and analyze
> the patches submitted by Russell King. For example the recent patch set
> for making phylink accept DSA CPU port OF nodes with no fixed-link or
> phy-handle. Perfect timing in resubmitting a new series when one was
> due, even when the previous one got no feedback whatsoever (which seems
> to be the hardest situation to deal with). You need to be able to take
> decisions even when you're doing so on your own, and much of that comes
> with experience.

I see the cadence of every 5-7 days or so seems to be the sweet spot. I
had thought this v13 would have been long enough since v12 (4 days) but
that seems to have been incorrect (understanding it was over a weekend).
I'll be more mindful of this in the future.
