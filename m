Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1279930BF31
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 14:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhBBNSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 08:18:30 -0500
Received: from mail-41103.protonmail.ch ([185.70.41.103]:31881 "EHLO
        mail-41103.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbhBBNR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 08:17:57 -0500
Received: from mail-02.mail-europe.com (mail-02.mail-europe.com [51.89.119.103])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        by mail-41103.protonmail.ch (Postfix) with ESMTPS id 85C682004C74;
        Tue,  2 Feb 2021 13:17:14 +0000 (UTC)
Authentication-Results: mail-41103.protonmail.ch;
        dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="K7qCB1jw"
Date:   Tue, 02 Feb 2021 13:13:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612271590; bh=wkrsDsmJrKMWDTAP0CgzaSOfN+12VWFr81Nb1Qb7W0A=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=K7qCB1jwBd70fF7fnDVz7zwMpJCi3aRlkq6AbbrG0dMIDUTBab250VWxXM7d/JBeC
         imiSnG9/VbWmDCmxV4UOshgzGyFI06qGkOkjCPKDhepiMo/1oMQeS9oWgXTMs+qyXq
         D2ICe8QN/OKumGGOm2iLXsg0gHJUVLLbKU7F0CCCuB34jgsQAHDShDBtHlNkHppNNn
         JIKcB4hwUJDpwYyFakZ7zUnxsauJA8AMVC2iJMU7lT/KMC1WvYnzMj00ZtU0KrPxwN
         jyS8F0rt7d/4XC1FKuoG9uDC1kT6Fi/OnhzOUUiUB32HwX6pgyjODc3AEFyO2DD82t
         GQ5im5p3D47HQ==
To:     Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
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
Subject: Re: [PATCH v3 net-next 0/5] net: consolidate page_is_pfmemalloc() usage
Message-ID: <20210202131233.4180-1-alobakin@pm.me>
In-Reply-To: <20210201171835.690558df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210131120844.7529-1-alobakin@pm.me> <20210201171835.690558df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
Date: Mon, 1 Feb 2021 17:18:35 -0800

> On Sun, 31 Jan 2021 12:11:16 +0000 Alexander Lobakin wrote:
> > page_is_pfmemalloc() is used mostly by networking drivers to test
> > if a page can be considered for reusing/recycling.
> > It doesn't write anything to the struct page itself, so its sole
> > argument can be constified, as well as the first argument of
> > skb_propagate_pfmemalloc().
> > In Page Pool core code, it can be simply inlined instead.
> > Most of the callers from NIC drivers were just doppelgangers of
> > the same condition tests. Derive them into a new common function
> > do deduplicate the code.
>=20
> Please resend, this did not get into patchwork :/

I suspected it would be so as I got reports about undelivered mails
due to unavailability of vger.kernel.org for some reasons Will do.

Al

