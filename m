Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF87867A498
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 22:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbjAXVK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 16:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjAXVK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 16:10:28 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DBB2A17F;
        Tue, 24 Jan 2023 13:10:27 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id jl3so15992802plb.8;
        Tue, 24 Jan 2023 13:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1D8ZEDoIZB8YyudSb7sCblWlbH8KH7zzZSAuZ0TbhG4=;
        b=BpONE3z8mbmm1aQQvEtExx1FMMReeNk6YUzVIylNelNMi86MtTU9lCO7tC0gaPRGdr
         BIuLzlZWCuZU+7htTW0xk7UGuzfRY+uMD0Iw5N0KLrUHekTEZyAwAuedJs4YO5GxLvr/
         9ELIYqPFdCYsTnsrs1U7bK6+FVVvvfYwLvU/vKlWKkn4UPAxqmEJiqqMSZ20Dkahraxc
         nOhctSmzuRF8xxgzuRk8UiMZmoZLBJO08lNX9tlSgqizsBAt+L6+GsBypBnKmFrY5C6W
         7aEZT7MEScaxN3DoYtBAoZYhccJQRGNnI3gfE0HiCJidnGLkqOhrFTVfCpMsHtsMX9uK
         a6ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1D8ZEDoIZB8YyudSb7sCblWlbH8KH7zzZSAuZ0TbhG4=;
        b=cBGuFt/kTZTVtZlCGilYgr9dwBWQPFnFtkWKW1nk4mhpwxyITIi5DR1SY3VH3yUHJL
         0kzNJaJSihlg9RZkbvYB99BH3PZBIOXrUuvDEt74+HJ/KaHnp+Z3NjURXapyIfD9bhre
         czrms2eFzO5aICU7QTTzgHGv3jiBY8HgHjPt8jwkeGfBAaANyvB5IZWAsgHVmS3Qz8j9
         55UZpH3uZNy2mn3QVL0pw7X7N+kqqIgXqglK9SG8Ou4fwwodDb9mIxSF/AeTOlxgL5pK
         D8pc2zXzIhgsZJtaKT1AASDLULQTIPea6trMyqBudMqyCVePgZ4+5SuVd64LDfU0Hljd
         qKVQ==
X-Gm-Message-State: AO0yUKUQFulKXNVzOM1PLwoqahkbmy37Xsp5ccldR/6A7lJkwiazMisb
        X0LEDzfNL1PSJ+PfiWbuSKg=
X-Google-Smtp-Source: AK7set+RLKhhwMxUNZ0I/NY+kzk+/Gc6YxaBajQ0l0Qc6GeBVNhthZ39fHMTWZakwqmFnAWzNw4n6Q==
X-Received: by 2002:a17:903:1245:b0:196:f00:c8f9 with SMTP id u5-20020a170903124500b001960f00c8f9mr5993858plh.10.1674594626486;
        Tue, 24 Jan 2023 13:10:26 -0800 (PST)
Received: from [192.168.0.128] ([98.97.116.5])
        by smtp.googlemail.com with ESMTPSA id m4-20020a170902768400b00194ab9a4fecsm2112330pll.138.2023.01.24.13.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 13:10:25 -0800 (PST)
Message-ID: <cd35316065cfe8d706ca2730babe3e6519df6034.camel@gmail.com>
Subject: Re: [PATCH] net: page_pool: fix refcounting issues with fragmented
 allocation
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>
Date:   Tue, 24 Jan 2023 13:10:24 -0800
In-Reply-To: <19121deb-368f-9786-8700-f1c45d227a4c@nbd.name>
References: <20230124124300.94886-1-nbd@nbd.name>
         <CAC_iWjKAEgUB8Z3WNNVgUK8omXD+nwt_VPSVyFn1i4EQzJadog@mail.gmail.com>
         <19121deb-368f-9786-8700-f1c45d227a4c@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-01-24 at 18:22 +0100, Felix Fietkau wrote:
> On 24.01.23 15:11, Ilias Apalodimas wrote:
> > Hi Felix,
> >=20
> > ++cc Alexander and Yunsheng.
> >=20
> > Thanks for the report
> >=20
> > On Tue, 24 Jan 2023 at 14:43, Felix Fietkau <nbd@nbd.name> wrote:
> > >=20
> > > While testing fragmented page_pool allocation in the mt76 driver, I w=
as able
> > > to reliably trigger page refcount underflow issues, which did not occ=
ur with
> > > full-page page_pool allocation.
> > > It appears to me, that handling refcounting in two separate counters
> > > (page->pp_frag_count and page refcount) is racy when page refcount ge=
ts
> > > incremented by code dealing with skb fragments directly, and
> > > page_pool_return_skb_page is called multiple times for the same fragm=
ent.
> > >=20
> > > Dropping page->pp_frag_count and relying entirely on the page refcoun=
t makes
> > > these underflow issues and crashes go away.
> > >=20
> >=20
> > This has been discussed here [1].  TL;DR changing this to page
> > refcount might blow up in other colorful ways.  Can we look closer and
> > figure out why the underflow happens?
> I don't see how the approch taken in my patch would blow up. From what I=
=20
> can tell, it should be fairly close to how refcount is handled in=20
> page_frag_alloc. The main improvement it adds is to prevent it from=20
> blowing up if pool-allocated fragments get shared across multiple skbs=
=20
> with corresponding get_page and page_pool_return_skb_page calls.
>=20
> - Felix
>=20

Do you have the patch available to review as an RFC? From what I am
seeing it looks like you are underrunning on the pp_frag_count itself.
I would suspect the issue to be something like starting with a bad
count in terms of the total number of references, or deducing the wrong
amount when you finally free the page assuming you are tracking your
frag count using a non-atomic value in the driver.

Thanks,

- Alex
