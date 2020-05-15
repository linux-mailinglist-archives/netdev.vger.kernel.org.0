Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A76C1D5CA3
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 01:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgEOXHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 19:07:51 -0400
Received: from mga17.intel.com ([192.55.52.151]:9989 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgEOXHv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 19:07:51 -0400
IronPort-SDR: gKM5UUhenvU+EKaGdKIzlG6Aix7ypXXPi47S3uvLqMyLAv5VQE/cVk8NJLD6HWktxba+rr6zZu
 3MGJtbddsEkQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 16:07:50 -0700
IronPort-SDR: Gd/ePeL6KnOOYE9Q0aI+Re9FyWkbdYIR83pOANu+fou1yryFpfV1V5Vie70MQ1oU7tL7+6XqXZ
 4gVLCykdTp0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,396,1583222400"; 
   d="scan'208";a="372830283"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 15 May 2020 16:07:48 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jZjQh-000DXf-Un; Sat, 16 May 2020 07:07:47 +0800
Date:   Sat, 16 May 2020 07:07:34 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH v2 net-next 3/7] dpaa2-eth: Distribute ingress frames
 based on VLAN prio
Message-ID: <202005160725.cW5HQjVY%lkp@intel.com>
References: <20200515184753.15080-4-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515184753.15080-4-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on sparc-next/master linus/master v5.7-rc5 next-20200515]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Ioana-Ciornei/dpaa2-eth-add-support-for-Rx-traffic-classes/20200516-024950
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git d00f26b623333f2419f4c3b95ff11c8b1bb96f56
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-193-gb8fad4bc-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2728:15: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] @@    got resunsigned short [usertype] @@
>> drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2728:15: sparse:    expected unsigned short [usertype]
>> drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2728:15: sparse:    got restricted __be16 [usertype]
   drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2747:29: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] @@    got resunsigned short [usertype] @@
   drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2747:29: sparse:    expected unsigned short [usertype]
   drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2747:29: sparse:    got restricted __be16 [usertype]

vim +2728 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c

  2664	
  2665	/* Configure ingress classification based on VLAN PCP */
  2666	static int set_vlan_qos(struct dpaa2_eth_priv *priv)
  2667	{
  2668		struct device *dev = priv->net_dev->dev.parent;
  2669		struct dpkg_profile_cfg kg_cfg = {0};
  2670		struct dpni_qos_tbl_cfg qos_cfg = {0};
  2671		struct dpni_rule_cfg key_params;
  2672		void *dma_mem, *key;
  2673		u8 key_size = 2;	/* VLAN TCI field */
  2674		int i, pcp, err;
  2675		u16 *mask;
  2676	
  2677		/* VLAN-based classification only makes sense if we have multiple
  2678		 * traffic classes.
  2679		 * Also, we need to extract just the 3-bit PCP field from the VLAN
  2680		 * header and we can only do that by using a mask
  2681		 */
  2682		if (dpaa2_eth_tc_count(priv) == 1 || !dpaa2_eth_fs_mask_enabled(priv)) {
  2683			dev_dbg(dev, "VLAN-based QoS classification not supported\n");
  2684			return -EOPNOTSUPP;
  2685		}
  2686	
  2687		dma_mem = kzalloc(DPAA2_CLASSIFIER_DMA_SIZE, GFP_KERNEL);
  2688		if (!dma_mem)
  2689			return -ENOMEM;
  2690	
  2691		kg_cfg.num_extracts = 1;
  2692		kg_cfg.extracts[0].type = DPKG_EXTRACT_FROM_HDR;
  2693		kg_cfg.extracts[0].extract.from_hdr.prot = NET_PROT_VLAN;
  2694		kg_cfg.extracts[0].extract.from_hdr.type = DPKG_FULL_FIELD;
  2695		kg_cfg.extracts[0].extract.from_hdr.field = NH_FLD_VLAN_TCI;
  2696	
  2697		err =  dpni_prepare_key_cfg(&kg_cfg, dma_mem);
  2698		if (err) {
  2699			dev_err(dev, "dpni_prepare_key_cfg failed\n");
  2700			goto out_free_tbl;
  2701		}
  2702	
  2703		/* set QoS table */
  2704		qos_cfg.default_tc = 0;
  2705		qos_cfg.discard_on_miss = 0;
  2706		qos_cfg.key_cfg_iova = dma_map_single(dev, dma_mem,
  2707						      DPAA2_CLASSIFIER_DMA_SIZE,
  2708						      DMA_TO_DEVICE);
  2709		if (dma_mapping_error(dev, qos_cfg.key_cfg_iova)) {
  2710			dev_err(dev, "QoS table DMA mapping failed\n");
  2711			err = -ENOMEM;
  2712			goto out_free_tbl;
  2713		}
  2714	
  2715		err = dpni_set_qos_table(priv->mc_io, 0, priv->mc_token, &qos_cfg);
  2716		if (err) {
  2717			dev_err(dev, "dpni_set_qos_table failed\n");
  2718			goto out_unmap_tbl;
  2719		}
  2720	
  2721		/* Add QoS table entries */
  2722		key = kzalloc(key_size * 2, GFP_KERNEL);
  2723		if (!key) {
  2724			err = -ENOMEM;
  2725			goto out_unmap_tbl;
  2726		}
  2727		mask = key + key_size;
> 2728		*mask = cpu_to_be16(VLAN_PRIO_MASK);
  2729	
  2730		key_params.key_iova = dma_map_single(dev, key, key_size * 2,
  2731						     DMA_TO_DEVICE);
  2732		if (dma_mapping_error(dev, key_params.key_iova)) {
  2733			dev_err(dev, "Qos table entry DMA mapping failed\n");
  2734			err = -ENOMEM;
  2735			goto out_free_key;
  2736		}
  2737	
  2738		key_params.mask_iova = key_params.key_iova + key_size;
  2739		key_params.key_size = key_size;
  2740	
  2741		/* We add rules for PCP-based distribution starting with highest
  2742		 * priority (VLAN PCP = 7). If this DPNI doesn't have enough traffic
  2743		 * classes to accommodate all priority levels, the lowest ones end up
  2744		 * on TC 0 which was configured as default
  2745		 */
  2746		for (i = dpaa2_eth_tc_count(priv) - 1, pcp = 7; i >= 0; i--, pcp--) {
  2747			*(u16 *)key = cpu_to_be16(pcp << VLAN_PRIO_SHIFT);
  2748			dma_sync_single_for_device(dev, key_params.key_iova,
  2749						   key_size * 2, DMA_TO_DEVICE);
  2750	
  2751			err = dpni_add_qos_entry(priv->mc_io, 0, priv->mc_token,
  2752						 &key_params, i, i);
  2753			if (err) {
  2754				dev_err(dev, "dpni_add_qos_entry failed\n");
  2755				dpni_clear_qos_table(priv->mc_io, 0, priv->mc_token);
  2756				goto out_unmap_key;
  2757			}
  2758		}
  2759	
  2760		priv->vlan_cls_enabled = true;
  2761	
  2762		/* Table and key memory is not persistent, clean everything up after
  2763		 * configuration is finished
  2764		 */
  2765	out_unmap_key:
  2766		dma_unmap_single(dev, key_params.key_iova, key_size * 2, DMA_TO_DEVICE);
  2767	out_free_key:
  2768		kfree(key);
  2769	out_unmap_tbl:
  2770		dma_unmap_single(dev, qos_cfg.key_cfg_iova, DPAA2_CLASSIFIER_DMA_SIZE,
  2771				 DMA_TO_DEVICE);
  2772	out_free_tbl:
  2773		kfree(dma_mem);
  2774	
  2775		return err;
  2776	}
  2777	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
