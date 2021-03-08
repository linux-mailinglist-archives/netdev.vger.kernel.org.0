Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FAC33118A
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 16:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhCHO75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 09:59:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47615 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229627AbhCHO7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 09:59:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615215571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mVoEg//dE/ObGdmvisFb7CVIqOdf79YQCTe0cmXuyRA=;
        b=LCPEotHVss+RaF3Qi3WDxnFc2UZiRBLd62XNRDKK3xcWVgMgvxfUbsSwfnfLCVmfQOVcnh
        jkY41p7oGbnw/EoD0AV5WRdpAHmhY96Nq8Vs3PxwQeGb0PgOwgjrtbfOy49cCWZeyHf9Zf
        VDSrR1mpFKakC/9xT9CKilD8Wc0+Zfo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-wD4q3pUFNk6YTCmazTScTQ-1; Mon, 08 Mar 2021 09:59:29 -0500
X-MC-Unique: wD4q3pUFNk6YTCmazTScTQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 306D810866A0;
        Mon,  8 Mar 2021 14:59:28 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6A7F5C27C;
        Mon,  8 Mar 2021 14:59:24 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 9BBDE30736C74;
        Mon,  8 Mar 2021 15:59:23 +0100 (CET)
Subject: [PATCH bpf V3 2/2] selftests/bpf: Tests using bpf_check_mtu
 BPF-helper input mtu_len param
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 08 Mar 2021 15:59:23 +0100
Message-ID: <161521556358.3515614.5915221479709358964.stgit@firesoul>
In-Reply-To: <161521552920.3515614.3831682841593366034.stgit@firesoul>
References: <161521552920.3515614.3831682841593366034.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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


