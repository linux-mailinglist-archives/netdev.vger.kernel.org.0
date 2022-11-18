Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B005862EA1C
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbiKRAQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbiKRAQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:16:20 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2106.outbound.protection.outlook.com [40.107.113.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21D0BA6;
        Thu, 17 Nov 2022 16:16:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYG+GahUXvRUWDP0/TDRLMoB8SMfg54RMH7lrpU1ZJl6hdA8tyuc18KVrn9PZ+GAr2YckuKspGQJ2p3xavU+zkIjvF1Q0dAfCNVpDo+7/g7SuRFm2ICGH7k35pai41jlCin7ZT3p4BKii3bCFizXOoRbLIJxsLwdTAfhJwnkOE81wYiCcLeU36o3Hy0ymojCYfwY395cBACc7DREFJ6Pe6vkYOABzKrXGtOSJAMaD9we79SOXJFBM7ec8Lr9ErcR1NgA2UMqiQN/G1AwCh2kUpaLlY1Bho9kEphUoTKP5murSGLqmDYhIcXx3CKmL5pFOhgKB97Xn8NX00ulsQVzJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X36v5x8c77OE+BnRAApt+FlpegaWBHJGyURHQvPxjrk=;
 b=YvnaOH6yfoV8OwoM+5e8vKA1ej5WbxnuWvTKoliwTI/GYsCwoXDWtpOk1ZaKwmRwfxh+GZa5tDSnCAbTJ4OCasgypKQ+NUT/mc5H4j+rVVnUvNKc6vcm9Bd1NHw5wgr/x3DSVhWbParz9Hcvs9+72t5CkPFbwwjSBZCFal5mPxiK71GjnKYy5bCg2PI2Phz8v/RPEER0RqrkBwYWNmFxIW/oZ7XRkeI7qqhnUVNnVxH03yNlgPwyL74zYzevUpv3i0hgHtXExA+hHjR0QkiWNToPVSyo+EdFagBlUctLqx5qsI6hAogr0WTjaprzsn8xbvBhJM+wpRPkCuwu3d5UUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X36v5x8c77OE+BnRAApt+FlpegaWBHJGyURHQvPxjrk=;
 b=kOraunCwz8OyMXv9r7Q/GjHy0k4GRA/bhJkIjQRogi10Z0UUYbXFQPcqO/8prImMaFPqChAD+86E9zWrSIkBfeLwf5ooFPxbz6DoZzcjn9fpJeIivKgMYYj0HRNTektdAy8ZTzxThIzegaV8zxcUlpPTDP0HxocxBm7BMxNucLc=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYYPR01MB8071.jpnprd01.prod.outlook.com
 (2603:1096:400:ff::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Fri, 18 Nov
 2022 00:16:15 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::cd89:4a4b:161e:b78d]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::cd89:4a4b:161e:b78d%8]) with mapi id 15.20.5813.019; Fri, 18 Nov 2022
 00:16:15 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Leon Romanovsky <leon@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Dan Carpenter <error27@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: RE: [PATCH] net: ethernet: renesas: rswitch: Fix MAC address info
Thread-Topic: [PATCH] net: ethernet: renesas: rswitch: Fix MAC address info
Thread-Index: AQHY+U28RnERYwPjUEeRyuo9iuoUG65Co5qAgAAvGaCAAACdgIAABCCAgAAGlwCAAPL5gA==
Date:   Fri, 18 Nov 2022 00:16:15 +0000
Message-ID: <TYBPR01MB5341E09A238C0BE776ED769CD8099@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20221115235519.679115-1-yoshihiro.shimoda.uh@renesas.com>
 <Y3XQBYdEG5EQFgQ+@unreal>
 <TYBPR01MB5341160928F54EF8A4814240D8069@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <CAMuHMdVZDNu7drDS618XG45ua7uASMkMgs0fRzZWv05BH_p_5g@mail.gmail.com>
 <Y3X7gWCP3h6OQb47@unreal>
 <CAMuHMdV2feBGX1tjrGu-gzq_MwfVRS5OHY9V+=wOe_q-E2VkTg@mail.gmail.com>
In-Reply-To: <CAMuHMdV2feBGX1tjrGu-gzq_MwfVRS5OHY9V+=wOe_q-E2VkTg@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYYPR01MB8071:EE_
x-ms-office365-filtering-correlation-id: afe74a1b-3c06-458b-a509-08dac8fa1b9a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +yclIm4oFJjxGUb+vEGleWMcB98ddXhDlFw3JabZ2YZxWQEs7w3lK1hg6zUbStzhFC21VB0nbkLeJSWKOcBfKklB7l2eEbeuhO01iJWW7gUOOocie/WLivj0x5OkFNdSDtJ3z9lgFoE2bUi4tdhlBAThHltynNE+v3mxr34bzQ70t8QcYOctQpnZGAlrpNnldmg635FnmOAc/3Q7NesypROtgK0j8VtiVEZ/oazMvgxY3Vm1IuoPKpS/zgZ5+V06so5OmjXlwokIjAaMru7ucbX42vX1o9VtEcPSC4X8QsuR+Ig+h8vw6RNeLsYYr4fmDcEQqeW+aoSOLM5XD9pF+uNNdFJgMkIfAvWnCSWrrJzFMwv6NOo8cPnq2sbOzsxApTaCq7qauNYwdtw8vVt3xvxoPTYdspKOYGNCz5fa5WmxD9OSvXGfedyvXGJt7TrUPN39XDG08gURGVlJAvpyhy6f6P8vkSJlJftCzks81Otml02nYdfFVGO2FpcefQbkI7Q336UR31Y08RTeVUkpDI+QPav4mLz2ww6sr+ni8LkIMxu4f65CXSEqRSMzA6cOnfcpNQrHA146HoYPFqTdTfBzEO+05ot8hHFppkPKemGsiSDXVTBTy9d9fCp0UU4Hr5A1NRwWByWbuKstSOTn1ZVjNCmeobrxdPfCVPdvEsnMLgJG5vIu7xidWwE0DSenq0E0Xf+9cPyCMT+ZXciH/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(451199015)(9686003)(26005)(7696005)(66446008)(2906002)(4326008)(5660300002)(66556008)(8676002)(76116006)(66476007)(66946007)(122000001)(7416002)(6506007)(8936002)(316002)(53546011)(64756008)(41300700001)(52536014)(55016003)(38070700005)(86362001)(83380400001)(33656002)(38100700002)(478600001)(71200400001)(110136005)(54906003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Gb2tFv+0trDH17eJn0d1YtRKJeQKtXLw0329I2Qeaw3iJjy9f6F1X9D+u84M?=
 =?us-ascii?Q?SE9ULO8wvEF+KbJovKtpMzBS4J1gaYF7jZs5MVgSbdbyvyZyKwvedggR9HST?=
 =?us-ascii?Q?3BRf4RxkSqa6EJGZN/Rs3JgWL/SPoT6Ib8MdAd+BTmzHjHHaOqOWDAPr1x7M?=
 =?us-ascii?Q?jJfkgbl6B/nvV85VrokPCW0scKtbrVXve9q3w7xVS6d+mkEIcn4WDJeHHnHO?=
 =?us-ascii?Q?GDGN/Rfkquhq3rmrwlKZ6WmCAAzcRaLGxazTDS0yD9sh8ycxH4/lGLKqndQM?=
 =?us-ascii?Q?Y3lOEjSY1u5ICUbilqvab38pMRf7OxJAlZKMKJXBXbz1Lm1tMasMWNVDLgvb?=
 =?us-ascii?Q?r9SBkNNE14d8J7rwQq37T0Q4MmniNU/l2SJk251r1GM+dL/CyKpYRHgOjRr5?=
 =?us-ascii?Q?lukVuhbuwuiXPVFsCRsV5qMdW2XEsF8jbhKI8jhV0vSmgz+nmp0iLWWJ+U2g?=
 =?us-ascii?Q?AbEPonlWaLsT3k9gPE3k2/lnSJiFNS/xNQGUf8WQgMVDm5ldkiWtD0ojfX4R?=
 =?us-ascii?Q?LfUMrXSPQ70vD/w5WUY6FXBpIlTbkEU97oXVrN6srFwcroTVEmtTxFMERKfX?=
 =?us-ascii?Q?atYNz/9lLbHu9lnFFlnnFabunNw5L72kcKFnoWqL+tiTm2L3rZKM2s6de562?=
 =?us-ascii?Q?G1bQcrVOhkAZPfCAlgkc20GjtX2NgcrBLMFqFBWMO1xD7j8GtjbK3fq5Akh6?=
 =?us-ascii?Q?/2vYC9VXfA9oHkbiwq5ajb6QAdmVuFtxAUNfUs9MFA8cM7xzFCJ5yZe38hu7?=
 =?us-ascii?Q?6wBwHCBy9nNrPflzQ+JF9WIuHZqznoMOEBhuTGm9+fs4qFu3tTqm1O9YPjtF?=
 =?us-ascii?Q?qisGYfwOKaD9s8jMLo91ykK5S8lJNlEdp6NvbI/0lHRQTuUuaxunwPo4UKYS?=
 =?us-ascii?Q?KQ6IxlkpUAxW9chAzUHOhp5mtLkcuaJk5P6T58dwAqjcgLmXAhpuRqBZp1vt?=
 =?us-ascii?Q?CchsAZlgKS+3/mAqYBY41QDVbZea39YleZhWzfoWYfJO+MPEqhMOTSpykWle?=
 =?us-ascii?Q?A3IfCnUlRoqa7ExD/bdrlMc1osz9AE9JjqEjoImGq3mikUBwqGWcQPJvT8ae?=
 =?us-ascii?Q?bek0BZiuzWjNWAn0RWvK+wNA59sMYM5QRSdS8cTit4fvtLLzWQS4tvCtRVzx?=
 =?us-ascii?Q?mXChF/8PwBPLQaMiTTwBx5FLvnZl785oebwnWrSpNOpQiHOJdGNx3XDggaI6?=
 =?us-ascii?Q?h3P3/PekRc2jzJDZ7j9fYeMPplvn88Hfax/9TeQlnDk2HG5jZ/qrpaoqQkGk?=
 =?us-ascii?Q?co1a+Bn01j6dy72eNSZTn816YYrcHir7I3wxekkFozltMYtmHIiKwAfRHR7h?=
 =?us-ascii?Q?tMBeYyIv1AIdtLozV4p9qct8z28bQXzpYAd7N9/w1meAVC6mrtHPDw/Y1V0X?=
 =?us-ascii?Q?qElhMKEu+AByTSsxYrr+fNyQgDBoQvrJn7pSqxuKkR58C/IHyKhPzGXgT9t6?=
 =?us-ascii?Q?/sEsg8Zej6DvT/Tmks89vFLui4LmJjlq1oh/+SCDLU0tmoUpjILHVTmYg3hj?=
 =?us-ascii?Q?rBVondm6y3QD2FQxL1pcqBtP0N09Gn//4/FJltYHDfhXuucG72tGyjGhxqdH?=
 =?us-ascii?Q?R4kG5aDOSu5iBxER2OO5QPCC4Q5dLkwhCA0g4aNc7k4UMxTYpnz/hqqePQI/?=
 =?us-ascii?Q?tA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afe74a1b-3c06-458b-a509-08dac8fa1b9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 00:16:15.6219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cJ3tO+RCwvMI/C+13oi0TI3E7rn5wg5kc7683/R+wy8b/ju9AnIlu12IzpLH0pxjWc2LWW7BxrCns3JjltKVoOz5rTzJRXqGI6iFbRHiAxJHAAul6SHVB7jbH2U4hrkh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB8071
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert-san,

> From: Geert Uytterhoeven, Sent: Thursday, November 17, 2022 6:38 PM
>=20
> Hi Leon,
>=20
> On Thu, Nov 17, 2022 at 10:14 AM Leon Romanovsky <leon@kernel.org> wrote:
> > On Thu, Nov 17, 2022 at 09:59:55AM +0100, Geert Uytterhoeven wrote:
> > > On Thu, Nov 17, 2022 at 9:58 AM Yoshihiro Shimoda
> > > <yoshihiro.shimoda.uh@renesas.com> wrote:
> > > > > From: Leon Romanovsky, Sent: Thursday, November 17, 2022 3:09 PM
> > > > > > --- a/drivers/net/ethernet/renesas/rswitch.c
> > > > > > +++ b/drivers/net/ethernet/renesas/rswitch.c
> > > > > > @@ -1714,7 +1714,7 @@ static int rswitch_init(struct rswitch_pr=
ivate *priv)
> > > > > >     }
> > > > > >
> > > > > >     for (i =3D 0; i < RSWITCH_NUM_PORTS; i++)
> > > > > > -           netdev_info(priv->rdev[i]->ndev, "MAC address %pMn"=
,
> > > > > > +           netdev_info(priv->rdev[i]->ndev, "MAC address %pM\n=
",
> > > > >
> > > > > You can safely drop '\n' from here. It is not needed while printi=
ng one
> > > > > line.
> > > >
> > > > Oh, I didn't know that. I'll remove '\n' from here on v2 patch.
> > >
> > > Please don't remove it.  The convention is to have the newlines.
> >
> > Can you please explain why?
>=20
> I'm quite sure this was discussed in the context of commits
> 5fd29d6ccbc98884 ("printk: clean up handling of log-levels and
> newlines") and 4bcc595ccd80decb ("printk: reinstate KERN_CONT for
> printing continuation lines"), but I couldn't find a pointer to an
> official statement.
>=20
> I did find[1], which states:
>=20
>     The printk subsystem will, for every printk, check
>     if the last printk has a newline termination and if
>     it doesn't and the current printk does not start with
>     KERN_CONT will insert a newline.
>=20
>     The negative to this approach is the last printk,
>     if it does not have a newline, is buffered and not
>     emitted until another printk occurs.

Thank you for your reply and sharing information.
I'll keep '\n' on v2 patch.

Best regards,
Yoshihiro Shimoda

>     There is also the (now small) possibility that
>     multiple concurrent kernel threads or processes
>     could interleave printks without a terminating
>     newline and a different process could emit a
>     printk that starts with KERN_CONT and the emitted
>     message could be garbled.
>=20
> [1]
>=20
> Gr{oetje,eeting}s,
>=20
>                         Geert
>=20
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m6=
8k.org
>=20
> In personal conversations with technical people, I call myself a hacker. =
But
> when I'm talking to journalists I just say "programmer" or something like=
 that.
>                                 -- Linus Torvalds
