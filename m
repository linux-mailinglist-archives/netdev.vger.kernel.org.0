Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E994058D438
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 09:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbiHIHIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 03:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiHIHIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 03:08:11 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2100.outbound.protection.outlook.com [40.107.94.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58EF331;
        Tue,  9 Aug 2022 00:08:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRBTI+Ocn/SxjKor+Y09mm5Kg8+30vEO2rpig/5jUqWBsScpMZeeiiN/P9zOgcM69dUSLg+1zlBTzvssTlXJ7AKULI7qo2exi+yVOzwPkyR/D4oKwWTLRu8+LBfAUGWga2pTkVDAAsmqKXo3s40CDFkJVhSyfY1Awm9eKnCnpE+oX1gv1zVHDBhVsvy4+IurZSfgNKC48bLPPz1edjObvGyziRyV6Ww3Q/ep4NLeuN2EK8DBbTDjzD7S1DU5PwkV9Qj8OSxqkbmucul2lfLsYJoc2ppRSu6b9VRYIcCn0GH3uGPfvDVoMCItqrqJwDW6Ex/I4SvGY7uDYm/iwP2gkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZmEll4T3v5GcQazZNwreFZX5++17IfO0q8HSgYcU+jk=;
 b=KnOj834jNVQBgyjYjv1C/AGCqdJOSJ1CMb+QnH22+focW/w9+Ciqt3SenPs0Zy8/2R23TpSTxdRYlFLwKvYCMtVyuQ1OyisIWGcyFjr/bqXI3KBCoTMk25eY+m0PGZ2M3MZ+8zOHfHEc1/5chP9fVqcxWlTh2AKw51uYI+ScQ6HaKjWvL2NqJGxlcPGFA8+69qDmt+GE3naFEqZb5bvm9D097KX1m4g24HyXPzBm8Q2WWZF0b6dbeJGwJk8H0OMBUAtt8nFkl3ZLVQzf9jwEMWYOhnzRl31qYwssNoO+OPV7UiDPnnismQZ8hd1M9mEMu9LhR1YuOqZdjD3MLJzWkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZmEll4T3v5GcQazZNwreFZX5++17IfO0q8HSgYcU+jk=;
 b=qo/JMAZvHVj3i2AfBaFqkteNJCMMr95hfxdocg5BJ0ov5Wze7vJ5mFHsnUyUulweWC8ctK+HDpDprvsav5ieCJVtZTftDY0rFeITpbXmSDMWVjSoNu5t9TxeVDuQStLDmArvC8NmdD2hY3IHbYntlVVmhzo7Otanb+vKeQx75Bc=
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by BY5PR13MB4406.namprd13.prod.outlook.com (2603:10b6:a03:1c5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.12; Tue, 9 Aug
 2022 07:08:09 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::a9d5:4b03:a419:d0df]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::a9d5:4b03:a419:d0df%6]) with mapi id 15.20.5525.008; Tue, 9 Aug 2022
 07:08:08 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jialiang Wang <wangjialiang0806@163.com>,
        Simon Horman <simon.horman@corigine.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "niejianglei2021@163.com" <niejianglei2021@163.com>
CC:     oss-drivers <oss-drivers@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] nfp: fix use-after-free in area_cache_get()
Thread-Topic: [PATCH] nfp: fix use-after-free in area_cache_get()
Thread-Index: AQHYqaE1BCS9MTpwu0SYejRxYlUrlq2mJRpQ
Date:   Tue, 9 Aug 2022 07:08:08 +0000
Message-ID: <DM6PR13MB3705DA5B27B55BD93E465EE0FC629@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20220806143043.106787-1-wangjialiang0806@163.com>
In-Reply-To: <20220806143043.106787-1-wangjialiang0806@163.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8fb723f-cf59-4898-48bb-08da79d5ea0e
x-ms-traffictypediagnostic: BY5PR13MB4406:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7+R2cgrAGT4vCpDV3l7/BePL2WLU3aOKRdlAKOdxC2qbLn88HM1SI3IcofJWNo2WnQ8C8QhqNZ+Y5o9qhdbF74tjH6vxmS5mAp9WvFkWm5bra6UYw9hlFz94Q5mTRzzUvp9tVu1EgrlC4hBC97Ze/QMTak6WxCFGOnbOBc54Dq25O9sGDlxNQQZ2H0Hd1DfhA1p1frygRpkNhVwcI6qmUOiTY+YifhTnGGBSWHfAs4cc6nFuC0JtoipM1dEeQrvSQu56MQjwpCb/y3pzpc2Sb/9m/YxRE97VX56Jj+MHUSz3DLbfEDEmsJnI0CtDwX+5uVZ4EplaIV945+Oa9V/pwLhpSFD6M3/YCrLAx4pTdK/cjuyjQuKo0bvCqK/AzBcoAXP90kqsSYwfFw0V7bBHv1ULGya/sFOEaov87C+lto0jCkd1GNXCDFB4DShCne1sKuacmBZq+xM4ZOipzAxdAjsFX55JDyv4aUTUf8srsXhLkVR+mDXVvFpX/DmEYDzFbaWlR++2dZwyiaAx7D4nR8l/wIyhV/TFySS0l5dTKG/Qq2zAOiO9lwTZiYTxbJDkazIRezT5ZLyFl7Nv/9EYiN/UzJhx9bkebt2Do+rWlwljzR6gx1l9VOGfLugqulOsrR8J21r7ol/XbNOFT1gf+ZLHDzISBe7JNGH942YzxG/J+W1HP+QzMpLaQAUZLZRlvuOWer1Jsz2wgMj2QoCYXS6luLV3wddsOf6QoKdEQgAdap4YD3s7jCQxUpV+PEcKMZHVhKy7lkeiY0jAeZ7mf9kss5ad/igyJS89g4Z2wpKIjr7s+P3Tm3ceQ7QO+0/4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(366004)(39850400004)(396003)(136003)(71200400001)(7696005)(316002)(66446008)(64756008)(6506007)(8676002)(4326008)(54906003)(110136005)(8936002)(5660300002)(9686003)(52536014)(41300700001)(44832011)(2906002)(26005)(186003)(86362001)(33656002)(38070700005)(66476007)(76116006)(66946007)(66556008)(478600001)(55016003)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ilOwBTtU1e91u7KzlMJ3/hYL9adhRV2DpJrA+JWaFt7s6qjNJ36lBc571RMk?=
 =?us-ascii?Q?4VVNgl5tFXa8AwMnOky+SqB7leNEoCiprE1jsqYFXye7U9Zql3pCVTcZ7KyQ?=
 =?us-ascii?Q?JZg59MfVMvfhlTx+JsqmsIaRs9DuF8aAIGWrbZMYsNZT/8dBQAnHPIpDNfMX?=
 =?us-ascii?Q?PlYzGqXETmmxavIHAFgMILbsBLxfFHwYj2iFdLhy67rGggsnF5hxfaAO94ak?=
 =?us-ascii?Q?4MYWo9ndhldslptm8OR6j6C+qcMRGTN8fn4vC/WE1jO7VqJQuXit3ZBykoLj?=
 =?us-ascii?Q?d+FFwNxqLAGh2PTE/CWDWmJM49mAPGAoj9QKnIATaldNOg0kTzL9+E0D6cPJ?=
 =?us-ascii?Q?3Nubu4YDjXF/zUGGYquwSZ8ZwaJaUq3wwh6bvynUzrNrl1fwB4+Levi0UVO3?=
 =?us-ascii?Q?MDFsqRArm4R4g+/yQHaFlNaIt7c17vqlJxj4S9iMgFAFrOiPYHfMy0Lt0Gfn?=
 =?us-ascii?Q?lACQA8rb9VLUaMV7Mpx7I8u09zD//wGEi/iL4a+PQWfL3kDtnZ0MWoqw8KZv?=
 =?us-ascii?Q?w5gpkc23spIrXE1d5J62zWuxqvJFXAuKs5xyGm8PLQsx0HqSZqpRDZtE6Qpq?=
 =?us-ascii?Q?uZD6inpp9hbPwPWLRgVOP7f5/AvXhkoNxs50Qa9HP+kTVDrq+s0+Ny7g7uhx?=
 =?us-ascii?Q?htyR8tWx5bScLxeV/rU70BMpsBjg3Dancgho7Th535kng0i1J6HQiyV2ROk4?=
 =?us-ascii?Q?Cc8YcuqX5q/VSjxjxY1YqoSMq2nLNkYxfAgtSlDCh9Gb2fiq1rjwmPtFaLW/?=
 =?us-ascii?Q?fUXXCOwW72hAg1igP81QXmMlXTMOO0o5vGBMt9KUFkSoypN4sXKH9al3bMaZ?=
 =?us-ascii?Q?e/XPXEFH4ojM/Nu2y5BTxmFIWyuO5lNEZeeiIjhBbEjo1lOgTFblzvh9Xgw0?=
 =?us-ascii?Q?vz37jqEbKhERfTrYkX+HbrTo7IntyoHM+crQEoxiI+/Ybc/GHwWNB+fweEJJ?=
 =?us-ascii?Q?V6JaAaWuWWQHrHyyKTriuYF5m/zsuRrxrhmBihdJNaEhe0MXQ+0sRDUg7t4h?=
 =?us-ascii?Q?StvBT8bk7nlSUJaUka4hiUu+ORilfp2W/lRrNgQ6v566t1J4zb9XEIBb3CmX?=
 =?us-ascii?Q?AoBaEyq9VEDWO3dHk5Rh8UkIvx07RzKfyJhesIKjpM2j/U47V+PZXj9ke/A6?=
 =?us-ascii?Q?0Y2SwVOwQCKoYkPMHNoAa8t0C5Zfw8AgVKDFx+erc6OhcIAPM2cuo9DIfZHk?=
 =?us-ascii?Q?ccptoRfTeJiDGFOhrcpBp5UA0Cy0H/kV0cvyIg3+puUahVWkwhT3LTsiiYqQ?=
 =?us-ascii?Q?b8sswFPCX31EPtLq676XOS+y+zahWUD+UpayjiXKKfR4dcdHhB1IKII0k0we?=
 =?us-ascii?Q?k7bv1PwAdUtZ8HGb9K+whUqqPDI8mlt1g9TaARzr2cruhTkFoTpLTSNzqRh7?=
 =?us-ascii?Q?7iQFKBecfaLvz/NL6OhJzQPhwRw9vCN4aR7QyQUer+vcv9MoQNt6hrgsf7sW?=
 =?us-ascii?Q?/0iRWW0Ip27CYbex5olN/ZFRYAO7Tt/B6xciy7IOauJhHNFUKr8/RkHcVHDg?=
 =?us-ascii?Q?2e1Y6EJltR+7PX+3nsIMUl30uIEcztLCKoOv5sIDK2pwpcUqs4lgQldHSzui?=
 =?us-ascii?Q?D0C0iszboGk+5kCIgI3r4oDa2Ety6s4uwkz716ua?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8fb723f-cf59-4898-48bb-08da79d5ea0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 07:08:08.7989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ox2bTMPKAJFi9StZndSZTGBg+q4d3l2JQlPW1nH2oEq3p1qM+HCb1HkbCjZVvjpd43KrTGXnbyj2h+PS5K5m2vy8Jo8wUypYCavs28CDKuo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB4406
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  6 Aug 2022 22:30:43 +0800 Jialiang Wang wrote:
> area_cache_get() calls cpp->op->area_init() and uses cache->area by
>  nfp_cpp_area_priv(area), but in
>  nfp_cpp_area_release()->nfp_cpp_area_put()->__release_cpp_area() we
>  already freed the cache->area.

It frees only under condition that `area->kref` refcount is zero. But in no=
rmal path,
the refcount is incremented by calling `nfp_cpp_area_acquire` when `cache->=
id`
is not zero. So it's OK to release once when `cache->id` is not zero.

But it does have some problem in error path when `area_init` or `area_acqui=
re`
fails, in which case `cache->id` is already set but refcount is not increme=
nted as
expected. So we need set `cache->id` after everything is done.

So your current fix is not appropriate. Anyway thanks for bringing this to =
table,
I think you can resubmit a v2 to fix it?

>=20
> To avoid the use-after-free, reallocate a piece of memory for the
>  cache->area by nfp_cpp_area_alloc().
>=20
> Note: This vulnerability is triggerable by providing emulated device
>  equipped with specified configuration.
>=20
> BUG: KASAN: use-after-free in nfp6000_area_init+0x74/0x1d0 [nfp]
> Write of size 4 at addr ffff888005b490a0 by task insmod/226
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0x33/0x46
>   print_report.cold.12+0xb2/0x6b7
>   ? nfp6000_area_init+0x74/0x1d0 [nfp]
>   kasan_report+0xa5/0x120
>   ? nfp6000_area_init+0x74/0x1d0 [nfp]
>   nfp6000_area_init+0x74/0x1d0 [nfp]
>   area_cache_get.constprop.8+0x2da/0x360 [nfp]
>=20
> Signed-off-by: Jialiang Wang <wangjialiang0806@163.com>
> ---
>  drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
> b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
> index 34c0d2ddf9ef..99091f24d2ba 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
> @@ -871,6 +871,10 @@ area_cache_get(struct nfp_cpp *cpp, u32 id,
>  		nfp_cpp_area_release(cache->area);
>  		cache->id =3D 0;
>  		cache->addr =3D 0;
> +		cache->area =3D nfp_cpp_area_alloc(cpp,
> +						 NFP_CPP_ID(7,
> +						 NFP_CPP_ACTION_RW, 0),
> +						 0, cache->size);
>  	}
>=20
>  	/* Adjust the start address to be cache size aligned */
> --
> 2.17.1

