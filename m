Return-Path: <netdev+bounces-5755-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5724A712A70
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:16:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0AC9E1C20FFD
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11C1927727;
	Fri, 26 May 2023 16:16:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C4A742EE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:16:52 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359B5BC;
	Fri, 26 May 2023 09:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685117811; x=1716653811;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tFle62zzOw130eAw0UDs1o1U+rbjQMuBYyQ/MfXYpg0=;
  b=VCu1WMMA6skKYPwsxaNpw7jflC1BcclZtiHxbBpsBeIxrVRYefMFyzst
   hMUK6KJoT/tNkwjomkz6lH0LjXcpnbV8GvVWF+kjyBEeZXRKagx5Ys7pS
   Vuq3h48ZwsGHek+IRvcR4OSsA5EOHGNZXZP8hQXpVtrIj3+gBxuuKLb51
   ggJQIyswJ0WX7+UgKjXuyY1VsHd6n0GkWlvuqTWCbyV1HIDTAGkBySocc
   Mbh/KaYriOkBNNVDbYaZeSav4hGJC+IM8VwYqEp/4Uc93+nqXxUYxhsB8
   D6vQkbFzbWK6+0P9yYW14bzJ/ab4kckYGez6HRjl1/fIdFqqUE+2wGHn7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10722"; a="334593844"
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="334593844"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 09:11:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10722"; a="770387608"
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="770387608"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 26 May 2023 09:11:36 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q2a2S-000JRq-0F;
	Fri, 26 May 2023 16:11:36 +0000
Date: Sat, 27 May 2023 00:11:25 +0800
From: kernel test robot <lkp@intel.com>
To: Liang Chen <liangchen.linux@gmail.com>, jasowang@redhat.com,
	mst@redhat.com
Cc: oe-kbuild-all@lists.linux.dev,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com,
	kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
	pabeni@redhat.com, alexander.duyck@gmail.com,
	Liang Chen <liangchen.linux@gmail.com>
Subject: Re: [PATCH net-next 2/5] virtio_net: Add page_pool support to
 improve performance
Message-ID: <202305262334.GiFQ3wpG-lkp@intel.com>
References: <20230526054621.18371-2-liangchen.linux@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526054621.18371-2-liangchen.linux@gmail.com>
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
patch link:    https://lore.kernel.org/r/20230526054621.18371-2-liangchen.linux%40gmail.com
patch subject: [PATCH net-next 2/5] virtio_net: Add page_pool support to improve performance
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20230526/202305262334.GiFQ3wpG-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/bfba563f43bba37181d8502cb2e566c32f96ec9e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Liang-Chen/virtio_net-Add-page_pool-support-to-improve-performance/20230526-135805
        git checkout bfba563f43bba37181d8502cb2e566c32f96ec9e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202305262334.GiFQ3wpG-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: vmlinux.o: in function `virtnet_find_vqs':
>> virtio_net.c:(.text+0x901fb5): undefined reference to `page_pool_create'
   ld: vmlinux.o: in function `add_recvbuf_mergeable.isra.0':
>> virtio_net.c:(.text+0x905618): undefined reference to `page_pool_alloc_pages'
   ld: vmlinux.o: in function `xdp_linearize_page':
   virtio_net.c:(.text+0x906b6b): undefined reference to `page_pool_alloc_pages'
   ld: vmlinux.o: in function `mergeable_xdp_get_buf.isra.0':
   virtio_net.c:(.text+0x90728f): undefined reference to `page_pool_alloc_pages'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

