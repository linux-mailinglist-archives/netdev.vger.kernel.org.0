Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0041062CF44
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 01:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiKQADW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 19:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiKQADV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 19:03:21 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C8B5E3C8;
        Wed, 16 Nov 2022 16:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668643400; x=1700179400;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BL5e/LgoBxQmRzg1PGPBNia5Xk32f8pEooPsjW82czA=;
  b=Rx6lEOi1WWv1NeXjNH6E3g5IlLmK2p1tx5/yKAiRa0KPEdM3qM4OH90H
   Bc3TLRBJZu7Hr6x+ptR65XUigZ4O5Q+BkvS7yYbRVCIh7k33rPUNGvbxw
   gyOUA7BFqoF9FczX2pElVn6Ho2AW56plDEMLbBjpRe6kzmIU8PYppx7hK
   rvxf3yYTxjlbDGWD+dZmnnKjVOpK9+x90AT4HPE/c3bm9n+v6KWjEwveH
   0rZaToEbn1nX0rkUhbHd1M5unPBnHzjrQ5+yQNyhxOPReZsxZOOMxZf1J
   qkdBPrCOHhPnBtUpSWonBf95CbJEqvKFAMX43t8SgkKKiTe2YgWR1MpSO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="376971102"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="376971102"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 16:03:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="745277102"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="745277102"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 16 Nov 2022 16:03:19 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 16:03:19 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 16:03:18 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 16 Nov 2022 16:03:18 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 16 Nov 2022 16:03:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXNXaz4Dma/BYsKtMo38jUKpqPfgIWnafMBJNjTSvbljOUbMMU+690TYoovXY2Zge1SmJfdh7MZhiP+2whFKH3Ql/ls6adTkSS/vUOhghKsW3GcxDrMSw2BCg64KdyePA7USk/a3wA6cHCnsK0yJnzs4cYwjDQ4wiifX40RucpUmIkCqiD/K9eOBhezFizLpx3eElRh43rRl9kJzWgmzScOSY72Uq4LNHMeHRv83/kthOQoTFVF6xclkEsaYzmttmSQrNS09tBPlBvwokopDqKrvbAqkkyxURS6fcjbIE5aCO6NkXJEKgEXbP052DNt4YVpjEwOOAPq1HbcM3F1gZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pmRPgUqHWFXth+1zuf54neakysn7D248pnM0w7m2DFw=;
 b=FCjnw0Ckd7vrRgErlsYvl5dCd8hH9TxgGDnibwzz/Rr/J7kKo7NRFlM2UR52Tz9LSlKSFxx/IzrkVpiDCQc//b0YBfTQVSYFw4vi9jrsmt8c/4PTzpQQtPSP2t5hjGW9913UV7u7w+b04zHIziamB+LLYdQCxymCfS+j2U2wuALllWcj2hWhqEQBANTBXOj0Ij7Wfzw3rPitwtWiHlMhgY1BZs3ElHGhZwa0kZdvcSCizof35h8eHAc7FwBmGMynBvoL7TuuYYg6N9RVMouUVtF5bIDe4DdTY6BsiSJ+Q0PIFwU/OyPn7M2ghTLvBHTog/qx1m5QsYBOU3GClvFtpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DS0PR11MB6519.namprd11.prod.outlook.com (2603:10b6:8:d1::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.19; Thu, 17 Nov 2022 00:03:16 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%5]) with mapi id 15.20.5813.013; Thu, 17 Nov 2022
 00:03:16 +0000
Date:   Thu, 17 Nov 2022 01:03:04 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <magnus.karlsson@intel.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <bpf@vger.kernel.org>
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2022-11-14 (i40e)
Message-ID: <Y3V6OLY6YlljYZFx@boxer>
References: <20221115000324.3040207-1-anthony.l.nguyen@intel.com>
 <20221116232121.ahaavt3m6wphxuyw@skbuf>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221116232121.ahaavt3m6wphxuyw@skbuf>
X-ClientProxiedBy: FR3P281CA0098.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::14) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DS0PR11MB6519:EE_
X-MS-Office365-Filtering-Correlation-Id: 8642e79c-d1b2-4eb2-7274-08dac82f20c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JwrcB3N82VYI7nUARV+jc58DUH6pycJqQVQlA1IHi87qSEQMEDAX+l+KyrgDO+ygvD2hJ08hjcC3VuEz9RatKTREfyKQ8VFk44eLQS4qVi4QhulUhtHbdAj0Swf81QzHPBY6y+LmJvdypQsggHJaDCRufyPbzobeEFVsGgD8101iftGr6ZlAzVJd1X3Q9p/bSVSf6FP8+J3Yoby7s6Hn2Seb7pkXuN1CBfMB59GO0lhInrJdbgqWdp2/W1Sz2yv3lkxZKb1E4Gf08znSxTU9zbo+eCkS8qpIXsd0UAZ7jowJt5xB8i6O/Ll2jtz1y+lFmVfALcYs9lZP+1hQA2Zb2uaUuSv+9MGr45cDJ/rqh2rIPDbtY6VcCcFElJAtjyJKi2bWllq4yraty/ZyWa3Gv4G2oMi9WpOEwC5pPVZfQlCkotbXaOnLBEC9Bc6abVe8/pZ6XbyecoGV82SzAeXP/TpxsJvMfyQToFv4cR/fyP1CBzY+fzQhyKw2wI2YT6jG4ELFYCfjE8mEY7jRCnU4HLAAPtoYGvR0jttNnvIcr5jvY5LFyF3Uww1bmzE/Hi+rcaBnY42eObGIC6z66I3xXzADvtMGpBCl5/5C3hgz9OsVSQ+gteEm2aDG86FFhixFC2y5uXDh/LFMWt4H7WYZRcmFhERmQVhYv1NG8pvTa9qsCOwlrNKlIt7QWs31mlK+6XxmDTnWshoHOgHbNIzTOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(136003)(366004)(396003)(376002)(346002)(451199015)(316002)(6916009)(66556008)(66946007)(4326008)(66476007)(8676002)(6486002)(478600001)(82960400001)(15650500001)(2906002)(5660300002)(8936002)(7416002)(41300700001)(44832011)(38100700002)(86362001)(6666004)(6506007)(9686003)(6512007)(26005)(186003)(33716001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JF/RAk7mr/a8iB5HQEdmZ2vgVz4noTUpXyKm4AFmy2VZKlBWGSjbolP7//Ml?=
 =?us-ascii?Q?O+TB6egKqOUwxG0M81MBOgXE3CamWtLbPAhcJYCLv2HbfNt2UikDpgKhiqk+?=
 =?us-ascii?Q?L0j+WV228LUcZGC/U7KN8gawO9x8kVQOVMUg8lWr2xcjGbDtWWuYahEjCTg5?=
 =?us-ascii?Q?/UBSyaVdBWKMpj/lPWoP/nkeA/6cNgMGi6eQPw78JEBKY+0cVUvUK2haXvDs?=
 =?us-ascii?Q?H4qVifBuqN5fFjMvGNTTOhhFqU6TWyOuZxgCqcIcpGujkUMcUU2GCAs5CyWE?=
 =?us-ascii?Q?ElRnkd9DS/owEds3GooaHtw0YayXeXOY1+ITBHBiC3rfqq8KD63YD/gfutyI?=
 =?us-ascii?Q?RZaKsTpEUb4LzfOtQoH/fNr4uMQ9Qh9QMc+y21nlL1IB7sgEf7shSAsZ2vaQ?=
 =?us-ascii?Q?iYs6cOdNR9+pHSfsjNt2949lC2YldjkY2MsCsDepVGfXF94KRWqEAmLLxSVW?=
 =?us-ascii?Q?E4a6ZFasAjbeghXQmdEzknJdA+Q412PUyF6HhSqg6Ker66yUfEnAQpOzblcA?=
 =?us-ascii?Q?dOtaHR0xZJMIkoBxEXlnRpDX9w1sC+dJey+vxulooLEaHugkhLfV2brt+BXz?=
 =?us-ascii?Q?koHlsDsg5TPWMyn5pmrOZjthartBOwlbDikJBozdCvn3TI3ecHrWhR7rBQUE?=
 =?us-ascii?Q?ob9nJEDAdsvlWEOgwjFR/Tlr26bRwSSOxA2woZqoVagvbaBnAxdaigwz21X5?=
 =?us-ascii?Q?Lpa/YHPuCNbqVxIA0fFqB7BJKd/DPIIzmRDRVC8xE2Jy6kUCR3FzytyNVaMo?=
 =?us-ascii?Q?h1OGGESvOfuTGxYPIKJK1lC7cbc9nDIvJwLmi7jjkm6d0z4I6bAKVR3gbd/I?=
 =?us-ascii?Q?YxfksJTwh2Fh8ZzEruF1fF2n4PEOexnQUcTCq8RGmARMOdWhuctUMeiBNQKG?=
 =?us-ascii?Q?iPI3VyKATkzww56W9fiH2JCzc1WxIv+tCKw0k8NIDnGpzcICtCluDPHU3uqp?=
 =?us-ascii?Q?RWw6HvbQR+oo0kYcTF5ADzu3j30ihQyUb1Xtg6gaF/32xNA4g+4ak1iIgK++?=
 =?us-ascii?Q?Y5F9Z9Ud1jbbixEmlT7+VVmUIIRa8/0VKcVJy1eIU8dyXhWfuKU48Pp953hQ?=
 =?us-ascii?Q?v8lT1NM3SWvrM8SMHfBVTPorMIX3dAnZpMIhmjG7vK/IQF/6XcuWtPEdrft1?=
 =?us-ascii?Q?KtpiGKd2k7T4SIoU1fdWXmsiK2UmelKX8JN2OnT6f/orCYVAmQFmeE/xmld7?=
 =?us-ascii?Q?0jF3fTPsNDD+dmSRBJvvxZSIsEgBCkQDUJwwdI21+FtlkQKquIY6US12CY0n?=
 =?us-ascii?Q?SAvYpc6m6Z6/ou/h1nC04g66XJZZjA6AHY4mzeRShA6yS7KQMO76Y9OGQOv0?=
 =?us-ascii?Q?s3ROeDsTCBkWS+DimFEDNcF4L0UjLq4ewDoM5y8F1q4LIwrTyz0imy54k1Yc?=
 =?us-ascii?Q?hhpJ6bPfbY9R870cA4J+98VP0RYmV6hobKsjifRSDI0jvwMJwZhzAG1bKMaG?=
 =?us-ascii?Q?1+CZDgFB8gcez6yg+s8sQ3Qf3uaIctwvodgEJyUKrKM+qRk0co4KuH+H3ffo?=
 =?us-ascii?Q?ZkEp5ysxYEBAoMsXsEAacEG125cIGnR+Q1yV58fpP8IukvdN8kBGCCQ7Zq+z?=
 =?us-ascii?Q?86TdeWQiW2RGLc2oEUBPWBcy+xexsXn04zQP1JAeoLzmgGX5YlgpaJCs3KHD?=
 =?us-ascii?Q?ow=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8642e79c-d1b2-4eb2-7274-08dac82f20c6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 00:03:16.6192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4DE379u0SuqWgGSX8lpzwXjP0veiwKsNoB8CmQBeyFxdtzu9XH4dXFrGSmBtA0ya+4BT1Joue1n6WRZALcnO2UavupxR+4XOVVTspxH2t0o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6519
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 01:21:21AM +0200, Vladimir Oltean wrote:
> Hi,
> 
> On Mon, Nov 14, 2022 at 04:03:22PM -0800, Tony Nguyen wrote:
> > This series contains updates to i40e driver only.
> > 
> > Sylwester removes attempted allocation of Rx buffers when AF_XDP is in Tx
> > only mode.
> > 
> > Bartosz adds helper to calculate Rx buffer length so that it can be
> > used when interface is down; before value has been set in struct.
> > 
> > The following are changes since commit ed1fe1bebe18884b11e5536b5ac42e3a48960835:
> >   net: dsa: make dsa_master_ioctl() see through port_hwtstamp_get() shims
> > and are available in the git repository at:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE
> > 
> > Bartosz Staszewski (1):
> >   i40e: fix xdp_redirect logs error message when testing with MTU=1500
> > 
> > Sylwester Dziedziuch (1):
> >   i40e: Fix failure message when XDP is configured in TX only mode
> > 
> >  drivers/net/ethernet/intel/i40e/i40e_main.c | 48 +++++++++++++++------
> >  1 file changed, 34 insertions(+), 14 deletions(-)
> > 
> > -- 
> > 2.35.1
> > 
> 
> Sorry to interject, but there might be a potential bug I noticed a while
> ago in the i40e driver, and I didn't find the occasion to bring it up,
> but remembered just now.
> 
> Is it correct for i40e_run_xdp_zc() to call i40e_xmit_xdp_tx_ring() on
> the XDP_TX action? If I'm reading the code correctly, this will map the
> buffer to DMA before sending it. But since this is a zero-copy RX buffer,
> it has already been mapped to DMA in i40e_xsk_pool_enable().

Hey Vladimir,

have a look at xdp_convert_zc_to_xdp_frame() in net/core/xdp.c. For XDP_TX
on ZC Rx side we basically create new xdp_frame backed by new page and
copy the contents we had in ZC buffer. Then we give back the ZC buffer to
XSK buff pool and new xdp_frame has to be DMA mapped to HW.

> 
> Since I don't have the hardware, I can't be 100% sure if I'm following
> the code correctly. However if I compare with i40e_xmit_zc(), the latter
> does not map buffers to DMA, so I think neither should the former.
