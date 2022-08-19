Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A61B599D16
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 15:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349402AbiHSNqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 09:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349217AbiHSNqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 09:46:00 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2105.outbound.protection.outlook.com [40.107.102.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94744F4C81
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 06:45:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ap7fkhICJf1Exs3KA6Lpn19CO/6STpR789tMloUSCsVZ8DMQeWQWvbEAGF9YvJr+cPotDl7tThWor4QZ6Z8rudjXO+MYlOLHBT5uaqvVvoXl7agLSpiIcOJU6XvJrDCJCaTeMReTovBIlkvNl2Vb6uONchaHM/1Y8L7A6dtkH3TVLY3TDl2S5DCPlEJ0fFRL4CLLEA1WdIW81vKgUDm2p1OfpYgTPdB1DzPHzt0I8hke0YOXj8Uj1vQuxShwJ36TWf6S/kA758zK11e4VVfTsmJi9maP0JT8zx/6qqu/sH2M9ny/iLPgn7HwM0l1Yf4Fss/tLm+JJ5wIXO0sVyJyUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FP4bpuIR8hrll2OEUP1YsI82dWiOc8q4eQ4T1rgvn0M=;
 b=BV/huHQb9O1shx7Ns3DS/NStmEcU/kCcg8jdjukR3GxPZB76A3j8VKHc0Se0gjXanSwabMdtvgVTTiUJYk8d+eVPX+X2JqsOu34fQsI7+0WOPzhSSBK+ie+8vrSR9IQpM59czXO2TbzHzvmCjUtWWxDRkDNbSMiJF6ffI0m2qoQn41km691wrnPuHAr8Y2aZkcsoNJuUHP3OENLDw8H1uxUzS9QrQf5l2Eu467LaKEz6gTM8qRb8QETi/wBqLUMiaHB+krm1MUk5GjnU/QGa2o870AZw7iW2YLDrNYmXBz9GAepf614gadz08vr5WzT97caWF23ZVG84nlkDdgIakQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FP4bpuIR8hrll2OEUP1YsI82dWiOc8q4eQ4T1rgvn0M=;
 b=r+7DPLEg2GtXQBOp8dUm4liVgNDunaLlMNrwSSp1AjHIfQNDeA+bDVZkoRQCO38grio9dz5sGAMA2mkO42gFIisnAdZKEjM85VYva659cYGyMweLW0uxtxbQLOU/rrvgvTrAJtc6kj0LL6cjx1TpFy6EZgCd0PxBGO47bqpacUY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN8PR10MB3649.namprd10.prod.outlook.com
 (2603:10b6:408:b1::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 13:45:53 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Fri, 19 Aug 2022
 13:45:52 +0000
Date:   Fri, 19 Aug 2022 06:45:48 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH v2 net-next 8/9] net: mscc: ocelot: set up tag_8021q CPU
 ports independent of user port affinity
Message-ID: <Yv+UDHgfZ0krm9X+@euler>
References: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
 <20220818135256.2763602-9-vladimir.oltean@nxp.com>
 <20220818205856.1ab7f5d1@kernel.org>
 <20220819110623.aivnyw7wunfdndav@skbuf>
 <Yv+SNHDXrl3KyaRA@euler>
 <20220819133859.7qzpo7kn3eviymzo@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819133859.7qzpo7kn3eviymzo@skbuf>
X-ClientProxiedBy: SJ0PR13CA0141.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::26) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb49df92-7217-4bb4-6232-08da81e921bb
X-MS-TrafficTypeDiagnostic: BN8PR10MB3649:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YQQyYUKi7AuYS8gsSo14lEeUZ2d5SPDJc51+vIN+ch4tzzAIM83dGrP4JREbh/BjdEaKqi2NEP2ItU7X41l+8SqAKHuQh/Fv9ZcoMeAcotB0SAy42AX+7Pp8NTzH0VbeYMsdZYbiMWhLov9cSDfOCDHLBhFV9l7d3XFI6hkugCWbY2ItbW7QHYzP8o8FS3+2vbJiYoZQFSz0u6ZEhPmDdNHUS/5UUkYLBpkyQ0R+Hc+d5RcHtyjRWn5WKymqRmwZZcvKGz6f+LuWccVGcoO4KsRnHkVX+/nIEdSAH5Mz1dJnpR1EAhoh7sRyFsLkgZPY5fYxJ/BhfYCg1aMk60svBPuz7fiwWZNsSQokWhNdH/PcqwYTro7LVE59e+qRjNoJPILHukebx908Ozz1o9hBc0ZbDZvmeSVbTWvuYhdpgPEShYeHojH2PvtIUbLvrSUUOAsyghwiD6PZfRDCdUP0AZSC74OrxjPZZu5QknrhW879oH9r4DKqx5BNLpaxwqVVasUH/AW1rfeOaxTbj+Dyf/kukj16EnbzsoGWd9jxxVzoBvc9RwYcHuuvHH+ykKzTTczu57IizOouT5tyupridil/T+cH/M3gKvEPmJGtqJO4ec1Nj25jNaE4s2OOVnkiYw4EN6CmNguVCDlAtNvzLkM9wqXBwaOp6kwv1L9IIlhBGnmb12UlGGpoR3UTa8hwJ+iA/Zd3IF2pTUiYSI2YMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(396003)(136003)(39830400003)(346002)(376002)(186003)(6512007)(9686003)(26005)(83380400001)(38100700002)(5660300002)(8936002)(4744005)(6506007)(44832011)(7416002)(66476007)(4326008)(66946007)(8676002)(66556008)(33716001)(2906002)(478600001)(6486002)(6666004)(41300700001)(54906003)(316002)(6916009)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZRNJ3LD2nSvLw4qUnItcO1AC6Lz2oCLqMxWwG4doLjkrt8zxtOvi4i58mrxD?=
 =?us-ascii?Q?XLHVJGEQ7xRretFGKeDYetVrvba6QgTSnGcN+dx4ZbYXJ24LZBHNeHlkPa3H?=
 =?us-ascii?Q?FhmM+sa2uQ9VjLSaYsZrETU7vZd2kcSG3Is66fSuc0c+84gzYH3VJ0lfUj0N?=
 =?us-ascii?Q?C0Ci+RN5M/V3mjYbD4Au8ZFV2Vavr6uc3JwPglNKUokJfGZo3U0cSyo3kaHS?=
 =?us-ascii?Q?QeliMugL1maBzoDU4bCrZGRpqfUw+sYxEKpNk8BGjzvazcND7CNh4J1SE6yS?=
 =?us-ascii?Q?rpgpoaxGvdgBWFeXaeq8Jpt+2zesqbVfSGTXh9G2n62WIMdmW1cNl/N+b4ZZ?=
 =?us-ascii?Q?ZO7Y0pJD6Ohz2511677YUc5cu5t5LBZO/ceFeR5a6/B0oMJBbTVx09HFOXSZ?=
 =?us-ascii?Q?wrkFAhMnJcePxpBdgddGupWbdbu6+g0iUTpHHEm5usPLQvgQxFFTKD/e5wk/?=
 =?us-ascii?Q?asud8EzPJU5zNZ1Xa7pI4fb46FsxrjOhbwPUw3IwV6HNcTdlMP9+a4mGWulD?=
 =?us-ascii?Q?rH4mu290Sxz9awm4TAcVIXqRZkeotvyKNRoZ7ddK4zajtn+ud8ozP5ljY2ps?=
 =?us-ascii?Q?dKBgLENjXUcxetcRMq9ChI2pb+NtzF8N00OQYyib5EiHy5G80J6M0Ex6UsmG?=
 =?us-ascii?Q?rcisGyZhLUfjV95uX6vIvxW1C8EmlhjjieCN87vgGOtglavY5Oz2HWNuTY+o?=
 =?us-ascii?Q?uG90TCtnqVsBAqi7Tu+m4uVGgmzxKN2Ni+yB1M6NdEQVaVEGzFMvq3mpt3hl?=
 =?us-ascii?Q?51rDnCp3pL/m9l2F3YXYR21vCQlsQ4k/YVY5Y8vYyV5vJ2SXl7+rLvTQLaqZ?=
 =?us-ascii?Q?hOwYPOKjmxcAv0smJAHzE0j2vhzIow8a/SoZ6yxCkOnKpqMUZ2eAXAfdAmSu?=
 =?us-ascii?Q?Cu+UHcYZGrAjY74Uxj7bqBE7X5D5g0lowfR02tIbNdJhViUlnkGkY0YvhhTH?=
 =?us-ascii?Q?unYIALuDqN4kFrYg7AYLUE7JYzgEVYIiSAHWq4QqsHdgW/sUL0BtnW8I5SRS?=
 =?us-ascii?Q?zO+OrF3NgcbA+kPn+jmkoZwVgIUS0RLm7hyzV3kHiiPvgZAqTtIkm3Cbn1TR?=
 =?us-ascii?Q?mg6UVKE0QeK3tc/oRoiJIkTrNDsK+26hSsw21XFll/IvEyPdFhmJkjlH08fe?=
 =?us-ascii?Q?+K+fh8eB6V60WfEnBc8brK841PGYjWGUNa2e07hj9c9Obpaqsm2g0EW92cRU?=
 =?us-ascii?Q?M6+Akz3hAkgTy1MLwfR+XEvU9KXPC2LzLP0l3DNNt8Tee3gxKJo3bnKxoOGs?=
 =?us-ascii?Q?E2KRqBqpg89Rufu3qpqNCZjVfZsvHHLizT+4j4MRWA/bDeODgmuqn/0tmMwh?=
 =?us-ascii?Q?kQWHBAw6dDzNHi+IdxB3OXCLiq5+mQ/vpQFAaso7048253Nc6S4m3xRr7pWR?=
 =?us-ascii?Q?ohHFT0t3Y923ay/jN6CeBJ2nueYqBhadWn+J2EtDn8OKysfGOTCfMNyVY+lP?=
 =?us-ascii?Q?NZWN2jdTJkKCSjdhs7+37vfXSopz6/6BR/mZ3cBirBwDCEHj2Vr30IRVzGVD?=
 =?us-ascii?Q?TpjfNj01J2kk6Bmg9FthgwxmJuEAtIB3aIM2gzXFobZd/pNCAkPMeQkEGQoW?=
 =?us-ascii?Q?SVPWjzN42Jzh70bBLCqX1rCdmdTrmmXNMbvuM/b3fUVoTR4ZgT1qO1FTmgTu?=
 =?us-ascii?Q?ZPVs6fujsBAFLQl2L71YODI=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb49df92-7217-4bb4-6232-08da81e921bb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 13:45:52.2137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mO2uFzPufxI3y1TplhlPRsUeQp+vtP5tGNHRYnAIGPXfpt7xSwMzXpHiIKXCM/f2XcWv8fuiBf3lDeTSk/A7q8gUU56l1+zf0YLLna/XDQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3649
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 01:39:00PM +0000, Vladimir Oltean wrote:
> On Fri, Aug 19, 2022 at 06:37:56AM -0700, Colin Foster wrote:
> > On Fri, Aug 19, 2022 at 11:06:23AM +0000, Vladimir Oltean wrote:
> > > On Thu, Aug 18, 2022 at 08:58:56PM -0700, Jakub Kicinski wrote:
> > > > ERROR: modpost: "ocelot_port_teardown_dsa_8021q_cpu" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
> > > > ERROR: modpost: "ocelot_port_teardown_dsa_8021q_cpu" [drivers/net/dsa/ocelot/mscc_seville.ko] undefined!
> > > 
> > > Damn, I forgot EXPORT_SYMBOL_GPL()....
> > > Since I see you've marked the patches as changes requested already, I'll
> > > go ahead and resubmit.
> > 
> > Any reason not to use the _NS() variants?
> 
> What's _NS() and why would I use it?

include/linux/export.h.

I don't know when to use one over the other. I just know it was
requested in my MFD set for drivers/mfd/ocelot*. Partitioning of the
symtab, from what I best understand.
