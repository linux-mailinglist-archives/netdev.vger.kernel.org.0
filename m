Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8486832152E
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 12:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhBVLfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 06:35:07 -0500
Received: from mga05.intel.com ([192.55.52.43]:17984 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230171AbhBVLfB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 06:35:01 -0500
IronPort-SDR: 2EFuaabGFwJ7eoIA5IpXVKZgokPDJ2ekCHGxeh0XJaMT9BWyXBEAryviRlLUn3Wli5J1Bw9EQr
 lOpMuERjI5VQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9902"; a="269346011"
X-IronPort-AV: E=Sophos;i="5.81,197,1610438400"; 
   d="scan'208";a="269346011"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 03:34:20 -0800
IronPort-SDR: mZOYLV5bKKq9fhhzLfyib1XGODD2VyqZiV3Cte4CMXkGRLxpOU0wDZeBX89DMDPRu2tvtcYAUI
 MqoQxsVq+Bkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,197,1610438400"; 
   d="scan'208";a="441354279"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga001.jf.intel.com with ESMTP; 22 Feb 2021 03:34:13 -0800
Date:   Mon, 22 Feb 2021 12:23:34 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Subject: Re: [PATCH bpf-next 3/4] selftests/bpf: restructure xsk selftests
Message-ID: <20210222112334.GA29106@ranger.igk.intel.com>
References: <20210217160214.7869-1-ciara.loftus@intel.com>
 <20210217160214.7869-4-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217160214.7869-4-ciara.loftus@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 04:02:13PM +0000, Ciara Loftus wrote:
> Prior to this commit individual xsk tests were launched from the
> shell script 'test_xsk.sh'. When adding a new test type, two new test
> configurations had to be added to this file - one for each of the
> supported XDP 'modes' (skb or drv). Should zero copy support be added to
> the xsk selftest framework in the future, three new test configurations
> would need to be added for each new test type. Each new test type also
> typically requires new CLI arguments for the xdpxceiver program.
> 
> This commit aims to reduce the overhead of adding new tests, by launching
> the test configurations from within the xdpxceiver program itself, using
> simple loops. Every test is run every time the C program is executed. Many
> of the CLI arguments can be removed as a result.
> 
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  tools/testing/selftests/bpf/test_xsk.sh    | 112 +-----------
>  tools/testing/selftests/bpf/xdpxceiver.c   | 199 ++++++++++++---------
>  tools/testing/selftests/bpf/xdpxceiver.h   |  27 ++-
>  tools/testing/selftests/bpf/xsk_prereqs.sh |  24 +--
>  4 files changed, 139 insertions(+), 223 deletions(-)
> 

Good cleanup! I have a series of fixes/cleanups as well and I need to
introduce a new test over here, so your work makes it easier for me.

One nit below and once you address Bjorn's request, then feel free to add
my:

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[...]

> +static int configure_skb(void)
> +{
> +
> +	char cmd[80];
> +
> +	snprintf(cmd, sizeof(cmd), "ip link set dev %s xdpdrv off", ifdict[0]->ifname);
> +	if (system(cmd)) {
> +		ksft_test_result_fail("Failed to configure native mode on iface %s\n",
> +						ifdict[0]->ifname);
> +		return -1;
> +	}
> +	snprintf(cmd, sizeof(cmd), "ip netns exec %s ip link set dev %s xdpdrv off",
> +					ifdict[1]->nsname, ifdict[1]->ifname);
> +	if (system(cmd)) {
> +		ksft_test_result_fail("Failed to configure native mode on iface/ns %s\n",
> +						ifdict[1]->ifname, ifdict[1]->nsname);
> +		return -1;
> +	}
> +
> +	cur_mode = TEST_MODE_SKB;
> +
> +	return 0;
> +
> +}
> +
> +static int configure_drv(void)
> +{
> +	char cmd[80];
> +
> +	snprintf(cmd, sizeof(cmd), "ip link set dev %s xdpgeneric off", ifdict[0]->ifname);
> +	if (system(cmd)) {
> +		ksft_test_result_fail("Failed to configure native mode on iface %s\n",
> +						ifdict[0]->ifname);
> +		return -1;
> +	}
> +	snprintf(cmd, sizeof(cmd), "ip netns exec %s ip link set dev %s xdpgeneric off",
> +					ifdict[1]->nsname, ifdict[1]->ifname);
> +	if (system(cmd)) {
> +		ksft_test_result_fail("Failed to configure native mode on iface/ns %s\n",
> +						ifdict[1]->ifname, ifdict[1]->nsname);
> +		return -1;
> +	}
> +
> +	cur_mode = TEST_MODE_DRV;
> +
> +	return 0;
> +}
> +
> +static void run_pkt_test(int mode, int type)
> +{
> +	test_type = type;
> +
> +	/* reset defaults after potential previous test */
> +	xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> +	pkt_counter = 0;
> +	switching_notify = 0;
> +	bidi_pass = 0;
> +	prev_pkt = -1;
> +	ifdict[0]->fv.vector = tx;
> +	ifdict[1]->fv.vector = rx;
> +
> +	switch (mode) {
> +	case (TEST_MODE_SKB):
> +		if (cur_mode != TEST_MODE_SKB)
> +			configure_skb();

Should you check a return value over here?

> +		xdp_flags |= XDP_FLAGS_SKB_MODE;
> +		uut = TEST_MODE_SKB;
> +		break;
> +	case (TEST_MODE_DRV):
> +		if (cur_mode != TEST_MODE_DRV)
> +			configure_drv();

ditto

> +		xdp_flags |= XDP_FLAGS_DRV_MODE;
> +		uut = TEST_MODE_DRV;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	pthread_init_mutex();
> +
> +	if ((test_type != TEST_TYPE_TEARDOWN) && (test_type != TEST_TYPE_BIDI))
> +		testapp_validate();
> +	else
> +		testapp_sockets();
> +
> +	pthread_destroy_mutex();
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
> @@ -1021,6 +1062,7 @@ int main(int argc, char **argv)
>  	const char *IP2 = "192.168.100.161";
>  	u16 UDP_DST_PORT = 2020;
>  	u16 UDP_SRC_PORT = 2121;
> +	int i, j;
>  
>  	ifaceconfig = malloc(sizeof(struct ifaceconfigobj));
>  	memcpy(ifaceconfig->dst_mac, MAC1, ETH_ALEN);
> @@ -1046,24 +1088,19 @@ int main(int argc, char **argv)
>  
>  	init_iface_config(ifaceconfig);
>  
> -	pthread_init_mutex();
> +	ksft_set_plan(TEST_MODE_MAX * TEST_TYPE_MAX);
>  
> -	ksft_set_plan(1);
> +	configure_skb();
> +	cur_mode = TEST_MODE_SKB;
>  
> -	if (!opt_teardown && !opt_bidi) {
> -		testapp_validate();
> -	} else if (opt_teardown && opt_bidi) {
> -		ksft_test_result_fail("ERROR: parameters -T and -B cannot be used together\n");
> -		ksft_exit_xfail();
> -	} else {
> -		testapp_sockets();
> +	for (i = 0; i < TEST_MODE_MAX; i++) {
> +		for (j = 0; j < TEST_TYPE_MAX; j++)
> +			run_pkt_test(i, j);
>  	}
>  
>  	for (int i = 0; i < MAX_INTERFACES; i++)
>  		free(ifdict[i]);
>  
> -	pthread_destroy_mutex();
> -
>  	ksft_exit_pass();
>  
>  	return 0;
