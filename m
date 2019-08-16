Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3B08FECE
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 11:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfHPJVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 05:21:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:13000 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbfHPJVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 05:21:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Aug 2019 02:21:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,391,1559545200"; 
   d="gz'50?scan'50,208,50";a="179630066"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 16 Aug 2019 02:21:29 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hyYQK-000FKO-VN; Fri, 16 Aug 2019 17:21:28 +0800
Date:   Fri, 16 Aug 2019 17:21:12 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Sridhar Samudrala <sridhar.samudrala@intel.com>
Cc:     kbuild-all@01.org, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        sridhar.samudrala@intel.com, intel-wired-lan@lists.osuosl.org,
        maciej.fijalkowski@intel.com, tom.herbert@intel.com
Subject: Re: [PATCH bpf-next 3/5] i40e: Enable XDP_SKIP_BPF option for AF_XDP
 sockets
Message-ID: <201908161723.TSR15kHq%lkp@intel.com>
References: <1565840783-8269-4-git-send-email-sridhar.samudrala@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pjvhzu5vtiaqdt5t"
Content-Disposition: inline
In-Reply-To: <1565840783-8269-4-git-send-email-sridhar.samudrala@intel.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pjvhzu5vtiaqdt5t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Sridhar,

I love your patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/0day-ci/linux/commits/Sridhar-Samudrala/xsk-Convert-bool-zc-field-in-struct-xdp_umem-to-a-u32-bitmap/20190816-144642
base:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: x86_64-lkp (attached as .config)
compiler: gcc-7 (Debian 7.4.0-10) 7.4.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/ethernet/intel/i40e/i40e_txrx.c: In function 'i40e_run_xdp':
>> drivers/net/ethernet/intel/i40e/i40e_txrx.c:2215:9: error: implicit declaration of function 'xsk_umem_rcv'; did you mean 'xsk_rcv'? [-Werror=implicit-function-declaration]
      err = xsk_umem_rcv(umem, xdp);
            ^~~~~~~~~~~~
            xsk_rcv
   drivers/net/ethernet/intel/i40e/i40e_txrx.c: In function 'i40e_finalize_xdp_rx':
>> drivers/net/ethernet/intel/i40e/i40e_txrx.c:2322:4: error: implicit declaration of function 'xsk_umem_flush'; did you mean 'xsk_umem_fq_reuse'? [-Werror=implicit-function-declaration]
       xsk_umem_flush(umem);
       ^~~~~~~~~~~~~~
       xsk_umem_fq_reuse
   cc1: some warnings being treated as errors
--
   drivers/net/ethernet/intel/i40e/i40e_xsk.c: In function 'i40e_run_xdp_zc':
>> drivers/net/ethernet/intel/i40e/i40e_xsk.c:199:9: error: implicit declaration of function 'xsk_umem_rcv'; did you mean 'xsk_rcv'? [-Werror=implicit-function-declaration]
      err = xsk_umem_rcv(rx_ring->xsk_umem, xdp);
            ^~~~~~~~~~~~
            xsk_rcv
   cc1: some warnings being treated as errors

vim +2215 drivers/net/ethernet/intel/i40e/i40e_txrx.c

  2190	
  2191	/**
  2192	 * i40e_run_xdp - run an XDP program
  2193	 * @rx_ring: Rx ring being processed
  2194	 * @xdp: XDP buffer containing the frame
  2195	 **/
  2196	static struct sk_buff *i40e_run_xdp(struct i40e_ring *rx_ring,
  2197					    struct xdp_buff *xdp)
  2198	{
  2199		int err, result = I40E_XDP_PASS;
  2200		struct i40e_ring *xdp_ring;
  2201		struct bpf_prog *xdp_prog;
  2202		struct xdp_umem *umem;
  2203		u32 act;
  2204	
  2205		rcu_read_lock();
  2206		xdp_prog = READ_ONCE(rx_ring->xdp_prog);
  2207	
  2208		if (!xdp_prog)
  2209			goto xdp_out;
  2210	
  2211		prefetchw(xdp->data_hard_start); /* xdp_frame write */
  2212	
  2213		umem = xdp_get_umem_from_qid(rx_ring->netdev, rx_ring->queue_index);
  2214		if (xsk_umem_skip_bpf(umem)) {
> 2215			err = xsk_umem_rcv(umem, xdp);
  2216			result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
  2217			goto xdp_out;
  2218		}
  2219	
  2220		act = bpf_prog_run_xdp(xdp_prog, xdp);
  2221		switch (act) {
  2222		case XDP_PASS:
  2223			break;
  2224		case XDP_TX:
  2225			xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->queue_index];
  2226			result = i40e_xmit_xdp_tx_ring(xdp, xdp_ring);
  2227			break;
  2228		case XDP_REDIRECT:
  2229			err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
  2230			result = !err ? I40E_XDP_REDIR : I40E_XDP_CONSUMED;
  2231			break;
  2232		default:
  2233			bpf_warn_invalid_xdp_action(act);
  2234			/* fall through */
  2235		case XDP_ABORTED:
  2236			trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
  2237			/* fall through -- handle aborts by dropping packet */
  2238		case XDP_DROP:
  2239			result = I40E_XDP_CONSUMED;
  2240			break;
  2241		}
  2242	xdp_out:
  2243		rcu_read_unlock();
  2244		return ERR_PTR(-result);
  2245	}
  2246	
  2247	/**
  2248	 * i40e_rx_buffer_flip - adjusted rx_buffer to point to an unused region
  2249	 * @rx_ring: Rx ring
  2250	 * @rx_buffer: Rx buffer to adjust
  2251	 * @size: Size of adjustment
  2252	 **/
  2253	static void i40e_rx_buffer_flip(struct i40e_ring *rx_ring,
  2254					struct i40e_rx_buffer *rx_buffer,
  2255					unsigned int size)
  2256	{
  2257	#if (PAGE_SIZE < 8192)
  2258		unsigned int truesize = i40e_rx_pg_size(rx_ring) / 2;
  2259	
  2260		rx_buffer->page_offset ^= truesize;
  2261	#else
  2262		unsigned int truesize = SKB_DATA_ALIGN(i40e_rx_offset(rx_ring) + size);
  2263	
  2264		rx_buffer->page_offset += truesize;
  2265	#endif
  2266	}
  2267	
  2268	/**
  2269	 * i40e_xdp_ring_update_tail - Updates the XDP Tx ring tail register
  2270	 * @xdp_ring: XDP Tx ring
  2271	 *
  2272	 * This function updates the XDP Tx ring tail register.
  2273	 **/
  2274	void i40e_xdp_ring_update_tail(struct i40e_ring *xdp_ring)
  2275	{
  2276		/* Force memory writes to complete before letting h/w
  2277		 * know there are new descriptors to fetch.
  2278		 */
  2279		wmb();
  2280		writel_relaxed(xdp_ring->next_to_use, xdp_ring->tail);
  2281	}
  2282	
  2283	/**
  2284	 * i40e_update_rx_stats - Update Rx ring statistics
  2285	 * @rx_ring: rx descriptor ring
  2286	 * @total_rx_bytes: number of bytes received
  2287	 * @total_rx_packets: number of packets received
  2288	 *
  2289	 * This function updates the Rx ring statistics.
  2290	 **/
  2291	void i40e_update_rx_stats(struct i40e_ring *rx_ring,
  2292				  unsigned int total_rx_bytes,
  2293				  unsigned int total_rx_packets)
  2294	{
  2295		u64_stats_update_begin(&rx_ring->syncp);
  2296		rx_ring->stats.packets += total_rx_packets;
  2297		rx_ring->stats.bytes += total_rx_bytes;
  2298		u64_stats_update_end(&rx_ring->syncp);
  2299		rx_ring->q_vector->rx.total_packets += total_rx_packets;
  2300		rx_ring->q_vector->rx.total_bytes += total_rx_bytes;
  2301	}
  2302	
  2303	/**
  2304	 * i40e_finalize_xdp_rx - Bump XDP Tx tail and/or flush redirect map
  2305	 * @rx_ring: Rx ring
  2306	 * @xdp_res: Result of the receive batch
  2307	 *
  2308	 * This function bumps XDP Tx tail and/or flush redirect map, and
  2309	 * should be called when a batch of packets has been processed in the
  2310	 * napi loop.
  2311	 **/
  2312	void i40e_finalize_xdp_rx(struct i40e_ring *rx_ring, unsigned int xdp_res)
  2313	{
  2314		if (xdp_res & I40E_XDP_REDIR) {
  2315			struct xdp_umem *umem;
  2316	
  2317			umem = rx_ring->xsk_umem;
  2318			if (!umem)
  2319				umem = xdp_get_umem_from_qid(rx_ring->netdev,
  2320							     rx_ring->queue_index);
  2321			if (xsk_umem_skip_bpf(umem))
> 2322				xsk_umem_flush(umem);
  2323			else
  2324				xdp_do_flush_map();
  2325		}
  2326	
  2327		if (xdp_res & I40E_XDP_TX) {
  2328			struct i40e_ring *xdp_ring =
  2329				rx_ring->vsi->xdp_rings[rx_ring->queue_index];
  2330	
  2331			i40e_xdp_ring_update_tail(xdp_ring);
  2332		}
  2333	}
  2334	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--pjvhzu5vtiaqdt5t
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
DMIBAA==

--pjvhzu5vtiaqdt5t--
