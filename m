Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0755679E11
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 16:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbjAXP5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 10:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbjAXP5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 10:57:39 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7264A1FF;
        Tue, 24 Jan 2023 07:57:38 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id jm10so15091519plb.13;
        Tue, 24 Jan 2023 07:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hqolBxXCNuOBmobd0DkrzxBEkxNCJTU7jxiH5MLZ5rw=;
        b=VF7hIVFm9tEJXxqAAb0rT9WiklBsCz88lSzN/0M+/jCBVz+OddZ6zSXuzXjPF1/Iiz
         JRgnR9Cfjd+dCpQJWHo5dXLjNAVtGVTDmeVKTdr7eiBWa+dm4XreQsETmoLM+aEy/g6d
         udi2YadJqdKylNnYxEsV0apiMAzgE0qJeNG23GnoIKCa0Ly9azN/GS2IWSe4LT6X6568
         wDNtxMw98ByheGDBbdlU45EZYgDRc0MJozQmF5Ww7AuD2rc3fX2ZZLhWnyq4fOcMe6L3
         o3f5sIx+5s84l9UPQqQDbqBMY9GRLNz0pae5fUEM4oH4RcoBe+q3dc9wz7tGly0W1aWa
         8s+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hqolBxXCNuOBmobd0DkrzxBEkxNCJTU7jxiH5MLZ5rw=;
        b=q/iJP0/ADwDVD6wbldhnJQ0B9An639UHbWSCmqjCfH2PXWzG5htzH0MSSBGFZZskpm
         82+YdszLkdC3JkCGwkii6J9AmuYLq60lwwVhwNza06G4XVPcP1EUupbOfzez84R0AZvM
         6QjfGMtaUr5vUGqELk4CAIk8bnbg8q5gFG9dbqOdhreBTtTTx6dyLPTS7XctFHiveqKi
         E31TQGn46hYCH5kDzrT2VecvYD4Y93KM1U9heqJp+vPONna+M6+9yn+wNi8CnNYZTcQo
         t9vizaA1LY7akFoMsQ88GF27vvRS4n4dg7qAx1+67aZ22PC5dJWrNdAU7sep+7jKfobe
         ABaQ==
X-Gm-Message-State: AO0yUKUt82IjO/s/8IE0NPSAvI3waNWGd89qNNFAu+axklzDC6VY+ebW
        MMZGYuUANnYzbW1w1q1wYQhQ0s0EDhs=
X-Google-Smtp-Source: AK7set/kfxCTTixwnKqQQKv0TFk9Ak4D/IsCJdHqSVJy+e6AyuWjQDmIdKoIa3+JnmnpLKV3A+QV/Q==
X-Received: by 2002:a17:90a:191c:b0:22b:e71b:1fde with SMTP id 28-20020a17090a191c00b0022be71b1fdemr3822120pjg.15.1674575857534;
        Tue, 24 Jan 2023 07:57:37 -0800 (PST)
Received: from [192.168.0.128] ([98.97.116.5])
        by smtp.googlemail.com with ESMTPSA id b26-20020a63931a000000b00478e7f87f3bsm1609790pge.67.2023.01.24.07.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 07:57:36 -0800 (PST)
Message-ID: <f3d079ce930895475f307de3fdaed0b85b4f2671.camel@gmail.com>
Subject: Re: [PATCH] net: page_pool: fix refcounting issues with fragmented
 allocation
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>
Date:   Tue, 24 Jan 2023 07:57:35 -0800
In-Reply-To: <CAC_iWjKAEgUB8Z3WNNVgUK8omXD+nwt_VPSVyFn1i4EQzJadog@mail.gmail.com>
References: <20230124124300.94886-1-nbd@nbd.name>
         <CAC_iWjKAEgUB8Z3WNNVgUK8omXD+nwt_VPSVyFn1i4EQzJadog@mail.gmail.com>
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

On Tue, 2023-01-24 at 16:11 +0200, Ilias Apalodimas wrote:
> Hi Felix,
>=20
> ++cc Alexander and Yunsheng.
>=20
> Thanks for the report
>=20
> On Tue, 24 Jan 2023 at 14:43, Felix Fietkau <nbd@nbd.name> wrote:
> >=20
> > While testing fragmented page_pool allocation in the mt76 driver, I was=
 able
> > to reliably trigger page refcount underflow issues, which did not occur=
 with
> > full-page page_pool allocation.
> > It appears to me, that handling refcounting in two separate counters
> > (page->pp_frag_count and page refcount) is racy when page refcount gets
> > incremented by code dealing with skb fragments directly, and
> > page_pool_return_skb_page is called multiple times for the same fragmen=
t.
> >=20
> > Dropping page->pp_frag_count and relying entirely on the page refcount =
makes
> > these underflow issues and crashes go away.
> >=20
>=20
> This has been discussed here [1].  TL;DR changing this to page
> refcount might blow up in other colorful ways.  Can we look closer and
> figure out why the underflow happens?
>=20
> [1] https://lore.kernel.org/netdev/1625903002-31619-4-git-send-email-liny=
unsheng@huawei.com/
>=20
> Thanks
> /Ilias
>=20
>=20

The logic should be safe in terms of the page pool itself as it should
be holding one reference to the page while the pp_frag_count is non-
zero. That one reference is what keeps the two halfs in sync as the
page shouldn't be able to be freed until we exhaust the pp_frag_count.

To have an underflow there are two possible scenarios. One is that
either put_page or free_page is being called somewhere that the
page_pool freeing functions should be used. The other possibility is
that a pp_frag_count reference was taken somewhere a page reference
should have.

Do we have a backtrace for the spots that are showing this underrun? If
nothing else we may want to look at tracking down the spots that are
freeing the page pool pages via put_page or free_page to determine what
paths these pages are taking.
