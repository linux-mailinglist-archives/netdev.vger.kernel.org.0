Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80703064D0
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhA0ULr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:11:47 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:60876 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbhA0ULp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:11:45 -0500
Date:   Wed, 27 Jan 2021 20:10:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1611778257; bh=VdLcOnTLbHfFNHFlN/XjYPHtoWTcOg+AoFdHQrfr7jE=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=Xk5AAUW2hzwHMulLeDd1o8jFMxpHFcNn5Lvyslpc98CPdmGW4hNZNh3OaAbwjkSWF
         oRIUWJF6XzV3pvfkbhNTHAgvLjD1kCMdekHFzEH3aT3J99QoFSDjRqhaxPk0zkda4E
         t6ZOnF3hrDrAuzwJf3UsUBN+qukP/a/neSV503kp2b969Qcxk+IxK556S/wA6rijux
         fPvxxFUbr0ObBC1OXrkGd3Xpr4RzPPRCNiBQ0Gpc3V0F6+CioAvlmc8HKKlahZTVif
         Lf2ETDXjkBX+TWCVy0ex1AB8YM/aUks2vTia/rjzIUxIRVi1U+zeOL7SuD+exMYml9
         xhEDv9ixZi3hA==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     David Rientjes <rientjes@google.com>,
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
Subject: [PATCH v2 net-next 0/4] net: consolidate page_is_pfmemalloc() usage
Message-ID: <20210127201031.98544-1-alobakin@pm.me>
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

Since v1 [0]:
 - new: reduce code duplication by introducing a new common function
   to test if a page can be reused/recycled (David Rientjes);
 - collect autographs for Page Pool bits (Jesper Dangaard Brouer,
   Ilias Apalodimas).

[0] https://lore.kernel.org/netdev/20210125164612.243838-1-alobakin@pm.me

Alexander Lobakin (4):
  mm: constify page_is_pfmemalloc() argument
  skbuff: constify skb_propagate_pfmemalloc() "page" argument
  net: introduce common dev_page_is_reserved()
  net: page_pool: simplify page recycling condition tests

 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 10 ++--------
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |  9 ++-------
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 15 +--------------
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   | 15 +--------------
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 11 +----------
 drivers/net/ethernet/intel/igb/igb_main.c     |  7 +------
 drivers/net/ethernet/intel/igc/igc_main.c     |  7 +------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  7 +------
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  7 +------
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  7 +------
 include/linux/mm.h                            |  2 +-
 include/linux/skbuff.h                        | 19 +++++++++++++++++--
 net/core/page_pool.c                          | 14 ++++----------
 13 files changed, 34 insertions(+), 96 deletions(-)

--=20
2.30.0


