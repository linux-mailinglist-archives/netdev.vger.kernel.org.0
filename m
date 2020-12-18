Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54922DE192
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 11:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389254AbgLRKzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 05:55:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36637 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389206AbgLRKzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 05:55:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608288813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mVhVm6FP2/9asw/6EvqMmdP5RwQaxD96nqDsZxgzE2w=;
        b=dTBprpyuVRToXqHdHZPkQKOFStm/+Xl26tlc2iEyjwQSju9nwgPWeqiWkt2i1ukTD+7zy3
        zJwpu93SZlppDLGkjAv1ccsmQ6rwiUHLF30xbiFYhdYtcOY66+4ycUwXkPdzw9NDxy39aG
        8Ti1/ZiZyVP6MBeG89iMhiNWLK17dwo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-ZFuF22dbM_uK-BM88tz7Vw-1; Fri, 18 Dec 2020 05:53:30 -0500
X-MC-Unique: ZFuF22dbM_uK-BM88tz7Vw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DECBAC7400;
        Fri, 18 Dec 2020 10:53:28 +0000 (UTC)
Received: from carbon (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE7D960CEF;
        Fri, 18 Dec 2020 10:53:21 +0000 (UTC)
Date:   Fri, 18 Dec 2020 11:53:20 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next V9 7/7] bpf/selftests: tests using
 bpf_check_mtu BPF-helper
Message-ID: <20201218115320.396dbcfc@carbon>
In-Reply-To: <160822601093.3481451.9135115478358953965.stgit@firesoul>
References: <160822594178.3481451.1208057539613401103.stgit@firesoul>
        <160822601093.3481451.9135115478358953965.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020 18:26:50 +0100
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> Adding selftest for BPF-helper bpf_check_mtu(). Making sure
> it can be used from both XDP and TC.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/check_mtu.c |  204 ++++++++++++++++++++
>  tools/testing/selftests/bpf/progs/test_check_mtu.c |  196 +++++++++++++++++++
>  2 files changed, 400 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/check_mtu.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_check_mtu.c

Will send V10 as I have an error in this selftests

> diff --git a/tools/testing/selftests/bpf/prog_tests/check_mtu.c b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
> new file mode 100644
> index 000000000000..b5d0c3a9abe8
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
[...]
> +static void test_check_mtu_run_xdp(struct test_check_mtu *skel,
> +				   struct bpf_program *prog,
> +				   __u32 mtu_expect)
> +{
> +	const char *prog_name = bpf_program__name(prog);
> +	int retval_expect = XDP_PASS;
> +	__u32 mtu_result = 0;
> +	char buf[256];
> +	int err;
> +
> +	struct bpf_prog_test_run_attr tattr = {
> +		.repeat = 1,
> +		.data_in = &pkt_v4,
> +		.data_size_in = sizeof(pkt_v4),
> +		.data_out = buf,
> +		.data_size_out = sizeof(buf),
> +		.prog_fd = bpf_program__fd(prog),
> +	};
> +
> +	memset(buf, 0, sizeof(buf));
> +
> +	err = bpf_prog_test_run_xattr(&tattr);
> +	CHECK_ATTR(err != 0 || errno != 0, "bpf_prog_test_run",
                               ^^^^^^^^^^^
You/I cannot use the check "errno != 0" here, as something else could
have set it earlier.


> +		   "prog_name:%s (err %d errno %d retval %d)\n",
> +		   prog_name, err, errno, tattr.retval);
> +
> +        CHECK(tattr.retval != retval_expect, "retval",
> +	      "progname:%s unexpected retval=%d expected=%d\n",
> +	      prog_name, tattr.retval, retval_expect);
> +
> +	/* Extract MTU that BPF-prog got */
> +	mtu_result = skel->bss->global_bpf_mtu_xdp;
> +	CHECK(mtu_result != mtu_expect, "MTU-compare-user",
> +	      "failed (MTU user:%d bpf:%d)", mtu_expect, mtu_result);
> +}


> +static void test_check_mtu_run_tc(struct test_check_mtu *skel,
> +				  struct bpf_program *prog,
> +				  __u32 mtu_expect)
> +{
[...]
> +	err = bpf_prog_test_run_xattr(&tattr);
> +	CHECK_ATTR(err != 0 || errno != 0, "bpf_prog_test_run",
> +		   "prog_name:%s (err %d errno %d retval %d)\n",
> +		   prog_name, err, errno, tattr.retval);

Same issue here.


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

