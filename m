Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8776A7425
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 20:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjCATTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 14:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCATTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 14:19:43 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23F123102;
        Wed,  1 Mar 2023 11:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677698382; x=1709234382;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6Nte7zMIlqadmJQfWLuZoBsbHq55nTuYQZ0k4cPzoHo=;
  b=CpIgu6dq6p0Ib7DtIhsjn//bqeQR+lCt/qQbAwIBLPyErNwzIW74pAxA
   tNmsNT+wsLJqTVawE3Liwpdx8b38vUJhg0lsx6g7oQ9pnkha9MX14pyjl
   hk/lNLLonfGiBIeOPtJiffWK7G6hJuMTL/z+gALbyxpblTD4o+xcFwdkJ
   hOecmVc1YFgzq/CGxSwh4+AJTbEIPZu4TkA3fU7/HD4So9lW3FJxsbRy1
   lhj+ZLY3hJfopvt/OzM403z+juJRc2Ig4Rax5MSeTEtpx2L/eU02KUYfK
   +DI+2KgM5e1iCjP/FPEtVkfZKtlHXo+rcSU58vGzsuHORUuxApkfDShfD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="420762638"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="420762638"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 11:19:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="848775944"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="848775944"
Received: from lkp-server01.sh.intel.com (HELO 3895f5c55ead) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 01 Mar 2023 11:19:35 -0800
Received: from kbuild by 3895f5c55ead with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pXRzA-0006MR-08;
        Wed, 01 Mar 2023 19:19:32 +0000
Date:   Thu, 2 Mar 2023 03:18:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 1/2] xdp: recycle Page Pool backed skbs built
 from XDP frames
Message-ID: <202303020342.Wi2PRFFH-lkp@intel.com>
References: <20230301160315.1022488-2-aleksander.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301160315.1022488-2-aleksander.lobakin@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Alexander-Lobakin/xdp-recycle-Page-Pool-backed-skbs-built-from-XDP-frames/20230302-000635
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/20230301160315.1022488-2-aleksander.lobakin%40intel.com
patch subject: [PATCH bpf-next v1 1/2] xdp: recycle Page Pool backed skbs built from XDP frames
config: x86_64-randconfig-a014 (https://download.01.org/0day-ci/archive/20230302/202303020342.Wi2PRFFH-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/a5ca5578e9bd35220be091fd02df96d492120ee3
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Alexander-Lobakin/xdp-recycle-Page-Pool-backed-skbs-built-from-XDP-frames/20230302-000635
        git checkout a5ca5578e9bd35220be091fd02df96d492120ee3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303020342.Wi2PRFFH-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/core/xdp.c:662:3: error: implicit declaration of function 'skb_mark_for_recycle' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
                   skb_mark_for_recycle(skb);
                   ^
   1 error generated.


vim +/skb_mark_for_recycle +662 net/core/xdp.c

   614	
   615	struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
   616						   struct sk_buff *skb,
   617						   struct net_device *dev)
   618	{
   619		struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
   620		unsigned int headroom, frame_size;
   621		void *hard_start;
   622		u8 nr_frags;
   623	
   624		/* xdp frags frame */
   625		if (unlikely(xdp_frame_has_frags(xdpf)))
   626			nr_frags = sinfo->nr_frags;
   627	
   628		/* Part of headroom was reserved to xdpf */
   629		headroom = sizeof(*xdpf) + xdpf->headroom;
   630	
   631		/* Memory size backing xdp_frame data already have reserved
   632		 * room for build_skb to place skb_shared_info in tailroom.
   633		 */
   634		frame_size = xdpf->frame_sz;
   635	
   636		hard_start = xdpf->data - headroom;
   637		skb = build_skb_around(skb, hard_start, frame_size);
   638		if (unlikely(!skb))
   639			return NULL;
   640	
   641		skb_reserve(skb, headroom);
   642		__skb_put(skb, xdpf->len);
   643		if (xdpf->metasize)
   644			skb_metadata_set(skb, xdpf->metasize);
   645	
   646		if (unlikely(xdp_frame_has_frags(xdpf)))
   647			xdp_update_skb_shared_info(skb, nr_frags,
   648						   sinfo->xdp_frags_size,
   649						   nr_frags * xdpf->frame_sz,
   650						   xdp_frame_is_frag_pfmemalloc(xdpf));
   651	
   652		/* Essential SKB info: protocol and skb->dev */
   653		skb->protocol = eth_type_trans(skb, dev);
   654	
   655		/* Optional SKB info, currently missing:
   656		 * - HW checksum info		(skb->ip_summed)
   657		 * - HW RX hash			(skb_set_hash)
   658		 * - RX ring dev queue index	(skb_record_rx_queue)
   659		 */
   660	
   661		if (xdpf->mem.type == MEM_TYPE_PAGE_POOL)
 > 662			skb_mark_for_recycle(skb);
   663	
   664		/* Allow SKB to reuse area used by xdp_frame */
   665		xdp_scrub_frame(xdpf);
   666	
   667		return skb;
   668	}
   669	EXPORT_SYMBOL_GPL(__xdp_build_skb_from_frame);
   670	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
