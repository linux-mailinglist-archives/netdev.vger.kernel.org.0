Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36344644DB
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 03:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345996AbhLACZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 21:25:28 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:54352 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346062AbhLACZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 21:25:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UywXgH9_1638325322;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0UywXgH9_1638325322)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 01 Dec 2021 10:22:03 +0800
Date:   Wed, 1 Dec 2021 10:22:02 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     kernel test robot <lkp@intel.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ursula Braun <ubraun@linux.ibm.com>
Cc:     kbuild-all@lists.01.org, Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net/smc: fix wrong list_del in smc_lgr_cleanup_early
Message-ID: <20211201022202.GB38461@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20211130151731.55951-1-dust.li@linux.alibaba.com>
 <202112010159.e2LA9rIR-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202112010159.e2LA9rIR-lkp@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 02:07:46AM +0800, kernel test robot wrote:
>Hi Dust,
>
>Thank you for the patch! Perhaps something to improve:
>
>[auto build test WARNING on net/master]
>
>url:    https://github.com/0day-ci/linux/commits/Dust-Li/net-smc-fix-wrong-list_del-in-smc_lgr_cleanup_early/20211130-232151
>base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 34d8778a943761121f391b7921f79a7adbe1feaf
>config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20211201/202112010159.e2LA9rIR-lkp@intel.com/config)
>compiler: arceb-elf-gcc (GCC) 11.2.0
>reproduce (this is a W=1 build):
>        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>        chmod +x ~/bin/make.cross
>        # https://github.com/0day-ci/linux/commit/9b9af6a458f20989d91478dc8e038325978e16d5
>        git remote add linux-review https://github.com/0day-ci/linux
>        git fetch --no-tags linux-review Dust-Li/net-smc-fix-wrong-list_del-in-smc_lgr_cleanup_early/20211130-232151
>        git checkout 9b9af6a458f20989d91478dc8e038325978e16d5
>        # save the config file to linux build tree
>        mkdir build_dir
>        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash net/smc/
>
>If you fix the issue, kindly add following tag as appropriate
>Reported-by: kernel test robot <lkp@intel.com>
>
>All warnings (new ones prefixed by >>):
>
>   net/smc/smc_core.c: In function 'smc_lgr_cleanup_early':
>>> net/smc/smc_core.c:628:27: warning: variable 'lgr_list' set but not used [-Wunused-but-set-variable]
>     628 |         struct list_head *lgr_list;
>         |                           ^~~~~~~~
Sorry, I will send a v2 to fix this.

>
>
>vim +/lgr_list +628 net/smc/smc_core.c
>
>8f9dde4bf230f5 Guvenc Gulce  2020-12-01  624  
>51e3dfa8906ace Ursula Braun  2020-02-25  625  void smc_lgr_cleanup_early(struct smc_connection *conn)
>51e3dfa8906ace Ursula Braun  2020-02-25  626  {
>51e3dfa8906ace Ursula Braun  2020-02-25  627  	struct smc_link_group *lgr = conn->lgr;
>9ec6bf19ec8bb1 Karsten Graul 2020-05-03 @628  	struct list_head *lgr_list;
>9ec6bf19ec8bb1 Karsten Graul 2020-05-03  629  	spinlock_t *lgr_lock;
>51e3dfa8906ace Ursula Braun  2020-02-25  630  
>51e3dfa8906ace Ursula Braun  2020-02-25  631  	if (!lgr)
>51e3dfa8906ace Ursula Braun  2020-02-25  632  		return;
>51e3dfa8906ace Ursula Braun  2020-02-25  633  
>51e3dfa8906ace Ursula Braun  2020-02-25  634  	smc_conn_free(conn);
>9ec6bf19ec8bb1 Karsten Graul 2020-05-03  635  	lgr_list = smc_lgr_list_head(lgr, &lgr_lock);
>9ec6bf19ec8bb1 Karsten Graul 2020-05-03  636  	spin_lock_bh(lgr_lock);
>9ec6bf19ec8bb1 Karsten Graul 2020-05-03  637  	/* do not use this link group for new connections */
>9b9af6a458f209 Dust Li       2021-11-30  638  	if (!list_empty(&lgr->list))
>9b9af6a458f209 Dust Li       2021-11-30  639  		list_del_init(&lgr->list);
>9ec6bf19ec8bb1 Karsten Graul 2020-05-03  640  	spin_unlock_bh(lgr_lock);
>f9aab6f2ce5761 Ursula Braun  2020-09-10  641  	__smc_lgr_terminate(lgr, true);
>51e3dfa8906ace Ursula Braun  2020-02-25  642  }
>51e3dfa8906ace Ursula Braun  2020-02-25  643  
>
>---
>0-DAY CI Kernel Test Service, Intel Corporation
>https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
