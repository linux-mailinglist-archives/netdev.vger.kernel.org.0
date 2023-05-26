Return-Path: <netdev+bounces-5784-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5247712BD4
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:34:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CDB61C20C79
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0023228C37;
	Fri, 26 May 2023 17:34:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA31F2CA6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:34:45 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81040A4;
	Fri, 26 May 2023 10:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685122484; x=1716658484;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aBPytJReVH8Ulrvcrruu/P0Ev+N0fGdkCGCZ+F2RSsI=;
  b=Ww3Mu8d7J2CMp7BzdH1WlNB5lxPsEJZVKaDFrlD6DQqz0xbkIeZucTRY
   hKrScSPU0wthH4QIiSiZP38LC4GGtwfslhueKanxWHTBKgAwCvXKtHm8/
   AOIQuWnE/3UU19YNddiHwqHIHSri+hDBgX5R/IjI31gHpPIbqohwjE5JA
   +nmJxzWdlcLhICL6tVeoleF1xTK4zYlCTYk/Xc6nJhosnufdET6vtiL8+
   4AOWwkGdWfQRhlBCkxnJHvkfiS/TFRftpwI6puvXX52znKhPShv5yMRG4
   j98CjnDIoUUbDCtjQW0D0VHrWLT3lBjq2Htf7Q5ZS+PD6MaNXInnIN0Cf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10722"; a="354273886"
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="354273886"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 10:34:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10722"; a="879610852"
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="879610852"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 26 May 2023 10:34:40 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q2bKp-000JVc-2N;
	Fri, 26 May 2023 17:34:39 +0000
Date: Sat, 27 May 2023 01:34:01 +0800
From: kernel test robot <lkp@intel.com>
To: Liang Chen <liangchen.linux@gmail.com>, jasowang@redhat.com,
	mst@redhat.com
Cc: oe-kbuild-all@lists.linux.dev,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com,
	kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
	pabeni@redhat.com, alexander.duyck@gmail.com,
	Liang Chen <liangchen.linux@gmail.com>
Subject: Re: [PATCH net-next 5/5] virtio_net: Implement DMA pre-handler
Message-ID: <202305270110.TbNSDh0Z-lkp@intel.com>
References: <20230526054621.18371-5-liangchen.linux@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526054621.18371-5-liangchen.linux@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Liang,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Liang-Chen/virtio_net-Add-page_pool-support-to-improve-performance/20230526-135805
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230526054621.18371-5-liangchen.linux%40gmail.com
patch subject: [PATCH net-next 5/5] virtio_net: Implement DMA pre-handler
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20230527/202305270110.TbNSDh0Z-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/e968bb5cacd30b672d0ccf705a24f1a792ff45aa
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Liang-Chen/virtio_net-Add-page_pool-support-to-improve-performance/20230526-135805
        git checkout e968bb5cacd30b672d0ccf705a24f1a792ff45aa
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 ~/bin/make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 ~/bin/make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202305270110.TbNSDh0Z-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "iommu_get_dma_domain" [drivers/net/virtio_net.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

