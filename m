Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93E4309818
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 20:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbhA3TqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 14:46:24 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:46626 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhA3TqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 14:46:21 -0500
Date:   Sat, 30 Jan 2021 19:45:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612035938; bh=KSS1WvHH+UXhfQLYUW4Daeb2Nv6yueVQ+VvjzEee/oA=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=GyORbfU+/iCXjaGF+dybJTXC9VvnAg4Yv47+oBL5y2ZsjMfuSNNu9ada072bWwz3G
         GJ1CogfM/BwCFIyL+YpjA0G7iY/z8dYQDD7uIQLCfNbYz2RLUS4TcyG55EFfJjlCBF
         DdaXtFEVU4OtuU0zNge83VNKL/NAg/cRtX8RrOz++4yhtNMD7kNU3GCt0xBl1IeP7i
         l5mPl/Zzcq0KSA7yhR9i6z+tO8uWgKGN0xWm07zlODJ3HEjhQK7IWuQV7iBTJic8oy
         U1VOjsuEKkRpcZl7/B5FuDSI2Jhbo7R91ouAZTWeUrEpFhPtlpvM8Gi4SFC3KQFCoK
         cOI3C6b1kSKFA==
To:     Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
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
Subject: Re: [PATCH v2 net-next 3/4] net: introduce common dev_page_is_reserved()
Message-ID: <20210130194459.37837-1-alobakin@pm.me>
In-Reply-To: <20210130110707.3122a360@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210127201031.98544-1-alobakin@pm.me> <20210127201031.98544-4-alobakin@pm.me> <20210129183907.2ae5ca3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20210130154149.8107-1-alobakin@pm.me> <20210130110707.3122a360@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

From: Jakub Kicinski <kuba@kernel.org>
Date: Sat, 30 Jan 2021 11:07:07 -0800

> On Sat, 30 Jan 2021 15:42:29 +0000 Alexander Lobakin wrote:
> > > On Wed, 27 Jan 2021 20:11:23 +0000 Alexander Lobakin wrote:
> > > > + * dev_page_is_reserved - check whether a page can be reused for n=
etwork Rx
> > > > + * @page: the page to test
> > > > + *
> > > > + * A page shouldn't be considered for reusing/recycling if it was =
allocated
> > > > + * under memory pressure or at a distant memory node.
> > > > + *
> > > > + * Returns true if this page should be returned to page allocator,=
 false
> > > > + * otherwise.
> > > > + */
> > > > +static inline bool dev_page_is_reserved(const struct page *page)
> > >
> > > Am I the only one who feels like "reusable" is a better term than
> > > "reserved".
> >
> > I thought about it, but this will need to inverse the conditions in
> > most of the drivers. I decided to keep it as it is.
> > I can redo if "reusable" is preferred.
>=20
> Naming is hard. As long as the condition is not a double negative it
> reads fine to me, but that's probably personal preference.
> The thing that doesn't sit well is the fact that there is nothing
> "reserved" about a page from another NUMA node.. But again, if nobody
> +1s this it's whatever...

Agree on NUMA and naming. I'm a bit surprised that 95% of drivers
have this helper called "reserved" (one of the reasons why I finished
with this variant).
Let's say, if anybody else will vote for "reusable", I'll pick it for
v3.

> That said can we move the likely()/unlikely() into the helper itself?
> People on the internet may say otherwise but according to my tests
> using __builtin_expect() on a return value of a static inline helper
> works just fine.

Sounds fine, this will make code more elegant. Will publish v3 soon.

Thanks,
Al

