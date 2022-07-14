Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7715757BB
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 00:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239063AbiGNWkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 18:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiGNWky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 18:40:54 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747EB6EE80;
        Thu, 14 Jul 2022 15:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657838453; x=1689374453;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Jp0uvkMpsUVFDNDNVRFxzBaquhMpCq7aL2kVSbO/unQ=;
  b=RRMIIi+Foiz/cjilavLKS0W0hyGpiua4pWzKD/PigcxB9zPaUHYKgcD/
   tgQ2RWmonn02X+alr9pSNwjfIk/YX4UfdWQ412jc+pXZPRwJp0fVdlmMc
   Y5vP5Y9w9/KGdm1Rudswi1OsbHRnKA5vPrD+CgTM393QOjbU7nxQkjKyY
   LJPGOobqtzco5eCSM+s2eKSbzDPwJRhM6heWSAfqPCOSjg/ACeoW/SMDn
   vJYS0o07IF1PZXRB2aMPddvVp3BqCa9+4gw3KCIWEk9sQuvpg1E0gxjKm
   in3brh8WGHFVAkoHozY4ubbxDmgcxBmCyOrp1urdOd1YrRXQqjq05gQxX
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="284400538"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="284400538"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 15:40:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="596254886"
Received: from lkp-server01.sh.intel.com (HELO fd2c14d642b4) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 14 Jul 2022 15:40:48 -0700
Received: from kbuild by fd2c14d642b4 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oC7Vn-0001EP-A0;
        Thu, 14 Jul 2022 22:40:47 +0000
Date:   Fri, 15 Jul 2022 06:40:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Biao Huang <biao.huang@mediatek.com>,
        David Miller <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Biao Huang <biao.huang@mediatek.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, macpaul.lin@mediatek.com,
        Jisheng Zhang <jszhang@kernel.org>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Subject: Re: [PATCH net v4 3/3] net: stmmac: fix unbalanced ptp clock issue
 in suspend/resume flow
Message-ID: <202207150612.B3phHNEY-lkp@intel.com>
References: <20220713101002.10970-4-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713101002.10970-4-biao.huang@mediatek.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Biao,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Biao-Huang/stmmac-dwmac-mediatek-fix-clock-issue/20220713-181044
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 22b9c41a3fb8ef4624bcda312665937d2ba98aa7
config: x86_64-randconfig-a016 (https://download.01.org/0day-ci/archive/20220715/202207150612.B3phHNEY-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 5e61b9c556267086ef9b743a0b57df302eef831b)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f145c999bcff52c22cc849bf17f2b30c5e991c0a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Biao-Huang/stmmac-dwmac-mediatek-fix-clock-issue/20220713-181044
        git checkout f145c999bcff52c22cc849bf17f2b30c5e991c0a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/ethernet/stmicro/stmmac/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:837:6: warning: unused variable 'ret' [-Wunused-variable]
           int ret;
               ^
   1 warning generated.


vim +/ret +837 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c

891434b18ec0a2 Rayagond Kokatanur 2013-03-26  820  
a6da2bbb0005e6 Holger Assmann     2021-11-21  821  /**
a6da2bbb0005e6 Holger Assmann     2021-11-21  822   * stmmac_init_tstamp_counter - init hardware timestamping counter
a6da2bbb0005e6 Holger Assmann     2021-11-21  823   * @priv: driver private structure
a6da2bbb0005e6 Holger Assmann     2021-11-21  824   * @systime_flags: timestamping flags
a6da2bbb0005e6 Holger Assmann     2021-11-21  825   * Description:
a6da2bbb0005e6 Holger Assmann     2021-11-21  826   * Initialize hardware counter for packet timestamping.
a6da2bbb0005e6 Holger Assmann     2021-11-21  827   * This is valid as long as the interface is open and not suspended.
a6da2bbb0005e6 Holger Assmann     2021-11-21  828   * Will be rerun after resuming from suspend, case in which the timestamping
a6da2bbb0005e6 Holger Assmann     2021-11-21  829   * flags updated by stmmac_hwtstamp_set() also need to be restored.
a6da2bbb0005e6 Holger Assmann     2021-11-21  830   */
a6da2bbb0005e6 Holger Assmann     2021-11-21  831  int stmmac_init_tstamp_counter(struct stmmac_priv *priv, u32 systime_flags)
a6da2bbb0005e6 Holger Assmann     2021-11-21  832  {
a6da2bbb0005e6 Holger Assmann     2021-11-21  833  	bool xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
a6da2bbb0005e6 Holger Assmann     2021-11-21  834  	struct timespec64 now;
a6da2bbb0005e6 Holger Assmann     2021-11-21  835  	u32 sec_inc = 0;
a6da2bbb0005e6 Holger Assmann     2021-11-21  836  	u64 temp = 0;
a6da2bbb0005e6 Holger Assmann     2021-11-21 @837  	int ret;
a6da2bbb0005e6 Holger Assmann     2021-11-21  838  
a6da2bbb0005e6 Holger Assmann     2021-11-21  839  	if (!(priv->dma_cap.time_stamp || priv->dma_cap.atime_stamp))
a6da2bbb0005e6 Holger Assmann     2021-11-21  840  		return -EOPNOTSUPP;
a6da2bbb0005e6 Holger Assmann     2021-11-21  841  
a6da2bbb0005e6 Holger Assmann     2021-11-21  842  	stmmac_config_hw_tstamping(priv, priv->ptpaddr, systime_flags);
a6da2bbb0005e6 Holger Assmann     2021-11-21  843  	priv->systime_flags = systime_flags;
a6da2bbb0005e6 Holger Assmann     2021-11-21  844  
a6da2bbb0005e6 Holger Assmann     2021-11-21  845  	/* program Sub Second Increment reg */
a6da2bbb0005e6 Holger Assmann     2021-11-21  846  	stmmac_config_sub_second_increment(priv, priv->ptpaddr,
a6da2bbb0005e6 Holger Assmann     2021-11-21  847  					   priv->plat->clk_ptp_rate,
a6da2bbb0005e6 Holger Assmann     2021-11-21  848  					   xmac, &sec_inc);
a6da2bbb0005e6 Holger Assmann     2021-11-21  849  	temp = div_u64(1000000000ULL, sec_inc);
a6da2bbb0005e6 Holger Assmann     2021-11-21  850  
a6da2bbb0005e6 Holger Assmann     2021-11-21  851  	/* Store sub second increment for later use */
a6da2bbb0005e6 Holger Assmann     2021-11-21  852  	priv->sub_second_inc = sec_inc;
a6da2bbb0005e6 Holger Assmann     2021-11-21  853  
a6da2bbb0005e6 Holger Assmann     2021-11-21  854  	/* calculate default added value:
a6da2bbb0005e6 Holger Assmann     2021-11-21  855  	 * formula is :
a6da2bbb0005e6 Holger Assmann     2021-11-21  856  	 * addend = (2^32)/freq_div_ratio;
a6da2bbb0005e6 Holger Assmann     2021-11-21  857  	 * where, freq_div_ratio = 1e9ns/sec_inc
a6da2bbb0005e6 Holger Assmann     2021-11-21  858  	 */
a6da2bbb0005e6 Holger Assmann     2021-11-21  859  	temp = (u64)(temp << 32);
a6da2bbb0005e6 Holger Assmann     2021-11-21  860  	priv->default_addend = div_u64(temp, priv->plat->clk_ptp_rate);
a6da2bbb0005e6 Holger Assmann     2021-11-21  861  	stmmac_config_addend(priv, priv->ptpaddr, priv->default_addend);
a6da2bbb0005e6 Holger Assmann     2021-11-21  862  
a6da2bbb0005e6 Holger Assmann     2021-11-21  863  	/* initialize system time */
a6da2bbb0005e6 Holger Assmann     2021-11-21  864  	ktime_get_real_ts64(&now);
a6da2bbb0005e6 Holger Assmann     2021-11-21  865  
a6da2bbb0005e6 Holger Assmann     2021-11-21  866  	/* lower 32 bits of tv_sec are safe until y2106 */
a6da2bbb0005e6 Holger Assmann     2021-11-21  867  	stmmac_init_systime(priv, priv->ptpaddr, (u32)now.tv_sec, now.tv_nsec);
a6da2bbb0005e6 Holger Assmann     2021-11-21  868  
a6da2bbb0005e6 Holger Assmann     2021-11-21  869  	return 0;
a6da2bbb0005e6 Holger Assmann     2021-11-21  870  }
a6da2bbb0005e6 Holger Assmann     2021-11-21  871  EXPORT_SYMBOL_GPL(stmmac_init_tstamp_counter);
a6da2bbb0005e6 Holger Assmann     2021-11-21  872  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
