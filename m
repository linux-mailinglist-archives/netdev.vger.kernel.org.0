Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC1E13AF9E
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgANQkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:40:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:36275 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgANQkn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 11:40:43 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2020 08:40:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,433,1574150400"; 
   d="scan'208";a="397565711"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 14 Jan 2020 08:40:40 -0800
Date:   Tue, 14 Jan 2020 10:33:43 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v2] selftests/bpf: Add a test for attaching a
 bpf fentry/fexit trace to an XDP program
Message-ID: <20200114093343.GB9130@ranger.igk.intel.com>
References: <157901745600.30872.10096561620432101095.stgit@xdp-tutorial>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157901745600.30872.10096561620432101095.stgit@xdp-tutorial>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 03:58:16PM +0000, Eelco Chaudron wrote:
> Add a test that will attach a FENTRY and FEXIT program to the XDP test
> program. It will also verify data from the XDP context on FENTRY and
> verifies the return code on exit.
> 
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> 
> ---
> v1 -> v2:
>   - Changed code to use the BPF skeleton
>   - Replace static volatile with global variable in eBPF code
> 
>  .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   69 ++++++++++++++++++++
>  .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |   44 +++++++++++++
>  2 files changed, 113 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
> new file mode 100644
> index 000000000000..e6e849df2632
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
> @@ -0,0 +1,69 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <net/if.h>
> +#include "test_xdp.skel.h"
> +#include "test_xdp_bpf2bpf.skel.h"
> +
> +void test_xdp_bpf2bpf(void)
> +{
> +
> +	struct test_xdp *pkt_skel = NULL;
> +        struct test_xdp_bpf2bpf *ftrace_skel = NULL;
> +	__u64 *ftrace_res;

Wanted to point out the RCT here but I see that
tools/testing/selftests/bpf/prog_tests don't really follow that rule.

> +
> +	struct vip key4 = {.protocol = 6, .family = AF_INET};
> +	struct iptnl_info value4 = {.family = AF_INET};
> +	char buf[128];
> +	struct iphdr *iph = (void *)buf + sizeof(struct ethhdr);
> +	__u32 duration = 0, retval, size;
> +	int err, pkt_fd, map_fd;
> +
> +	/* Load XDP program to introspect */
> +	pkt_skel = test_xdp__open_and_load();
> +	if (CHECK(!pkt_skel, "pkt_skel_load", "test_xdp skeleton failed\n"))
> +		return;
> +
> +	pkt_fd = bpf_program__fd(pkt_skel->progs._xdp_tx_iptunnel);
> +
> +	map_fd = bpf_map__fd(pkt_skel->maps.vip2tnl);
> +	bpf_map_update_elem(map_fd, &key4, &value4, 0);
> +
> +	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
> +			    .attach_prog_fd = pkt_fd,
> +			   );
> +
> +	ftrace_skel = test_xdp_bpf2bpf__open_opts(&opts);
> +	if (CHECK(!ftrace_skel, "__open", "ftrace skeleton failed\n"))
> +	  goto out;

Hmm do you have here mixed tabs and spaces? Maybe my client messes this
line up.

> +
> +	if (CHECK(test_xdp_bpf2bpf__load(ftrace_skel), "__load", "ftrace skeleton failed\n"))

line too long?

> +	  goto out;
> +
> +	err = test_xdp_bpf2bpf__attach(ftrace_skel);
> +	if (CHECK(err, "ftrace_attach", "ftrace attach failed: %d\n", err))
> +		goto out;
> +
> +        /* Run test program */
> +	err = bpf_prog_test_run(pkt_fd, 1, &pkt_v4, sizeof(pkt_v4),
> +				buf, &size, &retval, &duration);
> +
> +	CHECK(err || retval != XDP_TX || size != 74 ||
> +	      iph->protocol != IPPROTO_IPIP, "ipv4",
> +	      "err %d errno %d retval %d size %d\n",
> +	      err, errno, retval, size);
> +
> +	/* Verify test results */
> +	ftrace_res = (__u64 *)ftrace_skel->bss;
> +
> +	if (CHECK(ftrace_res[0] != if_nametoindex("lo"), "result",
> +		  "fentry failed err %llu\n", ftrace_res[0]))
> +		goto out;
> +
> +	if (CHECK(ftrace_res[1] != XDP_TX, "result",
> +		  "fexit failed err %llu\n", ftrace_res[1]))
> +		goto out;

this goto doesn't really make sense, can be dropped.

> +
> +out:
> +	test_xdp__destroy(pkt_skel);
> +	test_xdp_bpf2bpf__destroy(ftrace_skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> new file mode 100644
> index 000000000000..74c78b30ae07
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> @@ -0,0 +1,44 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include "bpf_helpers.h"
> +#include "bpf_trace_helpers.h"
> +
> +struct net_device {
> +	/* Structure does not need to contain all entries,
> +	 * as "preserve_access_index" will use BTF to fix this...
> +	 */
> +	int ifindex;
> +} __attribute__((preserve_access_index));
> +
> +struct xdp_rxq_info {
> +	/* Structure does not need to contain all entries,
> +	 * as "preserve_access_index" will use BTF to fix this...
> +	 */
> +	struct net_device *dev;
> +	__u32 queue_index;
> +} __attribute__((preserve_access_index));
> +
> +struct xdp_buff {
> +	void *data;
> +	void *data_end;
> +	void *data_meta;
> +	void *data_hard_start;
> +	unsigned long handle;
> +	struct xdp_rxq_info *rxq;
> +} __attribute__((preserve_access_index));
> +
> +__u64 test_result_fentry = 0;
> +BPF_TRACE_1("fentry/_xdp_tx_iptunnel", trace_on_entry,
> +	    struct xdp_buff *, xdp)
> +{
> +	test_result_fentry = xdp->rxq->dev->ifindex;
> +	return 0;
> +}
> +
> +__u64 test_result_fexit = 0;
> +BPF_TRACE_2("fexit/_xdp_tx_iptunnel", trace_on_exit,
> +	    struct xdp_buff*, xdp, int, ret)
> +{
> +	test_result_fexit = ret;
> +	return 0;
> +}
> 
