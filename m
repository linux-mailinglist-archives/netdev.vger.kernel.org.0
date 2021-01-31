Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC871309C35
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 14:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhAaM6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 07:58:05 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:33314 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbhAaMtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 07:49:20 -0500
Date:   Sun, 31 Jan 2021 12:48:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612097317; bh=y30s5J10nfJ05d+t9ObBLUOEaiYg0NNkaEvHUkJBLzA=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=nhDCOWplzmyXPSzZmedhJPQwO/CC5dhY2EAtlfsC7hL96xVl0c+sIejcE+CS/6IpU
         gKKz74jA72t0iHZmFG4/Vph3vyY8VtWfQ6r65Fm6GYKbXLbfdZe10YKpES2uD/emi8
         SHz1PtfhWCTcQPkFFde1Xz7YXK4Bf9JUIsyZrdynXJ0OgIbBhvB6oa5SUdPL4/J0RW
         OXbOAw2zjJyP47AAvJbs6D6KnTLWmMU4i43Sbxw6nbusSdbY+qHSiPn5BRfN/WIU+l
         YrXmib/7xJ4qSyDdhsroCsfKrCT45hSewfuvdY91s9u3N/tjTddj5YDF4JW17JiqKy
         VR6FDnyinK+Zw==
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
Subject: Re: [PATCH v3 net-next 5/5] net: page_pool: simplify page recycling condition tests
Message-ID: <20210131124802.8430-1-alobakin@pm.me>
In-Reply-To: <20210131122348.GM308988@casper.infradead.org>
References: <20210131120844.7529-1-alobakin@pm.me> <20210131120844.7529-6-alobakin@pm.me> <20210131122348.GM308988@casper.infradead.org>
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
Date: Sun, 31 Jan 2021 12:23:48 +0000

> On Sun, Jan 31, 2021 at 12:12:11PM +0000, Alexander Lobakin wrote:
> > pool_page_reusable() is a leftover from pre-NUMA-aware times. For now,
> > this function is just a redundant wrapper over page_is_pfmemalloc(),
> > so inline it into its sole call site.
>=20
> Why doesn't this want to use {dev_}page_is_reusable()?

Page Pool handles NUMA on its own. Replacing plain page_is_pfmemalloc()
with dev_page_is_reusable() will only add a completely redundant and
always-false check on the fastpath.

Al

