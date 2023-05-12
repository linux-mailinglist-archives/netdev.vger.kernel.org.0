Return-Path: <netdev+bounces-2070-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B20FC7002F9
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:51:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 408871C21133
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:51:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B52A9454;
	Fri, 12 May 2023 08:51:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5881F2597
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:51:28 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA3749D8
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 01:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683881487; x=1715417487;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=byVKnZ0Yr2ebOleP8Q3Uv67FsYXQBoiViLXc6zEp6Mw=;
  b=kPYxapJiT9LrKCSgt+2wu42HwI7eY2r/dYrW3r5qUeosrrHAtXzCwal8
   Us1Ekfm7qV8EUe3PZR0YkgWkNgzbFxWH9wBcWY2RdOZuLjWiT9KCzcYN0
   oNNJ9hHVykhXf9hpv5MW/YFK4NIiIAYvpF2YsIK4nb64GRLqLQ15YKwyN
   JeCBPLHDSBEu21W/vXpps+vZFJqj4D95T1Kqu+a8EZBNAui7TcLMzYs6f
   YOiIjeKprYu368qFwOMbNSlTh0UzsmND/895Fc3joAjSsI9eY8cByrB0l
   5sT7HGhV7cXFnVrenR03pOgBPVOxVQCTZ28XGagAuge9xwHmbtP8jtGY+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="414110547"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="414110547"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 01:51:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="732965997"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="732965997"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 12 May 2023 01:51:26 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 01:51:25 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 01:51:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 01:51:25 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 01:51:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0HOcp3BaNeXA9f+AQNYGTYcquXKW6nRmjn8xO27J1N30mP2R6riT8U0RzlW70uNDrDCNo1iTNN+xhVPelgStijTGLlt7MPvtq2/ku9N/lDE7TWXeHXRpq6e236Uj4pBXpVuStxpHW/+K4uZJn3bUdx26U0UnvxryIonnjkz6F7CrURgU4Il5O/tcJGB4TJs9Fl/z7wRAHE0inUR2fw+bunzRjz11Nd5L9ZCfuGbsj0ZslimnE5YJ5oARX/dxd6Zz8403n881VAKgDllZUdGQlEmmkI/H/V0GN3uJNXwxBYhNq7ZcCEYO+JmxSPTNQXKvV1Kf18q0kf9HRINGWZOYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=09PFVwyQvm/OK107q8oaMRqzyWNpHp559bTGgxc8bCk=;
 b=lh+vImLgvbYE975453FXpK4s1f0jfSNLFiAsiu53n0/aMvDMSiPSho4ZnA9jE1vbw5j5siKz4meCk64Rc5tgFIquGxOiCkbRbbtlNIdHMB2yXTelEZNYzPcrF1HpN6BVmhmhE+9PML4v90lfOzjAn7jAGdDucKbNZuekvKYZHyc2HLPsOzfGAwg2ghJ+CX79BjPI7CSnujWLBFDF1MPCKOiGLCU4CGCic6rtjRTw/lRtvuSeIzDF0ki9nPplauUOg7pt8btGjAMRKbnlBbW53rTQjrd+3HHxX8pJGYCYao4o8FsZiH9wVC1FtqcEgU7K2MUl8wNVSDzd6Awv9l9Mxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14)
 by BN9PR11MB5483.namprd11.prod.outlook.com (2603:10b6:408:104::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.23; Fri, 12 May
 2023 08:51:23 +0000
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::748:8cea:e1b3:88f8]) by SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::748:8cea:e1b3:88f8%6]) with mapi id 15.20.6363.033; Fri, 12 May 2023
 08:51:23 +0000
From: "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
To: Jakub Kicinski <kuba@kernel.org>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "edumazet@google.com" <edumazet@google.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Neftin, Sasha"
	<sasha.neftin@intel.com>, Naama Meir <naamax.meir@linux.intel.com>
Subject: RE: [PATCH net 1/3] igc: Clean the TX buffer and TX descriptor ring
Thread-Topic: [PATCH net 1/3] igc: Clean the TX buffer and TX descriptor ring
Thread-Index: AQHZgpmIJU3pEBCZU0q9nhkqarffDK9UV20AgAH8XvA=
Date: Fri, 12 May 2023 08:51:23 +0000
Message-ID: <SJ1PR11MB6180BBD70342998B2C639472B8759@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20230509170935.2237051-1-anthony.l.nguyen@intel.com>
	<20230509170935.2237051-2-anthony.l.nguyen@intel.com>
 <20230510191428.75efff66@kernel.org>
In-Reply-To: <20230510191428.75efff66@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6180:EE_|BN9PR11MB5483:EE_
x-ms-office365-filtering-correlation-id: 5e072c57-2d51-407c-fa26-08db52c61039
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9W/GqhRmTjZOEggR55cZW+0NweQN9lW4cGtxLpPh5l90dnlgUG4dgDGtxnX44oh+4m8mrZL4Bc8LZI9JTBUKlvCHcNascK0l0NqqtihDN/vrAjJc2wbaEKuqTZx6p+iXrE67Te1ZXqxaOfyI09+n1mYdHA1eZHCHrvo9eRXZRc4QaOkCsQUfil/7O3fs2DGp8BfMEnkBgpb8bYoUPPQzJPmFbQLiq6aLezXz3r00/SrOetCUARN5I2ZKtujGc5a8ft95PJFSaz5mlRXLDZHf90CJKXZAE5Mr66AuVi2m/63hGL3ZPQNKJp39u0axFR1JOD6dKo9sQT5PXJV+UiF8NGgREbhPZMe84LToVYQWpfYFa6WVrjeoi+n5EdvuK05xGyDcchY35ygPSwsAbLTMciscaM49RFZBI/OumjqoibmDEbxWWOi6RQ9eo7IHZjwWsNNYQ9n6JtlvCKBTw61rIyMomt1zf+pWZeK1u+WYDPERBgEWI8sJ/iPgNj8lfuBEvt7CJcxw6W27mrOuA+TlpK1um2L29DXz7eVZi23f6y767tvw4NBgxBgjvl4EiBTd3vs3go9MbGfkg3LBFMos2QAMAeFgto/oCdpu3SixDKU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(39860400002)(136003)(366004)(346002)(451199021)(110136005)(478600001)(54906003)(45080400002)(76116006)(2906002)(64756008)(66946007)(66446008)(66476007)(66556008)(71200400001)(41300700001)(316002)(6636002)(4326008)(966005)(8936002)(8676002)(5660300002)(6506007)(186003)(26005)(9686003)(7696005)(55016003)(122000001)(82960400001)(38100700002)(38070700005)(52536014)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZnfHj4kfx7ddjmwX84XtItBx6H1m8QJiO/ZQJm9EspQIgCUxhVRx1gVYqKSc?=
 =?us-ascii?Q?Gli0iKbTjKLbhun2SZ05VY2YeVTpyItkSdgYiyEp4YP6OT652IupbUdfpQIF?=
 =?us-ascii?Q?qYY59+QW3pMlKAHqJ+d9uhgIYLB3Bd6jJZjhIRDGKpXAos8av5vGnalHLCNb?=
 =?us-ascii?Q?TIXw0AcahBEPsQl+jrhxOD7MZOpsSDbjE8kZSQcySIsjKmQp2PbvUWeb5ni4?=
 =?us-ascii?Q?XXQHlQOY6aOIeYcs0ocmio4idIDV5yzu95XhD6Bn/jxQZIEWQ3JsNvGtzS5k?=
 =?us-ascii?Q?bzU0cpw2IqpoiIALOUH/JG9l87x4DO3RKpX2pV3R/QwWg5bvtNXC+DHYJHoq?=
 =?us-ascii?Q?eF3oN7lg1banFufT+lkjHKUfHgnHxfzb8S03hXTlmhSzWcrqfnGywr+SIKSk?=
 =?us-ascii?Q?VJp1Thp4mZ2NDj8uIMzmm5In6D2OhTMeeZDyoLnmKxGVxFmaxeAduaSLA1zQ?=
 =?us-ascii?Q?mywsProST6GheBVKcoSQFJKKz2Z9VHyhXiq1SeuuZkYEwBt2jMMEic36Dkse?=
 =?us-ascii?Q?zmwkV8iKcZjIMGS6glYx4+9rZx4yNa2oSArp02dtwpFLTrjhor+XACBMDNru?=
 =?us-ascii?Q?1gH5Tg0ipSF0k3+EDT69gHN34WKrA3y5I5Wqnm9HeQxuu2KKp6e6PWLXwn/j?=
 =?us-ascii?Q?sDxnWQS5tXBr7WWwrBC3Wx4ZkQ7zzN0SJqcg4t+qvOJ8mvBRdziCy/IEHPtE?=
 =?us-ascii?Q?YIPp8bRgoB5qZUqJQ0PW9l+E+xRY6CnrHr2x3lOy9Ojd/zX2lZ1Rc5QADsgV?=
 =?us-ascii?Q?tYO1rfDcFW6GwHtqVAdSQ+7CGTSqavUgxlRF0fG5nHpJc9xXWEvb59ABGGjN?=
 =?us-ascii?Q?ZtbuArYs9LdopMrCGvdJCxCJgrMaMhlxkpQuNf8QF3Pg/j0u8V9Mc7k9PB4H?=
 =?us-ascii?Q?keLBszU7ZXqXsjJzwU00sEVRvT4s5WBt6CeHx59ClpDGMbXvsnWbBYIhfsow?=
 =?us-ascii?Q?4oPNOpnLNoYvB253ZxhP8P1DiMvZWI29pB2HfSXwpecg9pTQQFB1mQngrP5q?=
 =?us-ascii?Q?Grfs5kkUaIQepvlb6gMJXvqSJKlOgghxLM2MjVv5QE9kwfr5V06jNrM12vOJ?=
 =?us-ascii?Q?I/n5TAXgrHC6f3GPXVVvKIQXG+kFinLMgK+uj3WYJmPJbiu+J0Ba+O1wvrFg?=
 =?us-ascii?Q?TLWzPb1uel6OmosToNzHLcKze6hMRyttiZynFL1h95rDq2qxajfE4L4IPBoT?=
 =?us-ascii?Q?GXbo3QuYkLuUhav4rK/TG8/g0HteWPEHltX2sxicOEjd1v7jphiSKASoR0xf?=
 =?us-ascii?Q?pRAtcBmH45FznAlgJ6WBatQ8yaPQ1hKQOPlr46hcCRe9mv7DkPbXOf/NSQur?=
 =?us-ascii?Q?dWhq/gS6GBfv8xQ8OqyOtiLi8Hr7MreRELW3dFWSnbFLc5e9l4Ha6rt7TYdj?=
 =?us-ascii?Q?4Vt0DMcI52zoZt7ksYJKGTJueOaIt2FYaRpf2cO8uw8bCUnApOiok/ZXTrHb?=
 =?us-ascii?Q?TxOrQVS5AMgOoyWQfW8apcvy4McCz8h6gn/b4sbwxLYtJQuNDkcXMNdtaq+G?=
 =?us-ascii?Q?PRZvLkh7fV3j8IxwQEtPH4bn4cTjeO7gG1tPE9y9eKaIohERsS+XzivfJncE?=
 =?us-ascii?Q?gaGtDnMoggs340sM1fbiZRGhhlUlUwA1LRHxIRGmo6uXXs+llcJPrNxlvZng?=
 =?us-ascii?Q?FbAglluFTAH+tWxNOquKMCM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e072c57-2d51-407c-fa26-08db52c61039
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2023 08:51:23.1742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TDCaYXRsxA5hPCYGjqf4tAoSPM4DCvEBqNcMsUaNwPKPV3pZI2QSRaeTT+QjuM7UQZ9R4Pbl1Je//Jgq9qwe50dEFoQKDypoUj0B5zqvmLulOtu6k4A8ztRPJkbxYDSf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5483
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jakub,

> On Tue,  9 May 2023 10:09:33 -0700 Tony Nguyen wrote:
> > There could be a race condition during link down where interrupt being
> > generated and igc_clean_tx_irq() been called to perform the TX
> > completion. Properly clear the TX buffer and TX descriptor ring to
> > avoid those case.
>=20
> > +	/* Zero out the buffer ring */
> > +	memset(tx_ring->tx_buffer_info, 0,
> > +	       sizeof(*tx_ring->tx_buffer_info) * tx_ring->count);
> > +
> > +	/* Zero out the descriptor ring */
> > +	memset(tx_ring->desc, 0, tx_ring->size);
>=20
> Just from the diff and the commit description this does not seem obviousl=
y
> correct. Race condition means the two functions can run at the same time,
> and memset() is not atomic.

While a link is going up or down and a lot of packets(UDP) are being sent t=
ransmitted,=20
we are observing some kernel panic issues. On my side, it was easily to rep=
roduce.
It's possible that igc_clean_tx_irq() was called to complete the TX during =
link up/down=20
based on how the call trace looks. With this fix, I not observed the issue =
anymore.

Almost similar issue reported before in here:
https://lore.kernel.org/all/SJ1PR11MB6180CDB866753CFBC2F9AF75B8959@SJ1PR11M=
B6180.namprd11.prod.outlook.com/

> --
> pw-bot: cr

