Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD36F5A45F2
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiH2JUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiH2JUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:20:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F9A3CBF4
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 02:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661764832; x=1693300832;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=eZ3V3hUv14+cuCD5/aPoMWuxtvDuDstVKJwZb+rD74s=;
  b=pWjreCIGQRBPzzpWP4JSSqTB2PzIqXLq16DnFkpkOE8t+rUSdLCs2bru
   ctxoSpAmq7e1Q9/Z2R5HJ65PvyFUEf/LL7qTO0jnYZ35AyvELTuzNCrDh
   gdv1H1nTJJrHhBbcArHVIWA2zGx2+Ksizp+KCEUYJ349s0wd77binqiUk
   /Y0I+592uUbMJxnJ9DamZ0GNbY0woFOVy5Um2XmxMjsNmUauIfw3A0eOK
   fjFAqioLW4VTyWz8vbzoiEkocaPtRw60IFeWIlucKoNgTlJZ8zW44NNku
   /mb3oWkLJhglWEDW9p61GO3rdU6GcrKKWN5Cx0SEWnoyfkMcGNtr0WeJ/
   g==;
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="111171101"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Aug 2022 02:20:32 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 29 Aug 2022 02:20:32 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 29 Aug 2022 02:20:30 -0700
Message-ID: <e9189f6ea1004a51d9387ed69483cebdd94f9c06.camel@microchip.com>
Subject: Re: [PATCH v2 net-next 0/3] net: sparx5: add mrouter support
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Casper Andersson <casper.casan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>
Date:   Mon, 29 Aug 2022 11:20:29 +0200
In-Reply-To: <20220825092837.907135-1-casper.casan@gmail.com>
References: <20220825092837.907135-1-casper.casan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Casper,

On Thu, 2022-08-25 at 11:28 +0200, Casper Andersson wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e content is safe
>=20
> This series adds support for multicast router ports to SparX5. To manage
> mrouter ports the driver must keep track of mdb entries. When adding an
> mrouter port the driver has to iterate over all mdb entries and modify
> them accordingly.
>=20
> v2:
> - add bailout in free_mdb
> - re-arrange mdb struct to avoid holes
> - change devm_kzalloc -> kzalloc
> - change GFP_ATOMIC -> GFP_KERNEL
> - fix spelling
>=20
> Casper Andersson (3):
> =C2=A0 ethernet: Add helpers to recognize addresses mapped to IP multicas=
t
> =C2=A0 net: sparx5: add list for mdb entries in driver
> =C2=A0 net: sparx5: add support for mrouter ports
>=20
> =C2=A0.../ethernet/microchip/sparx5/sparx5_main.c=C2=A0=C2=A0 |=C2=A0=C2=
=A0 4 +
> =C2=A0.../ethernet/microchip/sparx5/sparx5_main.h=C2=A0=C2=A0 |=C2=A0 15 =
+
> =C2=A0.../microchip/sparx5/sparx5_switchdev.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 | 271 ++++++++++++------
> =C2=A0.../ethernet/microchip/sparx5/sparx5_vlan.c=C2=A0=C2=A0 |=C2=A0=C2=
=A0 7 +
> =C2=A0include/linux/etherdevice.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=
=A0 22 ++
> =C2=A05 files changed, 232 insertions(+), 87 deletions(-)
>=20
> --
> 2.34.1
>=20

For this series:

Reviewed-by: Steen Hegelund <Steen.Hegelund@microchip.com>

BR
Steen
