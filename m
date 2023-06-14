Return-Path: <netdev+bounces-10775-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F5FB730428
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:50:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 520902814B7
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:50:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4856010956;
	Wed, 14 Jun 2023 15:50:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3690F1094C
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:50:34 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F992A7
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 08:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686757832; x=1718293832;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=K1inZiJPIOi3J1yxnNfT+ITWBnTBsFHgyuDlWtu03a0=;
  b=B44SySjtPGTGLYNkMVPDBooM7mIKXvzUXqp205KQbEV4xY5RWqHsWz43
   6LK7lBvLPpFcaJSS/mu7fJz+m73ru2kDcbUd9pnCZFtFQuZx0eX6znM/V
   kLKquhoG7VKfeyP5G10PsxCYCMuaGqSez/3R/f6sGGyCE5ionzXIWYcN1
   KtUzcdjJC2qdhp+SO2KDm++Wfla/QysUFN+H7FYSdz88VLOt6WHXsnJBI
   ajnHH7Snn+2Xg4ERNejgv7R/OrtZR4pT9qu6TQCwL1+o9gaUlKT7sNAmG
   1qvDZQK4Ti7Yq+AtuP3nl3790dYXCetPZfGCBmeg8cao6cPwGfvGvRK8m
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="387059570"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="387059570"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 08:50:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="741876460"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="741876460"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 14 Jun 2023 08:50:28 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 08:50:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 08:50:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 08:50:26 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 08:50:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HR3B9MZh1BjoPTrOopxxSTXG1JJzfbYiEQrRuTAODfmVEvv1u7ryFN/uySmnueykcHWlCg+BbUVO8rq0qOtsm1mrFEEv7mBTjo8UbuMJj0jq4fmHYjtbtgM5j1X89NCdz7Ff990iMNifMW5gGW0HyqNu0khd4LFDHR6Q8Od7PpvD1CZ6/izOst3lbz8KdmaRhFvc0itfc+dlvRAdKMJJbM1U4i17G6iUu10wMj/xtQtsRvAN+SjfWCqbLJIenH22SpFkMLXm6wAQMQ1N0BXB2T1LFdfh9EBdM+aO1n6580xKlUGfl9M2Rhy0Ug4nnfMyu7Tbv+bjih2zOpDZM2yCWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fFLG7XEIQl8AUvCpOHJ1sC7yoGGs+FdZKCFm1EhU8MQ=;
 b=FtWPY+3mcu17TW79DVlGRB+amKLUoYuUmUS5jLf+j4YjpXh6Y8Mm1GNXRyLVcVk7OBLXb3KDqLZRYPp6QSYz8zmpAO4p96Av6f47FbyPpLtk5Uiqk/pRf0TwBrCAfZ6LdPJr6U/bBf93kzMisnRyoJfwjtpJsE0SPimIfX/MkHStE2R4JYhSgvchGKo00vRY4I2SeGOUgfblAg/4tJnUgf5ZPCrsHrYjFFGyojxMNO6I2HJHGrvFd+3+U4C9p8MKMiZDn04sq+x82xCKXpCV43ep5MKY6puJdkbR9GrppVZ8ZqJuRfRqwhU/lu35jxry2BQYbljtSVlP7DPNiKYbFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SJ0PR11MB4813.namprd11.prod.outlook.com (2603:10b6:a03:2df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 15:50:09 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 15:50:09 +0000
Date: Wed, 14 Jun 2023 17:50:01 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Piotr Gardocki <piotrx.gardocki@intel.com>
CC: <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
	<przemyslaw.kitszel@intel.com>, <michal.swiatkowski@linux.intel.com>,
	<pmenzel@molgen.mpg.de>, <kuba@kernel.org>, <anthony.l.nguyen@intel.com>,
	<simon.horman@corigine.com>, <aleksander.lobakin@intel.com>
Subject: Re: [PATCH net-next v3 0/3] optimize procedure of changing MAC
 address on interface
Message-ID: <ZInhqR2RspvkMOYF@boxer>
References: <20230614145302.902301-1-piotrx.gardocki@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230614145302.902301-1-piotrx.gardocki@intel.com>
X-ClientProxiedBy: FR2P281CA0030.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::17) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SJ0PR11MB4813:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e490abc-6e56-4b08-dd22-08db6cef0814
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FBzGgpDrsyoGhdjaEWluDFDgcboPbzMX6MEMC8JLyc+SBgYoJy58PfftXX3Ge8R+uv+dEkfiJkNcqW93ZZn1FtEz3yvL28QyV8kXZf6k0GyV27kx600DW/+yD3p+IRZPOehT24i0POIgPXkEVfbnse6sq+6oE7inR3jYUL0jz98QUTlUYElZnGFKYZxZFU+u62shE41LNKGVa8wPAFNzjguN3xUHW1RPDSiSDdCPtnB+SPk/4yK6qYLtCB1lTEF6vyWOEfAgvkgwG8uGRhxi4l1yuDuYqgqHNySxHrJyEngoAq88IBXlkpc099F6TtfHYjbVrS8DS/1Hsu/xZ2+JQEw10iOlecLWIBKWbCPUuWUlsvLefu6nSfC1/EYRds8LOrPy/ZdEAP5EZzaQFp10J06OQOdup+66OZfy/CEdixa4WSUq5T3IUg4nk56pq3YB9K1l0yiu4AQnEd2KW170taiV7lXKE6/RYp6KPEQQJqjE1H2XmGI89T8X359nfoU69S6S4Na2obrQ8Gy4W29LyFIZM6zuerF237o/JETVq5rHE70oTCxkAFU55fqjB0XZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199021)(86362001)(6486002)(6862004)(6666004)(316002)(8676002)(41300700001)(5660300002)(26005)(83380400001)(82960400001)(6512007)(38100700002)(9686003)(6506007)(8936002)(44832011)(33716001)(66946007)(66556008)(4326008)(478600001)(6636002)(186003)(2906002)(66476007)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H2ZkpvcPkJ5qr2T7v/0iMXlZd2+S1UiJjcDsjrxq0Jt3+x6F5I8Na95QB0ew?=
 =?us-ascii?Q?qOtf38kSkQto4G+kaEKW0+fTOGjKn7xE6tLTnYYjmWmMatCK+roDPKQ0oTDe?=
 =?us-ascii?Q?hg/aSCsxFqZRvkuDz/EgpPLL1wvBPIREc3B52dW99KeAIHGz12XkjF0zb7OU?=
 =?us-ascii?Q?2CWpwBOCuEZlAMFT9ybbbdynCZQkEwUer4HKkzlw4ACBRJU8CfaVOhXt1N/q?=
 =?us-ascii?Q?APlS1I63OrH3TssViwLl6WnIpIpmFaAEWOAlyqv4qJGzUAn3QoPzq8yEUkTQ?=
 =?us-ascii?Q?3wyN5A0eNcKxulQgpwDHL1LdOt2WF0wMgbTkKhf1pWx9Tn+x6gvROABqHjP/?=
 =?us-ascii?Q?hG/OIZh8df1bou49TKeKuamKAsB0D6TU9nQI28Y6Mhziv+vWr1hSpea8oI1f?=
 =?us-ascii?Q?TJ7GNQt8vxeKslezC+aJMBSwVteyg599eBBXXsPh8WamfDDA4NAUeNbDas33?=
 =?us-ascii?Q?Ltigq7xxjxfEtykElxlKcp1w+Tjm98MY65t0+nyD4KetLxdgl/dEVztG7VqF?=
 =?us-ascii?Q?sad7z3imSfD6r/CbwkAooIXxnOCzhseCiXG5OvrYrcGYxNT3noY41XNpkx+v?=
 =?us-ascii?Q?+suv7dZibLaOZAsJfJqMAUvMW6Ah6OgjH7QFgmR5fQSOSDXvWAgbIB8OLQeG?=
 =?us-ascii?Q?cNJ4qCNJClZxvLZf4/+ElDmDzfpS2FjUS791V9+5j3bOUEtk8jpzllem131X?=
 =?us-ascii?Q?eYMonvHVG56lxTBCrP4DIhQ4r3Pjv0zkhQxiihxX93mVvAsEIw1p8mrMJT1H?=
 =?us-ascii?Q?e6+3i63NKRWE6tKSNKB42Zj7tMa18CNgOfs7WwKgdBA7cAkI0RjXsDkbkpzD?=
 =?us-ascii?Q?968v6AQu32SCnhuim9H0tPdxLx6ZN7kRPkGDc79ftWvWsK+1C8w8CwLM9H1v?=
 =?us-ascii?Q?geQ6V8ISJEQPjJ2MX9f8a8PIrPPTWW6G1laYwPrZPhUEvZTlRrSnzMijdi89?=
 =?us-ascii?Q?LyLobPW0NP8pql7JoJfJhrlnboH+LC9NdmixXddSvIEpPWMJpJHDLfeeQ42a?=
 =?us-ascii?Q?m4HqxdAiSSEzjqrfa5fzkGqjOoUrev0hN4Z+uLx9prcPh481gEZIplw27vb2?=
 =?us-ascii?Q?wu66uASHmUBoSXZE/k9yez47q2BiktnBgognr2Bjz1xXOiOJW/nJFSUcbm7e?=
 =?us-ascii?Q?RTJiO3lMAWCDeYMacrpeBLVvG5KIXF0QsfHjp88g1aqBqkZYa4LZbopvq2oI?=
 =?us-ascii?Q?GuuaH5zcJQlmZZXICDLd63eYWl0rnqs7KnFsR64qQi+AeEj4M4126R2p7jUA?=
 =?us-ascii?Q?ZJGC6SI4eiIzBM3jzYlMQjFAwl7dDjsTCW44mZ8igRlRuwge5oq2BQ0npL5c?=
 =?us-ascii?Q?doyESwx0lo3xu+EA+qdggwiud4DBsH3ORv9mWZdzPDQvH0yRmrK4TFbpsR1j?=
 =?us-ascii?Q?dEtuhYuoLYxyPq3MqIZE2mLuhGVgJeD3Rd/FHf7jllROHa1T43l0ayYy2FTB?=
 =?us-ascii?Q?JYAdahjmTZ09RftBzLkdVtgSHVLWjlJnr3BH3GaTWHAvOWImefIf+uN3+BYA?=
 =?us-ascii?Q?OMl0nErdNA4nkSVxpm88RQNzrMCaKBcc5wHLcTEFhRIIssT4V+rFv1Cipkrt?=
 =?us-ascii?Q?uftp4ctjrWFY5b2AId1Vhvll1zs8jblAxi41f/adSmvKjAsIx1IOwdjkBapt?=
 =?us-ascii?Q?EQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e490abc-6e56-4b08-dd22-08db6cef0814
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 15:50:09.3657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LyhcXV0/TAAPqN8rh1Tlgsd1P3/FXkizxb5RcJl1vBX2CV1uLpqt/XWUHzd/0lVqflW/QnpUq9r18LSIg7SRLWCVJOAobyuqqNkBP1sX8Ug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4813
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 04:52:59PM +0200, Piotr Gardocki wrote:
> The first patch adds an if statement in core to skip early when
> the MAC address is not being changes.
> The remaining patches remove such checks from Intel drivers
> as they're redundant at this point.
> 
> v3: removed "This patch ..." from first patch to simplify sentence.
> v2: modified check in core to support addresses of any length,
> removed redundant checks in i40e and ice

Any particular reason for not including my rev-by tags on driver patches?

> 
> Piotr Gardocki (3):
>   net: add check for current MAC address in dev_set_mac_address
>   i40e: remove unnecessary check for old MAC == new MAC
>   ice: remove unnecessary check for old MAC == new MAC
> 
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 6 ------
>  drivers/net/ethernet/intel/ice/ice_main.c   | 5 -----
>  net/core/dev.c                              | 2 ++
>  3 files changed, 2 insertions(+), 11 deletions(-)
> 
> -- 
> 2.34.1
> 

