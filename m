Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6372465E92A
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 11:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbjAEKn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 05:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjAEKnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 05:43:23 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE84395E2;
        Thu,  5 Jan 2023 02:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672915401; x=1704451401;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=D09wia/xBIh5VPDEISOZsQ1nVpd1S2d7Q+SDHIXy+OU=;
  b=DTcinu5dXraAtwKpje0KKhTnOeVg/Z1/A47l/+T7Tt9usKSsiQmG5/pi
   SJ9Pi5Dno/NuPeioEU4CjkgDBBGcVwZiqnyQ7ndoZNDQ2tPllSBrfrS7v
   hWxFMg6xcWurWGWnUInGq8cs+iKsAGzKvz12YzeyKd50fnkUnXWmJJsig
   1+EZElyv4HQZPC7k+KlWnz2IB0cCiJFYtPFBHhKUgcPYFNyqr1kBD0zgl
   WH2dv2k681itZfdTPppF0/hf/cJg9HbaMfKGZAg7XanggmGkC5YIynhhH
   UrhMes/fCVCtem2lC2X/Unpkj0fZrN1WepdM+RO3J/6neEqxbylZbI1IT
   w==;
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="206513514"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jan 2023 03:43:21 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 03:43:20 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 5 Jan 2023 03:43:17 -0700
Message-ID: <7fa8ea30beffcb9256422f7a474a8be7d5791f5a.camel@microchip.com>
Subject: Re: [PATCH net-next 2/8] net: microchip: sparx5: Reset VCAP counter
 for new rules
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
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Thu, 5 Jan 2023 11:43:17 +0100
In-Reply-To: <Y7aT8xGOCfvC/U0a@kadam>
References: <20230105081335.1261636-1-steen.hegelund@microchip.com>
         <20230105081335.1261636-3-steen.hegelund@microchip.com>
         <Y7aT8xGOCfvC/U0a@kadam>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 
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

On Thu, 2023-01-05 at 12:10 +0300, Dan Carpenter wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Thu, Jan 05, 2023 at 09:13:29AM +0100, Steen Hegelund wrote:
> > When a rule counter is external to the VCAP such as the Sparx5 IS2 coun=
ters
> > are, then this counter must be reset when a new rule is created.
> >=20
> > Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> > ---
> > =C2=A0drivers/net/ethernet/microchip/vcap/vcap_api.c=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 3 +++
> > =C2=A0drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c | 4 ++--
> > =C2=A02 files changed, 5 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > index b9b6432f4094..67e0a3d9103a 100644
> > --- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > +++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > @@ -1808,6 +1808,7 @@ int vcap_add_rule(struct vcap_rule *rule)
> > =C2=A0{
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct vcap_rule_internal *ri =3D to_int=
rule(rule);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct vcap_rule_move move =3D {0};
> > +=C2=A0=C2=A0=C2=A0=C2=A0 struct vcap_counter ctr =3D {0};
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D vcap_api_check(ri->vctrl);
> > @@ -1833,6 +1834,8 @@ int vcap_add_rule(struct vcap_rule *rule)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D vcap_write_rule(ri);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 pr_err("%s:%d: rule write error: %d\n", __func__, __LINE__,
> > ret);
> > +=C2=A0=C2=A0=C2=A0=C2=A0 /* Set the counter to zero */
> > +=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D vcap_write_counter(ri, &ctr);
> > =C2=A0out:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_unlock(&ri->admin->lock);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>=20
> I feel like you intended to send a v2 series but accidentally resent
> the v1 series.=C2=A0 Otherwise I guess I have the same question as before=
.

This series was first sent to net, but the response was that I should go in=
to
net-next instead, so it is really a first version in net-next.

What was your question?  I was not able to find it...

BR
Steen

>=20
> regards,
> dan carpenter
>=20

