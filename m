Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13E24635D4
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 14:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241761AbhK3NzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 08:55:16 -0500
Received: from mga07.intel.com ([134.134.136.100]:23353 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241821AbhK3NzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 08:55:13 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="299609782"
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="299609782"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 05:51:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="744738557"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by fmsmga006.fm.intel.com with ESMTP; 30 Nov 2021 05:51:50 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1ms3Xx-000DN9-Pn; Tue, 30 Nov 2021 13:51:49 +0000
Date:   Tue, 30 Nov 2021 21:51:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Wells Lu <wellslutw@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de
Cc:     kbuild-all@lists.01.org, wells.lu@sunplus.com,
        vincent.shih@sunplus.com, Wells Lu <wellslutw@gmail.com>
Subject: Re: [PATCH net-next v3 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Message-ID: <202111302126.kdjsLCiQ-lkp@intel.com>
References: <1638266572-5831-3-git-send-email-wellslutw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638266572-5831-3-git-send-email-wellslutw@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wells,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Wells-Lu/This-is-a-patch-series-for-pinctrl-driver-for-Sunplus-SP7021-SoC/20211130-180452
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 09ae03e2fc9d04240c21759ce9f1ef63d7651850
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20211130/202111302126.kdjsLCiQ-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/c5416cd4312a02ecbd1752129b61392a857a45fb
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Wells-Lu/This-is-a-patch-series-for-pinctrl-driver-for-Sunplus-SP7021-SoC/20211130-180452
        git checkout c5416cd4312a02ecbd1752129b61392a857a45fb
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=alpha SHELL=/bin/bash drivers/net/ethernet/sunplus/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/sunplus/spl2sw_int.c: In function 'spl2sw_tx_poll':
>> drivers/net/ethernet/sunplus/spl2sw_int.c:157:28: warning: variable 'mac' set but not used [-Wunused-but-set-variable]
     157 |         struct spl2sw_mac *mac;
         |                            ^~~


vim +/mac +157 drivers/net/ethernet/sunplus/spl2sw_int.c

   151	
   152	int spl2sw_tx_poll(struct napi_struct *napi, int budget)
   153	{
   154		struct spl2sw_common *comm = container_of(napi, struct spl2sw_common, tx_napi);
   155		struct spl2sw_skb_info *skbinfo;
   156		struct net_device_stats *stats;
 > 157		struct spl2sw_mac *mac;
   158		u32 tx_done_pos;
   159		u32 mask;
   160		u32 cmd;
   161		int i;
   162	
   163		spin_lock(&comm->tx_lock);
   164	
   165		tx_done_pos = comm->tx_done_pos;
   166		while ((tx_done_pos != comm->tx_pos) || (comm->tx_desc_full == 1)) {
   167			cmd = comm->tx_desc[tx_done_pos].cmd1;
   168			if (cmd & TXD_OWN)
   169				break;
   170	
   171			skbinfo = &comm->tx_temp_skb_info[tx_done_pos];
   172			if (unlikely(!skbinfo->skb))
   173				goto spl2sw_tx_poll_next;
   174	
   175			i = spl2sw_bit_pos_to_port_num(FIELD_GET(TXD_VLAN, cmd));
   176			if (i < MAX_NETDEV_NUM && comm->ndev[i]) {
   177				mac = netdev_priv(comm->ndev[i]);
   178				stats = &comm->ndev[i]->stats;
   179			} else {
   180				goto spl2sw_tx_poll_unmap;
   181			}
   182	
   183			if (unlikely(cmd & (TXD_ERR_CODE))) {
   184				stats->tx_errors++;
   185			} else {
   186				stats->tx_packets++;
   187				stats->tx_bytes += skbinfo->len;
   188			}
   189	
   190	spl2sw_tx_poll_unmap:
   191			dma_unmap_single(&comm->pdev->dev, skbinfo->mapping, skbinfo->len,
   192					 DMA_TO_DEVICE);
   193			skbinfo->mapping = 0;
   194			dev_kfree_skb_irq(skbinfo->skb);
   195			skbinfo->skb = NULL;
   196	
   197	spl2sw_tx_poll_next:
   198			/* Move tx_done_pos to next position */
   199			tx_done_pos = ((tx_done_pos + 1) == TX_DESC_NUM) ? 0 : tx_done_pos + 1;
   200	
   201			if (comm->tx_desc_full == 1)
   202				comm->tx_desc_full = 0;
   203		}
   204	
   205		comm->tx_done_pos = tx_done_pos;
   206		if (!comm->tx_desc_full)
   207			for (i = 0; i < MAX_NETDEV_NUM; i++)
   208				if (comm->ndev[i])
   209					if (netif_queue_stopped(comm->ndev[i]))
   210						netif_wake_queue(comm->ndev[i]);
   211	
   212		spin_unlock(&comm->tx_lock);
   213	
   214		wmb();			/* make sure settings are effective. */
   215		mask = readl(comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
   216		mask &= ~MAC_INT_TX;
   217		writel(mask, comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
   218	
   219		napi_complete(napi);
   220		return 0;
   221	}
   222	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
