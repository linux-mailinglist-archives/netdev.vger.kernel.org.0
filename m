Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48524E1AF0
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 10:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241721AbiCTJtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 05:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236014AbiCTJtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 05:49:31 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B692CE04
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 02:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647769685; x=1679305685;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UqdaTFkzFl/PHrRJ5yS0OdlfjTMNGatLBjgtJie+eLY=;
  b=HSDShqptUOYeWbqwoagTkRaKiBYvWGxSYSuAYl9T2YMK0LyUhbHPuRCM
   ny9DSByzYWfI6dE+HEGFeMNbaYOLBiKjndrBrUkSOcaV0PEEgM91ecEMd
   YSGQyA2VfitNbiB7d/JIJwFDmScNHJva6TzbW+GLGnScfn5O3N9gsKmUH
   46oeZmoioEuhTDV/iJEEnwJvz9cAJv73D8tj8sTO7oWZdBgPeG3XV0TwJ
   S+al75sJ2Mum7AwPuK+6G1Q0038WTBoyN4qKnYoxK9Crjwj/x1/avvCqe
   Z32xzL1p4F3XDoQ8UGpyvQWZmhTaR3lZU133FyJ/U0Vylf0Z52fOi7FEc
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10291"; a="257314699"
X-IronPort-AV: E=Sophos;i="5.90,195,1643702400"; 
   d="scan'208";a="257314699"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2022 02:48:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,195,1643702400"; 
   d="scan'208";a="716113322"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 20 Mar 2022 02:48:02 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nVsAL-000GnD-Mu; Sun, 20 Mar 2022 09:48:01 +0000
Date:   Sun, 20 Mar 2022 17:47:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net-next 01/11] bnxt: refactor bnxt_rx_xdp to separate
 xdp_init_buff/xdp_prepare_buff
Message-ID: <202203201751.yZWkjAof-lkp@intel.com>
References: <1647759473-2414-2-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1647759473-2414-2-git-send-email-michael.chan@broadcom.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20220320/202203201751.yZWkjAof-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 85e9b2687a13d1908aa86d1b89c5ce398a06cd39)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/a00a69739b9d83e22d8fd2404e50a886e4e99944
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Michael-Chan/bnxt-Support-XDP-multi-buffer/20220320-150017
        git checkout a00a69739b9d83e22d8fd2404e50a886e4e99944
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/ethernet/broadcom/bnxt/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c:200:36: warning: variable 'mapping' is uninitialized when used here [-Wuninitialized]
                   dma_unmap_page_attrs(&pdev->dev, mapping,
                                                    ^~~~~~~
   drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c:145:20: note: initialize the variable 'mapping' to silence this warning
           dma_addr_t mapping;
                             ^
                              = 0
   1 warning generated.


vim +/mapping +200 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c

a00a69739b9d83 Andy Gospodarek     2022-03-20  133  
c6d30e8391b85e Michael Chan        2017-02-06  134  /* returns the following:
c6d30e8391b85e Michael Chan        2017-02-06  135   * true    - packet consumed by XDP and new buffer is allocated.
c6d30e8391b85e Michael Chan        2017-02-06  136   * false   - packet should be passed to the stack.
c6d30e8391b85e Michael Chan        2017-02-06  137   */
c6d30e8391b85e Michael Chan        2017-02-06  138  bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
a00a69739b9d83 Andy Gospodarek     2022-03-20  139  		 struct xdp_buff xdp, struct page *page, unsigned int *len, u8 *event)
c6d30e8391b85e Michael Chan        2017-02-06  140  {
c6d30e8391b85e Michael Chan        2017-02-06  141  	struct bpf_prog *xdp_prog = READ_ONCE(rxr->xdp_prog);
38413406277fd0 Michael Chan        2017-02-06  142  	struct bnxt_tx_ring_info *txr;
c6d30e8391b85e Michael Chan        2017-02-06  143  	struct bnxt_sw_rx_bd *rx_buf;
c6d30e8391b85e Michael Chan        2017-02-06  144  	struct pci_dev *pdev;
c6d30e8391b85e Michael Chan        2017-02-06  145  	dma_addr_t mapping;
c6d30e8391b85e Michael Chan        2017-02-06  146  	void *orig_data;
38413406277fd0 Michael Chan        2017-02-06  147  	u32 tx_avail;
c6d30e8391b85e Michael Chan        2017-02-06  148  	u32 offset;
c6d30e8391b85e Michael Chan        2017-02-06  149  	u32 act;
c6d30e8391b85e Michael Chan        2017-02-06  150  
c6d30e8391b85e Michael Chan        2017-02-06  151  	if (!xdp_prog)
c6d30e8391b85e Michael Chan        2017-02-06  152  		return false;
c6d30e8391b85e Michael Chan        2017-02-06  153  
c6d30e8391b85e Michael Chan        2017-02-06  154  	pdev = bp->pdev;
c6d30e8391b85e Michael Chan        2017-02-06  155  	offset = bp->rx_offset;
c6d30e8391b85e Michael Chan        2017-02-06  156  
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  157  	txr = rxr->bnapi->tx_ring;
43b5169d8355cc Lorenzo Bianconi    2020-12-22  158  	/* BNXT_RX_PAGE_MODE(bp) when XDP enabled */
c6d30e8391b85e Michael Chan        2017-02-06  159  	orig_data = xdp.data;
c6d30e8391b85e Michael Chan        2017-02-06  160  
c6d30e8391b85e Michael Chan        2017-02-06  161  	act = bpf_prog_run_xdp(xdp_prog, &xdp);
c6d30e8391b85e Michael Chan        2017-02-06  162  
38413406277fd0 Michael Chan        2017-02-06  163  	tx_avail = bnxt_tx_avail(bp, txr);
38413406277fd0 Michael Chan        2017-02-06  164  	/* If the tx ring is not full, we must not update the rx producer yet
38413406277fd0 Michael Chan        2017-02-06  165  	 * because we may still be transmitting on some BDs.
38413406277fd0 Michael Chan        2017-02-06  166  	 */
38413406277fd0 Michael Chan        2017-02-06  167  	if (tx_avail != bp->tx_ring_size)
38413406277fd0 Michael Chan        2017-02-06  168  		*event &= ~BNXT_RX_EVENT;
38413406277fd0 Michael Chan        2017-02-06  169  
b968e735c79767 Nikita V. Shirokov  2018-04-17  170  	*len = xdp.data_end - xdp.data;
a00a69739b9d83 Andy Gospodarek     2022-03-20  171  	if (orig_data != xdp.data)
c6d30e8391b85e Michael Chan        2017-02-06  172  		offset = xdp.data - xdp.data_hard_start;
a00a69739b9d83 Andy Gospodarek     2022-03-20  173  
c6d30e8391b85e Michael Chan        2017-02-06  174  	switch (act) {
c6d30e8391b85e Michael Chan        2017-02-06  175  	case XDP_PASS:
c6d30e8391b85e Michael Chan        2017-02-06  176  		return false;
c6d30e8391b85e Michael Chan        2017-02-06  177  
38413406277fd0 Michael Chan        2017-02-06  178  	case XDP_TX:
a00a69739b9d83 Andy Gospodarek     2022-03-20  179  		rx_buf = &rxr->rx_buf_ring[cons];
a00a69739b9d83 Andy Gospodarek     2022-03-20  180  		mapping = rx_buf->mapping - bp->rx_dma_offset;
a00a69739b9d83 Andy Gospodarek     2022-03-20  181  
932dbf83ba18bd Michael Chan        2017-04-04  182  		if (tx_avail < 1) {
38413406277fd0 Michael Chan        2017-02-06  183  			trace_xdp_exception(bp->dev, xdp_prog, act);
38413406277fd0 Michael Chan        2017-02-06  184  			bnxt_reuse_rx_data(rxr, cons, page);
38413406277fd0 Michael Chan        2017-02-06  185  			return true;
38413406277fd0 Michael Chan        2017-02-06  186  		}
38413406277fd0 Michael Chan        2017-02-06  187  
38413406277fd0 Michael Chan        2017-02-06  188  		*event = BNXT_TX_EVENT;
38413406277fd0 Michael Chan        2017-02-06  189  		dma_sync_single_for_device(&pdev->dev, mapping + offset, *len,
38413406277fd0 Michael Chan        2017-02-06  190  					   bp->rx_dir);
52c0609258658f Andy Gospodarek     2019-07-08  191  		__bnxt_xmit_xdp(bp, txr, mapping + offset, *len,
38413406277fd0 Michael Chan        2017-02-06  192  				NEXT_RX(rxr->rx_prod));
38413406277fd0 Michael Chan        2017-02-06  193  		bnxt_reuse_rx_data(rxr, cons, page);
38413406277fd0 Michael Chan        2017-02-06  194  		return true;
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  195  	case XDP_REDIRECT:
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  196  		/* if we are calling this here then we know that the
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  197  		 * redirect is coming from a frame received by the
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  198  		 * bnxt_en driver.
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  199  		 */
f18c2b77b2e4ee Andy Gospodarek     2019-07-08 @200  		dma_unmap_page_attrs(&pdev->dev, mapping,
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  201  				     PAGE_SIZE, bp->rx_dir,
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  202  				     DMA_ATTR_WEAK_ORDERING);
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  203  
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  204  		/* if we are unable to allocate a new buffer, abort and reuse */
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  205  		if (bnxt_alloc_rx_data(bp, rxr, rxr->rx_prod, GFP_ATOMIC)) {
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  206  			trace_xdp_exception(bp->dev, xdp_prog, act);
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  207  			bnxt_reuse_rx_data(rxr, cons, page);
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  208  			return true;
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  209  		}
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  210  
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  211  		if (xdp_do_redirect(bp->dev, &xdp, xdp_prog)) {
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  212  			trace_xdp_exception(bp->dev, xdp_prog, act);
322b87ca55f2f3 Andy Gospodarek     2019-07-08  213  			page_pool_recycle_direct(rxr->page_pool, page);
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  214  			return true;
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  215  		}
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  216  
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  217  		*event |= BNXT_REDIRECT_EVENT;
f18c2b77b2e4ee Andy Gospodarek     2019-07-08  218  		break;
c6d30e8391b85e Michael Chan        2017-02-06  219  	default:
c8064e5b4adac5 Paolo Abeni         2021-11-30  220  		bpf_warn_invalid_xdp_action(bp->dev, xdp_prog, act);
df561f6688fef7 Gustavo A. R. Silva 2020-08-23  221  		fallthrough;
c6d30e8391b85e Michael Chan        2017-02-06  222  	case XDP_ABORTED:
c6d30e8391b85e Michael Chan        2017-02-06  223  		trace_xdp_exception(bp->dev, xdp_prog, act);
df561f6688fef7 Gustavo A. R. Silva 2020-08-23  224  		fallthrough;
c6d30e8391b85e Michael Chan        2017-02-06  225  	case XDP_DROP:
c6d30e8391b85e Michael Chan        2017-02-06  226  		bnxt_reuse_rx_data(rxr, cons, page);
c6d30e8391b85e Michael Chan        2017-02-06  227  		break;
c6d30e8391b85e Michael Chan        2017-02-06  228  	}
c6d30e8391b85e Michael Chan        2017-02-06  229  	return true;
c6d30e8391b85e Michael Chan        2017-02-06  230  }
c6d30e8391b85e Michael Chan        2017-02-06  231  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
