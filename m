Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E1368B961
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjBFKGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjBFKFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:05:55 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2095.outbound.protection.outlook.com [40.107.92.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2884C1BEE;
        Mon,  6 Feb 2023 02:05:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aPjGUPb9FE9sacpJlt+bvMJ2XKUZyL0vDcz2ZL8nKkNc4KuiBGbNlXPENVlapV9bhaHl8AimQ6cWj5Yppgjr5njf5j0yt9ZkU+ueZHdNGPANts52YlbG6Z8u5cgGine2IcwvZxjClXNC8ijzNu6zUNBfZUkjTO4AMFwxL1z3oSqbQ19fTdcfs6J614600rToBbR7dBaR+UHhaf+IkJYGzc4PNd+0/c4Wxs1W7Pp7P6RTuzNLj44671TKrpoHc7JuUm1x/GBTDDym/EhIBCIL+ecIHsv2JOpGhCsANF9UuLST7DdU+7Du49d8rgjMCtyDBu0k4VtUaDMVyVtgudlHJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zp2rydhZeCOVNIxQR1nmLnQeQ5xueGkslSrOTIo9X7c=;
 b=a0av7yvtg3sQjO1IEFBMsMT1Lk8SRDLFVei6wNbthMnlqKeMRTEkQuqUN/5Cn48t60tHHU64FFsgE93J8NMJhpMTvXMn7BeGM/GfE+JuyqQf40oRWg9WaZ55KsQ8eqc4t8jiJ/o1z1sgEUWcPFZ1eIjQL7T1J+/aUEiMCUNYRnlub7qbX0dAQRyE9J9aIvkkGUnPOzyAPl19y+KOMvWMTZY4jrq3d10MRV/kAxJD7b8lBZk1s5EQQgFSIIf8yOuRONTjUvNQF6I/gGbJSZXoo6ZonvG+J3Qs6qrLJdKScYI5hF4AhyrL6IERyPkSo/7dNruNVgq0TSkWoRTRV4GXkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zp2rydhZeCOVNIxQR1nmLnQeQ5xueGkslSrOTIo9X7c=;
 b=lofg8kuVOnC+KInmmG180X+fSQua/SuEBS3OzfEAgGwp5ybx3m2pHo9O3B2CMXucoQjEcTpBmiMpgNRvrNr/J2m3ZiGQEoV/RktT50jkqtx4SFE8Z1fnX4skPfC0zUG8Xa7eZBpLa0varBa0KN6tGhSukUOeZ9o9zVb5X1xMqgA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3900.namprd13.prod.outlook.com (2603:10b6:5:24c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 10:04:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 10:04:59 +0000
Date:   Mon, 6 Feb 2023 11:04:52 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Bo Liu <liubo03@inspur.com>
Cc:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] rfkill: Use sysfs_emit() to instead of
 sprintf()
Message-ID: <Y+DQxN9ybYqfozRr@corigine.com>
References: <20230206081641.3193-1-liubo03@inspur.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206081641.3193-1-liubo03@inspur.com>
X-ClientProxiedBy: AS4P190CA0043.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3900:EE_
X-MS-Office365-Filtering-Correlation-Id: 89c439cb-4356-4b1e-b7ec-08db08299af0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RVHDeN0OnkuyrwXLxBYiMRvOPR8KVAYYOZN+cuMBqGA36S3e8QZqY9cSZxGBLxlQVbuGHqQejpzKbPYrUr9I9mhZVXzOtGZC56y1HsAEF9oSUUjAU2dATVEylOvBddeB0posPfnaRc7pufQoAzp287I2pox0c3QnfxCwYN0AYB+VbqecBgdpkutd14GBV+ADZqZpGuxucFnpQiuSIIBrx60uT9/XD7Hect79eSC7A6muZhZaOaPbR+LYxOu55OVTbdSqyZt3qOg0DuNkuEX7rf+nMLztfYxGGpnDA6nhICD3htSNsHvpSc8CvzZAQ/g6rHTY9enRnJO3sJhV9Qm3caFTyQ1N/1MbH6WGVH8B/bjNpg9vgMHmEpBMhVMzJkANdbHsM4OTW9lQ86FokYEpN0bQdes6ZIFjrn73BLP1OQQWbSQeOxpPBDSNJaofvPTZffD+rLFFULPr4UMPwyNIa/zyBYs/VXujzy4H4N+gC3lcl1Duv35JMFgiQ5nceaekulejKZ9b4CjqzL5CcD2p8CEe+fxofBU10o2DdvjCQUyXlyuWmJ186z5BzC+QarJUcLUEdToh3WrMkfT2LYa0lGFPY6hG28aLOiPNxLzB6HdYkSCjifxtQ6F93JC3GXWYugsmFOqoZvt2i/HkKY/0vrBs1l4Pm0ThMHJOEGKK/ZI4TG7bNBl4+s35KK9tayU5vIo5ylQGjsMsKZSfi9zON1z3lmkr+3tD/e9U20qOqtQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(366004)(39830400003)(396003)(451199018)(4744005)(5660300002)(41300700001)(8936002)(2906002)(6916009)(8676002)(66476007)(66556008)(66946007)(83380400001)(4326008)(6506007)(6666004)(36756003)(478600001)(44832011)(186003)(6512007)(966005)(6486002)(38100700002)(86362001)(2616005)(316002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tetVxN9iIxGleSMmZ7nIiYLq0U8vVqX3uSqH/V6lqK2BK/7GEROTXq+kVefY?=
 =?us-ascii?Q?a+Cc35HU7t3bx2k4XcaMMsDn+dz33mtPAh5kW7NXuy+MOPJtvy86JAqB+sLn?=
 =?us-ascii?Q?IMHLZwHJoeqYEjSjIau5hadWHz9NcS5rrUB3mQMRlGYrjf2+EWzMP2o2ZnoA?=
 =?us-ascii?Q?OfIq3f1uM80Q4ITXC8vqcyALyuTiOiZ8aOklNrpKFQDP9wD64m0aFKp/0El9?=
 =?us-ascii?Q?RjmCw0aSZ3s/orjGSf/AI3fVPUn9LsFudZ/YJSzTEQzkUuxkpzGgSOAmXgI9?=
 =?us-ascii?Q?j7YdPvz81GGf4HQ42NtSplKBUhTMLLGiEYblS8+W387Eri8ENd03PMW978tG?=
 =?us-ascii?Q?9IMsUAyBQ4nJUjgCf6o6bGQU31koa6+Jy53HbtiCVnmJK9MinAUCH7ZFD3gV?=
 =?us-ascii?Q?bJUXvMNfRbdIoDmiHY11XXwnwcjWR7oWG9YsU5D63gYSqYJYZo7m709Khmr6?=
 =?us-ascii?Q?rI2gFKc0oaamIv7nrLI1o/kbou8/+ehuMEMqLYCnwx0n7xD7oOdkj16jWLrE?=
 =?us-ascii?Q?WSX1XTI7LnY18PTGRQu783CLC85bCaEXmh7vxDx/wyZz6aEtZL7QzsU5gx55?=
 =?us-ascii?Q?3vAlZ2ROuRfUttW8ItGcsxTAKMkFTEyDaTAwTY/Re7N3YQd9DGxns/C/u/ED?=
 =?us-ascii?Q?QBLKQiP83+KETyBYRADNdHqSdd0t/YBIhAL9BmezQEVgX4na1EtcEuvLKKwA?=
 =?us-ascii?Q?/ASL+i3xpZ6BAJAco/pq48ZsdEG0VgNzcz3fGADxpqw0CzdDg1BL3WsVscpP?=
 =?us-ascii?Q?H3ZyFQZgHV+3KcRIc2m9bWicMj9dKmfPqWhZql1M1OjBsu2NwQKziKiLJNSZ?=
 =?us-ascii?Q?UM4KULzakbiKmmN6ji1GeJcY5UerHKZ0F+pmJxSglRHiP781PYTxzdHC6W4U?=
 =?us-ascii?Q?8vFl9oA18oIkBCAFzF9CMjRoxNhENiB5nnafly3tjjQbEyiykhI3lJPDvsW1?=
 =?us-ascii?Q?FlRwJC//c8U4uAoJQBoSW7uxhciz+st0XDjSPCagSxaM1hh5hfPPiNDKO7m4?=
 =?us-ascii?Q?+LLe0NMUnkkf83Rpz5jQf7MUmn3h+aIXanlFr3qFMPVU280qcq8u2GWwtnKU?=
 =?us-ascii?Q?TCQZ9zWRII8XcwiRCXU2MgLr3YSb1MN7dVJNnZ6HoSvntuB9eqO9IFoh3LFF?=
 =?us-ascii?Q?WO0xbTPwmFBf07gGf6edKVFs5NhoIW/rOepEjY5jq21eRVC1BM8Yn6IC4WNc?=
 =?us-ascii?Q?RvkAgyHxtSSYZ3tY0SS98Ghad84OFOqyNyyqt5IUvaJ6jq+ypLjW5cVdBURc?=
 =?us-ascii?Q?fYoeoxEd+YykwYzkLBmq60ZJdggTjDPSnLHMD0HQ56J2fpJ2Vph4XTuQW6TN?=
 =?us-ascii?Q?YYZ16HhsM3DLiTLJkeAoVwyWrees/vAZ7XYQGD5aArxJQo004tY/oh/49c22?=
 =?us-ascii?Q?k8PG50XM7eXfI4pdo8YHyKPiFXFJvCwxJifuX1iAUk9FPhiV9bTA4oCVbw9Z?=
 =?us-ascii?Q?EHF3zjw8xP3lHWW3dJpooYlyTee5X1JFbCQnNoZCE4bg8dZJ854dyX9BNXX9?=
 =?us-ascii?Q?mqRmyBXlet/ufpW/+8kSSo8FQZ4o2RGH/keoss4nMRXUnQeAiliJ9WADQgB2?=
 =?us-ascii?Q?Qei9QDvQ20Md0t0zBDoqLbOVbjZsAsVJZwTKgz+oPa+ACzwdrR9yDen3d/Ql?=
 =?us-ascii?Q?5oFAeZYGYW/sqzOxsi8HxutfrLiN3UuYaBSweP3K14ZzKG9C6Nm5cpQhkk3U?=
 =?us-ascii?Q?b95nqQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89c439cb-4356-4b1e-b7ec-08db08299af0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 10:04:59.1093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AOOd/RD1uSQeQeCtsPELsn5J+Zfq2f+xmMBtFu4nkeuCtJxf0OpPCy5rg1vkS2Wcdx5PG47gIwLKUpKh9wJAytC3dVgVGMriGflP4LJ8z2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3900
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 03:16:41AM -0500, Bo Liu wrote:
> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the
> value to be returned to user space.
> 
> Signed-off-by: Bo Liu <liubo03@inspur.com>
> ---
>  net/rfkill/core.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

Hi Bo Liu,

A brief summary of changes since v1 should go here.

Comparing v1 and v2 manually, I see that you have addressed the minor
issues raised in the review of v1:
* the checkpatch warning regarding ' )'
* Including target tree, net-next, in subject

Ref: https://lore.kernel.org/netdev/Y91bc2LWMl+DsjcW@corigine.com/

So, FWIIW, I am happy with this patch now.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
