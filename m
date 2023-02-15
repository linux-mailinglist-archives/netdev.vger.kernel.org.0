Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB89697B8A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 13:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbjBOMNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 07:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjBOMNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 07:13:51 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8972B62C;
        Wed, 15 Feb 2023 04:13:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QmK8tNhJsSjadJJJVK2z1Ak402xWoBDB/RWK4O8nOmA9bENhmffRFtTm7udZrE6oGmd2AS7b71cM1BswORrcGSi5ispsmU0AkaUdhknjgiE3d8W2VvShIRZZAmXkgLiMfoXXC9V28ZZSqoVKii5B+VfZLXG8o4sLnSEUMoiO5FLxOVWM/hh68uFNJemSFqXUyJ1HbKWT2TvQGngwRrJ2awKYk8NGKWHSOLyNrUiHFuwBfYIWhtQ5x6uIM14B7Mo5SPw2I4dfXa63Br9WftFTWDF1byWbnkYn0yiVlp+pHe0LTv2mfl7dJEIXouEtOGcsPecFJCrPoXp/IZioaQgEaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k5rif9qcyLwCt2Mie9kClmEw8hCre0+8MYD/Z0zeuco=;
 b=QlGd/8VPkbe8idD6K0xLxErBPlRmv6K4MFh4FuHAYAcfTUQ0zWcZpvAhftgPdp6U7rajr3QZ88jMrRtq7rIGvnHyq7LBGWmusvGBF5LKsaLlZk68iIgbyfETFNemzvIaeXjmY0gdd1kgFmXWobKx6Bs7KeIsXrwZOpODvGqndWTD0wf3LH/05MK3TE/cnUsAKtZk300Q0KaXeqtfESkA0mQdGPc9ltV4l6ssZWg+ti3N2kRUXtVdhIhfaCEuzmfDz3AjEFnquiwVYJ9ZqdTCiWQKpIyaXvWFk0XppYFr2igayff26d6nBhuoPZpuVCx3A5qtbAc9aEA7HXLiW/rJQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5rif9qcyLwCt2Mie9kClmEw8hCre0+8MYD/Z0zeuco=;
 b=UbFn5sJqEO7OYtLb0MEAIMeqU6IsBA9u/rnEQXFrZ5weL6LmCgzJYEXv8kpr//MC8bPiMYuMBsxie9Yq9fQ+LCe7Jo2383cMogIbAODAc6Ko7l/KDb+2n7LwJ7MmmJFmIyEZ+y6FrMXtxwnLO3kpOe3PsSc5AAB3LlCpr+88sygQwWN3gA+Y8O0A1tt7CskUe9f0NAnrNgC0tQEaCUASOk5wiugcBVlQtrIr0Wt0f3J34JOAaqAEpFo26vtbHl1kJowQa+CuQdskPQoxfvPFVJRSNZn4+haDjm8/e37s3TZZsSiWmqSGnaHPPAHBsy9/Vwj+dwEykT0hs/H2SSfvuw==
Received: from DM5PR07CA0090.namprd07.prod.outlook.com (2603:10b6:4:ae::19) by
 DS0PR12MB8317.namprd12.prod.outlook.com (2603:10b6:8:f4::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Wed, 15 Feb 2023 12:13:47 +0000
Received: from DM6NAM11FT098.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::2a) by DM5PR07CA0090.outlook.office365.com
 (2603:10b6:4:ae::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.27 via Frontend
 Transport; Wed, 15 Feb 2023 12:13:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT098.mail.protection.outlook.com (10.13.173.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.12 via Frontend Transport; Wed, 15 Feb 2023 12:13:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 04:13:37 -0800
Received: from localhost (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 04:13:36 -0800
Date:   Wed, 15 Feb 2023 14:13:33 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     "Ertman, David M" <david.m.ertman@intel.com>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        poros <poros@redhat.com>, ivecera <ivecera@redhat.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 1/6] ice: avoid bonding causing auxiliary plug/unplug
 under RTNL lock
Message-ID: <Y+zMbR7aBs8tQrrN@unreal>
References: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
 <20230131213703.1347761-2-anthony.l.nguyen@intel.com>
 <Y9o1wbLykLodmbDd@unreal>
 <MW5PR11MB58119C1D62DAC020FB32ED00DDA29@MW5PR11MB5811.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <MW5PR11MB58119C1D62DAC020FB32ED00DDA29@MW5PR11MB5811.namprd11.prod.outlook.com>
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT098:EE_|DS0PR12MB8317:EE_
X-MS-Office365-Filtering-Correlation-Id: 9783e679-a604-4ab1-2d4c-08db0f4e1757
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VV/8sgC45cPlfx8Pj/TC7JGHiG2HAj1cFHWz+Dyrrj5mD/CuoH+AYIjkFopcIBgS7Ee/6jjX9hgKxYXn0dMZ4Xmq3646/OQGQOMQnlgznAgQTshzMrkX08NtGtXJU1G8LzMxey5Mg8UD4TXe2J/VKKGD4PzLqTbFR/QUayu03Uj4UmYxsg0NFZDxojSNbKyMbWcc0XqL5vyXG+lJ5Bdm0zoyypOnLnSjZ7N6OKIk2Qv0Qlk6Q/XsRGgf+586OmcedG9Y0vXV7UYqo6hvqzFznqeT+/tlbMOBWQ6BwjSbxjkLS97xaJRpfu14tX2fkwJXGtZPZzXgoZ6wyJX2YC9ILdkxjIjQ7u7GfhupZ3yQXjWl26x0KBsgLHWfNsQGwKNJ3Mn+sz/COXTotd9xVc0lC7d+xV/b+oOFO5aiwQhpWAUTOBt/gKrcSBL+cP8XE6HULLxLbG6aR8LJa9pF3S/YhqYpa5JwROpTfCNk/ktx4BYvuJ1WekUOHzIfLb2t1dCS1hwFUL+tuCyhUkH8IICovb1s/tmxFgMVsmXRmbFM2hxQKmsWI0PLLy1ATJoLKfbHDA63q+OaXkHvT+nUOv0jQpIhEwdRptcQkR7vZ6L/gcP1ppjCThIx9RGp5KRP/hnvLJsQoHsc3rZ2PTIPBI2mtMsxQDIhy+k3l6q/2iKZMkvAeKUWQTmPDD/TqQznFAGN9nLBMw5TwMXX+DYPdPZRZNkuxgBIm7OiXwejLEYupVthJ4eaUxdcwrjyWbbZ3MxHRn/JoqSDMRI7UQn/6RVDjw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(7916004)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(356005)(82740400003)(7636003)(40480700001)(40460700003)(82310400005)(86362001)(33716001)(54906003)(8676002)(70586007)(336012)(70206006)(4326008)(6916009)(316002)(426003)(478600001)(6666004)(966005)(53546011)(47076005)(26005)(186003)(9686003)(5660300002)(2906002)(16526019)(8936002)(7416002)(41300700001)(36860700001)(83380400001)(67856001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 12:13:47.5105
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9783e679-a604-4ab1-2d4c-08db0f4e1757
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT098.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8317
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 10:24:04PM +0000, Ertman, David M wrote:
> > -----Original Message-----
> > From: Leon Romanovsky <leonro@nvidia.com>
> > Sent: Wednesday, February 1, 2023 1:50 AM
> > Subject: Re: [PATCH net 1/6] ice: avoid bonding causing auxiliary plug/unplug
> > under RTNL lock
> > 
> > On Tue, Jan 31, 2023 at 01:36:58PM -0800, Tony Nguyen wrote:
> > > From: Dave Ertman <david.m.ertman@intel.com>
> > >
> > > RDMA is not supported in ice on a PF that has been added to a bonded
> > > interface. To enforce this, when an interface enters a bond, we unplug
> > > the auxiliary device that supports RDMA functionality.  This unplug
> > > currently happens in the context of handling the netdev bonding event.
> > > This event is sent to the ice driver under RTNL context.  This is causing
> > > a deadlock where the RDMA driver is waiting for the RTNL lock to complete
> > > the removal.
> > >
> > > Defer the unplugging/re-plugging of the auxiliary device to the service
> > > task so that it is not performed under the RTNL lock context.
> > >
> > > Reported-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
> > > Link: https://lore.kernel.org/linux-rdma/68b14b11-d0c7-65c9-4eeb-
> > 0487c95e395d@leemhuis.info/
> > > Fixes: 5cb1ebdbc434 ("ice: Fix race condition during interface enslave")
> > > Fixes: 4eace75e0853 ("RDMA/irdma: Report the correct link speed")
> > > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > > Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > > Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent
> > worker at Intel)
> > > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > > ---
> > >  drivers/net/ethernet/intel/ice/ice.h      | 14 +++++---------
> > >  drivers/net/ethernet/intel/ice/ice_main.c | 17 +++++++----------
> > >  2 files changed, 12 insertions(+), 19 deletions(-)
> > 
> > <...>
> > 
> > > index 5f86e4111fa9..055494dbcce0 100644
> > > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > > @@ -2290,18 +2290,15 @@ static void ice_service_task(struct work_struct
> > *work)
> > >  		}
> > >  	}
> > >
> > > -	if (test_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags)) {
> > > -		/* Plug aux device per request */
> > > +	/* Plug aux device per request */
> > > +	if (test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
> > 
> > Very interesting pattern. You are not holding any locks while running
> > ice_service_task() and clear bits before you actually performed requested
> > operation.
> > 
> > How do you protect from races while testing bits in other places of ice
> > driver?
> 
> Leon,
> 
> Thanks for the review and sorry for the late reply, got sidetracked into another project.
> 
> Your review caused us to re-evaluate the plug/unplug flow, and since these bits are only set/cleared in
> the bonding event flow, and the UNPLUG bit set clears the PLUG bit, we attain the desired outcome
> in all cases if we swap the order that we evaluate the bits in the service task.

I afraid that it won't make ice state machine more understandable. :)

Thanks

> 
> Any multi-event situation that happens between or during service task will be handled in the expected way.
> 
> DaveE
> 
> > 
> > Thanks
> > 
> > >  		ice_plug_aux_dev(pf);
> > >
> > > -		/* Mark plugging as done but check whether unplug was
> > > -		 * requested during ice_plug_aux_dev() call
> > > -		 * (e.g. from ice_clear_rdma_cap()) and if so then
> > > -		 * plug aux device.
> > > -		 */
> > > -		if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf-
> > >flags))
> > > -			ice_unplug_aux_dev(pf);
> > > -	}
> > > +	/* unplug aux dev per request, if an unplug request came in
> > > +	 * while processing a plug request, this will handle it
> > > +	 */
> > > +	if (test_and_clear_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags))
> > > +		ice_unplug_aux_dev(pf);
> > >
> > >  	if (test_and_clear_bit(ICE_FLAG_MTU_CHANGED, pf->flags)) {
> > >  		struct iidc_event *event;
> > > --
> > > 2.38.1
> > >
