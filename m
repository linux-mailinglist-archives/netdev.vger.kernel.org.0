Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D9F5E77B9
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 11:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbiIWJz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 05:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbiIWJzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 05:55:49 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B9EED5CC
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 02:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663926947; x=1695462947;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IccdhpzzRA0KuM8v8tybNjLLJVkI2H98qmcDLInNCQw=;
  b=DPeIwddJaJmGBPSlhVyvv97lgjDVaugOJT57E++l283viSEplNC4acFh
   Kf15N6xvXdNBIMccKNqRWWdoOUYS09ynWUqfJfjoQAeIOoPFfWbrQEus8
   Sl4fmSpbK1/fdofIN8qKRlT/4WKTaP3RVPZxSvO+KEO6fSm7WRd/z0rDW
   44Y4cLNXnWTsL5rjlRSvM+44dBHPwPFydfUD1zrlUuKIdLqcastUphCLK
   d4x3Iopm5KlmSTqtBOOX4lvI10qGorxrbn85YIEbl05f8dqdT4rZ0ONS7
   NiannvomNk+f4Q98OVMfei2hFG/nBVgO589jwjEpj3IgO2pgn9nbuyddP
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="302004376"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="302004376"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 02:55:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="571325078"
Received: from lkp-server01.sh.intel.com (HELO c0a60f19fe7e) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 23 Sep 2022 02:55:45 -0700
Received: from kbuild by c0a60f19fe7e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1obfPM-0005YQ-0v;
        Fri, 23 Sep 2022 09:55:44 +0000
Date:   Fri, 23 Sep 2022 17:55:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander H Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net-next v2] net: skb: introduce and use a single page
 frag cache
Message-ID: <202209231747.KOTeKw3E-lkp@intel.com>
References: <162fe40c387cd395d633729fa4f2b5245531514a.1663879752.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162fe40c387cd395d633729fa4f2b5245531514a.1663879752.git.pabeni@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Paolo-Abeni/net-skb-introduce-and-use-a-single-page-frag-cache/20220923-050251
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 2b9977470b39e011ee5fbc01ca55411a7768fb9d
config: arc-randconfig-r043-20220922 (https://download.01.org/0day-ci/archive/20220923/202209231747.KOTeKw3E-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/40ceb68029b30e158de46d21f73d0439ab8c2277
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Paolo-Abeni/net-skb-introduce-and-use-a-single-page-frag-cache/20220923-050251
        git checkout 40ceb68029b30e158de46d21f73d0439ab8c2277
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   net/core/skbuff.c: In function '__napi_alloc_skb':
>> net/core/skbuff.c:677:44: error: 'struct page_frag_1k' has no member named 'pfmemalloc'
     677 |                 pfmemalloc = nc->page_small.pfmemalloc;
         |                                            ^


vim +677 net/core/skbuff.c

   621	
   622	/**
   623	 *	__napi_alloc_skb - allocate skbuff for rx in a specific NAPI instance
   624	 *	@napi: napi instance this buffer was allocated for
   625	 *	@len: length to allocate
   626	 *	@gfp_mask: get_free_pages mask, passed to alloc_skb and alloc_pages
   627	 *
   628	 *	Allocate a new sk_buff for use in NAPI receive.  This buffer will
   629	 *	attempt to allocate the head from a special reserved region used
   630	 *	only for NAPI Rx allocation.  By doing this we can save several
   631	 *	CPU cycles by avoiding having to disable and re-enable IRQs.
   632	 *
   633	 *	%NULL is returned if there is no free memory.
   634	 */
   635	struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
   636					 gfp_t gfp_mask)
   637	{
   638		struct napi_alloc_cache *nc;
   639		struct sk_buff *skb;
   640		bool pfmemalloc;
   641		void *data;
   642	
   643		DEBUG_NET_WARN_ON_ONCE(!in_softirq());
   644		len += NET_SKB_PAD + NET_IP_ALIGN;
   645	
   646		/* If requested length is either too small or too big,
   647		 * we use kmalloc() for skb->head allocation.
   648		 * When the small frag allocator is available, prefer it over kmalloc
   649		 * for small fragments
   650		 */
   651		if ((!NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) ||
   652		    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
   653		    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
   654			skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX | SKB_ALLOC_NAPI,
   655					  NUMA_NO_NODE);
   656			if (!skb)
   657				goto skb_fail;
   658			goto skb_success;
   659		}
   660	
   661		nc = this_cpu_ptr(&napi_alloc_cache);
   662	
   663		if (sk_memalloc_socks())
   664			gfp_mask |= __GFP_MEMALLOC;
   665	
   666		if (NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) {
   667			/* we are artificially inflating the allocation size, but
   668			 * that is not as bad as it may look like, as:
   669			 * - 'len' less then GRO_MAX_HEAD makes little sense
   670			 * - larger 'len' values lead to fragment size above 512 bytes
   671			 *   as per NAPI_HAS_SMALL_PAGE_FRAG definition
   672			 * - kmalloc would use the kmalloc-1k slab for such values
   673			 */
   674			len = SZ_1K;
   675	
   676			data = page_frag_alloc_1k(&nc->page_small, gfp_mask);
 > 677			pfmemalloc = nc->page_small.pfmemalloc;
   678		} else {
   679			len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
   680			len = SKB_DATA_ALIGN(len);
   681	
   682			data = page_frag_alloc(&nc->page, len, gfp_mask);
   683			pfmemalloc = nc->page.pfmemalloc;
   684		}
   685	
   686		if (unlikely(!data))
   687			return NULL;
   688	
   689		skb = __napi_build_skb(data, len);
   690		if (unlikely(!skb)) {
   691			skb_free_frag(data);
   692			return NULL;
   693		}
   694	
   695		if (pfmemalloc)
   696			skb->pfmemalloc = 1;
   697		skb->head_frag = 1;
   698	
   699	skb_success:
   700		skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
   701		skb->dev = napi->dev;
   702	
   703	skb_fail:
   704		return skb;
   705	}
   706	EXPORT_SYMBOL(__napi_alloc_skb);
   707	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
