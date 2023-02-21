Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDD569E012
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 13:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbjBUMQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 07:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbjBUMQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 07:16:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9692C265BC
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676981703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZEuOkrsozFdoPORVuJE/m8NTeHtX1hbGyE+AebQNhhw=;
        b=YkGEgCd3WMb/x3KzEXnjFkITbE94XdW3dN3zB93LQAfOe5woGmcvVVKz8mgFmQiaiLDZhr
        YsM+tfSFEwHDYNoq1oNnyppNWxcPq7XDgfNQ3tpQpEGh+6Ywq6Mle8Jglg6pPztT81HGre
        RqFShIszS/u8fYNRKf15C7hfCp6RQts=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-633-ihxMh8CZP02WTR2T4CsbaA-1; Tue, 21 Feb 2023 07:01:13 -0500
X-MC-Unique: ihxMh8CZP02WTR2T4CsbaA-1
Received: by mail-wm1-f72.google.com with SMTP id n3-20020a05600c3b8300b003dc5dec2ac6so1964195wms.4
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:01:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676980872;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZEuOkrsozFdoPORVuJE/m8NTeHtX1hbGyE+AebQNhhw=;
        b=0UmEDKwUhu2uXSGFQtXVlaHkm2CZVJZdhlRFBuAHb/NiF+PB5eNdCAyT6iHTvSiUz+
         FiGrPjZ+12h8Y442Gz83D1DZVCApxMZSOaOBpqsCH7Sfzp9+bq0GSCvSX7qBP4IdtD6g
         yh82CP4ylH2AUOWVbxv4hAOlmm9CELIfs7DnMlajjs+N4qPsSuvJCdZhRM12K4PB6TAY
         yIrYUACAssv/j8sOEGj04D3Hzu6fHf6tn99s1DtLABvZNBaVmi8cIFw7jYzFXwDp/q7H
         du2ReDnppfa49lbxMD3DjMnZ2W+AxofkQd/4GG72koFJrzL4FRTHRezvvdeFaudoxml6
         3Qeg==
X-Gm-Message-State: AO0yUKUVehrAReZtmNL+UBH8cneRLBY8iiC034CJWDMyK3d8WqnG7vNp
        WrRfO1NVZ/+6ykMeMYfJqr3pqx/cE7ELGZno2tacYfqNr0E5M6K2EDl87xNs7ctggNYq+OytQNa
        +LriUCBxMLErn1Eag
X-Received: by 2002:a7b:c842:0:b0:3db:2063:425e with SMTP id c2-20020a7bc842000000b003db2063425emr4040503wml.1.1676980872505;
        Tue, 21 Feb 2023 04:01:12 -0800 (PST)
X-Google-Smtp-Source: AK7set8PaVDhgVo1lgR0da8lUdHjH25R3LyU28rdPMhylHxaJZIJiB/EWk7MyM/lSUZca+9Qs3BwKw==
X-Received: by 2002:a7b:c842:0:b0:3db:2063:425e with SMTP id c2-20020a7bc842000000b003db2063425emr4040459wml.1.1676980872120;
        Tue, 21 Feb 2023 04:01:12 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id b3-20020a05600010c300b002c57475c375sm6910399wrx.110.2023.02.21.04.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 04:01:11 -0800 (PST)
Message-ID: <d5ea4ad402f78e538a2566e0109b8216af32edbf.camel@redhat.com>
Subject: Re: [PATCH net-next v4 0/3] net: dsa: rzn1-a5psw: add support for
 vlan and .port_bridge_flags
From:   Paolo Abeni <pabeni@redhat.com>
To:     =?ISO-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?ISO-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 21 Feb 2023 13:01:09 +0100
In-Reply-To: <20230221092626.57019-1-clement.leger@bootlin.com>
References: <20230221092626.57019-1-clement.leger@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-02-21 at 10:26 +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> While adding support for VLAN, bridge_vlan_unaware.sh and
> bridge_vlan_aware.sh were executed and requires .port_bridge_flags
> to disable flooding on some specific port. Thus, this series adds
> both vlan support and .port_bridge_flags.
>=20
> ----
> V4:
>  - Fix missing CPU port bit in a5psw->bridged_ports
>  - Use unsigned int for vlan_res_id parameters
>  - Rename a5psw_get_vlan_res_entry() to a5psw_new_vlan_res_entry()
>  - In a5psw_port_vlan_add(), return -ENOSPC when no VLAN entry is found
>  - In a5psw_port_vlan_filtering(), compute "val" from "mask"
>=20
> V3:
>  - Target net-next tree and correct version...
>=20
> V2:
>  - Fixed a few formatting errors
>  - Add .port_bridge_flags implementation
>=20
> Cl=C3=A9ment L=C3=A9ger (3):
>   net: dsa: rzn1-a5psw: use a5psw_reg_rmw() to modify flooding
>     resolution
>   net: dsa: rzn1-a5psw: add support for .port_bridge_flags
>   net: dsa: rzn1-a5psw: add vlan support
>=20
>  drivers/net/dsa/rzn1_a5psw.c | 223 ++++++++++++++++++++++++++++++++++-
>  drivers/net/dsa/rzn1_a5psw.h |   8 +-
>  2 files changed, 222 insertions(+), 9 deletions(-)

# Form letter - net-next is closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after Mar 6th.

RFC patches sent for review only are obviously welcome at any time.

