Return-Path: <netdev+bounces-5303-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4277A710A7C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 13:03:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9B3E1C20E9F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5843EFBFA;
	Thu, 25 May 2023 11:03:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F454FBEA;
	Thu, 25 May 2023 11:03:04 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A5D132;
	Thu, 25 May 2023 04:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685012582; x=1716548582;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ddFOW2xYfu1CU2GodUaL3Ads18y+ezY315FdgOuCzkM=;
  b=XRc2AORA4JDRGvHUa13p6P92v3Hq8Ogaryp1UBmP7RSkTkyoJRNQCyL2
   BrRRrgzR55/pICvxwBYeDPnr7nuUamZLXct6Ija5xxGh39wjFYnu+H4pn
   IyYwA0mMJRfRBwjzSuZ+FHCU1jNiHUQJmYr5wVqyiDTgGi3v2D16WECw5
   fmEXsE6KWO51kLkx6UDke2CehjtvPNjdAfV8UZEr65f76W3QrJ4xJoDIg
   Mlsmrtg7heMpgtZnXGAfNVkGwtVL+eaADg0ZrXNxsz+w1dQ428x3ae//n
   u65YcdOxq3JnJ2MFwKgKFLrDMuxlfxeTqE9AI7wvxtRqbm3qKAgYDpIqQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="357083769"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="357083769"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 04:03:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="817042868"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="817042868"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 25 May 2023 04:03:00 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 04:02:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 04:02:59 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 25 May 2023 04:02:59 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 25 May 2023 04:02:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOEuD0o566khfpBMLv5NX0PCcKCSw1/TnjVUS3n8xOEdmQcXx66QLlZ8Cbhh0dZi7moGh2gHZWZWSxuujdBzYQUTJTUWwnNvasrzblnZZPgyvYJBJ4CWtn4B226FtA6iHcgpP1W6LMIcpDA49zX0ixRi9XDxZhfB6sBYz/E0TP7WZc73e0XdfNriOn0avVahukjloN6uMe6QjSc+2WnoygeuphGfYdoPw2+UBr6lwhrn//AuM5UgLSFBKGnXEZhOT+ZIUKBTb9su8Gb4wJcbe3+rBp/fyEOTcjes46GvA03/GpJ3meze298jsow58nRXXxwBIihAEQrjDdDyykteiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=exWGJGS21g2wvdpJwgAjdNr01jSeNO1Xk3/doGMH8s0=;
 b=iNYFVvkZ+jDE1LmmsS7Y3np2Z0RuJ2wPWPlVgOSWlbdoQM5AAMKYXZOnvQcpIVcy182u4S/jgcWpTOzltbSB4/TAS6OrrZZ3EzS9wNob/fipP1rcactw6sbc19astCKn43Ym5tACB5se2shYVhQxFW/WHXeG0N6DydoxC2S2edznH43gNhbOgF6dGfVTbT4ujMjwRrT4VhPVWJ94L0FDIGQsXRdwyUCkPKsDbCREErq+DP6ww1valqjcCO35FYyjBUIAob5EBdYZMthMtEKpx3BRm3h/mZabttkEiJCPeiOe1Y1as/tkBI9wKyvwlSFTQVg74jyyudHoBPcKamSfJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB6428.namprd11.prod.outlook.com (2603:10b6:510:1f4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Thu, 25 May
 2023 11:02:56 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6433.016; Thu, 25 May 2023
 11:02:55 +0000
Message-ID: <29d2b9dd-28bf-96ad-db5f-721f3a5b82a9@intel.com>
Date: Thu, 25 May 2023 13:02:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RESEND bpf-next 05/15] ice: Introduce ice_xdp_buff
To: Larysa Zaremba <larysa.zaremba@intel.com>
CC: <bpf@vger.kernel.org>, Stanislav Fomichev <sdf@google.com>, "Alexei
 Starovoitov" <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii
 Nakryiko <andrii@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Martin KaFai
 Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song
	<yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, "KP Singh"
	<kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>, Jesse Brandeburg
	<jesse.brandeburg@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anatoly Burakov <anatoly.burakov@intel.com>, Jesper Dangaard Brouer
	<brouer@redhat.com>, Alexander Lobakin <alexandr.lobakin@intel.com>, "Magnus
 Karlsson" <magnus.karlsson@gmail.com>, Maryam Tahhan <mtahhan@redhat.com>,
	<xdp-hints@xdp-project.net>, <netdev@vger.kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-6-larysa.zaremba@intel.com>
 <7a1716ca-365f-c869-3a57-94413234fb32@intel.com> <ZGxzIqbkgzSBWSIX@lincoln>
Content-Language: en-US
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <ZGxzIqbkgzSBWSIX@lincoln>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0178.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::6) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB6428:EE_
X-MS-Office365-Filtering-Correlation-Id: d3c3cf51-6ac1-4552-d3e0-08db5d0f97a9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K3KNXe8SzzAXi2dXQI7kOEyCvsyCKcW+mNMxWbj0ZF1Q+b70dotIugo6OsnnDit3n5kwVrg09/mllv36H1OUQQ63xd3I0Z8ZyDKyZumFsC/UaQGfbe/y1zooEZilytvGyrlDOvPSKCxg+E5BeTUkEJf1vm11yMTwiqZjeP3oOYyuwTKqNJwH2ZDg2MO2H/QFxSIZ1o329/bSJOEZlUA9X74tBpZjmAxF8GwS+cZA2y/wmAdG4tK8j6yIGAg0+s8WDckx4L1o00qnoO3825v76DxUFy5u7lF2CzchQHveUyK/wU0shtDwioJBaTudrp5u73ZgpIHqJ/o7S/ZTT+36BX+2vJoshB2NF4XaJv4zsEzynJXE8zjM+lBRU2t43VbBFdTpNTG+09Lnc/R2McAX8mDczwdZkzevDyVL6MQhhV/JMjXNkNIq4fF3f33MliYoUC84CH+lCwV9eHVxxVrmvIzUDwnRSesjJnMgY9+w3xlxas/QGB5//Q9ygK0gtop1BoaexuML9J0zSkGBc+R2Ac3hJR8I1k00bfJBRqBJjMMfa+MHiwClAEa/7NYklzoEMRYdDm2RQpUvU2qyA/bjGbLjauA+h32Sr0UyHL9JVDdWmN1gkVz9pSGZ5ICLpglXdkhCFZUfAhn/+FhtZGn8Pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(396003)(136003)(376002)(451199021)(5660300002)(6862004)(8936002)(86362001)(31696002)(8676002)(2906002)(83380400001)(26005)(6512007)(2616005)(36756003)(186003)(7416002)(6506007)(6636002)(4326008)(66476007)(66946007)(82960400001)(316002)(54906003)(37006003)(31686004)(38100700002)(66556008)(478600001)(6486002)(41300700001)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEVZVUdSeGtDRUI2U0ttL2lsVHhiSHhIV2tnZG9kaFFWSzVBMy9kSS9RYndZ?=
 =?utf-8?B?V2pKY2hUbGIxL2FmYVdMNkVhUUtIalo0VDNsSnpwamN0VzYreTdHcXR3K1NN?=
 =?utf-8?B?My9weWJrc3dYT1lBcXJKZzBSUHd0anZxNjgzUTh3NkZFZUUzSjA5QTJYRW52?=
 =?utf-8?B?VGFFM1RSbjJ5UXBqbmx3UndIT3lucFJxNTVxTXF6VDZqKzRORWVVd1NRb1V3?=
 =?utf-8?B?WUVrbHBYQmtTQjBxc2VwYWtBWktsMlcremQzTCtpdFJ4Zk9EcjNobmQ5VEs0?=
 =?utf-8?B?eENpelZ3ZWNnMUhEUDFGK2NFeWd1d25tOGRJblVPbUpwR0ZQZy9pcG13VDkx?=
 =?utf-8?B?dlhZNTAyQnZVKzlnNmFobHVRVzROeWFUSVZRL1g5S0ZRSjNhc3hCa2tHTS9l?=
 =?utf-8?B?WE5jMTIva2UvUnlLRXFTRUVNQ29BWXJnUlZTSTRoeDR6Ull3WkZ5RTFyT080?=
 =?utf-8?B?amNwMGpmWXdtUkc1VndML1M4V1h3bHowS3dHc3pObC92blhwQmUrRm42VW5P?=
 =?utf-8?B?cmIxYjN0QWtRSzBHeGNiL2lFc3NLLzFhWGhoRlR0bm1IaC9KUFlqWE0vTGNw?=
 =?utf-8?B?MHZCMHhjMzYrZ3M3anRDODg1T0h6NjUzVEtwOHZiZ0Y1SVlUcHdGSmswc1JU?=
 =?utf-8?B?MUVyN0VuOUhDaS9mdzY0MEV2ZE9pOE1oSzFsL2d3eUJnSEd3QTRTUlIvczN2?=
 =?utf-8?B?TStjQi9COTFBLzcvUG52cnpXU1dhQlpmMkJvSGYyakVzN05IWVZXUmJmSzFx?=
 =?utf-8?B?Sm1GMGZ5dTBxKzE5eTRZWDh5aVY5UHM5Y3hTQ21mY0pIVTF0U1RHY1Z1bjk4?=
 =?utf-8?B?cUNTbWYxelA4eEJkL0F3UzdQcE40cE5QNzh3Z04vSG1sTTFCaXNCT1p6dDFH?=
 =?utf-8?B?dDhwbzhESWZhdmJOWW8rbzgzd0E4WEJUbFhCR25kRVhYMEIvdkJCKzUxNEhu?=
 =?utf-8?B?N2J2L29QZWJ6Ykg2TUhVOERJU3FVZHcwYzhjSHNFenMvdjBuWXpxaEIrSU5P?=
 =?utf-8?B?Wk41QWEzNTRrTllVNWpsQ0pXUlp4MFh4WlZ2UHBqTTFoR2wvSE5Xb2N2ZUU4?=
 =?utf-8?B?czhkU2xwVG8wcEtobEJGczJMMFhjU1U0d0s1TFBEa3ZUMVdESWE1NVZ2d3ND?=
 =?utf-8?B?S0pBeUNBekRnSHYwWndEbmgwU21BQnM3UlA2WldBVkxHdDFicFJhT0dnQ1Bu?=
 =?utf-8?B?aFhEM1NZSFM1Qlh4cDBxTjRzbmVMK1owczZYem0yT1lIUVpjcXRTZGJTV29F?=
 =?utf-8?B?UERLczRzdisyRGM5WnNsRTY0QU82U0lrSy9KNGZZUDhIY2pwN0gwL2diZGR5?=
 =?utf-8?B?NkRtUS81eXZET21HUnQxWUVteThUWG9MWE1hQ3hWUEdSdkladzNCN0xhQklo?=
 =?utf-8?B?Z05KUWNwSUlqSDczZmZmSURNdjhIUnBTSEV0cGx5ejBIa2pWMWZRNUJielJt?=
 =?utf-8?B?bVZPbWF2MHBlRUtiRkhBaXgyS1Fqa0tuNzRpQy9SeFU4WUhqckxENUR6UEd4?=
 =?utf-8?B?UnNLTEMvMzJZaVVtZ1M2QzhrSUl3bW1XSEwvb2F6a2pWTGZ0ME1Sd0gyZ3Mz?=
 =?utf-8?B?QnZjQW1aZURvU3RpbnpvaEpYeCtIRjZVTVd1aEQwL3lSelZWRS9EaUh3NEVq?=
 =?utf-8?B?SVpIUXh6MHNmYWdsYXZUYVNQbHZpMktoTGlQZEw4SnR1T2ZKb25kOXZWSENx?=
 =?utf-8?B?am4yZHlWejVIbzNJbFhJTjVOVitTZFd4MDNjelkyVnJSQitOK0dBd3Nxc2RZ?=
 =?utf-8?B?SVhyREp3U3diSHV1TjA5LzN1YVliV3A5Ulc2QXFxajljcHp1VHdPYTROSnB1?=
 =?utf-8?B?R3JZSUphdWtxWUZXQk5KUy9ZRklUcWR5eVA5bGJjUElRTW1LZUZTWGpwM0w4?=
 =?utf-8?B?UVgweUdTMnczSnFWaDlGcnRhd0N5MWhxdjhCRWkwbUo3dUxiNHFINEgrUHBw?=
 =?utf-8?B?ajI4UC9XQ1lEN0ZEai95eEU3dlZBM2J0cDJQUEhBL29RZ0h2cnQ1bkRIL1Av?=
 =?utf-8?B?U2NzQmVhdUt4M3BINXFOWk0ybEFHN09wYWE3NS9WdVRVUk5KeTFiWVVhSEdZ?=
 =?utf-8?B?SUlBOHk0OVIzTlBiK1FZN1FCNUVSZW1nZjA4WVMxV2dINURGbk9TVDIyOGIr?=
 =?utf-8?B?RFF4VklMY3JqM0tGa0RtemdDd0FXK1M1eTlRR0pvaDNzNWxKL0F5cU1rcUY4?=
 =?utf-8?B?MXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d3c3cf51-6ac1-4552-d3e0-08db5d0f97a9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 11:02:55.6996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5yPHeCuRBC9hvm24U45n80gbnPQtCVRmkzO9E/ZFzGrQQZBdGe66UCNYRTXVRaOLgEzfqgGcFrvv4CC5PGs97obUiWwhx5uEuvNzr117chk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6428
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Larysa Zaremba <larysa.zaremba@intel.com>
Date: Tue, 23 May 2023 10:02:42 +0200

> On Mon, May 22, 2023 at 06:46:40PM +0200, Alexander Lobakin wrote:
>> From: Larysa Zaremba <larysa.zaremba@intel.com>
>> Date: Fri, 12 May 2023 17:25:57 +0200
>>
>>> In order to use XDP hints via kfuncs we need to put
>>> RX descriptor and ring pointers just next to xdp_buff.
>>> Same as in hints implementations in other drivers, we archieve

                                                          ^^^^^^^^
                                                          achieve

I missed this one initially :D

>>> this through putting xdp_buff into a child structure.
>>>
>>> Currently, xdp_buff is stored in the ring structure,
>>> so replace it with union that includes child structure.
>>> This way enough memory is available while existing XDP code
>>> remains isolated from hints.

[...]

>>> +	/* End of the 1st cache line */
>>> +	struct ice_rx_ring *rx_ring;
>>
>> Can't we get rid of ring dependency? Maybe there's only a couple fields
>> that could be copied here instead of referencing the ring? I just find
>> it weird that our drivers often look for something in the ring structure
>> to parse a descriptor ._.
>> If not, can't it be const?
> 
> You're right, I could put just rx_ring->cached_phctime into this structure.
> But I recall you saying that if we access ring for timestamps only this is not a 
> problem :)

Sure, it's not a problem, I just thought it's an overkill to put pointer
to the ring here, since it's not needed to parse descriptors.
...checked right now, the function which processes timestamp from a
descriptor really needs only ::cached_phctime from the ring, nothing
more. Sorta overkill I think :s This phctime would be enough to put here.

> 
>>
>>> +};
>>> +
>>> +static_assert(offsetof(struct ice_xdp_buff, xdp_buff) == 0);
>>> +
>>>  /* indices into GLINT_ITR registers */
>>>  #define ICE_RX_ITR	ICE_IDX_ITR0
>>>  #define ICE_TX_ITR	ICE_IDX_ITR1

[...]

>>> +		struct ice_xdp_buff xdp_ext;
>>> +		struct xdp_buff xdp;
>>> +	};
>>
>> ...or you can leave just one xdp_ext (naming it just "xdp") -- for now,
>> this union does literally nothing, as xdp_ext contains xdp at its very
>> beginning.
> 
> I would like to leave non-meta-related-code rather unaware of existance of 
> ice_xdp_buff. Why access '&ring->xdp.xdp_buff' or '(struct xdp_buff *)xdp', when 
> we can do just 'ring->xdp'?

Hmm, got it. On point :D

> 
>>
>>>  	/* CL3 - 3rd cacheline starts here */
>>>  	struct bpf_prog *xdp_prog;
>>>  	u16 rx_offset;

[...]

>>> +static inline void
>>> +ice_xdp_set_meta_srcs(struct xdp_buff *xdp,
>>
>> Not sure about the naming... But can't propose anything :clownface:
>> ice_xdp_init_buff()? Like xdp_init_buff(), but ice_xdp_buff :D
> 
> ice_xdp_init_buff() sound exactly like a custom wrapper for xdp_init_buff(), but 
> usage of those functions would be quite different. I've contemplated the naming 
> of this one for some time and think it's good enough as it is, at least it 
> communicates that function has sth to do with 'xdp' and 'meta' and doesn't sound 
> like it fills in metadata.

ice_xdp_prepare_buff() :D Just kiddin, "set_meta_srcs" is fine, too.

>>
>>> +		      union ice_32b_rx_flex_desc *eop_desc,
>>> +		      struct ice_rx_ring *rx_ring)
>>> +{
>>> +	struct ice_xdp_buff *xdp_ext = (struct ice_xdp_buff *)xdp;
>>
>> I'd use container_of(), even though it will do the same thing here.
>> BTW, is having &xdp_buff at offset 0 still a requirement?
> 
> I've actually forgot about why it is a requirement, but have found my older 
> github answer to you.
> 
> "AF_XDP implementation also assumes xdp_buff is at the start".
> 
> What I meant by that is xdp_buffs from xsk_pool have only tailroom.

> 
> Maybe I should add a comment about this next to static assert.
> Will change to container_of, I guess it's more future-proof.

Ah, AF_XDP programs, right. Comment near the assertion + container_of()
sounds perfect.

[...]

Thanks,
Olek

