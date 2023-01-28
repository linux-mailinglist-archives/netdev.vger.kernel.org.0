Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C52167FB33
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 22:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbjA1VnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 16:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjA1VnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 16:43:05 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD9A24130
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 13:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674942184; x=1706478184;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MBTI/xeOVZdfcIhLedNEUnD+z6zRjs1Py93ubAFIyxU=;
  b=m7ZL1laxLRfRJfoyEZqFfj2UaMyhnIb9QbErtmeS2TNlQWPORPOA8Xwm
   D2Xym23j66DbjrLZ4E72l7aaHav65appuiSW1lX8IduaormDiBGdxthpK
   iA0zwUw5ivlXNP0I1C0opRcwfl1XQ39GawyZHwzLc6o4mh4AM9uXoUylZ
   8y3iN/uoIAMPM9TyXoH//gptyAXKUfkiiUvQtJ11rA0f2Rkbu14NedrQo
   rj3dCyyPLJilBtZBgtrpHkQWfVYMqaA9ks82JUdZ5rPAvaI8UVwHTJ7N/
   EAHMAckh4W4rzv+9nSznwWh94190434CdpYBFJ8w1oAKbJzigcfA1FgeS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="326009593"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="326009593"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2023 13:43:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="992446764"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="992446764"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jan 2023 13:42:59 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pLsyL-00018c-2X;
        Sat, 28 Jan 2023 21:42:53 +0000
Date:   Sun, 29 Jan 2023 05:42:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Gal Pressman <gal@nvidia.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v3 2/2] mlx5: fix possible ptp queue fifo
 use-after-free
Message-ID: <202301290528.ZvflGIBO-lkp@intel.com>
References: <20230126010206.13483-3-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126010206.13483-3-vfedorenko@novek.ru>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vadim,

I love your patch! Yet something to improve:

[auto build test ERROR on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Vadim-Fedorenko/mlx5-fix-skb-leak-while-fifo-resync-and-push/20230128-120805
patch link:    https://lore.kernel.org/r/20230126010206.13483-3-vfedorenko%40novek.ru
patch subject: [PATCH net v3 2/2] mlx5: fix possible ptp queue fifo use-after-free
config: i386-randconfig-a015 (https://download.01.org/0day-ci/archive/20230129/202301290528.ZvflGIBO-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/2516a9785583b92ac82262a813203de696096ccd
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vadim-Fedorenko/mlx5-fix-skb-leak-while-fifo-resync-and-push/20230128-120805
        git checkout 2516a9785583b92ac82262a813203de696096ccd
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:93:18: warning: unused variable 'skb' [-Wunused-variable]
           struct sk_buff *skb;
                           ^
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:92:30: warning: unused variable 'hwts' [-Wunused-variable]
           struct skb_shared_hwtstamps hwts = {};
                                       ^
>> drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:102:2: error: expected identifier or '('
           while (skb_cc != skb_id && (skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo))) {
           ^
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:110:2: error: expected identifier or '('
           if (!skb)
           ^
   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:113:2: error: expected identifier or '('
           return true;
           ^
>> drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c:114:1: error: extraneous closing brace ('}')
   }
   ^
   2 warnings and 4 errors generated.


vim +102 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c

    88	
    89	static bool mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc,
    90						     u16 skb_id, int budget)
    91	{
    92		struct skb_shared_hwtstamps hwts = {};
    93		struct sk_buff *skb;
    94	
    95		ptpsq->cq_stats->resync_event++;
    96	
    97		if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < skb_id)
    98			pr_err_ratelimited("mlx5e: out-of-order ptp cqe\n");
    99			return false;
   100		}
   101	
 > 102		while (skb_cc != skb_id && (skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo))) {
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
 > 114	}
   115	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
