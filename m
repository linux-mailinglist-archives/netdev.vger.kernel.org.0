Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140B861EED0
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 10:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbiKGJX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 04:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbiKGJXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 04:23:53 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026A0656E;
        Mon,  7 Nov 2022 01:23:52 -0800 (PST)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N5QlH6BprzmVWB;
        Mon,  7 Nov 2022 17:23:39 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 17:23:50 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 17:23:49 +0800
From:   Yang Jihong <yangjihong1@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        <illusionist.neo@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mykolal@fb.com>, <shuah@kernel.org>,
        <benjamin.tissoires@redhat.com>, <memxor@gmail.com>,
        <asavkov@redhat.com>, <delyank@fb.com>, <bpf@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     <yangjihong1@huawei.com>
Subject: [PATCH bpf v2 5/5] bpf:selftests: Add kfunc_call test for mixing 32-bit and 64-bit parameters
Date:   Mon, 7 Nov 2022 17:20:32 +0800
Message-ID: <20221107092032.178235-6-yangjihong1@huawei.com>
X-Mailer: git-send-email 2.30.GIT
In-Reply-To: <20221107092032.178235-1-yangjihong1@huawei.com>
References: <20221107092032.178235-1-yangjihong1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.61]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

32-bit ARM has four registers to save function parameters,
add test cases to cover additional scenarios.

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 net/bpf/test_run.c                            | 18 +++++++
 .../selftests/bpf/prog_tests/kfunc_call.c     |  3 ++
 .../selftests/bpf/progs/kfunc_call_test.c     | 52 +++++++++++++++++++
 3 files changed, 73 insertions(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 13d578ce2a09..e7eb5bd4cf0e 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -551,6 +551,21 @@ struct sock * noinline bpf_kfunc_call_test3(struct sock *sk)
 	return sk;
 }
 
+u64 noinline bpf_kfunc_call_test4(struct sock *sk, u64 a, u64 b, u32 c, u32 d)
+{
+	return a + b + c + d;
+}
+
+u64 noinline bpf_kfunc_call_test5(u64 a, u64 b)
+{
+	return a + b;
+}
+
+u64 noinline bpf_kfunc_call_test6(u32 a, u32 b, u32 c, u32 d, u32 e)
+{
+	return a + b + c + d + e;
+}
+
 struct prog_test_member1 {
 	int a;
 };
@@ -739,6 +754,9 @@ BTF_SET8_START(test_sk_check_kfunc_ids)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test1)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test2)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test3)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test4)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test5)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test6)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_acquire, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_kfunc_call_memb_acquire, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_release, KF_RELEASE)
diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
index 5af1ee8f0e6e..6a6822e99071 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -72,6 +72,9 @@ static struct kfunc_test_params kfunc_tests[] = {
 	/* success cases */
 	TC_TEST(kfunc_call_test1, 12),
 	TC_TEST(kfunc_call_test2, 3),
+	TC_TEST(kfunc_call_test4, 16),
+	TC_TEST(kfunc_call_test5, 7),
+	TC_TEST(kfunc_call_test6, 15),
 	TC_TEST(kfunc_call_test_ref_btf_id, 0),
 	TC_TEST(kfunc_call_test_get_mem, 42),
 	SYSCALL_TEST(kfunc_syscall_test, 0),
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_test.c b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
index f636e50be259..0385ce2d4c6e 100644
--- a/tools/testing/selftests/bpf/progs/kfunc_call_test.c
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_test.c
@@ -6,6 +6,11 @@
 extern int bpf_kfunc_call_test2(struct sock *sk, __u32 a, __u32 b) __ksym;
 extern __u64 bpf_kfunc_call_test1(struct sock *sk, __u32 a, __u64 b,
 				  __u32 c, __u64 d) __ksym;
+extern __u64 bpf_kfunc_call_test4(struct sock *sk, __u64 a, __u64 b,
+				  __u32 c, __u32 d) __ksym;
+extern __u64 bpf_kfunc_call_test5(__u64 a, __u64 b) __ksym;
+extern __u64 bpf_kfunc_call_test6(__u32 a, __u32 b, __u32 c, __u32 d,
+				  __u32 e) __ksym;
 
 extern struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(unsigned long *sp) __ksym;
 extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
@@ -17,6 +22,53 @@ extern void bpf_kfunc_call_test_mem_len_fail2(__u64 *mem, int len) __ksym;
 extern int *bpf_kfunc_call_test_get_rdwr_mem(struct prog_test_ref_kfunc *p, const int rdwr_buf_size) __ksym;
 extern int *bpf_kfunc_call_test_get_rdonly_mem(struct prog_test_ref_kfunc *p, const int rdonly_buf_size) __ksym;
 
+SEC("tc")
+int kfunc_call_test6(struct __sk_buff *skb)
+{
+	__u64 a = 1ULL << 32;
+	__u32 ret;
+
+	a = bpf_kfunc_call_test6(1, 2, 3, 4, 5);
+	ret = a >> 32;   /* ret should be 0 */
+	ret += (__u32)a; /* ret should be 15 */
+
+	return ret;
+}
+
+SEC("tc")
+int kfunc_call_test5(struct __sk_buff *skb)
+{
+	__u64 a = 1ULL << 32;
+	__u32 ret;
+
+	a = bpf_kfunc_call_test5(a | 2, a | 3);
+	ret = a >> 32;   /* ret should be 2 */
+	ret += (__u32)a; /* ret should be 7 */
+
+	return ret;
+}
+
+SEC("tc")
+int kfunc_call_test4(struct __sk_buff *skb)
+{
+	struct bpf_sock *sk = skb->sk;
+	__u64 a = 1ULL << 32;
+	__u32 ret;
+
+	if (!sk)
+		return -1;
+
+	sk = bpf_sk_fullsock(sk);
+	if (!sk)
+		return -1;
+
+	a = bpf_kfunc_call_test4((struct sock *)sk, a | 2, a | 3, 4, 5);
+	ret = a >> 32;   /* ret should be 2 */
+	ret += (__u32)a; /* ret should be 16 */
+
+	return ret;
+}
+
 SEC("tc")
 int kfunc_call_test2(struct __sk_buff *skb)
 {
-- 
2.30.GIT

