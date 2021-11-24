Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C262F45CBF0
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 19:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350429AbhKXSTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 13:19:22 -0500
Received: from mga07.intel.com ([134.134.136.100]:41141 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348801AbhKXSTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 13:19:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="298745837"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="298745837"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 10:16:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="538717379"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 24 Nov 2021 10:15:58 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mpwoH-0005AW-Uz; Wed, 24 Nov 2021 18:15:57 +0000
Date:   Thu, 25 Nov 2021 02:15:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>
Subject: Re: [PATCH v2 net-next 09/26] mlx5: don't mix XDP_DROP and Rx XDP
 error cases
Message-ID: <202111250224.jTNAiYeF-lkp@intel.com>
References: <20211123163955.154512-10-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123163955.154512-10-alexandr.lobakin@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Alexander-Lobakin/net-introduce-and-use-generic-XDP-stats/20211124-004501
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 2106efda785b55a8957efed9a52dfa28ee0d7280
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20211125/202111250224.jTNAiYeF-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/1595085302c56b82cbac2ac40ce6f263ac64fa1f
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Alexander-Lobakin/net-introduce-and-use-generic-XDP-stats/20211124-004501
        git checkout 1595085302c56b82cbac2ac40ce6f263ac64fa1f
        # save the config file to linux build tree
        make W=1 ARCH=i386 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c: In function 'mlx5i_grp_sw_update_stats':
>> drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c:136:1: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]
     136 | }
         | ^


vim +136 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c

48935bbb7ae8bd drivers/net/ethernet/mellanox/mlx5/core/ipoib.c       Saeed Mahameed 2017-04-13  110  
fbb66ad5dcbebc drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Wei Yongjun    2018-09-05  111  static void mlx5i_grp_sw_update_stats(struct mlx5e_priv *priv)
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  112  {
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  113  	struct mlx5e_sw_stats s = { 0 };
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  114  	int i, j;
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  115  
9d758d4a3a039b drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Tariq Toukan   2021-09-02  116  	for (i = 0; i < priv->stats_nch; i++) {
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  117  		struct mlx5e_channel_stats *channel_stats;
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  118  		struct mlx5e_rq_stats *rq_stats;
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  119  
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  120  		channel_stats = &priv->channel_stats[i];
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  121  		rq_stats = &channel_stats->rq;
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  122  
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  123  		s.rx_packets += rq_stats->packets;
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  124  		s.rx_bytes   += rq_stats->bytes;
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  125  
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  126  		for (j = 0; j < priv->max_opened_tc; j++) {
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  127  			struct mlx5e_sq_stats *sq_stats = &channel_stats->sq[j];
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  128  
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  129  			s.tx_packets           += sq_stats->packets;
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  130  			s.tx_bytes             += sq_stats->bytes;
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  131  			s.tx_queue_dropped     += sq_stats->dropped;
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  132  		}
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  133  	}
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  134  
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  135  	memcpy(&priv->stats.sw, &s, sizeof(s));
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02 @136  }
c57d2358ff0dfa drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c Feras Daoud    2018-09-02  137  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
