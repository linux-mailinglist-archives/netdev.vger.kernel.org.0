Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2B2F12A957
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 00:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfLYXkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 18:40:06 -0500
Received: from mga17.intel.com ([192.55.52.151]:58610 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726866AbfLYXkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Dec 2019 18:40:06 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Dec 2019 15:40:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,356,1571727600"; 
   d="scan'208";a="214452199"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 25 Dec 2019 15:40:04 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ikGG4-0009ca-2W; Thu, 26 Dec 2019 07:40:04 +0800
Date:   Thu, 26 Dec 2019 07:39:48 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Doug Berger <opendmb@gmail.com>
Cc:     kbuild-all@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: Re: [PATCH net-next 3/8] net: bcmgenet: use CHECKSUM_COMPLETE for
 NETIF_F_RXCSUM
Message-ID: <201912260751.HrsMG6Gf%lkp@intel.com>
References: <1576616549-39097-4-git-send-email-opendmb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576616549-39097-4-git-send-email-opendmb@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Doug,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master v5.5-rc3 next-20191220]
[cannot apply to sparc-next/master]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Doug-Berger/net-bcmgenet-Turn-on-offloads-by-default/20191221-050220
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git d8e419da048e45a8258b9721e85232dbb25ac618
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-129-g341daf20-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/broadcom/genet/bcmgenet.c:1796:45: sparse: sparse: cast to restricted __be16
>> drivers/net/ethernet/broadcom/genet/bcmgenet.c:1796:45: sparse: sparse: cast to restricted __be16
>> drivers/net/ethernet/broadcom/genet/bcmgenet.c:1796:45: sparse: sparse: cast to restricted __be16
>> drivers/net/ethernet/broadcom/genet/bcmgenet.c:1796:45: sparse: sparse: cast to restricted __be16
   drivers/net/ethernet/broadcom/genet/bcmgenet.c:1796:43: sparse: sparse: incorrect type in assignment (different base types)
>> drivers/net/ethernet/broadcom/genet/bcmgenet.c:1796:43: sparse:    expected restricted __wsum [usertype] csum
>> drivers/net/ethernet/broadcom/genet/bcmgenet.c:1796:43: sparse:    got int
   include/linux/netdevice.h:3931:20: sparse: sparse: shift count is negative (-1)

vim +1796 drivers/net/ethernet/broadcom/genet/bcmgenet.c

  1724	
  1725	/* bcmgenet_desc_rx - descriptor based rx process.
  1726	 * this could be called from bottom half, or from NAPI polling method.
  1727	 */
  1728	static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
  1729					     unsigned int budget)
  1730	{
  1731		struct bcmgenet_priv *priv = ring->priv;
  1732		struct net_device *dev = priv->dev;
  1733		struct enet_cb *cb;
  1734		struct sk_buff *skb;
  1735		u32 dma_length_status;
  1736		unsigned long dma_flag;
  1737		int len;
  1738		unsigned int rxpktprocessed = 0, rxpkttoprocess;
  1739		unsigned int bytes_processed = 0;
  1740		unsigned int p_index, mask;
  1741		unsigned int discards;
  1742	
  1743		/* Clear status before servicing to reduce spurious interrupts */
  1744		if (ring->index == DESC_INDEX) {
  1745			bcmgenet_intrl2_0_writel(priv, UMAC_IRQ_RXDMA_DONE,
  1746						 INTRL2_CPU_CLEAR);
  1747		} else {
  1748			mask = 1 << (UMAC_IRQ1_RX_INTR_SHIFT + ring->index);
  1749			bcmgenet_intrl2_1_writel(priv,
  1750						 mask,
  1751						 INTRL2_CPU_CLEAR);
  1752		}
  1753	
  1754		p_index = bcmgenet_rdma_ring_readl(priv, ring->index, RDMA_PROD_INDEX);
  1755	
  1756		discards = (p_index >> DMA_P_INDEX_DISCARD_CNT_SHIFT) &
  1757			   DMA_P_INDEX_DISCARD_CNT_MASK;
  1758		if (discards > ring->old_discards) {
  1759			discards = discards - ring->old_discards;
  1760			ring->errors += discards;
  1761			ring->old_discards += discards;
  1762	
  1763			/* Clear HW register when we reach 75% of maximum 0xFFFF */
  1764			if (ring->old_discards >= 0xC000) {
  1765				ring->old_discards = 0;
  1766				bcmgenet_rdma_ring_writel(priv, ring->index, 0,
  1767							  RDMA_PROD_INDEX);
  1768			}
  1769		}
  1770	
  1771		p_index &= DMA_P_INDEX_MASK;
  1772		rxpkttoprocess = (p_index - ring->c_index) & DMA_C_INDEX_MASK;
  1773	
  1774		netif_dbg(priv, rx_status, dev,
  1775			  "RDMA: rxpkttoprocess=%d\n", rxpkttoprocess);
  1776	
  1777		while ((rxpktprocessed < rxpkttoprocess) &&
  1778		       (rxpktprocessed < budget)) {
  1779			cb = &priv->rx_cbs[ring->read_ptr];
  1780			skb = bcmgenet_rx_refill(priv, cb);
  1781	
  1782			if (unlikely(!skb)) {
  1783				ring->dropped++;
  1784				goto next;
  1785			}
  1786	
  1787			if (!priv->desc_64b_en) {
  1788				dma_length_status =
  1789					dmadesc_get_length_status(priv, cb->bd_addr);
  1790			} else {
  1791				struct status_64 *status;
  1792	
  1793				status = (struct status_64 *)skb->data;
  1794				dma_length_status = status->length_status;
  1795				if (priv->desc_rxchk_en) {
> 1796					skb->csum = ntohs(status->rx_csum & 0xffff);
  1797					skb->ip_summed = CHECKSUM_COMPLETE;
  1798				}
  1799			}
  1800	
  1801			/* DMA flags and length are still valid no matter how
  1802			 * we got the Receive Status Vector (64B RSB or register)
  1803			 */
  1804			dma_flag = dma_length_status & 0xffff;
  1805			len = dma_length_status >> DMA_BUFLENGTH_SHIFT;
  1806	
  1807			netif_dbg(priv, rx_status, dev,
  1808				  "%s:p_ind=%d c_ind=%d read_ptr=%d len_stat=0x%08x\n",
  1809				  __func__, p_index, ring->c_index,
  1810				  ring->read_ptr, dma_length_status);
  1811	
  1812			if (unlikely(!(dma_flag & DMA_EOP) || !(dma_flag & DMA_SOP))) {
  1813				netif_err(priv, rx_status, dev,
  1814					  "dropping fragmented packet!\n");
  1815				ring->errors++;
  1816				dev_kfree_skb_any(skb);
  1817				goto next;
  1818			}
  1819	
  1820			/* report errors */
  1821			if (unlikely(dma_flag & (DMA_RX_CRC_ERROR |
  1822							DMA_RX_OV |
  1823							DMA_RX_NO |
  1824							DMA_RX_LG |
  1825							DMA_RX_RXER))) {
  1826				netif_err(priv, rx_status, dev, "dma_flag=0x%x\n",
  1827					  (unsigned int)dma_flag);
  1828				if (dma_flag & DMA_RX_CRC_ERROR)
  1829					dev->stats.rx_crc_errors++;
  1830				if (dma_flag & DMA_RX_OV)
  1831					dev->stats.rx_over_errors++;
  1832				if (dma_flag & DMA_RX_NO)
  1833					dev->stats.rx_frame_errors++;
  1834				if (dma_flag & DMA_RX_LG)
  1835					dev->stats.rx_length_errors++;
  1836				dev->stats.rx_errors++;
  1837				dev_kfree_skb_any(skb);
  1838				goto next;
  1839			} /* error packet */
  1840	
  1841			skb_put(skb, len);
  1842			if (priv->desc_64b_en) {
  1843				skb_pull(skb, 64);
  1844				len -= 64;
  1845			}
  1846	
  1847			/* remove hardware 2bytes added for IP alignment */
  1848			skb_pull(skb, 2);
  1849			len -= 2;
  1850	
  1851			if (priv->crc_fwd_en) {
  1852				skb_trim(skb, len - ETH_FCS_LEN);
  1853				len -= ETH_FCS_LEN;
  1854			}
  1855	
  1856			bytes_processed += len;
  1857	
  1858			/*Finish setting up the received SKB and send it to the kernel*/
  1859			skb->protocol = eth_type_trans(skb, priv->dev);
  1860			ring->packets++;
  1861			ring->bytes += len;
  1862			if (dma_flag & DMA_RX_MULT)
  1863				dev->stats.multicast++;
  1864	
  1865			/* Notify kernel */
  1866			napi_gro_receive(&ring->napi, skb);
  1867			netif_dbg(priv, rx_status, dev, "pushed up to kernel\n");
  1868	
  1869	next:
  1870			rxpktprocessed++;
  1871			if (likely(ring->read_ptr < ring->end_ptr))
  1872				ring->read_ptr++;
  1873			else
  1874				ring->read_ptr = ring->cb_ptr;
  1875	
  1876			ring->c_index = (ring->c_index + 1) & DMA_C_INDEX_MASK;
  1877			bcmgenet_rdma_ring_writel(priv, ring->index, ring->c_index, RDMA_CONS_INDEX);
  1878		}
  1879	
  1880		ring->dim.bytes = bytes_processed;
  1881		ring->dim.packets = rxpktprocessed;
  1882	
  1883		return rxpktprocessed;
  1884	}
  1885	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
