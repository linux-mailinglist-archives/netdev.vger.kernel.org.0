Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12A84BCE29
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 12:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbiBTLc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 06:32:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiBTLc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 06:32:58 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2139.outbound.protection.outlook.com [40.107.113.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2E66375;
        Sun, 20 Feb 2022 03:32:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksxydqRskkZoj1Z9sZV9h8Nk/CaUCdRDn7OWmse0dVF6ZMJCDi3jOr9fRRBQZ4HdvMlofcvkURmAjq0dhs0aJLYaJQqwMvC6IWhQgxN9d8Yrhe+DhJlmnQ6v7aIZ+a2nMoCcosUdNh96JALOsARz3Og80E4qXsewR2qZ+PlEZl53PPOJQQ3RTD3+L1HKsro12WGQAfmJL1ej6DT9KPbKHawCfIveUhfrC/Po+V4/og4EoWG+rVrsw5zC1C0TCEW8YrOr+lXUtNTsFAAgA5EvqKHlZBKfQB6zCTHUn81JinBtY04yjV5IrxskISiLXqtckwvtb457vTNmYca3nVsJqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MHCSZOjMk8un68mhGcaGQCbVVqg9f4/41rCDKemeI/Y=;
 b=XrnyVmP72afykKtxQQkXgPllaL0oKHuC7dMSAeFCEf8sDGhkSWGq7L11jRYGxz+3BBg/otYz/Lppz5IC7Bgn2cwOrsiXYc4aqK6ZjDpzqKYEwjpfx7lrfiKvpSPp5uwZooYjCoA9LP1t1rh3zlcB08GiJYc8b/2oxRCvFrkwR/lvDH2ZwTFprffbObve4BSqIx+HfNWADF5qIBc9i12rpBKN5svabOPF8jdmxGPE+3EuPGem5qCybMk7GCDhZUuUzBxK2/rB1IvnhOIcXC6U22EfFyiNWnU5Oy429UfJNsV8Hh1UBy9EPP4f6q/9ciPtnKEpQMNKSyIuLkguAGGwnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHCSZOjMk8un68mhGcaGQCbVVqg9f4/41rCDKemeI/Y=;
 b=eCkqIH9O/wvtLGeZGRvt/GU9T4DgL35GbAyBdhck6VHoyRg41XD/oO0Sa6szELyqhseqNoHXtmRMoaTAtKoodvvtdDO/nrOpig7mpTUw27a10lBZyccUPZBoJKCutaR/H8JzRb0I1/Zo0jyYwZTWvzjMb1fkZyQW4oBKHj+Fz0o=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYXPR01MB1886.jpnprd01.prod.outlook.com (2603:1096:403:12::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Sun, 20 Feb
 2022 11:32:31 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::58d9:6a15:cebd:5500]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::58d9:6a15:cebd:5500%5]) with mapi id 15.20.4995.026; Sun, 20 Feb 2022
 11:32:31 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH] ravb: Use GFP_KERNEL instead of GFP_ATOMIC when possible
Thread-Topic: [PATCH] ravb: Use GFP_KERNEL instead of GFP_ATOMIC when possible
Thread-Index: AQHYJitP/nu5LcwZQ0S52dNHzV9R7aycC/4QgAAVCgCAAC1AoA==
Date:   Sun, 20 Feb 2022 11:32:30 +0000
Message-ID: <OS0PR01MB592267F71C626155F705496E86399@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <3d67f0369909010d620bd413c41d11b302eb0ff8.1645342015.git.christophe.jaillet@wanadoo.fr>
 <OS0PR01MB5922D806D40856485CDD612086399@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <a4006848-3dfe-8511-5010-37daa31df464@wanadoo.fr>
In-Reply-To: <a4006848-3dfe-8511-5010-37daa31df464@wanadoo.fr>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43deb03d-716e-43a1-86cc-08d9f464ae77
x-ms-traffictypediagnostic: TYXPR01MB1886:EE_
x-microsoft-antispam-prvs: <TYXPR01MB18862A07BF524934DAD0B6D486399@TYXPR01MB1886.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NN1Y/OMTqua+cIc4bIAuSpWWY52RLKFKKXc76smu4L+nz6R25UrhIlHl/eBVIod3n3vG8nJkGt/LLipH2x472pqZzk+i105IsmRZd2gGkGwqWv0dN4/tyoryBQkF1RYBD/b1lxQqpuhFQ81jUNmZ7bd2RQb04U6n5/BnxkaKhxbBL2N0aYr3gkZvPgnqKdIjPzRdE4Hqsk/e57a8mf17CyR8te3lZ9AUnQYR5vNgEvQTkZZduWaIp/yvw/SokYkunHlj/NxLx1vxsNaYbVXTIYNjCluArNEMoJRZLh7IxKb9XZXu1K+pWbyk8Ut81rqLnR1rVp0gfyXxol4rbj9hFKOip5sZz+oWFyg9dR9HL2OuHk127EUdd+C02hh2VlNuvcWmpXUYvVAEa0qMty3zeV60cvmSUN+mJUvUNZMkE2bPiVnPYf+lNqjt4cogMPwItlXnxKCHC9M4bC4iz9sF//9O9ExRBk3n6MdUtSE2yANAchSADMh4oFqRssBCdJsJLy8tkst+Bi6cw+5fxCpqH9XUHIuUarjvFUVFBDmdMczGiBhbvEKmeWi072B8snMY056L7ZVfUe90J8D27dClyxuD8KwwBPEYCYsoudx8VyWjPfvpf/5LLs4hs1VfBGaDdcKl5SxZbwualjEZFwoLYXvKplvtk5uEwQmL1WMjCj2F75b2LoN9LzcS7WZRZmWfzPotxkwZEwZOuuiWR8PmBecto87bPEBhNTislaptKuJKLB1zD1BYlW2L9iHPE/Nwv4HxruW+Erk+cyKx81r46X/JYVHTIzKIldhyFX1Wh9M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(55016003)(64756008)(4326008)(38070700005)(8676002)(66476007)(122000001)(2906002)(86362001)(76116006)(66446008)(66556008)(66946007)(38100700002)(5660300002)(52536014)(8936002)(26005)(186003)(71200400001)(966005)(6506007)(7696005)(9686003)(53546011)(54906003)(316002)(508600001)(83380400001)(66574015)(45080400002)(110136005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?L0WET8FxIMj/OnHza7l69Z3s9xG/szIUAkKCq7pfct4OZREsT+lbjY/l/G?=
 =?iso-8859-1?Q?A/dpBbis+J0oaTc7n8KniH+IXH8mDnDyHzHPghtOS2iou/ZpO0I558GMfB?=
 =?iso-8859-1?Q?AliAeBm/uBj8TZ377Y98vshxQ0YKgbnvV8qUoF/FOhRJv5Ttl6RR+SSfql?=
 =?iso-8859-1?Q?M0pWnH61ueSDA71xhowbDPKjyjirD6wuRMESdfundp43XLp030pPTzxKiR?=
 =?iso-8859-1?Q?+2sFp9S23nQ3EcL8J+F2mDbUslCyqJbr54nT36BfWl6TbnsiLlw04U9Oiv?=
 =?iso-8859-1?Q?q86UYpWmugG/eDP4319zNNGgsz30FF5Tj7fSsnlvTAwQZwSY+dCiWijFa0?=
 =?iso-8859-1?Q?+Y6NMMF/eBhzbObtt7AasUEFKumK4zwd2Aile3h3Zf7S9gJmrPTtTlVqnU?=
 =?iso-8859-1?Q?ulVlIqJ3g15k+zRE1EvmIGsttia42cGmNPlDBgS0Y4EN00tiCLM/nISyvW?=
 =?iso-8859-1?Q?tCtMGUxzUAh4T0SzoApCfaTP0fsYWNF2k5EE9hbSmmClZfdj0PnwbsdPi9?=
 =?iso-8859-1?Q?2C/HBQ+U90SoSTTAt9O3wpO7wYp256JQjcEme7/W6rDjv1hCTy/tMfvFwm?=
 =?iso-8859-1?Q?CxQXS4ofHobgL1mR674o/n8lf6onGL6c/NQxB5RGtBPOnvcl/2oUSagKRx?=
 =?iso-8859-1?Q?ZZQkkou2LYUmbzZJub0yGjCEuUuemNmT5w/IhpG3CLmx9EwqG+Ou32Rmtg?=
 =?iso-8859-1?Q?3Tr7j0m9WK/IZZ887/YHJv6jqpRxl3dYf2zs3hKLmasDnzI9dX5d9yeNF5?=
 =?iso-8859-1?Q?ObhzJ8MPV+L/JRxiwRGwLyDxALRm3Q94tx5lA5lHIKaS+Jae3AcjGLS7g5?=
 =?iso-8859-1?Q?pHnHOp6lvPVT/O7yCqKajm2fzSDmfgzyijl5vznI+BS9vnd7k+jCAc+PPt?=
 =?iso-8859-1?Q?UMNJGPMHVvmefODDeSqHRxB+EeKWUY5jlqRfkGB9ykbrvMsUaXfTDqa8a6?=
 =?iso-8859-1?Q?rXDydz0PAAjiNzzbwnAMch7wLSi3K9ZRpIMftWfm//1q2zEPsbFSiM98H7?=
 =?iso-8859-1?Q?FL/FhFZMYzRcBaPnWY+5P5xw3EAwPP2Hl0O0iotuZ4/3l6RdTRqweFwmLp?=
 =?iso-8859-1?Q?ahp0sF4TdLnO4R1TClqWbLFMC23Lv6a2jIB5LRNfpBx8pu334utB1Yeb1j?=
 =?iso-8859-1?Q?M9Gqt1bbkSN5mgzXmVzdqXy6H59knHi/iYKNt9ZtKV16CoMmMdrK2f9TFU?=
 =?iso-8859-1?Q?VaCo8CJJB+zEv/ArEc38KLIlW7PNSIFJEOMKD482OSdzEVTfH0YsMt41yy?=
 =?iso-8859-1?Q?X243i1lodlOXBiLpkfPOOmXYn+TkkrwprVkG+fFKaw4F0wyeO2x5Bh5YXC?=
 =?iso-8859-1?Q?1zO1jPzet5nuQ31/43k0+MoWd62xHUmFrtr7CDb0P9fcgUCXapu9PSWxrr?=
 =?iso-8859-1?Q?XmVBrxnOtEhxdki61FivDEVkMMI5N/UGhOjlsnTHXET2NuElEHevzAnsh+?=
 =?iso-8859-1?Q?FS52EpxZCRjP9PpIqwO2ZnybqoO4ER4nku7BBvT0E/G+Wj4cAggfM7UDq0?=
 =?iso-8859-1?Q?y7h15K93TnJ8iI300cBi62aBn+HAwZn4FqFY7WpjCLTfeNmF1ay3ejnpR+?=
 =?iso-8859-1?Q?/SK2gYB8+QfL7MqeYEHIvW/H6B8hFFLY5W3sEvRtN1gl2LYsJH8m6S6U1i?=
 =?iso-8859-1?Q?gIUIwWUCavwng61w3Nd3+ymI2rCvSZjKCpyP0PN60zxbr1Em0FgoTKhTcN?=
 =?iso-8859-1?Q?0MYrpa0RqBN2f6qH6Rit7+6RuIcc7AFTDamPC2fhgCAt0HmLfDTt5ooie7?=
 =?iso-8859-1?Q?apcA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43deb03d-716e-43a1-86cc-08d9f464ae77
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2022 11:32:30.9986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ihfX+rn/JnpxC3SVCoFfajKjejDkVcOpIfKzlyhVNnNZAkhwLBPRtFu66S7QwG/8jPLb/jmCumb3nAgQOFEbJIYpVanT3RwB6qQVFUP0AK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYXPR01MB1886
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe,

Thanks for your clarification.

Patch Looks good to me.

Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>

Cheers,
Biju

> -----Original Message-----
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Sent: 20 February 2022 08:49
> To: Biju Das <biju.das.jz@bp.renesas.com>; Sergey Shtylyov
> <s.shtylyov@omp.ru>; David S. Miller <davem@davemloft.net>; Jakub Kicinsk=
i
> <kuba@kernel.org>
> Cc: linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org;
> netdev@vger.kernel.org; linux-renesas-soc@vger.kernel.org
> Subject: Re: [PATCH] ravb: Use GFP_KERNEL instead of GFP_ATOMIC when
> possible
>=20
> Le 20/02/2022 =E0 08:53, Biju Das a =E9crit=A0:
> > Hi Christophe,
> >
> > Thanks for the patch.
> >
> > Just a  question, As per [1], former can be allocated from interrupt
> context.
> > But nothing mentioned for the allocation using the patch you
> > mentioned[2]. I agree GFP_KERNEL gives more opportunities of successful
> allocation.
>=20
> Hi,
>=20
> netdev_alloc_skb() uses an implicit GFP_ATOMIC, that is why it can be
> safely called from an interrupt context.
> __netdev_alloc_skb() is the same as netdev_alloc_skb(), except that you
> can choose the GFP flag you want to use. ([1])
>=20
> Here, the netdev_alloc_skb() is called just after some
> "kcalloc(GFP_KERNEL);"
>=20
> So this function can already NOT be called from interrupt context.
>=20
> So if GFP_KERNEL is fine here for kcalloc(), it is fine also for
> netdev_alloc_skb(), hence __netdev_alloc_skb(GFP_KERNEL).
>=20
> >
> > Q1) Here it allocates 8K instead of 1K on each loop, Is there any
> limitation for netdev_alloc_skb for allocating 8K size?
>=20
> Not sure to understand.
> My patch does NOT change anything on the amount of memory allocated. it
> only changes a GFP_ATOMIC into a GFP_KERNEL.
>=20
> I'm not aware of specific limitation for netdev_alloc_skb().
> My understanding is that in the worst case, it will behave just like
> malloc() ([3])
>=20
> So, if it was an issue before, it is still an issue after my patch.
>=20
> > Q2) In terms of allocation performance which is better netdev_alloc_skb
> or __netdev_alloc_skb?
>=20
> AFAIK, there should be no difference, but __netdev_alloc_skb(GFP_KERNEL)
> can succeed where netdev_alloc_skb() can fail. In such a case, it would b=
e
> slower but most importantly, it would succeed.
>=20
>=20
> CJ
>=20
> [1]:
> https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Felixi=
r.b
> ootlin.com%2Flinux%2Fv5.17-
> rc4%2Fsource%2Finclude%2Flinux%2Fskbuff.h%23L2945&amp;data=3D04%7C01%7Cbi=
ju.
> das.jz%40bp.renesas.com%7C5fab03422ea84da79f5308d9f44dd4fd%7C53d82571da19=
4
> 7e49cb4625a166a4a2a%7C0%7C0%7C637809437402718622%7CUnknown%7CTWFpbGZsb3d8=
e
> yJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&=
a
> mp;sdata=3D0GC7vUwDkz5n7wESWC2gK3x6e8RalA%2FCg%2FmokTv%2BIHE%3D&amp;reser=
ved
> =3D0
>=20
> [2]:
> https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Felixi=
r.b
> ootlin.com%2Flinux%2Fv5.17-
> rc4%2Fsource%2Fdrivers%2Fnet%2Fethernet%2Frenesas%2Fravb_main.c%23L470&am=
p
> ;data=3D04%7C01%7Cbiju.das.jz%40bp.renesas.com%7C5fab03422ea84da79f5308d9=
f44
> dd4fd%7C53d82571da1947e49cb4625a166a4a2a%7C0%7C0%7C637809437402718622%7CU=
n
> known%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiL=
C
> JXVCI6Mn0%3D%7C3000&amp;sdata=3DKsLMiap6E%2BBEl4DOqBvPE%2BVsfCtTpZqAa4Pvy=
KFq
> B9E%3D&amp;reserved=3D0
>=20
> [3]:
> https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Felixi=
r.b
> ootlin.com%2Flinux%2Fv5.17-
> rc3%2Fsource%2Fnet%2Fcore%2Fskbuff.c%23L488&amp;data=3D04%7C01%7Cbiju.das=
.jz
> %40bp.renesas.com%7C5fab03422ea84da79f5308d9f44dd4fd%7C53d82571da1947e49c=
b
> 4625a166a4a2a%7C0%7C0%7C637809437402718622%7CUnknown%7CTWFpbGZsb3d8eyJWIj=
o
> iMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sd=
a
> ta=3DkwR2VU5sT%2FiD9y5VUMTztet1btFjlHqU1j5pCXF%2F1Vk%3D&amp;reserved=3D0
>=20
>=20
> >
> > [1]
> > https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww=
.
> > kernel.org%2Fdoc%2Fhtmldocs%2Fnetworking%2FAPI-netdev-alloc-skb.html&a
> > mp;data=3D04%7C01%7Cbiju.das.jz%40bp.renesas.com%7C5fab03422ea84da79f53=
0
> > 8d9f44dd4fd%7C53d82571da1947e49cb4625a166a4a2a%7C0%7C0%7C6378094374027
> > 18622%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJB
> > TiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=3DAhBE6136UO98boBjSE3bpBSDv=
8
> > 2EsuvgzXbOHy%2FIM1U%3D&amp;reserved=3D0
> > [2]
> > https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww=
.
> > kernel.org%2Fdoc%2Fhtmldocs%2Fnetworking%2FAPI---netdev-alloc-skb.html
> > &amp;data=3D04%7C01%7Cbiju.das.jz%40bp.renesas.com%7C5fab03422ea84da79f=
5
> > 308d9f44dd4fd%7C53d82571da1947e49cb4625a166a4a2a%7C0%7C0%7C63780943740
> > 2718622%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLC
> > JBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=3DIqNfl5kZoQzO%2FB%2Frfq7=
q
> > 4QbgxKzoCy6iWB1ZXER7zO4%3D&amp;reserved=3D0
> >
> > Regards,
> > Biju
> >
> >> Subject: [PATCH] ravb: Use GFP_KERNEL instead of GFP_ATOMIC when
> >> possible
> >>
> >> 'max_rx_len' can be up to GBETH_RX_BUFF_MAX (i.e. 8192) (see
> >> 'gbeth_hw_info').
> >> The default value of 'num_rx_ring' can be BE_RX_RING_SIZE (i.e. 1024).
> >>
> >> So this loop can allocate 8 Mo of memory.
> >>
> >> Previous memory allocations in this function already use GFP_KERNEL,
> >> so use __netdev_alloc_skb() and an explicit GFP_KERNEL instead of a
> >> implicit GFP_ATOMIC.
> >>
> >> This gives more opportunities of successful allocation.
> >>
> >> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> >> ---
> >>   drivers/net/ethernet/renesas/ravb_main.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
> >> b/drivers/net/ethernet/renesas/ravb_main.c
> >> index 24e2635c4c80..525d66f71f02 100644
> >> --- a/drivers/net/ethernet/renesas/ravb_main.c
> >> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> >> @@ -475,7 +475,7 @@ static int ravb_ring_init(struct net_device
> >> *ndev, int
> >> q)
> >>   		goto error;
> >>
> >>   	for (i =3D 0; i < priv->num_rx_ring[q]; i++) {
> >> -		skb =3D netdev_alloc_skb(ndev, info->max_rx_len);
> >> +		skb =3D __netdev_alloc_skb(ndev, info->max_rx_len, GFP_KERNEL);
> >>   		if (!skb)
> >>   			goto error;
> >>   		ravb_set_buffer_align(skb);
> >> --
> >> 2.32.0
> >
> >

