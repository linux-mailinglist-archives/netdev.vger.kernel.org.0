Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1623648CB89
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 20:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356526AbiALTIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 14:08:10 -0500
Received: from mail-mw2nam12on2072.outbound.protection.outlook.com ([40.107.244.72]:44032
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241137AbiALTIG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 14:08:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gj6fHDnil9HFK49ip4UCaFswFtsvX9A05IT5pamNGbrAUc5tdoU8R3QrZzskakXs3AIp64fsBxUMb1hYH9akzz5jy8xpHcihyLmNaTyhrW+/Zds2GumM7N4AfxbO/XMk7JCOKf6FVum6GgzhAnKZpHJpBvLGHY19JTnHtKzn3/scTc88txNPwrCOezviRCSfqZs+bDiZCF0OvR2T+Ozf8/7CftTRqzGTBta+0D203CsdtGJknbxgsPOiE4eRAItqxAOPCgZiXggG6fAQgXIe76iMceGZOsjH0prnnh2EJPg0aoUKg4sBnSDpyx5UHE2LJdHVHz5sKSeBQJtrE1q0iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dLM2wCXP0jsD0JhNOiiMRsANkrI6whF/QWbLnLKAu/c=;
 b=iLmP5pFBue7pRp5YLSBMfLlas74UufTZZzBSESX21d+9d3en40CKHHlLcIMB052OEJEGu0LaiZyVkWy9712umTyvA3iQbVR5k2Q3184k7o1IHHw5CPSLMErk+OCLGt2ieGJGWnt0TAqd7TMCUL+NHG8eG3WDNeScw0WXw4JPv/9Of7vYfnlcAeD1n9JtopsphPQxW2SV6aSbGjZv/OLRaObyhrhfRqZf9q49WM4gquxZH06VkzRr4jUQTUOcT0MuOt04105RTM1xg1oXSjFqOBVmlfwMIZejzq6/wU6Pwke5i8aZuNH2EVMYBayBo0PiCSwAthEMsg+pwetavSgDjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dLM2wCXP0jsD0JhNOiiMRsANkrI6whF/QWbLnLKAu/c=;
 b=gzq6UwjHx5Aw1l/qsLUn7ZeOG1GK+Uoh81KP9d8CGX166EHkknTcF8GAB6u7qg4ORqxDS2abBPlYZlhk2gVrmOBafKh3sXW8ep1Soc3HYi+T3UDIsfvU0GHrdKf7A07K0CNQSmu1byYNGgXmpR1w81OgnSiTlud1/EaS1WtaMsV5tohCk5Er2TtFWEYfMVhZGlAeiMsmWtXWU+8dYaQdaePSy/68LRnXSruMK8rOs/P1AOoIQk0TkiWBi3k28Q9Ng1CscfGhA2VhWH3ziy3QASW4wYfXlDUqIHbeYdhN67ExAra7lWBnSLzoET40RY/Pb9jSYgU1EQFbk8o0ug6Sjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BYAPR12MB4758.namprd12.prod.outlook.com (2603:10b6:a03:a5::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Wed, 12 Jan
 2022 19:08:04 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%8]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 19:08:04 +0000
Date:   Wed, 12 Jan 2022 15:08:02 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <20220112190802.GW2328285@nvidia.com>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <20220111004126.GJ2328285@nvidia.com>
 <Yd0IeK5s/E0fuWqn@casper.infradead.org>
 <20220111150142.GL2328285@nvidia.com>
 <Yd3Nle3YN063ZFVY@casper.infradead.org>
 <20220111202159.GO2328285@nvidia.com>
 <Yd311C45gpQ3LqaW@casper.infradead.org>
 <20220111225306.GR2328285@nvidia.com>
 <Yd8fz4bY/aMMk24h@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd8fz4bY/aMMk24h@casper.infradead.org>
X-ClientProxiedBy: BL1PR13CA0194.namprd13.prod.outlook.com
 (2603:10b6:208:2be::19) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23badc31-dd80-4390-7d6c-08d9d5fedbeb
X-MS-TrafficTypeDiagnostic: BYAPR12MB4758:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB47583EB1A898F1A64734834EC2529@BYAPR12MB4758.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Yo6SZQVA2CPpqVnNgOkxrfBaGHr2c21D0NC9wk5gapJYhJ8gjp8CVxRxD4q7Ae8r7fMMNTkS0szxN9IcqNXPIRyMqIWCCNBnyiHTo11wOlIlWsa6WST+oyyIYi7tAAz7NTVKk/YGONhb3pm+Np9pLrPVIeEmYWQrEACI/SNxNhu+n5RmEisBu5dXzqQ07LFEh6/VrrDiZGoZHhk7ECgma84mXpykI91LCMEQzSc2apbTfYwlPlDMbuTY4DsM5v4ZD/2E7lR+z1t3OKLuxC1MlXvo0rtjZP73m+SizT0pC4ourD8iaR62msVzG0nZaEHxyBz1YLDyrg8zV0BnAXdBMH135csdXoCCWH9YYUVqUSLXAGytbh2GiSSTl8BMIzRRHv4gxZeCtX4Xv9z4VtaRew1xfAVX4DseS5ZLqp01vFJqaMQZZS0whHrxwes+NTGVjQsD8rIiEA4lqPy3cWmg+EPJcHjgI3J0UKYUvAMUvccvfWjlE9IXw1sLvHUbOewE063+7oZRn8nL3RzdveFdBuTLM7d1DAnQhGmQTXc4f8xySrd4svZJHvO1hGVaqY3yLD3Ff0F5JcEyRF/x7zy7uoIr1MTj4ToIODk3VusGeYb96BIhUEtPobpA3v/CRR7/hYjhFhUoNTshuwhWKaifQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(4326008)(1076003)(6486002)(5660300002)(2616005)(8676002)(26005)(36756003)(66556008)(66946007)(86362001)(8936002)(66476007)(6512007)(38100700002)(7116003)(6506007)(7416002)(33656002)(6916009)(3480700007)(316002)(54906003)(508600001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c1YWNSZaBefjC0Af1SVBI4Jtp1KdAOTHiBjPcSOTe/NQwvRMEYTPSTMxhnCH?=
 =?us-ascii?Q?aZRxdZ5q30hXHcyD/QXIudXk13PUKo4/XuouJ/rriZuCEcN+qly/W+lU1Ju7?=
 =?us-ascii?Q?kG8gDycvdHhLAr13BLrogl4qqCOGzTy512pMa6JM+8DxxrOywUupJR3+FuHj?=
 =?us-ascii?Q?AnijFKCi/HtZYXF7nHogBtZ4nlpHKa6kDkQGgCm49Wor0na0Hwgep+Ioqsf5?=
 =?us-ascii?Q?h/Yh23BtIQpizP8H3NcsNMF9Amyh9YH1b6imjZb+9CzySyEUfcxq0944uZ5o?=
 =?us-ascii?Q?lnbT2n2YQJgPTOKaqxWYjP0HV9MVZmbzDr+ooaS/d5vHIXnRnHDILRNZbC93?=
 =?us-ascii?Q?GR5/Xh7gpqEQE3YFwiOvkFJibY2DtAJlbgUw4DKvdB9vzTiOD7iuV8tYiNiP?=
 =?us-ascii?Q?U7/kBr7H2HcMDDIeHLVpU7sH1jaOEJCi7a/9aWhaRA8f6O9asYzzjSnEHhQL?=
 =?us-ascii?Q?gXaC/5C2hArKEYfQzRAkMrU/FN9YNx3BBY5J3nucVUEJBpFL5lW0l8LNWsIf?=
 =?us-ascii?Q?iz9JkN0RYkB4nvsuNB8hHpWPmADh69a6O0rJO49sMPqqaH4KVcO/rYfPsK7i?=
 =?us-ascii?Q?dEB3cTCuMr3LvksO5eYn1L1P163/2NFEVlHNzyordCs+wG68teCi3vo3RBCt?=
 =?us-ascii?Q?S+/Mik3N010lQ7BQBuRINi9RYrM1YoHtGH5t758SfMlWcEegAkwm95Vuw19x?=
 =?us-ascii?Q?G9Rmhc52DTWSz6kSfJq/Gc8k+3BpEYjhHWmQAtMxDh2qAvaaVs9e/sNV8PyK?=
 =?us-ascii?Q?Gx4Q2RQ/LoTRj9xRFA538/mLFWYVh8JRWUt6qJY40xItkYuffCbDmelQxknr?=
 =?us-ascii?Q?fPIYkVaEY730wsJxXptUYzp7l5TbxGtyHVPofhLVBcKV/9UyZQxz0OVLm2Pp?=
 =?us-ascii?Q?gNIfZKbgzona3qY0WHnWg3IBcPrnoQx8xt6H47+c8AJL2kFpkZs626TYg9N8?=
 =?us-ascii?Q?nKfC0pr9upZLaCieL4Y+IvOrSc+zHwipOdm0x3rh0QtOpmK1QwRZzK14Eoam?=
 =?us-ascii?Q?0R51YNxPTd2tjhnMz2kmWiEyXXdQEpzMW/DObNe1aO2i1NNZFDRwcazTTmwV?=
 =?us-ascii?Q?yEem/GitOkIFfdkNp2Efao/XlcFa56WafC/nSOUPPO62mm1lXW1GlU5uvCZK?=
 =?us-ascii?Q?AEhNwt5LpBzWpaZFMgoG5vveTUeBDv3wE1jEAB8hgwNTJRcPBO1EcGgy/SYJ?=
 =?us-ascii?Q?agCxzsFPz26enfNg38H/vXZbnZiVyvhz6a9PX5mj1K/BeKxzJ0ovMpUhOaBY?=
 =?us-ascii?Q?Bg+sV8EgzJm56HJuWmJtXuS4xzuFpUaEYCXOpNxH1jT2pwIe7y7BuaUe5a72?=
 =?us-ascii?Q?pmik+PaBknwbx2qL7pi7QKQpZMVRp16Y7wV32nuRtbmz8i8P8QijZdYLV2RJ?=
 =?us-ascii?Q?Qzk/WeUNSdLgp8iNR4ogTJfa0IIvHaC8PXgMhUkGMGFY7dMRbdgCk3cr1X8s?=
 =?us-ascii?Q?Tm47DtMwtivLFHQ+AzPTXiCGKKxrzD/aIyC1CvBo2ZpJ4WlAwuR6q+A6YeLN?=
 =?us-ascii?Q?K2zeM6DNSTj5Dx6vtoCPHpsKRw3P+6wCq08tBG3VNQarnK/padcyezo0MkiC?=
 =?us-ascii?Q?vIZb2btY1EjI0HSo73s=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23badc31-dd80-4390-7d6c-08d9d5fedbeb
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 19:08:03.9731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5GLkHryL2CzDaabsOPJfAlPRYIAEbcZUUxUsLGIRKO6+/wI/bcwhPdH8OJOAo4dQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4758
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 06:37:03PM +0000, Matthew Wilcox wrote:
> On Tue, Jan 11, 2022 at 06:53:06PM -0400, Jason Gunthorpe wrote:
> > IOMMU is not common in those cases, it is slow.
> > 
> > So you end up with 16 bytes per entry then another 24 bytes in the
> > entirely redundant scatter list. That is now 40 bytes/page for typical
> > HPC case, and I can't see that being OK.
> 
> Ah, I didn't realise what case you wanted to optimise for.

It is pretty common, even systems with the iommu turned on will run
the kernel drivers with an identity map due to the performance delta..

> Since you want to get to the same destination as I do (a
> 16-byte-per-entry dma_addr+dma_len struct), but need to get there sooner
> than "make all sg users stop using it wrongly", let's introduce a
> (hopefully temporary) "struct dma_range".
> 
> But let's go further than that (which only brings us to 32 bytes per
> range).  For the systems you care about which use an identity mapping,
> and have sizeof(dma_addr_t) == sizeof(phys_addr_t), we can simply
> point the dma_range pointer to the same memory as the phyr.  We just
> have to not free it too early.  That gets us down to 16 bytes per range,
> a saving of 33%.

Yes, that is more or less what I suggested.

I'm not sure I understand your "make all sg users stop using it
wrongly"

I suspect trying to change scatterlist is a tar pit.

Thanks,
Jason
