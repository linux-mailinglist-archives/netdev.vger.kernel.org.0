Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1582463DBE
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 19:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245436AbhK3SZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 13:25:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:22001 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245437AbhK3SZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 13:25:16 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="233787711"
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="233787711"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 10:08:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="676931116"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2021 10:08:03 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1ms7Xu-000Dc3-Ao; Tue, 30 Nov 2021 18:08:02 +0000
Date:   Wed, 1 Dec 2021 02:07:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dust Li <dust.li@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ursula Braun <ubraun@linux.ibm.com>
Cc:     kbuild-all@lists.01.org, Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net/smc: fix wrong list_del in smc_lgr_cleanup_early
Message-ID: <202112010159.e2LA9rIR-lkp@intel.com>
References: <20211130151731.55951-1-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211130151731.55951-1-dust.li@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dust,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]

url:    https://github.com/0day-ci/linux/commits/Dust-Li/net-smc-fix-wrong-list_del-in-smc_lgr_cleanup_early/20211130-232151
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 34d8778a943761121f391b7921f79a7adbe1feaf
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20211201/202112010159.e2LA9rIR-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/9b9af6a458f20989d91478dc8e038325978e16d5
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Dust-Li/net-smc-fix-wrong-list_del-in-smc_lgr_cleanup_early/20211130-232151
        git checkout 9b9af6a458f20989d91478dc8e038325978e16d5
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash net/smc/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/smc/smc_core.c: In function 'smc_lgr_cleanup_early':
>> net/smc/smc_core.c:628:27: warning: variable 'lgr_list' set but not used [-Wunused-but-set-variable]
     628 |         struct list_head *lgr_list;
         |                           ^~~~~~~~


vim +/lgr_list +628 net/smc/smc_core.c

8f9dde4bf230f5 Guvenc Gulce  2020-12-01  624  
51e3dfa8906ace Ursula Braun  2020-02-25  625  void smc_lgr_cleanup_early(struct smc_connection *conn)
51e3dfa8906ace Ursula Braun  2020-02-25  626  {
51e3dfa8906ace Ursula Braun  2020-02-25  627  	struct smc_link_group *lgr = conn->lgr;
9ec6bf19ec8bb1 Karsten Graul 2020-05-03 @628  	struct list_head *lgr_list;
9ec6bf19ec8bb1 Karsten Graul 2020-05-03  629  	spinlock_t *lgr_lock;
51e3dfa8906ace Ursula Braun  2020-02-25  630  
51e3dfa8906ace Ursula Braun  2020-02-25  631  	if (!lgr)
51e3dfa8906ace Ursula Braun  2020-02-25  632  		return;
51e3dfa8906ace Ursula Braun  2020-02-25  633  
51e3dfa8906ace Ursula Braun  2020-02-25  634  	smc_conn_free(conn);
9ec6bf19ec8bb1 Karsten Graul 2020-05-03  635  	lgr_list = smc_lgr_list_head(lgr, &lgr_lock);
9ec6bf19ec8bb1 Karsten Graul 2020-05-03  636  	spin_lock_bh(lgr_lock);
9ec6bf19ec8bb1 Karsten Graul 2020-05-03  637  	/* do not use this link group for new connections */
9b9af6a458f209 Dust Li       2021-11-30  638  	if (!list_empty(&lgr->list))
9b9af6a458f209 Dust Li       2021-11-30  639  		list_del_init(&lgr->list);
9ec6bf19ec8bb1 Karsten Graul 2020-05-03  640  	spin_unlock_bh(lgr_lock);
f9aab6f2ce5761 Ursula Braun  2020-09-10  641  	__smc_lgr_terminate(lgr, true);
51e3dfa8906ace Ursula Braun  2020-02-25  642  }
51e3dfa8906ace Ursula Braun  2020-02-25  643  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
