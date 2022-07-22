Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71BE757DC0B
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiGVIPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiGVIPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:15:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C8A15834;
        Fri, 22 Jul 2022 01:15:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5CE95CE27AA;
        Fri, 22 Jul 2022 08:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA88C341C6;
        Fri, 22 Jul 2022 08:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658477715;
        bh=wq8AeLzmn31RtGz2c8gYFnNwmHHMpqM6iqim4vaEza4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cngYB1j8u/zgpMZ96HSQTGkq9t1nKNZqoWH2upgMQ1rlhqzYDWggv26aQOsMcHFW+
         zN2AGbVwOuuj3bAQYjI/RZn2nCgbaQC9mJqZ0f+JmlI32HeWDNy+SMxq3NDuOR5iKR
         kKnWc85Y0b9bTlPgJQg9MxyQyZZIjd3IBt6B2AxVIQhHYhegeIEYxlb0878W1MIqoj
         LsLLaBWu5E50Lws/tjgERoTubRX/imJgTpFrCKV7MECnmBnyFzB3mag1enl+zHPEo9
         p41CnimGKdVgTbDlXZNgKlPVPAgQd7QkciimIRvMW8T2ZrETZK+37yaOX9bEW5rt4i
         cwIQZNLIgh6OQ==
Date:   Fri, 22 Jul 2022 10:15:05 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        paul@paul-moore.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, shuah@kernel.org, casey@schaufler-ca.com,
        ebiederm@xmission.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com
Subject: Re: [PATCH v3 3/4] selftests/bpf: Add tests verifying bpf lsm
 userns_create hook
Message-ID: <20220722081505.klaf3wzg6fnx3typ@wittgenstein>
References: <20220721172808.585539-1-fred@cloudflare.com>
 <20220721172808.585539-4-fred@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220721172808.585539-4-fred@cloudflare.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 12:28:07PM -0500, Frederick Lawler wrote:
> The LSM hook userns_create was introduced to provide LSM's an
> opportunity to block or allow unprivileged user namespace creation. This
> test serves two purposes: it provides a test eBPF implementation, and
> tests the hook successfully blocks or allows user namespace creation.
> 
> This tests 4 cases:
> 
>         1. Unattached bpf program does not block unpriv user namespace
>            creation.
>         2. Attached bpf program allows user namespace creation given
>            CAP_SYS_ADMIN privileges.
>         3. Attached bpf program denies user namespace creation for a
>            user without CAP_SYS_ADMIN.
>         4. The sleepable implementation loads

Sounds good!

> 
> Signed-off-by: Frederick Lawler <fred@cloudflare.com>
> 
> ---
> The generic deny_namespace file name is used for future namespace
> expansion. I didn't want to limit these files to just the create_user_ns
> hook.
> Changes since v2:
> - Rename create_user_ns hook to userns_create
> Changes since v1:
> - Introduce this patch
> ---
>  .../selftests/bpf/prog_tests/deny_namespace.c | 88 +++++++++++++++++++
>  .../selftests/bpf/progs/test_deny_namespace.c | 39 ++++++++
>  2 files changed, 127 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/deny_namespace.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_deny_namespace.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/deny_namespace.c b/tools/testing/selftests/bpf/prog_tests/deny_namespace.c
> new file mode 100644
> index 000000000000..9e4714295008
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/deny_namespace.c
> @@ -0,0 +1,88 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +#include <test_progs.h>
> +#include "test_deny_namespace.skel.h"
> +#include <sched.h>
> +#include "cap_helpers.h"
> +
> +#define STACK_SIZE (1024 * 1024)
> +static char child_stack[STACK_SIZE];
> +
> +int clone_callback(void *arg)
> +{
> +	return 0;
> +}
> +
> +static int create_new_user_ns(void)
> +{
> +	int status;
> +	pid_t cpid;
> +
> +	cpid = clone(clone_callback, child_stack + STACK_SIZE,
> +		     CLONE_NEWUSER | SIGCHLD, NULL);
> +
> +	if (cpid == -1)
> +		return errno;
> +
> +	if (cpid == 0)
> +		return 0;

Martin asked about this already but fwiw, this cannot happen with
clone(). The clone() function doesn't return twice. It always returns
the PID of the child process or an error.

> +
> +	waitpid(cpid, &status, 0);
> +	if (WIFEXITED(status))
> +		return WEXITSTATUS(status);
> +
> +	return -1;
> +}

You can also just avoid the clone() dance and simply do sm like:

static int wait_for_pid(pid_t pid)
{
	int status, ret;

again:
	ret = waitpid(pid, &status, 0);
	if (ret == -1) {
		if (errno == EINTR)
			goto again;

		return -1;
	}

	if (!WIFEXITED(status))
		return -1;

	return WEXITSTATUS(status);
}

/* negative return value -> some internal error
 * positive return value -> userns creation failed
 * 0                     -> userns creation succeeded
 */
static int create_user_ns(void)
{
	pid_t pid;

	pid = fork();
	if (pid < 0)
		return -1;

	if (pid == 0) {
		if (unshare(CLONE_NEWUSER))
			_exit(EXIT_FAILURE);
		_exit(EXIT_SUCCESS);
	}

	return wait_for_pid(pid);
}

Same difference since both codepaths hit the right spot in the kernel.

> +
> +static void test_userns_create_bpf(void)
> +{
> +	__u32 cap_mask = 1ULL << CAP_SYS_ADMIN;
> +	__u64 old_caps = 0;
> +
> +	ASSERT_OK(create_new_user_ns(), "priv new user ns");
> +
> +	cap_disable_effective(cap_mask, &old_caps);
> +
> +	ASSERT_EQ(create_new_user_ns(), EPERM, "unpriv new user ns");
> +
> +	if (cap_mask & old_caps)
> +		cap_enable_effective(cap_mask, NULL);
> +}
> +
> +static void test_unpriv_userns_create_no_bpf(void)
> +{
> +	__u32 cap_mask = 1ULL << CAP_SYS_ADMIN;
> +	__u64 old_caps = 0;
> +
> +	cap_disable_effective(cap_mask, &old_caps);
> +
> +	ASSERT_OK(create_new_user_ns(), "no-bpf unpriv new user ns");
> +
> +	if (cap_mask & old_caps)
> +		cap_enable_effective(cap_mask, NULL);
> +}
> +
> +void test_deny_namespace(void)
> +{
> +	struct test_deny_namespace *skel = NULL;
> +	int err;
> +
> +	if (test__start_subtest("unpriv_userns_create_no_bpf"))
> +		test_unpriv_userns_create_no_bpf();
> +
> +	skel = test_deny_namespace__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "skel load"))
> +		goto close_prog;
> +
> +	err = test_deny_namespace__attach(skel);
> +	if (!ASSERT_OK(err, "attach"))
> +		goto close_prog;
> +
> +	if (test__start_subtest("userns_create_bpf"))
> +		test_userns_create_bpf();
> +
> +	test_deny_namespace__detach(skel);
> +
> +close_prog:
> +	test_deny_namespace__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_deny_namespace.c b/tools/testing/selftests/bpf/progs/test_deny_namespace.c
> new file mode 100644
> index 000000000000..9ec9dabc8372
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_deny_namespace.c
> @@ -0,0 +1,39 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include <errno.h>
> +#include <linux/capability.h>
> +
> +struct kernel_cap_struct {
> +	__u32 cap[_LINUX_CAPABILITY_U32S_3];
> +} __attribute__((preserve_access_index));
> +
> +struct cred {
> +	struct kernel_cap_struct cap_effective;
> +} __attribute__((preserve_access_index));
> +
> +char _license[] SEC("license") = "GPL";
> +
> +SEC("lsm/userns_create")
> +int BPF_PROG(test_userns_create, const struct cred *cred, int ret)
> +{
> +	struct kernel_cap_struct caps = cred->cap_effective;
> +	int cap_index = CAP_TO_INDEX(CAP_SYS_ADMIN);
> +	__u32 cap_mask = CAP_TO_MASK(CAP_SYS_ADMIN);
> +
> +	if (ret)
> +		return 0;
> +
> +	ret = -EPERM;
> +	if (caps.cap[cap_index] & cap_mask)
> +		return 0;
> +
> +	return -EPERM;
> +}

Looks nice and simple.
Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>
