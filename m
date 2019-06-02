Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E575232287
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 10:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfFBIAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 04:00:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:45700 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbfFBIAP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 04:00:15 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jun 2019 23:37:41 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 01 Jun 2019 23:37:39 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hXK7f-0005MJ-8z; Sun, 02 Jun 2019 14:37:39 +0800
Date:   Sun, 2 Jun 2019 14:37:31 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org, anirudh@xilinx.com,
        John.Linn@xilinx.com, Robert Hancock <hancock@sedsystems.ca>
Subject: Re: [PATCH net-next 01/13] net: axienet: Fixed 64-bit compile,
 enable build on X86 and ARM
Message-ID: <201906021459.CkJJSWzi%lkp@intel.com>
References: <1559326545-28825-2-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559326545-28825-2-git-send-email-hancock@sedsystems.ca>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Robert,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Robert-Hancock/Xilinx-axienet-driver-updates/20190602-124146
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/xilinx/xilinx_axienet_main.c:778:37: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/xilinx/xilinx_axienet_main.c:778:37: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/xilinx/xilinx_axienet_main.c:778:37: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/xilinx/xilinx_axienet_main.c:778:37: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/xilinx/xilinx_axienet_main.c:778:37: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/xilinx/xilinx_axienet_main.c:778:37: sparse: sparse: cast to restricted __be32
>> drivers/net/ethernet/xilinx/xilinx_axienet_main.c:778:35: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __wsum [usertype] csum @@    got  [usertype] csum @@
>> drivers/net/ethernet/xilinx/xilinx_axienet_main.c:778:35: sparse:    expected restricted __wsum [usertype] csum
>> drivers/net/ethernet/xilinx/xilinx_axienet_main.c:778:35: sparse:    got unsigned int

vim +778 drivers/net/ethernet/xilinx/xilinx_axienet_main.c

8a3b7a25 Daniel Borkmann   2012-01-19  728  
8a3b7a25 Daniel Borkmann   2012-01-19  729  /**
8a3b7a25 Daniel Borkmann   2012-01-19  730   * axienet_recv - Is called from Axi DMA Rx Isr to complete the received
8a3b7a25 Daniel Borkmann   2012-01-19  731   *		  BD processing.
8a3b7a25 Daniel Borkmann   2012-01-19  732   * @ndev:	Pointer to net_device structure.
8a3b7a25 Daniel Borkmann   2012-01-19  733   *
8a3b7a25 Daniel Borkmann   2012-01-19  734   * This function is invoked from the Axi DMA Rx isr to process the Rx BDs. It
8a3b7a25 Daniel Borkmann   2012-01-19  735   * does minimal processing and invokes "netif_rx" to complete further
8a3b7a25 Daniel Borkmann   2012-01-19  736   * processing.
8a3b7a25 Daniel Borkmann   2012-01-19  737   */
8a3b7a25 Daniel Borkmann   2012-01-19  738  static void axienet_recv(struct net_device *ndev)
8a3b7a25 Daniel Borkmann   2012-01-19  739  {
8a3b7a25 Daniel Borkmann   2012-01-19  740  	u32 length;
8a3b7a25 Daniel Borkmann   2012-01-19  741  	u32 csumstatus;
8a3b7a25 Daniel Borkmann   2012-01-19  742  	u32 size = 0;
8a3b7a25 Daniel Borkmann   2012-01-19  743  	u32 packets = 0;
38e96b35 Peter Crosthwaite 2015-05-05  744  	dma_addr_t tail_p = 0;
8a3b7a25 Daniel Borkmann   2012-01-19  745  	struct axienet_local *lp = netdev_priv(ndev);
8a3b7a25 Daniel Borkmann   2012-01-19  746  	struct sk_buff *skb, *new_skb;
8a3b7a25 Daniel Borkmann   2012-01-19  747  	struct axidma_bd *cur_p;
8a3b7a25 Daniel Borkmann   2012-01-19  748  
8a3b7a25 Daniel Borkmann   2012-01-19  749  	cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
8a3b7a25 Daniel Borkmann   2012-01-19  750  
8a3b7a25 Daniel Borkmann   2012-01-19  751  	while ((cur_p->status & XAXIDMA_BD_STS_COMPLETE_MASK)) {
38e96b35 Peter Crosthwaite 2015-05-05  752  		tail_p = lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
8a3b7a25 Daniel Borkmann   2012-01-19  753  
8a3b7a25 Daniel Borkmann   2012-01-19  754  		dma_unmap_single(ndev->dev.parent, cur_p->phys,
8a3b7a25 Daniel Borkmann   2012-01-19  755  				 lp->max_frm_size,
8a3b7a25 Daniel Borkmann   2012-01-19  756  				 DMA_FROM_DEVICE);
8a3b7a25 Daniel Borkmann   2012-01-19  757  
2f148c6d Robert Hancock    2019-05-31  758  		skb = cur_p->skb;
2f148c6d Robert Hancock    2019-05-31  759  		cur_p->skb = NULL;
2f148c6d Robert Hancock    2019-05-31  760  		length = cur_p->app4 & 0x0000FFFF;
2f148c6d Robert Hancock    2019-05-31  761  
8a3b7a25 Daniel Borkmann   2012-01-19  762  		skb_put(skb, length);
8a3b7a25 Daniel Borkmann   2012-01-19  763  		skb->protocol = eth_type_trans(skb, ndev);
8a3b7a25 Daniel Borkmann   2012-01-19  764  		/*skb_checksum_none_assert(skb);*/
8a3b7a25 Daniel Borkmann   2012-01-19  765  		skb->ip_summed = CHECKSUM_NONE;
8a3b7a25 Daniel Borkmann   2012-01-19  766  
8a3b7a25 Daniel Borkmann   2012-01-19  767  		/* if we're doing Rx csum offload, set it up */
8a3b7a25 Daniel Borkmann   2012-01-19  768  		if (lp->features & XAE_FEATURE_FULL_RX_CSUM) {
8a3b7a25 Daniel Borkmann   2012-01-19  769  			csumstatus = (cur_p->app2 &
8a3b7a25 Daniel Borkmann   2012-01-19  770  				      XAE_FULL_CSUM_STATUS_MASK) >> 3;
8a3b7a25 Daniel Borkmann   2012-01-19  771  			if ((csumstatus == XAE_IP_TCP_CSUM_VALIDATED) ||
8a3b7a25 Daniel Borkmann   2012-01-19  772  			    (csumstatus == XAE_IP_UDP_CSUM_VALIDATED)) {
8a3b7a25 Daniel Borkmann   2012-01-19  773  				skb->ip_summed = CHECKSUM_UNNECESSARY;
8a3b7a25 Daniel Borkmann   2012-01-19  774  			}
8a3b7a25 Daniel Borkmann   2012-01-19  775  		} else if ((lp->features & XAE_FEATURE_PARTIAL_RX_CSUM) != 0 &&
ceffc4ac Joe Perches       2014-03-12  776  			   skb->protocol == htons(ETH_P_IP) &&
8a3b7a25 Daniel Borkmann   2012-01-19  777  			   skb->len > 64) {
8a3b7a25 Daniel Borkmann   2012-01-19 @778  			skb->csum = be32_to_cpu(cur_p->app3 & 0xFFFF);
8a3b7a25 Daniel Borkmann   2012-01-19  779  			skb->ip_summed = CHECKSUM_COMPLETE;
8a3b7a25 Daniel Borkmann   2012-01-19  780  		}
8a3b7a25 Daniel Borkmann   2012-01-19  781  
8a3b7a25 Daniel Borkmann   2012-01-19  782  		netif_rx(skb);
8a3b7a25 Daniel Borkmann   2012-01-19  783  
8a3b7a25 Daniel Borkmann   2012-01-19  784  		size += length;
8a3b7a25 Daniel Borkmann   2012-01-19  785  		packets++;
8a3b7a25 Daniel Borkmann   2012-01-19  786  
8a3b7a25 Daniel Borkmann   2012-01-19  787  		new_skb = netdev_alloc_skb_ip_align(ndev, lp->max_frm_size);
720a43ef Joe Perches       2013-03-08  788  		if (!new_skb)
8a3b7a25 Daniel Borkmann   2012-01-19  789  			return;
720a43ef Joe Perches       2013-03-08  790  
8a3b7a25 Daniel Borkmann   2012-01-19  791  		cur_p->phys = dma_map_single(ndev->dev.parent, new_skb->data,
8a3b7a25 Daniel Borkmann   2012-01-19  792  					     lp->max_frm_size,
8a3b7a25 Daniel Borkmann   2012-01-19  793  					     DMA_FROM_DEVICE);
8a3b7a25 Daniel Borkmann   2012-01-19  794  		cur_p->cntrl = lp->max_frm_size;
8a3b7a25 Daniel Borkmann   2012-01-19  795  		cur_p->status = 0;
2f148c6d Robert Hancock    2019-05-31  796  		cur_p->skb = new_skb;
8a3b7a25 Daniel Borkmann   2012-01-19  797  
91ff37ff Michal Simek      2014-02-13  798  		++lp->rx_bd_ci;
91ff37ff Michal Simek      2014-02-13  799  		lp->rx_bd_ci %= RX_BD_NUM;
8a3b7a25 Daniel Borkmann   2012-01-19  800  		cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
8a3b7a25 Daniel Borkmann   2012-01-19  801  	}
8a3b7a25 Daniel Borkmann   2012-01-19  802  
8a3b7a25 Daniel Borkmann   2012-01-19  803  	ndev->stats.rx_packets += packets;
8a3b7a25 Daniel Borkmann   2012-01-19  804  	ndev->stats.rx_bytes += size;
8a3b7a25 Daniel Borkmann   2012-01-19  805  
38e96b35 Peter Crosthwaite 2015-05-05  806  	if (tail_p)
8a3b7a25 Daniel Borkmann   2012-01-19  807  		axienet_dma_out32(lp, XAXIDMA_RX_TDESC_OFFSET, tail_p);
8a3b7a25 Daniel Borkmann   2012-01-19  808  }
8a3b7a25 Daniel Borkmann   2012-01-19  809  

:::::: The code at line 778 was first introduced by commit
:::::: 8a3b7a252dca9fb28c23b5bf76c49180a2b60d3b drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver

:::::: TO: danborkmann@iogearbox.net <danborkmann@iogearbox.net>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
