Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E5A58F922
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 10:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbiHKIeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 04:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233535AbiHKIeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 04:34:15 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2120.outbound.protection.outlook.com [40.107.96.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BC16A484;
        Thu, 11 Aug 2022 01:34:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RFcrEBkjRpVvYXdpPvD6dyfM7QgizePJ3zIWT1rIkMeE2gXI4z9LFUA0g30bHEB2bXbf5KSPqKM3Kbz7eCZhkJLEfS5gm4vx0RpH7yy3qypVQAYlbz7DbSfT77ZiZfkEG+XSxsmZ/mAuj6bChTHul/qqyv1NzWA7CG9worsrvucgU8CEw8/l1njNELztgg4601Hq5Le5FS2DqNT2wZqlaU4GMyiJ26R0rnID5KMS4d8w1nx7GRU7/Eazet+4Pec9Fxw7VhfoLoxpMUPbTzLi4RpoPHrWl74ZAbW8+zYCrSOV1OM9iWHH3gE0USDzbTZUOj4L+K51783AQxPWKpxhOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pe7sbxxo05HweeyuhWa571LsG8rS01f3g3RbVKV1KdU=;
 b=cL7P2WuQ6c2ZwpTTkGwjkzSBC2JIwc5SbOdzbvPKtnSuyaLKWN+/X7skg74rG+aRf2eLVer8Vj6DuBmI9h3t0Nv3nQEF/mwlqWPf0rziKCsOGuvNP3IfNenPPNLsJCjlK5NTDM8FOqkN9HfyK3Act5tf65hZvOmIO5qf4gdeMa5MFoKJIkEn0x7IWyV7Rdiqg1jNo7O23SEYnkJRa/EMmw/ugl0+SS/InqtGyX6NhSWZ5iaVIhl4dXc7ZwSgVfhVqTlnJnqFhQgnv5kou/v6Av38Y3x4/pbChtkbhGCLihRpTEPDePEpQWtCy+DXgJbQBPk6J2DIM1G+RYimCo/0fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pe7sbxxo05HweeyuhWa571LsG8rS01f3g3RbVKV1KdU=;
 b=sW3vbZxTziKUyt5je53J0wVimzdR2QlJxJIZTvarfgJ1JMI20MT5g8gAQ8nDO7eFlJ+reSDjHlNkTclmdGXduCglEIhBKkuP4slXo4+3WVd2uumQQj5BNt8V9B15Cm0rfnwlW7w7mpPHvGPlSscBbkEG2cdtBqF53jt01pXzcvo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4560.namprd13.prod.outlook.com (2603:10b6:5:209::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.8; Thu, 11 Aug
 2022 08:34:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%9]) with mapi id 15.20.5525.007; Thu, 11 Aug 2022
 08:34:12 +0000
Date:   Thu, 11 Aug 2022 09:34:04 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Jialiang Wang <wangjialiang0806@163.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "niejianglei2021@163.com" <niejianglei2021@163.com>,
        oss-drivers <oss-drivers@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] nfp: fix use-after-free in area_cache_get()
Message-ID: <YvS+/BRcHa5pTSXA@corigine.com>
References: <20220810073057.4032-1-wangjialiang0806@163.com>
 <DM6PR13MB3705E2B4925F8BA9B1482DB3FC649@DM6PR13MB3705.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR13MB3705E2B4925F8BA9B1482DB3FC649@DM6PR13MB3705.namprd13.prod.outlook.com>
X-ClientProxiedBy: LO4P123CA0353.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa1eabf5-3946-4a80-c4c3-08da7b744441
X-MS-TrafficTypeDiagnostic: DM6PR13MB4560:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +xj67sgif0gk6Ydq9ziFsMIR64cllu6fQeV6rlw7Q4KrwHgbHh5jRIRGwJTcVCoYBguRelGcdQeeg9s3qO7y5FwfIOHLq2FYkzgYu6AgCDlio8cYu+u9HymCaFdL25j58tChJhVjATV5ZDYZlnKkRfvaddN7qUCjsbqTXbZtff6wxVfdKYFw+XAD6+S4eLq4UZ1A7/w11iOeYD3EKGTyoLS8ZV5bU9Fi3dmi6vrfjT/eCBVloM8dmJttvHDhHX4YW6yQpAYMsxE3qI2u3rGaFajHiEJ+L9rTv1ELfPI7d7qVvR0Up6dEAgFKG596oyQAblgFrUB/7B91HK2i4yijdsTqDhFZcOF6cPOWEpIlC4U3f/f1LHKkIzXP4uUXcZalym9uE2tXXDuXuvYoPOviz8jw2zTn9YVHRl55N4z017TzEBOAxKPamVULMZwEtDRbzFLW1TkaQeIi5zKVBOTFA6huwQQueot2ENdSkUA+D0q/rcm3HLvRMv5NeJAg6xyrU8b5kxy41wZwtL6gaa7N1WIQFFbMa2BZDDiLxEe2YWtmJSc40M4FI5D0yZYn1oZTPv1zfJHKxT4k5ZW0PLLMPAEMsh/+Z09sVJLbBnIRfH85NV4hYH7S83Cg6AwgAHGS11+bT/AzECbH+YCCWg8mtX64Qf8kiBnLKlY53OxJl0Zh3mI/t+bRXgY363Qs5QFR4gGQG4p7Y6FBuKpzS0OeowdlqFcn1iM1y0kk+9E7pY0ylTYhr+uTvqbICHJpuppCsMuRjwKC9A9Wm9LdYo2mbdauXtrq/NbndcEMN2nNhuhJyR80pfXYH0l0wkEom8hnrZsHlL4khQJfPc2OF5Sg+kLMtx5F3s1a0xcAoGjBLVE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(346002)(39850400004)(366004)(44832011)(86362001)(2906002)(66946007)(8676002)(66476007)(66556008)(4326008)(38350700002)(38100700002)(6862004)(8936002)(316002)(54906003)(6636002)(37006003)(52116002)(55236004)(41300700001)(6666004)(5660300002)(186003)(6506007)(36756003)(2616005)(26005)(478600001)(6486002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JOxA1hPQXvSzu9OWeANAC2FKaLh1RgX81s7RdQQuhXypr3oKT8rDuPR3JhMa?=
 =?us-ascii?Q?qa8Up94zYNhtpiPiH4CpJtxiJ/WJxvKQYX17dnLHALLFYwVW+1CEO55gsTdn?=
 =?us-ascii?Q?ybHKE4f0pdU0OxF+d5kpp9nzCZU+lIMhQnXkEsD3Y1Y5ZGQ7ahuCIypx+vX/?=
 =?us-ascii?Q?tHFOxxvpV8+fJzSl0t+oqZHu7mntFAXchRMi2ASfO9RKpYuocWR/zyjPHmFe?=
 =?us-ascii?Q?tUsNxPXDL+FPfluhENof+c2Mu9DjBvs1zCdMD9MmIAj8vSaWZeLs86wLjLT2?=
 =?us-ascii?Q?xWUw7WCPFeLEElvk4IGXHlkLt/G0Uo4mZ/Ws8A10rwLMwEqUXUCMPMoXL+AY?=
 =?us-ascii?Q?prd+Ma+2o2VRNI6uh7VZTFaDMncMl0cER7pyMrae1vmX3hcoqg9zP99S1j3D?=
 =?us-ascii?Q?bLnasisR5WjE53KoWmOR9RoW6C1bXGFtanxVgcTgYRhj6BaGIKpZcGOdmaHJ?=
 =?us-ascii?Q?bbfASTFeo/uabFptjnwAXTk82DyagDMJsb4c3qnxuOS+coycJ2cpKIU1/EDV?=
 =?us-ascii?Q?+nC9fNuxs319JuIYoaYQJzOA0BBytFg5PRYJytD5cTB+aS0tcPqjz0CNwzEO?=
 =?us-ascii?Q?q4uEgoK6necBZCWbjxCeHfRRwAELEcbXGdl/Gdrfcd+09abL7CViKpjWerP1?=
 =?us-ascii?Q?egOjRFAeq9VjCNRNDc5fW+h/wqwZOvRwcKmFL6UDNcXkAR0scv8ND9loL4EU?=
 =?us-ascii?Q?VHp0hS9Fvl6W/1Q/GdrtkMVFCq1cO1thBqvBXjX/3m3d9wcnKlxCYy6CFlLK?=
 =?us-ascii?Q?QIGDVBmb3M4bziyOsTXnvEvaTt2BHqZ0PcEHiWbbm6ZelDU9jUZtTiIhLeT1?=
 =?us-ascii?Q?LAayOtQ+lhYMNo8TMyuHe2ujfogsdPXJXtWSDn7r7/XIaisyGcK6IKocNMV1?=
 =?us-ascii?Q?M7OLyro+zuDS47o5YF1+LcqsVwmkXeLBLA5zB3JLjnG97I78yIJLCHKmgJAQ?=
 =?us-ascii?Q?CmEwkksOSU14TokgtMJ2cdaSOsroYvvGaAaITvWfHir2rnWZx1++bHHK4QA/?=
 =?us-ascii?Q?uZSpVwymO4tWaCc8SBz34JaFq9I+9wfqk4oeF3ilYNuk6wXAVQlPJXx5T3ZE?=
 =?us-ascii?Q?l+BXe3PYmqNdJpxzZqRDTHS2q1ZZpnOzMH447btbTwMxAu9XAXytv9Zlf/gt?=
 =?us-ascii?Q?xq4hzys4shRX1zv7HvgXGg2gCNZUGWAtlboehHawHw6W7Iifziu3z6r6RNwj?=
 =?us-ascii?Q?3CDEYLQ8DLT4CjxoUrVgs5+D7zXbNAroWkGpUlm334g6n1ABlXXLwkcoGPeV?=
 =?us-ascii?Q?+RrowpUou1WZxowymVUTJO0lP7gwRXWze5dQEaGIl4LmZsBiiOBgUtbyn09L?=
 =?us-ascii?Q?67Ox7T7Ixmug9LVjUNeoxeVJYKCTKZmCrX3PDkPpb2RQig4a8f739KWfsWoa?=
 =?us-ascii?Q?iOhblxnb4rwJTkAlQMP3U69Od/2m5Lcnz8T5ps5IaRrfUTDLyPBocHEtzbSY?=
 =?us-ascii?Q?pmH/bJ7R/mL1pojdEbFWi8nhuFWesIKQaJd0PB60rHNkNKfSWUHczvntjv+8?=
 =?us-ascii?Q?4iD1bPVfadlwh5/NSwOkItnwxdVxhHaDVg0eAzwzv8C5H1JaKPkmNJBqbUhN?=
 =?us-ascii?Q?tTsES5NIEzg8YSsRVN/0ZQ6dXRvUpJZL/AJ4KkCyT8gXk87gkq4kPtBetXdx?=
 =?us-ascii?Q?WA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1eabf5-3946-4a80-c4c3-08da7b744441
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 08:34:12.0273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yc4XdrLO7qzlrlRBB3rPB4o75TYk4SL4wlhiRVBdI500fu/CwL9xnmRuTAosaNvhHHGr5YRBwEHTP4J7KJbX1M7cCMpdKwXlxVDCTfsT7HE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4560
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 05:10:44AM +0100, Yinjun Zhang wrote:
> On Wed, 10 Aug 2022 15:30:57 +0800 Jialiang Wang wrote:
> > area_cache_get() is used to distribute cache->area and set cache->id,
> >  and if cache->id is not 0 and cache->area->kref refcount is 0, it will
> >  release the cache->area by nfp_cpp_area_release(). area_cache_get()
> >  set cache->id before cpp->op->area_init() and nfp_cpp_area_acquire().
> > 
> > But if area_init() or nfp_cpp_area_acquire() fails, the cache->id is
> >  is already set but the refcount is not increased as expected. At this
> >  time, calling the nfp_cpp_area_release() will cause use-after-free.
> > 
> > To avoid the use-after-free, set cache->id after area_init() and
> >  nfp_cpp_area_acquire() complete successfully.
> > 
> > Note: This vulnerability is triggerable by providing emulated device
> >  equipped with specified configuration.
> > 
> >  BUG: KASAN: use-after-free in nfp6000_area_init (/home/user/Kernel/v5.19
> > /x86_64/src/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:7
> > 60)
> >   Write of size 4 at addr ffff888005b7f4a0 by task swapper/0/1
> > 
> >  Call Trace:
> >   <TASK>
> >  nfp6000_area_init (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> > /ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:760)
> >  area_cache_get.constprop.8 (/home/user/Kernel/v5.19/x86_64/src/drivers
> > /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:884)
> > 
> >  Allocated by task 1:
> >  nfp_cpp_area_alloc_with_name
> > (/home/user/Kernel/v5.19/x86_64/src/drivers
> > /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:303)
> >  nfp_cpp_area_cache_add
> > (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> > /ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:802)
> >  nfp6000_init (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > /netronome/nfp/nfpcore/nfp6000_pcie.c:1230)
> >  nfp_cpp_from_operations
> > (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> > /ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:1215)
> >  nfp_pci_probe (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > /netronome/nfp/nfp_main.c:744)
> > 
> >  Freed by task 1:
> >  kfree (/home/user/Kernel/v5.19/x86_64/src/mm/slub.c:4562)
> >  area_cache_get.constprop.8 (/home/user/Kernel/v5.19/x86_64/src/drivers
> > /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:873)
> >  nfp_cpp_read (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > /netronome/nfp/nfpcore/nfp_cppcore.c:924
> > /home/user/Kernel/v5.19/x86_64
> > /src/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:973)
> >  nfp_cpp_readl (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > /netronome/nfp/nfpcore/nfp_cpplib.c:48)
> > 
> > Signed-off-by: Jialiang Wang <wangjialiang0806@163.com>
> 
> Thanks.
> Reviewed-by: Yinjun Zhang <yinjun.zhang@corigine.com>

Acked-by: Simon Horman <simon.horman@corigine.com>

