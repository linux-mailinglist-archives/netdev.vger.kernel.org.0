Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BAC337EF9
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhCKUTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:19:39 -0500
Received: from mail-eopbgr750078.outbound.protection.outlook.com ([40.107.75.78]:62881
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230231AbhCKUTd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 15:19:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuJV20antJ57QSTaBcWkfpYpPjLbpgzobYRnTtR+XrENxUtJcTQMvw2RgDDtqVCzqD0JaTyGqvPMwjt8xJvJ7hMOURKNGGW4kFx1eT0VMiGo6VJYtTYCUoaWT++wIevRqtEsxDXJISqs0EocCZQmbvDaXieYwfnVngheZwbK4gMcMZLqhaNRZPEcs4jYTOhdaGfxjHrnDGN/pfqJZx6ESdbJW64SyNXwPJ9IlvIz++aByMyoBy4GajHRJ9GJc8RtQ3WsdgSBAiKSpK9p9GwH1F65VxtsCn3kVfDnWBSblSX+hYk2q/wTNQVGgQg4V+r1VVwY0IEreuCBy14f1/V4Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtpB/K49tuZusMmwT61mEsr0LPVavQigWsqSdH5bocM=;
 b=PbCCo8/X+vPEzQDMyZ5JMCaz7DiXLP/gatyY9TagTRYVo50Yyu8GSRG6swKprk/FciC0fT6aVAIZS1IIm8K3lG6f4YMYLT0SNthZOp4T+tJSyA0RirikwovitiaMQpWJ2fMYY4jtPzmwTcJ2PhoOGIGhXdselDJqc+SPOPWDJTzDxQ8ga8y0qx5OITHpN/oinvGpvL/Nb28V4p1BiB9lHyW+g5ROBGWv/pJzrr1wifHkwFuEkqpeB6qXBbHwFYxbZu2mBB856TR/cLQUhcLqCJCQzeCViNt0IRgCmhHK4vYJjCaB30E1/zMsQLAsmgTORMIcxtmyCa06KU4RDZ8MLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtpB/K49tuZusMmwT61mEsr0LPVavQigWsqSdH5bocM=;
 b=qIog1spfFO6RuoVLFUgS8Rha/JLPhAdgZqDevIjga/UyoTqAOU882oeR+1vDIsZ/m/fHiePpwYvoooESudUNgBwaRBZSYDzl9kMTWaDxfb6Snj0s+VdFk4tUOx39u8fgFA5rJrwlWj5dzmC/skdKl5j3/v3Wv/At/LFJ8fqaYT6No8bgbpw3qRcevwq5wCEe5sK2tj+qBk6FBb+jYikm8XQU00Qp7X+EgHwoedWgW2KUjyb0fmpcOldepuxntKbreH/x8OCdIzs9BBIITAVG+UIgmBdlo8F+QOI3OF2HloRE/kuw4Q/iBW/9tXhrHdcTvi3RojbHhHy7zpGqfd8pbg==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2779.namprd12.prod.outlook.com (2603:10b6:5:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38; Thu, 11 Mar
 2021 20:19:31 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.031; Thu, 11 Mar 2021
 20:19:31 +0000
Date:   Thu, 11 Mar 2021 16:19:29 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210311201929.GN2356281@nvidia.com>
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520>
 <CAKgT0UeprjR8QCQMCV8Le+Br=bQ7j2tCE6k6gxK4zCZML5woAA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UeprjR8QCQMCV8Le+Br=bQ7j2tCE6k6gxK4zCZML5woAA@mail.gmail.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:208:91::11) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR05CA0001.namprd05.prod.outlook.com (2603:10b6:208:91::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.10 via Frontend Transport; Thu, 11 Mar 2021 20:19:31 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKRmL-00BVkJ-3X; Thu, 11 Mar 2021 16:19:29 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ae5cdf6-fc59-43a0-f750-08d8e4cafa86
X-MS-TrafficTypeDiagnostic: DM6PR12MB2779:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB27794BC5848E96EDC80E0737C2909@DM6PR12MB2779.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rKLWeFsTD24dkzQ9+8EqsEEjnrJSk4yQ9RkMxsFgJYpa0qshr907u1l2VQHMXaJhsXSRQsSr3AFAgku+zitEbnCFbRsYyBF8PbeLpvU/Nao+aMPkzrPKmBl7Eoyv8pA5VRtPEUHQ/d5CEJa7Cnyk9v7O78bqBnX0EIr5q7uuZn02oa0Iq09GuFhT5iuFwPEJeXeW6VVayuvAsbBcfbGZv0BhBbZmPg6A+wZ8n/+aEIwQP/74SENi2CHy/ROA9kzoH5a9V0BdEmKEwYqIFeZgLa/9jweiMEbDJs6urpzzGLJE3+EjhV4S29ibUOGJDY4muIt4cd/o0j2fz2LhLsImoCYzWK9Zf8iiKDGAI7wuReQViZemSxWsjGV5cHGdZwsOqVf7cdFleb7kMLrVWRpUF4nHn3RmyI0Llfgala0f1Yqdpv3tVVvZM2Ggh9IcGlU04G2GrxfItkYUnTQN2HltSRZ5CbgFmekOBTBSF7U1vKrr9YQaSIcRK/R1DIpTExb/JSvIl2DoiDoE2h7eflyuiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(366004)(39860400002)(4744005)(5660300002)(2616005)(36756003)(86362001)(316002)(66556008)(66946007)(9746002)(478600001)(8936002)(54906003)(26005)(6916009)(66476007)(1076003)(83380400001)(7416002)(8676002)(4326008)(9786002)(426003)(186003)(33656002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QTlSMJFgVPMuF2oigCcM2HgBxGzyOoTs/nqOcBECaSXzoQXI/t+vN6yYPIAl?=
 =?us-ascii?Q?P36l4VtUOrgLD0WIlguQUdizDtY3zlaYxtSsPGUvlSdV35Dz2vQDym75PGAU?=
 =?us-ascii?Q?HtEnJq6TjU46q8wwxlHDJlPvetw961z+WkxiFckP4/1n43NJgVLBhwYK8d5V?=
 =?us-ascii?Q?wLf1/k7n0cq1fzDu2rYSPtNFEjmTbWxj3dn1dOP58EHFAj1zRt0Da0KBgGGU?=
 =?us-ascii?Q?DnXcv0XfKP2XH+8Zt+aL/GraAghU17Iut9hGtdvUFA3JKqTnvI2kX6sfnIjy?=
 =?us-ascii?Q?GbLN3KWaW6eKlvtDdP0fgqO++4YkkzrM6Dxl6fj5i6Dwhv6b9ERC25duijyr?=
 =?us-ascii?Q?WWvBfOO0qEViZdXO7/2HW4rzm7u5aclp2JonaN154vAVRirg523CMZXlra3h?=
 =?us-ascii?Q?BGzDzbZhybhVl5VrsUiVvubRveSJJ4PkKQemsAuvgd0eUn/7mmTjXV69L8bz?=
 =?us-ascii?Q?CsUBYgFDwPcF/Yf4CRbivlXDW9XWmBqgUG0R4kTDpqybQCZTUVWLe992kcUw?=
 =?us-ascii?Q?q6PFypGvVRnR3c7zG1uLWbg47EBCWU+3rsauSGJaWP3HJhMVjoqOMkc+NT2p?=
 =?us-ascii?Q?yMDljFBH5uTNJdjVU3cFbb3jmVfgKWJiaHRbck9bUzLdyqO8kVqGKvZtDory?=
 =?us-ascii?Q?+4FOF7g6nZfcZCc9pouQvp0BXm1Px+qOZY4okYmuZ6hIz+LmpF0ywunj8Ipp?=
 =?us-ascii?Q?Iw4igtX3YQ2EVgaNEc2Pav9xS2Bo6ROSR6dcxiC1kWsXtsDGRAR5pyHAv9qV?=
 =?us-ascii?Q?Dmx4T2NRxx1nRMhN2h6rKX2o1ybKegjb1VLtmA/uCcKetNLc8giKpvsxICLw?=
 =?us-ascii?Q?O7CRMFk0J7LkNIoDp0Yn7oUV1WgpsSWQUOelBcW4CluslQuBkRis2DYPxG5n?=
 =?us-ascii?Q?lMLhkegBCjiQ2ckKg48Bb903JRl5r1RaZXFObODLJgFBYZKtSeuLkLy33U+S?=
 =?us-ascii?Q?+9edgzOIfCs161mpkwH1DVBS39zTpzyUSHb9XkeGQrn0J7ZvOXw4vtsUJ8+K?=
 =?us-ascii?Q?//63mFHsWf0C0Vdlx7ow0hDE7G9hWmPs8FK1YvnhNIyoE5uefNg4kgqQLOgz?=
 =?us-ascii?Q?Vir3LLOJf5iLGgDcJkgLvMpW0Rd7lbesQ/9A/xeq3fB8vi26FUoU5RXofso0?=
 =?us-ascii?Q?HDK7yzhG6LI5Mt+HqP6WYkqOx3iSQUMOMmvh5VsH088w8EgyEvuYbg9urw8o?=
 =?us-ascii?Q?TtA1nUReJi4G6g2QXeJfpt7EUZMXG83lKV792dGxByu+GEnkIMJEPuTo7UbD?=
 =?us-ascii?Q?OAdD79CDRdfByqviIP6KGl7cDt8ME+I7fsu+X+PKnM5CH/vTZIsSH6cLdCJk?=
 =?us-ascii?Q?dvh+X17+QOyhMjq3CJlvjNyhlyncZikq08izhKK5Xh0r9A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ae5cdf6-fc59-43a0-f750-08d8e4cafa86
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 20:19:31.3289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /xTz7T/JL8XwNiT4sE+Rg4oUzlhoUyr29nPgfq8rbPHpHsvIP5+9l3x6PgpfKcY6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2779
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 11:37:28AM -0800, Alexander Duyck wrote:


> Then the flow for this could be changed where we take the VF lock and
> mark it as "stale" to prevent any driver binding and then we can
> release the VF lock. Next we would perform the PF operation telling it
> to update the VF.  Then we spin on the VF waiting for the stale data
> to be updated and once that happens we can pop the indication that the
> device is "stale" freeing it for use. 

I always get leary when people propose to open code locking constructs
:\

There is already an existing lock to prevent probe() it is the
device_lock() mutex on the VF. With no driver bound there is not much
issue to hold it over the HW activity.

This lock is normally held around the entire probe() and remove()
function which has huge amounts of HW activity already.

We don't need to invent new locks and new complexity for something
that is trivially solved already.

Jason
