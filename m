Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C678F42C3AB
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 16:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236903AbhJMOng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 10:43:36 -0400
Received: from mail-sn1anam02on2087.outbound.protection.outlook.com ([40.107.96.87]:42673
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237317AbhJMOnc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 10:43:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HwLkQfqv2bxRvxwYXYIucRoDuNm07RZB2W8yZTqrpQ5XeK4SDg33jrXDrJHM/BIlIj07oIVTeGfZpUac0A5um2H4cfnxWq8wdItDX5MQHPSuXyXIQmzKLpCjDtfEMSQGFGTv4Tzo1UzrPZxLiI7atWC81QD61oUxetR5MrWUjzPKgNScI57XE2aCzB7h+Ewn7vW9QdYbD/aABqFhHB5ydtzkHOvKXjAnleuGIQllEJ2SJ7z0Y5vYYv6bj3tQHv9mh4LMvGdsKR7ri1gjXl6KYlOMNlgodGViip3iDVCIBDsA1Blzjnf3PzcSr27EEvIMymV7+B90+L1IUOYyTItTrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2j68wmAga4u4gzCvJAQ0eOXRyOhxlwf+X/vNpCRFlI=;
 b=ChAhwHTG+zXLcNEJewwaJjNxYARtXHFIUnXrphBAWnadp7s4qCLLUKRvBpG6GS068G1UHF0Bm2tlbHTERdqveUGC+mmVjh871rZUwkyVtW0q3Okz9xmteL6xZ1kElH/lLJJ9mMYwqo3VnJyKBiVMbjm5BYVEj7pmooFad0ya1UUFiZnBwg8n/0k7OQsUgA1QgaRZsYv4c7nKyP1tQpKGhARvK9frLJDhjFBApuEDxmmimFgnpLoSlwbTQlrwJ+tWkfyDknzrlipD64PQ1GXa6SBU7UGvzRIX30UOLZS6RnDpYCgMxiSe2+mnx1i1aS6zQBdemkf+jy6zqx6JJ0sNag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2j68wmAga4u4gzCvJAQ0eOXRyOhxlwf+X/vNpCRFlI=;
 b=G0pRV46jWS+OVnA/ZKkHvldAEVO/8BMlB4CznQEZzOJU1tp0ROAuHr6bCehtBShnj7DQ5g40jHXkvyCZAyt2qWEyCMIawjF2bqP+bGSqf1nvAIybL5MT3Lqu5n4rPTmLDJToSsUUeOBhW2A/5Hsds46KqqEw5+sOsd0WWjWGGi7Ff1VuGzmUu/eVMlt2fnJwW++j7MMYM4PonNghjrK9GpjhoVbr4DgVYxDa+GiwkSgGSaTYBtzQ8b78XVx6ROK3fAAaCw0oHFLDwt7ZbFIswrXh5HJrpUJcAhJ/SEGtYG0ykkdhzIohH8nOie7y3K5z8J/fU7FANoe9MrvFrZs5Hw==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5173.namprd12.prod.outlook.com (2603:10b6:208:308::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Wed, 13 Oct
 2021 14:41:27 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.016; Wed, 13 Oct 2021
 14:41:27 +0000
Date:   Wed, 13 Oct 2021 11:41:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH mlx5-next 7/7] RDMA/mlx5: Attach ndescs to mlx5_ib_mkey
Message-ID: <20211013144125.GE2744544@nvidia.com>
References: <cover.1634033956.git.leonro@nvidia.com>
 <4bf22f9401a01df13804b90f9c7e90e36c788bd9.1634033957.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bf22f9401a01df13804b90f9c7e90e36c788bd9.1634033957.git.leonro@nvidia.com>
X-ClientProxiedBy: CH2PR19CA0010.namprd19.prod.outlook.com
 (2603:10b6:610:4d::20) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR19CA0010.namprd19.prod.outlook.com (2603:10b6:610:4d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 14:41:26 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mafRd-00EVTG-Hu; Wed, 13 Oct 2021 11:41:25 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f21ab987-e1db-4a99-5cc6-08d98e578963
X-MS-TrafficTypeDiagnostic: BL1PR12MB5173:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB517349332C2F8F9F1767FD9CC2B79@BL1PR12MB5173.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iV6/zSqZem4G7oKNWdnjxk++Ya2iUNZin5lgmzYMyKiZj8PAjUqzbpeYRzTBcZo2hpnJfb+klGPDoYvdcu6I1Kr2z+WIqTzAaFJ8xYZNMvf1m/rWr6XFvMMS2lNZpjryVgyan4cPiZ7JC6KxiwzddVQRvD5BkhvzYbu8o/j37sQJc2vw7sAWAfbVEnNt3I8XO6mHcHgN4rn3yCcGX3g9cuM6/uvRpqndXSHsn3+fSs4bGUh9r3cXeucVZOKSdM9iZ/Y+dS5s+e+UO1Gy01jnP/XPGtLLhXwrRxIZWktRmv9el3MTgPKU1OEOZV6BYDOe49n8t/RZm8KbgGXJhDNbJS9w+rRJFAMWmBBhdJW2Tikk8kotOcYrdv5yvmpgNqtlixcQuI1xDqAh/Rc+gtxX6WZ6e8e34FuqJgDTu2e4HmZkA7E0moMCNownQws5GaXaRH1tu7xgZXl0gFAfW5H7/lpFvLN35aSuI7jZFP5ulU1Ak7tbyHpr8R78yenP+L7lAM8S/rn7RSXuTfBXpKhcyZ00zS8ajmMFby1ZtCCagFQC3TPfSJ5FZE+IDQp5CtOcfninK1APSBiv41S5/YX+LUzrpH6Vl79mrB/0EcaY9YObnK8gZOMM+1TXCBWqwMq74WIQ5eGBeMGfSnHgsS9MGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(4744005)(2616005)(66946007)(66476007)(8936002)(66556008)(2906002)(8676002)(36756003)(86362001)(54906003)(1076003)(5660300002)(186003)(6916009)(7416002)(508600001)(426003)(26005)(316002)(9786002)(9746002)(33656002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yFD1+7dp+h4qj1LXUVT+S+CU2AKwI1YPuE8tW7rs2foCKgUcy8h5vOF37M2G?=
 =?us-ascii?Q?lb18oXt/f8S16MRvleEogSmes91xq0QdJntsWsyiV0bJ7SOZCSEdtEuSxR0M?=
 =?us-ascii?Q?Ek16d5rgbAlAMeChrWS7Hi77BH6QE8xH5Yb20R2IyFEZ41kluivyP4JS9xAi?=
 =?us-ascii?Q?TYsQ9NIuHOLaV+8BprsRj74jhAi93XxMV05RA7ObEwhZwCaan6F1cwL71jki?=
 =?us-ascii?Q?VM++u/rJUGV/BZ6VDmY7ioOsHgetlghfqFXrD2PKixOajmAw08pYItO/IMrL?=
 =?us-ascii?Q?KonURuk3hhQj1OmDAWSYrJR55GHFU4xVdQ2r4WH2S3rf1mXWY5aplXrlLcnH?=
 =?us-ascii?Q?SxHQ++pVHBK2kGGZIpT7E5yOUKHvCeRkg2HdIAGGvICdyZO2SCJQ2MuRClOo?=
 =?us-ascii?Q?i3GAA6aH7r0dOHVou7Ei9c4sBalL6OxFvQ4iH0NU6dPF3F3ZMJJW71eLhH4c?=
 =?us-ascii?Q?za33jvNJKrotGPh/sWLSFfRY4XLgShAYIBVpC8Vt1xzdx271ZBtUgkXxoGVw?=
 =?us-ascii?Q?lBIuCduYhaJVTL8GaZUD1NgpdFLoYPWwk65roStX6UyKU7/A97qy1MMUmQR0?=
 =?us-ascii?Q?U1+XgEwIMJmLyYdZoSO+qMz78LrnuKdbSb/QJKOgdCrALkz+KPLnCIo6Tkhl?=
 =?us-ascii?Q?VFRsQBhwlwcEavGEaQVycWJlmFenBjJq6dAgmy4B1OUdF8NIbrfMGtVB/7vo?=
 =?us-ascii?Q?I88MERN6VCoag8XC0LvVnSW9SS4hPiRxfM/m4jWd9h4+raSJG9F0loszUdnD?=
 =?us-ascii?Q?vGVUdnQ15LyBaQ3ejRtcSaG+Z3RxHYwtN7XdJoTe+kaHqTI0GXmqQZXGf3qL?=
 =?us-ascii?Q?KfRZekBDAo0Z6qP/lH2eM2oFelDv58WnUXGBI2lx1shKkggOJ5SKq0rm6CyN?=
 =?us-ascii?Q?ZJPgRVoooJvib+bGQxwfcTl7u0bjYXHBnLk0L6bcU9Y4YsN3MCO3hfzQ+unV?=
 =?us-ascii?Q?L9AMcTtbTvklxJTs4kEbor7P97PmVorZFVPermrRfrsXa+Nq3Bs7kEGKcbRv?=
 =?us-ascii?Q?gnw6MRSQDST2/ovE1+9akw3762JeUJ8t7pGPz1oygQLYqxExNw2MjB+YjtYu?=
 =?us-ascii?Q?KYwIb//jPs/KIbRSx+RbIuLnfEDv7/O+f9wbRG2S4BItUVMEhhwvivMk0Ibc?=
 =?us-ascii?Q?qQR8l3UrD0aEBVdqzROgsgBjV0dA9TCqtweXMAjZo+eqqVz2roJEXnq4rrMK?=
 =?us-ascii?Q?v1OOeCri5gujsitYLnptjUD+WssSL/DTUvsvvi7Iurt5Gcqxt5gqGZgY3vUN?=
 =?us-ascii?Q?qGckkdOcvYrQbCIv/wM40n7WqEnKw/qTIjPdwBSX0o+8fTCpmqEv+6pSNhuj?=
 =?us-ascii?Q?IfxQCezrDhX1MEk0s6oZrLtO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f21ab987-e1db-4a99-5cc6-08d98e578963
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 14:41:27.0683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XZp+YE3MvBk8Lh6r3e53HkgO5bEg6yp9v4qascD5TKx0AqVR2GbM5tBG55fXeo+4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5173
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 01:26:35PM +0300, Leon Romanovsky wrote:

> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index ef6087a9f93b..ed173af8ae75 100644
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -637,6 +637,7 @@ enum mlx5_mkey_type {
>  struct mlx5_ib_mkey {
>  	u32			key;
>  	enum mlx5_mkey_type	type;
> +	int			ndescs;

unsigned int

Jason
