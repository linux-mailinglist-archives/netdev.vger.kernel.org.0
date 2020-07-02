Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4739212BB2
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgGBRz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:55:59 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:23504 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727926AbgGBRz6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 13:55:58 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5efe1fab0000>; Fri, 03 Jul 2020 01:55:55 +0800
Received: from HKMAIL101.nvidia.com ([10.18.16.10])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Thu, 02 Jul 2020 10:55:55 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Thu, 02 Jul 2020 10:55:55 -0700
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 2 Jul
 2020 17:55:49 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 2 Jul 2020 17:55:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bwlM2DdnrWvjWUNkTQb+nllTVYwytF/GiVwTOCpv+xpmz7TD5hlx7K7byJzjHUBCtPcimnP8n9lq6cjE7bwVwrSQxwhqPjLuZNYMhWKlLpvoT1Jovw+ddNW2Axv9sausgAvsyobxQdZ5/Ndm68pXXRBbP9EhFvfj4loGFOqPiMPcMD1v63zb5DaSiS/P4HwxVqnRfsfAxL3WPbY7jMCk0o734DbR5WSDH4RpV457PenPxBTLecfsd4gnqoYTUTFULprbhIvmm81XzrLTIiuHoHCudZIivGGMpGtTl8FE8ZbPGXjZ5Edo4s+ueHiiuzH8IBNzTMXVJhRtd/G4+0zC7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLdty6+1PaFhDOHr88QPFMT0duOhgCnqv053BtULfE0=;
 b=hjbWjOoVnUwiSmWfZ9MBzYk6dSK+TE2+YlPQgZyn/UIMUZdgAnKiUaaFTUVDbysVd1l+/BuhUqMHvY7QL9+hylgivU02sT1pHtxWAuJJ/J833cgf3Lk9CVWNVOjirjoHa+m55k+JXxXWKvXY2kEaiF18mXM+cVuSWWmvt4WLfPfodlKsj1aUphGkRwaoixLegnLb78biM6uJumu+9xPRaNH8f60rFIQdq9QdrxLDnqQJ+KWvYwwVpS60ZjZdy63vRt8GyNNRO+uJdEV/cWcqueLSKe+8+bPZL2yYoKz4uxWYHPrOkW4nckil9P5+/KynXxLAwFldPpBdAso5JiHSbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2601.namprd12.prod.outlook.com (2603:10b6:5:45::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Thu, 2 Jul
 2020 17:55:47 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54%6]) with mapi id 15.20.3153.027; Thu, 2 Jul 2020
 17:55:47 +0000
Date:   Thu, 2 Jul 2020 14:55:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>, <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH rdma-next 0/2] Create IPoIB QP with specific QP number
Message-ID: <20200702175541.GA721759@nvidia.com>
References: <20200623110105.1225750-1-leon@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200623110105.1225750-1-leon@kernel.org>
X-ClientProxiedBy: BL0PR01CA0014.prod.exchangelabs.com (2603:10b6:208:71::27)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (193.47.165.251) by BL0PR01CA0014.prod.exchangelabs.com (2603:10b6:208:71::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Thu, 2 Jul 2020 17:55:46 +0000
Received: from jgg by mlx with local (Exim 4.93)        (envelope-from <jgg@nvidia.com>)        id 1jr3Qz-0031lv-Pl; Thu, 02 Jul 2020 14:55:41 -0300
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 817d9e7f-0c72-4742-a7c5-08d81eb125fa
X-MS-TrafficTypeDiagnostic: DM6PR12MB2601:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2601F508CD9711262EFCA303C26D0@DM6PR12MB2601.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PZAPD0WCQTrbtHCe1rQcE2nM178cb2AOy+w/1bJo26HFoXCdUenwScGhGRTMId64UkqpzfVTzkuA5Udb7AIjPTItfRQZ1kd0U4KB4CJP4qNOTwCccIP/WYhUODlfrSJQMtRA3rviNvqi6J7gi5iNwcKhAzlMbf7vlDsKlojU6/5TqmncVCwIkyQf1JaU82p614gMAsXgyIl+c1ymgXityoCA0NpMj0dOWOLaht8eTLkxMUmu5FjuRvrqvHRs9K8ldyE73iX5dr6GdLj/7ot8foQMe202ddXIrty0dGzxRx76P6KTrNYsmolA0nYeZbudtfmklA9PeR31ls55nA3nJGAQqousB0NGaV0uc8lGfU2jM4PAnhC9G6+PGNIhCpLE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(1076003)(26005)(186003)(66476007)(66556008)(66946007)(54906003)(316002)(36756003)(83380400001)(86362001)(33656002)(4326008)(2906002)(5660300002)(478600001)(6916009)(8936002)(8676002)(9746002)(9786002)(2616005)(426003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qRnsV9twRvJ2I36PggS6XCEFQoIJPROx64py9vY7BumIpISWq9iU2AdkhvIW1kGAVaDDgnI0qc6/3fvMeQZaEtuA7vMK8iXBjjH6fE/4a+IkHIK09oJ4QiZsSVbrH7L35rElO85llZJhBh4iiS1XH7itikZUSkTxXS03Am6vXSVyEE2vIfewBVI8MN0utbsu0+WGZkAaxsS+wuhELFJ64AQ9eP4J/Usa/lsDpQi+zl2cRhLxELXoUY7FIz5C7+F8isqc6pRLEpAAEb1DDGdUfgSmV9lx3m1LLYSw+vizsaTrFQMaojCXS/ZTb77EMOBOJFuUJ7npsY6hJqEvecs4dLmGL3A38Z3UzupyQNh2QoUu/oATGGEaolzvRsV3xB57Eh6EV6r6090y5XbPAagyFblhyQI+LNWma5Y72vRZ6YwfEmUUfYYzDMxqo6VwXA4/wRsmrnevEKTRDRGKa5x9ZYLFnVx+m3HuJpaM2634jxVvRGflNYxvCzHx3akXKjG1
X-MS-Exchange-CrossTenant-Network-Message-Id: 817d9e7f-0c72-4742-a7c5-08d81eb125fa
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 17:55:47.0372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4OQnWA9m1+lZ6QaRKCZTT+cTgmGAG5+iaEEPTphjkXxr+jn5mMbRq3BtmrpAG2pz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2601
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1593712555; bh=jLdty6+1PaFhDOHr88QPFMT0duOhgCnqv053BtULfE0=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-Forefront-PRVS:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=E+NtDibKGuiKcEwTHfxDLnplLb5DZC9UejI1Ry8vgWsz2LaACSguaacOWDk3/8jau
         l2kFOl9r4k7G1Iaa5OgKgeTKmclC4wg/kae30jetWozAuz58hV7zC/yttLQ+Df18YP
         uzykDDUarIjwZF+R8SPqX/q/DdqmhqPo7Fh8NM5sjlMudZ4USIPCElqcaBDmlTCftV
         BbCCkWW67oP3UKl93/8lfj1UOJaOW/uiTEQpvuEA7eEM8AYJE5YjTq602olPp9rI6U
         LI3IMitNF1fWBXAbHtAbe+wq/Qa+M+KN2GU54NLw51ayhf8lhVYLSohgApkk1SxMkR
         I3F/UInseo9fA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 02:01:03PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> >From Michael,
> 
> This series handles IPoIB child interface creation with setting
> interface's HW address.
> 
> In current implementation, lladdr requested by user is ignored and
> overwritten. Child interface gets the same GID as the parent interface
> and a QP number which is assigned by the underlying drivers.
> 
> In this series we fix this behavior so that user's requested address is
> assigned to the newly created interface.
> 
> As specific QP number request is not supported for all vendors, QP
> number requested by user will still be overwritten when this is not
> supported.
> 
> Behavior of creation of child interfaces through the sysfs mechanism or
> without specifying a requested address, stays the same.
> 
> Thanks
> 
> Michael Guralnik (2):
>   net/mlx5: Enable QP number request when creating IPoIB underlay QP
>   RDMA/ipoib: Handle user-supplied address when creating child

Applied to for-next, thanks

Jason
