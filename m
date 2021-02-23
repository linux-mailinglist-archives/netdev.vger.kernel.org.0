Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15BE32270E
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 09:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbhBWIYq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 23 Feb 2021 03:24:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:9903 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231942AbhBWIYp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 03:24:45 -0500
IronPort-SDR: magf6VNMUr9MdE7HjiXV6D6RaZXQ6daitRpzMaWRuCV27ZINu6MiF1WaFFg9AekmFKHlbeLoqa
 yEdk43w2a4Dg==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="181292694"
X-IronPort-AV: E=Sophos;i="5.81,199,1610438400"; 
   d="scan'208";a="181292694"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2021 00:24:29 -0800
IronPort-SDR: xXkId/ti6d+ZOqfLs7jHXYcK+u5oJJrjCUNxkUq4M1Zw/Z1URiy3wclm5UxsnnIH3xF69JUCm/
 4TGEvsa4ntrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,199,1610438400"; 
   d="scan'208";a="403062956"
Received: from irsmsx603.ger.corp.intel.com ([163.33.146.9])
  by orsmga008.jf.intel.com with ESMTP; 23 Feb 2021 00:24:26 -0800
Received: from irsmsx604.ger.corp.intel.com (163.33.146.137) by
 irsmsx603.ger.corp.intel.com (163.33.146.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 23 Feb 2021 08:24:25 +0000
Received: from irsmsx604.ger.corp.intel.com ([163.33.146.137]) by
 IRSMSX604.ger.corp.intel.com ([163.33.146.137]) with mapi id 15.01.2106.002;
 Tue, 23 Feb 2021 08:24:25 +0000
From:   "Loftus, Ciara" <ciara.loftus@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "Janjua, Weqaar A" <weqaar.a.janjua@intel.com>
Subject: RE: [PATCH bpf-next 3/4] selftests/bpf: restructure xsk selftests
Thread-Topic: [PATCH bpf-next 3/4] selftests/bpf: restructure xsk selftests
Thread-Index: AQHXBUqTVaeEgTuG802qQ/bkObXD8KpkD7oAgAFfo7A=
Date:   Tue, 23 Feb 2021 08:24:25 +0000
Message-ID: <746b426fd5bf408084d86c5a9a18b021@intel.com>
References: <20210217160214.7869-1-ciara.loftus@intel.com>
 <20210217160214.7869-4-ciara.loftus@intel.com>
 <20210222112334.GA29106@ranger.igk.intel.com>
In-Reply-To: <20210222112334.GA29106@ranger.igk.intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [163.33.253.164]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> On Wed, Feb 17, 2021 at 04:02:13PM +0000, Ciara Loftus wrote:
> > Prior to this commit individual xsk tests were launched from the
> > shell script 'test_xsk.sh'. When adding a new test type, two new test
> > configurations had to be added to this file - one for each of the
> > supported XDP 'modes' (skb or drv). Should zero copy support be added to
> > the xsk selftest framework in the future, three new test configurations
> > would need to be added for each new test type. Each new test type also
> > typically requires new CLI arguments for the xdpxceiver program.
> >
> > This commit aims to reduce the overhead of adding new tests, by launching
> > the test configurations from within the xdpxceiver program itself, using
> > simple loops. Every test is run every time the C program is executed. Many
> > of the CLI arguments can be removed as a result.
> >
> > Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> > ---
> >  tools/testing/selftests/bpf/test_xsk.sh    | 112 +-----------
> >  tools/testing/selftests/bpf/xdpxceiver.c   | 199 ++++++++++++---------
> >  tools/testing/selftests/bpf/xdpxceiver.h   |  27 ++-
> >  tools/testing/selftests/bpf/xsk_prereqs.sh |  24 +--
> >  4 files changed, 139 insertions(+), 223 deletions(-)
> >
> 
> Good cleanup! I have a series of fixes/cleanups as well and I need to
> introduce a new test over here, so your work makes it easier for me.
> 
> One nit below and once you address Bjorn's request, then feel free to add
> my:

Thanks Björn and Maciej for the feedback. Will include your suggestions in the v2.
I discovered some extra things to tweak for the v2 but hope to have it up shortly.

Thanks,
Ciara

> 
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> [...]
> 
> > +static int configure_skb(void)
> > +{
> > +
> > +	char cmd[80];
> > +
> > +	snprintf(cmd, sizeof(cmd), "ip link set dev %s xdpdrv off", ifdict[0]-
> >ifname);
> > +	if (system(cmd)) {
> > +		ksft_test_result_fail("Failed to configure native mode on
> iface %s\n",
> > +						ifdict[0]->ifname);
> > +		return -1;
> > +	}
> > +	snprintf(cmd, sizeof(cmd), "ip netns exec %s ip link set dev %s
> xdpdrv off",
> > +					ifdict[1]->nsname, ifdict[1]->ifname);
> > +	if (system(cmd)) {
> > +		ksft_test_result_fail("Failed to configure native mode on
> iface/ns %s\n",
> > +						ifdict[1]->ifname, ifdict[1]-
> >nsname);
> > +		return -1;
> > +	}
> > +
> > +	cur_mode = TEST_MODE_SKB;
> > +
> > +	return 0;
> > +
> > +}
> > +
> > +static int configure_drv(void)
> > +{
> > +	char cmd[80];
> > +
> > +	snprintf(cmd, sizeof(cmd), "ip link set dev %s xdpgeneric off",
> ifdict[0]->ifname);
> > +	if (system(cmd)) {
> > +		ksft_test_result_fail("Failed to configure native mode on
> iface %s\n",
> > +						ifdict[0]->ifname);
> > +		return -1;
> > +	}
> > +	snprintf(cmd, sizeof(cmd), "ip netns exec %s ip link set dev %s
> xdpgeneric off",
> > +					ifdict[1]->nsname, ifdict[1]->ifname);
> > +	if (system(cmd)) {
> > +		ksft_test_result_fail("Failed to configure native mode on
> iface/ns %s\n",
> > +						ifdict[1]->ifname, ifdict[1]-
> >nsname);
> > +		return -1;
> > +	}
> > +
> > +	cur_mode = TEST_MODE_DRV;
> > +
> > +	return 0;
> > +}
> > +
> > +static void run_pkt_test(int mode, int type)
> > +{
> > +	test_type = type;
> > +
> > +	/* reset defaults after potential previous test */
> > +	xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> > +	pkt_counter = 0;
> > +	switching_notify = 0;
> > +	bidi_pass = 0;
> > +	prev_pkt = -1;
> > +	ifdict[0]->fv.vector = tx;
> > +	ifdict[1]->fv.vector = rx;
> > +
> > +	switch (mode) {
> > +	case (TEST_MODE_SKB):
> > +		if (cur_mode != TEST_MODE_SKB)
> > +			configure_skb();
> 
> Should you check a return value over here?
> 
> > +		xdp_flags |= XDP_FLAGS_SKB_MODE;
> > +		uut = TEST_MODE_SKB;
> > +		break;
> > +	case (TEST_MODE_DRV):
> > +		if (cur_mode != TEST_MODE_DRV)
> > +			configure_drv();
> 
> ditto
> 
> > +		xdp_flags |= XDP_FLAGS_DRV_MODE;
> > +		uut = TEST_MODE_DRV;
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +
> > +	pthread_init_mutex();
> > +
> > +	if ((test_type != TEST_TYPE_TEARDOWN) && (test_type !=
> TEST_TYPE_BIDI))
> > +		testapp_validate();
> > +	else
> > +		testapp_sockets();
> > +
> > +	pthread_destroy_mutex();
> > +}
> > +
> >  int main(int argc, char **argv)
> >  {
> >  	struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
> > @@ -1021,6 +1062,7 @@ int main(int argc, char **argv)
> >  	const char *IP2 = "192.168.100.161";
> >  	u16 UDP_DST_PORT = 2020;
> >  	u16 UDP_SRC_PORT = 2121;
> > +	int i, j;
> >
> >  	ifaceconfig = malloc(sizeof(struct ifaceconfigobj));
> >  	memcpy(ifaceconfig->dst_mac, MAC1, ETH_ALEN);
> > @@ -1046,24 +1088,19 @@ int main(int argc, char **argv)
> >
> >  	init_iface_config(ifaceconfig);
> >
> > -	pthread_init_mutex();
> > +	ksft_set_plan(TEST_MODE_MAX * TEST_TYPE_MAX);
> >
> > -	ksft_set_plan(1);
> > +	configure_skb();
> > +	cur_mode = TEST_MODE_SKB;
> >
> > -	if (!opt_teardown && !opt_bidi) {
> > -		testapp_validate();
> > -	} else if (opt_teardown && opt_bidi) {
> > -		ksft_test_result_fail("ERROR: parameters -T and -B cannot
> be used together\n");
> > -		ksft_exit_xfail();
> > -	} else {
> > -		testapp_sockets();
> > +	for (i = 0; i < TEST_MODE_MAX; i++) {
> > +		for (j = 0; j < TEST_TYPE_MAX; j++)
> > +			run_pkt_test(i, j);
> >  	}
> >
> >  	for (int i = 0; i < MAX_INTERFACES; i++)
> >  		free(ifdict[i]);
> >
> > -	pthread_destroy_mutex();
> > -
> >  	ksft_exit_pass();
> >
> >  	return 0;
