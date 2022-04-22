Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCDEC50BAD8
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 16:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448650AbiDVO6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 10:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449026AbiDVO6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 10:58:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2B86461
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 07:55:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DFABB83076
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3355C385A0;
        Fri, 22 Apr 2022 14:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650639304;
        bh=WvGXYxh5DWdQ4KtteGEWx8/2trBxXAHe+taf2ZduHSo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wt5Jngh5fgPN3HE1MZWUZCENcCujRC2HZMbJXE2Q/sNstHe4h/V+rwPnJi8uMVi6B
         gDMz4Ok9txK3Y5guzpbPGKf7JVMx9laJLLB+Pa1pu2spb/w0B8kjRjWNYk+vSv8olu
         J9MMGeFGPUSbuRdkN3+jfughDl2OFO5zXq4npcWPoYFrRXYGL3YKrCKSFFYpJ48J4N
         Igmqw8nTiBExi1LhlB/s44Yblahzd1+m9TOoSWcXT35S0UUKkqp9K3VhkDJpKfgJTf
         MrdLHX4YQnY28PyfFtqgWaJBW3nS2Dw9LmQitbv1NzTLUTMnfR1lErzadLLR03DJE9
         /BmQ7qHthQFcw==
Date:   Fri, 22 Apr 2022 07:55:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Ilya Lesokhin <ilyal@mellanox.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] tls: Skip tls_append_frag on zero copy size
Message-ID: <20220422075502.27532722@kernel.org>
In-Reply-To: <da984a08-1730-1b0c-d845-cf7ec732ba4c@nvidia.com>
References: <20220413134956.3258530-1-maximmi@nvidia.com>
        <20220414122808.09f31bfe@kernel.org>
        <3c90d3cd-5224-4224-e9d9-e45546ce51c6@nvidia.com>
        <da984a08-1730-1b0c-d845-cf7ec732ba4c@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Apr 2022 12:47:18 +0300 Maxim Mikityanskiy wrote:
> On 2022-04-18 17:56, Maxim Mikityanskiy wrote:
> > On 2022-04-14 13:28, Jakub Kicinski wrote: =20
> >> I appreciate you're likely trying to keep the fix minimal but Greg
> >> always says "fix it right, worry about backports later".
> >>
> >> I think we should skip more, we can reorder the mins and if
> >> min(size, rec space) =3D=3D 0 then we can skip the allocation as well.=
 =20
> >=20
> > Sorry, I didn't get the idea. Could you elaborate?
> >=20
> > Reordering the mins:
> >=20
> > copy =3D min_t(size_t, size, max_open_record_len - record->len);
> > copy =3D min_t(size_t, copy, pfrag->size - pfrag->offset);
> >=20
> > I assume by skipping the allocation you mean skipping=20
> > tls_do_allocation(), right? Do you suggest to skip it if the result of=
=20
> > the first min_t() is 0?
> >=20
> > record->len used in the first min_t() comes from ctx->open_record, whic=
h=20
> > either exists or is allocated by tls_do_allocation(). If we move the=20
> > copy =3D=3D 0 check above the tls_do_allocation() call, first we'll hav=
e to=20
> > check whether ctx->open_record is NULL, which is currently checked by=20
> > tls_do_allocation() itself.
> >=20
> > If open_record is not NULL, there isn't much to skip in=20
> > tls_do_allocation on copy =3D=3D 0, the main part is already skipped,=20
> > regardless of the value of copy. If open_record is NULL, we can't skip=
=20
> > tls_do_allocation, and copy won't be 0 afterwards.
> >=20
> > To compare, before (pseudocode):
> >=20
> > tls_do_allocation {
> >  =C2=A0=C2=A0=C2=A0 if (!ctx->open_record)
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ALLOCATE RECORD
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Now ctx->open_record is not=
 NULL
> >  =C2=A0=C2=A0=C2=A0 if (!sk_page_frag_refill(sk, pfrag))
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOMEM
> > }
> > handle errors from tls_do_allocation
> > copy =3D min(size, pfrag->size - pfrag->offset)
> > copy =3D min(copy, max_open_record_len - ctx->open_record->len)
> > if (copy)
> >  =C2=A0=C2=A0=C2=A0 copy data and append frag
> >=20
> > After:
> >=20
> > if (ctx->open_record) {
> >  =C2=A0=C2=A0=C2=A0 copy =3D min(size, max_open_record_len - ctx->open_=
record->len)
> >  =C2=A0=C2=A0=C2=A0 if (copy) {
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 // You want to put this par=
t of tls_do_allocation under if (copy)?
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!sk_page_frag_refill(sk=
, pfrag))
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 han=
dle errors
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 copy =3D min(copy, pfrag->s=
ize - pfrag->offset)
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (copy)
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cop=
y data and append frag
> >  =C2=A0=C2=A0=C2=A0 }
> > } else {
> >  =C2=A0=C2=A0=C2=A0 ALLOCATE RECORD
> >  =C2=A0=C2=A0=C2=A0 if (!sk_page_frag_refill(sk, pfrag))
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 handle errors
> >  =C2=A0=C2=A0=C2=A0 // Have to do this after the allocation anyway.
> >  =C2=A0=C2=A0=C2=A0 copy =3D min(size, max_open_record_len - ctx->open_=
record->len)
> >  =C2=A0=C2=A0=C2=A0 copy =3D min(copy, pfrag->size - pfrag->offset)
> >  =C2=A0=C2=A0=C2=A0 if (copy)
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 copy data and append frag
> > }
> >=20
> > Either I totally don't get what you suggested, or it doesn't make sense=
=20
> > to me, because we have +1 branch in the common path when a record is=20
> > open and copy is not 0, no changes when there is no record, and more=20
> > repeating code hard to compress.
> >=20
> > If I missed your idea, please explain in more details. =20
>=20
> Jakub, is your comment still relevant after my response? If not, can the=
=20
> patch be merged?

I'd prefer if you refactored the code so tls_push_data() looks more
natural. But the patch is correct so if you don't want to you can
repost.

Sorry for the delay.
