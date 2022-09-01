Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48505AA1BF
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 23:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbiIAVxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 17:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiIAVxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 17:53:07 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC966786C9
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 14:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662069186; x=1693605186;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=vEkIH9vrcYr7hLiPMJyO8DMul8XhP9Txs7CGa8XjhNk=;
  b=TRdd/TkNEWKILegjoVZP5Dxt74WX6JjHImw3pLrcXExs0+6pfLNaUS2f
   T7W3belPBuei/1sl7IdZ5/KSRqjg1boRA82he4D1N/K/6/Ycoi5Fw3zCV
   ZBcQEOAKNxOSRMQgmyt0I8J9aymYGcae3EE2Og+K53G8b0Rqo8kZ/3xMv
   jfP5cJM8ahSbXQBV8zYJ0VzN0qtaC8pUVnLMcTbBna5FkGeRoaEzvxg7T
   G/yC/opCLdaHVQCFqBr7V8OggSPG2oPVlhWAwwiB01lDbif7IuqZm3nxw
   r0u8MCbp7LLvIbjEtctq/Z0znN4vs7fGLlrkeoeegtC6m8GJRnBo3/Cbd
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="357553178"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="357553178"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 14:53:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="755007939"
Received: from lkp-server02.sh.intel.com (HELO b138c9e8658c) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 01 Sep 2022 14:53:01 -0700
Received: from kbuild by b138c9e8658c with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oTs7Q-0000oZ-16;
        Thu, 01 Sep 2022 21:53:00 +0000
Date:   Fri, 2 Sep 2022 05:52:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, qiangqing.zhang@nxp.com,
        Andrew Lunn <andrew@lunn.ch>, kernel@pengutronix.de,
        =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH v2] net: fec: Use unlocked timecounter reads for saving
 state
Message-ID: <202209020550.JEmUsnnl-lkp@intel.com>
References: <20220830111516.82875-1-csokas.bence@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220830111516.82875-1-csokas.bence@prolan.hu>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi "Csókás,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]
[also build test ERROR on net-next/master linus/master v6.0-rc3 next-20220901]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Cs-k-s-Bence/net-fec-Use-unlocked-timecounter-reads-for-saving-state/20220830-191644
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git b05972f01e7d30419987a1f221b5593668fd6448
config: s390-allyesconfig (https://download.01.org/0day-ci/archive/20220902/202209020550.JEmUsnnl-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1b907e75a5f827529bfe24d68038c69fac840901
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Cs-k-s-Bence/net-fec-Use-unlocked-timecounter-reads-for-saving-state/20220830-191644
        git checkout 1b907e75a5f827529bfe24d68038c69fac840901
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/ethernet/freescale/fec_ptp.c: In function 'fec_ptp_save_state':
>> drivers/net/ethernet/freescale/fec_ptp.c:648:13: error: implicit declaration of function 'preempt_count_equals'; did you mean 'preempt_count_sub'? [-Werror=implicit-function-declaration]
     648 |         if (preempt_count_equals(0)) {
         |             ^~~~~~~~~~~~~~~~~~~~
         |             preempt_count_sub
   In file included from include/linux/bitops.h:7,
                    from include/linux/thread_info.h:27,
                    from arch/s390/include/asm/preempt.h:6,
                    from include/linux/preempt.h:78,
                    from arch/s390/include/asm/timex.h:13,
                    from include/linux/timex.h:67,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:13,
                    from drivers/net/ethernet/freescale/fec_ptp.c:10:
>> drivers/net/ethernet/freescale/fec_ptp.c:649:53: error: 'flags' undeclared (first use in this function)
     649 |                 spin_lock_irqsave(&fep->tmreg_lock, flags);
         |                                                     ^~~~~
   include/linux/typecheck.h:11:16: note: in definition of macro 'typecheck'
      11 |         typeof(x) __dummy2; \
         |                ^
   include/linux/spinlock.h:379:9: note: in expansion of macro 'raw_spin_lock_irqsave'
     379 |         raw_spin_lock_irqsave(spinlock_check(lock), flags);     \
         |         ^~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/freescale/fec_ptp.c:649:17: note: in expansion of macro 'spin_lock_irqsave'
     649 |                 spin_lock_irqsave(&fep->tmreg_lock, flags);
         |                 ^~~~~~~~~~~~~~~~~
   drivers/net/ethernet/freescale/fec_ptp.c:649:53: note: each undeclared identifier is reported only once for each function it appears in
     649 |                 spin_lock_irqsave(&fep->tmreg_lock, flags);
         |                                                     ^~~~~
   include/linux/typecheck.h:11:16: note: in definition of macro 'typecheck'
      11 |         typeof(x) __dummy2; \
         |                ^
   include/linux/spinlock.h:379:9: note: in expansion of macro 'raw_spin_lock_irqsave'
     379 |         raw_spin_lock_irqsave(spinlock_check(lock), flags);     \
         |         ^~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/freescale/fec_ptp.c:649:17: note: in expansion of macro 'spin_lock_irqsave'
     649 |                 spin_lock_irqsave(&fep->tmreg_lock, flags);
         |                 ^~~~~~~~~~~~~~~~~
   include/linux/typecheck.h:12:25: warning: comparison of distinct pointer types lacks a cast
      12 |         (void)(&__dummy == &__dummy2); \
         |                         ^~
   include/linux/spinlock.h:241:17: note: in expansion of macro 'typecheck'
     241 |                 typecheck(unsigned long, flags);        \
         |                 ^~~~~~~~~
   include/linux/spinlock.h:379:9: note: in expansion of macro 'raw_spin_lock_irqsave'
     379 |         raw_spin_lock_irqsave(spinlock_check(lock), flags);     \
         |         ^~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/freescale/fec_ptp.c:649:17: note: in expansion of macro 'spin_lock_irqsave'
     649 |                 spin_lock_irqsave(&fep->tmreg_lock, flags);
         |                 ^~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +648 drivers/net/ethernet/freescale/fec_ptp.c

   643	
   644	void fec_ptp_save_state(struct fec_enet_private *fep)
   645	{
   646		u32 atime_inc_corr;
   647	
 > 648		if (preempt_count_equals(0)) {
 > 649			spin_lock_irqsave(&fep->tmreg_lock, flags);
   650			fep->ptp_saved_state.ns_phc = timecounter_read(&fep->tc);
   651			spin_unlock_irqrestore(&fep->tmreg_lock, flags);
   652		} else {
   653			fep->ptp_saved_state.ns_phc = timecounter_read(&fep->tc);
   654		}
   655		fep->ptp_saved_state.ns_sys = ktime_get_ns();
   656	
   657		fep->ptp_saved_state.at_corr = readl(fep->hwp + FEC_ATIME_CORR);
   658		atime_inc_corr = readl(fep->hwp + FEC_ATIME_INC) & FEC_T_INC_CORR_MASK;
   659		fep->ptp_saved_state.at_inc_corr = (u8)(atime_inc_corr >> FEC_T_INC_CORR_OFFSET);
   660	}
   661	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
