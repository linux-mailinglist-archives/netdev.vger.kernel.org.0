Return-Path: <netdev+bounces-11256-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C38DF7324A4
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 03:26:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E22528141C
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 01:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EADA536D;
	Fri, 16 Jun 2023 01:26:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0974627
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 01:26:08 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1C42972
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 18:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686878766; x=1718414766;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cjlcGYZ8Xdgh5i43lgiUoq0m7XD27amjOqI8fH+x5j8=;
  b=diWYFV8d12atYCW0H1OmhZ5vFiwbMBlLSWDbQwEcrTMQ3GD+sZ7KZVHh
   2Jh1Q/wDq/xiBwQyhhnRJGphC3i6asAGlIcoY+4g3N8AtMl8bL79Iqyu2
   bEufYaZBEAf6pybsBX4UuQOe+gT7KYULXxFGIqnCycS4B0z9XQO34LwET
   qfyEwEb63QlHGD10RWMlJzCD7Kp18hfvPzWHjQmw7MEFNbqF+eZwbyqir
   1eUfaS+SN7uIsS6JhvQiD5NZLHKzsGNQxm1UW32E3L57qZk/ncFxCMwi3
   h+cSNN7N2o4EQ4Rl4qLHTT23yLLmWfAM8Csq3JpOFJBjoTN9amSj0TNCi
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="348794275"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="348794275"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 18:26:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="715823734"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="715823734"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 15 Jun 2023 18:26:00 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q9yDv-0000cf-38;
	Fri, 16 Jun 2023 01:25:59 +0000
Date: Fri, 16 Jun 2023 09:25:18 +0800
From: kernel test robot <lkp@intel.com>
To: Arjun Roy <arjunroy.kdev@gmail.com>, netdev@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: Re: [net-next] tcp: Use per-vma locking for receive zerocopy
Message-ID: <202306160941.CgtiNISL-lkp@intel.com>
References: <20230615185516.3738855-2-arjunroy.kdev@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615185516.3738855-2-arjunroy.kdev@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Arjun,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Arjun-Roy/tcp-Use-per-vma-locking-for-receive-zerocopy/20230616-025823
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230615185516.3738855-2-arjunroy.kdev%40gmail.com
patch subject: [net-next] tcp: Use per-vma locking for receive zerocopy
config: s390-randconfig-r026-20230615 (https://download.01.org/0day-ci/archive/20230616/202306160941.CgtiNISL-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch net-next main
        git checkout net-next/main
        b4 shazam https://lore.kernel.org/r/20230615185516.3738855-2-arjunroy.kdev@gmail.com
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306160941.CgtiNISL-lkp@intel.com/

All errors (new ones prefixed by >>):

   s390x-linux-ld: mm/memory.o: in function `lock_vma_under_rcu':
>> memory.c:(.text+0x9784): undefined reference to `tcp_vm_ops'
   s390x-linux-ld: drivers/dma/qcom/hidma.o: in function `hidma_probe':
   hidma.c:(.text+0x3e): undefined reference to `devm_ioremap_resource'
   s390x-linux-ld: hidma.c:(.text+0x96): undefined reference to `devm_ioremap_resource'
   s390x-linux-ld: drivers/net/ethernet/altera/altera_tse_main.o: in function `altera_tse_probe':
   altera_tse_main.c:(.text+0x12c): undefined reference to `devm_ioremap'
   s390x-linux-ld: altera_tse_main.c:(.text+0x28a): undefined reference to `devm_ioremap'
   s390x-linux-ld: altera_tse_main.c:(.text+0x316): undefined reference to `devm_ioremap'
   s390x-linux-ld: drivers/net/ethernet/altera/altera_tse_main.o: in function `request_and_map':
   altera_tse_main.c:(.text+0x688): undefined reference to `devm_ioremap'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

