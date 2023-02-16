Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55493698F56
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 10:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjBPJH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 04:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjBPJH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 04:07:56 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7302172A1;
        Thu, 16 Feb 2023 01:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676538475; x=1708074475;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=TByefcgb7dGsmhJUccqjfaaVch5b5YjDrVsfrUQGnFQ=;
  b=XsLQK6swR6ME/5hm2OCSgg5CTyq1zkFi+HLdwBhyS0qH+4rGPLKR7axh
   iexYQd27OBI7SHH6Zc7rDSPFa88kDE6kkanVNrgsD+MuEABflqr37OpSB
   fQXzxr8K0oyJue639KMfBtfi1Oz0HlGpAqXGVEwCquef559DvmGEy87XF
   FqLcuaR83N3XncplACaq+ezH0+GONGeWMFPlW7zgFONjY3qsPU8tUp/vK
   md0C6+ILWF8n8eQqvB8p0yFiJt+uPBdeYUF/xCOw6k485iIbl0KSJOy2l
   5tCVC8BYvbDOx4+VET5GBqI1KUJOUVLEPXCGsNq111n7PCh4xB1nji2nK
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,302,1669100400"; 
   d="scan'208";a="197256266"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2023 02:07:53 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 02:07:52 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 02:07:49 -0700
Message-ID: <e3ab2825bcb0ae93fd26a35dcaee91224ecadc0b.camel@microchip.com>
Subject: Re: [PATCH net-next v2 06/10] net: microchip: sparx5: Add ES0 VCAP
 model and updated KUNIT VCAP model
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Dan Carpenter <error27@gmail.com>,
        Michael Walle <michael@walle.cc>
Date:   Thu, 16 Feb 2023 10:07:48 +0100
In-Reply-To: <0b639b4294ffa61776756d33fc345e60a576d0ec.camel@redhat.com>
References: <20230214104049.1553059-1-steen.hegelund@microchip.com>
         <20230214104049.1553059-7-steen.hegelund@microchip.com>
         <0b639b4294ffa61776756d33fc345e60a576d0ec.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 
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

Hi Paolo,

On Thu, 2023-02-16 at 09:09 +0100, Paolo Abeni wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Tue, 2023-02-14 at 11:40 +0100, Steen Hegelund wrote:
> > This provides the VCAP model for the Sparx5 ES0 (Egress Stage 0) VCAP.
> >=20
> > This VCAP provides rewriting functionality in the egress path.
> >=20
> > Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> > ---
> > =C2=A0.../microchip/sparx5/sparx5_vcap_ag_api.c=C2=A0=C2=A0=C2=A0=C2=A0=
 | 385 +++++++++++++++++-
> > =C2=A0.../net/ethernet/microchip/vcap/vcap_ag_api.h | 174 +++++++-
> > =C2=A0.../microchip/vcap/vcap_api_debugfs_kunit.c=C2=A0=C2=A0 |=C2=A0=
=C2=A0 4 +-
> > =C2=A0.../microchip/vcap/vcap_model_kunit.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 270 +++++++-----
> > =C2=A0.../microchip/vcap/vcap_model_kunit.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 10 +-
> > =C2=A05 files changed, 721 insertions(+), 122 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c
> > b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c
> > index 561001ee0516..556d6ea0acd1 100644
> > --- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c
> > +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c
> > @@ -3,8 +3,8 @@
> > =C2=A0 * Microchip VCAP API
> > =C2=A0 */
> >=20
> > -/* This file is autogenerated by cml-utils 2023-01-17 16:55:38 +0100.
> > - * Commit ID: cc027a9bd71002aebf074df5ad8584fe1545e05e
> > +/* This file is autogenerated by cml-utils 2023-02-10 11:15:56 +0100.
> > + * Commit ID: c30fb4bf0281cd4a7133bdab6682f9e43c872ada
> > =C2=A0 */
>=20
> If the following has been already discussed, I'm sorry for the
> duplicates, I missed the relevant thread.
>=20
> Since this drivers contains quite a bit of auto-generated code, I'm
> wondering if you could share the tool and/or the source file, too. That
> would make reviews more accurate.

So far we have not made the tool (CML-Utils) available online, but it is
included as zip archive in our quarterly BSP releases which are available o=
n
AWS.

The BSP uses it (via Buildroot) to generate register access header files an=
d
VCAP models as well as compiling various test tools that are added to the
rootfs.

It is not because we want CML-Utils to be secret that it is not online, but
rather that we want to be free to update/change/remove features as needed
without breaking any build processes that might have been relying on these
features with our customers.

I would expect that CML-Utils will eventually have its own public repo, but=
 it
is probably a little too early yet.=20

>=20
> Thanks,
>=20
> Paolo
>=20

BR
Steen
