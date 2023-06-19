Return-Path: <netdev+bounces-11895-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5409735053
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:32:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 146621C20848
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC18CC131;
	Mon, 19 Jun 2023 09:30:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C61BE71
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:30:28 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73DD10F1
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687167002; x=1718703002;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5hJPKzggSLXq8EPAxyc/pQWFgJj4nUTY6bfYNZiu6Tk=;
  b=EAgP341SVbgJSD3Z0q29caxckbu8R+nM129ltZIyxTfh8r94CckaioZD
   vbx4Hv7COOPfx80jUdujUokjF3MVEyPw/Ov+6D5ezRhELQ6Ujf/TkNg4U
   Zx2Fz1qjAZoPcKjFNcQrrsTNzkDWF7SHzNL6I0uCsNhwRpsVbveAdI/Hr
   +3TyheXQEBBYpycj1rbUONaR3gTC4znJ8MkwoxX7uF3k81dUhcMDl4M6b
   8+fBnJKMayb7+IRjb2+w2pQmGJbTLxWdQO+t7Gmx9vHwCK63f1T9C41pY
   3hhU//DKiqPYbsd75BOuPhjdgAC8uTzKuGD+eqV1ukp+5KCUGyM1hV59U
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="339926153"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="339926153"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 02:30:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="663924367"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="663924367"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 19 Jun 2023 02:30:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 02:30:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 02:30:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 02:30:00 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 02:30:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2jzaSLpUUj2v2xSSqxlFUU7swCUMLNWJWvrhSITS3w6bpqTV+Gl7XCyhIuJ75Ccw3516p+JCrPJZFix+rhVVXsNSPz22b+n934I2ZeSqj2zAsk+8zsvVC6pOJ/hXHyaSUuDmn0WerP6IILgDDwFVJLZqgKlH/4xTax88EVPPA7lFJmzdvC9gyjjxO4uVmM7XwWeAbnpFStNT36hvK0uCIh4Q59DhU9BZAA8agrT1D1cmBfr6McA03d8QrH34Ly8Y+XuNuNNbPyGM6++vD8GgeA7R/POujw3y15K9xDawWt0yJcu9qfjzN7gzVbvr+GIFUg4leNQPaM4nKUtkuw5tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p6pIEpkyY/QQsuiipsWiONtJSs3lF6Q9Le7F070vBpk=;
 b=NuAV6ai+tj+wBobI5jd8jGBdVCqrUxyxZdetwxG2su4iM4dd5Uj1l4VDx/qVtdFiKtR0THBSz8Bg8AXJ6KvIj29a4qoZC7nzbWeg6uLAS5CtW1jqX+Bx3QLikHhW/HrPueTZCdFvy6PntJ+aaQAZ9mNBcp6FQqdV/Wd20XX341AHuf6TwYvrhShhiJIQv+ScUcCb2Hv1/XmTu6x0vb/saNgNsA0dHKuROC1iCW0T3YpjjDyhQEO8q+90TshJCwdXk8AJ8nH5tF9uk5JBxM2Qe/3IEAIYW4w22NX59j1ZyAd1mIkjn6Qg6TuiElziSEc3x95RJg6xk5vVaKdoGF6KDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21)
 by MN0PR11MB6256.namprd11.prod.outlook.com (2603:10b6:208:3c3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 09:29:58 +0000
Received: from PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f]) by PH0PR11MB5013.namprd11.prod.outlook.com
 ([fe80::fcef:c262:ba36:c42f%4]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 09:29:58 +0000
From: "Buvaneswaran, Sujai" <sujai.buvaneswaran@intel.com>
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v5 08/12] ice: Add guard rule
 when creating FDB in switchdev
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v5 08/12] ice: Add guard rule
 when creating FDB in switchdev
Thread-Index: AQHZneAqU82Ygil1TUWw1H1xAzojV6+R5Vzw
Date: Mon, 19 Jun 2023 09:29:58 +0000
Message-ID: <PH0PR11MB5013851AD8916B77CC15628E965FA@PH0PR11MB5013.namprd11.prod.outlook.com>
References: <20230613101330.87734-1-wojciech.drewek@intel.com>
 <20230613101330.87734-9-wojciech.drewek@intel.com>
In-Reply-To: <20230613101330.87734-9-wojciech.drewek@intel.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5013:EE_|MN0PR11MB6256:EE_
x-ms-office365-filtering-correlation-id: ac937afe-37c2-41b1-d95a-08db70a7bfc5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WqPaftkhj9Nnxv7G6OHMWk6Lk70ULgX8lRlpyf/8AlCrR+BukR9O8VhUwd3LlE0pa4AsYOpnZWn0z2UxQHmI0ayAE8ufrPqfrhrq2jpy3l+wWfmsV7+HSOYuBxQv1MWaKn8GEsup+jogczIb/GQV5nsMfmpIcpBEATLvESNAweWyfHGQC3aUac+OghPBUttp+3ySGkg1N0YuYsbddNjOLDtvS95i3NdSGvn+Et6+b35mzbSiXJq6XAoVrfekrl/U27biMaaHQ3Gq/SE74nEfjYC48DkeHZEiZ/8aMREcmY0KvnYLy3PWhzIjTEc6FTOHCQrd74ULvgwaG7W23xXB1g0RB1oQTolGbZEYcimypGN9lzupuv6B0PfilHzwf2p7ZJ+wb1ZhGL5/ST1KLqR3zON+CaTeEF3wf8+OBkxhCBxxw8LCJIFnZduEd720VbXALIs1Rp1jXEofD3PMXgYpPzeZFLBtSPTV0BC6L1VIol0nGcYKtMiWQCufj9nfvcy3AXBvmpPGPQt1kkwm5BxmkvnJGYXkF9puDpe1vpOHOSvLiP5lsrYEGSQmEEzIJIYU+fnbNTk/GHWfmxBcSkmUDdhmj4P6r6frlOHRb7WC0Bk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5013.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(346002)(366004)(39860400002)(396003)(451199021)(52536014)(33656002)(86362001)(41300700001)(8676002)(8936002)(38070700005)(5660300002)(66446008)(64756008)(66556008)(66476007)(66946007)(316002)(82960400001)(38100700002)(122000001)(83380400001)(186003)(9686003)(26005)(6506007)(53546011)(71200400001)(76116006)(4326008)(478600001)(54906003)(110136005)(2906002)(55016003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ozztgUlCW71mulS+rWTKiP0T+qT2BKVpUMgqDd9TLB2HpFaEO2ZbUhG4hYId?=
 =?us-ascii?Q?QL1W5TLhC5RPrh+EMriyIcXO59p6REAvxoP7Lf6FoHXNX02yHvgASiLRnhyi?=
 =?us-ascii?Q?y0eFSAbKpUduJqV/Fyq7ARQLvng/ty+9BIHfQsNH0oWe1jFYTE0cVF6CUKKO?=
 =?us-ascii?Q?eaO1WMLmv2oKFgQHPdnHLki5tDUDREq22sPINPpgSJUzEgwuZ8IVgGrGXTp8?=
 =?us-ascii?Q?z4knG+wM12w/XW5uT1ZZeCDj/VIA3bbMHYd/eDUeYrD5pXOeJZjqZsyG+U6s?=
 =?us-ascii?Q?GBfeHmYWMbMQ8UDPwIHYt98m00sBhMnfWWKKeFcYhiYGLdAG9jKkcXqCapl0?=
 =?us-ascii?Q?feqKd+5KXmbLvMWvh/dkcabE7SDISXyF108JE7UYE4UgCCD2HzEYw3qXoFii?=
 =?us-ascii?Q?2VTxpLvKD0/DaRdoftg9T1Va5QdUEkf1MLd9baHqnXfYVnJFitjCqlKFKZRX?=
 =?us-ascii?Q?iwY6YK/N6ZiY8fXWb2UuxnZCXLSx7nd5nzvFxK31wwwQ4lGXuGr7r31/ZArF?=
 =?us-ascii?Q?ILSiU4XbwmtF1janeaPka81D5NGos8qDjQ+UEhnDD4wDiBtldJNkL2wZm8li?=
 =?us-ascii?Q?s+K3v7OpdufdlJfaRsMQKOprM3PO4oxkYqiesav2qimuX6/h5mN6m/0hrCVE?=
 =?us-ascii?Q?/Oy304dTqsg05HIwXMiLANmRMmZa3IJR4judKZeY7raL0+rMFRs8dacLkyld?=
 =?us-ascii?Q?+jkDqtjKuZSkU2aiprQumGmOsym1KhQ8nXTsQVAknDRqg54yKQtGmiQOjCLQ?=
 =?us-ascii?Q?XZvBAEvEvxKVye3b0Gaz3CocP28gug79Id+TYHNhiHf6yFwXypJpnz7ViGeG?=
 =?us-ascii?Q?yoqedAbF3AKKQifBiB7o8ah08FFGhfvUHWVlM1RSTkf5EOUdqy0WcW3SHs8+?=
 =?us-ascii?Q?Cjzyal9T1/dvUMMiI18FAcNeg14YWl9L8RIyipaMM4FtAaMw77/p4CuXYTnh?=
 =?us-ascii?Q?XqoMKJxEgmFnbiz0nWFy+qJ+Rp5sNH5/lXx2ebB7RaTl0RTu1w/xYtP/L2E3?=
 =?us-ascii?Q?AZF+7s2H7bZ3Aodh5wvcgIE+haYfKaFvwyxlJaMLIKuflrMp1CzmDS1neCWa?=
 =?us-ascii?Q?spFFjetpKZ/+1B+SFJODrZVHm/w6LkpbQQXCCJph3oOCJI9MaTDb72wfDSOB?=
 =?us-ascii?Q?+e5x6vijYLnT5fMY1XzDkPj9HGmGUWcVqHJlyZdX/QF3jmy348x+xs/6dRNN?=
 =?us-ascii?Q?fF3GVoNU868Vr9IxFQsvd3kLpg7k4nk6SiS4MbI2DhgJwVHChwGix4bR94DQ?=
 =?us-ascii?Q?2dkwWoc5e5Wf/fnt/Qfc/S98tvWjT8AYkO4x1VY0htEHum7JnbXVp0mKoYQX?=
 =?us-ascii?Q?pP9ae33HvIFzHXV9Feoa0ckPwuPB86mpjAFUQSW6/h0/5COshk2QRF5rVPMP?=
 =?us-ascii?Q?l8clmZr1TnJl4IZqvA8r6voVCu8Q2sW2tEglzKtuSU6ZRe9etSUgEyhUUCes?=
 =?us-ascii?Q?gLHjfdj24drtGy6S2MxtGsC0eSxhws+uEVeSXvUvY5kwwQZ4WLFmpERwg6On?=
 =?us-ascii?Q?UCSAvFwb8Tr7IugTy9FpqInOe11kXg+hhZZhfTqwqwA4OoaJpqas8KKtPcrt?=
 =?us-ascii?Q?w53L5KmwBJDuAO71wB6LEV6kn9Oz9uDpbSUM0376zepQam8syR2OKTISplSz?=
 =?us-ascii?Q?mg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5013.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac937afe-37c2-41b1-d95a-08db70a7bfc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 09:29:58.2065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vYe/gBPWJCvJgGPdyg/QLmSBIGhdxRrwog+XWlruCPAmvud2R8Ulubd3b5Ybd49IoWQeJpQeQShZF0Q68C0B7GWXcQsr7Sq9QtqcjGE3y3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6256
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Wojciech Drewek
> Sent: Tuesday, June 13, 2023 3:43 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: pmenzel@molgen.mpg.de; netdev@vger.kernel.org;
> simon.horman@corigine.com; dan.carpenter@linaro.org
> Subject: [Intel-wired-lan] [PATCH iwl-next v5 08/12] ice: Add guard rule =
when
> creating FDB in switchdev
>=20
> From: Marcin Szycik <marcin.szycik@intel.com>
>=20
> Introduce new "guard" rule upon FDB entry creation.
>=20
> It matches on src_mac, has valid bit unset, allow_pass_l2 set and has a n=
op
> action.
>=20
> Previously introduced "forward" rule matches on dst_mac, has valid bit se=
t,
> need_pass_l2 set and has a forward action.
>=20
> With these rules, a packet will be offloaded only if FDB exists in both
> directions (RX and TX).
>=20
> Let's assume link partner sends a packet to VF1: src_mac =3D LP_MAC, dst_=
mac
> =3D is VF1_MAC. Bridge adds FDB, two rules are created:
> 1. Guard rule matching on src_mac =3D=3D LP_MAC 2. Forward rule matching =
on
> dst_mac =3D=3D LP_MAC Now VF1 responds with src_mac =3D VF1_MAC, dst_mac =
=3D
> LP_MAC. Before this change, only one rule with dst_mac =3D=3D LP_MAC woul=
d
> have existed, and the packet would have been offloaded, meaning the bridg=
e
> wouldn't add FDB in the opposite direction. Now, the forward rule matches
> (dst_mac =3D=3D LP_MAC), but it has need_pass_l2 set an there is no guard=
 rule
> with src_mac =3D=3D VF1_MAC, so the packet goes through slow-path and the
> bridge adds FDB. Two rules are created:
> 1. Guard rule matching on src_mac =3D=3D VF1_MAC 2. Forward rule matching=
 on
> dst_mac =3D=3D VF1_MAC Further packets in both directions will be offload=
ed.
>=20
> The same example is true in opposite direction (i.e. VF1 is the first to =
send a
> packet out).
>=20
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Marcin Szycik <marcin.szycik@intel.com>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v2: init err with -ENOMEM in ice_eswitch_br_guard_rule_create,
>     use FIELD_PREP in ice_add_adv_rule, use @content var in
>     ice_add_sw_recipe
> v3: fix kdoc for ice_find_recp
> v5: free @list var in ice_eswitch_br_guard_rule_create on
>     successful path
> ---
>  .../net/ethernet/intel/ice/ice_eswitch_br.c   | 64 +++++++++++-
>  .../net/ethernet/intel/ice/ice_eswitch_br.h   |  1 +
>  drivers/net/ethernet/intel/ice/ice_switch.c   | 97 ++++++++++++-------
>  drivers/net/ethernet/intel/ice/ice_switch.h   |  5 +
>  drivers/net/ethernet/intel/ice/ice_type.h     |  1 +
>  5 files changed, 132 insertions(+), 36 deletions(-)
>=20
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>

