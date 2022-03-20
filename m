Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56CB4E1B19
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 11:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244096AbiCTKtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 06:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241502AbiCTKtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 06:49:32 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D462CD3
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 03:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647773286; x=1679309286;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GEh4lqkvNvHxXEzdBkA6/xpiAYOeW7RsnYoRHrITa7c=;
  b=MxTs5F753RDi0twLY/TR7/SMzi2VD0Tf5eT8c0D+EOSW/PpJQNisb3RP
   zN6QhrfHdY82/27CltWCm05SxZXwYbMBnKKEC7+/f9X5oykKr6bMwc+P0
   pjy7HITvMGXuAWwQq8CYe6TbhEwlkeinWo6+bWl3xdIq529QaHcTjL/Zu
   Z7GU+aPn4n5urW9LbJ5sZ0UahgIWMfHIrMEc+8iqfzDQc+bpXKoQD8PGP
   CioAyqM5Etaz/cE6+1MHoY1gU38HntYsRqd/RIfrC5XSWpYvwJjru76Rp
   7DdPPvDaVy2U2imjCpC7m7QXaTpUixE97f96//YB9sSg21aFUVol0kM7X
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10291"; a="254948632"
X-IronPort-AV: E=Sophos;i="5.90,195,1643702400"; 
   d="scan'208";a="254948632"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2022 03:48:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,195,1643702400"; 
   d="scan'208";a="648227243"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 20 Mar 2022 03:48:03 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nVt6Q-000Gpd-Rt; Sun, 20 Mar 2022 10:48:02 +0000
Date:   Sun, 20 Mar 2022 18:47:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net-next 10/11] bnxt: support transmit and free of
 aggregation buffers
Message-ID: <202203201851.iT6RBOWK-lkp@intel.com>
References: <1647759473-2414-11-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1647759473-2414-11-git-send-email-michael.chan@broadcom.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Michael-Chan/bnxt-Support-XDP-multi-buffer/20220320-150017
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 092d992b76ed9d06389af0bc5efd5279d7b1ed9f
config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20220320/202203201851.iT6RBOWK-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 85e9b2687a13d1908aa86d1b89c5ce398a06cd39)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/01029de5d079c1271b0cdd6f64a6ee7132b1872f
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Michael-Chan/bnxt-Support-XDP-multi-buffer/20220320-150017
        git checkout 01029de5d079c1271b0cdd6f64a6ee7132b1872f
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/ethernet/broadcom/bnxt/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c:203:6: warning: variable 'shinfo' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
           if (xdp)
               ^~~
   drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c:206:18: note: uninitialized use occurs here
           for (i = 0; i < shinfo->nr_frags; i++) {
                           ^~~~~~
   drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c:203:2: note: remove the 'if' if its condition is always true
           if (xdp)
           ^~~~~~~~
   drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c:200:32: note: initialize the variable 'shinfo' to silence this warning
           struct skb_shared_info *shinfo;
                                         ^
                                          = NULL
   drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c:291:36: warning: variable 'mapping' is uninitialized when used here [-Wuninitialized]
                   dma_unmap_page_attrs(&pdev->dev, mapping,
                                                    ^~~~~~~
   drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c:225:20: note: initialize the variable 'mapping' to silence this warning
           dma_addr_t mapping;
                             ^
                              = 0
   2 warnings generated.


vim +203 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c

   196	
   197	void bnxt_xdp_buff_frags_free(struct bnxt_rx_ring_info *rxr,
   198				      struct xdp_buff *xdp)
   199	{
   200		struct skb_shared_info *shinfo;
   201		int i;
   202	
 > 203		if (xdp)
   204			shinfo = xdp_get_shared_info_from_buff(xdp);
   205	
   206		for (i = 0; i < shinfo->nr_frags; i++) {
   207			struct page *page = skb_frag_page(&shinfo->frags[i]);
   208	
   209			page_pool_recycle_direct(rxr->page_pool, page);
   210		}
   211		shinfo->nr_frags = 0;
   212	}
   213	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
