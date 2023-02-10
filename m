Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5439769243E
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 18:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbjBJRPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 12:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbjBJRPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 12:15:06 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3616227BB;
        Fri, 10 Feb 2023 09:15:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ClEmRUtKNKj1OZ1liHot9ufBrGQBuIqDkDqf7FZuR6m6HX4Gyk4QGTo1miEosCe+yXaTj1lqFgjCmqVsZAGYvisgWo7GHj/ymkmAQ1BJyvcezecHtTdPrxOQXpmexpwjT7gy017DW6oW5fMr0c/SO7BRQhEf9wLFDTk092v8k+XAhU8X1IK0kz1UEW7hkll1mR6KHpW5tE2XDPTX55McIzHWdTHEvrjjFMoUXWKGUWVmHE8qIwJt2rB+PNHKxPnaqpoVbj1ZLolixQray2rt8N3mjmMZuQUN3R3fhke0MiAWJHKKDgfWDRlIe4ieMpVGMN7JsldjbPzbmDkKAh9HYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a9Xh0wLENKAKQPPUCCW+NjkWmJIYvEASu8O0KfXrmhk=;
 b=URm22s6T4bjLMSbXwAO3Edy/l8ud0fZuAzmTTkdw87ZtOjWb/XTVCrcV4CHDZDaRBlarxy8oxHmThX55K9TpHsJddJwBRB3ptfktpRSYPZWHeD3yHH7EKuSVyeo41p2SD8e1w9CbMNmA6ZL19PYm2Qf6h/wJpUrOTQ3bTzJjaby82eEnBOottjl5k/kfLfIx+ApiYmiPyQ/PjAtNrgHDWpNPoJ9oxYNSAix8SYr877XVobiUUNPRnkirrik+153xz8m+v3elA25MhbGTdZqVSmgWRqXE87itTxAyPdiMXxudLrZQ9CceRHFsSGCzwJGPdx2b/btLvUMoxBdghKcNkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9Xh0wLENKAKQPPUCCW+NjkWmJIYvEASu8O0KfXrmhk=;
 b=CIjKNUr84eH7q1Tc4QnNcQjgFVan1Bf3sQZO5JVe9w3lQWpYwsIy8qGkcvOjc8XajNStn/cK8TzXEOefsB+TsKDi7b1t3u8Ienqt00dBZu+205tS3LKlOz3WgbtzSFCjAls3mqHO2FXfBcxXQ7XqMXTES/FidLEvZOW8MGTovPvKxe0dWCYZIshKhRQfNBxgGzdPfuurKWu34tf/1i41dXu9q/B5qo5QAGq5yngqX1Zp2gxzOwwbmUZLg1VyX/gIuHk1loiJetFe6AqbHuEm/xKTGRbWr7yEeGFsgEPz27djQ5CGx4CpVyoK8cnb+9ZB45KWY9VhsmCTDeptR0IGTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB7568.namprd12.prod.outlook.com (2603:10b6:208:42c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 17:15:03 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6086.019; Fri, 10 Feb 2023
 17:15:03 +0000
Date:   Fri, 10 Feb 2023 13:15:01 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <Y+Z7lVVWqnRBiPh2@nvidia.com>
References: <Y+EVsObwG4MDzeRN@nvidia.com>
 <20230206163841.0c653ced@kernel.org>
 <Y+KsG1zLabXexB2k@nvidia.com>
 <20230207140330.0bbb92c3@kernel.org>
 <Y+PKDOyUeU/GwA3W@nvidia.com>
 <20230208151922.3d2d790d@kernel.org>
 <Y+Q95U+61VaLC+RJ@nvidia.com>
 <20230208164807.291d232f@kernel.org>
 <Y+RFj3QfGIsmvTab@nvidia.com>
 <20230208171646.052e62fd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208171646.052e62fd@kernel.org>
X-ClientProxiedBy: MN2PR18CA0026.namprd18.prod.outlook.com
 (2603:10b6:208:23c::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB7568:EE_
X-MS-Office365-Filtering-Correlation-Id: 84297d97-7a90-422b-bcee-08db0b8a590e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qLicxIMO/4bVZY6/KfWnt3BVHBcARWQb9VuuFXjpI+1fv4ast7gfNox2jNUR3ioadePht0WW7VDJEHZmim0KRLXkBzS6ZRzzyhOIJOcE9KWCzc5sjkiqNJOF57CYASzoCG5L7P9MUBwsvIJ3oqfQGXx3ld+EyuhudDFdOX8tiI/bavU01Z00rjsBcIJ5TbTvw1uMOfuRdycZ/nOCc/r6tw5v+kZ3iZis1igsk9iE3IoM0gb9kfa5413yxvhe1cVaGp4gjjFgRJTJsIP/+Tt6G24CsqsiS8FWURPQla76zilEAhqbsAkPT8xPi/0v9+PiXvZ7R+822IbdpEyE9pY2nOc8VKvER/OvIvzYrpxjglTfU0dIuy4rUQshmTtK+CiG3NcJ3WI+OSF9ODt4zs/RKry62dExf0VjeWjKObSnZPtOsPq9D5zWr0c6JdBavcav5X2Y76XuPUrs7aLwgDVl2njqKWKJwqGeVZ/EsrSeVA31Qb3pdFd+pga/SLE7laKmTCXyjKlEHuncB9nSwYBSHZRfrHjsx8/Rtxemqv/r0Bbck9rVtox4sGtoJDs9HHE56iit3+u+CGn6QUa5UMnN1Q4K2ROKWfJGaVtBClobMq8ZhUxjaQ+C5YtPfX2mdqajNDf7hoMulsGBqvCZB1Tt5QCl8e/GqxAkPld7qXEiKn9+KCEQc/xWku9J1g9I+v/7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(451199018)(2616005)(478600001)(6486002)(36756003)(6506007)(86362001)(54906003)(316002)(66946007)(66556008)(66476007)(38100700002)(6916009)(6512007)(8676002)(8936002)(4326008)(41300700001)(186003)(26005)(5660300002)(4744005)(2906002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PSaOIZl6DNnrkcT7ByFozzZU9fAlK4L5HL25lrdlkBzzddm76WZ5H/sq1tIg?=
 =?us-ascii?Q?LfBVTnzypQFYo/eQQs6b+p3ynBqAm0kWhG70HmKFVq01ZbkovPJOpO7JGrFE?=
 =?us-ascii?Q?jST0bY//4B9H+AVLp7n+ZwYXVkwR30VdUmUcyE1jjhqki2w+14aeoga9S/wF?=
 =?us-ascii?Q?xO/WyWBt5ekjHi+8gRcdkkVllfkaqVc0ofFUJRxB0lyutbAKs5r7asSbYqqV?=
 =?us-ascii?Q?Y/yVKzl6vTfLU9sYdsuX7VzWNeDD/IvhvWTomQjY7wKAWUVS1K5ucWVmjJ/3?=
 =?us-ascii?Q?+mNeWizKhVqtWAVVtdfIw9lZ8GST1XEl7frwZXu6t9aumCaxU38q5twPuUZe?=
 =?us-ascii?Q?SH5jcEcs4/kU+EntPiedhROktCs/FQbKrp9vIhYnrGKuW+l5VUK1Wcnh9gDk?=
 =?us-ascii?Q?hx5QSceGDGZAzmFDhfucpifujzFhuoXWcJeEUL7gycFLvD1B5r9lblhDIqix?=
 =?us-ascii?Q?KVyRv9RJjWu31D62578u+EwVwNo4o6m2LaxDglYehv4tfyO2DAMLQUEaiL+8?=
 =?us-ascii?Q?O8Hfv65PVwiuWG2pUPC1BGcYDKLJlI+3VLi7qIrc3xlSSU0w8FwBWWyYTOuq?=
 =?us-ascii?Q?uzy4sONMZ9uCdzQTRo3HsUWfFykopnl+LV830HirxHW9TK+Ev/ZVoDCqHJLL?=
 =?us-ascii?Q?gnUqlcxLPE2ZCeU3NTeJe3WbDXlg2lPcfrQ7aua1E9qTH4dNkyi7C/tS2hr7?=
 =?us-ascii?Q?1eA1laKc/g94rPy2bCo4aVSRX03MSDq2DowPeAFLjdIN9uzXU+NVkZTt5Ro9?=
 =?us-ascii?Q?RjEHC62JBlFHUiPIxfhtnUoo7mqQFtxl47I3iEh/4hpTFSphJ52/IMt3kvFi?=
 =?us-ascii?Q?dfK3GwRDTiYDSGF4GWTAK/9WOOoit3vQQ5fPwDdbJDKaLQ5CX3JLvkXlArTN?=
 =?us-ascii?Q?5O75SJznPID666KHCgnRroNAkZY7x1Oj9jHsPUdkHqOb6lxY4T0g1RzNK0yf?=
 =?us-ascii?Q?Tyhfkp90CTRRAX5R4wVSWnkfLN3D+nIPa2PA6X3J5Gu0FvJLWMins8cFwumD?=
 =?us-ascii?Q?09ASdp4r/nkb7YHE+Nyx4TSBhkK2I5DRzJZGfNiC8TeB0cIp/D6DaxkHgd4Z?=
 =?us-ascii?Q?G6ZcP+IM1J/RFe3D/Fu3LgSY7CgG0v4oNSEtGwkpdpsCVNVJCL3C24MNReH/?=
 =?us-ascii?Q?oXeAZsEM0R9rncz32QpQiax7937pd20av9nBjLx4dbytl+gpopGuCwIYYbqz?=
 =?us-ascii?Q?UVMdYinQBqtw9nHaQKzYZqmHNpJbum+VfpxPsN5vdNHE6MoK0VFcQeXPi5aO?=
 =?us-ascii?Q?hWD1L3j5qIQhADS6ESKFDVwhrr2XmHhcaMHVj+1B6ey9ldfBL+2Ov8zjhQYZ?=
 =?us-ascii?Q?vB81z1evQ/t41O4LWdwx+PRpi3VRZvPqFlIgPna0EyUZ63FncNJxa9Mr5WBI?=
 =?us-ascii?Q?hPbGpLJQAaJbU5yMMq0AeFcHh8hAAE7OdpcufgKyTxLmrK12b/zYGWcwYW3j?=
 =?us-ascii?Q?9+JaTu6fYXNf2KYoSrWhGF2BwwFTZEeBPtdIknfxBI/pGCRR3aSZkRDNioNQ?=
 =?us-ascii?Q?KrJHTA+TuObVOalrb72le5KAe1Kn5NDSPrzapQkqfLv7nQxdA3n6hW1VaMPJ?=
 =?us-ascii?Q?b2ORr0g9i3S0903D8INbrgXTKfnXQOjtQ1QLzR7+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84297d97-7a90-422b-bcee-08db0b8a590e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 17:15:03.3134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hz0PpGG/Kd8kZb5AtzHbDmsyF9AwhpTs/DGgwbaYTpgEXVrcSke7lZm4ht+XL+Qu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7568
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 05:16:46PM -0800, Jakub Kicinski wrote:
> On Wed, 8 Feb 2023 20:59:59 -0400 Jason Gunthorpe wrote:
> > > Who said IP configuration.  
> > 
> > Please explain to me your vision how we could do IPSEC in rdma and
> > continue to use an IP address owned by netdev while netdev is also
> > running IPSEC on the same IP address for netdev traffic.
> 
> I'm no expert on IPsec but AFAIK it doesn't treat the entire endpoint
> as a single unit.

It does, the SA #'s in the ESP header have to be globally allocated.
 
> Could you please go back to answering the question of how we deliver
> on the compromise that was established to merge the full xfrm offload?

I've said repeatedly it is in our plans, we have people working on it,
and I'm not allowed to commit to specific dates in public.

Jason
