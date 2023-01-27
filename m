Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DADB467E3E0
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 12:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjA0Lnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 06:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbjA0LnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 06:43:07 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20700.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::700])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61BB78AC0
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 03:41:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dpTD1SVxrDvRlmWYiIiIWeX9XYV4wjZ7vREp5GHg1nWLydnpgvR0MxNBgJl+PZ2f68TaeUvmdtlG9bJlF7XRuUFvROSnUgZWJyGlu+RiRdCVFcVZ9emLxyPrqhn5501y5AinpdHNn0vGM/g0b8W93JiiIhgbCVPSqblEbKw3BBE3puTyUpNSXuWDFBNAfURjV4/XBOVdlTd4eb5lN2rk0xZtVOAEO+2PnMAeN2C3cwYl5MN1wVkqq2cAPYfXXnlZ8wN63xyL2VFGe+/yBnGmCLGw5l8yCe2ekag1C4tbqZX8ZkMCf1HlTdpssjceV1G1HJyt+G9BeIUaQiJAPODlRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pl3hqculDReptrJpX0/BB2HDOjflJlV81b3Vu3WoUW0=;
 b=eY4DvHtQq1SPJcOGVPKEQwKYg4pUZhwugZHbjeqamXIB93+jnW/N7vilJCp63cU3zZNyyWxW+MNgn/tj+LvBhtFDwTwNen/s3Ha/g+J4gn2D+M3Iyk38fGniVvi1cgAikbY+n865lTRfpXufJ8/+1HBbaQw+eyktqQB5qgta4PZGhXrgQtbmiQfEAlDNJ2y1Fc+dpvdyGeeQfeBm4eLrWfNnbt0d10b8rPSQmhKiIIii2/swrPzPcv4+HYdp4XP6gB557VbAiqSvBTTWeNOk4ObehIHogHWsuUYDWgc4blpBuvd6rMX9BlHDMxIbGmGhnsa9gx6nwlTu5W+fYogA3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pl3hqculDReptrJpX0/BB2HDOjflJlV81b3Vu3WoUW0=;
 b=bWB13cjqelu1sCyjMR26xjbA6GcSYGgMqfpXvay4VKJrms7PSQWT3zLeYEveAOlzEsf1Mca+nJNy741I3lk5v6C76F2vkbO730uWFTNX80ap4j50b0YakMUW0p500LqNvdbk84h1oljdQki806LFpokscMoNXY4Z+RCgojIzzZ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5688.namprd13.prod.outlook.com (2603:10b6:303:17b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 11:41:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 11:41:13 +0000
Date:   Fri, 27 Jan 2023 12:41:05 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, aelior@marvell.com,
        manishc@marvell.com, jacob.e.keller@intel.com, gal@nvidia.com,
        yinjun.zhang@corigine.com, fei.qin@corigine.com,
        Niklas.Cassel@wdc.com
Subject: Re: [patch net-next v2 09/12] devlink: protect devlink param list by
 instance lock
Message-ID: <Y9O4UUzxI1HAjVq1@corigine.com>
References: <20230126075838.1643665-1-jiri@resnulli.us>
 <20230126075838.1643665-10-jiri@resnulli.us>
 <Y9O2PHu7LDljh7sr@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9O2PHu7LDljh7sr@corigine.com>
X-ClientProxiedBy: AM0PR03CA0042.eurprd03.prod.outlook.com (2603:10a6:208::19)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5688:EE_
X-MS-Office365-Filtering-Correlation-Id: d6a2fa5e-bc1b-4fd4-2d42-08db005b64ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kfbaYcvvxp/Aji/myYv4BGtdM+UqbgLlBmFFa73Lv9RY2xfumVXm0k827uRRRaFzBWurfxNtiRnzHbxRfVvOENm/zuy7ndFftLy3aySMT2NroxhSI/htnZL+rVYI6s4uc4NwzTUXByN3aqO+4qjVn2SZSL/wl3tloj3hCt7mcfkvE1yTbwX0ymJ6lztsRhuckfI4I1M2rTEQIk0+vJfBkGOSUv3MyrlzUKT7C6XGWznw84kWEWxnIRtezXnp33LJbThKwZYMme34uVZ8BfgrrH45ZQ92uVkfRrRjv7bW72dFFSsPuOcW/DBFUxVwsG2XsAub7M0VYGPmOlzAsfp/9jzo1V9obFFBIH13DJQqzcJ88fkD4PBcA1r14JTZ7UlBLEzCxqLALNrJT7ccQG1X9yBWsYekW8PejGQ+gA4T2FzuhaMxf9AOj2ApO15rYpK01WCVjLn0U5oysNFOsSbVoUIPAZwQ59JJMAIvDdFAfQ9AeIJFe/Nd2yQ8M+Z/QBrKa+aln6CpupEpqhqnB6NBWD7D24hpIhQW1RDr9scvFYP7zZw39ElIWL3w2NZQsbAc2z48v8HUKCsZpMykksGq+06BPWdPquMBPqUDvtO7vMe+pnYMCMC++fHHh4yU8Pg1yJZrz9ASs4od5p9iJb4NdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(366004)(376002)(396003)(346002)(136003)(451199018)(38100700002)(86362001)(6506007)(36756003)(66556008)(8936002)(6916009)(41300700001)(4326008)(66946007)(316002)(8676002)(66476007)(5660300002)(44832011)(83380400001)(2906002)(2616005)(6486002)(478600001)(7416002)(186003)(6512007)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a8p6R3YaCAceAfMe/oxH/LWxNNX18Mt2NoAkm+27AB4G723/UPjlusmfK8uE?=
 =?us-ascii?Q?tCsbe2STZJUh1r/GODPHZ9hCJ93oU4kOdjw5vRkOSCXlwsMkvTKxx5s6Ma/x?=
 =?us-ascii?Q?EnaAKDqlKNupHo352jlM0m0+oGhib1CH6KnLLto0o6w24RmTR++VrK3dy6Zt?=
 =?us-ascii?Q?UCVPiVgS2sdf5qjkAZ6OnF6IqMzPW2/n/ksr0uXCCORUxRFg368e9X/2XC0b?=
 =?us-ascii?Q?0Y49Fk27ukOS2QZypmFgRW6H/dB2VA55Hk1iox+BdVP+6+1d+jwg4OyP5ZIN?=
 =?us-ascii?Q?IGkh0H0754lyTQspph6kipKIjW/it1XEIiMx2mexnpb1T3W4JEhLrWNBqOOE?=
 =?us-ascii?Q?2K1Mq7BsyNF+YhlBVaGa7RsaCmGn7RUR1VEd5cajywTDJTpeOIO9gfXHzHjn?=
 =?us-ascii?Q?daT7ZUew57aFRqtN9XAZmwNz9FpmSg0ZnEaLUTxspsVMP5h5i2upn8fyIoug?=
 =?us-ascii?Q?PqRYCuBSTGYBVtGMH8CkMQ/mRWNnAnfbFkOC3+Jrgu0YRVGsWmIhIXtjWcTZ?=
 =?us-ascii?Q?dZkWe4ibd+z/Sntaj08ZEYCgWivxVt7ZIeC+gnKqL3skv3KTuPtg+0uONoEP?=
 =?us-ascii?Q?dCWo+JkBVxYBrTpbypbOhl/plCiN3vrgF4A3P0YSxNGUl+4ed0tlMdKrntcn?=
 =?us-ascii?Q?5LrQJLosfZd+aUXZKQOyHBEELv2VpvHbK4lVWi2ueRaSVNltJ8L/kbi7Qh2X?=
 =?us-ascii?Q?3IHaN+8WVY2uhZmYKmISdoWEmPohSG1XxvjrgcfWZ+T3BZJWOR4+hsLfI3J2?=
 =?us-ascii?Q?8tITFXmu7VloHDgzO1xZ/KzWIhEd7vLaLReksmlR7LhHwUwz12mb2a5m/Pho?=
 =?us-ascii?Q?zNNnGWpcC+qWZYeUE7WK7n6s+9CKNIakfF5kL5pzbZ+4vJQjF6w3541cuyHY?=
 =?us-ascii?Q?olMcjdABV+D8WS0VMb+kmf513RVptgkBOAGh5IOQZiK9Hy6EUgtt68FECqEU?=
 =?us-ascii?Q?svXy2C0cM4PfzrOsYAUQRQb7zMJ1XxfZFo7j5W3pOOSBIJos0SZc7GwNa0BC?=
 =?us-ascii?Q?o6QBudDXdMu5J/OHFvl9f5/y+2olTM9Is33ETony8iPZuDxVDooAb/sGjTOZ?=
 =?us-ascii?Q?Um+inpEGY15DApX3TomSC8z4A+p6s5Vj30cAK3V68FWGyH8iFHeRT4aR/Fp3?=
 =?us-ascii?Q?elYVldgg3RNQ1SMp8x6rpI9TIh22lMRurDgGFCdhX8jBDssd0D7V8pfDOlRD?=
 =?us-ascii?Q?wzI9VY1JiFSiuJHTbDSiZbqo3IoKPKSyc+0vizGc3U845z8VlrpxRYulR0HS?=
 =?us-ascii?Q?go7slBx6kwgKPrD8J7s0JtwU2LLDVDHvFaqluB3TCAuAKcI7kH1rixycZdhn?=
 =?us-ascii?Q?LA+M5Oe9GLslO2PBG3DZag86wgHPDJKUFc0QjTZ1npXWi6bcjVJ+kkNUB/gz?=
 =?us-ascii?Q?c1ce5UOnAFBlDXMYtA1c8LAYkiheZQOnUoD+DeUc0cRpltDbdzy9Zi9zE+6K?=
 =?us-ascii?Q?tpnt2lsl3Lxv1WmmvPSL3VbOahXla25rHHCyEIKVdHpLHxcta80W6nWkKSKa?=
 =?us-ascii?Q?MAQ4BGyLtYXplAuNmfPJF1DIMhBLli2YmeGzqzwIB6H8sjdBp7e3WqGPyxNY?=
 =?us-ascii?Q?PeXCu7xfVkBWtQdAgVmpzJXW7RUoOOd8kf9ns0jVPQ0X5HthujoUsbB86JP3?=
 =?us-ascii?Q?/w4fBakr4DjH1f7bMHB9zB213Ro+W/aYGOFc6cqzxXQTecKc1zvhmVXFv63z?=
 =?us-ascii?Q?4NRQrA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6a2fa5e-bc1b-4fd4-2d42-08db005b64ba
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:41:13.7191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f7i9iHOwlJvIseOM8HSZJsdHkIU1HHMpPpOBhjMJz7xRjhmErrmZxHmtATkdkW5bS+SWdF71AsfSupq81hREy/X77qreOvmYLwEwo3j6nsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5688
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 12:32:21PM +0100, Simon Horman wrote:
> On Thu, Jan 26, 2023 at 08:58:35AM +0100, Jiri Pirko wrote:
> > From: Jiri Pirko <jiri@nvidia.com>
> > 
> > Commit 1d18bb1a4ddd ("devlink: allow registering parameters after
> > the instance") as the subject implies introduced possibility to register
> > devlink params even for already registered devlink instance. This is a
> > bit problematic, as the consistency or params list was originally
> > secured by the fact it is static during devlink lifetime. So in order to
> > protect the params list, take devlink instance lock during the params
> > operations. Introduce unlocked function variants and use them in drivers
> > in locked context. Put lock assertions to appropriate places.
> > 
> > Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> > Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> > Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx4/main.c     | 80 ++++++++--------
> >  drivers/net/ethernet/mellanox/mlx5/core/dev.c | 18 ++--
> >  .../net/ethernet/mellanox/mlx5/core/devlink.c | 92 +++++++++----------
> >  drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 12 +--
> >  .../net/ethernet/mellanox/mlx5/core/eswitch.c |  6 +-
> >  .../net/ethernet/mellanox/mlx5/core/main.c    | 12 +--
> >  drivers/net/ethernet/mellanox/mlxsw/core.c    | 18 ++--
> >  .../net/ethernet/mellanox/mlxsw/spectrum.c    | 16 ++--
> >  .../ethernet/netronome/nfp/devlink_param.c    |  8 +-
> >  .../net/ethernet/netronome/nfp/nfp_net_main.c |  7 +-
> >  drivers/net/netdevsim/dev.c                   | 36 ++++----
> >  include/net/devlink.h                         | 16 +++-
> >  net/devlink/leftover.c                        | 77 +++++++++++-----
> >  13 files changed, 218 insertions(+), 180 deletions(-)
> 
> For the nfp portion:
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> I will also see about getting the patchset tested on NFP hardware.

Seems the team was a bit further ahead on the testing than I thought.
So, on their behalf:

Tested-by: Simon Horman <simon.horman@corigine.com>

