Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D24E6628497
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 17:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237304AbiKNQEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 11:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237168AbiKNQEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 11:04:35 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1909FD8
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 08:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668441873; x=1699977873;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rhalCYb5j23CMSTLzyouWEjLQxs9k6V4/BChGN2KmrY=;
  b=mAqFDXXd+8qfADiTDa4R8fQgnve0ajam6oWfkRJG0D9UlwEB9K40EaNC
   +n1ZZnO3zRhWBF7yhIrOJ9li8tdBm2Bqwx+hWjDjhHOeV9sc/7qCIs6St
   yhi+Smw26FGJEWL4r8tPonYfJ0BWzROIcjXKipL3SpRVXn1sVAc2ZPmbD
   u7TGu2q6negVrx59/sHw9GgX4WgMTUbXobo9HyRXxHpMc9xzY4/aOwPin
   vc0DhCJCAymM9JfkDSePqawwep3L1l4ukyqQyFRocUW8WWk5Qmo1DEogR
   tQe8aDkt82g+3/OqgCMC404eSouf6j+h/nZMcizLOxKsS6EU3s3laJ39n
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="291721281"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="291721281"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 08:04:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="702057531"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="702057531"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 14 Nov 2022 08:04:01 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 08:04:01 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 08:04:01 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 14 Nov 2022 08:04:01 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 14 Nov 2022 08:04:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NjP3sSxw7ipd0Ol/jtss+YODttxRLaFPJ6IsUVbKd3au6oG1Kbqkq/Q5DfVZbmMZVYz5cQu0od9pfCadWxr1UFJp8v05Kx4aI71ZYWNynt4/Enq3nD12YPePQ5sv50JkYv9QSym54H18opDpINmFdcDADMbEHFSmwxrmTGo36qkr3h7Nt3K73KcH1yKCiQiHZiV2VGchp18kTCicY01kuH3/WAlFTkNk4XsLjDaBCEN05HdnarKLL0yWYeldBCnbk7qWE/2/YCjexPRfYSDj0fwtW1+Afgk5JovotwW4sAW4r8VcVHgKYFdzGb+ZqrqQFJziDPeV9/YEeDcJAQg0oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8IEYBkE2gdOaoNNYCakNUT1MsQyiFK5cNSfcLMJxBDA=;
 b=eJv5AU2t2762NxwZjGS18+tqROyaFqeX8uQhwouTQSI7mjz6E1e1TDnsrHk0nz6X8ozjLrmVvZN4adgYe82ip09RlVQFMFVuQ7pVfIOHTC7a0DSCXbuu3odXpUGPANZJoOKe0Z6LtyhiCsK+vtm3Eyio63pX6Yi2Ch3UF8OcqMcW6//fsaXzDJcE3uJFj/aZ4ea5D2KmgM0Xzul+u7VfpVOhAZPVKIRx/GYx50aHIZG9dXLchuJ6VAlF4pXc2AR615KdXmief3lX61cah+4sTdxtGnDYEp1TsNIiRDYeEwtl2qNDDlEqNM57x8igjgAmqMWZlhh18j8N83eKWT83AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN6PR1101MB2227.namprd11.prod.outlook.com
 (2603:10b6:405:51::14) by SJ0PR11MB4911.namprd11.prod.outlook.com
 (2603:10b6:a03:2ad::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 16:03:58 +0000
Received: from BN6PR1101MB2227.namprd11.prod.outlook.com
 ([fe80::b9e9:a694:2af7:6454]) by BN6PR1101MB2227.namprd11.prod.outlook.com
 ([fe80::b9e9:a694:2af7:6454%6]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 16:03:58 +0000
Date:   Mon, 14 Nov 2022 17:03:43 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Jiri Pirko <jiri@nvidia.com>
CC:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        <intel-wired-lan@lists.osuosl.org>, <anthony.l.nguyen@intel.com>,
        <alexandr.lobakin@intel.com>, <sridhar.samudrala@intel.com>,
        <wojciech.drewek@intel.com>, <lukasz.czapnik@intel.com>,
        <shiraz.saleem@intel.com>, <jesse.brandeburg@intel.com>,
        <mustafa.ismail@intel.com>, <przemyslaw.kitszel@intel.com>,
        <jacob.e.keller@intel.com>, <david.m.ertman@intel.com>,
        <leszek.kaliszczuk@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>
Subject: Re: [PATCH net-next 13/13] devlink, ice: add MSIX vectors as devlink
 resource
Message-ID: <Y3Jm36rYH4J1jSoc@praczyns-desk3>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
 <20221114125755.13659-14-michal.swiatkowski@linux.intel.com>
 <Y3Jepn7bxkCFP+cg@nanopsycho>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y3Jepn7bxkCFP+cg@nanopsycho>
X-ClientProxiedBy: FR0P281CA0067.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::21) To BN6PR1101MB2227.namprd11.prod.outlook.com
 (2603:10b6:405:51::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2227:EE_|SJ0PR11MB4911:EE_
X-MS-Office365-Filtering-Correlation-Id: c7067f4a-4cf8-4fda-5dd5-08dac659d5a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X9TcSOwWARcBueaEssSts9LvCpj/LFf7/ejfnmxjvMyfoYImJjXaUW+lYO0koW4Y5eatArlu/LL3DT6A69TvnOYg1PebfR+4cM+fbeui6PNllgC9OymbCTUJf+aDWRaasU35wofKw8GbLtHIaNg4reGZJmeD7GFW7j0eoDHRZKvFxuoONsM0+wv4U3YEAcppX7v1n55FczGrW5m7EQzMMZg4Ikw0olv8PTL9ioe283x3FR5K9vsPEhQYtI/VVSMCZI3ZWZyKmQbIjuWclVXwOu9RY/an1JisdkgZjiOS2CsE0z2EuHNJwizSHOWR785EYxzIdeumnsLsdOHDWEtHqpae+/48ed/7l1bAtGttnaOGQ8L8X8nehyiv7lfzP6nqtwRxAF2RRBR02nKCi6oPxHPO8jyRx0TUBdGRsi8cKv1ANJaipe/bkamooHpymgl9fIbQY0ulSu0c8Wz3rfLQAc0lZZkFZUOXYMYio7GVYgvovw7Wbku6U05SccEAnaLecFuHOnWHjOzSz5k9LAJdyoNT3mXTl9mXLSBR+7G4PMb3pLv+XvpRmd1eFQ7dJROOnv3ic6+O0giJ9sb8mtjiBZokuJyCe90pLg3xrvX5D/NNqXGlfmoQkfG25Fgvd9M2N3LBrPrrPo24UlABdAEjNFTh82x50xMpeKSX73ppj6KKcDUrrSMlXLk1v/ZFuK5jGFtUiTrrBpej8V+4T6NmXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2227.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(136003)(346002)(396003)(39860400002)(376002)(451199015)(33716001)(6666004)(82960400001)(41300700001)(44832011)(8936002)(38100700002)(83380400001)(6486002)(478600001)(6506007)(5660300002)(6916009)(54906003)(6512007)(9686003)(26005)(86362001)(316002)(66556008)(66946007)(8676002)(4326008)(66476007)(186003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VUaJOOeyq+ZF+VTsb1hNlhxLAAObfmxlacf9nDAMTeclWJuB1pecCYJegWNg?=
 =?us-ascii?Q?jnNmqNcgtOwHynypSJyvCitGPtw/dwrgvwYQPHjuDvrLw/WEKKf6UgT0ZhD+?=
 =?us-ascii?Q?px9NxpHhfcsmipMqOrDVpD2Lu1rtLagzFfq1nAKxY2KLOtXqWAvQvmqgDJjt?=
 =?us-ascii?Q?BOUPRcs5fvNRRmRA8IaIMzQOOCiNEh8IfRjBC86VxI3ksZsoIXSZxn3iZXKd?=
 =?us-ascii?Q?7Q6bum5GX7Z5RxvLThoHM3hfHeip8kBdv7mknW66IyJIgaaD5ndgOh/d9Edm?=
 =?us-ascii?Q?nrJv2v/FxPCg+EXuC7qSbhzo58j7r05MdbaCQg6C9X1yT+98/eqH2SADXq+i?=
 =?us-ascii?Q?jRylQxWyh4vTYmQL4At9h+5OZOJJGnj9l1aFmqGrvg+RpA4ObX/gem7xzM0k?=
 =?us-ascii?Q?+UWriFIU3tqHz41uSO+X7FA7Ty01UuW6dZYY/1TyZGgJejGQBuqmycPTZoG1?=
 =?us-ascii?Q?TdrCEwiB8oWy9CNDCcfGog0LJKaZ4JtSXab++e0mKUNZMJD6yu1DZAt4+dVd?=
 =?us-ascii?Q?7ZKR3CLy/OMoWfMl/NbwsjbsU/CqurKMJFxKzV178axDzUum+joaiU8Z7anX?=
 =?us-ascii?Q?orN89jpSBGMy+9LGzMMXauSzXUIS2xOpdyIU4AqULRCFYrVg0wIaO8S7lluN?=
 =?us-ascii?Q?3H3CwbXdmlL4dWQstGri3egOffwj7ajh2dRZBZUze+q+TbdipGXnep8u6g3z?=
 =?us-ascii?Q?xQ+Q7OOatGRMMY9uwowOSMRouq5yMlweJLUfrrCUS72grQDbRGR+9bV+zKoL?=
 =?us-ascii?Q?Oj45UXsyGTP8qCBslQaI66bBv3pQShf5lAwwtGukBsuDv98sQ+CPFOgHOhqD?=
 =?us-ascii?Q?ocge/RXG65zkB4LFsM8y3MieCqqtWEaiy4Ors0jH7jHTcO3LNpqLnKXzXv6w?=
 =?us-ascii?Q?rZshyU9o2E9A/B2rVAsiF8XODDIvj0JQEU/8AKh0ki76nHoCcz0jbi7ucgGO?=
 =?us-ascii?Q?3UYVcD+Mq/ArFmxCPFW/ZQd1f9Jb/0aXqxNdQyCQdJq60Pc2tXhMSuPjlXYh?=
 =?us-ascii?Q?cIDpI+AXZW6I05P+oD67fP4b9IY1lgShvAbBtg/zWIJnLOXTJhUPRB8plEwK?=
 =?us-ascii?Q?myvYeLU8z1qi5sbZytM5rrHDsTKZXxkT0gz53VeDlbhDoZ2lUk1M0uJnDQKL?=
 =?us-ascii?Q?6/UmHabt3e3QO9Hx3lq0D1XMt7A+9rNoISYIXwqTvUyp4uj89e7kC7kmy/dI?=
 =?us-ascii?Q?wYML/RilODyzoVEuf6FIiNFJksYSTdjgeuu96PUjHgD7GXBKzx2I0GY4KXDH?=
 =?us-ascii?Q?OFs+NHwtp110lQEPuT6k1eqS4X2Li7DDxN7xcvKSV1+NcbbqTw+PahFoerkf?=
 =?us-ascii?Q?dFW+ZNdZXWypVb2Q+A8ggl/4W39BQvJKXJEjZNmejvQjfL/tXHCRBc5yZkiE?=
 =?us-ascii?Q?4px3r+CFX9GeEmrNJEPfG5sjeIZAOVLQq7C+5pCidgxVc3vvvfdbrdVSyMEY?=
 =?us-ascii?Q?zkPeVMg8jES1lVjdjpMIWFAZHYj0ImyHBb+A/LAhHHB+KNdit+90NsKkicsY?=
 =?us-ascii?Q?lGHdogPp+PX0UvJFdmyfWPM7LUXFNbbKYaPU5FmvjWVAaxMenGl9qYxvFTs/?=
 =?us-ascii?Q?Ghi1/17ZpEs/7XIW6xA5LNwDQvzxVOgvGc4OiBVk12IJHWo2xioKTouteKG4?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c7067f4a-4cf8-4fda-5dd5-08dac659d5a7
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2227.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 16:03:57.8843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nY1MGaLfjVNfyJuou0Hsr6SsLWl88lm26sScOqkNtIXZm31ez3NmBU0TLqKa8wDY4/swa4s09MveRj7ovSwHQsT4a7e9L11OdJ2mfJ+9mIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4911
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 04:28:38PM +0100, Jiri Pirko wrote:
> Mon, Nov 14, 2022 at 01:57:55PM CET, michal.swiatkowski@linux.intel.com wrote:
> >From: Michal Kubiak <michal.kubiak@intel.com>
> >
> >Implement devlink resource to control how many MSI-X vectors are
> >used for eth, VF and RDMA. Show misc MSI-X as read only.
> >
> >This is first approach to control the mix of resources managed
> >by ice driver. This commit registers number of available MSI-X
> >as devlink resource and also add specific resources for eth, vf and RDMA.
> >
> >Also, make those resources generic.
> >
> >$ devlink resource show pci/0000:31:00.0
> >  name msix size 1024 occ 172 unit entry dpipe_tables none
> 
> 
> So, 1024 is the total vector count available in your hw?
> 

For this particular device and physical function, yes.


> 
> >    resources:
> >      name msix_misc size 4 unit entry dpipe_tables none
> 
> What's misc? Why you don't show occupancy for it? Yet, it seems to be
> accounted in the total (172)
> 
> Also, drop the "msix_" prefix from all, you already have parent called
> "msix".

misc interrupts are for miscellaneous purposes like communication with
Firmware or other control plane interrupts (if any).

> 
> 
> >      name msix_eth size 92 occ 92 unit entry size_min 1 size_max
> 
> Why "size_min is not 0 here?

Thanks, actually 0 would mean disable the eth, default, netdev at all.
It could be done, however not implemented in this patchset. But for
cases when the default port is not needed at all, it seems like a good
idea.

> 
> 
> >	128 size_gran 1 dpipe_tables none
> >      name msix_vf size 128 occ 0 unit entry size_min 0 size_max
> >	1020 size_gran 1 dpipe_tables none
> >      name msix_rdma size 76 occ 76 unit entry size_min 0 size_max
> 
> Okay, this means that for eth and rdma, the vectors are fully used, no
> VF is instanciated?

Yes, in this driver implementation, both eth and rdma will most probably
be always fully utilized, but the moment you change the size and execute
`devlink reload` then they will reconfigure with new values.

The VF allocation here is the maximum number of interrupt vectors that
can be assigned to actually created VFs. If so, then occ shows how many
are actually utilized by the VFs.

> 
> 
> 
> >	132 size_gran 1 dpipe_tables none
> >
> >example commands:
> >$ devlink resource set pci/0000:31:00.0 path msix/msix_eth size 16
> >$ devlink resource set pci/0000:31:00.0 path msix/msix_vf size 512
> >$ devlink dev reload pci/0000:31:00.0
