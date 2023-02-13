Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECE669461B
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 13:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjBMMoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 07:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjBMMom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 07:44:42 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A68A1A4AB;
        Mon, 13 Feb 2023 04:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676292280; x=1707828280;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=wSfPBVbsOiDQXnUbwjKvcSTq8xFHs34NQGZsvdlwvwU=;
  b=Qdp3CJkAKo/C7P9OmJx8aAeQCXAjmz6AxMnT9o0tq57jtixUkJiLtRUt
   tl/XY4MTJBkdgLTkbRNUD7683/5a9UEkxY5b9skOC4BuKf3IQeITpUVms
   OooMlqK6AxTTsV81J27jtE+5nVpSadvoXrjyzsWPi9/Kymlp1F/rZpAjV
   vO1m78xrHmNOi1OGWzAafAk3Bb5Nb+gSqMHG8KqGpmzd8/8wUWJEGzKeP
   Blk8m5tPXM5w7Gf8y9B7GU+FnhFHe3Jf1/Z6W2zg4ayqALhy5iAr/g9zI
   w6O9+SrK8sH1sXH1NWKoGEMU5C3dYDSYlu5zgXlV1cpcYb5x1iIfqXj+d
   g==;
X-IronPort-AV: E=Sophos;i="5.97,294,1669100400"; 
   d="scan'208";a="200416305"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Feb 2023 05:44:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 05:44:39 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 05:44:35 -0700
Message-ID: <c5920cb1f3db053c705a988cf484bbbaa5c3dcfa.camel@microchip.com>
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
Date:   Mon, 13 Feb 2023 13:44:35 +0100
In-Reply-To: <Y+ofJK2psEnj9QNh@kadam>
References: <20230213092426.1331379-1-steen.hegelund@microchip.com>
         <20230213092426.1331379-3-steen.hegelund@microchip.com>
         <Y+ofJK2psEnj9QNh@kadam>
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

On Mon, 2023-02-13 at 14:29 +0300, Dan Carpenter wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Mon, Feb 13, 2023 at 10:24:18AM +0100, Steen Hegelund wrote:
> > The rule counter must be cleared when creating a new rule, even if the =
VCAP
> > lookup is currently disabled.
> >=20
> > Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
>=20
> Is this a bugfix?=C2=A0 If so what are the user visible effects of this b=
ug
> and please add a Fixes tag.=C2=A0 If not then could you explain more what
> this patch is for?

Yes this is a bugfix of a side effect introduced by my mid-January series "=
Add
support for two classes of VCAP rules" where this counter change should hav=
e
been added too.

The counter problem is only present on VCAP that has external counters, so =
it
only affects the IS2 and ES0 VCAP on Sparx5 and none of the LAN966x VCAPs.

I will add a Fixes tag to the next series.

>=20
> > ---
> > =C2=A0drivers/net/ethernet/microchip/vcap/vcap_api.c=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 7 +++++--
> > =C2=A0drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c | 4 ++--
> > =C2=A02 files changed, 7 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > index 6307d59f23da..68e04d47f6fd 100644
> > --- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > +++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > @@ -2246,6 +2246,11 @@ int vcap_add_rule(struct vcap_rule *rule)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (move.count > 0)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 vcap_move_rules(ri, &move);
> >=20
> > +=C2=A0=C2=A0=C2=A0=C2=A0 /* Set the counter to zero */
> > +=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D vcap_write_counter(ri, &ctr);
> > +=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 goto out;
> > +
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ri->state =3D=3D VCAP_RS_DISABLED) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 /* Erase the rule area */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 ri->vctrl->ops->init(ri->ndev, ri->admin, ri->addr, ri->size);
> > @@ -2264,8 +2269,6 @@ int vcap_add_rule(struct vcap_rule *rule)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 pr_err("%s:%d: rule write error: %d\n", __func__, __LINE__,
> > ret);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 goto out;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > -=C2=A0=C2=A0=C2=A0=C2=A0 /* Set the counter to zero */
> > -=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D vcap_write_counter(ri, &ctr);
> > =C2=A0out:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_unlock(&ri->admin->lock);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
> > diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > index b2753aac8ad2..0a1d4d740567 100644
> > --- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > +++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > @@ -1337,8 +1337,8 @@ static void vcap_api_encode_rule_test(struct kuni=
t
> > *test)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 port_mask_rng_mask =3D 0x0f;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 igr_port_mask_value =3D 0xffabcd01;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 igr_port_mask_mask =3D ~0;
> > -=C2=A0=C2=A0=C2=A0=C2=A0 /* counter is written as the last operation *=
/
> > -=C2=A0=C2=A0=C2=A0=C2=A0 u32 expwriteaddr[] =3D {792, 793, 794, 795, 7=
96, 797, 792};
> > +=C2=A0=C2=A0=C2=A0=C2=A0 /* counter is written as the first operation =
*/
> > +=C2=A0=C2=A0=C2=A0=C2=A0 u32 expwriteaddr[] =3D {792, 792, 793, 794, 7=
95, 796, 797};
>=20
> So this moves 792 from the last to the first.=C2=A0 I would have expected
> that that would mean that we had to do something like this as well:
>=20
> diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> index b2753aac8ad2..4d36fad0acab 100644
> --- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> +++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> @@ -1400,7 +1400,7 @@ static void vcap_api_encode_rule_test(struct kunit
> *test)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Add rule with write callbac=
k */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D vcap_add_rule(rule);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 KUNIT_EXPECT_EQ(test, 0, ret);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 KUNIT_EXPECT_EQ(test, 792, is2_admi=
n.last_used_addr);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 KUNIT_EXPECT_EQ(test, 797, is2_admi=
n.last_used_addr);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (idx =3D 0; idx < ARRAY_SI=
ZE(expwriteaddr); ++idx)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 KUNIT_EXPECT_EQ(test, expwriteaddr[idx],
> test_updateaddr[idx]);
>=20
>=20
> But I couldn't really figure out how the .last_used_addr stuff works.
> And presumably fixing this unit test is the point of the patch...

It is just the array of addresses written to in the order that they are wri=
tten,
so for the visibility I would like to keep it as an array.

>=20
> regards,
> dan carpenter

Thanks for the comments!

BR
Steen

