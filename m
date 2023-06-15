Return-Path: <netdev+bounces-11049-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEA8373155F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:31:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 471CD28175A
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0407F3;
	Thu, 15 Jun 2023 10:31:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD24A942
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 10:31:08 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFE9199
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 03:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686825061; x=1718361061;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=93Cnh+a5LbYVfhByyUVXqgcYeRn23j/FqKqACqYkSL8=;
  b=kBIZVaepYFgKp6LPYv/jS3WeHp7b1cVD5g7WkNAFvWMIO/KWSpY9ffP0
   5p/iNwpNNeo/UnoczfsyfFk7Cso+fLu207Sm+TIXhy6FiwNr8QoA/KXAx
   7Wkoeh1f9koRsEI0xUe6G9ovpoaYPNOrYhav3ErOaylrsuCkR1hhcw6Tz
   Sll9KPqn9eOdrcWxPgCbnw2rAOl29Y1H0R/aqZQoGMEaReJq7D8Xi73ZV
   LdWW0SlRkhUy9kkZwXIAzNdol2+k6j3oGG/PAMWI8tskVwSPV+pnxtYQl
   4FmJBQC/MrfwfENLy0MtQtVSETxusqgIISciDbvxwQ5gxR47uvnxcMeCr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="361353639"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="361353639"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 03:31:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="802281707"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="802281707"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Jun 2023 03:30:59 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 03:30:59 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 03:30:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 03:30:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ne6gQDuS24y99Ry2NKpceANYHyx6pERFOZoA7cKhDnrFylSi5G8iTqgajYeyhPD8QoLtdRfxzPlot2U0VR02XxfFzI21jp+XFIy68nwS2coGsjaCO5es7buE4PewYHaOST7bxLsbEqxvn5wC6flnBBWPDj70cb6jO0gA7hLvLdXueMjt9quuLt7kTntTRUqanYFVGOtZ/PxH7E1/WKb2UNgzENcRUrVnyIW7cRLmGkJMUmlCV4RPZA5Y7l74iwTRaJU+qyMQqZ3JOtUYkjCb8VV4xgV+ilUZR6V0gUur1HBRcZ2nNVXiiYz60XIE0GG8cP7P5AjV4JeXGjzCxhmfKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e9qgxoaaIh1z+Mfs3fe2hLCLp2pFdBeOSDET81wCUw8=;
 b=kchX/B7a9/aYyFTfYBQY6tmRWcG7uxTgfE2zM4wH7QJtQPw9wXqh6/4rIhVVpNPEACP0cm3KPyhxXaq2FW9htJbca+yBAjFrbYjLfJuUCKWx9iEMbWl+4gjv2HTjtwAN1oIMPJF51QOX34DVzOCxU6eTRzFWaAhlyxd7IHDKQO23ta6M25Vbm5Du2RAW7qIpiGpsky7zlYQvcKsJLIRwee5uL9ka6Jx+lXMkzEWyLLI66I2PiioYTfUyBqjINTVvCn54vzHSxAz++nCBio30kakZN6jYZVwpsEW+lna9b1n/PWA4dnIVwPIBx9eldGLMLj30fTdfd44XLvlW6254xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SA1PR11MB6823.namprd11.prod.outlook.com (2603:10b6:806:2b0::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.37; Thu, 15 Jun 2023 10:30:50 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.028; Thu, 15 Jun 2023
 10:30:49 +0000
Date: Thu, 15 Jun 2023 12:30:36 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
CC: <ecree.xilinx@gmail.com>, <habetsm.xilinx@gmail.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>,
	<bkenward@solarflare.com>, Fei Liu <feliu@redhat.com>
Subject: Re: [PATCH v2 net] sfc: use budget for TX completions
Message-ID: <ZIroTOtyvknhzP2r@boxer>
References: <20230615084929.10506-1-ihuguet@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230615084929.10506-1-ihuguet@redhat.com>
X-ClientProxiedBy: FR3P281CA0015.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::13) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SA1PR11MB6823:EE_
X-MS-Office365-Filtering-Correlation-Id: cefc21c9-614c-4ae4-bb47-08db6d8b95e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SYzV4Nr9DqjuTYxSdt++1zyDLyldKC0ajOuRCaLys3DLiO8jvZxR0HT1k6D2p0V9B3qeU5CXZ6vh/aSwqmNObfU6kvgjcaLn+9dNe93tDGlkKUjR2tF+jnTzkNd3kDbolJ66bnAp0u+whcAE4Yq7l+8tyxtgso02w7oiRervpGEi9jAzPdlud5XBa35KfZWrPSRwpO9nOU5QwtNdEH4qRB+gdBk9t7wwnEffCQnZGXeCa0he4mSSFss3b/wPs9Wkk2p378UB5ieP+6k+nSR3nVy2s99XtK2LcN6KcaLxDZZLj9+aqlDL5eQyy1lxERaAS7swnqQAK1gIeWiIWKQgA7tNQPG0mf91ooHfmaLlcfAPjwXq9IGJ2OZCsUjM/dz1pTzg7yrD3+XsdWjVuNFWTlchwNI4KagVta0E9HoZ7Z2GKdMqhBkHjObWC2uF1zRpm6I7N5C0xmLtQXkC3I2nyb02UMrFANLsgPK8QV/+0y+5t3DYoXJO/OMTUwJXEPz9D0pap7aP5KWwJWY4qZeUWQZM4+YT5H7TVdPQJG2QeNXa9eG70jVPGBmwEtHzHxML
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(366004)(39860400002)(396003)(136003)(376002)(451199021)(5660300002)(83380400001)(186003)(33716001)(6506007)(44832011)(2906002)(7416002)(6512007)(41300700001)(8936002)(9686003)(26005)(8676002)(6486002)(316002)(6666004)(478600001)(82960400001)(4326008)(66556008)(66476007)(86362001)(38100700002)(66946007)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?gUnHh80tu82LZVs8sNATYpqRnLt1iXupKiKP40KL9aILRgUCYUQjSQExoJ?=
 =?iso-8859-1?Q?y3Wgl5IqOv/qs7Ks8sixGbAHWW/s2Ij0b3OYte1mQP1JhZeWVpD/5tGWjA?=
 =?iso-8859-1?Q?c3BDEJFofOEhYIhDujKv2HljeEW8fwaNpGLxeWukFOb10Xfht8XNvD5xeu?=
 =?iso-8859-1?Q?HqJYkPLjBMd7N23n+qtir9YTnglyJ+AImWgNnOlXxtUOL/D0EnyDSZqXiT?=
 =?iso-8859-1?Q?tvi/KLCzIYSVah1vVXCcHhq50SlwDvTog22W5z7NOY2timuBGMb4KiS1dr?=
 =?iso-8859-1?Q?ofarHA4LoH2PG1/ayuMEDzQoZS760jVVUlR7iN+8mMtxmvD3Qvv6y+Q3Eg?=
 =?iso-8859-1?Q?Q7igt4OSqXzJMK0BDllKLRAk1QhAdK7YcdyNMftWTJmdTMTG/zMjDt9OVv?=
 =?iso-8859-1?Q?NTFzYpVSH2UGBVF78YOlUVLTpKq1NqqVU/JJ4slvg1YspOSM0XovlluTWX?=
 =?iso-8859-1?Q?oxyRrNfHep+nYfmykhrAPttYiodWpOYhphlBoLIcmA7guF7IJ594lzL8XS?=
 =?iso-8859-1?Q?ghCx4JHDtEcF51u/r2BTcpSKgFQcv00zxZ85rDt13h+EtSACJ9N8aqkp3F?=
 =?iso-8859-1?Q?KDOBkEgJ6gsqdgKfTH/r/JdD3gXDsbj+cZcj9KIEieUuoDeOtyYXGk5Bu0?=
 =?iso-8859-1?Q?gOyEYO7jBmMwwNNwqp45yhlr+S2U2k2IAqBDAieFGfLJ0jE5BIT42LnT/U?=
 =?iso-8859-1?Q?RaPn0dqbxtJJvHk1WO7jpmDk2t/pabaAqepT3RjfzYaw7Us1rVRZJDnibA?=
 =?iso-8859-1?Q?GrRxHIPbdfw4NKYCwWtBRz38W1HHKZP3cyxSNadTmIgNQUPHRSjl382QxX?=
 =?iso-8859-1?Q?m5Lkq4/7s005BTH6c5htLIZJLmRZWXG8kwUYn1SPQ6XRZZjLJKMo/zsDtw?=
 =?iso-8859-1?Q?KthttyAyZgO+Z9hLCzwLKf2+HG6giCuV5lbFz4Bo/JLR9T4SjI6XxknHak?=
 =?iso-8859-1?Q?G/fb8f+WrYYgQilPZZwz7H0fsFpo0O3t5Glqrxmu4R0XHCXE/1uSuSGlUa?=
 =?iso-8859-1?Q?h7qB81MK8ZhTs12xiDqAX2kMv5m+ZrxRp+rgsjnkZPZnDSMW/0p2I0FIJH?=
 =?iso-8859-1?Q?mpM1lLHnECILfPN6lqdGG/eZgyK4fakXl+D8KusIWHi396kBa/DN2LGGvg?=
 =?iso-8859-1?Q?GujnvMs8JNjEpyz1tXE0c7jFQnm2iGcB4zLT9v5WaYAaJPf46L+ZVoL59G?=
 =?iso-8859-1?Q?iEthocGmP2jz8XPv38vWrEIyRy76FO2mJsSGAujRdxEGmnjb4eRQJeQZ07?=
 =?iso-8859-1?Q?lSsmXJ+cfTPKrJOtw+R8zZO0kPhSdC69o+SahS46MAB4PaobG5bq7xI06h?=
 =?iso-8859-1?Q?Spn8UohOJL0dis6h20NSEGDayzfnvuiR98UsMZb5y2Xdy2lCZKMyPFvUBR?=
 =?iso-8859-1?Q?2hv3vldrvE6NkY9JNpPC3XHm5tsvpzpxDc5BMACyz+tr9wJFu9+6RooYS2?=
 =?iso-8859-1?Q?n9u+ZpDzCdAWae/LAglzZhctZpJM0aGCgyT3SiaS/RcghNX61VkDFyoSjL?=
 =?iso-8859-1?Q?89dmcIPIJs30bJNO71xI5Frf6ueDZAeWlgsa1907HdMIf/7b3HKoEm1nto?=
 =?iso-8859-1?Q?IfOGFGaXv2EjEmAE5ZWuM9mAs+XGjVXmazijONm0ISyLP67nWXuU9/QCwj?=
 =?iso-8859-1?Q?24nPo0e24ysVfYiFh2gmXoXhj5om0njPfGn26JMwflOwxd0KIWCDKHnw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cefc21c9-614c-4ae4-bb47-08db6d8b95e3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 10:30:48.8080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FOWqjCslfD8dn0GBFjZJ801qLpORFEbMDptEzEFJJ3yy45o4emILydOW93Ml5PXgYuxvkkAhw+yIGYm1eIDaAkPEaTkjQynTN5ytFXastCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6823
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 10:49:29AM +0200, Íñigo Huguet wrote:
> When running workloads heavy unbalanced towards TX (high TX, low RX
> traffic), sfc driver can retain the CPU during too long times. Although
> in many cases this is not enough to be visible, it can affect
> performance and system responsiveness.

What is a v1..v2 diff? Please include this in future.

> 
> A way to reproduce it is to use a debug kernel and run some parallel
> netperf TX tests. In some systems, this will lead to this message being
> logged:
>   kernel:watchdog: BUG: soft lockup - CPU#12 stuck for 22s!

Hmm debug kernel is pretty wide term to me. maybe you could drop few
config options specific to your setup?

> 
> The reason is that sfc driver doesn't account any NAPI budget for the TX
> completion events work. With high-TX/low-RX traffic, this makes that the
> CPU is held for long time for NAPI poll.
> 
> Documentations says "drivers can process completions for any number of Tx
> packets but should only process up to budget number of Rx packets".
> However, many drivers do limit the amount of TX completions that they
> process in a single NAPI poll.
> 
> In the same way, this patch adds a limit for the TX work in sfc. With
> the patch applied, the watchdog warning never appears.

please use imperative mood.

> 
> Tested with netperf in different combinations: single process / parallel
> processes, TCP / UDP and different sizes of UDP messages. Repeated the
> tests before and after the patch, without any noticeable difference in
> network or CPU performance.
> 
> Test hardware:
> Intel(R) Xeon(R) CPU E5-1620 v4 @ 3.50GHz (4 cores, 2 threads/core)
> Solarflare Communications XtremeScale X2522-25G Network Adapter
> 
> Fixes: 5227ecccea2d ("sfc: remove tx and MCDI handling from NAPI budget consideration")
> Fixes: d19a53721863 ("sfc_ef100: TX path for EF100 NICs")
> Reported-by: Fei Liu <feliu@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---
>  drivers/net/ethernet/sfc/ef10.c      | 25 ++++++++++++++++++-------
>  drivers/net/ethernet/sfc/ef100_nic.c |  7 ++++++-
>  drivers/net/ethernet/sfc/ef100_tx.c  |  4 ++--
>  drivers/net/ethernet/sfc/ef100_tx.h  |  2 +-
>  drivers/net/ethernet/sfc/tx_common.c |  4 +++-
>  drivers/net/ethernet/sfc/tx_common.h |  2 +-
>  6 files changed, 31 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
> index d30459dbfe8f..b63e47af6365 100644
> --- a/drivers/net/ethernet/sfc/ef10.c
> +++ b/drivers/net/ethernet/sfc/ef10.c
> @@ -2950,7 +2950,7 @@ static u32 efx_ef10_extract_event_ts(efx_qword_t *event)
>  	return tstamp;
>  }
>  
> -static void
> +static int
>  efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
>  {
>  	struct efx_nic *efx = channel->efx;
> @@ -2958,13 +2958,14 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
>  	unsigned int tx_ev_desc_ptr;
>  	unsigned int tx_ev_q_label;
>  	unsigned int tx_ev_type;
> +	int work_done;
>  	u64 ts_part;
>  
>  	if (unlikely(READ_ONCE(efx->reset_pending)))
> -		return;
> +		return 0;
>  
>  	if (unlikely(EFX_QWORD_FIELD(*event, ESF_DZ_TX_DROP_EVENT)))
> -		return;
> +		return 0;
>  
>  	/* Get the transmit queue */
>  	tx_ev_q_label = EFX_QWORD_FIELD(*event, ESF_DZ_TX_QLABEL);
> @@ -2973,8 +2974,7 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
>  	if (!tx_queue->timestamping) {
>  		/* Transmit completion */
>  		tx_ev_desc_ptr = EFX_QWORD_FIELD(*event, ESF_DZ_TX_DESCR_INDX);
> -		efx_xmit_done(tx_queue, tx_ev_desc_ptr & tx_queue->ptr_mask);
> -		return;
> +		return efx_xmit_done(tx_queue, tx_ev_desc_ptr & tx_queue->ptr_mask);
>  	}
>  
>  	/* Transmit timestamps are only available for 8XXX series. They result
> @@ -3000,6 +3000,7 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
>  	 * fields in the event.
>  	 */
>  	tx_ev_type = EFX_QWORD_FIELD(*event, ESF_EZ_TX_SOFT1);
> +	work_done = 0;
>  
>  	switch (tx_ev_type) {
>  	case TX_TIMESTAMP_EVENT_TX_EV_COMPLETION:
> @@ -3016,6 +3017,7 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
>  		tx_queue->completed_timestamp_major = ts_part;
>  
>  		efx_xmit_done_single(tx_queue);
> +		work_done = 1;
>  		break;
>  
>  	default:
> @@ -3026,6 +3028,8 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
>  			  EFX_QWORD_VAL(*event));
>  		break;
>  	}
> +
> +	return work_done;
>  }
>  
>  static void
> @@ -3081,13 +3085,16 @@ static void efx_ef10_handle_driver_generated_event(struct efx_channel *channel,
>  	}
>  }
>  
> +#define EFX_NAPI_MAX_TX 512
> +
>  static int efx_ef10_ev_process(struct efx_channel *channel, int quota)
>  {
>  	struct efx_nic *efx = channel->efx;
>  	efx_qword_t event, *p_event;
>  	unsigned int read_ptr;
> -	int ev_code;
> +	int spent_tx = 0;
>  	int spent = 0;
> +	int ev_code;
>  
>  	if (quota <= 0)
>  		return spent;
> @@ -3126,7 +3133,11 @@ static int efx_ef10_ev_process(struct efx_channel *channel, int quota)
>  			}
>  			break;
>  		case ESE_DZ_EV_CODE_TX_EV:
> -			efx_ef10_handle_tx_event(channel, &event);
> +			spent_tx += efx_ef10_handle_tx_event(channel, &event);
> +			if (spent_tx >= EFX_NAPI_MAX_TX) {
> +				spent = quota;
> +				goto out;
> +			}
>  			break;
>  		case ESE_DZ_EV_CODE_DRIVER_EV:
>  			efx_ef10_handle_driver_event(channel, &event);
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> index 4dc643b0d2db..7adde9639c8a 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> @@ -253,6 +253,8 @@ static void ef100_ev_read_ack(struct efx_channel *channel)
>  		   efx_reg(channel->efx, ER_GZ_EVQ_INT_PRIME));
>  }
>  
> +#define EFX_NAPI_MAX_TX 512
> +
>  static int ef100_ev_process(struct efx_channel *channel, int quota)
>  {
>  	struct efx_nic *efx = channel->efx;
> @@ -260,6 +262,7 @@ static int ef100_ev_process(struct efx_channel *channel, int quota)
>  	bool evq_phase, old_evq_phase;
>  	unsigned int read_ptr;
>  	efx_qword_t *p_event;
> +	int spent_tx = 0;
>  	int spent = 0;
>  	bool ev_phase;
>  	int ev_type;
> @@ -295,7 +298,9 @@ static int ef100_ev_process(struct efx_channel *channel, int quota)
>  			efx_mcdi_process_event(channel, p_event);
>  			break;
>  		case ESE_GZ_EF100_EV_TX_COMPLETION:
> -			ef100_ev_tx(channel, p_event);
> +			spent_tx += ef100_ev_tx(channel, p_event);
> +			if (spent_tx >= EFX_NAPI_MAX_TX)
> +				spent = quota;
>  			break;
>  		case ESE_GZ_EF100_EV_DRIVER:
>  			netif_info(efx, drv, efx->net_dev,
> diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
> index 29ffaf35559d..849e5555bd12 100644
> --- a/drivers/net/ethernet/sfc/ef100_tx.c
> +++ b/drivers/net/ethernet/sfc/ef100_tx.c
> @@ -346,7 +346,7 @@ void ef100_tx_write(struct efx_tx_queue *tx_queue)
>  	ef100_tx_push_buffers(tx_queue);
>  }
>  
> -void ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event)
> +int ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event)
>  {
>  	unsigned int tx_done =
>  		EFX_QWORD_FIELD(*p_event, ESF_GZ_EV_TXCMPL_NUM_DESC);
> @@ -357,7 +357,7 @@ void ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event)
>  	unsigned int tx_index = (tx_queue->read_count + tx_done - 1) &
>  				tx_queue->ptr_mask;
>  
> -	efx_xmit_done(tx_queue, tx_index);
> +	return efx_xmit_done(tx_queue, tx_index);
>  }
>  
>  /* Add a socket buffer to a TX queue
> diff --git a/drivers/net/ethernet/sfc/ef100_tx.h b/drivers/net/ethernet/sfc/ef100_tx.h
> index e9e11540fcde..d9a0819c5a72 100644
> --- a/drivers/net/ethernet/sfc/ef100_tx.h
> +++ b/drivers/net/ethernet/sfc/ef100_tx.h
> @@ -20,7 +20,7 @@ void ef100_tx_init(struct efx_tx_queue *tx_queue);
>  void ef100_tx_write(struct efx_tx_queue *tx_queue);
>  unsigned int ef100_tx_max_skb_descs(struct efx_nic *efx);
>  
> -void ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event);
> +int ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event);
>  
>  netdev_tx_t ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
>  int __ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
> diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
> index 67e789b96c43..755aa92bf823 100644
> --- a/drivers/net/ethernet/sfc/tx_common.c
> +++ b/drivers/net/ethernet/sfc/tx_common.c
> @@ -249,7 +249,7 @@ void efx_xmit_done_check_empty(struct efx_tx_queue *tx_queue)
>  	}
>  }
>  
> -void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
> +int efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
>  {
>  	unsigned int fill_level, pkts_compl = 0, bytes_compl = 0;
>  	unsigned int efv_pkts_compl = 0;
> @@ -279,6 +279,8 @@ void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
>  	}
>  
>  	efx_xmit_done_check_empty(tx_queue);
> +
> +	return pkts_compl + efv_pkts_compl;
>  }
>  
>  /* Remove buffers put into a tx_queue for the current packet.
> diff --git a/drivers/net/ethernet/sfc/tx_common.h b/drivers/net/ethernet/sfc/tx_common.h
> index d87aecbc7bf1..1e9f42938aac 100644
> --- a/drivers/net/ethernet/sfc/tx_common.h
> +++ b/drivers/net/ethernet/sfc/tx_common.h
> @@ -28,7 +28,7 @@ static inline bool efx_tx_buffer_in_use(struct efx_tx_buffer *buffer)
>  }
>  
>  void efx_xmit_done_check_empty(struct efx_tx_queue *tx_queue);
> -void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
> +int efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
>  
>  void efx_enqueue_unwind(struct efx_tx_queue *tx_queue,
>  			unsigned int insert_count);
> -- 
> 2.40.1
> 
> 

