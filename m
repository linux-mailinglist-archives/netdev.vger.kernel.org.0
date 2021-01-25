Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3C1302832
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 17:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730916AbhAYQse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 11:48:34 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:25717 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730886AbhAYQro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 11:47:44 -0500
Date:   Mon, 25 Jan 2021 16:46:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1611593212; bh=O3BWBtVtHnlCsFaJds2EaRRj5UFBxIVItFjF3RQ5foo=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=fyb2kN/4x6ExKBRo9Irg/d1YeJZtuGXCH3KkYYxrwU6bfwqlp8xMWmyHoMUe9wKZ7
         FE4ZC5fnorwlL/gi5srUrW8gfzuAUandYJdMMJtbd60j7IN3szMPX9rMu49/9ZcFnx
         mggR925yYUco0rRp1UqPs6oBDI2aUk0GPLTSLnEIzSfFP1cdBPEwguNgJU25afaZoY
         5lx4EVfbt3/89Iq5QNz7cj/2zToRT9N8KHsxez2Sqd2z6gQsDdV4BKPWnmuayZVa6s
         voZckv5Kh2OQ1jTDMApFKg4MTPwxYrd2KAWmMNbjJKjcuTkrZ1xfkwA5Jay1YMuCQg
         rZ+LjQ+WWvz5Q==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Aleksandr Nogikh <nogikh@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org,
        Alexander Lobakin <alobakin@pm.me>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 0/3] net: constify page_is_pfmemalloc() and its users
Message-ID: <20210125164612.243838-1-alobakin@pm.me>
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

page_is_pfmemalloc() is used mostly by networking drivers. It doesn't
write anything to the struct page itself, so constify its argument and
a bunch of callers and wrappers around this function in drivers.
In Page Pool core code, it can be simply inlined instead.

Alexander Lobakin (3):
  mm: constify page_is_pfmemalloc() argument
  net: constify page_is_pfmemalloc() argument at call sites
  net: page_pool: simplify page recycling condition tests

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c   |  2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c     |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c       |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c       |  2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c         |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c         |  2 +-
 drivers/net/ethernet/intel/igc/igc_main.c         |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |  2 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   |  2 +-
 include/linux/mm.h                                |  2 +-
 include/linux/skbuff.h                            |  4 ++--
 net/core/page_pool.c                              | 14 ++++----------
 13 files changed, 17 insertions(+), 23 deletions(-)

--=20
2.30.0


