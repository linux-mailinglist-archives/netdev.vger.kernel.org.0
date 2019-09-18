Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5CAEB60F7
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 12:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbfIRKBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 06:01:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43904 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfIRKB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 06:01:29 -0400
Received: from static-dcd-cqq-121001.business.bouyguestelecom.com ([212.194.121.1] helo=elm)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <tyhicks@canonical.com>)
        id 1iAWm2-0001XJ-Nx; Wed, 18 Sep 2019 10:01:22 +0000
Date:   Wed, 18 Sep 2019 12:01:21 +0200
From:   Tyler Hicks <tyhicks@canonical.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     keescook@chromium.org, luto@amacapital.net, jannh@google.com,
        wad@chromium.org, shuah@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/4] seccomp: avoid overflow in implicit constant
 conversion
Message-ID: <20190918100121.GB5088@elm>
References: <20190918084833.9369-1-christian.brauner@ubuntu.com>
 <20190918084833.9369-4-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190918084833.9369-4-christian.brauner@ubuntu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-09-18 10:48:32, Christian Brauner wrote:
> USER_NOTIF_MAGIC is assigned to int variables in this test so set it to INT_MAX
> to avoid warnings:
> 
> seccomp_bpf.c: In function ‘user_notification_continue’:
> seccomp_bpf.c:3088:26: warning: overflow in implicit constant conversion [-Woverflow]
>  #define USER_NOTIF_MAGIC 116983961184613L
>                           ^
> seccomp_bpf.c:3572:15: note: in expansion of macro ‘USER_NOTIF_MAGIC’
>   resp.error = USER_NOTIF_MAGIC;
>                ^~~~~~~~~~~~~~~~
> 
> Fixes: 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
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

INT_MAX should be a safe value to use.

Reviewed-by: Tyler Hicks <tyhicks@canonical.com>

Tyler

> Cc: Jann Horn <jannh@google.com>
> Cc: stable@vger.kernel.org
> Cc: linux-kselftest@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org
> ---
>  tools/testing/selftests/seccomp/seccomp_bpf.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
> index ee52eab01800..921f0e26f835 100644
> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> @@ -35,6 +35,7 @@
>  #include <stdbool.h>
>  #include <string.h>
>  #include <time.h>
> +#include <limits.h>
>  #include <linux/elf.h>
>  #include <sys/uio.h>
>  #include <sys/utsname.h>
> @@ -3080,7 +3081,7 @@ static int user_trap_syscall(int nr, unsigned int flags)
>  	return seccomp(SECCOMP_SET_MODE_FILTER, flags, &prog);
>  }
>  
> -#define USER_NOTIF_MAGIC 116983961184613L
> +#define USER_NOTIF_MAGIC INT_MAX
>  TEST(user_notification_basic)
>  {
>  	pid_t pid;
> -- 
> 2.23.0
> 
