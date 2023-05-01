Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778AB6F3126
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 14:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbjEAMpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 08:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbjEAMpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 08:45:33 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2114.outbound.protection.outlook.com [40.107.92.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B83E2117;
        Mon,  1 May 2023 05:45:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCSk9L06xoIDbJxGE8039hovwGcWShmfSBD6AOCPCwPHzBlMQad5bnvMZE7vMGtwZ1sCK4VbWwQLsJvtSu9B6k1WePNB3OuuRCiJ3WcbmPQMRDTAtnG5+f1lhuxCQ8Ok8lesQSylDVnlERKOa+VoiPibO1h67p9xfjAlbiRMN/jLUt4Fv7c+cWdpzt+nVZRdtXk3wJ+Qlnaa3Cu85YB+it6B+VLvv+2NmFJzNND0TBRQO//eJkboJZrGocSO2dExPT5NmCeAJKRoKc/qzPzVUnfp2rz/anozARbXiyXG3MpbSyaeoIuk/AZ7ZwrbrIdv8Pt6HDW2AMngBXtmcFxP4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k8uQQohNhd3d9T68OA/Zvt9KhTK8cQGDGcWArdS/faw=;
 b=hsJR6YerxWfAYV5C8faRwo6eIgg2/t9p5MPMOoFiVoycmhivtt+QqYAupIiYh7rbRNaD9L1TVb/f0NSL8ZM4lVlawaFNZP4el3HmXv972pZDwUknsD789O4mrLKErOiOQb2AWdetVHnJNBJAfScN2j1wTCNzyqqrjf9Fo4nF1JqhuoBoLmn3VUZuaUTBrdstZjpOtBQKtsnNA3l7J/6Y1D61laBqC6SJSwFfcjAdfZ3ZTQk4HhSeq16BjZx7fHRUeMzo9rGlM36FZvmW1v3BklsCJiTnVtkX5oRJNziLHj+t+CCJdP+irCQ03pYphv4Wg4SY/DMe+7Ao01ZNIsfy8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8uQQohNhd3d9T68OA/Zvt9KhTK8cQGDGcWArdS/faw=;
 b=OkawHIZKawo4SxUfVPb+OxynmgPrfqbc3MW3NFj5MH2LZHTG+ZY+bLOekOrrDyuiadoW9qe/Q4X/ajjs9F9IbqdrZoBGpASPGlMWEsWsZfSca5/VxzQcRq1REt3DFW1ukCsFLcHPCQ+JN7oYFyB5aMOEgcksiwk/LcVdrVXC7Jo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5001.namprd13.prod.outlook.com (2603:10b6:510:98::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 12:45:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 12:45:01 +0000
Date:   Mon, 1 May 2023 14:44:54 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Feng Liu <feliu@nvidia.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        William Tu <witu@nvidia.com>, Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH net v1 2/2] virtio_net: Close queue pairs using helper
 function
Message-ID: <ZE+0RsBYDTgnauOX@corigine.com>
References: <20230428224346.68211-1-feliu@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428224346.68211-1-feliu@nvidia.com>
X-ClientProxiedBy: AM0PR06CA0080.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5001:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c0a28f9-0f5b-4108-7f42-08db4a41e0fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aJCFU0xiTbPRsXQnpEPNEueF+T0FfNXsi+atzW6gJmw6pKp4ovm+79ZGm0hdnU2xW0j4c3+iLz7Zl9r7DCr2q8nRZSRQD78Tin/KyQCotYkCH8FzI/ZJCukbAJcH9XxldCmLFL6Qh8+7sMn01FhhPrEeAgQavWTaI1j1pqvbzHInsJxL9hURGSSMACVR0lvr9DC+oGPJY3LfyFYGbDUvAbea+LX5bhAb0DGLYUV1p6HpCLZiYiW//iEdXVmqZk0AjH2/X7tnW55Ch3lXgedXwUXGAqo780Qy0wwNZYvGJ10oFpyCqVRPTq67l7oO0QqxTG2goOAOUIK5O04hv2a6FUh0fz5A8d1+ej0/gtK8NRue0/yQSo622UFzDOpnXg2vn6M7Sxpb8rfZ+SPvVqzETr1dItzSHnrz5tsLtwEzPqzaDxp9mjIk/EHC+QLC2rfEm6O/ix1ttMBQ92W7FOT8nb+xb8pqjRnl1Nm25BJXLtiAIeMmXlJCYBXb0IoVi0SpcAa+gFmHjbEwPeF2YSbfJ/v3K1Svn7tWP0Lyk98TxAPpLKCHttSgbNe+Yp2FvMkVBq/FNTWoRFIhFAmLZ0+3ngrIaNSqDXOeHHVb0je9seendty9eAH5mZbujmwYU6mi+vIpTRF6MbHXWMAnp2asvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(136003)(39830400003)(366004)(451199021)(186003)(6512007)(6506007)(7416002)(44832011)(8936002)(8676002)(5660300002)(2616005)(36756003)(54906003)(478600001)(316002)(6916009)(4326008)(66476007)(66946007)(66556008)(86362001)(41300700001)(6666004)(6486002)(38100700002)(2906002)(4744005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hdvQIZKyQ+hcc8wTwfFqTNr2p0dJ2OHIUv8emxKE17ek7OcqbDlYuj35RBFr?=
 =?us-ascii?Q?WTIO7R//sN/FsbeGutU/Rw5dS6WQpP0Z7pqyes98kYDpw3znW/l0fumJ0OSl?=
 =?us-ascii?Q?93fjOvoUYS8TDuDPZnzZHtPwzEakX5aS/wG1eeTIffo1UA9uW/+Ji06qrjfY?=
 =?us-ascii?Q?sdqQHzyAZgn67CaVOS1b9dGask7LFLY6g3lmPGXBpjEjYH09KsCuIIR7Kmg0?=
 =?us-ascii?Q?L0F8rPHLtOJHERweSG2fk/d50T4ZuMe1gHSHLhp4ZSoTUW0CdHtGXEUL+Leq?=
 =?us-ascii?Q?j7ql4rwiHN1WSV041XbogiTWMZYo+Q2NElxcsB9/9lZzdD8lnH1lq0ZhvNHK?=
 =?us-ascii?Q?be9CFd7a07HuKed/sS7WgaA9bcznnnF7xhKTa0ALK7SeOguvqQOc1WO1YMoK?=
 =?us-ascii?Q?3P5LrGQgCS8NkywOmNYwgNhZYCUiag2/CenJz4iWprohd75xOxyXaO9NLLXx?=
 =?us-ascii?Q?zFg/uaiKjtJofd1ZzbD6W70E2YWoGE84snkQAAUlBS/7NhQHxZ4jFkEW/nF5?=
 =?us-ascii?Q?kib2cbtmfoN/73GGOfufCqm5T5ceh1ou+YvlkmNaWyMvAogpXQ1Dwm3T1U+j?=
 =?us-ascii?Q?K5gfZcIlZidyUb78pp/9sV7nidDlzmKu1QDpB7L3+WexEDMq7W1ZIpXWiU45?=
 =?us-ascii?Q?1Twm1wSQ/lMQMaWaE5GLBn4U8/SbRtuDEyIXXsACv3FDKNA58S0Jzvjl4wPW?=
 =?us-ascii?Q?qAH7LXlu+qEfyEliN1sHnAh7m7x6gvzJKOnMAbS0nYwSPGV9z4GO9Ejjr2ws?=
 =?us-ascii?Q?9cNVC5m6j5CYp17GQEvt37XUbFNnRagdRNlFEUBFUaWLnRz+VI3o2Xk01Awm?=
 =?us-ascii?Q?LkOX5Ln4jYzTzJvgLsMke07+tMGzNdPYsos2Q5HbSenu2xIjxd88GPyCytkt?=
 =?us-ascii?Q?Y5tXL/40tggewZi7jM6ISbu/OgbU4Nyj0UpFuTCJfMqKBncYokectgrLzUR8?=
 =?us-ascii?Q?qkMl+PpdhL5tjw/aVoTwcrPFZXrLQ9pNKVeRfdZuTWIWpnd8dQ9WMLSDM+NV?=
 =?us-ascii?Q?0SH8avjQKJ5cCVvRkkBSWjm0L0z9uziMC/h8xIgF0adPvtkPr7wPGR58jYOa?=
 =?us-ascii?Q?gKZZ/WFMUbHvtgGHbSowDrTMwz3baJ5sZj85orhVmWKUkuUUIYmiIwXTAld4?=
 =?us-ascii?Q?2K4jep+gA/U3J9WXgYi1BLvsoPXqaqC82bhyeOWqThMfIlaaCjU5nky9CReX?=
 =?us-ascii?Q?Z1IWhWwMUex3wEZrRfQhThSjj6C1OFB/9UsBFfsCRZodduZRwl2e6S4bg6l0?=
 =?us-ascii?Q?wtrJQpJVUW9C9p3ZlZ9E14a9StETqtaL3wWeBbaxXOC0vKdFsBjxZbuuO7Kw?=
 =?us-ascii?Q?HzT98jhXyAN6Ojt4UlBpN5uEL3KXne5/fZx9JIjgjKhxiMFar435H9dVkkf1?=
 =?us-ascii?Q?yVT2j9+U4aK1RcVfhDkeAUJJpnW/h1h7P6CWpgy1a8iA6HPSRgGV/vWK/rt9?=
 =?us-ascii?Q?8ZRJSUpXHf1/1RbMqeq7kdH+bQoAcmDrvfBp80Vemjzdwh0b5+mYgroJK0vr?=
 =?us-ascii?Q?No2Dhz8Na8wlzz3MRDgToqM3khqTSYJCOWVunLFUDI7PrjsGAe2qFALiUh1i?=
 =?us-ascii?Q?95lcV/StsA73E9kZfsByk6OS36GptnTO4lNMq+OViH/krdqVLIJySOunkMBj?=
 =?us-ascii?Q?lK3t9FSzAnxSI2AGlkNlwYYOuEC7l/ZlNJMoTj/Mpxv1GEoGAzuzW8MLYOOT?=
 =?us-ascii?Q?U8TPFA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c0a28f9-0f5b-4108-7f42-08db4a41e0fc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 12:45:01.2521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n4S0M4DuszbqDF9aFqGhI4blmFHW+Rhfuzt/QPNua/ByrnkZj/r/Y4GRTiiC+2j9Vwbx/jSgg1A+XJkODa5dlMD3hL/lI58VVwRe52l0zH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5001
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 06:43:46PM -0400, Feng Liu wrote:
> Use newly introduced helper function that exactly does the same of
> closing the queue pairs.
> 
> Signed-off-by: Feng Liu <feliu@nvidia.com>
> Reviewed-by: William Tu <witu@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>

I guess this was put in a separate patch to 1/2, as it's more
net-next material, as opposed to 1/2 which seems to be net material.
FWIIW, I'd lean to putting 1/2 in net. And holding this one for net-next.

That aside, this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
