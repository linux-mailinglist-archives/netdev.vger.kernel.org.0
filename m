Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C7C2D6979
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 22:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404637AbgLJVJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 16:09:01 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:24097 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730214AbgLJVJB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 16:09:01 -0500
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd28e420000>; Fri, 11 Dec 2020 05:08:18 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 10 Dec
 2020 21:08:17 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 10 Dec 2020 21:08:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPKcguxc4qZEmqi2ooojh5jfbY0pv7mji6bYzcOxLIsrifG4Y1Dsm9i2Xr2ESP9qu0wcNC5OkFwO1TLsbLBCRzb706IwIzD2UDunFHb3oCVNWhZDx9wYWUlYDZKFAJV0nGq7TDoo8/B4QbvxMtFbm2WMzNocMYxiQBi3PY0IniIMat8ZG5R+4AaHVontfmgZpYJbmA1fd8vpiqPsp+Q4RFPXRxAyDl994fpvpfndCwtgwQinuBGBcIerxuK59bVBbI2/jZdSnqfTWH8NuFHdwH10O/ftOG7PVwqy9G6CjaZXuyyPBZtpYFnLOjkhIy+G0geGpXV+G3BoRk6+LrVcEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OOKFQErysvoX13N4rm5tbwbTbzAzlUzzMIF7kbg3Fx0=;
 b=Rb5MGCRAMPOv85M3TXZLCtYvLSQo4o161y1SzWm4XqIsA26kpLSviN/sMCZdbh73N/80noGSK1BBydg2gkRdAlyE08sKm2zmpF/bfdkglvRoXkFcExVSe1Ych8xUCTtx6+b399gPF53BhTr4LFQP2VSYXA+cIJ5eSMcJHOAoBrjz/5Q5qEExoKHd2HMG0hSfL4mfxHkndB1IuKvuwIe58ksaeLNCfqS5yfceuq1KLlt2Vs4AIYvHKzHcc88f56cp1bQGo42A9EUyf5+879VOyPFJqCLBZievHV0gi0u9us775ZOMr/bipkTXvNLKiFouVQP+AXIzx41zQGLflNjBVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4402.namprd12.prod.outlook.com (2603:10b6:5:2a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 21:08:15 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433%3]) with mapi id 15.20.3632.023; Thu, 10 Dec 2020
 21:08:14 +0000
Date:   Thu, 10 Dec 2020 17:08:13 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH rdma-next] RDMA/mlx4: remove bogus dev_base_lock usage
Message-ID: <20201210210813.GA2143210@nvidia.com>
References: <20201208193928.1500893-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201208193928.1500893-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: BL1PR13CA0064.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::9) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0064.namprd13.prod.outlook.com (2603:10b6:208:2b8::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.7 via Frontend Transport; Thu, 10 Dec 2020 21:08:14 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1knTAb-008zYb-4f; Thu, 10 Dec 2020 17:08:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607634498; bh=OOKFQErysvoX13N4rm5tbwbTbzAzlUzzMIF7kbg3Fx0=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=hxyoZDyg9lgkHi5QkvtRCPRbhwtF4DoTFI4YmumnDt6c1yLsyHMHuYLxqJ/z9Ljtx
         docSkQuXkut97yhaGkWTU+UIwLMwPRG7Gvl/su8zMN8AIe6hjj9HITj7h87GD/lUk2
         lUgOOh6yYRPqwdL9dmNNojlITvfcCTPjkgZNGiM7QbeCcQECmlbE9Zj2VKcAUtuwWQ
         aTEPPITgjmPpxdfii4/nNEL6zFYGtbPxA/GHuL0bODNoG4uYXxqg329v4sF0FVy5g/
         uMsdMf7li+40C9DP7JVjmK44s+pCw8wkra2HCV8koQYj2lJw7pf7DTN1QVsQEL3szt
         UzcoTvY4V1eEA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 09:39:28PM +0200, Vladimir Oltean wrote:
> It is not clear what this lock protects. If the authors wanted to ensure
> that "dev" does not disappear, that is impossible, given the following
> code path:
> 
> mlx4_ib_netdev_event (under RTNL mutex)
> -> mlx4_ib_scan_netdevs
>    -> mlx4_ib_update_qps
> 
> Also, the dev_base_lock does not protect dev->dev_addr either.
> 
> So it serves no purpose here. Remove it.
> 
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/infiniband/hw/mlx4/main.c | 3 ---
>  1 file changed, 3 deletions(-)

Applied to for-next, thanks

Jason
