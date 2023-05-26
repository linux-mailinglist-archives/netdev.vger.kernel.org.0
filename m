Return-Path: <netdev+bounces-5792-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D429C712C03
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:44:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89F651C20B81
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0030290E5;
	Fri, 26 May 2023 17:44:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DE9271F6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:44:45 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6DFA4;
	Fri, 26 May 2023 10:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685123084; x=1716659084;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x5pHN9VZUDdP2TLxPCWhN/t1BZUONMIrFg5l5cvTays=;
  b=iumDFVZi7C80j6evW6iF0RKqad73FursD70v3leNkSM9R/swmRsZtacA
   GI59VxuTAHyVoKzWWueAiltYGwmSooOapOedX4iDqdBMmb9KlgyVIfi86
   AuxWod5EHeZkaL+lyVM4AkAWEssL2tiZS1zm7SNTRpRvTdGn83q91fvWO
   bmqBp+Mf3uVsZVdGbWo2KH4kC32ei3BtUAqMrYg8libwgRpQ+1eBpsc4j
   r91k5ksf1SK9myYf6v3iOIsGasbpfx2ORxTJKP7adTp5CBdfcm6h3n7lK
   511WjJFydYB/XIMHCCnR/yaROsSn/A3Tjw0ZMVwL67TGC7pdZ4K8k+UlX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10722"; a="417745392"
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="417745392"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 10:44:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10722"; a="775163669"
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="775163669"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 26 May 2023 10:44:40 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q2bUV-000JVq-2o;
	Fri, 26 May 2023 17:44:39 +0000
Date: Sat, 27 May 2023 01:44:27 +0800
From: kernel test robot <lkp@intel.com>
To: Liang Chen <liangchen.linux@gmail.com>, jasowang@redhat.com,
	mst@redhat.com
Cc: oe-kbuild-all@lists.linux.dev,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com,
	kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
	pabeni@redhat.com, alexander.duyck@gmail.com,
	Liang Chen <liangchen.linux@gmail.com>
Subject: Re: [PATCH net-next 3/5] virtio_net: Add page pool fragmentation
 support
Message-ID: <202305270116.TJ31IjNL-lkp@intel.com>
References: <20230526054621.18371-3-liangchen.linux@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526054621.18371-3-liangchen.linux@gmail.com>
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
patch link:    https://lore.kernel.org/r/20230526054621.18371-3-liangchen.linux%40gmail.com
patch subject: [PATCH net-next 3/5] virtio_net: Add page pool fragmentation support
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20230527/202305270116.TJ31IjNL-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/dda0469e059354b61192e1d25b77c57351346282
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Liang-Chen/virtio_net-Add-page_pool-support-to-improve-performance/20230526-135805
        git checkout dda0469e059354b61192e1d25b77c57351346282
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202305270116.TJ31IjNL-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: vmlinux.o: in function `virtnet_find_vqs':
   virtio_net.c:(.text+0x901fd2): undefined reference to `page_pool_create'
   ld: vmlinux.o: in function `add_recvbuf_mergeable.isra.0':
   virtio_net.c:(.text+0x905662): undefined reference to `page_pool_alloc_pages'
>> ld: virtio_net.c:(.text+0x905715): undefined reference to `page_pool_alloc_frag'
   ld: vmlinux.o: in function `xdp_linearize_page':
   virtio_net.c:(.text+0x906c50): undefined reference to `page_pool_alloc_pages'
   ld: virtio_net.c:(.text+0x906e33): undefined reference to `page_pool_alloc_frag'
   ld: vmlinux.o: in function `mergeable_xdp_get_buf.isra.0':
>> virtio_net.c:(.text+0x90740e): undefined reference to `page_pool_alloc_frag'
>> ld: virtio_net.c:(.text+0x90750b): undefined reference to `page_pool_alloc_pages'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

