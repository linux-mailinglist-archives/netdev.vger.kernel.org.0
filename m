Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C582F1DFA
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389982AbhAKS2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:28:09 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:57984 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728056AbhAKS2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 13:28:08 -0500
Date:   Mon, 11 Jan 2021 18:27:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610389644; bh=zMoAhzMpBXRXHs8lVx+DOgiDZHIU73jEHLkoY9JLnro=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=SWUU5ht8L8ZEe+kq1pnXCVazfDuj3E0bZwUcIqz3GWofA9V1xwnen3KkUeccl6/fa
         hrf9LP2PYE31fih+pPVTs6RjWESZV+Xak2qqPWcRy07faCTzdAy/xxJBRomecvoVM0
         7lncmRkMYZn7DP0Sp3mld9wsKupMLOpWImge9tifNRaFoXSIqk9k85bGvkql4uwXjk
         Lj+lOuLb948PHi7PLXlulZwOB8hKh6+q3S0yBS2treuFPzeVJK0exjyak7ZXbnuhmF
         roHG4aC0whxt+38tbw5/IoruCAJMcVvJQ1Pih7rjaD7MJ9Nnsdp16sv51w1liXSzGE
         nutOmEIKsmpmg==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Eric Dumazet <edumazet@google.com>,
        Edward Cree <ecree@solarflare.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 0/5] skbuff: introduce skbuff_heads bulking and reusing
Message-ID: <20210111182655.12159-1-alobakin@pm.me>
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

Inspired by cpu_map_kthread_run() and _kfree_skb_defer() logics.

Currently, all sorts of skb allocation always do allocate
skbuff_heads one by one via kmem_cache_alloc().
On the other hand, we have percpu napi_alloc_cache to store
skbuff_heads queued up for freeing and flush them by bulks.

We can use this struct to cache and bulk not only freeing, but also
allocation of new skbuff_heads, as well as to reuse cached-to-free
heads instead of allocating the new ones.
As accessing napi_alloc_cache implies NAPI softirq context, do this
only for __napi_alloc_skb() and its derivatives (napi_alloc_skb()
and napi_get_frags()). The rough amount of their call sites are 69,
which is quite a number.

iperf3 showed a nice bump from 910 to 935 Mbits while performing
UDP VLAN NAT on 1.2 GHz MIPS board. The boost is likely to be
way bigger on more powerful hosts and NICs with tens of Mpps.

Patches 1-2 are preparation steps, while 3-5 do the real work.

Alexander Lobakin (5):
  skbuff: rename fields of struct napi_alloc_cache to be more intuitive
  skbuff: open-code __build_skb() inside __napi_alloc_skb()
  skbuff: reuse skbuff_heads from flush_skb_cache if available
  skbuff: allocate skbuff_heads by bulks instead of one by one
  skbuff: refill skb_cache early from deferred-to-consume entries

 net/core/skbuff.c | 62 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 14 deletions(-)

--=20
2.30.0


