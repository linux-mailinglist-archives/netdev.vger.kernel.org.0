Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49AE23066BE
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 22:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbhA0VuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 16:50:15 -0500
Received: from mga17.intel.com ([192.55.52.151]:44159 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231127AbhA0VsT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 16:48:19 -0500
IronPort-SDR: lcRO+nBbwlxD5OKQ9floYnPqvizXa/TpKNsXPOC2RGM3wZ0MgRHL4W5twcWIKDXDS+qBKmCR6V
 trTxUngA0I8w==
X-IronPort-AV: E=McAfee;i="6000,8403,9877"; a="159912616"
X-IronPort-AV: E=Sophos;i="5.79,380,1602572400"; 
   d="scan'208";a="159912616"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 13:47:30 -0800
IronPort-SDR: x8SX2Z/eZDC0uopz6q0GvPObDP9bsfjhVBCSv7w/mie7EoujaaoDFv19suwWd/v2MLVVLnlSIt
 K8UvsSEBqhkg==
X-IronPort-AV: E=Sophos;i="5.79,380,1602572400"; 
   d="scan'208";a="573409951"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.44.59])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 13:47:28 -0800
Date:   Wed, 27 Jan 2021 13:47:26 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
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
Subject: Re: [PATCH v2 net-next 3/4] net: introduce common
 dev_page_is_reserved()
Message-ID: <20210127134726.00003605@intel.com>
In-Reply-To: <20210127201031.98544-4-alobakin@pm.me>
References: <20210127201031.98544-1-alobakin@pm.me>
        <20210127201031.98544-4-alobakin@pm.me>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin wrote:

> A bunch of drivers test the page before reusing/recycling for two
> common conditions:
>  - if a page was allocated under memory pressure (pfmemalloc page);
>  - if a page was allocated at a distant memory node (to exclude
>    slowdowns).
> 
> Introduce and use a new common function for doing this and eliminate
> all functions-duplicates from drivers.
> 
> Suggested-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c   | 10 ++--------
>  drivers/net/ethernet/intel/fm10k/fm10k_main.c     |  9 ++-------
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c       | 15 +--------------
>  drivers/net/ethernet/intel/iavf/iavf_txrx.c       | 15 +--------------
>  drivers/net/ethernet/intel/ice/ice_txrx.c         | 11 +----------
>  drivers/net/ethernet/intel/igb/igb_main.c         |  7 +------
>  drivers/net/ethernet/intel/igc/igc_main.c         |  7 +------
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |  7 +------
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |  7 +------
>  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   |  7 +------
>  include/linux/skbuff.h                            | 15 +++++++++++++++
>  11 files changed, 27 insertions(+), 83 deletions(-)

For the patch, and esp. for the Intel drivers:
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
