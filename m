Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6E730BF7D
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 14:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbhBBNck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 08:32:40 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:50744 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232359AbhBBNbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 08:31:32 -0500
Date:   Tue, 02 Feb 2021 13:30:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612272649; bh=ZfF+yk2N+NpRKErjKX/1hJfnJ9+R0QZ7qi8wGDkxhLc=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=JC6ZE9YeQdNvI/FWAl8VlGARKHDd6WNRQLAfnfL4TVLDkLkoYE9K8UqDc4M7jBs9N
         g4khZmUyNszCOHZYqaHjaU1RqnX9uCCZF0Y3556PymK+l2H37MIhyhkEFs7WCZtAvf
         /Hl5Sa4CK7Wbq+vm2zPcTsYQ/N14xJc0SU2u3qE0h50tEDFvF3J9/2nvuOz0JBKGz6
         xZAC2RaD1jhAkA2NyOJen4GjnhAl8X5d59limqowBlkzBLf50L8+Mf1dC1+8tMB+uu
         4uMest71b8Svz4XnAVl5nW2/qzGmvnntUkLJptBBRNzv+DKBcOK9Yi+qsDxeW8DiCK
         l/UcY02ewA5Bg==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     John Hubbard <jhubbard@nvidia.com>,
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
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH RESEND v3 net-next 0/5] net: consolidate page_is_pfmemalloc() usage
Message-ID: <20210202133030.5760-1-alobakin@pm.me>
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

page_is_pfmemalloc() is used mostly by networking drivers to test
if a page can be considered for reusing/recycling.
It doesn't write anything to the struct page itself, so its sole
argument can be constified, as well as the first argument of
skb_propagate_pfmemalloc().
In Page Pool core code, it can be simply inlined instead.
Most of the callers from NIC drivers were just doppelgangers of
the same condition tests. Derive them into a new common function
do deduplicate the code.

Resend of v3 [2]:
 - it missed Patchwork and Netdev archives, probably due to server-side
   issues.

Since v2 [1]:
 - use more intuitive name for the new inline function since there's
   nothing "reserved" in remote pages (Jakub Kicinski, John Hubbard);
 - fold likely() inside the helper itself to make driver code a bit
   fancier (Jakub Kicinski);
 - split function introduction and using into two separate commits;
 - collect some more tags (Jesse Brandeburg, David Rientjes).

Since v1 [0]:
 - new: reduce code duplication by introducing a new common function
   to test if a page can be reused/recycled (David Rientjes);
 - collect autographs for Page Pool bits (Jesper Dangaard Brouer,
   Ilias Apalodimas).

[0] https://lore.kernel.org/netdev/20210125164612.243838-1-alobakin@pm.me
[1] https://lore.kernel.org/netdev/20210127201031.98544-1-alobakin@pm.me
[2] https://lore.kernel.org/lkml/20210131120844.7529-1-alobakin@pm.me

Alexander Lobakin (5):
  mm: constify page_is_pfmemalloc() argument
  skbuff: constify skb_propagate_pfmemalloc() "page" argument
  net: introduce common dev_page_is_reusable()
  net: use the new dev_page_is_reusable() instead of private versions
  net: page_pool: simplify page recycling condition tests

 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 17 ++++++----------
 drivers/net/ethernet/intel/fm10k/fm10k_main.c | 13 ++++--------
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 15 +-------------
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   | 15 +-------------
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 13 ++----------
 drivers/net/ethernet/intel/igb/igb_main.c     |  9 ++-------
 drivers/net/ethernet/intel/igc/igc_main.c     |  9 ++-------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  9 ++-------
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  9 ++-------
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  7 +------
 include/linux/mm.h                            |  2 +-
 include/linux/skbuff.h                        | 20 +++++++++++++++++--
 net/core/page_pool.c                          | 14 ++++---------
 13 files changed, 46 insertions(+), 106 deletions(-)

--=20
2.30.0


