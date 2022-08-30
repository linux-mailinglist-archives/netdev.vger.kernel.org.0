Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0005A7164
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 01:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbiH3XJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 19:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiH3XJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 19:09:45 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18F7A0246
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 16:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661900983; x=1693436983;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9vBG0y3SOmSrfQidWy5/+FDRZ5rrM6g4x7hNCnHJrSQ=;
  b=BHW4IXj+CfUKvjpwQA81lk36U2M7Bna2oYxQ6SnFejrIf19vPKSUrp2d
   0uUICvAJU5RLzUoQSnA15zm3r7ikyu7wuTZUZyT5mfY5N+BA93GQ91s5e
   ZpGhl+5f8aUBgxmj28AAQvwgMvDyJ2QzW+DNIqWy6GdzKMyNLtWL0IYXM
   esxEPEaoCqERUfF+7TQxyfnklNBjX9WOksFfUuoCHyQu6Q1uLhDX1M1UO
   yoBKQUkp+AhTwyjNkbF9CVHtEMadHOALV/o+GgF2oXhKsFkIwd2lcQ/Xy
   /9biPYgB4P67fap37O6AWmY8UdjSix7Rkr4i0C17Rdsdp0jngJoHsTNWo
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="321462669"
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="321462669"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 16:09:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="680227155"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 30 Aug 2022 16:09:43 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 16:09:43 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 30 Aug 2022 16:09:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 30 Aug 2022 16:09:42 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 30 Aug 2022 16:09:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+QaojViJCmzr+CPuq/Y4pPU0anmkpmMS+PWBhz43PeFo2WOZKTm7OdQupzurwiowfppmNIPiYa5SAqvqA+7o8imjpCRIKjfLYjjd8qCKpqig0PsUCQmYulCHGtRjM6m/Pgk53X24BuplPuPl5HlpC10F9d+JuPm1VSdXsbS9GPAgyIzy8X32g6CAAURhVMMBzf61sOOKdl01aVjAeb5DMyNUZFPMnJyNxnyJ0k++dyfzu+pEkL1D/eUJ2Ust+NbRNwrCWId/KD0wEZPNNEFJIALUoUv64/ndJ/JSVY1uQG5NfpsSCLKxdSf3tZ3WjRMzMd+kJEHDLiKSEjsb5vFXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9vBG0y3SOmSrfQidWy5/+FDRZ5rrM6g4x7hNCnHJrSQ=;
 b=Q8VrNtO7B3m4bI/x1BDKuJIrUbsZI1YVZLwnC7P3XhRWXa2ghdQVkybBtn/95OpFpiBQphD1JOZ0n7WHxC90z1h6w0JYEkMrhEgMj6+w5suOrv4L/G6IkWQdDeNNNUqvj5RCoHPGG1HunUiP+/HNCrtzz0U81XTIOPQ46IOlAZ/aNKXke9ddmzVoA33HL0pBBtcBZkfHNConFJWRZdtTPj8b02k17W0NyRhFq5wsWn1GlWNpreOgS2nTYTH0CuuBTLkLCkr5m0UmsRerZmPxB5dPBmH3BJpZXytwcqIG2isDXi0tQ/7VW/FM4nz3EnQpDR8M+1OBCj1pH/CUo7BMOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by MN2PR11MB4616.namprd11.prod.outlook.com (2603:10b6:208:26f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Tue, 30 Aug
 2022 23:09:41 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::b4ce:dcac:20c5:66c8]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::b4ce:dcac:20c5:66c8%8]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 23:09:41 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Gal Pressman <gal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: RE: [PATCH net-next 0/2] ice: support FEC automatic disable
Thread-Topic: [PATCH net-next 0/2] ice: support FEC automatic disable
Thread-Index: AQHYtwG+vEC+zxF9EUaLIV60VfCCNK2+DsqAgABCJ9CAAOPjgIAAnPyAgAAHflCAAAlpgIAAAyXwgAAwQYCAAEQfAIAABmWAgAEaQoCAAGY2gIACRriAgAFU34CAAEhLgP///PSAgAIo1ACAABqwgIAAFrbg
Date:   Tue, 30 Aug 2022 23:09:40 +0000
Message-ID: <SA2PR11MB510008FED4388CBACDFE80C4D6799@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
        <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
        <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
        <20220825092957.26171986@kernel.org>
        <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
        <20220825103027.53fed750@kernel.org>
        <CO1PR11MB50891983ACE664FB101F2BAAD6729@CO1PR11MB5089.namprd11.prod.outlook.com>
        <20220825133425.7bfb34e9@kernel.org>
        <bcdfe60a-0eb7-b1cf-15c8-5be7740716a1@intel.com>
        <20220825180107.38915c09@kernel.org>
        <9d962e38-1aa9-d0ed-261e-eb77c82b186b@intel.com>
        <20220826165711.015e7827@kernel.org>
        <b1c03626-1df1-e4e5-815e-f35c6346cbed@nvidia.com>
        <SA2PR11MB51005070A0E456D7DD169A1FD6769@SA2PR11MB5100.namprd11.prod.outlook.com>
        <b20f0964-42b7-53af-fe24-540d6cd011de@nvidia.com>
        <3f72e038-016d-8b1c-a215-243199bac033@intel.com>
        <26384052-86fa-dc29-51d8-f154a0a71561@intel.com>
 <20220830144451.64fb8ea8@kernel.org>
In-Reply-To: <20220830144451.64fb8ea8@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74f7dcfd-3fcc-40d7-d859-08da8adcb7f7
x-ms-traffictypediagnostic: MN2PR11MB4616:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fltcETIoNgwby3cTe3Nh/7XumyGaLR+CKWlMadGyy1ZChCcV3rdCEwxd9KrLg6TCa+23gkCLmwLDj1QEIS7J7nqF7BarhKtWKjey7HYtrg2w5frHHY297TCictkfKwh2osXh8GgbjQfcXAoPsLSjNREAw5VwgZ+4CLKLWpxZFV4VM/tbaXvf3ZVg6/fUKWg0nB/SyHJoojScJLwhBjTGmT1begZRHpXvq7gKuRDEL4dcbSnWYdrtAAkDmYATBaKoROXKMLJKbQ3EBwYwtCCoJnI+srduU82B/d5xSSpOLAtILB+0lkN16VAnJRmtaifsdxH7viC54sROwdPoCDQxsbQPU098yhOFOw2kZZrbYQ1mFrR3m4s66wNCnevpB4bfDZiU5v5atBBFaFljZugiLwtsMd36tpWqfXVaeTKEYYrYcLzBIxvnt83yHkglqHVTfjZmWEGh8CC8uEvAZJjFGcy3iWuBemUSzlQzy09SuN+3zmbGQebiFNf3Ka+aVnDFx66IhE4lvlLE/Ag78v4mzBcwltbQjJNrt+M8ju9ZMB8jRKmiUKoimKTdMFSiHmjA2UX9tvsdVS59JC/kwKRuxd5/NChZ5Vhon81ydctCFmVQ8Ph8OVVMbyBqqCQSZqYXMbynHfqSlgZVYOSqxz2IaaPZxjy870RA4tpj8q1jqnEoSUcKXJc1RlSUjy36oPvifkqye9q+lUib5y0LYVIGgSInp2odjBE34tvhMgBjPFJChMc9EuV4oGbZtzLnakqhO8tmZrIdGb8FYFSAtK+TqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(346002)(376002)(396003)(366004)(122000001)(2906002)(6506007)(7696005)(38100700002)(55016003)(26005)(83380400001)(9686003)(33656002)(53546011)(71200400001)(86362001)(66946007)(8676002)(66446008)(76116006)(64756008)(4326008)(66476007)(66556008)(186003)(54906003)(6916009)(316002)(41300700001)(52536014)(82960400001)(38070700005)(8936002)(478600001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/Kn0mq82rMfb4WLuJzmLlgKeOXNM7gcH24yzbymh8bHHcnn4Dt69o9EiCfaM?=
 =?us-ascii?Q?P6VDZHu//pKTjV/5U7SPxBB3X7H9SttfgEPr7V8OCA9+OtM55xkRthJyGlk2?=
 =?us-ascii?Q?euss1SGex/5BIC8jme4vZpcRKyV6h4MpdnvAb0sGQT5KfCQITHYdtMS26nRI?=
 =?us-ascii?Q?5GN4evC06QCLw7FFSMUplAvq68P2rKpABD4Ioyokt37gVzzAzq5YmddeOmHh?=
 =?us-ascii?Q?KO2ml9DE1Jfi/LLW+5jng4XQGSSynhtLhsbo6ivvjEU47I8ew1BVQRyL2DPt?=
 =?us-ascii?Q?GH5jtw5D1AL6sKgNvw8m9Fm6Kg7Xd48IBBSfgJKJwmTvWF6XA6FPzIEtN13N?=
 =?us-ascii?Q?i28ZNIQnvZIhLbm12Amak2pKIwBlvZCs5cUrYNd1Ft20xn1x+jCqYt/MPFSF?=
 =?us-ascii?Q?9OGwkJCok7kHAu0fYGyhxweILmywHIy/RRWme+JQeVh/BC7Givtjk7X8sQsM?=
 =?us-ascii?Q?xI8jUUT6NcvRsOISgsa/KY9GnWjj6F2RSDcWJ96QI4IajNUuvt5NqrSnEV5+?=
 =?us-ascii?Q?BxVrpGZ0JqoR5cLXWKcsurC+thVIj8g0YqhIhAgY0Gs28iEATVcCrPzjUWmf?=
 =?us-ascii?Q?NK0HGjlNSVN7eqWLuz3/XgFkNo5cJw3S+2xjkJ/5RklDwRraERHCyOjUm3YZ?=
 =?us-ascii?Q?Vc1JMz4yUUsttdvP1Ded5ldNiIA8JgF7AdFIgI/sc+d3Ct362TQtehRFd2Rv?=
 =?us-ascii?Q?RYWa8sUVpS87zY10Rim8yMAmlFeROqnzw4l24/zjWpLQCfdRtMW8XENLM+U8?=
 =?us-ascii?Q?xSS7t0hhTrTecZS3b132QtMDog0DMrnFKrJ3JhBsFiBbRp/GVUvWsnTfWCfI?=
 =?us-ascii?Q?I7hLtwasxUMfExEX95ZnHayAHWqkzQ1CvE2TiSIy7Rpn+Sf281/nThK6h7Uk?=
 =?us-ascii?Q?CTd49sx81czso02sWX4f/GJF0b0EmuzEbsGT6pZMINZyxogqO1qEVXCyiy0/?=
 =?us-ascii?Q?35FWLw/2gMQeQLhoRVoUMHWVl7xAnS5Sn3tKUvPO1U1DUi4zxf94MknfAxxW?=
 =?us-ascii?Q?e775TdktoCbXz9HsxA6tKAkNU/GAECRlxxVrtUZqNpO4mw+MJGcwP02soErI?=
 =?us-ascii?Q?jrQfxjwzmzVF6jGrMA8h8KQ0pER5JIz9Lwoehv6ADQaVX2OmwhqidQ6Ps4RI?=
 =?us-ascii?Q?nVCuWtn5KXGi+xsDJHw3fXN+lGD6igqObHNvve6AS3HzlrY0bD6UNLMiPnFr?=
 =?us-ascii?Q?L43WwLX36Q9QzdHRxXIm/uDsa3w6dYxZyARj+yJNqVhwR3QSuXGtPvr5vh+v?=
 =?us-ascii?Q?1+TbK27UoHuwv1Ytm/taFjbL29gD5Hp3BrCAt7tZ9E3cbLMszysba7Jviy40?=
 =?us-ascii?Q?DvCdDF9BlgPKM6IDB+NbvOY0VU7hYuUj2Q1bhYccWmFX7d97lqnMS+ZL+LFz?=
 =?us-ascii?Q?KQL4rZ451n4K11NNalCbBH1N0YmcgXhzdyDPdatUiqnauAi9mC2lJ1ZVhMGC?=
 =?us-ascii?Q?suvre1CTOhCtdN5y/aXxWOfPwHppIRwDdLafBndfEPBjhObHLG1iarMJ5spW?=
 =?us-ascii?Q?nAuLxLqMebEzDZPd6r2HPkOBEbZnq3Ky8wmMRg+Sq36E2QWpZo8j2YtPHI+D?=
 =?us-ascii?Q?QN+NIGqj8UR400S6hhntdHPFwbsX1Yx25RKmLUMqBtJH/gnIrgdc9nAB2QDT?=
 =?us-ascii?Q?bQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74f7dcfd-3fcc-40d7-d859-08da8adcb7f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 23:09:40.9633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2hHk4zAJH+OGp0BYFwZP/TVan2WTY4j8qcRYqETyDLxViMaPnT5FsYwUpamq4twkts6HXSTKjiaHOleT/BVD3RJyiBlyJi1NrAENpblY+h4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4616
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, August 30, 2022 2:45 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Gal Pressman <gal@nvidia.com>; Saeed Mahameed <saeedm@nvidia.com>;
> netdev@vger.kernel.org; Simon Horman <horms@verge.net.au>; Andy
> Gospodarek <andy@greyhouse.net>
> Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
>=20
> On Tue, 30 Aug 2022 13:09:20 -0700 Jacob Keller wrote:
> > I'm trying to figure out what my next steps are here.
> >
> > Jakub, from earlier discussion it sounded like you are ok with acceptin=
g
> > patch to include "No FEC" into our auto override behavior, with no uAPI
> > changes. Is that still ok given the recent dicussion regarding going
> > beyond the spec?
>=20
> Yes, I reserve the right to change my mind :) but AFAIU it doesn't make
> things worse, so fine by me.
>

Ok.
=20
> > I'm also happy to rename the flag in ice so that its not misnamed and
> > clearly indicates its behavior.
>=20
> Which flag? A new ethtool priv flag?
>=20

No the flag I am referring to here is for the bit we pass to firmware from =
the driver. This is confusingly named "EN_AUTO_FEC" but it really means som=
ething like "override spec and try all FEC modes".

> > Gal seems against extending uAPI to indicate or support "ignore spec".
> > To be properly correct that would mean changing ice to stop setting the
> > AUTO_FEC flag. As explained above, I believe this will lead to breakage
> > in situations where we used to link and function properly.
>=20
> Stop setting the AUTO_FEC flag or start using a new standard compliant
> AUTO flag?

There is only "EN_AUTO_FEC" which means both "try multiple FEC modes, inclu=
ding ones outside the spec". If we disable this flag, then I believe it wil=
l only try the highest priority FEC mode for each link type. This is the fl=
ag which I think is poorly named and led me to misunderstand the whole beha=
vior.

>=20
> Gal, within the spec do you iterate over modes or pick one mode somehow
> (the spec gives a set, AFAICT)?
>=20
> > I have no way to verify whether other vendors actually follow this or
> > not, as it essentially requires checking with modules that wouldn't lin=
k
> > otherwise and likely requires a lot of trial and error.
>=20
> Getting some input from Broadcom or Netronome would be useful, yes :(
