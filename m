Return-Path: <netdev+bounces-6603-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC04D71711C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:57:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D0F71C20D4A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:57:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C283D34CD1;
	Tue, 30 May 2023 22:57:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A38A927
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:57:35 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D55FE8
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685487454; x=1717023454;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=21KWeCp7Y8FhA2+J3q2Qmlr/HuWnnvSph2Sp/O3zxqM=;
  b=bbdXTVLjUOdsLAq5xWj8yZyHYKCP/JM3UFeFvstrpN/qkb/h/LY5wpGW
   AbLfROg7oTpAV2YlO5lnyaGPPG0IBGuZbilmMtBCbmTEsmGUj0llDsnr5
   98XWFGGFG4+V/0Kq9CAsirl78Hu4owCJCCW9X8qB7jt+glB6rMFWigqjh
   etBEDTP/FNNn9L6v4jRhsTB21QQ3uGkAP2vql0BGzZsvFdkWmk/ks8mH8
   PnxUzVZWbiK41rdR5PQnZuttP6JfPu/Pi1kHjKDjoALypBj3S+Ry8Otpq
   rQnyzEXrqdrEnkstUXDzBqTuy7YsfqaJIrdnO6NKBNbd0Qlgfvd6thW81
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="352567427"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="352567427"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 15:57:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="850973625"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="850973625"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 30 May 2023 15:57:33 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 15:57:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 15:57:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 15:57:33 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 15:57:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWwbh8hm1c/6fCAb2bco78M8tkZUYlydj7fNR5WhwgwOGHCi4w8hKIb9LuKbTTAs9siC2qasdwiUwb9nn5nNJ1kx7iPFvCrDV1+rRe/wSmbxY/eqv49OU2XQV0u725OXWdve+wcRLr1Zr0i09md/w6J8hPYm+kmlGE3XYtlNZrlI2iYseH8ag9dJo3JF9+pF9hBVxyyANBtNa2WuWvTzDAFZp+QCl1JIab0KvLNCEZzdOgQrkvF1CgtcCJWgnKsEBBub9ZrMRuGRLw4bO1ybxRFvfo/AcsSYGVufX/P+EsU/yUzJTvvT2t3/WNYA/S0aY8/oabVkD94yPuOvXBSwBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p14+cJAdjX3f+qnDgkqMCJzT7Z8U+dmy9wkuAyXFqNs=;
 b=hEoKG+CWjSuu6cb2IXOCOC78XSIvoHXZ4t2tZB7IUU03lkhuLjzB61ezAC9c0qmTh0Y0LCuZ5dljz6K1WUfR0HlHdyVZSWS3RR0NlNDic65LSfmRQgReNqeqaltMsqlzoUI1ypSY3OnX9Bl8teGUpk2km7g5m6CuvSaMGSR/6yv1W3U588DR434brAjtkdo/O0u+61MWO30wzQChjfHctX9VqlvFi2/VAmOBlVKGmHUgSjDlTRihffg8kvOqbdH2irovmGMYdLlXQ1mQmRUg8WQd4YKAkrRGJDjekTMfFr7DZAy+72BCtrToZ1s6U+9eppZXtFWxt5xgD3A33wH+IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5911.namprd11.prod.outlook.com (2603:10b6:303:16b::16)
 by BN9PR11MB5547.namprd11.prod.outlook.com (2603:10b6:408:104::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 22:57:23 +0000
Received: from MW4PR11MB5911.namprd11.prod.outlook.com
 ([fe80::d06:5841:d0e0:68b8]) by MW4PR11MB5911.namprd11.prod.outlook.com
 ([fe80::d06:5841:d0e0:68b8%4]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 22:57:22 +0000
From: "Singh, Krishneil K" <krishneil.k.singh@intel.com>
To: "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "willemb@google.com" <willemb@google.com>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "leon@kernel.org" <leon@kernel.org>, "mst@redhat.com"
	<mst@redhat.com>, "simon.horman@corigine.com" <simon.horman@corigine.com>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"stephen@networkplumber.org" <stephen@networkplumber.org>,
	"edumazet@google.com" <edumazet@google.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "kuba@kernel.org" <kuba@kernel.org>, "Burra, Phani
 R" <phani.r.burra@intel.com>, "decot@google.com" <decot@google.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "shannon.nelson@amd.com"
	<shannon.nelson@amd.com>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v6 08/15] idpf: configure
 resources for RX queues
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v6 08/15] idpf: configure
 resources for RX queues
Thread-Index: AQHZjQ1aHwYncWaNDUKS8L177SDvIq9zeeYA
Date: Tue, 30 May 2023 22:57:21 +0000
Message-ID: <MW4PR11MB5911D575BA443AEFC2962840BA4B9@MW4PR11MB5911.namprd11.prod.outlook.com>
References: <20230523002252.26124-1-pavan.kumar.linga@intel.com>
 <20230523002252.26124-9-pavan.kumar.linga@intel.com>
In-Reply-To: <20230523002252.26124-9-pavan.kumar.linga@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5911:EE_|BN9PR11MB5547:EE_
x-ms-office365-filtering-correlation-id: 2ff2d65b-1d32-4f42-9393-08db61613a3b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tugC0SetHEVEOllPYPkJAM9sb5QseMzSRZ34uOFGJoMOmjIfVRrtIx4ZAIxxiz4cKcHMf5kTMC7eKsrD+qfw58hxyQqPsYibRSUi7RLTTBQ2OGO9Osex5+Ix64MGput9SIAGxRTARxcCTvJ3wgCnLLeijXF9hcdqKOQeCJJFF9YS1rSCzqjvv+tdfiBurr9jkvMHgeBoQoXHB9oWAKwFVSJjRI83zCPXDTpaXwM0ee8RQZPKrDp3hSK1Y58O+khHQ+SRvrm5l+krTPkRcLDo6fVyE+eFI8E+bnFAelreH9vfPD2AJlK/SnQt7+4GS+Zaz2snxIzGYNN5PAJ72l0Nmkos0uNr+kDAE5PLfs7fIAAgyAAiudsfa4GmZQdsGpJ47aPaS0fZ6Vdsf9fQ1Z7FglEdRVgMFMz8Kq9bwvfyP8e0K8F4OoWt67vNngJ6haaCBv0OmffosztlEIUF5MtJzGhSmkfBMnFYQTB+ufv04yCOE2PxUhT4qgACsJXA6rErhZnNhQb7lBy/hRR3Km5SSGfeqiYwAnFeCw5/YPoPTTYc0uSqZs/w/Gt6PiuX0iVMmma5LcKnPMvIFZSjF69yndRPsZ/dhZTWWUeBEbPoVmdiVQc0CgkyYOOBJJu+m7lN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5911.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199021)(86362001)(41300700001)(7696005)(38070700005)(478600001)(55016003)(4326008)(71200400001)(316002)(33656002)(66946007)(66556008)(66476007)(64756008)(7416002)(76116006)(66446008)(52536014)(5660300002)(2906002)(186003)(53546011)(6506007)(26005)(9686003)(83380400001)(8676002)(54906003)(38100700002)(122000001)(8936002)(82960400001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ARdnB+YwMAtTabZRKoQtE6wLMU7U/WRNNWD1GIwZxMIRmsTaCyN57NBw1t/9?=
 =?us-ascii?Q?LiZ5Sd6+0q7O20kwhA7FfWr6Zlcwfj51JETynwwvUYqrlHbdi4TqmcjY0YO9?=
 =?us-ascii?Q?C8E7S704jC8hGdDDuwaLk8boHLrTRq9bsJhp+dUOmQF7RSSBaTpKcF/VTv0U?=
 =?us-ascii?Q?EaN2NUs8a1VxzztfFieDsIf9kMhxQ5vK3CqZhbfbzM4jicHBMYRAStcNVylK?=
 =?us-ascii?Q?IFrBMxX3bD3a7kk6athsz7cK37Bd7x8435YwgDjXrGSMqADj97BVeSOemdB3?=
 =?us-ascii?Q?J6FQPHhC9g2uadYuOU9AYTnIdHA11VbcgAIzsQPze90DiBRKHcFH/+FjxpEE?=
 =?us-ascii?Q?tT/3PIXLixtQXiQpeCDwY0XqNrKcqJZk/1lKxLKLLI0ca+9HpvVf3apd3UKu?=
 =?us-ascii?Q?dqXxZihw3sjQqCy2JXxMzRKGPBU0BJ7ftYhvTBG1RYssWN90H7DZONR1uqtN?=
 =?us-ascii?Q?hYobn53QrnrPp2ku/YuymdeB0ACBo1sLJ1b0Dpyt9+49a3a2lHnlF221rihR?=
 =?us-ascii?Q?CfBuOC77NmV1psnUF/Cu4NbnVh0W8WX/hI0xEQ5U3jNxo+LZr263WTdwCRDq?=
 =?us-ascii?Q?pekPO/cpiBsfvvblVyrW81+vySNgW02GKEkKVLx0Ig0DdZmxxMqdxW0Buj2K?=
 =?us-ascii?Q?e4mmAQsCDVKNI6ztoaBVr+pbGSABXM/gtBuy6+iOQ4cNe0lRAd5vGx44e8jz?=
 =?us-ascii?Q?HcSTaahecM8YfRTX3A/6IY08gmKhFIAszmoFniXWxLZwQPMbUgMmGANFrX+E?=
 =?us-ascii?Q?MmOZ4R9aeJawMCHtQNEnqO/K2KX3cMZFb6K+x++8X442foPBNWov6Jp+CWFc?=
 =?us-ascii?Q?VHxwNDXjoda3f5ltY4ftXOzwBz7pau4+dOuusrBwtJojdv2QpCiBoESE576T?=
 =?us-ascii?Q?Z0eYYUKwzwxLDdIu7A/yau0M4cEVE3Aregl0pjhKnQms/lk1B70Wo68Wj2gk?=
 =?us-ascii?Q?2bvsQVmUOWVla/jmlqv8GtBS1glaEWn7nQJFfj6NaQ/T91tAgD6t+xOWLSrf?=
 =?us-ascii?Q?ivl1IhgBBVwHKjfzkyAVy7WhUlbxF7XL9s5XIx+2AJJa7cBFr48s4O2ZgBA+?=
 =?us-ascii?Q?1dXJuN1Vjq1dCnvvHMNQ9kSmEborVTYVlAH9oOLRP1lL5cbnofz3yeoIACnu?=
 =?us-ascii?Q?dvARiROTy6yZ9MTzBN2ch9gWNg+Z+yFAutc4XnbXkD4+9NhX14hzA3aq//V9?=
 =?us-ascii?Q?XTax3qgwsQSsMIfPrAbV1+WXZ9AAQ8B9m7vWBhc0oLDFAiEVXDThorPVOBfi?=
 =?us-ascii?Q?RBvTg/yUbYCXu9zUzA5Gbk9wVV5j4pyApbNXFWP5fHnzaPt+Iefl+efQQ/Ca?=
 =?us-ascii?Q?SXJQdgQnrsDKe2olu+kplWDRj4a72IxKkDhflCgrMDVBsEzVTI3whTenJSky?=
 =?us-ascii?Q?hemSmBfNzElbTGfljvcCbqrc6MOwrNjbAbELT+uVxhKdr1L3+mtRGCofXQJF?=
 =?us-ascii?Q?evBXrAve19gZbky0hKX6A40HE2OLRPMx3vMcn15WhTFfbcUDc2SySkhq9zmt?=
 =?us-ascii?Q?gvW1Byg7uScGfCRenxWOUYdSfHuXUDNFTwlkap9AdABTQU22sd1xiGDtJFIe?=
 =?us-ascii?Q?cVbxbjzSHjHA+/boKouB7ymmKUKd/Xpyzr07AL008YNQAuuIj7vasFEkDpeM?=
 =?us-ascii?Q?sA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5911.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ff2d65b-1d32-4f42-9393-08db61613a3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 22:57:21.9152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vhrxsrBP5/Ls8z9oU5ahE6TC9Axiz0irotP1DRa418PpEP6BzXQEkcBKZnT3pH8ltlfFaZByXAirdgpiWRFlEn0br+7s991aB3+KIqOVamk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5547
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Pavan Kumar Linga
> Sent: Monday, May 22, 2023 5:23 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: willemb@google.com; pabeni@redhat.com; leon@kernel.org;
> mst@redhat.com; simon.horman@corigine.com; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; stephen@networkplumber.org;
> edumazet@google.com; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; netdev@vger.kernel.org; kuba@kernel.org;
> Burra, Phani R <phani.r.burra@intel.com>; decot@google.com;
> davem@davemloft.net; shannon.nelson@amd.com
> Subject: [Intel-wired-lan] [PATCH iwl-next v6 08/15] idpf: configure reso=
urces
> for RX queues
>=20
> From: Alan Brady <alan.brady@intel.com>
>=20
> Similar to the TX, RX also supports both single and split queue models.
> In single queue model, the same descriptor queue is used by SW to post
> buffer descriptors to HW and by HW to post completed descriptors
> to SW. In split queue model, "RX buffer queues" are used to pass
> descriptor buffers from SW to HW whereas "RX queues" are used to
> post the descriptor completions i.e. descriptors that point to
> completed buffers, from HW to SW. "RX queue group" is a set of
> RX queues grouped together and will be serviced by a "RX buffer queue
> group". IDPF supports 2 buffer queues i.e. large buffer (4KB) queue
> and small buffer (2KB) queue per buffer queue group. HW uses large
> buffers for 'hardware gro' feature and also if the packet size is
> more than 2KB, if not 2KB buffers are used.
>=20
> Add all the resources required for the RX queues initialization.
> Allocate memory for the RX queue and RX buffer queue groups. Initialize
> the software maintained refill queues for buffer management algorithm.
>=20
> Same like the TX queues, initialize the queue parameters for the RX
> queues and send the config RX queue virtchnl message to the device
> Control Plane.
>=20
> Signed-off-by: Alan Brady <alan.brady@intel.com>
> Co-developed-by: Alice Michael <alice.michael@intel.com>
> Signed-off-by: Alice Michael <alice.michael@intel.com>
> Co-developed-by: Joshua Hay <joshua.a.hay@intel.com>
> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> ---
>  drivers/net/ethernet/intel/idpf/Makefile      |   1 +
>  drivers/net/ethernet/intel/idpf/idpf.h        |  37 +-
>  .../net/ethernet/intel/idpf/idpf_lan_txrx.h   |  54 +-
>  drivers/net/ethernet/intel/idpf/idpf_lib.c    |  35 +-
>  .../ethernet/intel/idpf/idpf_singleq_txrx.c   |  60 ++
>  drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 920 +++++++++++++++++-
>  drivers/net/ethernet/intel/idpf/idpf_txrx.h   | 148 ++-
>  .../net/ethernet/intel/idpf/idpf_virtchnl.c   | 495 +++++++++-
>  8 files changed, 1735 insertions(+), 15 deletions(-)
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
>=20

Tested-by: Krishneil Singh  <krishneil.k.singh@intel.com>

