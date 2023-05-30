Return-Path: <netdev+bounces-6368-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A2C2715FCB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:33:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 101F82811F9
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A07012B81;
	Tue, 30 May 2023 12:33:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E69FBED;
	Tue, 30 May 2023 12:33:06 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49571A7;
	Tue, 30 May 2023 05:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685449960; x=1716985960;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wJIsJkCkiX+7Fk0sprrAv2Zsb95lgSdZOFi48+nt/hc=;
  b=nDOnnwa6jZ5mrqIKHMvHkeWbRqgmP41Z/Gr6EwJHBN7VJ136WHHG08XP
   x/cnfOeMsT8PJscqnTe3B6kh2Gd43i11P4sxZEniIBTltHIEWYf42jeIm
   Ifq51SbngF0E7DcescO4SjSZaPyUoiTtIYyipChMdCyDiIQSgZgHcuJu/
   RncTBBPDumaxTgNMl1co4infNBbyuvWLjYpCjD32r50s7iCUfIHg5+C8R
   eQvQ6NIAR6Zp+/a1eNvRwHS4QlCUmX4S023WsF3LAW0OMYIhbz7T9AOQj
   A1f6qIkxv1t/0euOASuGDNK1w5bKpdAZx6t+fUYTe7jasm7hgfLSW5g52
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="334521705"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="334521705"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 05:31:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="953114719"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="953114719"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 30 May 2023 05:31:30 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 05:31:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 05:31:29 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 05:31:29 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 05:31:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZ/AuBXMDE88z/ud8gA2hpM/tIzpTIuGBi1CEa/0iY9eEaHrOuQdQKIlXLZhGUsmJ0/Rshm62l+ajbTygLfQtMhGnyTTDm1jvP9f67iKO46EbtWD7vaNtU6LR1lVyeO/fSxYxng03M+3EFReKDw8PTu+8HqsPYqIYl+7GeDop7s2d1kOJM5EsnZqNlks8h1cVC7CGxbmzWROBx6v890rnsuN7Y84V5gFvpqv8Sl9whfV2NHZ3rXy9fU3V6IJtGN6Hwf1RO8N7PgDg3HAyJh/7fBjjAzt2YaPBsCqlUOkgS3wT3mCDQKKxZFlFPNHVuScM7L8ssUtCCkTThi7ogJBIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIj/ed3zuUMPi0ePlcValbi+nZG2Krh/chfpGWjY5RU=;
 b=ItdR/w7YFlfaOA7jQxzl+vVWIyI4QTPxx2QrYVQwrdDOpao8FuU/h1zr/jbVQxrXAbLBt0hTSSvkRMqQGggQ8buIc3DCCW8+gwmoH6mPsXLY0NYLWwCjXCOP4JCTiUlLI99BUcN6jryQeWtFngV5uIZycjY/JDdsk16PgTQcLUgqVkIxEthNuH/Bxv01otCcxfPG3bIo0YhLR3iA+2VWbWlg7MooLaNG1ARo8G7LQL8v2xaoqglRhggmMqPm+jGS9v6HOvSqA48sbtlz15wowxrawTDraKQlN/ccLANhBcSdDn7dQOXkWwJb+4sAbHd6GslOspsp8rM2/Qw5bymsmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 LV8PR11MB8606.namprd11.prod.outlook.com (2603:10b6:408:1f7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 12:31:27 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 12:31:27 +0000
Date: Tue, 30 May 2023 14:31:20 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Simon Horman <simon.horman@corigine.com>
CC: <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
	<andrii@kernel.org>, <netdev@vger.kernel.org>, <magnus.karlsson@intel.com>,
	<bjorn@kernel.org>, <tirthendu.sarkar@intel.com>
Subject: Re: [PATCH v2 bpf-next 13/22] xsk: report ZC multi-buffer capability
 via xdp_features
Message-ID: <ZHXsmDhfw9hxjUCe@boxer>
References: <20230529155024.222213-1-maciej.fijalkowski@intel.com>
 <20230529155024.222213-14-maciej.fijalkowski@intel.com>
 <ZHXkQX0uSh8tDFTO@corigine.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZHXkQX0uSh8tDFTO@corigine.com>
X-ClientProxiedBy: FR0P281CA0141.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::12) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|LV8PR11MB8606:EE_
X-MS-Office365-Filtering-Correlation-Id: fd791f70-2853-47ba-d2ad-08db6109c99b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DDopzqg0lXHWrNUdT9N6DcVMlGF3vdBIz2cFvsghMnTzxQq/ynalbAk84dwzCngAo9bwoRNukm7uE5k6ZIz/OL+djmYPD3ULG51VuqWPXr8wcMV497lszSoMyGYk9TEAoZTo+Dg2nBR5VRbvnCqnUgSH6KpPDQM7i8zjz39pFVpiPItN61xWEFT3UeOiI6JCJ1tC8Ui4iuR/3sfrJQow49LanZXTgUl9OElEIkbdKHXqWmJlFLbdAcWrr+7feez9A+yAr5BSWziMxIltz4ZABSmFrTNCL5CBy4KEKs9/l1RjlkTjTdvSAZxZCH5Kc6u2iJumi0UAbRSKQ1AIUOmTrhdKYGUNT0Hkw8WqvseV0fk0OWsc9pSO/N2DRG3KM/4pOyc8v+HqfRMwCz3xgMp5PDKSNKqcXVCetbWR0UAjoVahdyoOyxFg5FKBKZ97PzLMavwKaYtZ+3MsBvoptO+8E3DyJOppJuv4Yo3xc/yFYHb6aNWwL1vTdJnje2IxZEShA5CuJxlyxlfd15TfeVjY2+DRCnYiq4XEPsubdRvd31xMJE9wZQD+wxZjUDNXBdQj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199021)(478600001)(8936002)(8676002)(44832011)(5660300002)(2906002)(33716001)(86362001)(4326008)(6916009)(66556008)(66476007)(66946007)(82960400001)(316002)(38100700002)(41300700001)(186003)(107886003)(6506007)(6512007)(9686003)(26005)(6486002)(6666004)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nxy+ZBWGtRJLVml2aMbw5ej8ekTwDqINFBb6/wc6EibGDrjPacMHJbr9YLkl?=
 =?us-ascii?Q?q8Bx08pJhD2QXWmvejTZG3Mg0LQNPAIEXe/Q853ww9YSpbs0EyULBIxYErdk?=
 =?us-ascii?Q?z8RzgGixoARhFeYbBE6FIqXWfICdCsV8pn9wIyAgDD98loYMuwigDrmBbED9?=
 =?us-ascii?Q?rsqMe77g6FlDoH+ARP6nR1mpBmedTC38xhPJp83JKbvPlob3VHnE8wLAwK4s?=
 =?us-ascii?Q?0FigHlNKb7IqlrdLyk0+H017GMEgqOa6anF4r12tV6KaDaQQt0bREIGstcxk?=
 =?us-ascii?Q?ga35tVJhLiUY2ZupEp1oZ0V9tP745Ebt/kA4CARPwk8aX1/Ynvg5CfvUZRzJ?=
 =?us-ascii?Q?KUNKjBKgaMAiHTX3PSalpXkUZDbP9iK87cyfKyM4u0apd4x7FP459KeiRwf1?=
 =?us-ascii?Q?bYrnrhyVcu+h8zP0i61v4OAsBtXoiVPPfZwFKlqgqheOJMh01OCVUQymFYDT?=
 =?us-ascii?Q?X02MFcTeCCNcAx3w1BfrIoqy4x2SZYlNF5QSUZ3J4z6NlTT137B2/0+yqBnn?=
 =?us-ascii?Q?B/k7yI6SpNc4sDFx0v96v5lq7h4y5h1HWZ+lulOxttjrf6XKbhVbLRysWPUw?=
 =?us-ascii?Q?nkQYvkO41bX00O7Md9Y9MdIqaof89ojgOyzEZE8yjTgUVR9mRv+AaXA4yVJ+?=
 =?us-ascii?Q?8H73O7x7/b3Br8VtyyeX89wJGmDlwCNiaUpHnWP3vCpALsyFgwTEz6hkjFG1?=
 =?us-ascii?Q?z/+rlUetL3idGwNJ3KIKQwFnmlYkHR/+I5TrkB+oCLHM49ptMXM7w+KqRl7O?=
 =?us-ascii?Q?HGIpNqs+yak5AkT+HznaIT5iBjwDJSXuFeuUxwQryvBf3t/rxBIH143Qc5RX?=
 =?us-ascii?Q?aKkyT0I1wOt/2Jvtm9rj6Rw8F+B67WbriSbkuALiwL5E1JGNIYjZc3uDeBa1?=
 =?us-ascii?Q?gAf4HmfVYtEhqcFxTWuKoN07i4E1qAz5/gS5FDY+k4hccX+wpiDZjutkO+Hc?=
 =?us-ascii?Q?kuzQHqrNcXRPvvhIUlKP+gLh5TqhQZgO4JVSOYrB8YEa3Mn/wq+p54jODCrt?=
 =?us-ascii?Q?/45yZvb0EXq9dYMhoMIDbiUrwEtRvfRGHX7GlzG+TtnSIfJ4+Qk9AC7a+Z+Z?=
 =?us-ascii?Q?OwjYtUjeShVwjQ7Z2pW7cgI+uUKZt+0EFXaD1aZzY6SJ8YgTKyG35Fm7xF5Q?=
 =?us-ascii?Q?ddlORbNrM9g7ON3ZdGHDnx+Fo3zUusZ4MnwVDgv4NQYMiItYcrWd0Z4Ztocm?=
 =?us-ascii?Q?DfATo7RfPALXIdQA4ntrP8pTmu+HRd8bESQw/gqHPE3BVBYxppuWrL7ZBSH1?=
 =?us-ascii?Q?YRomVX5EhTsSarkZjMoJ1a7vYrGq088DmFuttnL2TYNPHum64rDWm48FcNs3?=
 =?us-ascii?Q?fWpPyA53TzQt0Bkl39D8isN9q4StdRumFHgyHEuD7k22mgnJiR3b4WlR+kb/?=
 =?us-ascii?Q?x9HtuYRidCf70LQ/ovftdKt1MW52ogEFi5gV+ImPV+f9H9FLQdtjiLubALY8?=
 =?us-ascii?Q?qFarsm3B8DlneEtGIYUGGNHFmXObZ063+6QTPR8XVkLEzXS6RGVN+Z20nOLs?=
 =?us-ascii?Q?Qu137DXRheFgegtB8HzTLYs6ZN9oMbEJNIoxUX6AVE0Y7eyXeH5mfL7Jm92h?=
 =?us-ascii?Q?tx+7woasgdxGd74rUde/NIuCsmX2S64ff2ss2IDw57MyaU1JZk0womGrKZ5J?=
 =?us-ascii?Q?9A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fd791f70-2853-47ba-d2ad-08db6109c99b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 12:31:26.9512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yvig4c3zzi8IeTlYQ+nLvyzCfJor2LTfDn9WEagECUGD0ZZRgmVewiccddZVA/p0sO4XfnhUKyJ6s3+Yh772CRGrXtm03yM5LDzlbxnx+7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8606
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 01:55:45PM +0200, Simon Horman wrote:
> On Mon, May 29, 2023 at 05:50:15PM +0200, Maciej Fijalkowski wrote:
> > Introduce new xdp_feature NETDEV_XDP_ACT_NDO_ZC_SG that will be used to
> > find out if user space that wants to do ZC multi-buffer will be able to
> > do so against underlying ZC driver.
> > 
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >  include/uapi/linux/netdev.h | 4 ++--
> >  net/xdp/xsk_buff_pool.c     | 6 ++++++
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
> > index 639524b59930..bfca07224f7b 100644
> > --- a/include/uapi/linux/netdev.h
> > +++ b/include/uapi/linux/netdev.h
> > @@ -33,8 +33,8 @@ enum netdev_xdp_act {
> >  	NETDEV_XDP_ACT_HW_OFFLOAD = 16,
> >  	NETDEV_XDP_ACT_RX_SG = 32,
> >  	NETDEV_XDP_ACT_NDO_XMIT_SG = 64,
> > -
> > -	NETDEV_XDP_ACT_MASK = 127,
> > +	NETDEV_XDP_ACT_NDO_ZC_SG = 128,
> 
> Hi Maciej,
> 
> Please consider adding NETDEV_XDP_ACT_NDO_ZC_SG to the Kernel doc
> a just above netdev_xdp_act.

right, my bad. i'll do this in next rev but i'd like to gather more
feedback from people. thanks once again for spotting an issue.

> 
> > +	NETDEV_XDP_ACT_MASK = 255,
> >  };
> >  
> >  enum {
> 
> ...

