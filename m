Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8931D6C0848
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 02:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbjCTBJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 21:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbjCTBIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 21:08:48 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBD315CB0;
        Sun, 19 Mar 2023 18:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679274040; x=1710810040;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=smOBfRVqrOhWu8XvcIR133OdyNbI2Ln/Zggu1BX7YS8=;
  b=OG2VMp5nb9Uuu9Orp85uxBOlJ0OXP8P9cAbEjCT2zrDYDBchyY6eAzH/
   E6k9wr5lsSmlybnCH1aJsXwKkp+5XpoxIwBy6Pn5JgjKsh/7hvtduM+u1
   UYi7U+1fLRtJN3268ChLL9EIAHBQ6hCblJ4LxEQTw/xJtdB9k6wxHg3R+
   2TaucFWNme21HKRwVuNOhMJnq9hzJGT96OdIaXHYhcno72qx1694ds8kb
   mPzGWmN20Lk8rLdg/Q7EcgquYmcxUdr2moR3cwoQKZWJIhM1fkMUCPnuM
   ti1lI/EyARicGPRol61ZGU7v9V2LJbHq4dUNVWm0RMx3RbLg28KqPB4NK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="326921316"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="326921316"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 17:59:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="630939113"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="630939113"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 19 Mar 2023 17:59:26 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pe3rw-000AjO-3C;
        Mon, 20 Mar 2023 00:59:24 +0000
Date:   Mon, 20 Mar 2023 08:58:51 +0800
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
Message-ID: <202303200837.DNorzOFV-lkp@intel.com>
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
[also build test ERROR on next-20230317]
[cannot apply to bpf-next/master linus/master v6.3-rc3]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kal-Conley/xsk-Support-UMEM-chunk_size-PAGE_SIZE/20230320-035849
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git master
patch link:    https://lore.kernel.org/r/20230319195656.326701-2-kal.conley%40dectris.com
patch subject: [PATCH bpf-next 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
config: arm-mvebu_v5_defconfig (https://download.01.org/0day-ci/archive/20230320/202303200837.DNorzOFV-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/intel-lab-lkp/linux/commit/bbcc35c4ff807754bf61ef2c1f11195533e53de0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kal-Conley/xsk-Support-UMEM-chunk_size-PAGE_SIZE/20230320-035849
        git checkout bbcc35c4ff807754bf61ef2c1f11195533e53de0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303200837.DNorzOFV-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from net/core/xdp.c:22:
   In file included from include/net/xdp_sock_drv.h:10:
>> include/net/xsk_buff_pool.h:179:43: error: use of undeclared identifier 'HPAGE_SIZE'
           bool cross_pg = pool->hugetlb ? (addr & (HPAGE_SIZE - 1)) + len > HPAGE_SIZE :
                                                    ^
   include/net/xsk_buff_pool.h:179:68: error: use of undeclared identifier 'HPAGE_SIZE'
           bool cross_pg = pool->hugetlb ? (addr & (HPAGE_SIZE - 1)) + len > HPAGE_SIZE :
                                                                             ^
   2 errors generated.


vim +/HPAGE_SIZE +179 include/net/xsk_buff_pool.h

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
