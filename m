Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C893B58F673
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 05:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbiHKDlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 23:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiHKDlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 23:41:22 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CB628E26;
        Wed, 10 Aug 2022 20:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660189281; x=1691725281;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pmGTeFXTRCq2QoJTtO4AUyyyAiy9u7rIqBO4oy0L52g=;
  b=GnraFpVDAN6VP+gktu6LBEZX7OVl87lldKFzk7PSgNli8dTCZu4374CX
   kevAgfBSF55pAqoj6tl55Iwa8XbqcWk/tJNI2x9a/cLqANPfKl0fOr4m2
   FKqXi5k/bNN6oLTZGZe9YzloiKmadXL0lLrLuTvzqz6MW3tkpzfhtOCix
   EoPI0JFoTdAcSNQpbvjFVzI2YSdP6S6X+wZ3XWPJ1rHSbgZ0OUv8X7QuG
   WozYwNMcdgUmxDRK3qXv0EpBjHUpqEysz100yDtFK03bKAvrJWFwC39CW
   JuA+NqOiiTYIrEUGCIK+jzF/M2D2aT5KUmN5Fr2X85jtKceewAc7RbfkJ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="292040550"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="292040550"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 20:41:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="933153776"
Received: from lkp-server02.sh.intel.com (HELO 5d6b42aa80b8) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 10 Aug 2022 20:41:18 -0700
Received: from kbuild by 5d6b42aa80b8 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oLz4Q-00013W-0b;
        Thu, 11 Aug 2022 03:41:18 +0000
Date:   Thu, 11 Aug 2022 11:41:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 01/10] net/smc: remove locks
 smc_client_lgr_pending and smc_server_lgr_pending
Message-ID: <202208111145.LdpP76au-lkp@intel.com>
References: <075ff0be35660efac638448cdae7f7e7e04199d4.1660152975.git.alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <075ff0be35660efac638448cdae7f7e7e04199d4.1660152975.git.alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wythe",

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/D-Wythe/net-smc-optimize-the-parallelism-of-SMC-R-connections/20220811-014942
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git f86d1fbbe7858884d6754534a0afbb74fc30bc26
config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20220811/202208111145.LdpP76au-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 5f1c7e2cc5a3c07cbc2412e851a7283c1841f520)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/2c1c2e644fb8dbce9b8a004e604792340cbfccb8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review D-Wythe/net-smc-optimize-the-parallelism-of-SMC-R-connections/20220811-014942
        git checkout 2c1c2e644fb8dbce9b8a004e604792340cbfccb8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/smc/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/smc/smc_core.c:95:30: warning: operator '?:' has lower precedence than '+'; '+' will be evaluated first [-Wparentheses]
                   + (lnkc->role == SMC_SERV) ? 0 : lnkc->clcqpn;
                   ~~~~~~~~~~~~~~~~~~~~~~~~~~ ^
   net/smc/smc_core.c:95:30: note: place parentheses around the '+' expression to silence this warning
                   + (lnkc->role == SMC_SERV) ? 0 : lnkc->clcqpn;
                                              ^
                                             )
   net/smc/smc_core.c:95:30: note: place parentheses around the '?:' expression to evaluate it first
                   + (lnkc->role == SMC_SERV) ? 0 : lnkc->clcqpn;
                                              ^
                     (                                          )
   net/smc/smc_core.c:104:29: warning: operator '?:' has lower precedence than '+'; '+' will be evaluated first [-Wparentheses]
                   + (key->role == SMC_SERV) ? 0 : key->clcqpn;
                   ~~~~~~~~~~~~~~~~~~~~~~~~~ ^
   net/smc/smc_core.c:104:29: note: place parentheses around the '+' expression to silence this warning
                   + (key->role == SMC_SERV) ? 0 : key->clcqpn;
                                             ^
                                            )
   net/smc/smc_core.c:104:29: note: place parentheses around the '?:' expression to evaluate it first
                   + (key->role == SMC_SERV) ? 0 : key->clcqpn;
                                             ^
                     (                                        )
   2 warnings generated.


vim +95 net/smc/smc_core.c

    88	
    89	/* SMC-R lnk cluster hash func */
    90	static u32 smcr_lnk_cluster_hashfn(const void *data, u32 len, u32 seed)
    91	{
    92		const struct smc_lnk_cluster *lnkc = data;
    93	
    94		return jhash2((u32 *)lnkc->peer_systemid, SMC_SYSTEMID_LEN / sizeof(u32), seed)
  > 95			+ (lnkc->role == SMC_SERV) ? 0 : lnkc->clcqpn;
    96	}
    97	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
