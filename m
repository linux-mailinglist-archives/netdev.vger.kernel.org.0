Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C8345DEB1
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 17:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241395AbhKYQqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 11:46:31 -0500
Received: from mga06.intel.com ([134.134.136.31]:55320 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237189AbhKYQoa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 11:44:30 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10179"; a="296344520"
X-IronPort-AV: E=Sophos;i="5.87,263,1631602800"; 
   d="scan'208";a="296344520"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2021 08:41:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,263,1631602800"; 
   d="scan'208";a="554684521"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 25 Nov 2021 08:41:15 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1APGfE2H028637;
        Thu, 25 Nov 2021 16:41:14 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kbuild-all@lists.01.org,
        netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2 net-next 09/26] mlx5: don't mix XDP_DROP and Rx XDP error cases
Date:   Thu, 25 Nov 2021 17:40:40 +0100
Message-Id: <20211125164040.127008-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <202111250224.jTNAiYeF-lkp@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com> <20211123163955.154512-10-alexandr.lobakin@intel.com> <202111250224.jTNAiYeF-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: kernel test robot <lkp@intel.com>
Date: Thu, 25 Nov 2021 02:15:55 +0800

> Hi Alexander,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on net-next/master]
> 
> url:    https://github.com/0day-ci/linux/commits/Alexander-Lobakin/net-introduce-and-use-generic-XDP-stats/20211124-004501
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 2106efda785b55a8957efed9a52dfa28ee0d7280
> config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20211125/202111250224.jTNAiYeF-lkp@intel.com/config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/0day-ci/linux/commit/1595085302c56b82cbac2ac40ce6f263ac64fa1f
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Alexander-Lobakin/net-introduce-and-use-generic-XDP-stats/20211124-004501
>         git checkout 1595085302c56b82cbac2ac40ce6f263ac64fa1f
>         # save the config file to linux build tree
>         make W=1 ARCH=i386 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c: In function 'mlx5i_grp_sw_update_stats':
> >> drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c:136:1: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>      136 | }
>          | ^
> 
> 
> vim +136 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
> 
> 48935bbb7ae8bd drivers/net/ethernet/mellanox/mlx5/core/ipoib.c       Saeed Mahameed 2017-04-13  110  
> fbb66ad5dcbebc drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Wei Yongjun    2018-09-05  111  static void mlx5i_grp_sw_update_stats(struct mlx5e_priv *priv)
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  112  {
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  113  	struct mlx5e_sw_stats s = { 0 };

Can I allocate mlx5e_sw_stats dynamically here to avoid running out
of the stack frame size?

> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  114  	int i, j;
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  115  
> 9d758d4a3a039b drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Tariq Toukan   2021-09-02  116  	for (i = 0; i < priv->stats_nch; i++) {
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  117  		struct mlx5e_channel_stats *channel_stats;
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  118  		struct mlx5e_rq_stats *rq_stats;
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  119  
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  120  		channel_stats = &priv->channel_stats[i];
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  121  		rq_stats = &channel_stats->rq;
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  122  
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  123  		s.rx_packets += rq_stats->packets;
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  124  		s.rx_bytes   += rq_stats->bytes;
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  125  
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  126  		for (j = 0; j < priv->max_opened_tc; j++) {
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  127  			struct mlx5e_sq_stats *sq_stats = &channel_stats->sq[j];
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  128  
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  129  			s.tx_packets           += sq_stats->packets;
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  130  			s.tx_bytes             += sq_stats->bytes;
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  131  			s.tx_queue_dropped     += sq_stats->dropped;
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  132  		}
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  133  	}
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  134  
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  135  	memcpy(&priv->stats.sw, &s, sizeof(s));
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02 @136  }
> c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  137  
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Thanks,
Al
