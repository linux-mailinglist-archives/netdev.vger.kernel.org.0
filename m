Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B908A27FA6B
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgJAHnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:43:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbgJAHnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:43:45 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601538223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SqwmxOuvg2mKV2zNhGfKfaji+GVSOGEvsmkHT66XkW0=;
        b=J7IioW1wYd/MZOB9MtB8NmgIUkgsYdyIa/V7j889KOxsmqHOh9dv3QYqitCmBabRoYlLsm
        j4OudjxB+p0lrDc4iN8VPJ7r/XwRiOYispKAB1qShEu08k66jH6A26g00RpOOWz1wSZK3I
        fhsTs1W9IcWU7Kzx0/7Fl4TwMcP0qVI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-YecVqbiIO-WRDHoAO_fbYw-1; Thu, 01 Oct 2020 03:43:42 -0400
X-MC-Unique: YecVqbiIO-WRDHoAO_fbYw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBCF31074656;
        Thu,  1 Oct 2020 07:43:39 +0000 (UTC)
Received: from [10.36.113.22] (ovpn-113-22.ams2.redhat.com [10.36.113.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4410255776;
        Thu,  1 Oct 2020 07:43:31 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Lorenzo Bianconi" <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        sameehj@amazon.com, kuba@kernel.org, john.fastabend@gmail.com,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com,
        brouer@redhat.com, lorenzo.bianconi@redhat.com, dsahern@kernel.org
Subject: Re: [PATCH v3 net-next 10/12] bpf: add xdp multi-buffer selftest
Date:   Thu, 01 Oct 2020 09:43:29 +0200
Message-ID: <E0F803BD-597D-42E8-8C17-197A99D8F4CB@redhat.com>
In-Reply-To: <fb036cd7830a6db1ea9d68f8a987bb0004ccb8d6.1601478613.git.lorenzo@kernel.org>
References: <cover.1601478613.git.lorenzo@kernel.org>
 <fb036cd7830a6db1ea9d68f8a987bb0004ccb8d6.1601478613.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30 Sep 2020, at 17:42, Lorenzo Bianconi wrote:

> Introduce xdp multi-buffer selftest for the following ebpf helpers:
> - bpf_xdp_get_frags_total_size
> - bpf_xdp_get_frag_count
>
> Co-developed-by: Eelco Chaudron <echaudro@redhat.com>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  .../testing/selftests/bpf/prog_tests/xdp_mb.c | 77 
> +++++++++++++++++++
>  .../selftests/bpf/progs/test_xdp_multi_buff.c | 24 ++++++
>  2 files changed, 101 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_mb.c
>  create mode 100644 
> tools/testing/selftests/bpf/progs/test_xdp_multi_buff.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_mb.c 
> b/tools/testing/selftests/bpf/prog_tests/xdp_mb.c
> new file mode 100644
> index 000000000000..8cfe7253bf2a
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_mb.c
> @@ -0,0 +1,77 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <unistd.h>
> +#include <linux/kernel.h>
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +
> +#include "test_xdp_multi_buff.skel.h"
> +
> +static void test_xdp_mb_check_len(void)
> +{
> +	int test_sizes[] = { 128, 4096, 9000 };
> +	struct test_xdp_multi_buff *pkt_skel;
> +	char *pkt_in = NULL, *pkt_out = NULL;
> +	__u32 duration = 0, retval, size;
> +	int err, pkt_fd, i;
> +
> +	/* Load XDP program */
> +	pkt_skel = test_xdp_multi_buff__open_and_load();
> +	if (CHECK(!pkt_skel, "pkt_skel_load", "test_xdp_mb skeleton 
> failed\n"))
> +		goto out;
> +
> +	/* Allocate resources */
> +	pkt_out = malloc(test_sizes[ARRAY_SIZE(test_sizes) - 1]);
> +	pkt_in = malloc(test_sizes[ARRAY_SIZE(test_sizes) - 1]);
> +	if (CHECK(!pkt_in || !pkt_out, "malloc",
> +		  "Failed malloc, in = %p, out %p\n", pkt_in, pkt_out))
> +		goto out;
> +
> +	pkt_fd = bpf_program__fd(pkt_skel->progs._xdp_check_mb_len);
> +	if (pkt_fd < 0)
> +		goto out;
> +
> +	/* Run test for specific set of packets */
> +	for (i = 0; i < ARRAY_SIZE(test_sizes); i++) {
> +		int frag_count;
> +
> +		/* Run test program */
> +		err = bpf_prog_test_run(pkt_fd, 1, &pkt_in, test_sizes[i],

Small bug, should be:

         err = bpf_prog_test_run(pkt_fd, 1, pkt_in, test_sizes[i],

> +					pkt_out, &size, &retval, &duration);
> +
> +		if (CHECK(err || retval != XDP_PASS, // || size != test_sizes[i],
> +			  "test_run", "err %d errno %d retval %d size %d[%d]\n",
> +			  err, errno, retval, size, test_sizes[i]))
> +			goto out;
> +
> +		/* Verify test results */
> +		frag_count = DIV_ROUND_UP(
> +			test_sizes[i] - pkt_skel->data->test_result_xdp_len,
> +			getpagesize());
> +
> +		if (CHECK(pkt_skel->data->test_result_frag_count != frag_count,
> +			  "result", "frag_count = %llu != %u\n",
> +			  pkt_skel->data->test_result_frag_count, frag_count))
> +			goto out;
> +
> +		if (CHECK(pkt_skel->data->test_result_frag_len != test_sizes[i] -
> +			  pkt_skel->data->test_result_xdp_len,
> +			  "result", "frag_len = %llu != %llu\n",
> +			  pkt_skel->data->test_result_frag_len,
> +			  test_sizes[i] - pkt_skel->data->test_result_xdp_len))
> +			goto out;
> +	}
> +out:
> +	if (pkt_out)
> +		free(pkt_out);
> +	if (pkt_in)
> +		free(pkt_in);
> +
> +	test_xdp_multi_buff__destroy(pkt_skel);
> +}
> +
> +void test_xdp_mb(void)
> +{
> +	if (test__start_subtest("xdp_mb_check_len_frags"))
> +		test_xdp_mb_check_len();
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_multi_buff.c 
> b/tools/testing/selftests/bpf/progs/test_xdp_multi_buff.c
> new file mode 100644
> index 000000000000..1a46e0925282
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_multi_buff.c
> @@ -0,0 +1,24 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/bpf.h>
> +#include <linux/if_ether.h>
> +#include <bpf/bpf_helpers.h>
> +#include <stdint.h>
> +
> +__u64 test_result_frag_len = UINT64_MAX;
> +__u64 test_result_frag_count = UINT64_MAX;
> +__u64 test_result_xdp_len = UINT64_MAX;
> +
> +SEC("xdp_check_mb_len")
> +int _xdp_check_mb_len(struct xdp_md *xdp)
> +{
> +	void *data_end = (void *)(long)xdp->data_end;
> +	void *data = (void *)(long)xdp->data;
> +
> +	test_result_xdp_len = (__u64)(data_end - data);
> +	test_result_frag_len = bpf_xdp_get_frags_total_size(xdp);
> +	test_result_frag_count = bpf_xdp_get_frag_count(xdp);
> +	return XDP_PASS;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> -- 
> 2.26.2

