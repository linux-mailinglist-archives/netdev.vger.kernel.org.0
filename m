Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CC56C2318
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 21:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjCTUqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 16:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjCTUqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 16:46:04 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D626448D;
        Mon, 20 Mar 2023 13:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679345162; x=1710881162;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oj8FCpgjJtzrtUXxb6wifpz4rftHlOYHuOur48CLjI0=;
  b=ZDiJFrwk8hr8zpyb+pjHmo0l4WLZhDfuGxqXeawKRr+HoGkuKM6mIZsY
   H/bMfKBB4m7EufN7CpZ5wL/1bE8qNsYsclbciY67yn5xeu0PsksSRng9/
   IprRLmAwzpbWkqpTFJpzYX7iBPLTy/dlEIesoEW/CPa3FcYiWIZTknsIp
   7aRGGLmoGidylBKGWNNcrn7hn8upa2rGDysj8sWOu0XX2WDgA+qWvesgk
   rRZRxL0maFSzZl/Dce4giO4rRrk/K03SclpLG9whCxn94ozD+dgVUrIWq
   W+WXU1bN5jXKss4AT4HubDNBB4f2a+whUb1vKh9oM4U92eSRJFxIP8dfH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="340322682"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="340322682"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 13:46:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="658505666"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="658505666"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 20 Mar 2023 13:45:57 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1peMOC-000BJC-1h;
        Mon, 20 Mar 2023 20:45:56 +0000
Date:   Tue, 21 Mar 2023 04:45:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kal Conley <kal.conley@dectris.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        netdev@vger.kernel.org, Kal Conley <kal.conley@dectris.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
Message-ID: <202303210408.FyhMgxME-lkp@intel.com>
References: <20230319195656.326701-2-kal.conley@dectris.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230319195656.326701-2-kal.conley@dectris.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kal,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf/master]
[also build test ERROR on next-20230320]
[cannot apply to bpf-next/master linus/master v6.3-rc3]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kal-Conley/xsk-Support-UMEM-chunk_size-PAGE_SIZE/20230320-035849
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git master
patch link:    https://lore.kernel.org/r/20230319195656.326701-2-kal.conley%40dectris.com
patch subject: [PATCH bpf-next 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
config: mips-randconfig-r011-20230320 (https://download.01.org/0day-ci/archive/20230321/202303210408.FyhMgxME-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install mips cross compiling tool for clang build
        # apt-get install binutils-mipsel-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/bbcc35c4ff807754bf61ef2c1f11195533e53de0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kal-Conley/xsk-Support-UMEM-chunk_size-PAGE_SIZE/20230320-035849
        git checkout bbcc35c4ff807754bf61ef2c1f11195533e53de0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=mips olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303210408.FyhMgxME-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/xdp/xsk.c:425:68: warning: '_Static_assert' with no message is a C2x extension [-Wc2x-extensions]
   _Static_assert(XDP_UMEM_MAX_CHUNK_SIZE / PAGE_SIZE <= MAX_SKB_FRAGS);
                                                                      ^
                                                                      , ""
   In file included from net/xdp/xsk.c:26:
   In file included from include/net/xdp_sock_drv.h:10:
>> include/net/xsk_buff_pool.h:179:43: error: call to '__compiletime_assert_494' declared with 'error' attribute: BUILD_BUG failed
           bool cross_pg = pool->hugetlb ? (addr & (HPAGE_SIZE - 1)) + len > HPAGE_SIZE :
                                                    ^
   arch/mips/include/asm/page.h:68:22: note: expanded from macro 'HPAGE_SIZE'
   #define HPAGE_SIZE      ({BUILD_BUG(); 0; })
                             ^
   include/linux/build_bug.h:59:21: note: expanded from macro 'BUILD_BUG'
   #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
                       ^
   include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
   #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                       ^
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/compiler_types.h:385:2: note: expanded from macro '_compiletime_assert'
           __compiletime_assert(condition, msg, prefix, suffix)
           ^
   include/linux/compiler_types.h:378:4: note: expanded from macro '__compiletime_assert'
                           prefix ## suffix();                             \
                           ^
   <scratch space>:191:1: note: expanded from here
   __compiletime_assert_494
   ^
   1 warning and 1 error generated.
--
   net/xdp/xdp_umem.c:23:52: warning: '_Static_assert' with no message is a C2x extension [-Wc2x-extensions]
   _Static_assert(XDP_UMEM_MIN_CHUNK_SIZE <= PAGE_SIZE);
                                                      ^
                                                      , ""
>> net/xdp/xdp_umem.c:24:43: error: statement expression not allowed at file scope
   _Static_assert(XDP_UMEM_MAX_CHUNK_SIZE <= HPAGE_SIZE);
                                             ^
   arch/mips/include/asm/page.h:68:20: note: expanded from macro 'HPAGE_SIZE'
   #define HPAGE_SIZE      ({BUILD_BUG(); 0; })
                           ^
   1 warning and 1 error generated.
--
>> net/xdp/xsk_buff_pool.c:378:28: error: call to '__compiletime_assert_507' declared with 'error' attribute: BUILD_BUG failed
           u32 page_size = hugetlb ? HPAGE_SIZE : PAGE_SIZE;
                                     ^
   arch/mips/include/asm/page.h:68:22: note: expanded from macro 'HPAGE_SIZE'
   #define HPAGE_SIZE      ({BUILD_BUG(); 0; })
                             ^
   include/linux/build_bug.h:59:21: note: expanded from macro 'BUILD_BUG'
   #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
                       ^
   include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
   #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                       ^
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/compiler_types.h:385:2: note: expanded from macro '_compiletime_assert'
           __compiletime_assert(condition, msg, prefix, suffix)
           ^
   include/linux/compiler_types.h:378:4: note: expanded from macro '__compiletime_assert'
                           prefix ## suffix();                             \
                           ^
   <scratch space>:82:1: note: expanded from here
   __compiletime_assert_507
   ^
   In file included from net/xdp/xsk_buff_pool.c:3:
   include/net/xsk_buff_pool.h:179:43: error: call to '__compiletime_assert_350' declared with 'error' attribute: BUILD_BUG failed
           bool cross_pg = pool->hugetlb ? (addr & (HPAGE_SIZE - 1)) + len > HPAGE_SIZE :
                                                    ^
   arch/mips/include/asm/page.h:68:22: note: expanded from macro 'HPAGE_SIZE'
   #define HPAGE_SIZE      ({BUILD_BUG(); 0; })
                             ^
   include/linux/build_bug.h:59:21: note: expanded from macro 'BUILD_BUG'
   #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
                       ^
   include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
   #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                       ^
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/compiler_types.h:385:2: note: expanded from macro '_compiletime_assert'
           __compiletime_assert(condition, msg, prefix, suffix)
           ^
   include/linux/compiler_types.h:378:4: note: expanded from macro '__compiletime_assert'
                           prefix ## suffix();                             \
                           ^
   <scratch space>:21:1: note: expanded from here
   __compiletime_assert_350
   ^
   In file included from net/xdp/xsk_buff_pool.c:3:
   include/net/xsk_buff_pool.h:179:43: error: call to '__compiletime_assert_350' declared with 'error' attribute: BUILD_BUG failed
   arch/mips/include/asm/page.h:68:22: note: expanded from macro 'HPAGE_SIZE'
   #define HPAGE_SIZE      ({BUILD_BUG(); 0; })
                             ^
   include/linux/build_bug.h:59:21: note: expanded from macro 'BUILD_BUG'
   #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
                       ^
   include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
   #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                       ^
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/compiler_types.h:385:2: note: expanded from macro '_compiletime_assert'
           __compiletime_assert(condition, msg, prefix, suffix)
           ^
   include/linux/compiler_types.h:378:4: note: expanded from macro '__compiletime_assert'
                           prefix ## suffix();                             \
                           ^
   <scratch space>:21:1: note: expanded from here
   __compiletime_assert_350
   ^
   3 errors generated.


vim +179 include/net/xsk_buff_pool.h

   175	
   176	static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
   177							 u64 addr, u32 len)
   178	{
 > 179		bool cross_pg = pool->hugetlb ? (addr & (HPAGE_SIZE - 1)) + len > HPAGE_SIZE :
   180						(addr & (PAGE_SIZE - 1)) + len > PAGE_SIZE;
   181	
   182		if (likely(!cross_pg))
   183			return false;
   184	
   185		if (pool->dma_pages_cnt) {
   186			return !(pool->dma_pages[addr >> PAGE_SHIFT] &
   187				 XSK_NEXT_PG_CONTIG_MASK);
   188		}
   189	
   190		/* skb path */
   191		return addr + len > pool->addrs_cnt;
   192	}
   193	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
