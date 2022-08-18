Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4135988ED
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344793AbiHRQca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344789AbiHRQc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:32:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F286BD51;
        Thu, 18 Aug 2022 09:32:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA581B82218;
        Thu, 18 Aug 2022 16:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639BBC433C1;
        Thu, 18 Aug 2022 16:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660840345;
        bh=H1xICkkfCV3ifkVZeMTkF+qq1abs3AkrI/EuWefH1D4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bqzl3Q4YhBNFKeL+pZZHn09zV7Do/YjH90UAqmW2IyfAeZkKwupujJcXOCU169BHU
         bvNDpFzwRuseWaSDqHGBAkef9Ac8H2gVE+wt3VXlGwfcyh9YB2tvlUVNij9DFNWNmP
         ZMpvnvkDSSBxFlkHkPpsYpT/aAieT5c8nY+ZPkzGJ8PUq6BgrUz7Z6I9OhVqPGMA2n
         5A8QU36+mJzlJAbdwYhao3Q2tjU54TemxJY1z6iGEawsE0TIe715xLRDJS6qzb4zG6
         PyAAupK6y4DqlgzuJnzqbF4x+gvB6BqS9f2nvecKKB7epxQLDfNeJG7g4xcK8SwaUL
         lLYXwKCj98ZHQ==
Date:   Thu, 18 Aug 2022 09:32:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     "Denis V. Lunev" <den@virtuozzo.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com
Subject: Re: [PATCH -next] net: neigh: use dev_kfree_skb_irq instead of
 kfree_skb()
Message-ID: <20220818093224.2539d0bc@kernel.org>
In-Reply-To: <79784952-0d15-8a4a-aa8d-590bc243ab5e@virtuozzo.com>
References: <20220818043729.412753-1-yangyingliang@huawei.com>
        <79784952-0d15-8a4a-aa8d-590bc243ab5e@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please put [PATCH net] as the tag for v2, this is a fix, not -next
material.

On Thu, 18 Aug 2022 11:00:13 +0200 Denis V. Lunev wrote:
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long flags;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct sk_buff *skb;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct sk_buff_head tmp;

reverse xmas tree, so tmp should be declared before the shorter lines

> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 skb_queue_head_init(&tmp);
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock_irqsave(&list->lock=
, flags);
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 skb =3D skb_peek(list);
> @@ -318,12 +321,16 @@ static void pneigh_queue_purge(struct sk_buff_head=
=20
> *list, struct net *net)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 struct sk_buff *skb_next =3D skb_peek_next(skb, list);

while at it let's add an empty line here

>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (net =3D=3D NULL || net =3D=3D dev_net(skb->dev)) {
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __skb_un=
link(skb, list);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_put(skb->d=
ev);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree_skb(skb);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __skb_queue_ta=
il(&tmp, skb);
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 }
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 skb =3D skb_next;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } while (skb !=3D NULL);
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irqrestore(&list-=
>lock, flags);
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 while ((skb =3D __skb_dequeue(&tmp)=
) !=3D NULL) {

No need to compare pointers to NULL

> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 dev_put(skb->dev);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 kfree_skb(skb);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
