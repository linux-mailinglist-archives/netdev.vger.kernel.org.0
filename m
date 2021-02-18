Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FADF31EA98
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 14:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbhBRNwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 08:52:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40048 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230335AbhBRLvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 06:51:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613649008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mVoEg//dE/ObGdmvisFb7CVIqOdf79YQCTe0cmXuyRA=;
        b=CkgCvt11t0DOVDJ0LQz87Nc8H0UE0pHfguL/sAgbQFJk11FGZVOtY0qtZwx0+f0zSZHEhe
        7qw1pUtS2yTKde9szfEqVQnGzKR7eKzpecAMbaZOb/AqkzjgTLALZw3t0+R8xEiApXwu86
        U8dy9rSvVLmdKhtBe8wnyATFYpt998o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-wQZcJmKZPkGnog_WYWyxOA-1; Thu, 18 Feb 2021 06:50:06 -0500
X-MC-Unique: wQZcJmKZPkGnog_WYWyxOA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 387C21005501;
        Thu, 18 Feb 2021 11:50:05 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3707197F9;
        Thu, 18 Feb 2021 11:50:04 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id AA4BC30736C73;
        Thu, 18 Feb 2021 12:50:03 +0100 (CET)
Subject: [PATCH bpf-next V2 2/2] selftests/bpf: Tests using bpf_check_mtu
 BPF-helper input mtu_len param
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Feb 2021 12:50:03 +0100
Message-ID: <161364900363.1250213.9894483265551874755.stgit@firesoul>
In-Reply-To: <161364896576.1250213.8059418482723660876.stgit@firesoul>
References: <161364896576.1250213.8059418482723660876.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests that use mtu_len as input parameter in BPF-helper
bpf_check_mtu().

The BPF-helper is avail from both XDP and TC context. Add two tests
per context, one that tests below MTU and one that exceeds the MTU.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/check_mtu.c |    4 +
 tools/testing/selftests/bpf/progs/test_check_mtu.c |   92 ++++++++++++++++++++
 2 files changed, 96 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/check_mtu.c b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
index 36af1c138faf..b62a39315336 100644
--- a/tools/testing/selftests/bpf/prog_tests/check_mtu.c
+++ b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
@@ -128,6 +128,8 @@ static void test_check_mtu_xdp(__u32 mtu, __u32 ifindex)
 	test_check_mtu_run_xdp(skel, skel->progs.xdp_use_helper, mtu);
 	test_check_mtu_run_xdp(skel, skel->progs.xdp_exceed_mtu, mtu);
 	test_check_mtu_run_xdp(skel, skel->progs.xdp_minus_delta, mtu);
+	test_check_mtu_run_xdp(skel, skel->progs.xdp_input_len, mtu);
+	test_check_mtu_run_xdp(skel, skel->progs.xdp_input_len_exceed, mtu);
 
 cleanup:
 	test_check_mtu__destroy(skel);
@@ -187,6 +189,8 @@ static void test_check_mtu_tc(__u32 mtu, __u32 ifindex)
 	test_check_mtu_run_tc(skel, skel->progs.tc_exceed_mtu, mtu);
 	test_check_mtu_run_tc(skel, skel->progs.tc_exceed_mtu_da, mtu);
 	test_check_mtu_run_tc(skel, skel->progs.tc_minus_delta, mtu);
+	test_check_mtu_run_tc(skel, skel->progs.tc_input_len, mtu);
+	test_check_mtu_run_tc(skel, skel->progs.tc_input_len_exceed, mtu);
 cleanup:
 	test_check_mtu__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_check_mtu.c b/tools/testing/selftests/bpf/progs/test_check_mtu.c
index b7787b43f9db..c4a9bae96e75 100644
--- a/tools/testing/selftests/bpf/progs/test_check_mtu.c
+++ b/tools/testing/selftests/bpf/progs/test_check_mtu.c
@@ -105,6 +105,54 @@ int xdp_minus_delta(struct xdp_md *ctx)
 	return retval;
 }
 
+SEC("xdp")
+int xdp_input_len(struct xdp_md *ctx)
+{
+	int retval = XDP_PASS; /* Expected retval on successful test */
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	__u32 ifindex = GLOBAL_USER_IFINDEX;
+	__u32 data_len = data_end - data;
+
+	/* API allow user give length to check as input via mtu_len param,
+	 * resulting MTU value is still output in mtu_len param after call.
+	 *
+	 * Input len is L3, like MTU and iph->tot_len.
+	 * Remember XDP data_len is L2.
+	 */
+	__u32 mtu_len = data_len - ETH_HLEN;
+
+	if (bpf_check_mtu(ctx, ifindex, &mtu_len, 0, 0))
+		retval = XDP_ABORTED;
+
+	global_bpf_mtu_xdp = mtu_len;
+	return retval;
+}
+
+SEC("xdp")
+int xdp_input_len_exceed(struct xdp_md *ctx)
+{
+	int retval = XDP_ABORTED; /* Fail */
+	__u32 ifindex = GLOBAL_USER_IFINDEX;
+	int err;
+
+	/* API allow user give length to check as input via mtu_len param,
+	 * resulting MTU value is still output in mtu_len param after call.
+	 *
+	 * Input length value is L3 size like MTU.
+	 */
+	__u32 mtu_len = GLOBAL_USER_MTU;
+
+	mtu_len += 1; /* Exceed with 1 */
+
+	err = bpf_check_mtu(ctx, ifindex, &mtu_len, 0, 0);
+	if (err == BPF_MTU_CHK_RET_FRAG_NEEDED)
+		retval = XDP_PASS ; /* Success in exceeding MTU check */
+
+	global_bpf_mtu_xdp = mtu_len;
+	return retval;
+}
+
 SEC("classifier")
 int tc_use_helper(struct __sk_buff *ctx)
 {
@@ -196,3 +244,47 @@ int tc_minus_delta(struct __sk_buff *ctx)
 	global_bpf_mtu_xdp = mtu_len;
 	return retval;
 }
+
+SEC("classifier")
+int tc_input_len(struct __sk_buff *ctx)
+{
+	int retval = BPF_OK; /* Expected retval on successful test */
+	__u32 ifindex = GLOBAL_USER_IFINDEX;
+
+	/* API allow user give length to check as input via mtu_len param,
+	 * resulting MTU value is still output in mtu_len param after call.
+	 *
+	 * Input length value is L3 size.
+	 */
+	__u32 mtu_len = GLOBAL_USER_MTU;
+
+	if (bpf_check_mtu(ctx, ifindex, &mtu_len, 0, 0))
+		retval = BPF_DROP;
+
+	global_bpf_mtu_xdp = mtu_len;
+	return retval;
+}
+
+SEC("classifier")
+int tc_input_len_exceed(struct __sk_buff *ctx)
+{
+	int retval = BPF_DROP; /* Fail */
+	__u32 ifindex = GLOBAL_USER_IFINDEX;
+	int err;
+
+	/* API allow user give length to check as input via mtu_len param,
+	 * resulting MTU value is still output in mtu_len param after call.
+	 *
+	 * Input length value is L3 size like MTU.
+	 */
+	__u32 mtu_len = GLOBAL_USER_MTU;
+
+	mtu_len += 1; /* Exceed with 1 */
+
+	err = bpf_check_mtu(ctx, ifindex, &mtu_len, 0, 0);
+	if (err == BPF_MTU_CHK_RET_FRAG_NEEDED)
+		retval = BPF_OK; /* Success in exceeding MTU check */
+
+	global_bpf_mtu_xdp = mtu_len;
+	return retval;
+}


