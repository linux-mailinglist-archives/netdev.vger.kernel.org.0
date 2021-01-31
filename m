Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A037D309DA5
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 16:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbhAaPhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 10:37:06 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:62432 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbhAaM6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 07:58:16 -0500
Date:   Sun, 31 Jan 2021 12:57:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612097850; bh=hy3HTU1Gr4SJ412CK0eDCO6whxGXOGwlEZQ/bHzh0IY=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=gOF3DQLDOPbnITXBUL2KPwaqec06jg7hgwxBrpixduvxzEnKNGsfv8ItuXKrxv9Ng
         JiqbWegAiSb0RANpw00MRZt5dHVkVaU/4aT5yLL76tDfJs1aAdwYldD7IWkRc5kxbh
         1BAJMWanlZQ2JqPkXy6HSIYWPNKbrH0EQAF1HDdchGDHYnALdR6ajs+2btoq67GU9f
         f5YZ1517Lx6mBTrwwu58TBCcS9IuiaspQ6k7jtFh66w62CLwSumleX42KAPMkjKfzH
         bHZna372czPrByZznTmm5VyRMiP9VCQ0UQEj/5CLGRQO8Ef03IeNcCrs59678BmNjl
         NGoTfgARWpgvw==
To:     Matthew Wilcox <willy@infradead.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
        David Rientjes <rientjes@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v3 net-next 3/5] net: introduce common dev_page_is_reusable()
Message-ID: <20210131125713.8710-1-alobakin@pm.me>
In-Reply-To: <20210131122205.GL308988@casper.infradead.org>
References: <20210131120844.7529-1-alobakin@pm.me> <20210131120844.7529-4-alobakin@pm.me> <20210131122205.GL308988@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>
Date: Sun, 31 Jan 2021 12:22:05 +0000

> On Sun, Jan 31, 2021 at 12:11:52PM +0000, Alexander Lobakin wrote:
> > A bunch of drivers test the page before reusing/recycling for two
> > common conditions:
> >  - if a page was allocated under memory pressure (pfmemalloc page);
> >  - if a page was allocated at a distant memory node (to exclude
> >    slowdowns).
> >
> > Introduce a new common inline for doing this, with likely() already
> > folded inside to make driver code a bit simpler.
>=20
> I don't see the need for the 'dev_' prefix.  That actually confuses me
> because it makes me think this is tied to ZONE_DEVICE or some such.

Several functions right above this one also use 'dev_' prefix. It's
a rather old mark that it's about network devices.

> So how about calling it just 'page_is_reusable' and putting it in mm.h
> with page_is_pfmemalloc() and making the comment a little less network-ce=
ntric?

This pair of conditions (!pfmemalloc + local memory node) is really
specific to network drivers. I didn't see any other instances of such
tests, so I don't see a reason to place it in a more common mm.h.

> Or call it something like skb_page_is_recyclable() since it's only used
> by networking today.  But I bet it could/should be used more widely.

There's nothing about skb. Tested page is just a memory chunk for DMA
transaction. It can be used as skb head/frag, for XDP buffer/frame or
for XSK umem.

> > +/**
> > + * dev_page_is_reusable - check whether a page can be reused for netwo=
rk Rx
> > + * @page: the page to test
> > + *
> > + * A page shouldn't be considered for reusing/recycling if it was allo=
cated
> > + * under memory pressure or at a distant memory node.
> > + *
> > + * Returns false if this page should be returned to page allocator, tr=
ue
> > + * otherwise.
> > + */
> > +static inline bool dev_page_is_reusable(const struct page *page)
> > +{
> > +=09return likely(page_to_nid(page) =3D=3D numa_mem_id() &&
> > +=09=09      !page_is_pfmemalloc(page));
> > +}
> > +

Al

