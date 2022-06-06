Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A0E53E7DF
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbiFFLnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 07:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235459AbiFFLnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 07:43:45 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB951842E1;
        Mon,  6 Jun 2022 04:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654515824; x=1686051824;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=41MSC5OoU6EZFcLFN6Knf1MfS2QzAw/hk8FR5x8wJhc=;
  b=UlSUWPrOo71q5V+8Rk9VZhm7uN3efSDGvNk1E1ug1jyF+MwrvCbXXnTw
   z3YOpuYOOHxfBpMVfX0EqW8a7FNO/hdCTOd7QBW5pd8vMzA3KRTqm3Daq
   MM808kHaJ0t6mlH6jKGfckgOI3q+Z1wzbSUaXIDRgQdTHRMMvznhC2T2Z
   VS88pE9bE3HdqMOOZ/LFQH8RZjO6AbDGqJOdpk/+K9FqzBSG2ZFd1OPZ+
   hsr/bzG2SHjiQXe9HC4EaTnVF4RXvsOL6TcupcMBc4EN9zeBw4nKh1zen
   4AEdOJWM0+Wwf8Jxp6S8aAKg7JJD/+6g+N2+LAavDqHK6Z986TR/4Wbeq
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="302009479"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="302009479"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 04:43:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="583592916"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jun 2022 04:43:43 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 6 Jun 2022 04:43:43 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 6 Jun 2022 04:43:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 6 Jun 2022 04:43:42 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 6 Jun 2022 04:43:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbQ56bBSw8eJidwgatWJRTJWVNI9m5hqnmDMtcXVBuAb0EppeSonu7U97D/RQuYJqnP9u2QtcJ90YsEWNR0LxDmGJRzQZXKJtq5m7vvVaxGc4QtnPcNWO7LNUprHSqmLlqsKLV3uUC3FMdBbdKZ/Um6V2PCZLEkGL2BG8RFDyvTHBtrs49cHVT3FLJ2j3SMdU69DVSFPqHqi0eno1r3mKzZ3+c1w29Diip2lXNZ5/JzIhFJwISDCaJ/gCoJsiPv3gVMxXW3G6sZGxtN6QyZ/u3AKpErhXubh86XdE/z+eomrsZW4py0i887kGdqA6xeLHkGv623cgbYS99n0uh3v+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O1o3j2ss8XT7SrkPgT+YcA7vXn1FgV+DmdjtrfCA32Y=;
 b=d7PetpsBPqK9X5wrZcUmDzEQ4nNIi1oH6XfbR/nrKnLZNp308quntLgjwjFgBahc7tTzBCLLmd0vU9iIdXeJmQUfQJXdlUrxxdzJEggv5THnCT7VNDWoND959kwzSvZjKwyWVq4nVaDsFJOaaNy0wM5noZRNi6TRELq7aBwvX8r2QzQn1I8S0csaCgGHvsKfZ2OoICaFlJTzR35MQF+Jr1hy5O5xxzRbKPIDCcN5PsLlyNxcNUTK/1W4VraAMk8cUNbtLN8X3qYt49fuzi84xrmUqdPq5Si9Um197Yc0nlIgXjmxnSfoyt31YMCrq3XXTRkTSLOa/QFnTWGyySDOAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 BN9PR11MB5482.namprd11.prod.outlook.com (2603:10b6:408:103::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Mon, 6 Jun
 2022 11:43:39 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::5110:69c8:5d4f:e769]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::5110:69c8:5d4f:e769%3]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 11:43:39 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     "Matz, Olivier" <olivier.matz@6wind.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Paul Menzel <pmenzel@molgen.mpg.de>,
        "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net v2 1/2] ixgbe: fix bcast packets Rx
 on VF after promisc removal
Thread-Topic: [Intel-wired-lan] [PATCH net v2 1/2] ixgbe: fix bcast packets Rx
 on VF after promisc removal
Thread-Index: AQHYSZwu87yQHcrYMUy1TfblmYCLsq1Cof1Q
Date:   Mon, 6 Jun 2022 11:43:39 +0000
Message-ID: <DM8PR11MB56210FDC7185A92E44450C0AABA29@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20220406095252.22338-1-olivier.matz@6wind.com>
 <20220406095252.22338-2-olivier.matz@6wind.com>
In-Reply-To: <20220406095252.22338-2-olivier.matz@6wind.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84539d53-cf6b-419d-9fa7-08da47b1cce6
x-ms-traffictypediagnostic: BN9PR11MB5482:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN9PR11MB5482731F3AFB1ECCF7C626EEABA29@BN9PR11MB5482.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4iN9H8gdkWRVetFuLXUpnlarOIU5pnprYkVYVSqduwR/efiNuVDUI9jXCKtlE24CRwUYLz67v9osPgWaEfefFO7IMoHMZdwlulNCbqm2m+2CCDhxWEx3GsuNvfsMHW2czO/G3r0mkOK8u65mSIMn0igq/nx6rLPyiYauWd45z28DI7fSoSN9tjtCQRV8Dwet4YjNq63rbAPmGD6sot6XEUbs9+U4RxSM6YXVcXgRldSN+zxBUpQK9xb5sB+Fv3JK3MYr/D6igb/tFdtVgOj1b1jI+7/fzCkLbKiOgquAptgvjzb/3Srd1Y2EHsff9hRy+VdRnUFNsMByDtgPkuXCOfE5RMJfVZzkUdd8x2e02JiYxhg//HDL513Elky9sla1Q/900g9XgbzRWEHNUdc4fOiNjGwMuCq4yqFkES5ZjZHp5f9+5X0WMz0XYuA5JSjN2t3z512fFEir+deHZQtNIOe+pirvJYxxOY4OiHSFFu2kinofB1mMVgvH46qd6DXlEixDQXu4IRKCNUNIFxxCw4Kyy2zZLqwllrSjXm+XhR6zhOUN3UPT4qDMh1r/usvR3IXVSNRSYNfTzDUwJ0IAtA7YTim6OgQCS1geJrtw3ELBrB07KzV4fqPoL67Jj/hPbxx49eiwW6nWXJNPkRk+MNuqq6gWff5wCQLALzjSnpU+UBM6LRYRgrNCTjCddQLJYy4bCLFUdDTwWKUlek9jVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(64756008)(66446008)(8936002)(55016003)(52536014)(2906002)(8676002)(66556008)(186003)(82960400001)(26005)(316002)(38070700005)(122000001)(110136005)(83380400001)(54906003)(9686003)(66476007)(66946007)(33656002)(71200400001)(38100700002)(6506007)(53546011)(7696005)(76116006)(4326008)(86362001)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l54GIQb8269QnBCbk3hVxhlvzRHkPvnruiA+Eg/jSZLDkoZ9rMLi8nhBmAyp?=
 =?us-ascii?Q?DOwziLA3evYr3Vr4pk2v7eXEwt54oPdiU/kndOOh0buxEzYLujYs2xRmMKhK?=
 =?us-ascii?Q?PBDkstupsokibBX3CXd2y9Lu1c0O8KKRocq9RgwyWnpBEay/XUReJscFQMKD?=
 =?us-ascii?Q?+15axAirH4SK13EE4ycFgo5y3kYMW8vpCVLoqqcoF93v5JBYWRt+odGcyhxF?=
 =?us-ascii?Q?8DSw0Lz8QysyV/QTkj9z5KYnZfcrlBJiVDUtw1qDNL5Ju18lpx5EihXBghPS?=
 =?us-ascii?Q?CDoN9dT4DRo1I9oUwj4/wDRppvvcp5EHQGbUAmsdg2DUqplQq7iPrlSmUDqu?=
 =?us-ascii?Q?eQ0qmsc4Dc6guwOxjLPovOamXSqVidaXtr34THwcNBxRm/NJtucAI5mJUbUG?=
 =?us-ascii?Q?YBxB4/xbmAJXeTQ54NguAV4bF8GOsrnE49lkuz5kva0+de5o8CDadbuYqfsC?=
 =?us-ascii?Q?xq0Fp8tUt2/II0VSbbFjimxX2kMV9pOrDG3A5Kj2ajT8NFmN4b0X/h0bM6yi?=
 =?us-ascii?Q?Nq3ItdvG/PRtc8Ab7dR+AlqV7cc/w9cgSQumgxgCof4GwjyIKcpJOoqAZZ6c?=
 =?us-ascii?Q?Oh5NJzgTKrmmIpguego71I3PIO/naeDFAclef945/VHf/wCUx3D3dKarXuap?=
 =?us-ascii?Q?Q/fLVy5uQqgQLTdO+jIsNyKQI/GLyMn5TSQZltFYjGu2y6v+rWFvBAlkIjzi?=
 =?us-ascii?Q?h/2WdgQA9OXew3ThDtGysQOFMF35Ztnr/MwEo61BE0avKFE4ZOQhKfTLcuEh?=
 =?us-ascii?Q?+RUvx4BCldY+YTnK0WkW4lsaQrlV+kyw1Q8ElfZnBy1hEiKfUBV8SRhVo1Sx?=
 =?us-ascii?Q?9M1DD0lIUqomFpb/suRL5Q5CIPN3VIcS0Vf45FNEcnKEQJxLP4kEhUtlpGKA?=
 =?us-ascii?Q?crUBvMKtXZTQn2DtWbKrWnoYp1FFAnzZe0Zh54JSi4ltnlnuoLh0uyHeAz3f?=
 =?us-ascii?Q?CCMlkCBdfefh/nvENww8k8i64KaGUrBFo8pbdnLGnNOKPkeJKvO/QcpB5L4g?=
 =?us-ascii?Q?09L6+eK2epye0/XOEYjq7oMaliTCJSpv5yPqteCKIk4RNxjci+i+zXTse13B?=
 =?us-ascii?Q?27B8WnXQeeKSgGRCyEMkzXu+qk0j1BfT2xv/lOaXVjHRDPIttUa8yk28EeFI?=
 =?us-ascii?Q?MonY33Xx5KTa0hJgeZQ4xtWVH8FagDSXN+xG5nkMMOIk3qmnV7GyjAk4L+7h?=
 =?us-ascii?Q?qfrK1PNax/vULvDPV7Z8dAby9aV1z6vuhaao2ZMhVjeVJf25LHzDgAiw9LcL?=
 =?us-ascii?Q?1i5bHGSUo9YrWFr/5ynWFXxas5dJXEIVozdveaMtqIRx9NIJOgLH+r08fnxT?=
 =?us-ascii?Q?SpakoU5/VCiRM1abw2HxhSQQO7m9DgJsoFyoqivqgbnuuDoX4vqumBlJ1dzI?=
 =?us-ascii?Q?QkkLh74uITzXsDcEmVGXJH8FkpIzLQBX9aB0DZmYrAOdraA+vk4sKkC21Wjt?=
 =?us-ascii?Q?Baq5f4HlJKneMrO210U4dl3nmEOiT4axjHoa555Wtr6KmAzAzPeAfTsVo8x3?=
 =?us-ascii?Q?8OGVJodZCQLaV/aByLPcV2N0/QdJf9kCBjBY1SuuSEZm0WdxhGyo8SQouAgY?=
 =?us-ascii?Q?dbGmNl75r/7Ouuh2DIsW4dSVgqgbiZtA6b6TKaCvBSH2Sfa2RgvuXJFNEjJv?=
 =?us-ascii?Q?jW7Ibe9UDwvMrJxJ8LHL+w7w3HoXYd8ZydF5bZCuPuOFwvhD+D4yqColtiEW?=
 =?us-ascii?Q?KMY9/xCZPRXiUgUJdpHygzvHkqx3uqfCFk/4GxBLr4FD2b2AOyN58437maNV?=
 =?us-ascii?Q?erNHvk/2cuLNdVgyYFes+ajj1S/Mang=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84539d53-cf6b-419d-9fa7-08da47b1cce6
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2022 11:43:39.8327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 35uy8EumXhB/EU65XFE5rDZDuo1RMg8JeNd+LPPDvJ+ArMG975u2JDEcboHGKOTtetZTHp4DxRh+mrprhLxGq4YUEQmzknHYxQChrvxCkzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5482
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Olivier Matz
> Sent: Wednesday, April 6, 2022 11:53 AM
> To: netdev@vger.kernel.org
> Cc: Paul Menzel <pmenzel@molgen.mpg.de>; intel-wired-lan@osuosl.org;
> stable@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>; Nicolas Dichtel
> <nicolas.dichtel@6wind.com>; Paolo Abeni <pabeni@redhat.com>; David S .
> Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH net v2 1/2] ixgbe: fix bcast packets Rx=
 on VF
> after promisc removal
>=20
> After a VF requested to remove the promiscuous flag on an interface, the
> broadcast packets are not received anymore. This breaks some protocols li=
ke
> ARP.
>=20
> In ixgbe_update_vf_xcast_mode(), we should keep the IXGBE_VMOLR_BAM
> bit (Broadcast Accept) on promiscuous removal.
>=20
> This flag is already set by default in ixgbe_set_vmolr() on VF reset.
>=20
> Fixes: 8443c1a4b192 ("ixgbe, ixgbevf: Add new mbox API xcast mode")
> Cc: stable@vger.kernel.org
> Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Signed-off-by: Olivier Matz <olivier.matz@6wind.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
> b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
> index 7f11c0a8e7a9..8d108a78941b 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
> @@ -1184,9 +1184,9 @@ static int ixgbe_update_vf_xcast_mode(struct

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
