Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB6042FCE7
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 22:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242980AbhJOUTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 16:19:04 -0400
Received: from mail-mw2nam12on2077.outbound.protection.outlook.com ([40.107.244.77]:52128
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242982AbhJOUTD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 16:19:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YaS9a4faCjJdaX6R/euAYgl27CollGQjerpPBgsT06kTDLovvFQe1SxLqs0WWCey0bpR1/H0lOYd89B4jKbFqvGjSrt3O10JwTYxTGpVQwOjnzRqophML89Tivjx5onJO+2i/xqrORDtV2t7h8RDcrvJ1IWotJ6j+rT6Mnk/xOzhVSmq3R64C6oqA3u0NowwwxXsWMYFtDaJ+YE+2Nm8sue/pyOmLcHD5Ty3RfwHaoOzB/EsDusOEwaMWXP5umKgD7N3xcO+HuXcuS1dG5RQHUmzyGmgiDgZk9gfSvtt4x5biT5syQyO4AxIV/21fBXkqAheJRghfgvghEbiFyKbgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a74e9vDuyMopsus0C//13ZIYldxfzgTNcHefTnn+2Tk=;
 b=L1j/H/yQOWE8wlYaJc2jvmKA0/kq67EdQZXLPDRHWkSqUCg09d9y2vY9ahwsT1gIa+yYlwMuxJN4tIshL36WCGOb9czN6QqdHD9Lqb40dxqxX107p1mWl75L5bYw4QGn07bXBWZnngXY3YMNEIub4Bllwo2Cvq5HBpeqChOSfdoqZSVdDyCvTpeNaYBOqBEIBHAL1ibbuChnfkgs4yUyJ2gy0/Az0uxuicbuPhWsmILJItqCqZLrwjDYcQ8rXVFpi1lVZxTUyHtp3yKK0RQzrwk0paon57VuntR0eOpWsmwbcZ0QiSK+XPFvGAPYAmmVtdJG3qG1o3PHN/8kvLF5fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a74e9vDuyMopsus0C//13ZIYldxfzgTNcHefTnn+2Tk=;
 b=sb/OmF2jYKSroBjcy5w/+51qf2joHKaPpr5H+g9qVFfN9khbR/gl1yKfgAqjCKvr4tT3y4TQS6xi/WR4mysmX9wopL3XWxLBPCM2qVKyR5LZv0FycU+Iw/blnhvP6rG2YESGDGTCetX82Z+UqpIuWBvK31wzhNEuvHkcnZEk/pthnOOwg9825ByCKAHU67rdLo+CuSnBif2LtI8zaYt7OxQnaNbFnoSy/vRSoCBf4PoS+CXkKRvtaqZgg0faef3XshNKIcd3299PmDbn/TXVRnVb4DWp4Sdlt9VYCagWqktDLrpvS9WPNaaj9dgpz07foDQ2hz1AoUIj7Ws6T5JQ6g==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5507.namprd12.prod.outlook.com (2603:10b6:208:1c4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14; Fri, 15 Oct
 2021 20:16:55 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 20:16:55 +0000
Date:   Fri, 15 Oct 2021 17:16:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 mlx5-next 11/13] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211015201654.GH2744544@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
 <20211013094707.163054-12-yishaih@nvidia.com>
 <20211015134820.603c45d0.alex.williamson@redhat.com>
 <20211015195937.GF2744544@nvidia.com>
 <20211015141201.617049e9.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015141201.617049e9.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0119.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::34) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0119.namprd13.prod.outlook.com (2603:10b6:208:2b9::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.10 via Frontend Transport; Fri, 15 Oct 2021 20:16:54 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mbTdO-00FTce-Aa; Fri, 15 Oct 2021 17:16:54 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 039a99db-8ef9-45b4-2ee9-08d99018bb8d
X-MS-TrafficTypeDiagnostic: BL0PR12MB5507:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB5507F255112E0D9EF4B3CA63C2B99@BL0PR12MB5507.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: avj3qIvmvr/SqmRhgkRuCzzgGOQxUbcoIy9HvLc4RhCLM4jHM0OszEGdFBaaJySZoB7ZWNm2Lnygw9hxIpdJfsQu/xgCTI8h+QEz3+GRuEcvD5hTHQ3nzCNw9dX/lzF8x73GpC+5jsIkvlHeB6hb1wqlbsxMH51T1/FcDWZEY4rIo3BllYJ0LPO1U2rruUz4fPvh4jiSOT4f6OGc9JXUhwVaXvo+418u6gIwCoKtq0oWGe0T1XzYCWROGEwMuIT0zjfMQFumJfCC/QR+QPmLVUXu+ebkI3ZV4bBZ5QeOs/+1MVwICl05OBabdM7nfPGNTsbCVwcgnwHGx7Q3jtA6eJ/JYnz43+qeQgorl/zIKdLtWAG7opKtpHefDUFZLMVrlZ/xf3sn/GjYXMmHLHmoLh3bSbut0de2gVMjhm2Vyq3guq8hAaPd5XYBAzAAjp+ZcF6++KvhSFMguHh/+fPRhQAC0+ohEOS8PHzX98g1iwvJVxnteaL0r9O0+36/vLVstLmFkc0ailPYWHw2Wnok1zFFvOKDkImyIhx9CLCBPoi6r+8iJmFP6uYwSpmuB/aRcAzJnLakdL0rkUfjqisJCV3mykXKZTEGQ7PLprjr9saPD1z312nCj66KAh7C3Wcyit0UTwIk/Q2K4X10WcZd5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(426003)(66476007)(2616005)(1076003)(66556008)(66946007)(6916009)(508600001)(107886003)(316002)(33656002)(8936002)(9786002)(26005)(186003)(2906002)(86362001)(5660300002)(8676002)(36756003)(9746002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fu3A4ujYnK3uj9eGH9PZDwbXzPv+7dPDmCCTN0Zjn4PUhoM+XVTmmphYw9UY?=
 =?us-ascii?Q?7du4v3b4bNG96r0QuK9pk1CFM8kiucnPWmlYhO7S4nKBHR507ySiL+i73MhH?=
 =?us-ascii?Q?BrOjnVlhxMcx6tUmGBDkypfovcWdOjFooGXmm+h/UxhNxEjsNG/f0FuQkUsu?=
 =?us-ascii?Q?L10W/2X0ia5EzzTpl4Ef0C5fGHm15GJ4ZYcfgpU5H5as6KLMFyGd8kRT6gJV?=
 =?us-ascii?Q?EV19Z63KcQz8bSCAn0NrfTPsN1N2LLkk6Yaq63zdgq0HRBOLp9LhRpoTWMPh?=
 =?us-ascii?Q?AVOYNXWb2NtC8VrqMukauh2RBW6xIlV3YH3ejYwpq5GHMzbqYXUEzr4FKIKo?=
 =?us-ascii?Q?G+0LTwejHi1q1RdJ7Ccz0vrqjwj0plr/jO+rmm/VDsqY3kAN4tZlqyfD7oEU?=
 =?us-ascii?Q?oPaWjRBTsWhVGgdcPZN5QhBLRbUdkL/DB+go0sWyD7VqaVS9i7OAxIkK9SWc?=
 =?us-ascii?Q?COdNF1LBJQPavfXx+3T2IAXhsZqMsXnVgjhMo8e9t9otP/sQx4xKXCemo8Gg?=
 =?us-ascii?Q?89xztDXI8XRkHt5ZgfFE822WI1YpFTaZ1vFVjwIC2t2pKtqLnOYtlbUoaq+f?=
 =?us-ascii?Q?4kyF9heSCCsktZZ5by3TZXbuuFKROGJTtWyTEXInpBqQDU8tmts22RYUYJM/?=
 =?us-ascii?Q?+Y0xRnV1sjEK89u6ztP+ivq4K8ljgG2Dw+Wde/jZG2pA1ivgOhzdYa3jxg9R?=
 =?us-ascii?Q?7mbfrRTrfat996/A5uxfLAUL7HGBvfyl9Qnw/oOlY9sgwbHmkqhixjdLC1v+?=
 =?us-ascii?Q?FRIVLP/HVANsrab0BDw7mlnYCWhQCcp+/gDLHvD/tFddankYFpbAB1rJygnw?=
 =?us-ascii?Q?vdz7kJI+VhQW5X+ALm4U/oo3/19Ss0kmdVs8zLq5h+JSa9rsg5KpsZdbQ2yD?=
 =?us-ascii?Q?vsCG/H6oqkDo+dtuq6af+UfyPwzYSS0DUhQ+2pl0YVlbto+N26Ep8FfTbFNK?=
 =?us-ascii?Q?TAjEOyfg/TUDpwJtUMjbE+QGHYy6TQfYJoIcDby3KmavWMAgZAxxOre2uPiG?=
 =?us-ascii?Q?vfvK5S2kvZASNVXKEUbDbnZx0IV2qPOoqYSH6s6AZLgltVZ8q54hPAMVhIUL?=
 =?us-ascii?Q?REVQPYaVHVIN/L8+W/8oA9RlqFYFBlNV+bCXtIa9z5lb8fjFrCJ7fZ5YQfKF?=
 =?us-ascii?Q?bdFbgKftYxDnRheCCGd7/2bJaujueUizKRJDNtKIRil1fn2YvRGvMRuTR3Pz?=
 =?us-ascii?Q?Sggv5IQML70cZWw0eLHhIBu8/BvbzuOUFIrTS93IFmJkk4W7J7XVf3wPHoPk?=
 =?us-ascii?Q?SclHKhFLLrB7iZlE3nZ2rBr0rBRlSnKz24T9iDlSLBHipx1Elcv4Zby0ZKRA?=
 =?us-ascii?Q?7WysTE0w9qXQSlZeuhqOfRmL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 039a99db-8ef9-45b4-2ee9-08d99018bb8d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 20:16:55.1007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gGP0T1NPgjMvOpGCUGMx2V8d9VXTfaXiBFJJMHnsM6JSaxET9YARUdr/NL+tf3Ms
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5507
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 02:12:01PM -0600, Alex Williamson wrote:
> On Fri, 15 Oct 2021 16:59:37 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Fri, Oct 15, 2021 at 01:48:20PM -0600, Alex Williamson wrote:
> > > > +static int mlx5vf_pci_set_device_state(struct mlx5vf_pci_core_device *mvdev,
> > > > +				       u32 state)
> > > > +{
> > > > +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
> > > > +	u32 old_state = vmig->vfio_dev_state;
> > > > +	int ret = 0;
> > > > +
> > > > +	if (vfio_is_state_invalid(state) || vfio_is_state_invalid(old_state))
> > > > +		return -EINVAL;  
> > > 
> > > if (!VFIO_DEVICE_STATE_VALID(old_state) || !VFIO_DEVICE_STATE_VALID(state))  
> > 
> > AFAICT this macro doesn't do what is needed, eg
> > 
> > VFIO_DEVICE_STATE_VALID(0xF000) == true
> > 
> > What Yishai implemented is at least functionally correct - states this
> > driver does not support are rejected.
> 
> 
> if (!VFIO_DEVICE_STATE_VALID(old_state) || !VFIO_DEVICE_STATE_VALID(state)) || (state & ~VFIO_DEVICE_STATE_MASK))
> 
> old_state is controlled by the driver and can never have random bits
> set, user state should be sanitized to prevent setting undefined bits.

In that instance let's just write

old_state != VFIO_DEVICE_STATE_ERROR

?

I'm happy to see some device specific mask selecting the bits it
supports.

> > > > +	/* Running switches off */
> > > > +	if ((old_state & VFIO_DEVICE_STATE_RUNNING) !=
> > > > +	    (state & VFIO_DEVICE_STATE_RUNNING) &&  
> > > 
> > > ((old_state ^ state) & VFIO_DEVICE_STATE_RUNNING) ?  
> > 
> > It is not functionally the same, xor only tells if the bit changed, it
> > doesn't tell what the current value is, and this needs to know that it
> > changed to 1
> 
> That's why I inserted my comment after the "it changed" test and not
> after the "and the old old value was..." test below.

Oh, I see, it was not clear to me

Thanks,
Jason
