Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5795906CC
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 21:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235799AbiHKS7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 14:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234335AbiHKS7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 14:59:05 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E0B9FAB2
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 11:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660244344; x=1691780344;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OgRPmckFG0TtMVAfj/fjsMBpWluP7n5nc5q0S29fQ70=;
  b=B9Co7/MzMkBXuUDwiRgvaz1hGeuSi3tRJdLy7JR5Gw99hPJvGXmpvZM8
   PMWcsow2ZL5W/4z1GIDqZIMuQRGALLeFlFLvF4oyp8YcoxHeLxKN9Puvg
   04dbTMMbGrQH1qsNS2W0jR1SsHKt8jnoBTd1JRo9b4QWwiZY9DMYvHeWu
   LJS37z6x3hsrYbkV9lepY2lkl2e0LULISQ6rhKIoS+BOcxWZpSniE1euV
   /1gjQdLvTBz3w53vInvu/XKf1Q3FuVejrOXkepr7U0S1IAYROjTTzGJAO
   CWahFFt0OrGVpbWcHhx0yQVCWQqhjzvEMNpUN+Ysm7FDsQkTWGfOgX+17
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="355442232"
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="355442232"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 11:59:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="673810482"
Received: from lkp-server02.sh.intel.com (HELO cfab306db114) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 11 Aug 2022 11:59:01 -0700
Received: from kbuild by cfab306db114 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oMDOX-0000Xr-0K;
        Thu, 11 Aug 2022 18:59:01 +0000
Date:   Fri, 12 Aug 2022 02:58:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhogan@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Paul Menzel <pmenzel@molgen.mpg.de>, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [Intel-wired-lan] [PATCH] igc: fix deadlock caused by taking
 RTNL in RPM resume path
Message-ID: <202208120244.a7CKRiFy-lkp@intel.com>
References: <20220811151342.19059-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811151342.19059-1-vinicius.gomes@intel.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20220812/202208120244.a7CKRiFy-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 5f1c7e2cc5a3c07cbc2412e851a7283c1841f520)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/61ed7ed758f23a10549c5d4fdc82ef9356281cbf
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vinicius-Costa-Gomes/igc-fix-deadlock-caused-by-taking-RTNL-in-RPM-resume-path/20220811-232032
        git checkout 61ed7ed758f23a10549c5d4fdc82ef9356281cbf
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/ethernet/intel/igc/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/ethernet/intel/igc/igc_main.c:6838:26: error: use of undeclared identifier 'igc_suspend'; did you mean '__igc_suspend'?
           SET_SYSTEM_SLEEP_PM_OPS(igc_suspend, igc_resume)
                                   ^~~~~~~~~~~
                                   __igc_suspend
   include/linux/pm.h:343:22: note: expanded from macro 'SET_SYSTEM_SLEEP_PM_OPS'
           SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
                               ^
   include/linux/pm.h:313:26: note: expanded from macro 'SYSTEM_SLEEP_PM_OPS'
           .suspend = pm_sleep_ptr(suspend_fn), \
                                   ^
   include/linux/pm.h:439:65: note: expanded from macro 'pm_sleep_ptr'
   #define pm_sleep_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM_SLEEP), (_ptr))
                                                                   ^
   include/linux/kernel.h:57:38: note: expanded from macro 'PTR_IF'
   #define PTR_IF(cond, ptr)       ((cond) ? (ptr) : NULL)
                                              ^
   drivers/net/ethernet/intel/igc/igc_main.c:6706:27: note: '__igc_suspend' declared here
   static int __maybe_unused __igc_suspend(struct device *dev)
                             ^
>> drivers/net/ethernet/intel/igc/igc_main.c:6838:26: error: use of undeclared identifier 'igc_suspend'; did you mean '__igc_suspend'?
           SET_SYSTEM_SLEEP_PM_OPS(igc_suspend, igc_resume)
                                   ^~~~~~~~~~~
                                   __igc_suspend
   include/linux/pm.h:343:22: note: expanded from macro 'SET_SYSTEM_SLEEP_PM_OPS'
           SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
                               ^
   include/linux/pm.h:315:25: note: expanded from macro 'SYSTEM_SLEEP_PM_OPS'
           .freeze = pm_sleep_ptr(suspend_fn), \
                                  ^
   include/linux/pm.h:439:65: note: expanded from macro 'pm_sleep_ptr'
   #define pm_sleep_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM_SLEEP), (_ptr))
                                                                   ^
   include/linux/kernel.h:57:38: note: expanded from macro 'PTR_IF'
   #define PTR_IF(cond, ptr)       ((cond) ? (ptr) : NULL)
                                              ^
   drivers/net/ethernet/intel/igc/igc_main.c:6706:27: note: '__igc_suspend' declared here
   static int __maybe_unused __igc_suspend(struct device *dev)
                             ^
>> drivers/net/ethernet/intel/igc/igc_main.c:6838:26: error: use of undeclared identifier 'igc_suspend'; did you mean '__igc_suspend'?
           SET_SYSTEM_SLEEP_PM_OPS(igc_suspend, igc_resume)
                                   ^~~~~~~~~~~
                                   __igc_suspend
   include/linux/pm.h:343:22: note: expanded from macro 'SET_SYSTEM_SLEEP_PM_OPS'
           SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
                               ^
   include/linux/pm.h:317:27: note: expanded from macro 'SYSTEM_SLEEP_PM_OPS'
           .poweroff = pm_sleep_ptr(suspend_fn), \
                                    ^
   include/linux/pm.h:439:65: note: expanded from macro 'pm_sleep_ptr'
   #define pm_sleep_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM_SLEEP), (_ptr))
                                                                   ^
   include/linux/kernel.h:57:38: note: expanded from macro 'PTR_IF'
   #define PTR_IF(cond, ptr)       ((cond) ? (ptr) : NULL)
                                              ^
   drivers/net/ethernet/intel/igc/igc_main.c:6706:27: note: '__igc_suspend' declared here
   static int __maybe_unused __igc_suspend(struct device *dev)
                             ^
   3 errors generated.


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
