Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3290B7FC9
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 19:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391913AbfISRNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 13:13:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389036AbfISRNu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 13:13:50 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBC8920644;
        Thu, 19 Sep 2019 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568913229;
        bh=C6c2YEvibdNoNZWf7eWMbtcC3kWsBLMtr7qv9n5HX54=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=LejHyarjxv6foUiqT/iaweRXMyAKc4MrbnjqLEg2nnurVkyhwKcDkK3JVf2yhJYja
         Z5Kvoa0iWl4DR+8KnhgjPli9uFV2SD9iAv5pUbgS/7da52hED+gtALndkivj4Yn6bA
         NSUqH6AXWqwF1hy4H7z6sIg3aSZXQYOx63anetpo=
Subject: Re: [PATCH v1 3/3] seccomp: test SECCOMP_USER_NOTIF_FLAG_CONTINUE
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        keescook@chromium.org, luto@amacapital.net
Cc:     jannh@google.com, wad@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>,
        Tyler Hicks <tyhicks@canonical.com>, stable@vger.kernel.org,
        shuah <shuah@kernel.org>
References: <20190919095903.19370-1-christian.brauner@ubuntu.com>
 <20190919095903.19370-4-christian.brauner@ubuntu.com>
From:   shuah <shuah@kernel.org>
Message-ID: <ad7d2901-6639-3684-b71c-bdc1a6a020cc@kernel.org>
Date:   Thu, 19 Sep 2019 11:13:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919095903.19370-4-christian.brauner@ubuntu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/19 3:59 AM, Christian Brauner wrote:
> Test whether a syscall can be performed after having been intercepted by
> the seccomp notifier. The test uses dup() and kcmp() since it allows us to
> nicely test whether the dup() syscall actually succeeded by comparing whether
> the fds refer to the same underlying struct file.
> 
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Will Drewry <wad@chromium.org>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: Tycho Andersen <tycho@tycho.ws>
> CC: Tyler Hicks <tyhicks@canonical.com>
> Cc: stable@vger.kernel.org
> Cc: linux-kselftest@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org
> ---
> /* v1 */
> - Christian Brauner <christian.brauner@ubuntu.com>:
>    - adapt to new flag name SECCOMP_USER_NOTIF_FLAG_CONTINUE
> 
> /* v0 */
> Link: https://lore.kernel.org/r/20190918084833.9369-5-christian.brauner@ubuntu.com
> ---
>   tools/testing/selftests/seccomp/seccomp_bpf.c | 102 ++++++++++++++++++
>   1 file changed, 102 insertions(+)
> 
> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
> index e996d7b7fd6e..b0966599acb5 100644
> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> @@ -44,6 +44,7 @@
>   #include <sys/times.h>
>   #include <sys/socket.h>
>   #include <sys/ioctl.h>
> +#include <linux/kcmp.h>
>   
>   #include <unistd.h>
>   #include <sys/syscall.h>
> @@ -167,6 +168,10 @@ struct seccomp_metadata {
>   
>   #define SECCOMP_RET_USER_NOTIF 0x7fc00000U
>   
> +#ifndef SECCOMP_USER_NOTIF_FLAG_CONTINUE
> +#define SECCOMP_USER_NOTIF_FLAG_CONTINUE 0x00000001
> +#endif
> +
>   #define SECCOMP_IOC_MAGIC		'!'
>   #define SECCOMP_IO(nr)			_IO(SECCOMP_IOC_MAGIC, nr)
>   #define SECCOMP_IOR(nr, type)		_IOR(SECCOMP_IOC_MAGIC, nr, type)
> @@ -3481,6 +3486,103 @@ TEST(seccomp_get_notif_sizes)
>   	EXPECT_EQ(sizes.seccomp_notif_resp, sizeof(struct seccomp_notif_resp));
>   }
>   
> +static int filecmp(pid_t pid1, pid_t pid2, int fd1, int fd2)
> +{
> +#ifdef __NR_kcmp
> +	return syscall(__NR_kcmp, pid1, pid2, KCMP_FILE, fd1, fd2);
> +#else
> +	errno = ENOSYS;
> +	return -1;

This should be SKIP for kselftest so this isn't counted a failure.
In this case test can't be run because of a missing dependency.

> +#endif
> +}
> +
> +TEST(user_notification_continue)
> +{
> +	pid_t pid;
> +	long ret;
> +	int status, listener;
> +	struct seccomp_notif req = {};
> +	struct seccomp_notif_resp resp = {};
> +	struct pollfd pollfd;
> +
> +	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
> +	ASSERT_EQ(0, ret) {
> +		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
> +	}
> +
> +	listener = user_trap_syscall(__NR_dup, SECCOMP_FILTER_FLAG_NEW_LISTENER);
> +	ASSERT_GE(listener, 0);
> +
> +	pid = fork();
> +	ASSERT_GE(pid, 0);
> +
> +	if (pid == 0) {
> +		int dup_fd, pipe_fds[2];
> +		pid_t self;
> +
> +		ret = pipe(pipe_fds);
> +		if (ret < 0)
> +			exit(EXIT_FAILURE);
> +
> +		dup_fd = dup(pipe_fds[0]);
> +		if (dup_fd < 0)
> +			exit(EXIT_FAILURE);
> +
> +		self = getpid();
> +
> +		ret = filecmp(self, self, pipe_fds[0], dup_fd);
> +		if (ret)
> +			exit(EXIT_FAILURE);
> +
> +		exit(EXIT_SUCCESS);
> +	}
> +
> +	pollfd.fd = listener;
> +	pollfd.events = POLLIN | POLLOUT;
> +
> +	EXPECT_GT(poll(&pollfd, 1, -1), 0);
> +	EXPECT_EQ(pollfd.revents, POLLIN);
> +
> +	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
> +
> +	pollfd.fd = listener;
> +	pollfd.events = POLLIN | POLLOUT;
> +
> +	EXPECT_GT(poll(&pollfd, 1, -1), 0);
> +	EXPECT_EQ(pollfd.revents, POLLOUT);
> +
> +	EXPECT_EQ(req.data.nr, __NR_dup);
> +
> +	resp.id = req.id;
> +	resp.flags = SECCOMP_USER_NOTIF_FLAG_CONTINUE;
> +
> +	/*
> +	 * Verify that setting SECCOMP_USER_NOTIF_FLAG_CONTINUE enforces other
> +	 * args be set to 0.
> +	 */
> +	resp.error = 0;
> +	resp.val = USER_NOTIF_MAGIC;
> +	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), -1);
> +	EXPECT_EQ(errno, EINVAL);
> +
> +	resp.error = USER_NOTIF_MAGIC;
> +	resp.val = 0;
> +	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), -1);
> +	EXPECT_EQ(errno, EINVAL);
> +
> +	resp.error = 0;
> +	resp.val = 0;
> +	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), 0) {
> +		if (errno == EINVAL)
> +			XFAIL(goto skip, "Kernel does not support SECCOMP_USER_NOTIF_FLAG_CONTINUE");
> +	}
> +
> +skip:
> +	EXPECT_EQ(waitpid(pid, &status, 0), pid);
> +	EXPECT_EQ(true, WIFEXITED(status));
> +	EXPECT_EQ(0, WEXITSTATUS(status));
> +}
> +
>   /*
>    * TODO:
>    * - add microbenchmarks
> 

thanks,
-- Shuah
