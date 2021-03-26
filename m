Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C552B34A7F8
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 14:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhCZNUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 09:20:09 -0400
Received: from mail-mw2nam12on2071.outbound.protection.outlook.com ([40.107.244.71]:57696
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229984AbhCZNTk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 09:19:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4gu12nnhiU5uReBBH2ljriZ9PGu6EZr9TDPFx1GMDSKQdtANufVXjhSERk7eEJoDiL1DleVW8FbRhSUJFaN4mujfngQyVI/DRP/ffYivE+wi00UcdJVguCoOdj3i//oUtPu7CfwMBMY16LJmuR7KEmCRFA4+/A81go0eUjn47znb9udhG8FjVT+tgSSjGgaAkyQxUyM8dzYxjdt93dMfH40YUEymJIvR6321jyFNibHQGWhv2L4zJfoidYcRWnDKnjyoD+FTeiI1/ld+om+tFGktpaU/GkTH+fGE0xmzy8AJQn5nWFl8dJmc0gTZsE0H91nLngjeAMVXl5p7EZvzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2QyRRexhWNUWIAxAsaeaIXNSvO1kB4vnCzv9CeGHdpg=;
 b=RSNAMpVBS2I/u0GZwn2gosNjul9WHujMAVzjgrYL5KT+OJu7sO+O+Dt68YNWSPOJkUxmriw37XIADlZNWxmHgREAth36ZRK8+BDifhELdFuUpCfluKKPt9IzlPH4g/yai8vEFbNnPgQSVAfh973XyUAMBrbDks3kJsiNU6IlF3kHlf53Ejzei/Zqr0SDnmbEQoTBUFSwia4qwYqAqw9jMfDDKxzhrMrdRQip2I+46DGmWMHXssMp0DaKhmY2tkvt1XPsCw5jGgzsgDjV4TyVHAnbEAvi15n/CB6iTz8/g32WwdjH0aQ6AzUp4UDLrMXyHSR5u0SoXFN5FSGY+sLJVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2QyRRexhWNUWIAxAsaeaIXNSvO1kB4vnCzv9CeGHdpg=;
 b=XHwqdRZHYRQx/U/2Cz9q/6a20nooXs92qsnrXm0zTEbk8OXqHKMOugzsoascLR/C/xchtFnHPOmm9lKvY7Rlp0FtaLSklHeGF2TqRxvJEIiegOo5xTNm+Rz6PYUncHFIHo7dOEt6rKkWGoh3qU6xelMwtgaXTASsI9FmkA/qz0wKOsTBaJCRs4/vE/ec3ka+XQ0pmG7bUcVbwVV5NK/c/8qiX3hIrE9fP941ObhGyw5crHXo50YB4W6i1QIsWX1fGkVNcprLX1eSQ20VIlZh/uBkmPUKyROpRXH/8hpF/Fd5JpNhxW83pdS24+Y9/3EghkFDsHKFP9dW5i8u01oBRg==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4012.namprd12.prod.outlook.com (2603:10b6:5:1cc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 13:19:36 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3977.029; Fri, 26 Mar 2021
 13:19:36 +0000
Date:   Fri, 26 Mar 2021 10:19:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     Doug Ledford <dledford@redhat.com>, Mark Bloch <mbloch@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Ariel Elior <aelior@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Christian Benvenuti <benve@cisco.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lijun Ou <oulijun@huawei.com>, linux-rdma@vger.kernel.org,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        target-devel@vger.kernel.org,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        "Wei Hu(Xavier)" <huwei87@hisilicon.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next] RDMA: Support more than 255 rdma ports
Message-ID: <20210326131934.GA832996@nvidia.com>
References: <20210301070420.439400-1-leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301070420.439400-1-leon@kernel.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR20CA0025.namprd20.prod.outlook.com
 (2603:10b6:208:e8::38) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR20CA0025.namprd20.prod.outlook.com (2603:10b6:208:e8::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend Transport; Fri, 26 Mar 2021 13:19:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lPmNC-003Unh-UI; Fri, 26 Mar 2021 10:19:34 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09da628e-fb9a-4189-2c62-08d8f059cd5c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4012:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4012C3821A002B951F6453C7C2619@DM6PR12MB4012.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HYgrT/OsxMlEjF4sH+y3pG8r6zVhhfKlq/U6xxRyrmJfA/ExobYzDXHn0tFMdpc0cNl0N+xvLPFleNlvJ8eeBKZoT4eSJwA2LlBu0NcjL17WH91L8oFtAwxWMWPUjwupcfJ59Pb6irUSkRPrcIAlj6fW54CRlY8Oe2FnYrPDq0O+A1Q0jiKXSJtEDNw3o1j3tI/zEZCfC0MSrYvR2/Hv3AklNW7Ndt2brXVcESJwU/AzbzapU+G4lCzJxyDe4UOB1U9KuRwnqwd/8yH4qzlU6M6Swk28qhQMn4Dn8EEwsgNOz8D7jWeb/r7I/q8pNlNEOq4w1pdUvOzSMy41WeftqnnXde2uZ0f3l3gL7BFnTSZNeQ6SxLtVLSkY9II6xcChpbVH530eRPhGSg56S34amkeXonLB83dvi574TLdMp+WDL2tj8jwv3TDwafv7r27z/508JBNCShTgzCpr3gsRR2AKdsRAhSdn2mxhjVxRdVasVZj+gVxTXHhypqt5bfoHIuXSgmPfPgIbt8yNzM/Hp6SvVXtVr7M4i3eoYAKd+priNRfhn+n0RDVgDjKKpsFppWt/o/CYTWfl/4yYuD8IgCLChDYJwZysCJ/KWHf4xbZDH3TxUvcZH4V8kpL8COV+8ZNnVZmm5P4S1NvYiDBUjf9XTjr4xQSwSPcPp6p9tD7sS4JCw8If6cf7lMon5j8v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(5660300002)(9746002)(110136005)(36756003)(4326008)(54906003)(33656002)(316002)(9786002)(8936002)(478600001)(66556008)(66476007)(8676002)(2906002)(86362001)(66946007)(7416002)(2616005)(186003)(26005)(426003)(83380400001)(1076003)(38100700001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DGFlMZlBbsASrjXGILwkXzElOMSkXa5hAfjvOpsTVUQh7F3CLUFN7yokYTDx?=
 =?us-ascii?Q?jx+mfOkDUmLWQbQRYn5uPd2jQQBDMLB9WY7vvM/NhjkHOB2hDMV5npX3klw1?=
 =?us-ascii?Q?V58gTecYo2ydll2TmHL1f5lIW/2yY+6q9kv2DNpLZtIv+uEwgda75VOVN2TW?=
 =?us-ascii?Q?AfZy60BPmLTQdt/Jbgc3BoFkf+B/af2Qf7MKS4r5uABbCO+wHSaQh7a8XCrw?=
 =?us-ascii?Q?hVQOZpQlhlniAbopuYAoW/UVAQfn1WcFCNMiYUQkUBIfVn54kgPw2d8fjDyt?=
 =?us-ascii?Q?gt/N00swXlyh9jWnX7aKWEkHF6xQ91O1HrGPmUgXQgZdquHI7JphtUE5MHbU?=
 =?us-ascii?Q?1XOzoz3CK7JoxYeE4jRBNew2ThZIq3H9X8fIQB23GkeOAwpa3T0pnPSa4EsT?=
 =?us-ascii?Q?L0VYglDtMVaGDrZriLN+wF31xfblkv51Ny2Er4Zo2bmZWFDQUM6RPj+iQ5VJ?=
 =?us-ascii?Q?hKAmEf9VXAJdR/pTUtVLznrMzrpfrbhPCGZAFJN18vdntYtCT9HCpMNZvFHY?=
 =?us-ascii?Q?dscrajVcs3iQeaR3gUhqJpaWbJK3h0Os4sRhl82u92l8SZyHYNKXWujfixcD?=
 =?us-ascii?Q?j8+ukQeDF5konoLPcj8q75QkzGIcV0hNJg28GmUOQipYzWOO3sErIR1muhHe?=
 =?us-ascii?Q?3rhzukCBsTevsVkeN4IoFLQs+r6EH+oQBBx4/VSHSCoS83Ayxc2acOztiGJe?=
 =?us-ascii?Q?n8Yuja+iz9+A726rAXpQjQyv5Pi74e90x3b8g7cGtOn88XqdTFvaOErtfits?=
 =?us-ascii?Q?DbgPthr3perBJCf9vgjwcxGER0ic/vCjLiBXD29bzVpuYbapTRK/9naJ7f4T?=
 =?us-ascii?Q?n/u5NbWjxjvZJyZ0qKRelIuGpLa5JR6ZcNGsXIYl/G3zb0ZNQaa6fwUPFvZZ?=
 =?us-ascii?Q?F4o3Qa/mxOAyj4h09Tcuh1QhtunScPOUmoUwLoYNxUEeVCrJ7bEKRh3HNHok?=
 =?us-ascii?Q?xvx7NOQtYeaf1OCXaW4BO3qLHGIFJthDq/gURaD5Uvxz67zSxs0DoqYmPJlM?=
 =?us-ascii?Q?QBgY3n9U/rGF+tknlNkT4XOr2BHeN9o2pYiILIcviP/GF5kdAkQcqbNl0ESx?=
 =?us-ascii?Q?2xnWBsSXtePAk2mXjIK4gPODcg+iEOoGwFnvYZ7L5Jgax7a7lwrOZop0tL2S?=
 =?us-ascii?Q?UfhhOX3ikJ1tPgn+uw/YbrV2jC/JE5jTOWF0I/fRwu9zGw0Dy/U5c1SBE8fZ?=
 =?us-ascii?Q?tgJjG4l+jvqzWDl4XtksnkY8JyYPsVCVtc0nAmAddlRZZq3HtegN3U54pne+?=
 =?us-ascii?Q?Ndf9+hc2oLZ6gZkcvkyAQ3uHnuEQ9D7RlmcsvqW80tN6sdkmh7mCNCBNY8rC?=
 =?us-ascii?Q?cIwMSopf+mKQe8NYHgV5Y/+X3skwRL3UL2OoTPm5l9ktnw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09da628e-fb9a-4189-2c62-08d8f059cd5c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 13:19:36.8066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hxwRzBaW/qZd6y3qofReAixh4a+D5FC8hRxrWK6GcCaijzygDC0BulRXLS2P3vF0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4012
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 09:04:20AM +0200, Leon Romanovsky wrote:
> From: Mark Bloch <mbloch@nvidia.com>
> 
> Current code uses many different types when dealing with a port of a
> RDMA device: u8, unsigned int and u32. Switch to u32 to clean up the
> logic.
> 
> This allows us to make (at least) the core view consistent and use the same
> type. Unfortunately not all places can be converted. Many uverbs functions
> expect port to be u8 so keep those places in order not to break UAPIs.
> HW/Spec defined values must also not be changed.
> 
> With the switch to u32 we now can support devices with more than 255
> ports. U32_MAX is reserved to make control logic a bit easier to deal
> with. As a device with U32_MAX ports probably isn't going to happen any
> time soon this seems like a non issue.
> 
> When a device with more than 255 ports is created uverbs will report
> the RDMA device as having 255 ports as this is the max currently supported.
> 
> The verbs interface is not changed yet because the IBTA spec limits the
> port size in too many places to be u8 and all applications that relies in
> verbs won't be able to cope with this change. At this stage, we are
> extending the interfaces that are using vendor channel solely
> 
> Once the limitation is lifted mlx5 in switchdev mode will be able to have
> thousands of SFs created by the device. As the only instance of an RDMA
> device that reports more than 255 ports will be a representor device
> and it exposes itself as a RAW Ethernet only device CM/MAD/IPoIB and other
> ULPs aren't effected by this change and their sysfs/interfaces that
> are exposes to userspace can remain unchanged.
> 
> While here cleanup some alignment issues and remove unneeded sanity
> checks (mainly in rdmavt),
> 
> Signed-off-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---

Applied to for-next, I suppose this means the irdma driver needs
re-spinning already.

Thanks,
Jason
