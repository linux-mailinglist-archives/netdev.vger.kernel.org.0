Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989DB3215CB
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 13:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhBVMIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 07:08:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:29281 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230211AbhBVMIP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 07:08:15 -0500
IronPort-SDR: LU4d+FFqKcCTFwzQyyWzp2guL1DfzOALIOttoFA04u7e3ecTGstgcmke4xyujpW2KkYnaf6a1P
 D4I3DlaZE6NQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9902"; a="203812544"
X-IronPort-AV: E=Sophos;i="5.81,197,1610438400"; 
   d="scan'208";a="203812544"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 04:07:33 -0800
IronPort-SDR: 64ACum+sE55XqQJRiDtpfjnw9/pBKL71ZDUaKHGwvQlTPV7Z+CkluUmv+OTyEz8yKy5LZAnkCy
 9lvixlksWj4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,197,1610438400"; 
   d="scan'208";a="389809657"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 22 Feb 2021 04:07:31 -0800
Date:   Mon, 22 Feb 2021 12:56:53 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Subject: Re: [PATCH bpf-next 4/4] selftests/bpf: introduce xsk statistics
 tests
Message-ID: <20210222115653.GB29106@ranger.igk.intel.com>
References: <20210217160214.7869-1-ciara.loftus@intel.com>
 <20210217160214.7869-5-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217160214.7869-5-ciara.loftus@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 04:02:14PM +0000, Ciara Loftus wrote:
> This commit introduces a range of tests to the xsk testsuite
> for validating xsk statistics.
> 
> A new test type called 'stats' is added. Within it there are
> four sub-tests which test the following statistics:
> 1. rx dropped
> 2. tx invalid
> 3. rx ring full
> 4. fill queue empty
> 
> Each test configures a scenario which should trigger the given
> error statistic. The test passes if the statistic is successfully
> incremented.

Have you thought of adding a short description per each sub-test? This
would be helpful if you would mention how each particular is triggered.

Like, reducing the size of XSK Rx ring causes Rx drops and so on.

Reason why I'm asking for that is because personally I feel like 'tx
invalid' is a bit too generic name for a sub-test.

> 
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 130 ++++++++++++++++++++---
>  tools/testing/selftests/bpf/xdpxceiver.h |  13 +++
>  2 files changed, 130 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index 7cb4a13597d0..4647c89b2019 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -28,8 +28,11 @@
>   *       Configure sockets as bi-directional tx/rx sockets, sets up fill and
>   *       completion rings on each socket, tx/rx in both directions. Only nopoll
>   *       mode is used
> + *    e. Statistics
> + *       Trigger some error conditions and ensure that the appropriate statistics
> + *       are incremented.
>   *
> - * Total tests: 8
> + * Total tests: 10
>   *
>   * Flow:
>   * -----
> @@ -90,10 +93,11 @@ static void __exit_with_error(int error, const char *file, const char *func, int
>  #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
>  
>  #define print_ksft_result(void)\
> -	(ksft_test_result_pass("PASS: %s %s %s%s\n", uut ? "DRV" : "SKB",\
> +	(ksft_test_result_pass("PASS: %s %s %s%s%s\n", uut ? "DRV" : "SKB",\
>  			       test_type == TEST_TYPE_POLL ? "POLL" : "NOPOLL",\
>  			       test_type == TEST_TYPE_TEARDOWN ? "Socket Teardown" : "",\
> -			       test_type == TEST_TYPE_BIDI ? "Bi-directional Sockets" : ""))
> +			       test_type == TEST_TYPE_BIDI ? "Bi-directional Sockets" : "",\
> +			       test_type == TEST_TYPE_STATS ? "Stats" : ""))
>  
>  static void pthread_init_mutex(void)
>  {
> @@ -255,13 +259,20 @@ static void gen_eth_frame(struct xsk_umem_info *umem, u64 addr)
>  static void xsk_configure_umem(struct ifobject *data, void *buffer, u64 size)
>  {
>  	int ret;
> +	struct xsk_umem_config cfg = {
> +		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
> +		.comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS,
> +		.frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE,
> +		.frame_headroom = frame_headroom,
> +		.flags = XSK_UMEM__DEFAULT_FLAGS
> +	};
>  
>  	data->umem = calloc(1, sizeof(struct xsk_umem_info));
>  	if (!data->umem)
>  		exit_with_error(errno);
>  
>  	ret = xsk_umem__create(&data->umem->umem, buffer, size,
> -			       &data->umem->fq, &data->umem->cq, NULL);
> +			       &data->umem->fq, &data->umem->cq, &cfg);
>  	if (ret)
>  		exit_with_error(ret);
>  
> @@ -293,7 +304,7 @@ static int xsk_configure_socket(struct ifobject *ifobject)
>  		exit_with_error(errno);
>  
>  	ifobject->xsk->umem = ifobject->umem;
> -	cfg.rx_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
> +	cfg.rx_size = rxqsize;
>  	cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
>  	cfg.libbpf_flags = 0;
>  	cfg.xdp_flags = xdp_flags;
> @@ -555,6 +566,8 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frameptr, int batch_size)
>  {
>  	u32 idx;
>  	unsigned int i;
> +	bool tx_invalid_test = stat_test_type == STAT_TEST_TX_INVALID;
> +	u32 len = tx_invalid_test ? XSK_UMEM__DEFAULT_FRAME_SIZE + 1 : PKT_SIZE;
>  
>  	while (xsk_ring_prod__reserve(&xsk->tx, batch_size, &idx) < batch_size)
>  		complete_tx_only(xsk, batch_size);
> @@ -563,11 +576,16 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frameptr, int batch_size)
>  		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx, idx + i);
>  
>  		tx_desc->addr = (*frameptr + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
> -		tx_desc->len = PKT_SIZE;
> +		tx_desc->len = len;
>  	}
>  
>  	xsk_ring_prod__submit(&xsk->tx, batch_size);
> -	xsk->outstanding_tx += batch_size;
> +	if (!tx_invalid_test) {
> +		xsk->outstanding_tx += batch_size;
> +	} else {
> +		if (!NEED_WAKEUP || xsk_ring_prod__needs_wakeup(&xsk->tx))
> +			kick_tx(xsk);
> +	}
>  	*frameptr += batch_size;
>  	*frameptr %= num_frames;
>  	complete_tx_only(xsk, batch_size);
> @@ -679,6 +697,48 @@ static void worker_pkt_dump(void)
>  	}
>  }
>  
> +static void worker_stats_validate(struct ifobject *ifobject)
> +{
> +	struct xdp_statistics stats;
> +	socklen_t optlen;
> +	int err;
> +	struct xsk_socket *xsk = stat_test_type == STAT_TEST_TX_INVALID ?
> +							ifdict[!ifobject->ifdict_index]->xsk->xsk :
> +							ifobject->xsk->xsk;
> +	int fd = xsk_socket__fd(xsk);
> +	unsigned long xsk_stat = 0, expected_stat = opt_pkt_count;
> +
> +	sigvar = 0;
> +
> +	optlen = sizeof(stats);
> +	err = getsockopt(fd, SOL_XDP, XDP_STATISTICS, &stats, &optlen);
> +	if (err)
> +		return;
> +
> +	if (optlen == sizeof(struct xdp_statistics)) {
> +		switch (stat_test_type) {
> +		case STAT_TEST_RX_DROPPED:
> +			xsk_stat = stats.rx_dropped;
> +			break;
> +		case STAT_TEST_TX_INVALID:
> +			xsk_stat = stats.tx_invalid_descs;
> +			break;
> +		case STAT_TEST_RX_FULL:
> +			xsk_stat = stats.rx_ring_full;
> +			expected_stat -= RX_FULL_RXQSIZE;
> +			break;
> +		case STAT_TEST_RX_FILL_EMPTY:
> +			xsk_stat = stats.rx_fill_ring_empty_descs;
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		if (xsk_stat == expected_stat)
> +			sigvar = 1;
> +	}
> +}
> +
>  static void worker_pkt_validate(void)
>  {
>  	u32 payloadseqnum = -2;
> @@ -817,7 +877,8 @@ static void *worker_testapp_validate(void *arg)
>  			thread_common_ops(ifobject, bufs, &sync_mutex_tx, &spinning_rx);
>  
>  		print_verbose("Interface [%s] vector [Rx]\n", ifobject->ifname);
> -		xsk_populate_fill_ring(ifobject->umem);
> +		if (stat_test_type != STAT_TEST_RX_FILL_EMPTY)
> +			xsk_populate_fill_ring(ifobject->umem);
>  
>  		TAILQ_INIT(&head);
>  		if (debug_pkt_dump) {
> @@ -839,15 +900,21 @@ static void *worker_testapp_validate(void *arg)
>  				if (ret <= 0)
>  					continue;
>  			}
> -			rx_pkt(ifobject->xsk, fds);
> -			worker_pkt_validate();
> +
> +			if (test_type != TEST_TYPE_STATS) {
> +				rx_pkt(ifobject->xsk, fds);
> +				worker_pkt_validate();
> +			} else {
> +				worker_stats_validate(ifobject);
> +			}
>  
>  			if (sigvar)
>  				break;
>  		}
>  
> -		print_verbose("Received %d packets on interface %s\n",
> -			       pkt_counter, ifobject->ifname);
> +		if (test_type != TEST_TYPE_STATS)
> +			print_verbose("Received %d packets on interface %s\n",
> +				pkt_counter, ifobject->ifname);
>  
>  		if (test_type == TEST_TYPE_TEARDOWN)
>  			print_verbose("Destroying socket\n");
> @@ -921,7 +988,7 @@ static void testapp_validate(void)
>  		free(pkt_buf);
>  	}
>  
> -	if (!(test_type == TEST_TYPE_TEARDOWN) && !bidi)
> +	if (!(test_type == TEST_TYPE_TEARDOWN) && !bidi && !(test_type == TEST_TYPE_STATS))
>  		print_ksft_result();
>  }
>  
> @@ -940,6 +1007,34 @@ static void testapp_sockets(void)
>  	print_ksft_result();
>  }
>  
> +static void testapp_stats(void)
> +{
> +	for (int i = 0; i < STAT_TEST_TYPE_MAX; i++) {
> +		stat_test_type = i;
> +
> +		/* reset defaults */
> +		rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
> +		frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM;
> +
> +		switch (stat_test_type) {
> +		case STAT_TEST_RX_DROPPED:
> +			frame_headroom = XSK_UMEM__DEFAULT_FRAME_SIZE -
> +						XDP_PACKET_HEADROOM - 1;
> +			break;
> +		case STAT_TEST_RX_FULL:
> +			rxqsize = RX_FULL_RXQSIZE;
> +			break;
> +		default:
> +			break;
> +		}
> +		pthread_init_mutex();

Do you really have to init/destroy mutexes per each iteration?

> +		testapp_validate();
> +		pthread_destroy_mutex();
> +	}
> +
> +	print_ksft_result();
> +}
> +
>  static void init_iface_config(struct ifaceconfigobj *ifaceconfig)
>  {
>  	/*Init interface0 */
> @@ -1021,6 +1116,10 @@ static void run_pkt_test(int mode, int type)
>  	prev_pkt = -1;
>  	ifdict[0]->fv.vector = tx;
>  	ifdict[1]->fv.vector = rx;
> +	sigvar = 0;
> +	stat_test_type = -1;
> +	rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
> +	frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM;
>  
>  	switch (mode) {
>  	case (TEST_MODE_SKB):
> @@ -1039,6 +1138,11 @@ static void run_pkt_test(int mode, int type)
>  		break;
>  	}
>  
> +	if (test_type == TEST_TYPE_STATS) {
> +		testapp_stats();
> +		return;
> +	}

Why this can't be a part of if/else if/else branch that below is picking
the test type?

> +
>  	pthread_init_mutex();
>  
>  	if ((test_type != TEST_TYPE_TEARDOWN) && (test_type != TEST_TYPE_BIDI))
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
> index 1127a396d5d0..4d0a80dbfef0 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.h
> +++ b/tools/testing/selftests/bpf/xdpxceiver.h
> @@ -41,6 +41,7 @@
>  #define BATCH_SIZE 64
>  #define POLL_TMOUT 1000
>  #define NEED_WAKEUP true
> +#define RX_FULL_RXQSIZE 32
>  
>  #define print_verbose(x...) do { if (opt_verbose) ksft_print_msg(x); } while (0)
>  
> @@ -59,9 +60,18 @@ enum TEST_TYPES {
>  	TEST_TYPE_POLL,
>  	TEST_TYPE_TEARDOWN,
>  	TEST_TYPE_BIDI,
> +	TEST_TYPE_STATS,
>  	TEST_TYPE_MAX
>  };
>  
> +enum STAT_TEST_TYPES {
> +	STAT_TEST_RX_DROPPED,
> +	STAT_TEST_TX_INVALID,
> +	STAT_TEST_RX_FULL,
> +	STAT_TEST_RX_FILL_EMPTY,
> +	STAT_TEST_TYPE_MAX
> +};
> +
>  static u8 uut;
>  static u8 debug_pkt_dump;
>  static u32 num_frames;
> @@ -80,6 +90,9 @@ static u8 pkt_data[XSK_UMEM__DEFAULT_FRAME_SIZE];
>  static u32 pkt_counter;
>  static long prev_pkt = -1;
>  static int sigvar;
> +static int stat_test_type;
> +static u32 rxqsize;
> +static u32 frame_headroom;
>  
>  struct xsk_umem_info {
>  	struct xsk_ring_prod fq;
> -- 
> 2.17.1
> 
