Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7564E4FE7A7
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 20:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358628AbiDLSNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 14:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357033AbiDLSNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 14:13:33 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB2135DF6;
        Tue, 12 Apr 2022 11:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649787075; x=1681323075;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lx68TdPGcWgfpuggGaziE1bzCH4pcICXKu31ixz4/NM=;
  b=DDNzQPBJ0EXu7ZqyXq2VmTPpU/IJF9u74hHZiyI/Tk544Zl6X4xBK9kD
   n4twOifT3k1YAM6hafvReBzIfxKKor58z3/bde1WxVHwMeOdjG4gtR6au
   qtPKO1P9Xs4Hogdanp0CNUjeBhqAxD434p00ffvsTZQMIXwcIRxhO5X28
   x4ih6tzEWCgHfOB59W7GCzgni0EeeQPpDKjQ9KLRPcwLHlMBo7upPXhd6
   DtmhDcFyboFhcfDyjLSm46uR32c+Nr02E7luLLvTYxt44Q8ZftVmIXxLc
   mRQgcGlHdTUI0SlXQRmqIcJr4saEXlxzys6bgMz1qauuhUTD6zWxsaXXa
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="242406055"
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="242406055"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 11:11:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="507665399"
Received: from lkp-server02.sh.intel.com (HELO d3fc50ef50de) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 12 Apr 2022 11:11:11 -0700
Received: from kbuild by d3fc50ef50de with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1neKys-00032t-Te;
        Tue, 12 Apr 2022 18:11:10 +0000
Date:   Wed, 13 Apr 2022 02:11:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Duoming Zhou <duoming@zju.edu.cn>, krzk@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, alexander.deucher@amd.com,
        broonie@kernel.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: Re: [PATCH 2/2] drivers: nfc: nfcmrvl: fix double free bug in
 nfc_fw_download_done()
Message-ID: <202204130213.ukrJxJpy-lkp@intel.com>
References: <d958c7ea019766405bf9db42d58d24d61d6b7607.1649759498.git.duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d958c7ea019766405bf9db42d58d24d61d6b7607.1649759498.git.duoming@zju.edu.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Duoming,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[also build test ERROR on net/master linus/master linux/master v5.18-rc2 next-20220412]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Duoming-Zhou/Fix-double-free-bugs-in-nfcmrvl-module/20220412-203028
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git b66bfc131c69bd9a5ed3ae90be4cf47ec46c1526
config: openrisc-randconfig-r033-20220411 (https://download.01.org/0day-ci/archive/20220413/202204130213.ukrJxJpy-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1f4dba76cb2e854d8ae29781d066257f58b33dee
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Duoming-Zhou/Fix-double-free-bugs-in-nfcmrvl-module/20220412-203028
        git checkout 1f4dba76cb2e854d8ae29781d066257f58b33dee
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=openrisc SHELL=/bin/bash drivers/nfc/nfcmrvl/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/build_bug.h:5,
                    from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/module.h:12,
                    from drivers/nfc/nfcmrvl/fw_dnld.c:8:
   drivers/nfc/nfcmrvl/fw_dnld.c: In function 'fw_dnld_over':
>> drivers/nfc/nfcmrvl/fw_dnld.c:120:13: error: 'dev' undeclared (first use in this function); did you mean 'cdev'?
     120 |         if (dev->fw_download_in_progress)
         |             ^~~
   include/linux/compiler.h:58:52: note: in definition of macro '__trace_if_var'
      58 | #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
         |                                                    ^~~~
   drivers/nfc/nfcmrvl/fw_dnld.c:120:9: note: in expansion of macro 'if'
     120 |         if (dev->fw_download_in_progress)
         |         ^~
   drivers/nfc/nfcmrvl/fw_dnld.c:120:13: note: each undeclared identifier is reported only once for each function it appears in
     120 |         if (dev->fw_download_in_progress)
         |             ^~~
   include/linux/compiler.h:58:52: note: in definition of macro '__trace_if_var'
      58 | #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
         |                                                    ^~~~
   drivers/nfc/nfcmrvl/fw_dnld.c:120:9: note: in expansion of macro 'if'
     120 |         if (dev->fw_download_in_progress)
         |         ^~


vim +120 drivers/nfc/nfcmrvl/fw_dnld.c

   > 8	#include <linux/module.h>
     9	#include <asm/unaligned.h>
    10	#include <linux/firmware.h>
    11	#include <linux/nfc.h>
    12	#include <net/nfc/nci.h>
    13	#include <net/nfc/nci_core.h>
    14	#include "nfcmrvl.h"
    15	
    16	#define FW_DNLD_TIMEOUT			15000
    17	
    18	#define NCI_OP_PROPRIETARY_BOOT_CMD	nci_opcode_pack(NCI_GID_PROPRIETARY, \
    19								NCI_OP_PROP_BOOT_CMD)
    20	
    21	/* FW download states */
    22	
    23	enum {
    24		STATE_RESET = 0,
    25		STATE_INIT,
    26		STATE_SET_REF_CLOCK,
    27		STATE_SET_HI_CONFIG,
    28		STATE_OPEN_LC,
    29		STATE_FW_DNLD,
    30		STATE_CLOSE_LC,
    31		STATE_BOOT
    32	};
    33	
    34	enum {
    35		SUBSTATE_WAIT_COMMAND = 0,
    36		SUBSTATE_WAIT_ACK_CREDIT,
    37		SUBSTATE_WAIT_NACK_CREDIT,
    38		SUBSTATE_WAIT_DATA_CREDIT,
    39	};
    40	
    41	/*
    42	 * Patterns for responses
    43	 */
    44	
    45	static const uint8_t nci_pattern_core_reset_ntf[] = {
    46		0x60, 0x00, 0x02, 0xA0, 0x01
    47	};
    48	
    49	static const uint8_t nci_pattern_core_init_rsp[] = {
    50		0x40, 0x01, 0x11
    51	};
    52	
    53	static const uint8_t nci_pattern_core_set_config_rsp[] = {
    54		0x40, 0x02, 0x02, 0x00, 0x00
    55	};
    56	
    57	static const uint8_t nci_pattern_core_conn_create_rsp[] = {
    58		0x40, 0x04, 0x04, 0x00
    59	};
    60	
    61	static const uint8_t nci_pattern_core_conn_close_rsp[] = {
    62		0x40, 0x05, 0x01, 0x00
    63	};
    64	
    65	static const uint8_t nci_pattern_core_conn_credits_ntf[] = {
    66		0x60, 0x06, 0x03, 0x01, NCI_CORE_LC_CONNID_PROP_FW_DL, 0x01
    67	};
    68	
    69	static const uint8_t nci_pattern_proprietary_boot_rsp[] = {
    70		0x4F, 0x3A, 0x01, 0x00
    71	};
    72	
    73	static struct sk_buff *alloc_lc_skb(struct nfcmrvl_private *priv, uint8_t plen)
    74	{
    75		struct sk_buff *skb;
    76		struct nci_data_hdr *hdr;
    77	
    78		skb = nci_skb_alloc(priv->ndev, (NCI_DATA_HDR_SIZE + plen), GFP_KERNEL);
    79		if (!skb)
    80			return NULL;
    81	
    82		hdr = skb_put(skb, NCI_DATA_HDR_SIZE);
    83		hdr->conn_id = NCI_CORE_LC_CONNID_PROP_FW_DL;
    84		hdr->rfu = 0;
    85		hdr->plen = plen;
    86	
    87		nci_mt_set((__u8 *)hdr, NCI_MT_DATA_PKT);
    88		nci_pbf_set((__u8 *)hdr, NCI_PBF_LAST);
    89	
    90		return skb;
    91	}
    92	
    93	static void fw_dnld_over(struct nfcmrvl_private *priv, u32 error)
    94	{
    95		spin_lock_irq(&priv->fw_dnld.lock);
    96		if (priv->fw_dnld.fw) {
    97			release_firmware(priv->fw_dnld.fw);
    98			priv->fw_dnld.fw = NULL;
    99			priv->fw_dnld.header = NULL;
   100			priv->fw_dnld.binary_config = NULL;
   101		}
   102		spin_unlock_irq(&priv->fw_dnld.lock);
   103	
   104		atomic_set(&priv->ndev->cmd_cnt, 0);
   105	
   106		if (timer_pending(&priv->ndev->cmd_timer))
   107			del_timer_sync(&priv->ndev->cmd_timer);
   108	
   109		if (timer_pending(&priv->fw_dnld.timer))
   110			del_timer_sync(&priv->fw_dnld.timer);
   111	
   112		nfc_info(priv->dev, "FW loading over (%d)]\n", error);
   113	
   114		if (error != 0) {
   115			/* failed, halt the chip to avoid power consumption */
   116			nfcmrvl_chip_halt(priv);
   117		}
   118	
   119		spin_lock_irq(&priv->fw_dnld.lock);
 > 120		if (dev->fw_download_in_progress)
   121			nfc_fw_download_done(priv->ndev->nfc_dev, priv->fw_dnld.name, error);
   122		spin_unlock_irq(&priv->fw_dnld.lock);
   123	}
   124	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
