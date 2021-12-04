Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8796468852
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 00:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbhLDXng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 18:43:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:50181 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233964AbhLDXnf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 18:43:35 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10188"; a="261172709"
X-IronPort-AV: E=Sophos;i="5.87,288,1631602800"; 
   d="scan'208";a="261172709"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2021 15:40:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,288,1631602800"; 
   d="scan'208";a="610833422"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 04 Dec 2021 15:40:05 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mtedR-000JZo-9F; Sat, 04 Dec 2021 23:40:05 +0000
Date:   Sun, 5 Dec 2021 07:39:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH v2 net-next 02/23] lib: add tests for reference tracker
Message-ID: <202112050729.hISLa0oF-lkp@intel.com>
References: <20211203024640.1180745-3-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211203024640.1180745-3-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/net-add-preliminary-netdev-refcount-tracking/20211203-104930
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git fc993be36f9ea7fc286d84d8471a1a20e871aad4
config: nios2-allyesconfig (https://download.01.org/0day-ci/archive/20211205/202112050729.hISLa0oF-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/98ad7e89138f4176a549203b6e23c2dc1cb9581d
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-add-preliminary-netdev-refcount-tracking/20211203-104930
        git checkout 98ad7e89138f4176a549203b6e23c2dc1cb9581d
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nios2 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   lib/ref_tracker.c: In function 'ref_tracker_alloc':
>> lib/ref_tracker.c:80:22: error: implicit declaration of function 'stack_trace_save'; did you mean 'stack_depot_save'? [-Werror=implicit-function-declaration]
      80 |         nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
         |                      ^~~~~~~~~~~~~~~~
         |                      stack_depot_save
>> lib/ref_tracker.c:81:22: error: implicit declaration of function 'filter_irq_stacks' [-Werror=implicit-function-declaration]
      81 |         nr_entries = filter_irq_stacks(entries, nr_entries);
         |                      ^~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for REF_TRACKER
   Depends on STACKTRACE_SUPPORT
   Selected by
   - TEST_REF_TRACKER && RUNTIME_TESTING_MENU && DEBUG_KERNEL


vim +80 lib/ref_tracker.c

fc2d884275133c Eric Dumazet 2021-12-02  64  
fc2d884275133c Eric Dumazet 2021-12-02  65  int ref_tracker_alloc(struct ref_tracker_dir *dir,
fc2d884275133c Eric Dumazet 2021-12-02  66  		      struct ref_tracker **trackerp,
fc2d884275133c Eric Dumazet 2021-12-02  67  		      gfp_t gfp)
fc2d884275133c Eric Dumazet 2021-12-02  68  {
fc2d884275133c Eric Dumazet 2021-12-02  69  	unsigned long entries[REF_TRACKER_STACK_ENTRIES];
fc2d884275133c Eric Dumazet 2021-12-02  70  	struct ref_tracker *tracker;
fc2d884275133c Eric Dumazet 2021-12-02  71  	unsigned int nr_entries;
fc2d884275133c Eric Dumazet 2021-12-02  72  	unsigned long flags;
fc2d884275133c Eric Dumazet 2021-12-02  73  
fc2d884275133c Eric Dumazet 2021-12-02  74  	*trackerp = tracker = kzalloc(sizeof(*tracker), gfp | __GFP_NOFAIL);
fc2d884275133c Eric Dumazet 2021-12-02  75  	if (unlikely(!tracker)) {
fc2d884275133c Eric Dumazet 2021-12-02  76  		pr_err_once("memory allocation failure, unreliable refcount tracker.\n");
fc2d884275133c Eric Dumazet 2021-12-02  77  		refcount_inc(&dir->untracked);
fc2d884275133c Eric Dumazet 2021-12-02  78  		return -ENOMEM;
fc2d884275133c Eric Dumazet 2021-12-02  79  	}
fc2d884275133c Eric Dumazet 2021-12-02 @80  	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
fc2d884275133c Eric Dumazet 2021-12-02 @81  	nr_entries = filter_irq_stacks(entries, nr_entries);
fc2d884275133c Eric Dumazet 2021-12-02  82  	tracker->alloc_stack_handle = stack_depot_save(entries, nr_entries, gfp);
fc2d884275133c Eric Dumazet 2021-12-02  83  
fc2d884275133c Eric Dumazet 2021-12-02  84  	spin_lock_irqsave(&dir->lock, flags);
fc2d884275133c Eric Dumazet 2021-12-02  85  	list_add(&tracker->head, &dir->list);
fc2d884275133c Eric Dumazet 2021-12-02  86  	spin_unlock_irqrestore(&dir->lock, flags);
fc2d884275133c Eric Dumazet 2021-12-02  87  	return 0;
fc2d884275133c Eric Dumazet 2021-12-02  88  }
fc2d884275133c Eric Dumazet 2021-12-02  89  EXPORT_SYMBOL_GPL(ref_tracker_alloc);
fc2d884275133c Eric Dumazet 2021-12-02  90  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
