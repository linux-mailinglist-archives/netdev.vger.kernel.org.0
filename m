Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27065694B32
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjBMPcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjBMPcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:32:33 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFFAC40DE;
        Mon, 13 Feb 2023 07:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676302350; x=1707838350;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=DeaAOy1EtIPetsiAcsgakhwt7uVrCAel/kw4PMiuCVs=;
  b=ncbgp2vyz2qjQo16cObxlR75f9TSMSj2QrgUJpod11OvNiZmtdiSpev4
   kUnG674+hoP8C5kORA7D/FD3Jwr83T1QoMukQzfEw4uQP0blSRaoYFRWH
   yrTONkj/o0Q+4nCWVqtOD4izfto9UkIPMl7suVbNTWlQxx9M6rM7GuyjE
   4uMWQAiiPMp5n75YREMSGzK/Nt0OOjAM7mRGX92h0nB4qiMRPOhiJujBb
   q5bWiafU4VQSfh7cMDcNxs1iMbn9MH2W3TeqDclS9RZq6QPVvlTaRyMl6
   c4JOZxBHjQo9csGYNNESyMpSNeEgSsz+BM6ZoJnGElgSs5abUJYyvJb8T
   w==;
X-IronPort-AV: E=Sophos;i="5.97,294,1669100400"; 
   d="scan'208";a="200723559"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Feb 2023 08:32:29 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 08:32:28 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 08:32:22 -0700
Message-ID: <54791f7d5e4211b03a53e890a5d8a678039bec6d.camel@microchip.com>
Subject: Re: [PATCH net-next 02/10] net: microchip: sparx5: Clear rule
 counter even if lookup is disabled
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Dan Carpenter <error27@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        "Russell King" <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Michael Walle <michael@walle.cc>
Date:   Mon, 13 Feb 2023 16:32:21 +0100
In-Reply-To: <Y+pR4RZ8wJYFgSHL@kadam>
References: <20230213092426.1331379-1-steen.hegelund@microchip.com>
         <20230213092426.1331379-3-steen.hegelund@microchip.com>
         <Y+ofJK2psEnj9QNh@kadam>
         <c5920cb1f3db053c705a988cf484bbbaa5c3dcfa.camel@microchip.com>
         <Y+pR4RZ8wJYFgSHL@kadam>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

On Mon, 2023-02-13 at 18:06 +0300, Dan Carpenter wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Mon, Feb 13, 2023 at 01:44:35PM +0100, Steen Hegelund wrote:
> > > > diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > > > b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > > > index b2753aac8ad2..0a1d4d740567 100644
> > > > --- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > > > +++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > > > @@ -1337,8 +1337,8 @@ static void vcap_api_encode_rule_test(struct =
kunit
> > > > *test)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 port_mask_rng_mask =3D 0x0f;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 igr_port_mask_value =3D 0xffabcd=
01;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 igr_port_mask_mask =3D ~0;
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0 /* counter is written as the last operati=
on */
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0 u32 expwriteaddr[] =3D {792, 793, 794, 79=
5, 796, 797, 792};
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 /* counter is written as the first operat=
ion */
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0 u32 expwriteaddr[] =3D {792, 792, 793, 79=
4, 795, 796, 797};
> > >=20
> > > So this moves 792 from the last to the first.=C2=A0 I would have expe=
cted
> > > that that would mean that we had to do something like this as well:
> > >=20
> > > diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > > b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > > index b2753aac8ad2..4d36fad0acab 100644
> > > --- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > > +++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > > @@ -1400,7 +1400,7 @@ static void vcap_api_encode_rule_test(struct ku=
nit
> > > *test)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Add rule with write cal=
lback */
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D vcap_add_rule(rule=
);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 KUNIT_EXPECT_EQ(test, 0, r=
et);
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 KUNIT_EXPECT_EQ(test, 792, is2_=
admin.last_used_addr);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 KUNIT_EXPECT_EQ(test, 797, is2_=
admin.last_used_addr);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (idx =3D 0; idx < ARRA=
Y_SIZE(expwriteaddr); ++idx)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 KUNIT_EXPECT_EQ(test, expwriteaddr[idx],
> > > test_updateaddr[idx]);
> > >=20
> > >=20
> > > But I couldn't really figure out how the .last_used_addr stuff works.
> > > And presumably fixing this unit test is the point of the patch...
> >=20
> > It is just the array of addresses written to in the order that they are
> > written,
> > so for the visibility I would like to keep it as an array.
> >=20
>=20
> My question was likely noise to begin with, but it's not clear that I
> phrased it well.=C2=A0 I'm asking that since 797 is now the last element =
in
> the array, I expected that the KUNIT_EXPECT_EQ() test for last_used_addr
> would have to be changed to 797 as well.

There are two writes to the 792 address as the counter recides with the sta=
rt of
the rule (the lowest address of the rule).  Instead of being written after =
the
rule, it is now being written before the rule, so the test array that recor=
ds
the order of the write operations gets changed.

The is2_admin.last_used_addr on the other hand records the "low water mark"=
 of
used addresses in the VCAP instance, so it does not change as the rule size=
 is
the same.

>=20
> regards,
> dan carpenter
>=20

BR
Steen
