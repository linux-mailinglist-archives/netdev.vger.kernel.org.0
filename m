Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5179E711CD
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 08:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbfGWGWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 02:22:39 -0400
Received: from mga05.intel.com ([192.55.52.43]:6099 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbfGWGWj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 02:22:39 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jul 2019 23:22:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,297,1559545200"; 
   d="gz'50?scan'50,208,50";a="171863881"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 22 Jul 2019 23:22:21 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hpoBo-000Ij5-Nf; Tue, 23 Jul 2019 14:22:20 +0800
Date:   Tue, 23 Jul 2019 14:22:05 +0800
From:   kbuild test robot <lkp@intel.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org
Subject: [net-next:master 13/14]
 drivers/net/ethernet/faraday/ftgmac100.c:777:13: error: 'skb_frag_t {aka
 struct bio_vec}' has no member named 'size'
Message-ID: <201907231400.Q5QaKepi%lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tg7kd6hawdukrmow"
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tg7kd6hawdukrmow
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/davem/net-next.git master
head:   d5c3a62d0bb9b763e9378fe8f4cd79502e16cce8
commit: 8842d285bafa9ff7719f4107b6545a11dcd41995 [13/14] net: Convert skb_frag_t to bio_vec
config: m68k-allyesconfig (attached as .config)
compiler: m68k-linux-gcc (GCC) 7.4.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout 8842d285bafa9ff7719f4107b6545a11dcd41995
        # save the attached .config to linux build tree
        GCC_VERSION=7.4.0 make.cross ARCH=m68k 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/ethernet/faraday/ftgmac100.c: In function 'ftgmac100_hard_start_xmit':
>> drivers/net/ethernet/faraday/ftgmac100.c:777:13: error: 'skb_frag_t {aka struct bio_vec}' has no member named 'size'
      len = frag->size;
                ^~

vim +777 drivers/net/ethernet/faraday/ftgmac100.c

05690d633f309d7 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   701  
0a715156656bddf drivers/net/ethernet/faraday/ftgmac100.c YueHaibing             2018-09-26   702  static netdev_tx_t ftgmac100_hard_start_xmit(struct sk_buff *skb,
43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   703  					     struct net_device *netdev)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   704  {
43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   705  	struct ftgmac100 *priv = netdev_priv(netdev);
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   706  	struct ftgmac100_txdes *txdes, *first;
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   707  	unsigned int pointer, nfrags, len, i, j;
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   708  	u32 f_ctl_stat, ctl_stat, csum_vlan;
43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   709  	dma_addr_t map;
43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   710  
9b0f7711d92bf44 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   711  	/* The HW doesn't pad small frames */
9b0f7711d92bf44 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   712  	if (eth_skb_pad(skb)) {
9b0f7711d92bf44 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   713  		netdev->stats.tx_dropped++;
9b0f7711d92bf44 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   714  		return NETDEV_TX_OK;
9b0f7711d92bf44 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   715  	}
9b0f7711d92bf44 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   716  
9b0f7711d92bf44 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   717  	/* Reject oversize packets */
43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   718  	if (unlikely(skb->len > MAX_PKT_SIZE)) {
43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   719  		if (net_ratelimit())
43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   720  			netdev_dbg(netdev, "tx packet too big\n");
3e427a3363edbc8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   721  		goto drop;
43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   722  	}
43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   723  
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   724  	/* Do we have a limit on #fragments ? I yet have to get a reply
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   725  	 * from Aspeed. If there's one I haven't hit it.
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   726  	 */
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   727  	nfrags = skb_shinfo(skb)->nr_frags;
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   728  
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   729  	/* Get header len */
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   730  	len = skb_headlen(skb);
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   731  
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   732  	/* Map the packet head */
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   733  	map = dma_map_single(priv->dev, skb->data, len, DMA_TO_DEVICE);
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   734  	if (dma_mapping_error(priv->dev, map)) {
43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   735  		if (net_ratelimit())
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   736  			netdev_err(netdev, "map tx packet head failed\n");
3e427a3363edbc8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   737  		goto drop;
43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   738  	}
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   739  
83617317d2136ca drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   740  	/* Grab the next free tx descriptor */
83617317d2136ca drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   741  	pointer = priv->tx_pointer;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   742  	txdes = first = &priv->txdes[pointer];
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   743  
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   744  	/* Setup it up with the packet head. Don't write the head to the
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   745  	 * ring just yet
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   746  	 */
83617317d2136ca drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   747  	priv->tx_skbs[pointer] = skb;
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   748  	f_ctl_stat = ftgmac100_base_tx_ctlstat(priv, pointer);
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   749  	f_ctl_stat |= FTGMAC100_TXDES0_TXDMA_OWN;
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   750  	f_ctl_stat |= FTGMAC100_TXDES0_TXBUF_SIZE(len);
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   751  	f_ctl_stat |= FTGMAC100_TXDES0_FTS;
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   752  	if (nfrags == 0)
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   753  		f_ctl_stat |= FTGMAC100_TXDES0_LTS;
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   754  	txdes->txdes3 = cpu_to_le32(map);
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   755  
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   756  	/* Setup HW checksumming */
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   757  	csum_vlan = 0;
05690d633f309d7 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   758  	if (skb->ip_summed == CHECKSUM_PARTIAL &&
05690d633f309d7 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   759  	    !ftgmac100_prep_tx_csum(skb, &csum_vlan))
05690d633f309d7 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   760  		goto drop;
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18   761  
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18   762  	/* Add VLAN tag */
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18   763  	if (skb_vlan_tag_present(skb)) {
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18   764  		csum_vlan |= FTGMAC100_TXDES1_INS_VLANTAG;
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18   765  		csum_vlan |= skb_vlan_tag_get(skb) & 0xffff;
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18   766  	}
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18   767  
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   768  	txdes->txdes1 = cpu_to_le32(csum_vlan);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   769  
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   770  	/* Next descriptor */
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   771  	pointer = ftgmac100_next_tx_pointer(priv, pointer);
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   772  
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   773  	/* Add the fragments */
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   774  	for (i = 0; i < nfrags; i++) {
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   775  		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   776  
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  @777  		len = frag->size;
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   778  
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   779  		/* Map it */
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   780  		map = skb_frag_dma_map(priv->dev, frag, 0, len,
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   781  				       DMA_TO_DEVICE);
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   782  		if (dma_mapping_error(priv->dev, map))
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   783  			goto dma_err;
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   784  
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   785  		/* Setup descriptor */
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   786  		priv->tx_skbs[pointer] = skb;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   787  		txdes = &priv->txdes[pointer];
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   788  		ctl_stat = ftgmac100_base_tx_ctlstat(priv, pointer);
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   789  		ctl_stat |= FTGMAC100_TXDES0_TXDMA_OWN;
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   790  		ctl_stat |= FTGMAC100_TXDES0_TXBUF_SIZE(len);
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   791  		if (i == (nfrags - 1))
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   792  			ctl_stat |= FTGMAC100_TXDES0_LTS;
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   793  		txdes->txdes0 = cpu_to_le32(ctl_stat);
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   794  		txdes->txdes1 = 0;
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   795  		txdes->txdes3 = cpu_to_le32(map);
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   796  
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   797  		/* Next one */
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   798  		pointer = ftgmac100_next_tx_pointer(priv, pointer);
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   799  	}
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   800  
4a2712b2f0b6895 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   801  	/* Order the previous packet and descriptor udpates
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   802  	 * before setting the OWN bit on the first descriptor.
4a2712b2f0b6895 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   803  	 */
4a2712b2f0b6895 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   804  	dma_wmb();
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   805  	first->txdes0 = cpu_to_le32(f_ctl_stat);
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   806  
83617317d2136ca drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   807  	/* Update next TX pointer */
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   808  	priv->tx_pointer = pointer;
83617317d2136ca drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   809  
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   810  	/* If there isn't enough room for all the fragments of a new packet
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   811  	 * in the TX ring, stop the queue. The sequence below is race free
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   812  	 * vs. a concurrent restart in ftgmac100_poll()
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   813  	 */
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   814  	if (unlikely(ftgmac100_tx_buf_avail(priv) < TX_THRESHOLD)) {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   815  		netif_stop_queue(netdev);
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   816  		/* Order the queue stop with the test below */
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   817  		smp_mb();
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   818  		if (ftgmac100_tx_buf_avail(priv) >= TX_THRESHOLD)
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   819  			netif_wake_queue(netdev);
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   820  	}
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   821  
8eecf7caad8687e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   822  	/* Poke transmitter to read the updated TX descriptors */
8eecf7caad8687e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   823  	iowrite32(1, priv->base + FTGMAC100_OFFSET_NPTXPD);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   824  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   825  	return NETDEV_TX_OK;
3e427a3363edbc8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   826  
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   827   dma_err:
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   828  	if (net_ratelimit())
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   829  		netdev_err(netdev, "map tx fragment failed\n");
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   830  
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   831  	/* Free head */
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   832  	pointer = priv->tx_pointer;
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   833  	ftgmac100_free_tx_packet(priv, pointer, skb, first, f_ctl_stat);
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   834  	first->txdes0 = cpu_to_le32(f_ctl_stat & priv->txdes0_edotr_mask);
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   835  
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   836  	/* Then all fragments */
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   837  	for (j = 0; j < i; j++) {
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   838  		pointer = ftgmac100_next_tx_pointer(priv, pointer);
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   839  		txdes = &priv->txdes[pointer];
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   840  		ctl_stat = le32_to_cpu(txdes->txdes0);
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   841  		ftgmac100_free_tx_packet(priv, pointer, skb, txdes, ctl_stat);
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   842  		txdes->txdes0 = cpu_to_le32(ctl_stat & priv->txdes0_edotr_mask);
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   843  	}
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   844  
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   845  	/* This cannot be reached if we successfully mapped the
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   846  	 * last fragment, so we know ftgmac100_free_tx_packet()
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   847  	 * hasn't freed the skb yet.
6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   848  	 */
3e427a3363edbc8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   849   drop:
3e427a3363edbc8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   850  	/* Drop the packet */
3e427a3363edbc8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   851  	dev_kfree_skb_any(skb);
3e427a3363edbc8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   852  	netdev->stats.tx_dropped++;
3e427a3363edbc8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   853  
3e427a3363edbc8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   854  	return NETDEV_TX_OK;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   855  }
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   856  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   857  static void ftgmac100_free_buffers(struct ftgmac100 *priv)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   858  {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   859  	int i;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   860  
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   861  	/* Free all RX buffers */
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   862  	for (i = 0; i < priv->rx_q_entries; i++) {
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   863  		struct ftgmac100_rxdes *rxdes = &priv->rxdes[i];
7b49cd1c9eca4ac drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   864  		struct sk_buff *skb = priv->rx_skbs[i];
4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   865  		dma_addr_t map = le32_to_cpu(rxdes->rxdes3);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   866  
7b49cd1c9eca4ac drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   867  		if (!skb)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   868  			continue;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   869  
7b49cd1c9eca4ac drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   870  		priv->rx_skbs[i] = NULL;
7b49cd1c9eca4ac drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   871  		dma_unmap_single(priv->dev, map, RX_BUF_SIZE, DMA_FROM_DEVICE);
7b49cd1c9eca4ac drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   872  		dev_kfree_skb_any(skb);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   873  	}
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   874  
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   875  	/* Free all TX buffers */
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   876  	for (i = 0; i < priv->tx_q_entries; i++) {
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   877  		struct ftgmac100_txdes *txdes = &priv->txdes[i];
83617317d2136ca drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   878  		struct sk_buff *skb = priv->tx_skbs[i];
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   879  
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   880  		if (!skb)
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   881  			continue;
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   882  		ftgmac100_free_tx_packet(priv, i, skb, txdes,
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   883  					 le32_to_cpu(txdes->txdes0));
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   884  	}
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   885  }
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   886  
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   887  static void ftgmac100_free_rings(struct ftgmac100 *priv)
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   888  {
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   889  	/* Free skb arrays */
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   890  	kfree(priv->rx_skbs);
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   891  	kfree(priv->tx_skbs);
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   892  
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   893  	/* Free descriptors */
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   894  	if (priv->rxdes)
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   895  		dma_free_coherent(priv->dev, MAX_RX_QUEUE_ENTRIES *
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   896  				  sizeof(struct ftgmac100_rxdes),
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   897  				  priv->rxdes, priv->rxdes_dma);
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   898  	priv->rxdes = NULL;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   899  
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   900  	if (priv->txdes)
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   901  		dma_free_coherent(priv->dev, MAX_TX_QUEUE_ENTRIES *
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   902  				  sizeof(struct ftgmac100_txdes),
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   903  				  priv->txdes, priv->txdes_dma);
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   904  	priv->txdes = NULL;
d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   905  
d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   906  	/* Free scratch packet buffer */
d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   907  	if (priv->rx_scratch)
d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   908  		dma_free_coherent(priv->dev, RX_BUF_SIZE,
d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   909  				  priv->rx_scratch, priv->rx_scratch_dma);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   910  }
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   911  
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   912  static int ftgmac100_alloc_rings(struct ftgmac100 *priv)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   913  {
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   914  	/* Allocate skb arrays */
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   915  	priv->rx_skbs = kcalloc(MAX_RX_QUEUE_ENTRIES, sizeof(void *),
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   916  				GFP_KERNEL);
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   917  	if (!priv->rx_skbs)
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   918  		return -ENOMEM;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   919  	priv->tx_skbs = kcalloc(MAX_TX_QUEUE_ENTRIES, sizeof(void *),
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   920  				GFP_KERNEL);
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   921  	if (!priv->tx_skbs)
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   922  		return -ENOMEM;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   923  
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   924  	/* Allocate descriptors */
750afb08ca71310 drivers/net/ethernet/faraday/ftgmac100.c Luis Chamberlain       2019-01-04   925  	priv->rxdes = dma_alloc_coherent(priv->dev,
750afb08ca71310 drivers/net/ethernet/faraday/ftgmac100.c Luis Chamberlain       2019-01-04   926  					 MAX_RX_QUEUE_ENTRIES * sizeof(struct ftgmac100_rxdes),
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   927  					 &priv->rxdes_dma, GFP_KERNEL);
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   928  	if (!priv->rxdes)
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   929  		return -ENOMEM;
750afb08ca71310 drivers/net/ethernet/faraday/ftgmac100.c Luis Chamberlain       2019-01-04   930  	priv->txdes = dma_alloc_coherent(priv->dev,
750afb08ca71310 drivers/net/ethernet/faraday/ftgmac100.c Luis Chamberlain       2019-01-04   931  					 MAX_TX_QUEUE_ENTRIES * sizeof(struct ftgmac100_txdes),
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   932  					 &priv->txdes_dma, GFP_KERNEL);
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   933  	if (!priv->txdes)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   934  		return -ENOMEM;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   935  
d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   936  	/* Allocate scratch packet buffer */
d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   937  	priv->rx_scratch = dma_alloc_coherent(priv->dev,
d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   938  					      RX_BUF_SIZE,
d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   939  					      &priv->rx_scratch_dma,
d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   940  					      GFP_KERNEL);
d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   941  	if (!priv->rx_scratch)
d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   942  		return -ENOMEM;
d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   943  
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   944  	return 0;
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   945  }
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   946  
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   947  static void ftgmac100_init_rings(struct ftgmac100 *priv)
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   948  {
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   949  	struct ftgmac100_rxdes *rxdes = NULL;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   950  	struct ftgmac100_txdes *txdes = NULL;
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   951  	int i;
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   952  
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   953  	/* Update entries counts */
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   954  	priv->rx_q_entries = priv->new_rx_q_entries;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   955  	priv->tx_q_entries = priv->new_tx_q_entries;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   956  
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   957  	if (WARN_ON(priv->rx_q_entries < MIN_RX_QUEUE_ENTRIES))
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   958  		return;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   959  
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   960  	/* Initialize RX ring */
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   961  	for (i = 0; i < priv->rx_q_entries; i++) {
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   962  		rxdes = &priv->rxdes[i];
d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   963  		rxdes->rxdes0 = 0;
4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   964  		rxdes->rxdes3 = cpu_to_le32(priv->rx_scratch_dma);
d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   965  	}
4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   966  	/* Mark the end of the ring */
4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   967  	rxdes->rxdes0 |= cpu_to_le32(priv->rxdes0_edorr_mask);
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   968  
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   969  	if (WARN_ON(priv->tx_q_entries < MIN_RX_QUEUE_ENTRIES))
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   970  		return;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   971  
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   972  	/* Initialize TX ring */
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   973  	for (i = 0; i < priv->tx_q_entries; i++) {
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   974  		txdes = &priv->txdes[i];
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   975  		txdes->txdes0 = 0;
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   976  	}
52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10   977  	txdes->txdes0 |= cpu_to_le32(priv->txdes0_edotr_mask);
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   978  }
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   979  
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   980  static int ftgmac100_alloc_rx_buffers(struct ftgmac100 *priv)
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   981  {
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   982  	int i;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   983  
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   984  	for (i = 0; i < priv->rx_q_entries; i++) {
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12   985  		struct ftgmac100_rxdes *rxdes = &priv->rxdes[i];
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   986  
7b49cd1c9eca4ac drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06   987  		if (ftgmac100_alloc_rx_buf(priv, i, rxdes, GFP_KERNEL))
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   988  			return -ENOMEM;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   989  	}
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   990  	return 0;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   991  }
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   992  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   993  static void ftgmac100_adjust_link(struct net_device *netdev)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   994  {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   995  	struct ftgmac100 *priv = netdev_priv(netdev);
b3c40adcc9891a7 drivers/net/ethernet/faraday/ftgmac100.c Philippe Reynes        2016-05-16   996  	struct phy_device *phydev = netdev->phydev;
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18   997  	bool tx_pause, rx_pause;
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05   998  	int new_speed;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08   999  
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1000  	/* We store "no link" as speed 0 */
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1001  	if (!phydev->link)
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1002  		new_speed = 0;
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1003  	else
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1004  		new_speed = phydev->speed;
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1005  
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1006  	/* Grab pause settings from PHY if configured to do so */
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1007  	if (priv->aneg_pause) {
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1008  		rx_pause = tx_pause = phydev->pause;
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1009  		if (phydev->asym_pause)
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1010  			tx_pause = !rx_pause;
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1011  	} else {
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1012  		rx_pause = priv->rx_pause;
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1013  		tx_pause = priv->tx_pause;
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1014  	}
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1015  
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1016  	/* Link hasn't changed, do nothing */
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1017  	if (phydev->speed == priv->cur_speed &&
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1018  	    phydev->duplex == priv->cur_duplex &&
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1019  	    rx_pause == priv->rx_pause &&
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1020  	    tx_pause == priv->tx_pause)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1021  		return;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1022  
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1023  	/* Print status if we have a link or we had one and just lost it,
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1024  	 * don't print otherwise.
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1025  	 */
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1026  	if (new_speed || priv->cur_speed)
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1027  		phy_print_status(phydev);
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1028  
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1029  	priv->cur_speed = new_speed;
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1030  	priv->cur_duplex = phydev->duplex;
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1031  	priv->rx_pause = rx_pause;
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1032  	priv->tx_pause = tx_pause;
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1033  
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1034  	/* Link is down, do nothing else */
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1035  	if (!new_speed)
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1036  		return;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1037  
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1038  	/* Disable all interrupts */
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1039  	iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1040  
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1041  	/* Reset the adapter asynchronously */
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1042  	schedule_work(&priv->reset_task);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1043  }
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1044  
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1045  static int ftgmac100_mii_probe(struct ftgmac100 *priv, phy_interface_t intf)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1046  {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1047  	struct net_device *netdev = priv->netdev;
e574f39816f0227 drivers/net/ethernet/faraday/ftgmac100.c Guenter Roeck          2016-01-10  1048  	struct phy_device *phydev;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1049  
e574f39816f0227 drivers/net/ethernet/faraday/ftgmac100.c Guenter Roeck          2016-01-10  1050  	phydev = phy_find_first(priv->mii_bus);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1051  	if (!phydev) {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1052  		netdev_info(netdev, "%s: no PHY found\n", netdev->name);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1053  		return -ENODEV;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1054  	}
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1055  
84eff6d194df442 drivers/net/ethernet/faraday/ftgmac100.c Andrew Lunn            2016-01-06  1056  	phydev = phy_connect(netdev, phydev_name(phydev),
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1057  			     &ftgmac100_adjust_link, intf);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1058  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1059  	if (IS_ERR(phydev)) {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1060  		netdev_err(netdev, "%s: Could not attach to PHY\n", netdev->name);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1061  		return PTR_ERR(phydev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1062  	}
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1063  
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1064  	/* Indicate that we support PAUSE frames (see comment in
cb1aaebea8d7986 drivers/net/ethernet/faraday/ftgmac100.c Mauro Carvalho Chehab  2019-06-07  1065  	 * Documentation/networking/phy.rst)
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1066  	 */
af8d9bb2f2f405a drivers/net/ethernet/faraday/ftgmac100.c Andrew Lunn            2018-09-12  1067  	phy_support_asym_pause(phydev);
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1068  
33de693248b4564 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1069  	/* Display what we found */
33de693248b4564 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1070  	phy_attached_info(phydev);
33de693248b4564 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1071  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1072  	return 0;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1073  }
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1074  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1075  static int ftgmac100_mdiobus_read(struct mii_bus *bus, int phy_addr, int regnum)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1076  {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1077  	struct net_device *netdev = bus->priv;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1078  	struct ftgmac100 *priv = netdev_priv(netdev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1079  	unsigned int phycr;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1080  	int i;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1081  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1082  	phycr = ioread32(priv->base + FTGMAC100_OFFSET_PHYCR);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1083  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1084  	/* preserve MDC cycle threshold */
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1085  	phycr &= FTGMAC100_PHYCR_MDC_CYCTHR_MASK;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1086  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1087  	phycr |= FTGMAC100_PHYCR_PHYAD(phy_addr) |
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1088  		 FTGMAC100_PHYCR_REGAD(regnum) |
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1089  		 FTGMAC100_PHYCR_MIIRD;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1090  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1091  	iowrite32(phycr, priv->base + FTGMAC100_OFFSET_PHYCR);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1092  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1093  	for (i = 0; i < 10; i++) {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1094  		phycr = ioread32(priv->base + FTGMAC100_OFFSET_PHYCR);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1095  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1096  		if ((phycr & FTGMAC100_PHYCR_MIIRD) == 0) {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1097  			int data;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1098  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1099  			data = ioread32(priv->base + FTGMAC100_OFFSET_PHYDATA);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1100  			return FTGMAC100_PHYDATA_MIIRDATA(data);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1101  		}
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1102  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1103  		udelay(100);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1104  	}
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1105  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1106  	netdev_err(netdev, "mdio read timed out\n");
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1107  	return -EIO;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1108  }
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1109  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1110  static int ftgmac100_mdiobus_write(struct mii_bus *bus, int phy_addr,
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1111  				   int regnum, u16 value)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1112  {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1113  	struct net_device *netdev = bus->priv;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1114  	struct ftgmac100 *priv = netdev_priv(netdev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1115  	unsigned int phycr;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1116  	int data;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1117  	int i;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1118  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1119  	phycr = ioread32(priv->base + FTGMAC100_OFFSET_PHYCR);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1120  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1121  	/* preserve MDC cycle threshold */
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1122  	phycr &= FTGMAC100_PHYCR_MDC_CYCTHR_MASK;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1123  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1124  	phycr |= FTGMAC100_PHYCR_PHYAD(phy_addr) |
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1125  		 FTGMAC100_PHYCR_REGAD(regnum) |
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1126  		 FTGMAC100_PHYCR_MIIWR;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1127  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1128  	data = FTGMAC100_PHYDATA_MIIWDATA(value);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1129  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1130  	iowrite32(data, priv->base + FTGMAC100_OFFSET_PHYDATA);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1131  	iowrite32(phycr, priv->base + FTGMAC100_OFFSET_PHYCR);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1132  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1133  	for (i = 0; i < 10; i++) {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1134  		phycr = ioread32(priv->base + FTGMAC100_OFFSET_PHYCR);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1135  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1136  		if ((phycr & FTGMAC100_PHYCR_MIIWR) == 0)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1137  			return 0;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1138  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1139  		udelay(100);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1140  	}
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1141  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1142  	netdev_err(netdev, "mdio write timed out\n");
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1143  	return -EIO;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1144  }
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1145  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1146  static void ftgmac100_get_drvinfo(struct net_device *netdev,
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1147  				  struct ethtool_drvinfo *info)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1148  {
7826d43f2db45c9 drivers/net/ethernet/faraday/ftgmac100.c Jiri Pirko             2013-01-06  1149  	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
7826d43f2db45c9 drivers/net/ethernet/faraday/ftgmac100.c Jiri Pirko             2013-01-06  1150  	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
7826d43f2db45c9 drivers/net/ethernet/faraday/ftgmac100.c Jiri Pirko             2013-01-06  1151  	strlcpy(info->bus_info, dev_name(&netdev->dev), sizeof(info->bus_info));
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1152  }
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1153  
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1154  static void ftgmac100_get_ringparam(struct net_device *netdev,
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1155  				    struct ethtool_ringparam *ering)
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1156  {
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1157  	struct ftgmac100 *priv = netdev_priv(netdev);
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1158  
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1159  	memset(ering, 0, sizeof(*ering));
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1160  	ering->rx_max_pending = MAX_RX_QUEUE_ENTRIES;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1161  	ering->tx_max_pending = MAX_TX_QUEUE_ENTRIES;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1162  	ering->rx_pending = priv->rx_q_entries;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1163  	ering->tx_pending = priv->tx_q_entries;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1164  }
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1165  
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1166  static int ftgmac100_set_ringparam(struct net_device *netdev,
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1167  				   struct ethtool_ringparam *ering)
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1168  {
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1169  	struct ftgmac100 *priv = netdev_priv(netdev);
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1170  
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1171  	if (ering->rx_pending > MAX_RX_QUEUE_ENTRIES ||
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1172  	    ering->tx_pending > MAX_TX_QUEUE_ENTRIES ||
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1173  	    ering->rx_pending < MIN_RX_QUEUE_ENTRIES ||
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1174  	    ering->tx_pending < MIN_TX_QUEUE_ENTRIES ||
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1175  	    !is_power_of_2(ering->rx_pending) ||
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1176  	    !is_power_of_2(ering->tx_pending))
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1177  		return -EINVAL;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1178  
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1179  	priv->new_rx_q_entries = ering->rx_pending;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1180  	priv->new_tx_q_entries = ering->tx_pending;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1181  	if (netif_running(netdev))
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1182  		schedule_work(&priv->reset_task);
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1183  
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1184  	return 0;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1185  }
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1186  
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1187  static void ftgmac100_get_pauseparam(struct net_device *netdev,
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1188  				     struct ethtool_pauseparam *pause)
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1189  {
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1190  	struct ftgmac100 *priv = netdev_priv(netdev);
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1191  
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1192  	pause->autoneg = priv->aneg_pause;
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1193  	pause->tx_pause = priv->tx_pause;
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1194  	pause->rx_pause = priv->rx_pause;
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1195  }
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1196  
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1197  static int ftgmac100_set_pauseparam(struct net_device *netdev,
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1198  				    struct ethtool_pauseparam *pause)
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1199  {
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1200  	struct ftgmac100 *priv = netdev_priv(netdev);
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1201  	struct phy_device *phydev = netdev->phydev;
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1202  
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1203  	priv->aneg_pause = pause->autoneg;
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1204  	priv->tx_pause = pause->tx_pause;
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1205  	priv->rx_pause = pause->rx_pause;
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1206  
70814e819c1139e drivers/net/ethernet/faraday/ftgmac100.c Andrew Lunn            2018-09-12  1207  	if (phydev)
70814e819c1139e drivers/net/ethernet/faraday/ftgmac100.c Andrew Lunn            2018-09-12  1208  		phy_set_asym_pause(phydev, pause->rx_pause, pause->tx_pause);
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1209  
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1210  	if (netif_running(netdev)) {
70814e819c1139e drivers/net/ethernet/faraday/ftgmac100.c Andrew Lunn            2018-09-12  1211  		if (!(phydev && priv->aneg_pause))
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1212  			ftgmac100_config_pause(priv);
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1213  	}
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1214  
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1215  	return 0;
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1216  }
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1217  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1218  static const struct ethtool_ops ftgmac100_ethtool_ops = {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1219  	.get_drvinfo		= ftgmac100_get_drvinfo,
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1220  	.get_link		= ethtool_op_get_link,
fd24d72ca9b5255 drivers/net/ethernet/faraday/ftgmac100.c Philippe Reynes        2016-05-16  1221  	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
fd24d72ca9b5255 drivers/net/ethernet/faraday/ftgmac100.c Philippe Reynes        2016-05-16  1222  	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
e98233a6192d75d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1223  	.nway_reset		= phy_ethtool_nway_reset,
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1224  	.get_ringparam		= ftgmac100_get_ringparam,
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1225  	.set_ringparam		= ftgmac100_set_ringparam,
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1226  	.get_pauseparam		= ftgmac100_get_pauseparam,
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1227  	.set_pauseparam		= ftgmac100_set_pauseparam,
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1228  };
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1229  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1230  static irqreturn_t ftgmac100_interrupt(int irq, void *dev_id)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1231  {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1232  	struct net_device *netdev = dev_id;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1233  	struct ftgmac100 *priv = netdev_priv(netdev);
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1234  	unsigned int status, new_mask = FTGMAC100_INT_BAD;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1235  
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1236  	/* Fetch and clear interrupt bits, process abnormal ones */
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1237  	status = ioread32(priv->base + FTGMAC100_OFFSET_ISR);
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1238  	iowrite32(status, priv->base + FTGMAC100_OFFSET_ISR);
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1239  	if (unlikely(status & FTGMAC100_INT_BAD)) {
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1240  
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1241  		/* RX buffer unavailable */
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1242  		if (status & FTGMAC100_INT_NO_RXBUF)
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1243  			netdev->stats.rx_over_errors++;
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1244  
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1245  		/* received packet lost due to RX FIFO full */
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1246  		if (status & FTGMAC100_INT_RPKT_LOST)
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1247  			netdev->stats.rx_fifo_errors++;
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1248  
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1249  		/* sent packet lost due to excessive TX collision */
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1250  		if (status & FTGMAC100_INT_XPKT_LOST)
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1251  			netdev->stats.tx_fifo_errors++;
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1252  
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1253  		/* AHB error -> Reset the chip */
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1254  		if (status & FTGMAC100_INT_AHB_ERR) {
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1255  			if (net_ratelimit())
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1256  				netdev_warn(netdev,
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1257  					   "AHB bus error ! Resetting chip.\n");
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1258  			iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1259  			schedule_work(&priv->reset_task);
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1260  			return IRQ_HANDLED;
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1261  		}
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1262  
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1263  		/* We may need to restart the MAC after such errors, delay
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1264  		 * this until after we have freed some Rx buffers though
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1265  		 */
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1266  		priv->need_mac_restart = true;
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1267  
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1268  		/* Disable those errors until we restart */
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1269  		new_mask &= ~status;
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1270  	}
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1271  
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1272  	/* Only enable "bad" interrupts while NAPI is on */
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1273  	iowrite32(new_mask, priv->base + FTGMAC100_OFFSET_IER);
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1274  
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1275  	/* Schedule NAPI bh */
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1276  	napi_schedule_irqoff(&priv->napi);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1277  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1278  	return IRQ_HANDLED;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1279  }
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1280  
4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06  1281  static bool ftgmac100_check_rx(struct ftgmac100 *priv)
4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06  1282  {
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1283  	struct ftgmac100_rxdes *rxdes = &priv->rxdes[priv->rx_pointer];
4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06  1284  
4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06  1285  	/* Do we have a packet ? */
4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06  1286  	return !!(rxdes->rxdes0 & cpu_to_le32(FTGMAC100_RXDES0_RXPKT_RDY));
4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06  1287  }
4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-06  1288  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1289  static int ftgmac100_poll(struct napi_struct *napi, int budget)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1290  {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1291  	struct ftgmac100 *priv = container_of(napi, struct ftgmac100, napi);
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1292  	int work_done = 0;
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1293  	bool more;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1294  
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1295  	/* Handle TX completions */
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1296  	if (ftgmac100_tx_buf_cleanable(priv))
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1297  		ftgmac100_tx_complete(priv);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1298  
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1299  	/* Handle RX packets */
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1300  	do {
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1301  		more = ftgmac100_rx_packet(priv, &work_done);
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1302  	} while (more && work_done < budget);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1303  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1304  
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1305  	/* The interrupt is telling us to kick the MAC back to life
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1306  	 * after an RX overflow
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1307  	 */
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1308  	if (unlikely(priv->need_mac_restart)) {
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1309  		ftgmac100_start_hw(priv);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1310  
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1311  		/* Re-enable "bad" interrupts */
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1312  		iowrite32(FTGMAC100_INT_BAD,
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1313  			  priv->base + FTGMAC100_OFFSET_IER);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1314  	}
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1315  
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1316  	/* As long as we are waiting for transmit packets to be
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1317  	 * completed we keep NAPI going
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1318  	 */
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1319  	if (ftgmac100_tx_buf_cleanable(priv))
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1320  		work_done = budget;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1321  
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1322  	if (work_done < budget) {
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1323  		/* We are about to re-enable all interrupts. However
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1324  		 * the HW has been latching RX/TX packet interrupts while
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1325  		 * they were masked. So we clear them first, then we need
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1326  		 * to re-check if there's something to process
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1327  		 */
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1328  		iowrite32(FTGMAC100_INT_RXTX,
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1329  			  priv->base + FTGMAC100_OFFSET_ISR);
ccaf725a1fd7904 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1330  
ccaf725a1fd7904 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1331  		/* Push the above (and provides a barrier vs. subsequent
ccaf725a1fd7904 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1332  		 * reads of the descriptor).
ccaf725a1fd7904 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1333  		 */
ccaf725a1fd7904 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1334  		ioread32(priv->base + FTGMAC100_OFFSET_ISR);
ccaf725a1fd7904 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1335  
ccaf725a1fd7904 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1336  		/* Check RX and TX descriptors for more work to do */
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1337  		if (ftgmac100_check_rx(priv) ||
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1338  		    ftgmac100_tx_buf_cleanable(priv))
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1339  			return budget;
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1340  
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1341  		/* deschedule NAPI */
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1342  		napi_complete(napi);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1343  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1344  		/* enable all interrupts */
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1345  		iowrite32(FTGMAC100_INT_ALL,
fc6061cf93524c3 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1346  			  priv->base + FTGMAC100_OFFSET_IER);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1347  	}
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1348  
6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1349  	return work_done;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1350  }
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1351  
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1352  static int ftgmac100_init_all(struct ftgmac100 *priv, bool ignore_alloc_err)
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1353  {
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1354  	int err = 0;
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1355  
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1356  	/* Re-init descriptors (adjust queue sizes) */
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1357  	ftgmac100_init_rings(priv);
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1358  
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1359  	/* Realloc rx descriptors */
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1360  	err = ftgmac100_alloc_rx_buffers(priv);
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1361  	if (err && !ignore_alloc_err)
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1362  		return err;
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1363  
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1364  	/* Reinit and restart HW */
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1365  	ftgmac100_init_hw(priv);
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1366  	ftgmac100_config_pause(priv);
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1367  	ftgmac100_start_hw(priv);
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1368  
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1369  	/* Re-enable the device */
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1370  	napi_enable(&priv->napi);
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1371  	netif_start_queue(priv->netdev);
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1372  
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1373  	/* Enable all interrupts */
10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1374  	iowrite32(FTGMAC100_INT_ALL, priv->base + FTGMAC100_OFFSET_IER);
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1375  
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1376  	return err;
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1377  }
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1378  
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1379  static void ftgmac100_reset_task(struct work_struct *work)
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1380  {
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1381  	struct ftgmac100 *priv = container_of(work, struct ftgmac100,
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1382  					      reset_task);
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1383  	struct net_device *netdev = priv->netdev;
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1384  	int err;
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1385  
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1386  	netdev_dbg(netdev, "Resetting NIC...\n");
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1387  
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1388  	/* Lock the world */
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1389  	rtnl_lock();
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1390  	if (netdev->phydev)
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1391  		mutex_lock(&netdev->phydev->lock);
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1392  	if (priv->mii_bus)
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1393  		mutex_lock(&priv->mii_bus->mdio_lock);
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1394  
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1395  
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1396  	/* Check if the interface is still up */
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1397  	if (!netif_running(netdev))
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1398  		goto bail;
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1399  
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1400  	/* Stop the network stack */
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1401  	netif_trans_update(netdev);
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1402  	napi_disable(&priv->napi);
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1403  	netif_tx_disable(netdev);
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1404  
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1405  	/* Stop and reset the MAC */
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1406  	ftgmac100_stop_hw(priv);
874b55bf62330ca drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1407  	err = ftgmac100_reset_and_config_mac(priv);
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1408  	if (err) {
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1409  		/* Not much we can do ... it might come back... */
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1410  		netdev_err(netdev, "attempting to continue...\n");
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1411  	}
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1412  
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1413  	/* Free all rx and tx buffers */
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1414  	ftgmac100_free_buffers(priv);
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1415  
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1416  	/* Setup everything again and restart chip */
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1417  	ftgmac100_init_all(priv, true);
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1418  
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1419  	netdev_dbg(netdev, "Reset done !\n");
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1420   bail:
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1421  	if (priv->mii_bus)
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1422  		mutex_unlock(&priv->mii_bus->mdio_lock);
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1423  	if (netdev->phydev)
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1424  		mutex_unlock(&netdev->phydev->lock);
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1425  	rtnl_unlock();
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1426  }
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1427  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1428  static int ftgmac100_open(struct net_device *netdev)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1429  {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1430  	struct ftgmac100 *priv = netdev_priv(netdev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1431  	int err;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1432  
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1433  	/* Allocate ring buffers  */
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1434  	err = ftgmac100_alloc_rings(priv);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1435  	if (err) {
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1436  		netdev_err(netdev, "Failed to allocate descriptors\n");
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1437  		return err;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1438  	}
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1439  
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1440  	/* When using NC-SI we force the speed to 100Mbit/s full duplex,
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1441  	 *
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1442  	 * Otherwise we leave it set to 0 (no link), the link
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1443  	 * message from the PHY layer will handle setting it up to
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1444  	 * something else if needed.
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1445  	 */
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1446  	if (priv->use_ncsi) {
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1447  		priv->cur_duplex = DUPLEX_FULL;
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1448  		priv->cur_speed = SPEED_100;
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1449  	} else {
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1450  		priv->cur_duplex = 0;
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1451  		priv->cur_speed = 0;
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1452  	}
51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1453  
874b55bf62330ca drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1454  	/* Reset the hardware */
874b55bf62330ca drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1455  	err = ftgmac100_reset_and_config_mac(priv);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1456  	if (err)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1457  		goto err_hw;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1458  
b8dbecff9bab825 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1459  	/* Initialize NAPI */
b8dbecff9bab825 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1460  	netif_napi_add(netdev, &priv->napi, ftgmac100_poll, 64);
b8dbecff9bab825 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1461  
81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1462  	/* Grab our interrupt */
81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1463  	err = request_irq(netdev->irq, ftgmac100_interrupt, 0, netdev->name, netdev);
81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1464  	if (err) {
81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1465  		netdev_err(netdev, "failed to request irq %d\n", netdev->irq);
81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1466  		goto err_irq;
81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1467  	}
81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1468  
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1469  	/* Start things up */
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1470  	err = ftgmac100_init_all(priv, false);
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1471  	if (err) {
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1472  		netdev_err(netdev, "Failed to allocate packet buffers\n");
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1473  		goto err_alloc;
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1474  	}
08c9c126004e999 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-09-22  1475  
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1476  	if (netdev->phydev) {
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1477  		/* If we have a PHY, start polling */
b3c40adcc9891a7 drivers/net/ethernet/faraday/ftgmac100.c Philippe Reynes        2016-05-16  1478  		phy_start(netdev->phydev);
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1479  	} else if (priv->use_ncsi) {
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1480  		/* If using NC-SI, set our carrier on and start the stack */
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1481  		netif_carrier_on(netdev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1482  
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1483  		/* Start the NCSI device */
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1484  		err = ncsi_start_dev(priv->ndev);
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1485  		if (err)
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1486  			goto err_ncsi;
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1487  	}
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1488  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1489  	return 0;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1490  
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1491   err_ncsi:
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1492  	napi_disable(&priv->napi);
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1493  	netif_stop_queue(netdev);
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1494   err_alloc:
da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1495  	ftgmac100_free_buffers(priv);
60b28a1167749c5 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1496  	free_irq(netdev->irq, netdev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1497   err_irq:
81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1498  	netif_napi_del(&priv->napi);
81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1499   err_hw:
81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1500  	iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1501  	ftgmac100_free_rings(priv);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1502  	return err;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1503  }
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1504  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1505  static int ftgmac100_stop(struct net_device *netdev)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1506  {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1507  	struct ftgmac100 *priv = netdev_priv(netdev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1508  
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1509  	/* Note about the reset task: We are called with the rtnl lock
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1510  	 * held, so we are synchronized against the core of the reset
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1511  	 * task. We must not try to synchronously cancel it otherwise
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1512  	 * we can deadlock. But since it will test for netif_running()
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1513  	 * which has already been cleared by the net core, we don't
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1514  	 * anything special to do.
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1515  	 */
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1516  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1517  	/* disable all interrupts */
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1518  	iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1519  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1520  	netif_stop_queue(netdev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1521  	napi_disable(&priv->napi);
b8dbecff9bab825 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1522  	netif_napi_del(&priv->napi);
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1523  	if (netdev->phydev)
b3c40adcc9891a7 drivers/net/ethernet/faraday/ftgmac100.c Philippe Reynes        2016-05-16  1524  		phy_stop(netdev->phydev);
2c15f25b2923435 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-10-04  1525  	else if (priv->use_ncsi)
2c15f25b2923435 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-10-04  1526  		ncsi_stop_dev(priv->ndev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1527  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1528  	ftgmac100_stop_hw(priv);
60b28a1167749c5 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1529  	free_irq(netdev->irq, netdev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1530  	ftgmac100_free_buffers(priv);
87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1531  	ftgmac100_free_rings(priv);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1532  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1533  	return 0;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1534  }
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1535  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1536  /* optional */
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1537  static int ftgmac100_do_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1538  {
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1539  	if (!netdev->phydev)
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1540  		return -ENXIO;
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1541  
b3c40adcc9891a7 drivers/net/ethernet/faraday/ftgmac100.c Philippe Reynes        2016-05-16  1542  	return phy_mii_ioctl(netdev->phydev, ifr, cmd);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1543  }
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1544  
d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1545  static void ftgmac100_tx_timeout(struct net_device *netdev)
d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1546  {
d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1547  	struct ftgmac100 *priv = netdev_priv(netdev);
d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1548  
d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1549  	/* Disable all interrupts */
d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1550  	iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1551  
d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1552  	/* Do the reset outside of interrupt context */
d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1553  	schedule_work(&priv->reset_task);
d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1554  }
d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1555  
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1556  static int ftgmac100_set_features(struct net_device *netdev,
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1557  				  netdev_features_t features)
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1558  {
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1559  	struct ftgmac100 *priv = netdev_priv(netdev);
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1560  	netdev_features_t changed = netdev->features ^ features;
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1561  
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1562  	if (!netif_running(netdev))
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1563  		return 0;
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1564  
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1565  	/* Update the vlan filtering bit */
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1566  	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1567  		u32 maccr;
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1568  
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1569  		maccr = ioread32(priv->base + FTGMAC100_OFFSET_MACCR);
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1570  		if (priv->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1571  			maccr |= FTGMAC100_MACCR_RM_VLAN;
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1572  		else
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1573  			maccr &= ~FTGMAC100_MACCR_RM_VLAN;
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1574  		iowrite32(maccr, priv->base + FTGMAC100_OFFSET_MACCR);
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1575  	}
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1576  
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1577  	return 0;
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1578  }
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1579  
030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1580  #ifdef CONFIG_NET_POLL_CONTROLLER
030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1581  static void ftgmac100_poll_controller(struct net_device *netdev)
030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1582  {
030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1583  	unsigned long flags;
030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1584  
030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1585  	local_irq_save(flags);
030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1586  	ftgmac100_interrupt(netdev->irq, netdev);
030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1587  	local_irq_restore(flags);
030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1588  }
030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1589  #endif
030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1590  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1591  static const struct net_device_ops ftgmac100_netdev_ops = {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1592  	.ndo_open		= ftgmac100_open,
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1593  	.ndo_stop		= ftgmac100_stop,
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1594  	.ndo_start_xmit		= ftgmac100_hard_start_xmit,
113ce107afe9799 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1595  	.ndo_set_mac_address	= ftgmac100_set_mac_addr,
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1596  	.ndo_validate_addr	= eth_validate_addr,
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1597  	.ndo_do_ioctl		= ftgmac100_do_ioctl,
d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1598  	.ndo_tx_timeout		= ftgmac100_tx_timeout,
f48b3c0d5b6ab4d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1599  	.ndo_set_rx_mode	= ftgmac100_set_rx_mode,
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1600  	.ndo_set_features	= ftgmac100_set_features,
030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1601  #ifdef CONFIG_NET_POLL_CONTROLLER
030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1602  	.ndo_poll_controller	= ftgmac100_poll_controller,
030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1603  #endif
51564585d8c6de2 drivers/net/ethernet/faraday/ftgmac100.c Samuel Mendoza-Jonas   2017-08-28  1604  	.ndo_vlan_rx_add_vid	= ncsi_vlan_rx_add_vid,
51564585d8c6de2 drivers/net/ethernet/faraday/ftgmac100.c Samuel Mendoza-Jonas   2017-08-28  1605  	.ndo_vlan_rx_kill_vid	= ncsi_vlan_rx_kill_vid,
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1606  };
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1607  
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1608  static int ftgmac100_setup_mdio(struct net_device *netdev)
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1609  {
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1610  	struct ftgmac100 *priv = netdev_priv(netdev);
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1611  	struct platform_device *pdev = to_platform_device(priv->dev);
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1612  	int phy_intf = PHY_INTERFACE_MODE_RGMII;
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1613  	struct device_node *np = pdev->dev.of_node;
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1614  	int i, err = 0;
e07dc63ba22df2d drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2016-09-22  1615  	u32 reg;
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1616  
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1617  	/* initialize mdio bus */
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1618  	priv->mii_bus = mdiobus_alloc();
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1619  	if (!priv->mii_bus)
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1620  		return -EIO;
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1621  
78d28543a6093fa drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1622  	if (priv->is_aspeed) {
e07dc63ba22df2d drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2016-09-22  1623  		/* This driver supports the old MDIO interface */
e07dc63ba22df2d drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2016-09-22  1624  		reg = ioread32(priv->base + FTGMAC100_OFFSET_REVR);
e07dc63ba22df2d drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2016-09-22  1625  		reg &= ~FTGMAC100_REVR_NEW_MDIO_INTERFACE;
e07dc63ba22df2d drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2016-09-22  1626  		iowrite32(reg, priv->base + FTGMAC100_OFFSET_REVR);
f819cd926ca7c91 drivers/net/ethernet/faraday/ftgmac100.c YueHaibing             2019-03-01  1627  	}
e07dc63ba22df2d drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2016-09-22  1628  
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1629  	/* Get PHY mode from device-tree */
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1630  	if (np) {
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1631  		/* Default to RGMII. It's a gigabit part after all */
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1632  		phy_intf = of_get_phy_mode(np);
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1633  		if (phy_intf < 0)
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1634  			phy_intf = PHY_INTERFACE_MODE_RGMII;
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1635  
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1636  		/* Aspeed only supports these. I don't know about other IP
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1637  		 * block vendors so I'm going to just let them through for
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1638  		 * now. Note that this is only a warning if for some obscure
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1639  		 * reason the DT really means to lie about it or it's a newer
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1640  		 * part we don't know about.
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1641  		 *
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1642  		 * On the Aspeed SoC there are additionally straps and SCU
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1643  		 * control bits that could tell us what the interface is
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1644  		 * (or allow us to configure it while the IP block is held
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1645  		 * in reset). For now I chose to keep this driver away from
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1646  		 * those SoC specific bits and assume the device-tree is
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1647  		 * right and the SCU has been configured properly by pinmux
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1648  		 * or the firmware.
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1649  		 */
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1650  		if (priv->is_aspeed &&
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1651  		    phy_intf != PHY_INTERFACE_MODE_RMII &&
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1652  		    phy_intf != PHY_INTERFACE_MODE_RGMII &&
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1653  		    phy_intf != PHY_INTERFACE_MODE_RGMII_ID &&
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1654  		    phy_intf != PHY_INTERFACE_MODE_RGMII_RXID &&
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1655  		    phy_intf != PHY_INTERFACE_MODE_RGMII_TXID) {
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1656  			netdev_warn(netdev,
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1657  				   "Unsupported PHY mode %s !\n",
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1658  				   phy_modes(phy_intf));
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1659  		}
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1660  	}
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1661  
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1662  	priv->mii_bus->name = "ftgmac100_mdio";
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1663  	snprintf(priv->mii_bus->id, MII_BUS_ID_SIZE, "%s-%d",
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1664  		 pdev->name, pdev->id);
d57b9db1ae0cde3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-07-24  1665  	priv->mii_bus->parent = priv->dev;
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1666  	priv->mii_bus->priv = priv->netdev;
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1667  	priv->mii_bus->read = ftgmac100_mdiobus_read;
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1668  	priv->mii_bus->write = ftgmac100_mdiobus_write;
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1669  
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1670  	for (i = 0; i < PHY_MAX_ADDR; i++)
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1671  		priv->mii_bus->irq[i] = PHY_POLL;
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1672  
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1673  	err = mdiobus_register(priv->mii_bus);
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1674  	if (err) {
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1675  		dev_err(priv->dev, "Cannot register MDIO bus!\n");
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1676  		goto err_register_mdiobus;
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1677  	}
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1678  
abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1679  	err = ftgmac100_mii_probe(priv, phy_intf);
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1680  	if (err) {
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1681  		dev_err(priv->dev, "MII Probe failed!\n");
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1682  		goto err_mii_probe;
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1683  	}
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1684  
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1685  	return 0;
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1686  
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1687  err_mii_probe:
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1688  	mdiobus_unregister(priv->mii_bus);
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1689  err_register_mdiobus:
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1690  	mdiobus_free(priv->mii_bus);
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1691  	return err;
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1692  }
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1693  
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1694  static void ftgmac100_destroy_mdio(struct net_device *netdev)
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1695  {
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1696  	struct ftgmac100 *priv = netdev_priv(netdev);
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1697  
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1698  	if (!netdev->phydev)
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1699  		return;
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1700  
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1701  	phy_disconnect(netdev->phydev);
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1702  	mdiobus_unregister(priv->mii_bus);
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1703  	mdiobus_free(priv->mii_bus);
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1704  }
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1705  
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1706  static void ftgmac100_ncsi_handler(struct ncsi_dev *nd)
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1707  {
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1708  	if (unlikely(nd->state != ncsi_dev_state_functional))
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1709  		return;
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1710  
87975a0117815b9 drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2018-06-19  1711  	netdev_dbg(nd->dev, "NCSI interface %s\n",
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1712  		   nd->link_up ? "up" : "down");
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1713  }
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1714  
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1715  static void ftgmac100_setup_clk(struct ftgmac100 *priv)
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1716  {
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1717  	priv->clk = devm_clk_get(priv->dev, NULL);
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1718  	if (IS_ERR(priv->clk))
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1719  		return;
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1720  
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1721  	clk_prepare_enable(priv->clk);
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1722  
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1723  	/* Aspeed specifies a 100MHz clock is required for up to
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1724  	 * 1000Mbit link speeds. As NCSI is limited to 100Mbit, 25MHz
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1725  	 * is sufficient
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1726  	 */
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1727  	clk_set_rate(priv->clk, priv->use_ncsi ? FTGMAC_25MHZ :
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1728  			FTGMAC_100MHZ);
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1729  }
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1730  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1731  static int ftgmac100_probe(struct platform_device *pdev)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1732  {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1733  	struct resource *res;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1734  	int irq;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1735  	struct net_device *netdev;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1736  	struct ftgmac100 *priv;
78d28543a6093fa drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1737  	struct device_node *np;
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1738  	int err = 0;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1739  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1740  	if (!pdev)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1741  		return -ENODEV;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1742  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1743  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1744  	if (!res)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1745  		return -ENXIO;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1746  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1747  	irq = platform_get_irq(pdev, 0);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1748  	if (irq < 0)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1749  		return irq;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1750  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1751  	/* setup net_device */
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1752  	netdev = alloc_etherdev(sizeof(*priv));
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1753  	if (!netdev) {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1754  		err = -ENOMEM;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1755  		goto err_alloc_etherdev;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1756  	}
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1757  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1758  	SET_NETDEV_DEV(netdev, &pdev->dev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1759  
7ad24ea4bf620a3 drivers/net/ethernet/faraday/ftgmac100.c Wilfried Klaebe        2014-05-11  1760  	netdev->ethtool_ops = &ftgmac100_ethtool_ops;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1761  	netdev->netdev_ops = &ftgmac100_netdev_ops;
d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-10  1762  	netdev->watchdog_timeo = 5 * HZ;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1763  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1764  	platform_set_drvdata(pdev, netdev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1765  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1766  	/* setup private data */
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1767  	priv = netdev_priv(netdev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1768  	priv->netdev = netdev;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1769  	priv->dev = &pdev->dev;
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1770  	INIT_WORK(&priv->reset_task, ftgmac100_reset_task);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1771  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1772  	/* map io memory */
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1773  	priv->res = request_mem_region(res->start, resource_size(res),
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1774  				       dev_name(&pdev->dev));
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1775  	if (!priv->res) {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1776  		dev_err(&pdev->dev, "Could not reserve memory region\n");
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1777  		err = -ENOMEM;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1778  		goto err_req_mem;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1779  	}
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1780  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1781  	priv->base = ioremap(res->start, resource_size(res));
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1782  	if (!priv->base) {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1783  		dev_err(&pdev->dev, "Failed to ioremap ethernet registers\n");
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1784  		err = -EIO;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1785  		goto err_ioremap;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1786  	}
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1787  
60b28a1167749c5 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1788  	netdev->irq = irq;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1789  
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1790  	/* Enable pause */
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1791  	priv->tx_pause = true;
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1792  	priv->rx_pause = true;
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1793  	priv->aneg_pause = true;
7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1794  
113ce107afe9799 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1795  	/* MAC address from chip or random one */
ba1b1234d6a3ecb drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1796  	ftgmac100_initial_mac(priv);
113ce107afe9799 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1797  
78d28543a6093fa drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1798  	np = pdev->dev.of_node;
78d28543a6093fa drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1799  	if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac") ||
78d28543a6093fa drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1800  		   of_device_is_compatible(np, "aspeed,ast2500-mac"))) {
2a0ab8ebbec6341 drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2016-09-22  1801  		priv->rxdes0_edorr_mask = BIT(30);
2a0ab8ebbec6341 drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2016-09-22  1802  		priv->txdes0_edotr_mask = BIT(30);
78d28543a6093fa drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1803  		priv->is_aspeed = true;
2a0ab8ebbec6341 drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2016-09-22  1804  	} else {
2a0ab8ebbec6341 drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2016-09-22  1805  		priv->rxdes0_edorr_mask = BIT(15);
2a0ab8ebbec6341 drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2016-09-22  1806  		priv->txdes0_edotr_mask = BIT(15);
2a0ab8ebbec6341 drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2016-09-22  1807  	}
2a0ab8ebbec6341 drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2016-09-22  1808  
78d28543a6093fa drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1809  	if (np && of_get_property(np, "use-ncsi", NULL)) {
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1810  		if (!IS_ENABLED(CONFIG_NET_NCSI)) {
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1811  			dev_err(&pdev->dev, "NCSI stack not enabled\n");
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1812  			goto err_ncsi_dev;
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1813  		}
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1814  
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1815  		dev_info(&pdev->dev, "Using NCSI interface\n");
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1816  		priv->use_ncsi = true;
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1817  		priv->ndev = ncsi_register_dev(netdev, ftgmac100_ncsi_handler);
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1818  		if (!priv->ndev)
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1819  			goto err_ncsi_dev;
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1820  	} else {
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1821  		priv->use_ncsi = false;
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1822  		err = ftgmac100_setup_mdio(netdev);
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1823  		if (err)
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1824  			goto err_setup_mdio;
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1825  	}
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1826  
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1827  	if (priv->is_aspeed)
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1828  		ftgmac100_setup_clk(priv);
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1829  
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1830  	/* Default ring sizes */
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1831  	priv->rx_q_entries = priv->new_rx_q_entries = DEF_RX_QUEUE_ENTRIES;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1832  	priv->tx_q_entries = priv->new_tx_q_entries = DEF_TX_QUEUE_ENTRIES;
52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1833  
6aff0bf641cf69e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1834  	/* Base feature set */
8c3ed1315e129e9 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1835  	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1836  		NETIF_F_GRO | NETIF_F_SG | NETIF_F_HW_VLAN_CTAG_RX |
0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-18  1837  		NETIF_F_HW_VLAN_CTAG_TX;
6aff0bf641cf69e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1838  
51564585d8c6de2 drivers/net/ethernet/faraday/ftgmac100.c Samuel Mendoza-Jonas   2017-08-28  1839  	if (priv->use_ncsi)
51564585d8c6de2 drivers/net/ethernet/faraday/ftgmac100.c Samuel Mendoza-Jonas   2017-08-28  1840  		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
51564585d8c6de2 drivers/net/ethernet/faraday/ftgmac100.c Samuel Mendoza-Jonas   2017-08-28  1841  
6aff0bf641cf69e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1842  	/* AST2400  doesn't have working HW checksum generation */
6aff0bf641cf69e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1843  	if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac")))
8c3ed1315e129e9 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1844  		netdev->hw_features &= ~NETIF_F_HW_CSUM;
6aff0bf641cf69e drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1845  	if (np && of_get_property(np, "no-hw-checksum", NULL))
8c3ed1315e129e9 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1846  		netdev->hw_features &= ~(NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
8c3ed1315e129e9 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-12  1847  	netdev->features |= netdev->hw_features;
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1848  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1849  	/* register network device */
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1850  	err = register_netdev(netdev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1851  	if (err) {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1852  		dev_err(&pdev->dev, "Failed to register netdev\n");
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1853  		goto err_register_netdev;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1854  	}
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1855  
60b28a1167749c5 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1856  	netdev_info(netdev, "irq %d, mapped at %p\n", netdev->irq, priv->base);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1857  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1858  	return 0;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1859  
bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1860  err_ncsi_dev:
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1861  err_register_netdev:
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1862  	ftgmac100_destroy_mdio(netdev);
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1863  err_setup_mdio:
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1864  	iounmap(priv->base);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1865  err_ioremap:
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1866  	release_resource(priv->res);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1867  err_req_mem:
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1868  	free_netdev(netdev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1869  err_alloc_etherdev:
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1870  	return err;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1871  }
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1872  
be12502e2e64854 drivers/net/ethernet/faraday/ftgmac100.c Dmitry Torokhov        2017-03-01  1873  static int ftgmac100_remove(struct platform_device *pdev)
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1874  {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1875  	struct net_device *netdev;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1876  	struct ftgmac100 *priv;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1877  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1878  	netdev = platform_get_drvdata(pdev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1879  	priv = netdev_priv(netdev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1880  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1881  	unregister_netdev(netdev);
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1882  
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1883  	clk_disable_unprepare(priv->clk);
4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel Stanley           2017-10-13  1884  
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1885  	/* There's a small chance the reset task will have been re-queued,
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1886  	 * during stop, make sure it's gone before we free the structure.
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1887  	 */
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1888  	cancel_work_sync(&priv->reset_task);
855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin Herrenschmidt 2017-04-05  1889  
eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1890  	ftgmac100_destroy_mdio(netdev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1891  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1892  	iounmap(priv->base);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1893  	release_resource(priv->res);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1894  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1895  	netif_napi_del(&priv->napi);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1896  	free_netdev(netdev);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1897  	return 0;
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1898  }
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1899  
bb168e2e9e512e6 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1900  static const struct of_device_id ftgmac100_of_match[] = {
bb168e2e9e512e6 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1901  	{ .compatible = "faraday,ftgmac100" },
bb168e2e9e512e6 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1902  	{ }
bb168e2e9e512e6 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1903  };
bb168e2e9e512e6 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1904  MODULE_DEVICE_TABLE(of, ftgmac100_of_match);
bb168e2e9e512e6 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1905  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1906  static struct platform_driver ftgmac100_driver = {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1907  	.probe	= ftgmac100_probe,
be12502e2e64854 drivers/net/ethernet/faraday/ftgmac100.c Dmitry Torokhov        2017-03-01  1908  	.remove	= ftgmac100_remove,
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1909  	.driver	= {
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1910  		.name		= DRV_NAME,
bb168e2e9e512e6 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan             2016-07-19  1911  		.of_match_table	= ftgmac100_of_match,
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1912  	},
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1913  };
14f645d0deb4d18 drivers/net/ethernet/faraday/ftgmac100.c Sachin Kamat           2013-03-18  1914  module_platform_driver(ftgmac100_driver);
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1915  
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1916  MODULE_AUTHOR("Po-Yu Chuang <ratbert@faraday-tech.com>");
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1917  MODULE_DESCRIPTION("FTGMAC100 driver");
69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu Chuang           2011-06-08  1918  MODULE_LICENSE("GPL");

:::::: The code at line 777 was first introduced by commit
:::::: 6db7470445f0757d2e8f23f57d86611338717ebe ftgmac100: Add support for fragmented tx

:::::: TO: Benjamin Herrenschmidt <benh@kernel.crashing.org>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--tg7kd6hawdukrmow
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
wNRtQAMA

--tg7kd6hawdukrmow--
