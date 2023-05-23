Return-Path: <netdev+bounces-4632-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A981C70DA05
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:11:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA4A01C20D10
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA3311EA61;
	Tue, 23 May 2023 10:10:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52CB1E501
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:10:58 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93515FA
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684836657; x=1716372657;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3x6ZCqu5CT7Ue7AGn6/09f0ZzNfidjWOj6s25lmpMqQ=;
  b=SYVNZqj2qc1N1kcoQEguFVVxf4YyzPw9emLaA8R21t1VB5nKSl73sdEA
   FQRhVbK14nh2ypXELiPKdw9UPyWGO9szDYAIcgHP2zmk8kIpVdJc6XlJT
   U2i/JFutedgwvLBNdhf2v8Ss3cZ0pOMEtJN81jVefy7omgunFh0HMwhGo
   PvnSc2AdBJE/3ZhwJQRQQNgoQSSUTmbuiXgUwJyJ6MfxYAwMg76RIeO0R
   mZmpb9ZR8uaAA9hEa2TNw2KVWuihdPHyyda1bUwv05cb+aP176jvn8CFp
   TIb1ei6ShnGLcFF/5szbq1hr4hViPydXKZITAbc56XOdfiZrqj2dwmw9o
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="342655405"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="342655405"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 03:10:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="816080641"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="816080641"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 23 May 2023 03:10:54 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 03:10:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 03:10:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 23 May 2023 03:10:53 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 23 May 2023 03:10:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYDPagx5s90BgdBj4zOsySFkXIUEUX55yqoETP1mvFjl6hHEtmKRQ3+o54vnLNYuQhwD8IZBfYhBplJ0h130akUFW1FQv9jBy/0VUNLNMYeiV9wU/GyA/F/NE4YlXlcsQ5DYNPUR2OGTC52NCpNtRT/+Ji3G7VK7iQp0A273krcgM3u4hhwSZvnQkWYM3Gr6tcKu2PSqdY0max8XUYeglbAjpdOUIJs+drWgxB3TqxyFAlJ5zBsKlsBTzMDWispY0s5otzroSWrVgt2ki3oc9ky+fZwWNhOt9uUdr3nJUQM6RqBjeJcdIikAckweOlTv1LVbNk2aymlOIuf9e+TsYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E1sGgOAGuUfhn9ycVxJAG82D3UJnDpXXIaslG4PIlpM=;
 b=fS/zR4txVzL1zZpZXGR+7tST2TzvLVQTfiX5rizv+plo3Ki1Sd8hZtBokJ0AnnRSiYvZ7behgmc0ihLFwUkMshgz0tGDpn6edZ6o7F+n9ryq62dJzp/j5gY3WtCNnmsYCHqlRqBX+XT+bZ9azr8ClUbbC7PHY8oqEHZozvNRshAv9ngn+Edr0zlK1mEM5ZPgKSAO1F1CImNufyeF04gRWTbJPCap2AF+VS9NsEXqBU/S7J1qH02FSVNVjOjG34By77nBAfBlIWF37FFxp9zSfgFUGEhGk4oW++mKBtuSFK2zSUMY/Ib5PuncMeBI1wJ7QPyvCi3hmyuUMh4sgJDoGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by BL1PR11MB5287.namprd11.prod.outlook.com (2603:10b6:208:31b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Tue, 23 May
 2023 10:10:46 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0%7]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 10:10:46 +0000
From: "Drewek, Wojciech" <wojciech.drewek@intel.com>
To: Simon Horman <simon.horman@corigine.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Lobakin, Aleksander"
	<aleksander.lobakin@intel.com>, "Ertman, David M" <david.m.ertman@intel.com>,
	"michal.swiatkowski@linux.intel.com" <michal.swiatkowski@linux.intel.com>,
	"marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
	"Chmielewski, Pawel" <pawel.chmielewski@intel.com>, "Samudrala, Sridhar"
	<sridhar.samudrala@intel.com>, Dan Carpenter <dan.carpenter@linaro.org>
Subject: RE: [PATCH iwl-next v3 08/10] ice: implement bridge port vlan
Thread-Topic: [PATCH iwl-next v3 08/10] ice: implement bridge port vlan
Thread-Index: AQHZjKB149SJCHIED0WGNAYuwNEh669npEog
Date: Tue, 23 May 2023 10:10:46 +0000
Message-ID: <MW4PR11MB57762D825AD01B9A8527EE61FD409@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20230522090542.45679-1-wojciech.drewek@intel.com>
 <20230522090542.45679-9-wojciech.drewek@intel.com>
 <ZGtRqTaWtKYbI+f1@corigine.com>
In-Reply-To: <ZGtRqTaWtKYbI+f1@corigine.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|BL1PR11MB5287:EE_
x-ms-office365-filtering-correlation-id: 411ee99a-f37a-4bac-a1f9-08db5b75f9e1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 33jEJFPEriLXQv4+Q9LhUL1TYAb6TuXWRuD3AngEkTtB8+Qrp7znHrCuShsLRvPuCIYBiVpve4OMKyk7HlF6sdd9qVRZrBdYUB9gm2/U4KhziTLRgqOOb7cyK/0XGOkhaNCzqa+4m4ScyvFvjQ8doS1XV9RR3JGIYd57LCmKPVkuqJQb3G8Wbc0IdNdCCb4iyMR/b78/z6C1+Xsv76mRl/lVzMFu0tvMZaS1TCmd/cMKm4RCsvsBlfu3+E0KV0ykvIBkBVNOGQI8xtBbQpjGJoZs3aQlHl1LURpve3810jghmiYnnyBZ+cJvk89iKs5NVYMQI7xn9/hAxOInHLWRJRtGJtWj+MWiNzIYHC++3KXlvqCmZqWu492hLrkxbbVFLPKA7Vzd6Jjs6t43oMgoemzwuCx/k5s0k+QcVEP+4W5KEl6qdysDrAqfGBafIcsaisgEDLVhY69VyBoCWke4WBgaqm1P+MSDXS+EeSKLphOpLvFsA0q+Rz8rvwgVdbVQ2DLDNikD9/kyp78cVllTFX72eYpYDaGbJv5U3CgFeKHDPgSdNSO6nwsrlcRoiHEfqBo/9nFtxlyA4pfB8gKPYGGNNsTpZFvAm7U8sdAsDTyUS1D6Qgo9+4bpTvCQZXgT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(136003)(376002)(396003)(451199021)(186003)(82960400001)(53546011)(122000001)(33656002)(6506007)(26005)(9686003)(38100700002)(66574015)(83380400001)(2906002)(55016003)(54906003)(7696005)(71200400001)(316002)(41300700001)(478600001)(86362001)(6916009)(4326008)(64756008)(66946007)(66556008)(66476007)(66446008)(76116006)(38070700005)(8936002)(8676002)(52536014)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?SablMCwmoHuO26ITUoM09ta21ghlSzDI6EurnPxtPAPwdk+r7/Imh7mDV0?=
 =?iso-8859-2?Q?8W9FATeM20FiIiKMD5Gv+AYpmjEc0xUZDa+YDaf/XhF9SwTEa/AEL9JXAI?=
 =?iso-8859-2?Q?NOURn8147IT1TaYfWhwRQpC00RBM+Ja1yGm+5CJIEbqZDbZ1CRYoDHkPhO?=
 =?iso-8859-2?Q?EtLOvyzuKepIsxAubId3K6z9JWnSLkCjEF5i+3yzsfNhG3lFU0tRTN70t2?=
 =?iso-8859-2?Q?8XqwblaUT1UqksfC6Ed5K7TMaNkNap9jXCqzCjZ7+eV2xZb9BfTk42TLmv?=
 =?iso-8859-2?Q?GWPhbtgi9ReXuh+CZH1NoDDtnfIwvoxknRTOMWhPNyKn+gXxjHBYununID?=
 =?iso-8859-2?Q?HmfnfcPPS9+m0+bmFdkQ/7JtZAIPzq6DnC2GgBKE35WeSNgOZu9EVGZzdb?=
 =?iso-8859-2?Q?vsFpApI4RkYtoHd/ZmnY07IWhzZlWm6OJnhHmrTNYET77zHhacIOTSyciX?=
 =?iso-8859-2?Q?LYZiw+sA3yRWFRSSGY9qxfigcvdmNAEP7CxjQcI9BnDEDnEyKwn0Tw66TV?=
 =?iso-8859-2?Q?XBDFiIC/TWQwZsvnsIZ7NvncWeVZPMSDjfJBYvB7nDp9RIHpEGAI4O7jjx?=
 =?iso-8859-2?Q?AUcRWWyVNzcUkCt31OOdbCfyg83jaN4bUjhQxgdk5kn/8fS2iiBeAX2hsy?=
 =?iso-8859-2?Q?vXkGFwReS7OxVy5K9hl7acH7uaxbjFwc5ssZDxX7wDzzpvNE9EX0Yb/UGs?=
 =?iso-8859-2?Q?zREKgaLUKRC3Uaqe7bXyz2iz+Ph73p+AwE/ozae9h+4l2LDEO4duXdIQEW?=
 =?iso-8859-2?Q?AQNNtcWF/jwZUbTnMF5TIbj/iTzDdbr00VYD+ZQiRvPswsrCCQ8nKCbQAI?=
 =?iso-8859-2?Q?eJA2LwyqQqdP3C99rVpQTrhR50lZOK6/WnlsnRdNqFDXfVzLSXoVNMfNRU?=
 =?iso-8859-2?Q?ksf8gZcx7kIEukW3C3Mco7d8PnpHkqJJgB6O8oyb2In4vDLwCWkVqVKnP1?=
 =?iso-8859-2?Q?86khEaTSEkuPHEUXPx6eHxZCQB7PP3wzfCMMaJXl5wpBwN3ckJ19vAQVIr?=
 =?iso-8859-2?Q?UAemkIMdCXF9fe++HzitlRYUztQZbbdKvLd3KTiKNTH8OjsdZoX6Hdiwxe?=
 =?iso-8859-2?Q?49bewoVRC+xGoHjaSvKrERvkJZDx+973nHLeBm4FnVpVY4HI9SWDAF3nr3?=
 =?iso-8859-2?Q?0if0+4kOEjKe9f7ZKa7ZHIMV8piZ1xRDLTVPGJ0CQ5vmlpchKacKFFOclY?=
 =?iso-8859-2?Q?7OSFT/qPC/KjoLtOrnWmO/hDCJ0ypYs8SgFZTuIzAA4gq173Rdk8Ex73XF?=
 =?iso-8859-2?Q?KkdGw6eFIirI99jxrOmi0K1Fp2YCh1r/Tobe6IaJlDFgZadN30PNTJ1cLF?=
 =?iso-8859-2?Q?5zj6RvvvUwnR8zL8whQVlVwYxU4IT7+c4DGouHXWAaCn5oGuK0vR2PU/O9?=
 =?iso-8859-2?Q?wposnBUqqs3nzX017zVwp21wYc9xmb3KKlWJYv6BCgkJlZtPYP6x6WzgC8?=
 =?iso-8859-2?Q?vbv0rb6LEb1SavW8w4Wngu8ejzZWpIsUFM7vEAUyj6kd4SRSUtCo+ya7y/?=
 =?iso-8859-2?Q?GsLvZqOb/SY8+W7rHgcJ+NALw416ig+/ODOO62wJ4tY4zPMllV9aMO5M/J?=
 =?iso-8859-2?Q?uRr2j3QpyQ65/l9dpCcM5SqbEEPhuyuqb2BfiUdC3H76GvQV/fkQ6krg/t?=
 =?iso-8859-2?Q?PBcC1Q55g+qM0nyNvZqz1TjSPtqMgSJh3I?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 411ee99a-f37a-4bac-a1f9-08db5b75f9e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 10:10:46.4572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: owlvWzWdV3o7MaxYF9L4UOmX9oBvjin9aXk1Cw/wDCAnprx6+sK9isZomEWPrX8Ly7SDE4GbOdhkPMYU/megnpEGddhmf9elAiIlp668N0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5287
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: poniedzia=B3ek, 22 maja 2023 13:28
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; Lobakin, Al=
eksander <aleksander.lobakin@intel.com>; Ertman, David M
> <david.m.ertman@intel.com>; michal.swiatkowski@linux.intel.com; marcin.sz=
ycik@linux.intel.com; Chmielewski, Pawel
> <pawel.chmielewski@intel.com>; Samudrala, Sridhar <sridhar.samudrala@inte=
l.com>; Dan Carpenter <dan.carpenter@linaro.org>
> Subject: Re: [PATCH iwl-next v3 08/10] ice: implement bridge port vlan
>=20
> +Dan Carpenter
>=20
> On Mon, May 22, 2023 at 11:05:40AM +0200, Wojciech Drewek wrote:
> > From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> >
> > Port VLAN in this case means push and pop VLAN action on specific vid.
> > There are a few limitation in hardware:
> > - push and pop can't be used separately
> > - if port VLAN is used there can't be any trunk VLANs, because pop
> >   action is done on all traffic received by VSI in port VLAN mode
> > - port VLAN mode on uplink port isn't supported
> >
> > Reflect these limitations in code using dev_info to inform the user
> > about unsupported configuration.
> >
> > In bridge mode there is a need to configure port vlan without resetting
> > VFs. To do that implement ice_port_vlan_on/off() functions. They are
> > only configuring correct vlan_ops to allow setting port vlan.
> >
> > We also need to clear port vlan without resetting the VF which is not
> > supported right now. Change it by implementing clear_port_vlan ops.
> > As previous VLAN configuration isn't always the same, store current
> > config while creating port vlan and restore it in clear function.
> >
> > Configuration steps:
> > - configure switchdev with bridge
> > - #bridge vlan add dev eth0 vid 120 pvid untagged
> > - #bridge vlan add dev eth1 vid 120 pvid untagged
> > - ping from VF0 to VF1
> >
> > Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
>=20
> ...
>=20
> > @@ -639,14 +698,29 @@ ice_eswitch_br_vlan_create(u16 vid, u16 flags, st=
ruct ice_esw_br_port *port)
> >
> >  	vlan->vid =3D vid;
> >  	vlan->flags =3D flags;
> > +	if ((flags & BRIDGE_VLAN_INFO_PVID) &&
> > +	    (flags & BRIDGE_VLAN_INFO_UNTAGGED)) {
> > +		err =3D ice_eswitch_br_set_pvid(port, vlan);
> > +		if (err)
> > +			goto err_set_pvid;
> > +	} else if ((flags & BRIDGE_VLAN_INFO_PVID) ||
> > +		   (flags & BRIDGE_VLAN_INFO_UNTAGGED)) {
> > +		dev_info(dev, "VLAN push and pop are supported only simultaneously\n=
");
> > +		return ERR_PTR(-EOPNOTSUPP);
>=20
> Hi Wojciech,
>=20
> Smatch thinks that vlan is being leaked here.
> So perhaps:
>=20
> 		err =3D -EOPNOTSUPP;
> 		goto err_set_pvid;
>=20
> .../ice_eswitch_br.c:709 ice_eswitch_br_vlan_create() warn: possible memo=
ry leak of 'vlan'

Thanks,
I'll fix that

>=20
>=20
> > +	}
> >
> >  	err =3D xa_insert(&port->vlans, vlan->vid, vlan, GFP_KERNEL);
> > -	if (err) {
> > -		kfree(vlan);
> > -		return ERR_PTR(err);
> > -	}
> > +	if (err)
> > +		goto err_insert;
> >
> >  	return vlan;
> > +
> > +err_insert:
> > +	if (port->pvid)
> > +		ice_eswitch_br_clear_pvid(port);
> > +err_set_pvid:
> > +	kfree(vlan);
> > +	return ERR_PTR(err);
> >  }
> >
> >  static int
>=20
> ...

