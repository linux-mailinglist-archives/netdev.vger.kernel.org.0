Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B27867D5A5
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 20:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbjAZTsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 14:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbjAZTsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 14:48:21 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633D8468E;
        Thu, 26 Jan 2023 11:48:20 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id i65so1868998pfc.0;
        Thu, 26 Jan 2023 11:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fxNsjvn9+OSow4BMpRRCgV1IuRXdPftlOQFWImp71FU=;
        b=pXEWAp4u0p04Z/bibDOOfT/JD5qzG69AqxyqOVhm3zM8NR1r4aPUaySXTw7tasxW+g
         gsfHNVZaeRLAebKnwaZXRU9tlWcUjc/vFAwRmjP/ve0ua3Rm107sCRJnGBdmpX8ppjOO
         +e4mGB2Qx77s45gWuwjWnZQy35HY1ZW9363oEJ5hu3+vjtpn/IwwddzhBEp62jwv50X4
         6VMebVsQ9iboVP8UmX8DSzmYOqpaltX9UjRiQVe+IesysvOZvThr4rAb5Isntz11iqIZ
         UY1QWpkag/Pwl0zmQc017+GXiEar/dZevpleDn4TzIT4/A5tGp+4ygduJj5gv3FteNoR
         DjWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fxNsjvn9+OSow4BMpRRCgV1IuRXdPftlOQFWImp71FU=;
        b=NjXHOb72EL5rGZwNKB/uJdMklzLyvn792mB/UeT+B7WJnTk6Uhzzszls/CCtpGWjbB
         3yyrAOfKSuFDrVa0ELLM/B5BUnCGUs3XxqBlHGY2c82Blme253ZFMKI0UNjrrORVf+Yp
         ah5cX+d7azW7qtd0ClzZeE2VmBlUO73GegCEOSROse1AXc+LxNYw4VPEwbcDI4ww8DWl
         /dNBztU560QNtLkEgOlcxcOI3kwT14Inc7MCRGxnU5xOFqNFhxEnns0tbxyFs+d1FfE3
         4ODgHzRJdCAAlwoz+XHP2XkMvzcwMYIQZQ6UkYqIqgX/67XaNizM3UumG+wxj9D2Aiuc
         cPYg==
X-Gm-Message-State: AFqh2kr/7v1DmRVW8mhM8KhEeFugg2azwE5/ktTXIqhKrB2XgfKR8mFa
        MHvNjcyvR25jq8CWPHK40bIRVNDZIgZ7K1OnzWM=
X-Google-Smtp-Source: AMrXdXs6F92Uqzu2nWh932gs2OjS75Q+z4tOAIykKz0NWJNiGR17Wsdb9QCrxYFWjd3yK4Xun+52lgzSp8YMzOTqeRk=
X-Received: by 2002:a65:4d09:0:b0:4a0:8210:f47a with SMTP id
 i9-20020a654d09000000b004a08210f47amr3384198pgt.14.1674762499865; Thu, 26 Jan
 2023 11:48:19 -0800 (PST)
MIME-Version: 1.0
References: <04e27096-9ace-07eb-aa51-1663714a586d@nbd.name>
 <167475990764.1934330.11960904198087757911.stgit@localhost.localdomain> <87tu0dkt1h.fsf@toke.dk>
In-Reply-To: <87tu0dkt1h.fsf@toke.dk>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 26 Jan 2023 11:48:08 -0800
Message-ID: <CAKgT0UfsLFuCK0vQF70s=8XC8qwrzxag_NR2dCDvxqx84E0K=g@mail.gmail.com>
Subject: Re: [net PATCH] skb: Do mix page pool and page referenced frags in GRO
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     nbd@nbd.name, davem@davemloft.net, edumazet@google.com,
        hawk@kernel.org, ilias.apalodimas@linaro.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linyunsheng@huawei.com,
        lorenzo@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 11:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Alexander Duyck <alexander.duyck@gmail.com> writes:
>
> > From: Alexander Duyck <alexanderduyck@fb.com>
> >
> > GSO should not merge page pool recycled frames with standard reference
> > counted frames. Traditionally this didn't occur, at least not often.
> > However as we start looking at adding support for wireless adapters the=
re
> > becomes the potential to mix the two due to A-MSDU repartitioning frame=
s in
> > the receive path. There are possibly other places where this may have
> > occurred however I suspect they must be few and far between as we have =
not
> > seen this issue until now.
> >
> > Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in pag=
e pool")
> > Reported-by: Felix Fietkau <nbd@nbd.name>
> > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
>
> I know I'm pattern matching a bit crudely here, but we recently had
> another report where doing a get_page() on skb->head didn't seem to be
> enough; any chance they might be related?
>
> See: https://lore.kernel.org/r/Y9BfknDG0LXmruDu@JNXK7M3

Looking at it I wouldn't think so. Doing get_page() on these frames is
fine. In the case you reference it looks like get_page() is being
called on a slab allocated skb head. So somehow a slab allocated head
is leaking through.

What is causing the issue here is that after get_page() is being
called and the fragments are moved into a non-pp_recycle skb they are
then picked out and merged back into a pp_recycle skb. As a result
what is happening is that we are seeing a reference count leak from
pp_frag_count and into refcount.

This is the quick-n-dirty fix. I am debating if we want to expand this
so that we could support the case where the donor frame is pp_recycle
but the recipient is a standard reference counted frame. Fixing that
would essentially consist of having to add logic to take the reference
on all donor frags, making certain that nr_frags on the donor skb
isn't altered, and then lastly making sure that all cases use the
NAPI_GRO_FREE path to drop the page pool counts.
