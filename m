Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A45036D2E25
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 06:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbjDAEZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 00:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjDAEZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 00:25:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B60E1DFB1;
        Fri, 31 Mar 2023 21:25:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BB6A6190D;
        Sat,  1 Apr 2023 04:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236DDC433EF;
        Sat,  1 Apr 2023 04:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680323115;
        bh=rhQMdQ3loA1jFhJxJX38tMeXfbzlLIFjCjXfge58ZhU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oq5blUMgfIcgfRWn8LsZJ4qNCplw+HmdW6UTG1ORC3xp8aac4WT1nBXjQpWIiO+F8
         mXGiQiFTyYi4EhFgjeGgcZh1/8o2N88Ou2HGNG6pzhqR9+YX9Uk27RhGyT1kHKobFC
         WzcZu0yrG+2yeIVtGocwuZNX1dshsFaWRv0NTZAYgVJ2wUkg3QxiXlJdSh+yiOuzXH
         l8DFhDzRhbTCI1fUmoqAtTPg3V4Ok4YpSvB0jR+iEJrRKkE3JQ+vCAInNMnBRljR1T
         AfX7z68QufWpFMayvl2PKaIKbUVyamyuXWPAAmGrSFvRCx7gR/b5IgsA9ytRN/1YXz
         w9GGuYZ/IQUDw==
Date:   Fri, 31 Mar 2023 21:25:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix =?UTF-8?B?SMO8dHRuZXI=?= <felix.huettner@mail.schwarz>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luca Czesla <Luca.Czesla@mail.schwarz>
Subject: Re: [PATCH] net: openvswitch: fix race on port output
Message-ID: <20230331212514.7a9ee3d9@kernel.org>
In-Reply-To: <DU0PR10MB5244A38E7712028763169A93EA8F9@DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM>
References: <DU0PR10MB5244A38E7712028763169A93EA8F9@DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 06:25:13 +0000 Felix H=C3=BCttner wrote:
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 253584777101..6628323b7bea 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3199,6 +3199,7 @@ static u16 skb_tx_hash(const struct net_device *dev,
>         }
>=20
>         if (skb_rx_queue_recorded(skb)) {
> +               BUG_ON(unlikely(qcount =3D=3D 0));

DEBUG_NET_WARN_ON()

>                 hash =3D skb_get_rx_queue(skb);
>                 if (hash >=3D qoffset)
>                         hash -=3D qoffset;
> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> index ca3ebfdb3023..33b317e5f9a5 100644
> --- a/net/openvswitch/actions.c
> +++ b/net/openvswitch/actions.c
> @@ -913,7 +913,7 @@ static void do_output(struct datapath *dp, struct sk_=
buff *skb, int out_port,
>  {
>         struct vport *vport =3D ovs_vport_rcu(dp, out_port);
>=20
> -       if (likely(vport)) {
> +       if (likely(vport && vport->dev->reg_state =3D=3D NETREG_REGISTERE=
D)) {

Without looking too closely netif_carrier_ok() seems like a more
appropriate check for liveness on the datapath?

>                 u16 mru =3D OVS_CB(skb)->mru;
>                 u32 cutlen =3D OVS_CB(skb)->cutlen;
>=20
> --
> 2.40.0
>=20
> Diese E Mail enth=C3=A4lt m=C3=B6glicherweise vertrauliche Inhalte und is=
t nur f=C3=BCr die Verwertung durch den vorgesehenen Empf=C3=A4nger bestimm=
t. Sollten Sie nicht der vorgesehene Empf=C3=A4nger sein, setzen Sie den Ab=
sender bitte unverz=C3=BCglich in Kenntnis und l=C3=B6schen diese E Mail. H=
inweise zum Datenschutz finden Sie hier<https://www.datenschutz.schwarz>.

You gotta get rid of this to work upstream.
