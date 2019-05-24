Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5559C2A1A2
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 01:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbfEXXbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 19:31:38 -0400
Received: from mga03.intel.com ([134.134.136.65]:23819 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbfEXXbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 19:31:38 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 May 2019 16:31:37 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 24 May 2019 16:31:36 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hUJex-0009OK-JN; Sat, 25 May 2019 07:31:35 +0800
Date:   Sat, 25 May 2019 07:30:49 +0800
From:   kbuild test robot <lkp@intel.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [net-next:master 58/94]
 drivers/net/ethernet/freescale/enetc/enetc.c:314:27: sparse: sparse:
 restricted __le32 degrades to integer
Message-ID: <201905250746.Yd5wCWkC%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   22942498ccebf13b076859f8746be161dc0c6d89
commit: d398231219116da5697bbe090e478dd68a2259ed [58/94] enetc: add hardware timestamping support
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        git checkout d398231219116da5697bbe090e478dd68a2259ed
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/freescale/enetc/enetc.c:314:27: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/freescale/enetc/enetc.c:316:43: sparse: sparse: restricted __le32 degrades to integer
>> drivers/net/ethernet/freescale/enetc/enetc.c:489:20: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/freescale/enetc/enetc.c:492:34: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/freescale/enetc/enetc.c:495:49: sparse: sparse: restricted __le32 degrades to integer

vim +314 drivers/net/ethernet/freescale/enetc/enetc.c

   306	
   307	static void enetc_get_tx_tstamp(struct enetc_hw *hw, union enetc_tx_bd *txbd,
   308					u64 *tstamp)
   309	{
   310		u32 lo, hi;
   311	
   312		lo = enetc_rd(hw, ENETC_SICTR0);
   313		hi = enetc_rd(hw, ENETC_SICTR1);
 > 314		if (lo <= txbd->wb.tstamp)
   315			hi -= 1;
   316		*tstamp = (u64)hi << 32 | txbd->wb.tstamp;
   317	}
   318	
   319	static void enetc_tstamp_tx(struct sk_buff *skb, u64 tstamp)
   320	{
   321		struct skb_shared_hwtstamps shhwtstamps;
   322	
   323		if (skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) {
   324			memset(&shhwtstamps, 0, sizeof(shhwtstamps));
   325			shhwtstamps.hwtstamp = ns_to_ktime(tstamp);
   326			skb_tstamp_tx(skb, &shhwtstamps);
   327		}
   328	}
   329	
   330	static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
   331	{
   332		struct net_device *ndev = tx_ring->ndev;
   333		int tx_frm_cnt = 0, tx_byte_cnt = 0;
   334		struct enetc_tx_swbd *tx_swbd;
   335		int i, bds_to_clean;
   336		bool do_tstamp;
   337		u64 tstamp = 0;
   338	
   339		i = tx_ring->next_to_clean;
   340		tx_swbd = &tx_ring->tx_swbd[i];
   341		bds_to_clean = enetc_bd_ready_count(tx_ring, i);
   342	
   343		do_tstamp = false;
   344	
   345		while (bds_to_clean && tx_frm_cnt < ENETC_DEFAULT_TX_WORK) {
   346			bool is_eof = !!tx_swbd->skb;
   347	
   348			if (unlikely(tx_swbd->check_wb)) {
   349				struct enetc_ndev_priv *priv = netdev_priv(ndev);
   350				union enetc_tx_bd *txbd;
   351	
   352				txbd = ENETC_TXBD(*tx_ring, i);
   353	
   354				if (txbd->flags & ENETC_TXBD_FLAGS_W &&
   355				    tx_swbd->do_tstamp) {
   356					enetc_get_tx_tstamp(&priv->si->hw, txbd,
   357							    &tstamp);
   358					do_tstamp = true;
   359				}
   360			}
   361	
   362			if (likely(tx_swbd->dma))
   363				enetc_unmap_tx_buff(tx_ring, tx_swbd);
   364	
   365			if (is_eof) {
   366				if (unlikely(do_tstamp)) {
   367					enetc_tstamp_tx(tx_swbd->skb, tstamp);
   368					do_tstamp = false;
   369				}
   370				napi_consume_skb(tx_swbd->skb, napi_budget);
   371				tx_swbd->skb = NULL;
   372			}
   373	
   374			tx_byte_cnt += tx_swbd->len;
   375	
   376			bds_to_clean--;
   377			tx_swbd++;
   378			i++;
   379			if (unlikely(i == tx_ring->bd_count)) {
   380				i = 0;
   381				tx_swbd = tx_ring->tx_swbd;
   382			}
   383	
   384			/* BD iteration loop end */
   385			if (is_eof) {
   386				tx_frm_cnt++;
   387				/* re-arm interrupt source */
   388				enetc_wr_reg(tx_ring->idr, BIT(tx_ring->index) |
   389					     BIT(16 + tx_ring->index));
   390			}
   391	
   392			if (unlikely(!bds_to_clean))
   393				bds_to_clean = enetc_bd_ready_count(tx_ring, i);
   394		}
   395	
   396		tx_ring->next_to_clean = i;
   397		tx_ring->stats.packets += tx_frm_cnt;
   398		tx_ring->stats.bytes += tx_byte_cnt;
   399	
   400		if (unlikely(tx_frm_cnt && netif_carrier_ok(ndev) &&
   401			     __netif_subqueue_stopped(ndev, tx_ring->index) &&
   402			     (enetc_bd_unused(tx_ring) >= ENETC_TXBDS_MAX_NEEDED))) {
   403			netif_wake_subqueue(ndev, tx_ring->index);
   404		}
   405	
   406		return tx_frm_cnt != ENETC_DEFAULT_TX_WORK;
   407	}
   408	
   409	static bool enetc_new_page(struct enetc_bdr *rx_ring,
   410				   struct enetc_rx_swbd *rx_swbd)
   411	{
   412		struct page *page;
   413		dma_addr_t addr;
   414	
   415		page = dev_alloc_page();
   416		if (unlikely(!page))
   417			return false;
   418	
   419		addr = dma_map_page(rx_ring->dev, page, 0, PAGE_SIZE, DMA_FROM_DEVICE);
   420		if (unlikely(dma_mapping_error(rx_ring->dev, addr))) {
   421			__free_page(page);
   422	
   423			return false;
   424		}
   425	
   426		rx_swbd->dma = addr;
   427		rx_swbd->page = page;
   428		rx_swbd->page_offset = ENETC_RXB_PAD;
   429	
   430		return true;
   431	}
   432	
   433	static int enetc_refill_rx_ring(struct enetc_bdr *rx_ring, const int buff_cnt)
   434	{
   435		struct enetc_rx_swbd *rx_swbd;
   436		union enetc_rx_bd *rxbd;
   437		int i, j;
   438	
   439		i = rx_ring->next_to_use;
   440		rx_swbd = &rx_ring->rx_swbd[i];
   441		rxbd = ENETC_RXBD(*rx_ring, i);
   442	
   443		for (j = 0; j < buff_cnt; j++) {
   444			/* try reuse page */
   445			if (unlikely(!rx_swbd->page)) {
   446				if (unlikely(!enetc_new_page(rx_ring, rx_swbd))) {
   447					rx_ring->stats.rx_alloc_errs++;
   448					break;
   449				}
   450			}
   451	
   452			/* update RxBD */
   453			rxbd->w.addr = cpu_to_le64(rx_swbd->dma +
   454						   rx_swbd->page_offset);
   455			/* clear 'R" as well */
   456			rxbd->r.lstatus = 0;
   457	
   458			rx_swbd++;
   459			rxbd++;
   460			i++;
   461			if (unlikely(i == rx_ring->bd_count)) {
   462				i = 0;
   463				rx_swbd = rx_ring->rx_swbd;
   464				rxbd = ENETC_RXBD(*rx_ring, 0);
   465			}
   466		}
   467	
   468		if (likely(j)) {
   469			rx_ring->next_to_alloc = i; /* keep track from page reuse */
   470			rx_ring->next_to_use = i;
   471			/* update ENETC's consumer index */
   472			enetc_wr_reg(rx_ring->rcir, i);
   473		}
   474	
   475		return j;
   476	}
   477	
   478	#ifdef CONFIG_FSL_ENETC_HW_TIMESTAMPING
   479	static void enetc_get_rx_tstamp(struct net_device *ndev,
   480					union enetc_rx_bd *rxbd,
   481					struct sk_buff *skb)
   482	{
   483		struct skb_shared_hwtstamps *shhwtstamps = skb_hwtstamps(skb);
   484		struct enetc_ndev_priv *priv = netdev_priv(ndev);
   485		struct enetc_hw *hw = &priv->si->hw;
   486		u32 lo, hi;
   487		u64 tstamp;
   488	
 > 489		if (rxbd->r.flags & ENETC_RXBD_FLAG_TSTMP) {
   490			lo = enetc_rd(hw, ENETC_SICTR0);
   491			hi = enetc_rd(hw, ENETC_SICTR1);
   492			if (lo <= rxbd->r.tstamp)
   493				hi -= 1;
   494	
   495			tstamp = (u64)hi << 32 | rxbd->r.tstamp;
   496			memset(shhwtstamps, 0, sizeof(*shhwtstamps));
   497			shhwtstamps->hwtstamp = ns_to_ktime(tstamp);
   498		}
   499	}
   500	#endif
   501	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
