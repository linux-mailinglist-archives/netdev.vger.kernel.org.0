Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54838694B90
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjBMPrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjBMPrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:47:09 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7825193F5;
        Mon, 13 Feb 2023 07:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676303229; x=1707839229;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=26zBXs9U0xIVIcE1270XHPcpO39gO3jje/xpCU6DrnM=;
  b=TX+kXeRcwGyt2OnPArLm7Kb2DwLJ8yq3PHBwJUGrbi1rdhHab0p9VU9P
   5yfR7qnRMe3SCZuTBq7LB7hMd1SN/WgQqXcMsbMsficuzCv5dhJkC8Fnp
   K7l4zcVPAiiGM9xJaJ/84tPAU7YZ8n7uU3WLm9wcD9OlOzbkFLmEhuq2D
   BGhR0TF6OeMPcmLajdZdJFwdfeHX2I/yurUkP6YgReQm9I+7PlPsn4t7x
   SSQ8BiV2jLL+lteDU4YlPx2KWwA5wHK8RR+kNW/xpaD8DaoLDZlCVoHFm
   rbz67QM+2U85zEeuoETKhBtgK8Pr051+raVizP21QucNIPSuLSp+Gmv2i
   A==;
X-IronPort-AV: E=Sophos;i="5.97,294,1669100400"; 
   d="scan'208";a="196669922"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Feb 2023 08:47:06 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 08:47:03 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 08:46:59 -0700
Message-ID: <1c317ed5e3f70b403206e6fdb181c1d0573e8b17.camel@microchip.com>
Subject: Re: [PATCH net-next 04/10] net: microchip: sparx5: Use chain ids
 without offsets when enabling rules
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
Date:   Mon, 13 Feb 2023 16:46:59 +0100
In-Reply-To: <Y+pTlf+2o0mVEErX@kadam>
References: <20230213092426.1331379-1-steen.hegelund@microchip.com>
         <20230213092426.1331379-5-steen.hegelund@microchip.com>
         <Y+oZjg8EkKp46V9Z@kadam>
         <b755fa1c818639a1e7c11ab3b2ac56443757ac3c.camel@microchip.com>
         <Y+pSKQdcpMw3YGvh@kadam> <Y+pTlf+2o0mVEErX@kadam>
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

On Mon, 2023-02-13 at 18:13 +0300, Dan Carpenter wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Mon, Feb 13, 2023 at 06:07:21PM +0300, Dan Carpenter wrote:
> > On Mon, Feb 13, 2023 at 01:48:50PM +0100, Steen Hegelund wrote:
> > > Hi Dan,
> > >=20
> > > On Mon, 2023-02-13 at 14:05 +0300, Dan Carpenter wrote:
> > > > EXTERNAL EMAIL: Do not click links or open attachments unless you k=
now
> > > > the
> > > > content is safe
> > > >=20
> > > > On Mon, Feb 13, 2023 at 10:24:20AM +0100, Steen Hegelund wrote:
> > > > > diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > > > > b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > > > > index 68e04d47f6fd..9ca0cb855c3c 100644
> > > > > --- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > > > > +++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > > > > @@ -1568,6 +1568,18 @@ static int vcap_write_counter(struct
> > > > > vcap_rule_internal *ri,
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> > > > > =C2=A0}
> > > > >=20
> > > > > +/* Return the chain id rounded down to nearest lookup */
> > > > > +static int vcap_round_down_chain(int cid)
> > > > > +{
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0 return cid - (cid % VCAP_CID_LOOKUP_SIZ=
E);
> > > > > +}
> > > > > +
> > > > > +/* Return the chain id rounded up to nearest lookup */
> > > > > +static int vcap_round_up_chain(int cid)
> > > > > +{
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0 return vcap_round_down_chain(cid + VCAP=
_CID_LOOKUP_SIZE);
> > > >=20
> > > > Just use the round_up/down() macros.
> > >=20
> > > The only round up/down macros that I am aware of are:
> > >=20
> > > =C2=A0* round_up - round up to next specified power of 2
> > > =C2=A0* round_down - round down to next specified power of 2
> > >=20
> > > And I cannot use these as the VCAP_CID_LOOKUP_SIZE is not a power of =
2.
> > >=20
> > > Did I miss something here?
> > >=20
> >=20
> > Oh wow.=C2=A0 I didn't realize they needed to be a power of 2.=C2=A0 So=
rry!
>=20
> The correct macros are roundup/down().=C2=A0 Those don't have the power o=
f
> two requirement.

Yep - You are right, these are a bit further down in the math.h file, and I
never noticed them before :-)

I will update my code to use these instead.

>=20
> regards,
> dan carpenter
>=20

Thanks for the investigation!

BR
Steen
