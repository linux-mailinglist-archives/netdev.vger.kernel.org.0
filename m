Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1794F22CE26
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 20:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgGXSsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 14:48:47 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:8864 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbgGXSsr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 14:48:47 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f1b2d0c0000>; Sat, 25 Jul 2020 02:48:44 +0800
Received: from HKMAIL102.nvidia.com ([10.18.16.11])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Fri, 24 Jul 2020 11:48:44 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Fri, 24 Jul 2020 11:48:44 -0700
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 24 Jul
 2020 18:48:36 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 24 Jul 2020 18:48:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/GvXuxKfGsJEnNCuRDNQ0wmyi/WETxOWJnLbS1pqb2YtyWqToebWy9gKvYVeJfYkewfviPYMrHehKAgcXjvX7GbtAjWb9Ewgiq6fBq9ztzj55wi/SmX1PkSWrLyDejOEv8Vo8kgu0luDW4+4+ZkRYv9fNeYRNzqN62tprz619HpGA8EIInY+esC6LnDMbEyVCsxmsYYkbcfHsc21Q1Bruk7Qa8NMMCOzxrOibm0qIB6ZBvogA7fKsqmo+vh43CWSfjq+gYwiXc5VILLlqDVGPxQnGWxSdUSNw7gRphk45Gi+r4kITujj1vLShEbHw4L3yECoRueKjNoe6Sg0aw1LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRnE2CmFE0/TnwIjm5WhGFCCyTECyaCwmfx5qoRaH+s=;
 b=nH24xsqmOyBTeFGvLWFPB+5/kpB+Ln3pVLq8P70vFST7viHP/imdSuoWAZmmEChEFThl9INuXq/MjBJOhKBSgiUGxX0IKQgdg46suQdiS2FN+W0D7r+/VBw6CzTjfB233RvkEO+XfFP3yDphtYi0yUqJBZmWOo7TkLcqQby06XWAZRvfu8Ix7yeuq8vETvqr8W23Coh7p5/ZKe5+KO20g3bVBoP82Sr6+0vjj7M9l6JWRS7b5NiOFcfoAXtrIJ1PIXbabGmLlDdyb9RtgcbhSRCo5mHqMYeVwFR426MvyxdmtC4obOSyulxHNMblhprjYJwOjI8NSjxDYDWwr48elQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1833.namprd12.prod.outlook.com (2603:10b6:3:111::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.26; Fri, 24 Jul
 2020 18:48:34 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76%3]) with mapi id 15.20.3216.024; Fri, 24 Jul 2020
 18:48:34 +0000
Date:   Fri, 24 Jul 2020 15:48:32 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        <linux-rdma@vger.kernel.org>, Meir Lichtinger <meirl@mellanox.com>,
        "Michael Guralnik" <michaelgur@mellanox.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH rdma-next 0/3] Create UMR with relaxed ordering
Message-ID: <20200724184832.GA3642406@nvidia.com>
References: <20200716105248.1423452-1-leon@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200716105248.1423452-1-leon@kernel.org>
X-ClientProxiedBy: MN2PR20CA0006.namprd20.prod.outlook.com
 (2603:10b6:208:e8::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR20CA0006.namprd20.prod.outlook.com (2603:10b6:208:e8::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Fri, 24 Jul 2020 18:48:33 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1jz2kC-00FHau-5g; Fri, 24 Jul 2020 15:48:32 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d804ab9e-e591-4452-2051-08d830022a4e
X-MS-TrafficTypeDiagnostic: DM5PR12MB1833:
X-Microsoft-Antispam-PRVS: <DM5PR12MB183327637DEBE86C964356F7C2770@DM5PR12MB1833.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vp71Rs38nBcwvjLJ2x8KtQYR/7OYqF5qX7KWETbmXt06eA7WFIZ5/b5C4xw6Bj9ygGrkXK34bdihNyQfZ8O8/Qi9rjD8VSYK7SPw9UtCWOFgp3fNOx27CBbuBoqfT4ab5NvmZbdGeGiZxFh42IESVEZ7OVnnavfWoyl3d4eLJaBAzQ0uP/7M8orVvM9PNABhcv9pfsIGqdZq35+JFprEeRYLZ4ItgeC2roWYtIyh5d2XD6xSYv/FPizoSSl0e54vsG9+RE7tiwwazH0QLQ1tROy5AbrZFjblfrljsXKAyME5ZgLftgCSDjU4kZv14UN3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(5660300002)(316002)(33656002)(66556008)(66476007)(54906003)(478600001)(9786002)(9746002)(1076003)(36756003)(83380400001)(26005)(4744005)(2616005)(86362001)(4326008)(66946007)(186003)(8676002)(6916009)(8936002)(426003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FNphXRZrd9pKkAMFGvIlw5gh/JOEY4FcLz5SUMj6qaULlH01uuqpD0m9ZPnVy/CgGzWAqq+4nWltRxvzMsMmX/4XXjxzAloEPZ5ybeG7JjgNjWIAIH6B071pXqkGmETcvIE/H/N6rl4D+imM3fDnVLt98sGEzMu7WwLv6yIM9JdxKfiZbV8GaknerM1RTFLMLVgL9fAnJaVYpWiKnZtTkE8/RQiPJolZuOCjPWgmUV+kDbfKPGNlNAWZljSr021aiZIBFsQQNrBMhZ8d3BybJIsl0J+WBG90cl9lcqvd30yctpHA/aZU1TuhMVNrpRL84fnSErIZN7XkOlMBgsfw4hSC3fkv7MVKTHpuHnpLBq4d83vjgOSGbspOhX7Qd66T0/HmKKAbs5dc+8gKRWgttCfdyXpktg7YvZcXgtxsUUuef44TufM4VJVKX7o6ytsFyaJHatWXnjzQ9KaCX5JVWkOQatRJisjOIrBh9YDCth4=
X-MS-Exchange-CrossTenant-Network-Message-Id: d804ab9e-e591-4452-2051-08d830022a4e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2020 18:48:34.0740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dU39wKp3SQPT3iM+k273Yvrz9ctwjyPbXz5wtPBllGMs+gYLGVNze+/m+kaob0B/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1833
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1595616524; bh=aRnE2CmFE0/TnwIjm5WhGFCCyTECyaCwmfx5qoRaH+s=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=f122oJr/xbMfa7RTrvbsI7oa45H3Gj5F3hKNpBrOnxGeq9lOfRpq5ZG3TmAtaJpLv
         +ciaSk6+BitdD/+3wnBdOP3VYn48AkCEpVyTMuFlskQN5JTl/Q6tDvGbBfx8ntHtot
         5owRn1uA4Q11ms7gh7hxnNJ+NuAiVWgj9xnm/1tIzo5JhHr3oPVDfMM363pO+XKDOL
         uY20wngXoH5IFrcF/ktdbOLRHGR33xvJ0+Z9tNq5p9grpZUqxkyYsmq4pvR6O55kXq
         j/pNUOEPb7Kd8hgYFvp8VmdKe6nF8O0/Mex+fA0i+MTz6Fu6dwzU1UHMauZ+YZ9JWU
         LtvIbC4VHxDGQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 01:52:45PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi,
> 
> ConnectX-7 supports setting relaxed ordering read/write mkey attribute by UMR,
> indicated by new HCA capabilities, so extend mlx5_ib driver to configure
> UMR control segment based on those capabilities.
> 
> Thanks
> 
> Meir Lichtinger (3):
>   RDMA/mlx5: ConnectX-7 new capabilities to set relaxed ordering by UMR
>   RDMA/mlx5: Use MLX5_SET macro instead of local structure
>   RDMA/mlx5: Set mkey relaxed ordering by UMR with ConnectX-7

These look OK, can you apply the first patch to the shared branch
please?

Jason
