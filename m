Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDBFB5AB9F
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 15:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfF2N4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 09:56:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:33034 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbfF2N4K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 09:56:10 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jun 2019 06:55:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,431,1557212400"; 
   d="scan'208";a="338175519"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 29 Jun 2019 06:55:41 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hhDpM-0001yQ-KJ; Sat, 29 Jun 2019 21:55:40 +0800
Date:   Sat, 29 Jun 2019 21:54:48 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Catherine Sullivan <csully@google.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Subject: Re: [PATCH net-next v2 2/4] gve: Add transmit and receive support
Message-ID: <201906292107.taC5EgR4%lkp@intel.com>
References: <20190628175633.143501-3-csully@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628175633.143501-3-csully@google.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Catherine,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Catherine-Sullivan/Add-gve-driver/20190629-143743
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/net/ethernet/google/gve/gve_rx.c:11:6: sparse: sparse: symbol 'gve_rx_remove_from_block' was not declared. Should it be static?
   drivers/net/ethernet/google/gve/gve_rx.c:217:16: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned int val @@    got restricted __be3unsigned int val @@
   drivers/net/ethernet/google/gve/gve_rx.c:217:16: sparse:    expected unsigned int val
   drivers/net/ethernet/google/gve/gve_rx.c:217:16: sparse:    got restricted __be32 [usertype]
   drivers/net/ethernet/google/gve/gve_rx.c:349:27: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __wsum [usertype] csum @@    got restricted __wsum [usertype] csum @@
   drivers/net/ethernet/google/gve/gve_rx.c:349:27: sparse:    expected restricted __wsum [usertype] csum
   drivers/net/ethernet/google/gve/gve_rx.c:349:27: sparse:    got restricted __be16 [usertype] csum
   drivers/net/ethernet/google/gve/gve_rx.c:374:19: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] flags_seq @@    got resunsigned short [usertype] flags_seq @@
   drivers/net/ethernet/google/gve/gve_rx.c:374:19: sparse:    expected unsigned short [usertype] flags_seq
   drivers/net/ethernet/google/gve/gve_rx.c:374:19: sparse:    got restricted __be16 [usertype] flags_seq
>> drivers/net/ethernet/google/gve/gve_rx.c:378:17: sparse: sparse: cast to restricted __be16
>> drivers/net/ethernet/google/gve/gve_rx.c:378:17: sparse: sparse: cast to restricted __be16
>> drivers/net/ethernet/google/gve/gve_rx.c:378:17: sparse: sparse: cast to restricted __be16
>> drivers/net/ethernet/google/gve/gve_rx.c:378:17: sparse: sparse: cast to restricted __be16

vim +378 drivers/net/ethernet/google/gve/gve_rx.c

   212	
   213	void gve_rx_write_doorbell(struct gve_priv *priv, struct gve_rx_ring *rx)
   214	{
   215		u32 db_idx = be32_to_cpu(rx->q_resources->db_index);
   216	
 > 217		writel(cpu_to_be32(rx->desc.fill_cnt), &priv->db_bar2[db_idx]);
   218	}
   219	
   220	static enum pkt_hash_types gve_rss_type(__be16 pkt_flags)
   221	{
   222		if (likely(pkt_flags & (GVE_RXF_TCP | GVE_RXF_UDP)))
   223			return PKT_HASH_TYPE_L4;
   224		if (pkt_flags & (GVE_RXF_IPV4 | GVE_RXF_IPV6))
   225			return PKT_HASH_TYPE_L3;
   226		return PKT_HASH_TYPE_L2;
   227	}
   228	
   229	static struct sk_buff *gve_rx_copy(struct net_device *dev,
   230					   struct napi_struct *napi,
   231					   struct gve_rx_slot_page_info *page_info,
   232					   u16 len)
   233	{
   234		struct sk_buff *skb = napi_alloc_skb(napi, len);
   235		void *va = page_info->page_address + GVE_RX_PAD +
   236			   page_info->page_offset;
   237	
   238		if (unlikely(!skb))
   239			return NULL;
   240	
   241		__skb_put(skb, len);
   242	
   243		skb_copy_to_linear_data(skb, va, len);
   244	
   245		skb->protocol = eth_type_trans(skb, dev);
   246		return skb;
   247	}
   248	
   249	static struct sk_buff *gve_rx_add_frags(struct net_device *dev,
   250						struct napi_struct *napi,
   251						struct gve_rx_slot_page_info *page_info,
   252						u16 len)
   253	{
   254		struct sk_buff *skb = napi_get_frags(napi);
   255	
   256		if (unlikely(!skb))
   257			return NULL;
   258	
   259		skb_add_rx_frag(skb, 0, page_info->page,
   260				page_info->page_offset +
   261				GVE_RX_PAD, len, PAGE_SIZE / 2);
   262	
   263		return skb;
   264	}
   265	
   266	static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info,
   267				     struct gve_rx_data_slot *data_ring)
   268	{
   269		u64 addr = be64_to_cpu(data_ring->qpl_offset);
   270	
   271		page_info->page_offset ^= PAGE_SIZE / 2;
   272		addr ^= PAGE_SIZE / 2;
   273		data_ring->qpl_offset = cpu_to_be64(addr);
   274	}
   275	
   276	static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
   277			   netdev_features_t feat)
   278	{
   279		struct gve_rx_slot_page_info *page_info;
   280		struct gve_priv *priv = rx->gve;
   281		struct napi_struct *napi = &priv->ntfy_blocks[rx->ntfy_id].napi;
   282		struct net_device *dev = priv->dev;
   283		struct sk_buff *skb;
   284		int pagecount;
   285		u16 len;
   286		u32 idx;
   287	
   288		/* drop this packet */
   289		if (unlikely(rx_desc->flags_seq & GVE_RXF_ERR))
   290			return true;
   291	
   292		len = be16_to_cpu(rx_desc->len) - GVE_RX_PAD;
   293		idx = rx->data.cnt & rx->data.mask;
   294		page_info = &rx->data.page_info[idx];
   295	
   296		/* gvnic can only receive into registered segments. If the buffer
   297		 * can't be recycled, our only choice is to copy the data out of
   298		 * it so that we can return it to the device.
   299		 */
   300	
   301	#if PAGE_SIZE == 4096
   302		if (len <= priv->rx_copybreak) {
   303			/* Just copy small packets */
   304			skb = gve_rx_copy(dev, napi, page_info, len);
   305			goto have_skb;
   306		}
   307		if (unlikely(!gve_can_recycle_pages(dev))) {
   308			skb = gve_rx_copy(dev, napi, page_info, len);
   309			goto have_skb;
   310		}
   311		pagecount = page_count(page_info->page);
   312		if (pagecount == 1) {
   313			/* No part of this page is used by any SKBs; we attach
   314			 * the page fragment to a new SKB and pass it up the
   315			 * stack.
   316			 */
   317			skb = gve_rx_add_frags(dev, napi, page_info, len);
   318			if (!skb)
   319				return true;
   320			/* Make sure the kernel stack can't release the page */
   321			get_page(page_info->page);
   322			/* "flip" to other packet buffer on this page */
   323			gve_rx_flip_buff(page_info, &rx->data.data_ring[idx]);
   324		} else if (pagecount >= 2) {
   325			/* We have previously passed the other half of this
   326			 * page up the stack, but it has not yet been freed.
   327			 */
   328			skb = gve_rx_copy(dev, napi, page_info, len);
   329		} else {
   330			WARN(pagecount < 1, "Pagecount should never be < 1");
   331			return false;
   332		}
   333	#else
   334		skb = gve_rx_copy(dev, napi, page_info, len);
   335	#endif
   336	
   337	have_skb:
   338		if (!skb)
   339			return true;
   340	
   341		rx->data.cnt++;
   342	
   343		if (likely(feat & NETIF_F_RXCSUM)) {
   344			/* NIC passes up the partial sum */
   345			if (rx_desc->csum)
   346				skb->ip_summed = CHECKSUM_COMPLETE;
   347			else
   348				skb->ip_summed = CHECKSUM_NONE;
   349			skb->csum = rx_desc->csum;
   350		}
   351	
   352		/* parse flags & pass relevant info up */
   353		if (likely(feat & NETIF_F_RXHASH) &&
   354		    gve_needs_rss(rx_desc->flags_seq))
   355			skb_set_hash(skb, be32_to_cpu(rx_desc->rss_hash),
   356				     gve_rss_type(rx_desc->flags_seq));
   357	
   358		if (skb_is_nonlinear(skb))
   359			napi_gro_frags(napi);
   360		else
   361			napi_gro_receive(napi, skb);
   362		return true;
   363	}
   364	
   365	static bool gve_rx_work_pending(struct gve_rx_ring *rx)
   366	{
   367		struct gve_rx_desc *desc;
   368		u16 flags_seq;
   369		u32 next_idx;
   370	
   371		next_idx = rx->desc.cnt & rx->desc.mask;
   372		desc = rx->desc.desc_ring + next_idx;
   373	
   374		flags_seq = desc->flags_seq;
   375		/* Make sure we have synchronized the seq no with the device */
   376		smp_rmb();
   377	
 > 378		return (GVE_SEQNO(flags_seq) == rx->desc.seqno);
   379	}
   380	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
