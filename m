Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72F36893A3
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbjBCJ04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbjBCJ0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:26:55 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739246E89;
        Fri,  3 Feb 2023 01:26:50 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 3139PiLf773660
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Fri, 3 Feb 2023 09:25:45 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 3139PcbS1534444
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Fri, 3 Feb 2023 10:25:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1675416339; bh=VBtFXiOaxjapiMDewgSuvRBSynlE/nLpzbKpUvxzZ4U=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=T+WP/6kLczsZbbKv+POC7djUJLTqQWawcXIjaJh0dxew66z6DdtXzOluohHttOPfm
         cCcq4mR9tptxsD34OuqlIDjWHIdBy1a4MMAuBsIsL0x0laZebqITfRFj/voICcHRUH
         SIk67RuPLR+/9DRaqtUqQgkkx9xfdS6ESIzGlyJQ=
Received: (nullmailer pid 337756 invoked by uid 1000);
        Fri, 03 Feb 2023 09:25:38 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>
Subject: Re: [PATCH 8/9] net: ethernet: mtk_eth_soc: switch to external PCS
 driver
Organization: m
References: <cover.1675407169.git.daniel@makrotopia.org>
        <3bac780184867e111c3a1567d8b55658abd931da.1675407169.git.daniel@makrotopia.org>
Date:   Fri, 03 Feb 2023 10:25:38 +0100
In-Reply-To: <3bac780184867e111c3a1567d8b55658abd931da.1675407169.git.daniel@makrotopia.org>
        (Daniel Golle's message of "Fri, 3 Feb 2023 07:06:10 +0000")
Message-ID: <87357nt819.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Golle <daniel@makrotopia.org> writes:

> -		ss->pcs[i].ana_rgc3 =3D ana_rgc3;
> -		ss->pcs[i].regmap =3D syscon_node_to_regmap(np);
> -
> -		ss->pcs[i].flags =3D 0;
> +		flags =3D 0;
>  		if (of_property_read_bool(np, "pn_swap"))
> -			ss->pcs[i].flags |=3D MTK_SGMII_FLAG_PN_SWAP;
> +			flags |=3D MTK_SGMII_FLAG_PN_SWAP;
>=20=20

patch 1 added "mediatek,pn_swap" so this doesn't apply.  We've all done
last minute cleanups - never a good idea :-)


Bj=C3=B8rn
