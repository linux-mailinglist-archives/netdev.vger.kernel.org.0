Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638F351CE61
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388188AbiEFB7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388183AbiEFB7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:59:00 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3960CFFF
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 18:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651802119; x=1683338119;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VYh3t/xp0DZMnprLcLN9Qaa20uH8rVTUofBzr82Uzts=;
  b=JpwAtfCHU6LUrKxRusDB1x4I7MQBpiiMZHviYtoJ8UL+s9PalVN6ovFm
   G4FU1es28SlEm9rKrm8QfBBv8BDDmzT6O3oGt6Sw5eE0ui3mnWEdOPV+3
   gXiGZF80OWdFancrKG7jdLDKqlV94WwAFluWB5mnSygeQqWezuhgRe4yt
   Bv8RRPcKyrAfFVUandI8kCCFL3DD6F8FA4lonqohlZcENJAl/WKI9pEln
   cyWIc56pVPdGLJ45cuxztVqPC9hnSyb5UpUedBGvyuvHfWFwgk4fq7yFa
   C4tH8MLbkIdu8R2AcUv6TJtBfD+hb8+pX1u8dHTa5CvQ0wk++ULWb4l53
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="354750773"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="354750773"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 18:55:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="517802313"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 05 May 2022 18:55:15 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nmnBb-000CxX-6L;
        Fri, 06 May 2022 01:55:15 +0000
Date:   Fri, 6 May 2022 09:54:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Robert Hancock <robert.hancock@calian.com>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: Re: [PATCH net-next v3] net: axienet: Use NAPI for TX completion path
Message-ID: <202205060910.pO104P2e-lkp@intel.com>
References: <20220505203754.1905881-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505203754.1905881-1-robert.hancock@calian.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Robert,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Robert-Hancock/net-axienet-Use-NAPI-for-TX-completion-path/20220506-043932
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 1c1ed5a48411e1686997157c21633653fbe045c6
config: x86_64-randconfig-c007 (https://download.01.org/0day-ci/archive/20220506/202205060910.pO104P2e-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 5e004fb787698440a387750db7f8028e7cb14cfc)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/89eb9e692229a3af81eaf2f599781bfae3091e93
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Robert-Hancock/net-axienet-Use-NAPI-for-TX-completion-path/20220506-043932
        git checkout 89eb9e692229a3af81eaf2f599781bfae3091e93
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/ethernet/xilinx/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/xilinx/xilinx_axienet_main.c:765: warning: expecting prototype for axienet_start_xmit_done(). Prototype was for axienet_tx_poll() instead


vim +765 drivers/net/ethernet/xilinx/xilinx_axienet_main.c

bb193e3db8b86a Robert Hancock  2022-01-18  749  
ab365c3393664f Andre Przywara  2020-03-24  750  /**
ab365c3393664f Andre Przywara  2020-03-24  751   * axienet_start_xmit_done - Invoked once a transmit is completed by the
ab365c3393664f Andre Przywara  2020-03-24  752   * Axi DMA Tx channel.
89eb9e692229a3 Robert Hancock  2022-05-05  753   * @napi:	Pointer to NAPI structure.
89eb9e692229a3 Robert Hancock  2022-05-05  754   * @budget:	Max number of TX packets to process.
89eb9e692229a3 Robert Hancock  2022-05-05  755   *
89eb9e692229a3 Robert Hancock  2022-05-05  756   * Return: Number of TX packets processed.
ab365c3393664f Andre Przywara  2020-03-24  757   *
89eb9e692229a3 Robert Hancock  2022-05-05  758   * This function is invoked from the NAPI processing to notify the completion
ab365c3393664f Andre Przywara  2020-03-24  759   * of transmit operation. It clears fields in the corresponding Tx BDs and
ab365c3393664f Andre Przywara  2020-03-24  760   * unmaps the corresponding buffer so that CPU can regain ownership of the
ab365c3393664f Andre Przywara  2020-03-24  761   * buffer. It finally invokes "netif_wake_queue" to restart transmission if
ab365c3393664f Andre Przywara  2020-03-24  762   * required.
ab365c3393664f Andre Przywara  2020-03-24  763   */
89eb9e692229a3 Robert Hancock  2022-05-05  764  static int axienet_tx_poll(struct napi_struct *napi, int budget)
ab365c3393664f Andre Przywara  2020-03-24 @765  {
89eb9e692229a3 Robert Hancock  2022-05-05  766  	struct axienet_local *lp = container_of(napi, struct axienet_local, napi_tx);
89eb9e692229a3 Robert Hancock  2022-05-05  767  	struct net_device *ndev = lp->ndev;
ab365c3393664f Andre Przywara  2020-03-24  768  	u32 size = 0;
89eb9e692229a3 Robert Hancock  2022-05-05  769  	int packets;
ab365c3393664f Andre Przywara  2020-03-24  770  
89eb9e692229a3 Robert Hancock  2022-05-05  771  	packets = axienet_free_tx_chain(lp, lp->tx_bd_ci, budget, false, &size, budget);
ab365c3393664f Andre Przywara  2020-03-24  772  
89eb9e692229a3 Robert Hancock  2022-05-05  773  	if (packets) {
ab365c3393664f Andre Przywara  2020-03-24  774  		lp->tx_bd_ci += packets;
ab365c3393664f Andre Przywara  2020-03-24  775  		if (lp->tx_bd_ci >= lp->tx_bd_num)
89eb9e692229a3 Robert Hancock  2022-05-05  776  			lp->tx_bd_ci %= lp->tx_bd_num;
ab365c3393664f Andre Przywara  2020-03-24  777  
8a3b7a252dca9f Daniel Borkmann 2012-01-19  778  		ndev->stats.tx_packets += packets;
8a3b7a252dca9f Daniel Borkmann 2012-01-19  779  		ndev->stats.tx_bytes += size;
7de44285c1f69c Robert Hancock  2019-06-06  780  
7de44285c1f69c Robert Hancock  2019-06-06  781  		/* Matches barrier in axienet_start_xmit */
7de44285c1f69c Robert Hancock  2019-06-06  782  		smp_mb();
7de44285c1f69c Robert Hancock  2019-06-06  783  
bb193e3db8b86a Robert Hancock  2022-01-18  784  		if (!axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1))
8a3b7a252dca9f Daniel Borkmann 2012-01-19  785  			netif_wake_queue(ndev);
8a3b7a252dca9f Daniel Borkmann 2012-01-19  786  	}
8a3b7a252dca9f Daniel Borkmann 2012-01-19  787  
89eb9e692229a3 Robert Hancock  2022-05-05  788  	if (packets < budget && napi_complete_done(napi, packets)) {
89eb9e692229a3 Robert Hancock  2022-05-05  789  		/* Re-enable TX completion interrupts. This should
89eb9e692229a3 Robert Hancock  2022-05-05  790  		 * cause an immediate interrupt if any TX packets are
89eb9e692229a3 Robert Hancock  2022-05-05  791  		 * already pending.
89eb9e692229a3 Robert Hancock  2022-05-05  792  		 */
89eb9e692229a3 Robert Hancock  2022-05-05  793  		axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, lp->tx_dma_cr);
89eb9e692229a3 Robert Hancock  2022-05-05  794  	}
89eb9e692229a3 Robert Hancock  2022-05-05  795  	return packets;
89eb9e692229a3 Robert Hancock  2022-05-05  796  }
89eb9e692229a3 Robert Hancock  2022-05-05  797  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
