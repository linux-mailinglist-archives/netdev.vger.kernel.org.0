Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05C03AF98E
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 01:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhFUXjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 19:39:53 -0400
Received: from mail-bn1nam07on2072.outbound.protection.outlook.com ([40.107.212.72]:56130
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231697AbhFUXjx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 19:39:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0Ydv80qUkV/p2WM7E7swD//M4Y8Q+HS6SlDAoeddcmcdvrWURLtwtoIa1yXu8ZRAQ510ieZp/tFAAXlGCSIXhVzFkDYi5ITkTr3CLHn9E5UkeXs+isybQO99mlCdNTDUsncu0VNQnez07L9MdA0dDaGiIhRMpUsQ1HFJ/NpL54RvZ8UMwRYp8eFxqTOn7SVKGUW9PO3rjrDqCZkieKRfEH9UBfGif/Aw9L+mcjyF7SQFufntocUX8JanJ/GsXc2/3Dnwd4iOUFeAEowERQAn0KWdp0yohvjZBrdvZ5XrtfZIR4VupzPv+4GEDi5wG3fMqrmUlfIkzFxj4yVvWKzUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2a8peVO1BZ8fRM0qEpsnG6tH2zmVcay/6U8piER3ySI=;
 b=FJB1AKLTabKJGKI3pSAyp5Jm6msOszdYt+A9AgmAIdbSgbFhAzvrJ9nTd30jLA1xjQOO8NvivjuDNo4/2en7SopxEUKLUDEBO1Nt/uAz5JXDsVt9UzmQMhTW0iSR628z+jnifVnjsluTwnVK2hQKOXUiIOvKtvaoK2vn14ztp6+WJ4h96B1L/tGWLh4VxkYnIEMgU1rAVf+bb9wMWE7beTDTxRdKwkd5Df4xki3vu3ZQ+Imtn1YPPCyorcqi4uDTr9+6Q8JvTG+Wyg7eEwrC29xj2klZBqBdMQ6tdNRU9Gvqq8JAdRuutivLwoVYzDkk9tqihMhDs+YJr4HHjFgk8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2a8peVO1BZ8fRM0qEpsnG6tH2zmVcay/6U8piER3ySI=;
 b=dr9EJn6NdWES0xwpTfbt4NEJKMm46LTPpcZT0iUDG1pLGO+IXP3f3GY7YzwtZH5E013r1lTEr6LtPtNH+jLtB7M8v7fKlXhreepRq9hj/0WYae84HV548irTXNCiqzDc4RBx0Cijp7dwpeiu6uriX0+VswHgYF64DSuxCT7MlOO9m/y5rIB6/5s1xfrmDRUJ5ImXOXfIVAxWE0VFVd3cmCbEu7BA7vTu8aY41uKe87bJvAD9XBAMMT2kBgfKMgrZzDeQwUwlS/1dt73xXTujvrGiMq4BnLX7vQwNuh1l7xOWav4DxztWNsi5UQ7hTXanK/tqF7lCQludARKNDsGp9w==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5302.namprd12.prod.outlook.com (2603:10b6:208:31d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Mon, 21 Jun
 2021 23:37:36 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 23:37:36 +0000
Date:   Mon, 21 Jun 2021 20:37:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next 0/2] Provide already supported real-time
 timestamp
Message-ID: <20210621233734.GA2363796@nvidia.com>
References: <cover.1623829775.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1623829775.git.leonro@nvidia.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR08CA0017.namprd08.prod.outlook.com
 (2603:10b6:208:239::22) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR08CA0017.namprd08.prod.outlook.com (2603:10b6:208:239::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Mon, 21 Jun 2021 23:37:35 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lvTTy-009uwl-RD; Mon, 21 Jun 2021 20:37:34 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f37af988-ce5b-4bd1-2482-08d9350d8c9b
X-MS-TrafficTypeDiagnostic: BL1PR12MB5302:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB530236EF1871EB19CA1D4AFDC20A9@BL1PR12MB5302.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yJaw0+IgOr4hYhLY8GvYDmG9tagjXmZ33ZeHvikrINyTR6PULevOB86qiPv+9llaheQ5QRbX7a2xUK2TJ8Op4t2A46ZxAeQhwZN7xsg1HJrSvEBqr42DA43D7Gbzr1QXZ1vJsUKajX75TXK4b/udm5mW/pJ5D/amJfQ68F2ARp1mHTw3ozXDEO5gmaON6cL8I1cwVNS+ka8Y4XtOoEmzsgXcjlIVCV6bZIwFLP++ECjv57FAT8FzrlJL+axjts5BBOruzQcLuvnBIwHf+VKxHjcQh4kEsuoS3pnr+7caB15K3oHpkGqq0t73XZ+qMeSJWF8BiIZzaNi1MicHKTihQZ4ycrerrCS8NQ7536ppw+gLS0c2kUVGoVRttLTmtb0kNL6NqbK46ZESilre8sc/XC0N0XKIqxGG32B8MDGFRANAct+Oa5ujPHr5tpx0bFJ5iMzsT3t+VyCNvB48TnwYRXxme+XjveWBhfGcBZSaZB0O/X+Tobnk5biLXSWpbKKcJF9Pd/1mVOVIej13hB5CsnLyOA0g+zfs3E4YxYUfOegx7Xq60vGxPja4/QE3xVtxfhLDW3E2puGaTNrMZolpm2yEs9UDVDYfdxtfgnnOMcE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(426003)(83380400001)(9786002)(38100700002)(2616005)(66946007)(36756003)(86362001)(316002)(9746002)(107886003)(66476007)(66556008)(54906003)(6916009)(33656002)(478600001)(1076003)(186003)(4744005)(26005)(4326008)(8676002)(5660300002)(2906002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gAvduf7A5EJ/A5PChpskl9BCh5yG4w49Pbp42Tei0o08uCIhz4WjuB6/DGWB?=
 =?us-ascii?Q?5zIJioFuxJta8wr7wkZCxYf6FVauMlgGbW/7effgPRa076dIxjzTcoq2LRip?=
 =?us-ascii?Q?0Hj5jL8VefOnejILK8cEZH0kKQTxGYgk+rh1RzaMcchlfdGtI7svx0ASCmt4?=
 =?us-ascii?Q?pDnUMJYUXR8F/djGAA6lE5YRzjWpwIFhtupapqcv2JLdhXObGkWKT33De7wc?=
 =?us-ascii?Q?kOgcVWl1IfdJTIOuFgZHlVYkP70XGtO/UxCHECyG5q1/aQB4ZflukszNEUHA?=
 =?us-ascii?Q?po4MZI27Cz2hxcA2m6Sex5aGqZdtJnvHtk9MzhV7PzkTmFFdznee9N5TfpJL?=
 =?us-ascii?Q?+Xmr35Un4EhFY631lAgNIrm+Hlv10asCdn7qix6iZWLiDPPn+XNUCKA6IlIo?=
 =?us-ascii?Q?xkc1u01MaFda2Ni0zI8sDAPOYKZhIGsmxoqlijAZzQr43PFDqEWkbxGE/BZ2?=
 =?us-ascii?Q?XgKXNsCnDsgGk/Lz+0hlQ6aUwheKYZAjNX3F7CIKr6O0J2v6GR6xyfnCViAm?=
 =?us-ascii?Q?J6loo8OB9JYD5bGev/YI1ZHpfa4WzSyEJnEASwcXqXZP4l+ClrVnDosJjrs2?=
 =?us-ascii?Q?6s7Nd0x1eVl/ZEwlVC3xVLzUYAxFg8XAjxi9cN4Pd8jMJH2CMRUvap0P/DBy?=
 =?us-ascii?Q?fYCxFm057bp2PjhT/em2zYKtB+dHnSdJDbATmEjyIS/lK0B0uElGg6O67Qai?=
 =?us-ascii?Q?rk2okBJ1HY0vJnKtHtIYMYyNvORqV/r4VaE10Cm5xpuU+UIn1Rgx6SFENkx2?=
 =?us-ascii?Q?xNhpa1frSeRbS/7D9a4eiB6GAiU6GC3C6wZSi1poSsHJ3ez9QXPXkauui6Ia?=
 =?us-ascii?Q?TGjQ7jU1Ze+K7XqAzLlv7Q4SaQeljYowdezoCEwA4LW4cdlMvfISZ3TSwjll?=
 =?us-ascii?Q?M11csvjwlkvl6RoBFWCwBG0NVohhcIikc2bNh5lyjU9ZSSlxxgAu6BRyUQ3v?=
 =?us-ascii?Q?CAD9a6ZfrRLbPibx4PT1LjY7ihIrbOsxpA8cX5ka21r7JVB/DWglvcDP6FsW?=
 =?us-ascii?Q?x8/rjivxijZb0sLi+667lsc5i/+ymPzLIbtE9DRqKKUYgaK47SVm14eTiTOX?=
 =?us-ascii?Q?dGeq3RA+5ciuDHRuGU/xF14mOqQd1n3ENTrnzFN/XbloBfobUkaw6KEkbwdS?=
 =?us-ascii?Q?MYUn3mAQ0RIgw8HVZcu4u4AqArrkrPAJgrXkjgzo8//mLA+jbponGjWdMFKf?=
 =?us-ascii?Q?xbQXFRQVXxsmwcKwt3/xcNOln200smUG9jQ6fH1s5yd9nMnpn/JQAj2YrJW+?=
 =?us-ascii?Q?f21TCG1O5Ke2V/4V2NnZB+EKLxbVI9Tyhh/2DmkyHFFjLZ0dkicZuv1gW1/V?=
 =?us-ascii?Q?xaQ1npej2+mTwYmkOhjkXgEX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f37af988-ce5b-4bd1-2482-08d9350d8c9b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2021 23:37:36.0525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: niOA8OjYR5wJYd1p4ddTVWlY+EWlc7x2kncN/+Yskdi85P8hSuH6IftXdN3OD17M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5302
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 10:57:37AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> In case device supports only real-time timestamp, the kernel will
> fail to create QP despite rdma-core requested such timestamp type.
> 
> It is because device returns free-running timestamp, and the conversion
> from free-running to real-time is performed in the user space.
> 
> This series fixes it, by returning real-time timestamp.
> 
> Thanks
> 
> Aharon Landau (2):
>   RDMA/mlx5: Refactor get_ts_format functions to simplify code
>   RDMA/mlx5: Support real-time timestamp directly from the device

This looks fine, can you update the shared branch please

Jason
