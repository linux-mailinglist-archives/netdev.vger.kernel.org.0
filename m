Return-Path: <netdev+bounces-11304-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42CD17327E2
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:52:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71E421C20F62
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 06:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00933A2C;
	Fri, 16 Jun 2023 06:52:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24E4624
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 06:52:07 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6CB191;
	Thu, 15 Jun 2023 23:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686898326; x=1718434326;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dFjutCVvUKm0EGyS5clm/18WyBC+AaDozgN1zTQgPbY=;
  b=KuA+UkK+ScYCir50gipVcwcLUHRTgMThKnqRykD31aA48N+H6tzW+Kd/
   YkrEe4musyT0n5fDHaWEwtyZW9csGbfkfnLyVfNAdN6aMIYLyCA0BUUko
   O58Pr7bYMgBKcalfQITDxzn0I/mvNTRy2+biNaiA3hFfzJznUUjlmSab8
   Q/luq5ZTrq1L/8kYUZRG9myG7cT9u0N1j+Ft9Sk+8xTfgj+lGmFJilZqw
   P5Xm7kV11ypEkC59OCGXGJAMlCirX/ATPPQtZQSC43Eeci9RAxzRtOdA5
   EMol9uFAoNsY+9/f6NCK8DP49zhatA9dHg79InNjlpk/flSlMrrMkHKUU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="425078452"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="425078452"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 23:52:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="690101331"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="690101331"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 15 Jun 2023 23:52:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 23:52:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 23:52:04 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 23:52:04 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 23:52:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ii6fvkxw9rujyHJy+iwA2jHEjoKb1q81wpckWJOHH7n8jfNwmzXeaaOWxv7U9kml5UqADUvdSWoezwc3OIYCRvOysPnnq5T06FHU+tcyXNmb4GoWfaB5ZBX0FxRHrWmQYvX1egpMFoSfwIX7v8KNXZkubbppRcIqcN9KDYOTvJv14aaF3VqhYgigojBV1UHYJpda4nNXJ3/iEFj2IWsODW6wduEljw5DetwLv4PtLDlR3UrJ/gFp1Mg1dZwv4sjjWVz9GN/KsMoML49/a4RvpeJMwpGTQhjKaBRaulR2oZkimDyuI5phvUogOX2cjP3HPHPM/uvBJ8ww/RrfsIY+eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dmJQljvdRmTZFL79fiPXmyCQ5hOXH+yPXo+kMp2/+M4=;
 b=m8inRvmUfXqIiyFjOSxCyp8CE9QEDTzDUecRgm7T+9fR43isDoOaWHWTdlopINkjGJ51n+pmopfSejsajUUdoxJUuzUGtvrbyj6kZmc61sbdN0plrQ8wwU/a4EMUs61Qbqm42ha9enmfVZeh7H5ePiAO+Ujz8GZLc1u3oL5zIw/b4FoCs/eaQeYjW6IRohRI/YwAzGeu5rJYdVh23yCx1XP2TYf+fk63rckDuBVXvCqj/R9o8LzbzUnkAf4NgIHhDChagmsciWCibzkHLl+m8wrXU/bKB+EJmNQdUOpvaiAWfC4YzyhFdFiBWQlbTnwSQXu+MN1wX69u+wXDyPBD0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB8192.namprd11.prod.outlook.com (2603:10b6:610:191::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.29; Fri, 16 Jun
 2023 06:52:03 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6500.026; Fri, 16 Jun 2023
 06:52:03 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Brett Creeley <brett.creeley@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>
CC: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v10 vfio 1/7] vfio: Commonize combine_ranges for use in
 other VFIO drivers
Thread-Topic: [PATCH v10 vfio 1/7] vfio: Commonize combine_ranges for use in
 other VFIO drivers
Thread-Index: AQHZlZ4c25/TIBmFoES55sjpUtDtQq+NEcDA
Date: Fri, 16 Jun 2023 06:52:03 +0000
Message-ID: <BN9PR11MB52765D6E90B38CEAE04128618C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-2-brett.creeley@amd.com>
In-Reply-To: <20230602220318.15323-2-brett.creeley@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH0PR11MB8192:EE_
x-ms-office365-filtering-correlation-id: 864770d9-5333-45ba-ee00-08db6e3630f6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jEF1r5d6gpbsgK5gsBsl6U0l67QVhBBFUYduPLqR52UojpieDcBGOk+JVTHz8aq5pzCrb6s3NhCIraNZtjfXJ9YxGbxzpAOXPwOuAiKCNhLPKqE4J8Nvl0oya8bMrTgzdFk12yhqpcbLHV8I5vWKu6zHFudd1v+WGmKWJXn8Z3dH8caKiMN4GdSzVURLThAhA3qaBM4rFY8ru9QnqvEE7zqxMoF5rqRzTG61+fzWax46vY/J4KLCLTybrj7jZaYn1tedOTegX4bxKfK2VBOrq5Lzfu5Lk7y7+TpybK3IXErE0vY8qSxzk/BNQAl/bsaP9JW1IudvC1D/NNHMILzpmGoup2L7GdZDtrWP6VxQqb30BegRBCQ2M8whwUA9frbqY4CoHPpZFeWynudiH/amdlrltO+lweKIv1wwBfBaan/1glKviS1R9A7v0PzFGluBoJfM1Nvk0wCtRPGWI/Gqssi1e8gkIreyxCxamPQI/cNikXL9qbsiMTgq+m0+89nKm069vam3DdTg8F3y0o5IvjCaCG7ZcW1ApYt4gGRdgc3yCh8KLSuoEtrKEeRcRYUXotyvCDSuooS1JP+N4Y8tg1ZldO6ytyhTc1oJFGaGzpNILatIelVBSm7gn7v7YjuA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199021)(71200400001)(6506007)(9686003)(26005)(66946007)(4326008)(316002)(64756008)(66446008)(66476007)(66556008)(76116006)(186003)(7696005)(122000001)(55016003)(110136005)(478600001)(38100700002)(8676002)(52536014)(82960400001)(8936002)(5660300002)(41300700001)(86362001)(38070700005)(33656002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kcYFf11uCCTpDhEpn8oVQuvcwu6t6zS+YVkX7Dbsptzo4HXMO2VHpW7WuGbN?=
 =?us-ascii?Q?3RQEhOULFaX1G/wRYmsgjgDx6DIkJJ326d2bGXJaS8+rgT6p9AV3wxgwgvp7?=
 =?us-ascii?Q?5rt5vTykG7Fi/cTBn0UTajtQ++Kvt9Me4DjxXrbTPIiaPfajgs3MVmfIzAG1?=
 =?us-ascii?Q?ULkCAmdTMmCXczv/mpQEKfTstSNvbZII7xMjDe7Ic+4w6xRVgnjLW/F2aIrL?=
 =?us-ascii?Q?PpzRMrX3pATNR4+9yJgVNHe7DLJUKWWN+z71+rUY88TlQcfN1gCdmyqPB2OV?=
 =?us-ascii?Q?zAy53fkuhS1TMn+eMe0eBTUL2+JMeptOPwpf5KWGPO4//N5kxnRw74q4rhjE?=
 =?us-ascii?Q?CU9SDhVAiH/2i/L+X3kxKMUKiwpBoeDHxG6Z1xrshPCMaxu9pzkLLOisdddF?=
 =?us-ascii?Q?HjdMe4rPp0N1Qkk7fOsfgcfii16Z08aeH/Seh2NbozbH1/ti4UlQVwWvsgQb?=
 =?us-ascii?Q?I8zN1vu4kN7NEWTY7SrfzeOnC8h4v1MN5hqiaQ5HwwkZ/Xmtjkcadc0PAEXB?=
 =?us-ascii?Q?JOfKAoQ6FdEcGE7Nf+CWJ3VlWzBktz0boxw2+ug4r/5hKBSzUBTzGxgAVTsf?=
 =?us-ascii?Q?xCP7lXZ1gw9gx7KnGgPGb0/oo3w2/4fQ0YRcUZAPRCpceTN5NZ+2cnHredRl?=
 =?us-ascii?Q?ZNzrmcNtR9OBulMeUF2G+tCj9JHobv0+maVHutzOLwFX2NIOJ9OVNe+/LJRF?=
 =?us-ascii?Q?8RcnMBWo2cdsqx1egeknaOsXNu813oBSUpCrRDARn/2w2xNWc+QfULGOvwKl?=
 =?us-ascii?Q?8dVjANyVKn0ZsUinFDbpzshT9YS8bAk3XV4QSo2dBFF/Iud3XUiFAYDYx6pN?=
 =?us-ascii?Q?2Nj0xmtNpnmBSPV2Ndiu3uxdIuYLnqTtKUNcrPTMa3HjVknPeIdKwMcOAXsO?=
 =?us-ascii?Q?0ALYoYjaug9FSKq2eVVyQjC1ijn47WbcklpSHn/1voePVlYazJwLeRzaUmnf?=
 =?us-ascii?Q?RhbICANlky+eUAyS+oTvY9kxznR4g6G8V5Fa1DsMCMfyKafBN0Xq5s9nU2EK?=
 =?us-ascii?Q?8wx/MhwVDaFrsNq8dfOQjT2R37a4yZV9P8Ux7LReFehDgciQkoEWg9eqA+mB?=
 =?us-ascii?Q?ilq8IOpT0Tf0r3SdtcOdqxPx7RjTl7i3I3pAiOTSDERrjwkk5JyZfB7TCiz8?=
 =?us-ascii?Q?b6PF32L27rxD6Zu2sAzVmtxzcpz0tdXTkC98bXKYagG4AqrxNSL0H52/MApQ?=
 =?us-ascii?Q?sIkXhp6qi3JB3rvPG/z0oS3k0UJIaHR5IdfyQ73RKvISmK52BdqbZrE9sOjQ?=
 =?us-ascii?Q?Pi2+LhP8VlcRWlXQ4OipjIcAWJOhucI28RaCHK4MZbbN0ouFeB+lEWu4acJK?=
 =?us-ascii?Q?bbMuxUBiXrW/NIughsdJjJuhrdxkPVMRVPjvbKOMEif5m0NUoYzWtNoXSX7A?=
 =?us-ascii?Q?yVrO0VlLoE7D781PwRX9KqyvqsSrvFEMv1CrgBpdGKXrVanurtwMqjCvABhc?=
 =?us-ascii?Q?ihiFGK7dmqbKoJqDNBl6iNF3ttYC4l8S/rwmgiPBElbo7xOfQh15E0gJmJPZ?=
 =?us-ascii?Q?+xa0QUEYQP7Q+W5Tt6Wm9iNFMV/OxpSa0Cg4dryLMFTM/HWlJLD59oZvaKUa?=
 =?us-ascii?Q?k9S6JVvDCDUzJ9B/L/cqpdxfDSEWJq9t/XtBpc3N?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 864770d9-5333-45ba-ee00-08db6e3630f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 06:52:03.1534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oGKQ7FwPBHElu1gfNhiCpuCax1ddZLmep4q6cJBaiD+bSUxq+lK9X3NqOFPkr4fREFo7UVigZ9fuSXJhwzL3bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8192
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> From: Brett Creeley <brett.creeley@amd.com>
> Sent: Saturday, June 3, 2023 6:03 AM
>=20
> +void vfio_combine_iova_ranges(struct rb_root_cached *root, u32
> cur_nodes,
> +			      u32 req_nodes)
> +{
> +	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
> +	unsigned long min_gap, curr_gap;
> +
> +	/* Special shortcut when a single range is required */
> +	if (req_nodes =3D=3D 1) {
> +		unsigned long last;
> +
> +		comb_start =3D interval_tree_iter_first(root, 0, ULONG_MAX);
> +		curr =3D comb_start;
> +		while (curr) {
> +			last =3D curr->last;
> +			prev =3D curr;
> +			curr =3D interval_tree_iter_next(curr, 0, ULONG_MAX);
> +			if (prev !=3D comb_start)
> +				interval_tree_remove(prev, root);
> +		}
> +		comb_start->last =3D last;
> +		return;
> +	}
> +
> +	/* Combine ranges which have the smallest gap */
> +	while (cur_nodes > req_nodes) {
> +		prev =3D NULL;
> +		min_gap =3D ULONG_MAX;
> +		curr =3D interval_tree_iter_first(root, 0, ULONG_MAX);
> +		while (curr) {
> +			if (prev) {
> +				curr_gap =3D curr->start - prev->last;
> +				if (curr_gap < min_gap) {
> +					min_gap =3D curr_gap;
> +					comb_start =3D prev;
> +					comb_end =3D curr;
> +				}
> +			}
> +			prev =3D curr;
> +			curr =3D interval_tree_iter_next(curr, 0, ULONG_MAX);
> +		}
> +		comb_start->last =3D comb_end->last;
> +		interval_tree_remove(comb_end, root);
> +		cur_nodes--;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(vfio_combine_iova_ranges);
> +

Being a public function please follow the kernel convention with comment
explaining what this function actually does.

btw while you rename it with 'vfio' and 'iova' keywords, the actual logic
has nothing to do with either of them. Does it make more sense to move it
to a more generic library?

