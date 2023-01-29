Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6681C67FBF1
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 01:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjA2AGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 19:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjA2AGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 19:06:03 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B89D23663
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 16:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674950762; x=1706486762;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nGT/F+YKd21Z8Ve19Rp/fgFf9e6GA5LdRKDx4LoUbUI=;
  b=aJEFmrKrjGnrMb5E1VE/NgljyneMgv8TsB0P0nfP7PEsewwnOPS5NLKB
   qsEMjDMxXBokHnrjWUOOqmtcokOIF2yXn3Pyj2c4j0m8bGgvpKc4Pq5dT
   +MpBCMcR47EzIwBTKETGsqLRXWAkYlkM0xvUqOngtOecj74FEw9sH74hS
   TWk7gdfIZxaEzSLwq7+SidymSed3YQ3UnXFpT4zQmyw3rTqCs1dss8RyB
   0IjjLLrzFecdMdPTDY3T0LzjZY2hjPn2dRZhBhaQ9gBj3iqnhoNwO6Cv7
   FGzPOBQ6JGyiZfeVxWKi4SKi2T2Me1982ybop5AdsmPgD+8rIYB6bBeU4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="354660885"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="354660885"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2023 16:06:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="732266875"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="732266875"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 28 Jan 2023 16:05:59 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pLvCp-0001FQ-08;
        Sun, 29 Jan 2023 00:05:59 +0000
Date:   Sun, 29 Jan 2023 08:05:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Gal Pressman <gal@nvidia.com>
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH net v3 2/2] mlx5: fix possible ptp queue fifo
 use-after-free
Message-ID: <202301290714.hjuYGOXr-lkp@intel.com>
References: <20230126010206.13483-3-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126010206.13483-3-vfedorenko@novek.ru>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vadim,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Vadim-Fedorenko/mlx5-fix-skb-leak-while-fifo-resync-and-push/20230128-120805
patch link:    https://lore.kernel.org/r/20230126010206.13483-3-vfedorenko%40novek.ru
patch subject: [PATCH net v3 2/2] mlx5: fix possible ptp queue fifo use-after-free
config: alpha-allmodconfig (https://download.01.org/0day-ci/archive/20230129/202301290714.hjuYGOXr-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/2516a9785583b92ac82262a813203de696096ccd
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vadim-Fedorenko/mlx5-fix-skb-leak-while-fifo-resync-and-push/20230128-120805
        git checkout 2516a9785583b92ac82262a813203de696096ccd
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=alpha olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=alpha SHELL=/bin/bash drivers/bluetooth/ drivers/net/ethernet/mediatek/ drivers/net/ethernet/mellanox/mlx5/core/ drivers/pci/controller/ drivers/power/supply/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c: In function 'mlx5e_ptp_skb_fifo_ts_cqe_resync':
>> drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:97:9: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
      97 |         if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < skb_id)
         |         ^~
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:99:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
      99 |                 return false;
         |                 ^~~~~~
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:93:25: warning: unused variable 'skb' [-Wunused-variable]
      93 |         struct sk_buff *skb;
         |                         ^~~
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:92:37: warning: unused variable 'hwts' [-Wunused-variable]
      92 |         struct skb_shared_hwtstamps hwts = {};
         |                                     ^~~~
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c: At top level:
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:102:9: error: expected identifier or '(' before 'while'
     102 |         while (skb_cc != skb_id && (skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo))) {
         |         ^~~~~
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:110:9: error: expected identifier or '(' before 'if'
     110 |         if (!skb)
         |         ^~
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:113:9: error: expected identifier or '(' before 'return'
     113 |         return true;
         |         ^~~~~~
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:114:1: error: expected identifier or '(' before '}' token
     114 | }
         | ^


vim +/if +97 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c

    88	
    89	static bool mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc,
    90						     u16 skb_id, int budget)
    91	{
    92		struct skb_shared_hwtstamps hwts = {};
    93		struct sk_buff *skb;
    94	
    95		ptpsq->cq_stats->resync_event++;
    96	
  > 97		if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < skb_id)
    98			pr_err_ratelimited("mlx5e: out-of-order ptp cqe\n");
    99			return false;
   100		}
   101	
   102		while (skb_cc != skb_id && (skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo))) {
   103			hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
   104			skb_tstamp_tx(skb, &hwts);
   105			ptpsq->cq_stats->resync_cqe++;
   106			napi_consume_skb(skb, budget);
   107			skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
   108		}
   109	
   110		if (!skb)
   111			return false;
   112	
   113		return true;
   114	}
   115	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
