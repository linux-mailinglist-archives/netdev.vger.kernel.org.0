Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A70A4000A0
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 15:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235734AbhICNiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 09:38:55 -0400
Received: from mga18.intel.com ([134.134.136.126]:45875 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235169AbhICNiy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 09:38:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="206544189"
X-IronPort-AV: E=Sophos;i="5.85,265,1624345200"; 
   d="scan'208";a="206544189"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2021 06:37:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,265,1624345200"; 
   d="scan'208";a="603066631"
Received: from ipd-test105-dell.igk.intel.com (HELO localhost.localdomain) ([10.102.20.173])
  by fmsmga001.fm.intel.com with ESMTP; 03 Sep 2021 06:37:52 -0700
Date:   Fri, 3 Sep 2021 17:38:30 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: Re: [PATCH bpf-next 17/20] selftests: xsk: add test for unaligned
 mode
Message-ID: <YTJBdg9S1QEvPVZY@localhost.localdomain>
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
 <20210901104732.10956-18-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901104732.10956-18-magnus.karlsson@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 12:47:29PM +0200, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Add a test for unaligned mode in which packet buffers can be placed
> anywhere within the umem. Some packets are made to straddle page
> boundraries in order to check for correctness. On the Tx side, buffers

boundaries

> are now allocated according to the addresses found in the packet
> stream. Thus, the placement of buffers can be controlled with the
> boolean use_addr_for_fill in the packet stream.
> 
> One new pkt_stream insterface is introduced: pkt_stream_replace_half()

interface

> that replaces every other packet in the default packet stream with the
> specified new packet.

Can you describe the introduction of DEFAULT_OFFSET ?

> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 125 ++++++++++++++++++-----
>  tools/testing/selftests/bpf/xdpxceiver.h |   4 +
>  2 files changed, 106 insertions(+), 23 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index d4aad4833754..a24068993cc3 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -19,7 +19,7 @@
>   * Virtual Ethernet interfaces.
>   *
>   * For each mode, the following tests are run:
> - *    a. nopoll - soft-irq processing
> + *    a. nopoll - soft-irq processing in run-to-completion mode
>   *    b. poll - using poll() syscall
>   *    c. Socket Teardown
>   *       Create a Tx and a Rx socket, Tx from one socket, Rx on another. Destroy
> @@ -45,6 +45,7 @@
>   *       Configure sockets at indexes 0 and 1, run a traffic on queue ids 0,
>   *       then remove xsk sockets from queue 0 on both veth interfaces and
>   *       finally run a traffic on queues ids 1
> + *    g. unaligned mode
>   *
>   * Total tests: 12
>   *
> @@ -243,6 +244,9 @@ static int xsk_configure_umem(struct xsk_umem_info *umem, void *buffer, u64 size
>  	};
>  	int ret;
>  
> +	if (umem->unaligned_mode)
> +		cfg.flags |= XDP_UMEM_UNALIGNED_CHUNK_FLAG;
> +
>  	ret = xsk_umem__create(&umem->umem, buffer, size,
>  			       &umem->fq, &umem->cq, &cfg);
>  	if (ret)
> @@ -252,19 +256,6 @@ static int xsk_configure_umem(struct xsk_umem_info *umem, void *buffer, u64 size
>  	return 0;
>  }
>  
> -static void xsk_populate_fill_ring(struct xsk_umem_info *umem)
> -{
> -	int ret, i;
> -	u32 idx = 0;
> -
> -	ret = xsk_ring_prod__reserve(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS, &idx);
> -	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
> -		exit_with_error(-ret);
> -	for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i++)
> -		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = i * umem->frame_size;
> -	xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS);
> -}
> -
>  static int xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_info *umem,
>  				struct ifobject *ifobject, u32 qid)
>  {
> @@ -487,7 +478,8 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
>  
>  	pkt_stream->nb_pkts = nb_pkts;
>  	for (i = 0; i < nb_pkts; i++) {
> -		pkt_stream->pkts[i].addr = (i % umem->num_frames) * umem->frame_size;
> +		pkt_stream->pkts[i].addr = (i % umem->num_frames) * umem->frame_size +
> +			DEFAULT_OFFSET;
>  		pkt_stream->pkts[i].len = pkt_len;
>  		pkt_stream->pkts[i].payload = i;

Probably we need to init use_addr_for_fill to false by default in here as
pkt_stream is malloc'd.

>  
> @@ -500,6 +492,12 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
>  	return pkt_stream;
>  }
>  
> +static struct pkt_stream *pkt_stream_clone(struct xsk_umem_info *umem,
> +					   struct pkt_stream *pkt_stream)
> +{
> +	return pkt_stream_generate(umem, pkt_stream->nb_pkts, pkt_stream->pkts[0].len);
> +}
> +
>  static void pkt_stream_replace(struct test_spec *test, u32 nb_pkts, u32 pkt_len)
>  {
>  	struct pkt_stream *pkt_stream;
> @@ -507,8 +505,22 @@ static void pkt_stream_replace(struct test_spec *test, u32 nb_pkts, u32 pkt_len)
>  	pkt_stream = pkt_stream_generate(test->ifobj_tx->umem, nb_pkts, pkt_len);
>  	test->ifobj_tx->pkt_stream = pkt_stream;
>  	test->ifobj_rx->pkt_stream = pkt_stream;
> +}
>  
> -	pkt_stream_delete(pkt_stream);
> +static void pkt_stream_replace_half(struct test_spec *test, u32 pkt_len, u32 offset)
> +{
> +	struct xsk_umem_info *umem = test->ifobj_tx->umem;
> +	struct pkt_stream *pkt_stream;
> +	u32 i;
> +
> +	pkt_stream = pkt_stream_clone(umem, test->pkt_stream_default);
> +	for (i = 0; i < test->pkt_stream_default->nb_pkts; i += 2) {
> +		pkt_stream->pkts[i].addr = (i % umem->num_frames) * umem->frame_size + offset;
> +		pkt_stream->pkts[i].len = pkt_len;
> +	}
> +
> +	test->ifobj_tx->pkt_stream = pkt_stream;
> +	test->ifobj_rx->pkt_stream = pkt_stream;
>  }
>  
>  static struct pkt *pkt_generate(struct ifobject *ifobject, u32 pkt_nb)
> @@ -572,9 +584,9 @@ static void pkt_dump(void *pkt, u32 len)
>  	fprintf(stdout, "---------------------------------------\n");
>  }
>  
> -static bool is_pkt_valid(struct pkt *pkt, void *buffer, const struct xdp_desc *desc)
> +static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
>  {
> -	void *data = xsk_umem__get_data(buffer, desc->addr);
> +	void *data = xsk_umem__get_data(buffer, addr);
>  	struct iphdr *iphdr = (struct iphdr *)(data + sizeof(struct ethhdr));
>  
>  	if (!pkt) {
> @@ -588,10 +600,10 @@ static bool is_pkt_valid(struct pkt *pkt, void *buffer, const struct xdp_desc *d
>  		if (opt_pkt_dump)
>  			pkt_dump(data, PKT_SIZE);
>  
> -		if (pkt->len != desc->len) {
> +		if (pkt->len != len) {
>  			ksft_test_result_fail
>  				("ERROR: [%s] expected length [%d], got length [%d]\n",
> -					__func__, pkt->len, desc->len);
> +					__func__, pkt->len, len);
>  			return false;
>  		}
>  
> @@ -673,7 +685,7 @@ static void receive_pkts(struct pkt_stream *pkt_stream, struct xsk_socket_info *
>  
>  			orig = xsk_umem__extract_addr(addr);
>  			addr = xsk_umem__add_offset_to_addr(addr);
> -			if (!is_pkt_valid(pkt, xsk->umem->buffer, desc))
> +			if (!is_pkt_valid(pkt, xsk->umem->buffer, addr, desc->len))
>  				return;
>  
>  			*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) = orig;
> @@ -817,13 +829,16 @@ static void tx_stats_validate(struct ifobject *ifobject)
>  
>  static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
>  {
> +	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
>  	u32 i;
>  
>  	ifobject->ns_fd = switch_namespace(ifobject->nsname);
>  
> +	if (ifobject->umem->unaligned_mode)
> +		mmap_flags |= MAP_HUGETLB;
> +
>  	for (i = 0; i < test->nb_sockets; i++) {
>  		u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
> -		int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
>  		u32 ctr = 0;
>  		void *bufs;
>  
> @@ -881,6 +896,32 @@ static void *worker_testapp_validate_tx(void *arg)
>  	pthread_exit(NULL);
>  }
>  
> +static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream *pkt_stream)
> +{
> +	u32 idx = 0, i;
> +	int ret;
> +
> +	ret = xsk_ring_prod__reserve(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS, &idx);
> +	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
> +		exit_with_error(ENOSPC);

-ENOSPC?

> +	for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i++) {
> +		u64 addr;
> +
> +		if (pkt_stream->use_addr_for_fill) {
> +			struct pkt *pkt = pkt_stream_get_pkt(pkt_stream, i);
> +
> +			if (!pkt)
> +				break;
> +			addr = pkt->addr;
> +		} else {
> +			addr = (i % umem->num_frames) * umem->frame_size + DEFAULT_OFFSET;
> +		}
> +
> +		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = addr;
> +	}
> +	xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS);
> +}
