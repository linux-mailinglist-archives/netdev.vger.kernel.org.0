Return-Path: <netdev+bounces-1239-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40AB16FCD30
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 20:04:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CF131C20C2D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 18:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2EBD182DA;
	Tue,  9 May 2023 18:04:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13A7F9C5
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 18:04:52 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A370540F6;
	Tue,  9 May 2023 11:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683655491; x=1715191491;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TR5WHHRCzGdsPh8bo8hMlJBkOQ0jfHateJxOqUeVeTM=;
  b=EhBeXjKiXQTQyRuWUbYzBrHyvK1KWUrVdrGY9CecIuRyS0wmAzQFPn44
   dxVHvLOq/aWReP5mMiu6D6qXZPhBNSxNIb3LrwbMEx74c30U+mwGnyYrl
   Wl4Q1s3nnYVxUAxBbT/aNpKE6e/21FXIhGucQipqRIkK/dvCH1ciPoATM
   5/J96Qx8PBVhocnVmtaS72BdFCYjLooTHbotzb7u+a7VOVs/mKPbDszri
   /eM0ZOc1Wr8sSgMd4TY9E0+b4b0jSW03R9nGUffZdrDuk46vXNLpw0lDf
   nqVAoiP5SLh/gjJX30D6mm04SmVdGnYvsWxTAurCJ0yJipRQxSE6+uf9X
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="413291878"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="413291878"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 11:04:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="788621981"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="788621981"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 09 May 2023 11:04:50 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 11:04:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 11:04:50 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 11:04:50 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 11:04:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hOoczdlbi+fiXY2m8zHu2n/5bS4IXnDBsqaDve8RNi5iJfoGJqgyWwCkuQ33MGjnF7gbECvENZbchszMN2YPM/ehfgaoUVAARjbsa8AweCRkWbu0dlHHd06HynTedz70MjYMZmDEMkDy5iONrMibEiM0N1bzXUFBl2hXP9M5tWKlVKtplyjo0DrlqUB4cdIYZXC62+jcJxU3vDyBDd6U0rP1OI6Zutl9cKw0wDyKatZpA0TRhahj1ZBmW0a8l81cl2D3GFgfp7VFv7U9xu9c7gnwlnIL5BJEUtoSgmVAKvKYOb3tIsvkLZUxaQ0uURtP8M8TpPc0rk5IDp3F52r3sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gyg86muHa2TpWRB8A1m4+oO+TEsGVv4U1AqJwvPJCKk=;
 b=BwQLGlGSpcCbN1d7CJ7FOitmb7S1qpxlZ+atYqY/MJY++CHYxpEp7NEqtyH7vjADbp0v1J2+qQUuxB6b36gR5J3edtxQ/GR+nD7rzrbXcPVYZJZOP9L7SqUdrpDGzBJHCh2MUegzoQf5CfdftK08oOnrG4RWDjOx9EI/wTzlD+qelohEwW4u9qlOADOEGHuBQtN+yXpcIITyi9QRv3DlWujZy8ihxnFzpaTX9CFh18snxPfTzbWtXYbPfPnnDbzJ4OInBzHtXGHWhPYpAjbAos8xkyDonHpAXQKuN2FEAOyIuam8RPnnTUs9YBgM6CQu+zbJb3YOfYbbPNTfzQWwQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4107.namprd11.prod.outlook.com (2603:10b6:5:198::24)
 by PH0PR11MB5925.namprd11.prod.outlook.com (2603:10b6:510:143::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 18:04:48 +0000
Received: from DM6PR11MB4107.namprd11.prod.outlook.com
 ([fe80::29e3:b4cc:730a:eb25]) by DM6PR11MB4107.namprd11.prod.outlook.com
 ([fe80::29e3:b4cc:730a:eb25%6]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 18:04:48 +0000
From: "Chen, Tim C" <tim.c.chen@intel.com>
To: Shakeel Butt <shakeelb@google.com>, "Zhang, Cathy" <cathy.zhang@intel.com>
CC: "edumazet@google.com" <edumazet@google.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "Brandeburg, Jesse"
	<jesse.brandeburg@intel.com>, "Srinivas, Suresh" <suresh.srinivas@intel.com>,
	"You, Lizhen" <lizhen.you@intel.com>, "eric.dumazet@gmail.com"
	<eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org"
	<cgroups@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHt/BAgKLPso0OJcVd7a0C9UK9SMhgAgAAKP4A=
Date: Tue, 9 May 2023 18:04:47 +0000
Message-ID: <DM6PR11MB41078CDC3B97ED88AF71DEBFDC769@DM6PR11MB4107.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <20230509171910.yka3hucbwfnnq5fq@google.com>
In-Reply-To: <20230509171910.yka3hucbwfnnq5fq@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4107:EE_|PH0PR11MB5925:EE_
x-ms-office365-filtering-correlation-id: d8aa4583-520a-41a6-d26b-08db50b7e097
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mcqQ0bcRrsMj9tDfdeaKLbvmjb4iyM/hE06T0W1pqbR7dC67BLkZVUhS7HP9DODuKj/gbYn2+6VapAEQFlcgB3Nz79YJ5RGLMiX6vFSyGA2n552BFI3S9JjnK4m88NvWkflYGDjGjkNRMA3sytmTaHfNZFX9DxT6qqNBjJ4uhHv8y//rpBXxklmo8zOGWS06TlPy50WRu2AuxhZiVnlvDMi/Rm/PRuXku58vxuyprehbu6cv2qrDpaaqWiTYgNyEkH+dXXKnZB7PTr8jgO8KSOT3HxZTan12cGxWEO740xTUNlCZpKKNz+qgihgui1tkRxt6zOv2dvPQ5j0gio2fMRKc6gjSKciboT2hzISStYTwpGYeuBCiyF5anm7nwsTP9HvaxknI3084I1kZnKsv6v/4Ur+TNKDsfM9f+GcKM9d4rEYhU3ZIrg+xx3Dsf1o7a3rNz2tqlbMTxa1WKeLiKIiUGzMwp29V2v0cNzvfxR9TBxTen7Ik5vLIZPuq1X4tu0RnMW1nc36Dvqt9DKg00M0sGmAged3g/f4EkNAMu7mZQKZZ1R4snT4B+IEdFz23Qdhx2k3URJf8kTWPkKUm3ez4NBhNNN9iwa2yFRnnE1RD7ENvcSHnCU8GRab3772g
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(346002)(39860400002)(366004)(396003)(451199021)(54906003)(5660300002)(52536014)(110136005)(8936002)(7696005)(41300700001)(316002)(8676002)(71200400001)(26005)(66476007)(64756008)(478600001)(66556008)(6636002)(9686003)(76116006)(66946007)(66446008)(6506007)(4326008)(2906002)(4744005)(83380400001)(186003)(122000001)(82960400001)(55016003)(86362001)(33656002)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QWbh/a4SFEoZVq4bthNVREa4BD95aD38sMUyVRhzbMGfZ/OvfPsO4klDou8Z?=
 =?us-ascii?Q?q/Ppx/I1oBcZaORVbSeAIpOroVErob5ICTqpgbebtXj6uCFOxTBqy74D711i?=
 =?us-ascii?Q?8oYnG82vr25clUT7KX907fAz+wSzFeS2TkOGfQvCG+y8ED1gV0BapP+mhRA1?=
 =?us-ascii?Q?sTIRlC/umUc9ErRkv9XbX027Ly7SeWymPLiS0gzUUst3vM5clt4rrjaXRL1K?=
 =?us-ascii?Q?5A2dD7lXSjBn4fWgtJinrjGEJcZYeJg2n8OFWFXT1Fi/yVyoFROlH75jaGSe?=
 =?us-ascii?Q?Ldyqx9UTaJxvridX74wp3s6VTWAwNM6BLL5k0z6+ZpMJVEh1U/NUGBmt5WXL?=
 =?us-ascii?Q?ybwWWXllue1l4cBwlLiF+pwYBZj+VWJdeFcxNY8nWvU5ZcYlkI+tfVMEO0sy?=
 =?us-ascii?Q?+cSO72yu2gzavwgEaff4lKbx32ghYcuzStWASynE/BHG3u8EKSFbedg1elc6?=
 =?us-ascii?Q?pJgEbkUKJZMLy9WVUJx1GWRQ3w7+9farO7yD+OFGvN9coyufekDLUq/iALJB?=
 =?us-ascii?Q?m4KzpDe1yo2TqAmWX1DXTnUtQgUkrN3cQC1sSH/p7tjosWSW6QAadIfoHyAO?=
 =?us-ascii?Q?enyg6j1OkxYYabcCGZS7pVY50fPRgc34Sc8ue8dKyGR25BKYj9ltoev6x75l?=
 =?us-ascii?Q?sz8anU/qjsTFSWsrMxwTjIck+XF7AUijAgIFA5z7jY7ftAIPWCPKxGX2940t?=
 =?us-ascii?Q?ATrqYjsSc86AnyqqY2RKKMzQRILjWLyTBBOAc61KjnS8wp66OiFNtfwhjoJS?=
 =?us-ascii?Q?75ff6VGm05KlujmY4d4qqkxRKHuu6N87HYbdbIFQUVyn8L7RWyUdgn3jWvCB?=
 =?us-ascii?Q?GZNJymcueYnSgSkF+h291PvEJgzX782Boe60ZnPoKEM0oNVAfDcGlkl6IGha?=
 =?us-ascii?Q?eprpdBFH/7BXUkcfswNaeun6ZIop/6iQ1d1K9r08F79z3+XzgIQ5Pgknw9pJ?=
 =?us-ascii?Q?JZO4Ewugx5Vb4/C0WPAKxSbDyfPZJ+lc95BABxl0yE072XXNBFaW2Hoiv2Jk?=
 =?us-ascii?Q?z6P2sQum9sXWDjbFk0n7sha9sXwRXMqkzwLnf5oHUOsrvTzlFvn125JFWBya?=
 =?us-ascii?Q?oi0sl8Nv5BKSlnrQJFd5mu8MqnlJ+gZFAUVTeDCS+nJAN+qki0IIQjjFA6JX?=
 =?us-ascii?Q?lk9fJYmgWkC2eJRj0/UNKn9mnQSDOqwAWBGWJhuoX9qR6L3cK+iFvmkTtn18?=
 =?us-ascii?Q?toou/MpRTJwmBRqz5uCusidCS0T7L7+DtMQzSkl5UI3x1QfhMqLxbx39E8nF?=
 =?us-ascii?Q?WRFGFnQ3u6BzwrLvbsCF26WNhnokwfsN1GqsND4vg/1sOcN0lv1Ra0SJqOzJ?=
 =?us-ascii?Q?yF9SIpkh4P9NhqRhG7sF9IhcSTtNmgKs5xa9+3g5Hwr/bG6eerK4sLwH4XGb?=
 =?us-ascii?Q?Ctioy1S7N1SHBhRyaYVm58gFAN9zbL5pWpe+7p0abdc5K5ZMpeU0iXTybAUy?=
 =?us-ascii?Q?s+dd6qSY+wxaysN4RheDvtbeM1Iap1mcIIV/0vNrKphj8t38mtdXddpE6Ob+?=
 =?us-ascii?Q?zGY2BOarMPLjHRnDvWN3kG7ioY4TPfKl7BSdN7JzMlBUxsz1scoCJCr+jkZB?=
 =?us-ascii?Q?DwTEdIZNOHrpckb9Zi/JMUx/sR2xI+ZW4tOQgDcY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8aa4583-520a-41a6-d26b-08db50b7e097
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 18:04:48.0196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ze16YKwIwoIO7/hrsdELNVPApRY1hdq1CkCHRs9Kh4S5guRHLgDg7oiBobs5YVYeVE9eV+OFA1e0AS8OhXfffA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5925
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>>=20
>> Run memcached with memtier_benchamrk to verify the optimization fix. 8=20
>> server-client pairs are created with bridge network on localhost,=20
>> server and client of the same pair share 28 logical CPUs.
>>=20
> >Results (Average for 5 run)
> >RPS (with/without patch)	+2.07x
> >

>Do you have regression data from any production workload? Please keep in m=
ind that many times we (MM subsystem) accepts the regressions of microbench=
marks over complicated optimizations. So, if there is a real production reg=
ression, please be very explicit about it.

Though memcached is actually used by people in production. So this isn't an=
 unrealistic scenario.

Tim

