Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8724B3A0D
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 08:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbiBMH6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 02:58:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiBMH6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 02:58:30 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2055.outbound.protection.outlook.com [40.107.100.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7778F5E74F
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 23:58:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZfxR+DMQ8lPuEoOyBo+sirpeUAUJ0dU6Ah4jtHh5YnDovvASQhss1Mqv5+NKYJy1Xz5FqeCk8MGigRPaHEv/3mrV4FIIUhWnIS22sMXo+90VGNLLHvGQHrmHze8DaE92gznlqYtoWg1TMciuBY6zoS6NA1REODo/G1xdo/X3btYukJJNlJOjsGudL2KV4qadTt0Z6tNfDDBUSMZHRByWfZqNZvm3/5w0+BSIoJSaSAlDMGEqxkKYCrU87uxteTiVoqed29mTIvOTCKWzXkbTYHDwuGE+EWv9TzmNmBdpASOSIi/6uY71gH3JTuVZ3rOLCNpw26motrH2CtSulUKvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dC8XHaGsdt6FRQeTSr5+KqOigz2wkP+U8Tt0sDcAAzs=;
 b=dUbwVkG0q8nXidj/daamSkjL5s3txTD8ajEHJf8wE3BlTnmUdabdPxEoZtRP6gyPstO5WvIGOwGx577TYi+qb7JUgWGCpCJwjbE/0dlee2Yv0eGO9DXSGInsU/ynU1QGXHw6fTa2jHKs93bgyitZc4g3GHqFN81QmA3FHg7C91qjB87v5ZXes6+0gH5dwFAPLUBZZ/EThUTjWFdIxV8xZpklqd5kSjSQGNpx6NCJpiEcPrSVAazqXMvA0cJy14GPSnYRFEi3PGY2/E5XFGmO7U58wo7VcT3nlDdnZKwyWMF8btfBbANLSRABQNWDs91amhIYdjOxY2uwWCVMnWCbig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=ovn.org smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dC8XHaGsdt6FRQeTSr5+KqOigz2wkP+U8Tt0sDcAAzs=;
 b=tHtEMctgXdqDO9syRwm9oM8SzC25RZeqP11gMBF8O48qV8qiIcDULGQFgUYwrc94JC88kSzscneypETi8oFaMQU6Lc+lH4G56WgpUPqQ7a2gRA0dacxW9alJzf52vjcCjzK7v5JZh70i5UaIYnMXpC4zEOwLKNHNzKAIQR89veqJY0FAAt7Ab/PnIJztXFKLTbmpX27UI931tLvb0cn0ax3je7jmhu3RWz84RBvIKy/+u5TE+1JsosM5nFJkE2rvPCCaFqPPWWNJpYY0jhpuMvKnX7bzsD0mpAPi53Bl+f4EkytqjUP1W9k1K+xn4gD8P7IUd9cWXfeyJ/W/WupqKw==
Received: from MWHPR1401CA0007.namprd14.prod.outlook.com
 (2603:10b6:301:4b::17) by BL1PR12MB5754.namprd12.prod.outlook.com
 (2603:10b6:208:391::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Sun, 13 Feb
 2022 07:58:23 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::1f) by MWHPR1401CA0007.outlook.office365.com
 (2603:10b6:301:4b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Sun, 13 Feb 2022 07:58:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Sun, 13 Feb 2022 07:58:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 13 Feb
 2022 07:58:18 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sat, 12 Feb 2022 23:58:14 -0800
Date:   Sun, 13 Feb 2022 09:58:04 +0200
From:   Paul Blakey <paulb@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <dev@openvswitch.org>, <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Pravin B Shelar <pshelar@ovn.org>, <davem@davemloft.net>,
        Eelco Chaudron <echaudro@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, "Vlad Buslov" <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: Re: [PATCH net 1/1] openvswitch: Fix setting ipv6 fields causing hw
 csum failure
In-Reply-To: <20220210102151.6df356ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <efc0576f-431e-d1c1-be1-14c28fc064e5@nvidia.com>
References: <20220207144101.17200-1-paulb@nvidia.com> <20220208201155.7cc582cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <5ee3304d-162a-e5b2-f8e9-5a4d52c71216@nvidia.com> <20220210102151.6df356ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 952ec659-6c11-4095-2958-08d9eec69b14
X-MS-TrafficTypeDiagnostic: BL1PR12MB5754:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB57547BCADCFA39C4D145D8DFC2329@BL1PR12MB5754.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0trXuTqPEQL8vz8q3W0lyajg4LsZdCXKj+/qtmbeTYbnHX++SKV+NG+646In8EnMn32B/Pzf+ib5nYugj5j3uD7ec+wM8Z6/+FOyKrOudZCbmnnILrEy/RJb39VXNs0M/jB6KEhNP0VP0xnGhe5r30qWroco+A6X/E5jWXe04Vkp9dhS2lWThc/PRdWhTv77l0Yrk11T9VDXbBp6ipokYQ7w3OQpLWPVtrlm3xPj+RFB6e/trxNGGdau45+K+3n55sXER1PutvK41lORKHPJCx4+Kh3xtKl613qg7pqQiikb7KSPuH/PuqB1ft9G8iCSld+kbH5C4O5qf6EM1hdDeyNL5WyOHy7LLgqOITOCGOzYRFNHn3qgGdKDC+Uf30+h5NId9GeCnNDol9bpJmXORyV9LFTQEp8OwHUopptkSomw6l0AxUEEZ+pYU43zBISVVyZFee8HH9EeVs5fYlrlvu7d9VMwZS2XSDJFc2hSC95ubMFKyuOnniYENm9MuVi4cCiOnSjD5rnV9p7vaApkp3MpnSmh6FMf/gP2jYuEMSH41NB3MKzQxtbWOpaziNvic4cU7CwGP5x2BV9rlxy/YncsCkbkLSNqJAN/TgX4gw5AM8BklyAab7thwI0GpWSiCyY6McOnLOPxXWSxsNLhJxsUxEuxlOuOgsiLADgsxiLyygZJTt/u3cxJN/i7AYGDBUDHD7lasfAK2eiQoemKRg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(316002)(36860700001)(5660300002)(6916009)(107886003)(6666004)(2906002)(40460700003)(82310400004)(86362001)(186003)(356005)(81166007)(47076005)(336012)(426003)(508600001)(26005)(2616005)(54906003)(36756003)(8936002)(16526019)(70586007)(4326008)(70206006)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2022 07:58:22.1423
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 952ec659-6c11-4095-2958-08d9eec69b14
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5754
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Thu, 10 Feb 2022, Jakub Kicinski wrote:

> On Thu, 10 Feb 2022 10:53:24 +0200 Paul Blakey wrote:
> > > The calls seem a little heavy for single byte replacements.
> > > Can you instead add a helper based on csum_replace4() maybe?
> > > 
> > > BTW doesn't pedit have the same problem?
> > 
> > I don't think they are heavier then csum_replace4,
> 
> csum_replace4 is a handful of instructions all of which will be inlined.
> csum_partial() is a function call and handles variable lengths.
> 
> > but they are more bulletproof in my opinion, since they handle both
> > the COMPLETE and PARTIAL csum cases (in __skb_postpull_rcsum())
> 
> Yes, that's why I said "add a helper based on", a skb helper which
> checks the csum type of the packet but instead of calling csum_partial
> for no reason does the adjustment directly.

Then sure, I will do that and send v2.

> 
> > and resemble what editing of the packet should have done - pull the
> > header, edit, and then push it back.
> 
> That's not what this code is doing, so the argument does not stand IMO.
> 
