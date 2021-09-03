Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F2B4003C1
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 18:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350169AbhICQ6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 12:58:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:13117 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhICQ6x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 12:58:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10096"; a="219169049"
X-IronPort-AV: E=Sophos;i="5.85,265,1624345200"; 
   d="scan'208";a="219169049"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2021 09:57:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,265,1624345200"; 
   d="scan'208";a="534211828"
Received: from ipd-test105-dell.igk.intel.com (HELO localhost.localdomain) ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Sep 2021 09:57:46 -0700
Date:   Fri, 3 Sep 2021 20:58:23 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: Re: [PATCH bpf-next 19/20] selftests: xsk: add tests for invalid xsk
 descriptors
Message-ID: <YTJwT8QBAELMO0T1@localhost.localdomain>
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
 <20210901104732.10956-20-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901104732.10956-20-magnus.karlsson@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 12:47:31PM +0200, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Add tests for invalid xsk descriptors in the Tx ring. A number of
> handcrafted nasty invalid descriptors are created and submitted to the
> tx ring to check that they are validated correctly. Corener case valid

Corner

> ones are also sent. The tests are run for both aligned and unaligned
> mode.
> 
> pkt_stream_set() is introduced to be able to create a hand-crafted
> packet stream where every single packet is specified in detail.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 143 ++++++++++++++++++++---
>  tools/testing/selftests/bpf/xdpxceiver.h |   7 +-
>  2 files changed, 131 insertions(+), 19 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index d085033afd53..a4f6ce3a6b14 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -46,6 +46,8 @@
>   *       then remove xsk sockets from queue 0 on both veth interfaces and
>   *       finally run a traffic on queues ids 1
>   *    g. unaligned mode
> + *    h. tests for invalid and corner case Tx descriptors so that the correct ones
> + *       are discarded and let through, respectively.
>   *
>   * Total tests: 12
>   *
> @@ -394,7 +396,7 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
>  		for (j = 0; j < MAX_SOCKETS; j++) {
>  			memset(&ifobj->umem_arr[j], 0, sizeof(ifobj->umem_arr[j]));
>  			memset(&ifobj->xsk_arr[j], 0, sizeof(ifobj->xsk_arr[j]));
> -			ifobj->umem_arr[j].num_frames = DEFAULT_PKT_CNT / 4;
> +			ifobj->umem_arr[j].num_frames = DEFAULT_UMEM_BUFFERS;
>  			ifobj->umem_arr[j].frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
>  			ifobj->xsk_arr[j].rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
>  		}
> @@ -450,6 +452,16 @@ static struct pkt *pkt_stream_get_pkt(struct pkt_stream *pkt_stream, u32 pkt_nb)
>  	return &pkt_stream->pkts[pkt_nb];
>  }
>  
> +static struct pkt *pkt_stream_get_next_rx_pkt(struct pkt_stream *pkt_stream)
> +{
> +	while (pkt_stream->rx_pkt_nb < pkt_stream->nb_pkts) {
> +		if (pkt_stream->pkts[pkt_stream->rx_pkt_nb].valid)
> +			return &pkt_stream->pkts[pkt_stream->rx_pkt_nb++];
> +		pkt_stream->rx_pkt_nb++;
> +	}
> +	return NULL;
> +}
> +
>  static void pkt_stream_delete(struct pkt_stream *pkt_stream)
>  {
>  	free(pkt_stream->pkts);
> @@ -465,17 +477,31 @@ static void pkt_stream_restore_default(struct test_spec *test)
>  	test->ifobj_rx->pkt_stream = test->pkt_stream_default;
>  }
>  
> -static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb_pkts, u32 pkt_len)
> +static struct pkt_stream *__pkt_stream_alloc(u32 nb_pkts)
>  {
>  	struct pkt_stream *pkt_stream;
> -	u32 i;
>  
> -	pkt_stream = malloc(sizeof(*pkt_stream));
> +	pkt_stream = calloc(1, sizeof(*pkt_stream));

So with that probably my previous comment about use_addr_for_fill being
not set is not relevant.

>  	if (!pkt_stream)
> -		exit_with_error(ENOMEM);
> +		return NULL;
>  
>  	pkt_stream->pkts = calloc(nb_pkts, sizeof(*pkt_stream->pkts));
> -	if (!pkt_stream->pkts)
> +	if (!pkt_stream->pkts) {
> +		free(pkt_stream);
> +		return NULL;
> +	}
> +
> +	pkt_stream->nb_pkts = nb_pkts;
> +	return pkt_stream;
> +}
> +
> +static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb_pkts, u32 pkt_len)
> +{
> +	struct pkt_stream *pkt_stream;
> +	u32 i;
> +
> +	pkt_stream = __pkt_stream_alloc(nb_pkts);
> +	if (!pkt_stream)
>  		exit_with_error(ENOMEM);
>  
>  	pkt_stream->nb_pkts = nb_pkts;
> @@ -525,6 +551,26 @@ static void pkt_stream_replace_half(struct test_spec *test, u32 pkt_len, u32 off
>  	test->ifobj_rx->pkt_stream = pkt_stream;
>  }
>  
> +static void pkt_stream_set(struct test_spec *test, struct pkt *pkts, u32 nb_pkts)

This is still a generation of pkt stream, can we name this is as:
pkt_stream_generate_custom or is this too long? WDYT?

> +{
> +	struct pkt_stream *pkt_stream;
> +	u32 i;
> +
> +	pkt_stream = __pkt_stream_alloc(nb_pkts);
> +	if (!pkt_stream)
> +		exit_with_error(ENOMEM);
> +
> +	test->ifobj_tx->pkt_stream = pkt_stream;
> +	test->ifobj_rx->pkt_stream = pkt_stream;
> +
> +	for (i = 0; i < nb_pkts; i++) {
> +		pkt_stream->pkts[i].addr = pkts[i].addr;
> +		pkt_stream->pkts[i].len = pkts[i].len;
> +		pkt_stream->pkts[i].payload = i;
> +		pkt_stream->pkts[i].valid = pkts[i].valid;
> +	}
> +}
> +
>  static struct pkt *pkt_generate(struct ifobject *ifobject, u32 pkt_nb)
>  {
>  	struct pkt *pkt = pkt_stream_get_pkt(ifobject->pkt_stream, pkt_nb);
> @@ -535,6 +581,8 @@ static struct pkt *pkt_generate(struct ifobject *ifobject, u32 pkt_nb)
>  
>  	if (!pkt)
>  		return NULL;
> +	if (!pkt->valid || pkt->len < PKT_SIZE)
> +		return pkt;
>  
>  	data = xsk_umem__get_data(ifobject->umem->buffer, pkt->addr);
>  	udp_hdr = (struct udphdr *)(data + sizeof(struct ethhdr) + sizeof(struct iphdr));
> @@ -596,19 +644,24 @@ static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
>  		return false;
>  	}
>  
> +	if (len < PKT_SIZE) {
> +		/*Do not try to verify packets that are smaller than minimun size. */

minimum

> +		return true;
> +	}
> +
> +	if (pkt->len != len) {
> +		ksft_test_result_fail
> +			("ERROR: [%s] expected length [%d], got length [%d]\n",
> +			 __func__, pkt->len, len);
> +		return false;
> +	}
> +
>  	if (iphdr->version == IP_PKT_VER && iphdr->tos == IP_PKT_TOS) {
>  		u32 seqnum = ntohl(*((u32 *)(data + PKT_HDR_SIZE)));
>  
>  		if (opt_pkt_dump)
>  			pkt_dump(data, PKT_SIZE);
>  
> -		if (pkt->len != len) {
> -			ksft_test_result_fail
> -				("ERROR: [%s] expected length [%d], got length [%d]\n",
> -					__func__, pkt->len, len);
> -			return false;
> -		}
> -
>  		if (pkt->payload != seqnum) {
>  			ksft_test_result_fail
>  				("ERROR: [%s] expected seqnum [%d], got seqnum [%d]\n",
> @@ -645,6 +698,15 @@ static void complete_pkts(struct xsk_socket_info *xsk, int batch_size)
>  
>  	rcvd = xsk_ring_cons__peek(&xsk->umem->cq, batch_size, &idx);
>  	if (rcvd) {
> +		if (rcvd > xsk->outstanding_tx) {
> +			u64 addr = *xsk_ring_cons__comp_addr(&xsk->umem->cq, idx + rcvd - 1);
> +
> +			ksft_test_result_fail("ERROR: [%s] Too many packets completed\n",
> +					      __func__);
> +			ksft_print_msg("Last completion address: %llx\n", addr);
> +			return;
> +		}
> +
>  		xsk_ring_cons__release(&xsk->umem->cq, rcvd);
>  		xsk->outstanding_tx -= rcvd;
>  	}
> @@ -653,11 +715,10 @@ static void complete_pkts(struct xsk_socket_info *xsk, int batch_size)
>  static void receive_pkts(struct pkt_stream *pkt_stream, struct xsk_socket_info *xsk,
>  			 struct pollfd *fds)
>  {
> -	u32 idx_rx = 0, idx_fq = 0, rcvd, i, pkt_count = 0;
> -	struct pkt *pkt;
> +	struct pkt *pkt = pkt_stream_get_next_rx_pkt(pkt_stream);
> +	u32 idx_rx = 0, idx_fq = 0, rcvd, i;
>  	int ret;
>  
> -	pkt = pkt_stream_get_pkt(pkt_stream, pkt_count++);
>  	while (pkt) {
>  		rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
>  		if (!rcvd) {
> @@ -685,13 +746,21 @@ static void receive_pkts(struct pkt_stream *pkt_stream, struct xsk_socket_info *
>  			const struct xdp_desc *desc = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx++);
>  			u64 addr = desc->addr, orig;
>  
> +			if (!pkt) {
> +				ksft_test_result_fail("ERROR: [%s] Received too many packets.\n",
> +						      __func__);
> +				ksft_print_msg("Last packet has addr: %llx len: %u\n",
> +					       addr, desc->len);
> +				return;
> +			}
> +
>  			orig = xsk_umem__extract_addr(addr);
>  			addr = xsk_umem__add_offset_to_addr(addr);
>  			if (!is_pkt_valid(pkt, xsk->umem->buffer, addr, desc->len))
>  				return;
>  
>  			*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) = orig;
> -			pkt = pkt_stream_get_pkt(pkt_stream, pkt_count++);
> +			pkt = pkt_stream_get_next_rx_pkt(pkt_stream);
>  		}
>  
>  		xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
> @@ -875,6 +944,7 @@ static void testapp_cleanup_xsk_res(struct ifobject *ifobj)
>  {
>  	print_verbose("Destroying socket\n");
>  	xsk_socket__delete(ifobj->xsk->xsk);
> +	munmap(ifobj->umem->buffer, ifobj->umem->num_frames * ifobj->umem->frame_size);
>  	xsk_umem__delete(ifobj->umem->umem);
>  }
>  
> @@ -1118,6 +1188,33 @@ static bool testapp_unaligned(struct test_spec *test)
>  	return true;
>  }
>  
> +static void testapp_inv_desc(struct test_spec *test)

I'd say that speaking out whole 'invalid' word wouldn't hurt us here.

> +{
> +	struct pkt pkts[] = {{0, 0, 0, true}, /* Zero packet length and zero address allowed */

Above looks a bit weird, maybe this should be formatted same as the lines
below:

	struct pkt pkts[] = {
		/* Zero packet length and zero address allowed */
			     {0, 0, 0, true},

> +		/* Zero packet length allowed */
> +			     {0x1000, 0, 0, true},
> +		/* Straddling the start of umem */
> +			     {-2, PKT_SIZE, 0, false},
> +		/* Packet too large */
> +			     {0x2000, XSK_UMEM__INVALID_FRAME_SIZE, 0, false},
> +		/* After umem ends */
> +			     {UMEM_SIZE, PKT_SIZE, 0, false},
> +		/* Straddle the end of umem */
> +			     {UMEM_SIZE - PKT_SIZE / 2, PKT_SIZE, 0, false},
> +		/* Straddle a page boundrary */
> +			     {0x3000 - PKT_SIZE / 2, PKT_SIZE, 0, false},
> +		/* Valid packet for synch so that something is received */
> +			     {0x4000, PKT_SIZE, 0, true}};
> +
> +	if (test->ifobj_tx->umem->unaligned_mode) {
> +		/* Crossing a page boundrary allowed */
> +		pkts[6].valid = true;
> +	}
> +	pkt_stream_set(test, pkts, ARRAY_SIZE(pkts));
> +	testapp_validate_traffic(test);
> +	pkt_stream_restore_default(test);
> +}
> +
>  static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
>  		       const char *dst_ip, const char *src_ip, const u16 dst_port,
>  		       const u16 src_port, thread_func_t func_ptr)
> @@ -1159,7 +1256,7 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
>  	case TEST_TYPE_BPF_RES:
>  		testapp_bpf_res(test);
>  		break;
> -	case TEST_TYPE_NOPOLL:
> +	case TEST_TYPE_RUN_TO_COMPLETION:

I think that you were updating some comment around it on previous patches
and it probably belongs to this one.

>  		test_spec_set_name(test, "RUN_TO_COMPLETION");
>  		testapp_validate_traffic(test);
>  		break;
> @@ -1169,6 +1266,16 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
>  		test_spec_set_name(test, "POLL");
>  		testapp_validate_traffic(test);
>  		break;
> +	case TEST_TYPE_ALIGNED_INV_DESC:
> +		test_spec_set_name(test, "ALIGNED_INV_DESC");
> +		testapp_inv_desc(test);
> +		break;
> +	case TEST_TYPE_UNALIGNED_INV_DESC:
> +		test_spec_set_name(test, "UNALIGNED_INV_DESC");
> +		test->ifobj_tx->umem->unaligned_mode = true;
> +		test->ifobj_rx->umem->unaligned_mode = true;
> +		testapp_inv_desc(test);
> +		break;
>  	case TEST_TYPE_UNALIGNED:
>  		if (!testapp_unaligned(test))
>  			return;
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
> index 129801eb013c..2d9efb89ea28 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.h
> +++ b/tools/testing/selftests/bpf/xdpxceiver.h
> @@ -38,6 +38,8 @@
>  #define BATCH_SIZE 8
>  #define POLL_TMOUT 1000
>  #define DEFAULT_PKT_CNT (4 * 1024)
> +#define DEFAULT_UMEM_BUFFERS (DEFAULT_PKT_CNT / 4)
> +#define UMEM_SIZE (DEFAULT_UMEM_BUFFERS * XSK_UMEM__DEFAULT_FRAME_SIZE)
>  #define RX_FULL_RXQSIZE 32
>  #define DEFAULT_OFFSET 256
>  #define XSK_UMEM__INVALID_FRAME_SIZE (XSK_UMEM__DEFAULT_FRAME_SIZE + 1)
> @@ -51,9 +53,11 @@ enum test_mode {
>  };
>  
>  enum test_type {
> -	TEST_TYPE_NOPOLL,
> +	TEST_TYPE_RUN_TO_COMPLETION,
>  	TEST_TYPE_POLL,
>  	TEST_TYPE_UNALIGNED,
> +	TEST_TYPE_ALIGNED_INV_DESC,
> +	TEST_TYPE_UNALIGNED_INV_DESC,
>  	TEST_TYPE_TEARDOWN,
>  	TEST_TYPE_BIDI,
>  	TEST_TYPE_STATS,
> @@ -104,6 +108,7 @@ struct pkt {
>  
>  struct pkt_stream {
>  	u32 nb_pkts;
> +	u32 rx_pkt_nb;
>  	struct pkt *pkts;
>  	bool use_addr_for_fill;
>  };
> -- 
> 2.29.0
> 
