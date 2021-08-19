Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784193F1672
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 11:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237552AbhHSJmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 05:42:14 -0400
Received: from mga18.intel.com ([134.134.136.126]:30072 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233957AbhHSJmN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 05:42:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="203668108"
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="203668108"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 02:41:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="679254573"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga006.fm.intel.com with ESMTP; 19 Aug 2021 02:41:34 -0700
Date:   Thu, 19 Aug 2021 11:26:34 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: Re: [PATCH bpf-next v2 10/16] selftests: xsk: validate tx stats on
 tx thread
Message-ID: <20210819092634.GA32204@ranger.igk.intel.com>
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
 <20210817092729.433-11-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817092729.433-11-magnus.karlsson@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 11:27:23AM +0200, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Validate the tx stats on the Tx thread instead of the Rx
> tread. Depending on your settings, you might not be allowed to query
> the statistics of a socket you do not own, so better to do this on the
> correct thread to start with.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 55 ++++++++++++++++++------
>  1 file changed, 41 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index fe3d281a0575..8ff24472ef1e 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -642,23 +642,22 @@ static void tx_only_all(struct ifobject *ifobject)
>  	complete_tx_only_all(ifobject);
>  }
>  
> -static void stats_validate(struct ifobject *ifobject)
> +static bool rx_stats_are_valid(struct ifobject *ifobject)
>  {
> +	u32 xsk_stat = 0, expected_stat = opt_pkt_count;
> +	struct xsk_socket *xsk = ifobject->xsk->xsk;
> +	int fd = xsk_socket__fd(xsk);
>  	struct xdp_statistics stats;
>  	socklen_t optlen;
>  	int err;
> -	struct xsk_socket *xsk = stat_test_type == STAT_TEST_TX_INVALID ?
> -							ifdict[!ifobject->ifdict_index]->xsk->xsk :
> -							ifobject->xsk->xsk;
> -	int fd = xsk_socket__fd(xsk);
> -	unsigned long xsk_stat = 0, expected_stat = opt_pkt_count;
> -
> -	sigvar = 0;
>  
>  	optlen = sizeof(stats);
>  	err = getsockopt(fd, SOL_XDP, XDP_STATISTICS, &stats, &optlen);
> -	if (err)
> -		return;
> +	if (err) {
> +		ksft_test_result_fail("ERROR: [%s] getsockopt(XDP_STATISTICS) error %u %s\n",
> +				      __func__, -err, strerror(-err));
> +		return true;

Can we invert the logic or change the name of the func?
Returning 'true' for error case is a bit confusing given the name of func
is blah_are_valid, no? If there was an error then I'd return false.

OTOH we're testing faulty socket situations in here, but error from
getsockopt does not mean that stats were valid.

> +	}
>  
>  	if (optlen == sizeof(struct xdp_statistics)) {
>  		switch (stat_test_type) {
> @@ -666,8 +665,7 @@ static void stats_validate(struct ifobject *ifobject)
>  			xsk_stat = stats.rx_dropped;
>  			break;
>  		case STAT_TEST_TX_INVALID:
> -			xsk_stat = stats.tx_invalid_descs;
> -			break;
> +			return true;
>  		case STAT_TEST_RX_FULL:
>  			xsk_stat = stats.rx_ring_full;
>  			expected_stat -= RX_FULL_RXQSIZE;
> @@ -680,8 +678,33 @@ static void stats_validate(struct ifobject *ifobject)
>  		}
>  
>  		if (xsk_stat == expected_stat)
> -			sigvar = 1;
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +static void tx_stats_validate(struct ifobject *ifobject)
> +{
> +	struct xsk_socket *xsk = ifobject->xsk->xsk;
> +	int fd = xsk_socket__fd(xsk);
> +	struct xdp_statistics stats;
> +	socklen_t optlen;
> +	int err;
> +
> +	optlen = sizeof(stats);
> +	err = getsockopt(fd, SOL_XDP, XDP_STATISTICS, &stats, &optlen);
> +	if (err) {
> +		ksft_test_result_fail("ERROR: [%s] getsockopt(XDP_STATISTICS) error %u %s\n",
> +				      __func__, -err, strerror(-err));
> +		return;
>  	}
> +
> +	if (stats.tx_invalid_descs == opt_pkt_count)
> +		return;
> +
> +	ksft_test_result_fail("ERROR: [%s] tx_invalid_descs incorrect. Got [%u] expected [%u]\n",
> +			      __func__, stats.tx_invalid_descs, opt_pkt_count);
>  }
>  
>  static void thread_common_ops(struct ifobject *ifobject, void *bufs)
> @@ -767,6 +790,9 @@ static void *worker_testapp_validate_tx(void *arg)
>  	print_verbose("Sending %d packets on interface %s\n", opt_pkt_count, ifobject->ifname);
>  	tx_only_all(ifobject);
>  
> +	if (stat_test_type == STAT_TEST_TX_INVALID)
> +		tx_stats_validate(ifobject);
> +
>  	testapp_cleanup_xsk_res(ifobject);
>  	pthread_exit(NULL);
>  }
> @@ -792,7 +818,8 @@ static void *worker_testapp_validate_rx(void *arg)
>  		if (test_type != TEST_TYPE_STATS) {
>  			rx_pkt(ifobject->xsk, fds);
>  		} else {
> -			stats_validate(ifobject);
> +			if (rx_stats_are_valid(ifobject))
> +				break;
>  		}
>  		if (sigvar)
>  			break;
> -- 
> 2.29.0
> 
