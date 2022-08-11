Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E65659072F
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 22:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbiHKUAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 16:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235934AbiHKUAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 16:00:08 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E2F9AFE3
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 13:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660248007; x=1691784007;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YiQBXT9wfa1wetxm9fnBkCHowbBE8sB6uMZyl/xqtkU=;
  b=CkWdyboj4c18vyfPVaEPi6Z8kzcZS/FT8AxyzYrXGO5DogrZuPtg0vWz
   HBhY4RhxBDw0gR0ujqwu5k1DD1aETEH4gRxVlhfAmdj+s6SvRN2X1YxOH
   TklKahwcd9Wz1XIjYLcDOHk5mOoa14IWkzDXaMZNreIhiW96LdUr+j/8r
   RUu/aT8tK1DsA+Eo56oLWOnoUbEMOp77YTtE4FAvkcf/eIP5zNWVt6yhs
   4Wz4qGN79CSDH/fAMbXOWjb4ZbTwYG1G6FWxXg/bADygVoIeR7g46UhHi
   +aIC3MyeexZ0aQsjNxgRHaPz79ciQh+jxC7vLXZ03d8fNoOrYlt8/KMBr
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="317415731"
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="317415731"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 13:00:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="933455900"
Received: from lkp-server02.sh.intel.com (HELO cfab306db114) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 11 Aug 2022 13:00:04 -0700
Received: from kbuild by cfab306db114 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oMELc-0000bp-10;
        Thu, 11 Aug 2022 20:00:04 +0000
Date:   Fri, 12 Aug 2022 03:59:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhogan@kernel.org
Cc:     kbuild-all@lists.01.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [Intel-wired-lan] [PATCH] igc: fix deadlock caused by taking
 RTNL in RPM resume path
Message-ID: <202208120359.pPxeIJNZ-lkp@intel.com>
References: <20220811151342.19059-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811151342.19059-1-vinicius.gomes@intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

I love your patch! Yet something to improve:

[auto build test ERROR on tnguy-next-queue/dev-queue]
[also build test ERROR on linus/master v5.19 next-20220811]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vinicius-Costa-Gomes/igc-fix-deadlock-caused-by-taking-RTNL-in-RPM-resume-path/20220811-232032
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue.git dev-queue
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220812/202208120359.pPxeIJNZ-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/61ed7ed758f23a10549c5d4fdc82ef9356281cbf
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vinicius-Costa-Gomes/igc-fix-deadlock-caused-by-taking-RTNL-in-RPM-resume-path/20220811-232032
        git checkout 61ed7ed758f23a10549c5d4fdc82ef9356281cbf
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/x86/include/asm/percpu.h:27,
                    from arch/x86/include/asm/nospec-branch.h:14,
                    from arch/x86/include/asm/paravirt_types.h:40,
                    from arch/x86/include/asm/ptrace.h:97,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:13,
                    from arch/x86/include/asm/timex.h:5,
                    from include/linux/timex.h:67,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:13,
                    from drivers/net/ethernet/intel/igc/igc_main.c:4:
>> drivers/net/ethernet/intel/igc/igc_main.c:6838:33: error: 'igc_suspend' undeclared here (not in a function); did you mean 'dpm_suspend'?
    6838 |         SET_SYSTEM_SLEEP_PM_OPS(igc_suspend, igc_resume)
         |                                 ^~~~~~~~~~~
   include/linux/kernel.h:57:44: note: in definition of macro 'PTR_IF'
      57 | #define PTR_IF(cond, ptr)       ((cond) ? (ptr) : NULL)
         |                                            ^~~
   include/linux/pm.h:313:20: note: in expansion of macro 'pm_sleep_ptr'
     313 |         .suspend = pm_sleep_ptr(suspend_fn), \
         |                    ^~~~~~~~~~~~
   include/linux/pm.h:343:9: note: in expansion of macro 'SYSTEM_SLEEP_PM_OPS'
     343 |         SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
         |         ^~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/intel/igc/igc_main.c:6838:9: note: in expansion of macro 'SET_SYSTEM_SLEEP_PM_OPS'
    6838 |         SET_SYSTEM_SLEEP_PM_OPS(igc_suspend, igc_resume)
         |         ^~~~~~~~~~~~~~~~~~~~~~~


vim +6838 drivers/net/ethernet/intel/igc/igc_main.c

bc23aa949aeba0 Sasha Neftin 2020-01-29  6835  
9513d2a5dc7f3f Sasha Neftin 2019-11-14  6836  #ifdef CONFIG_PM
9513d2a5dc7f3f Sasha Neftin 2019-11-14  6837  static const struct dev_pm_ops igc_pm_ops = {
9513d2a5dc7f3f Sasha Neftin 2019-11-14 @6838  	SET_SYSTEM_SLEEP_PM_OPS(igc_suspend, igc_resume)
9513d2a5dc7f3f Sasha Neftin 2019-11-14  6839  	SET_RUNTIME_PM_OPS(igc_runtime_suspend, igc_runtime_resume,
9513d2a5dc7f3f Sasha Neftin 2019-11-14  6840  			   igc_runtime_idle)
9513d2a5dc7f3f Sasha Neftin 2019-11-14  6841  };
9513d2a5dc7f3f Sasha Neftin 2019-11-14  6842  #endif
9513d2a5dc7f3f Sasha Neftin 2019-11-14  6843  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
