Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3476B83B6
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 23:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733062AbfISVu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 17:50:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55156 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733028AbfISVu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 17:50:29 -0400
Received: from static-dcd-cqq-121001.business.bouyguestelecom.com ([212.194.121.1] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iB4Ji-00055W-Mw; Thu, 19 Sep 2019 21:50:22 +0000
Date:   Thu, 19 Sep 2019 23:50:21 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     shuah <shuah@kernel.org>
Cc:     keescook@chromium.org, luto@amacapital.net, jannh@google.com,
        wad@chromium.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Tycho Andersen <tycho@tycho.ws>,
        Tyler Hicks <tyhicks@canonical.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1 3/3] seccomp: test SECCOMP_USER_NOTIF_FLAG_CONTINUE
Message-ID: <20190919215020.7gfqwy44umxollou@wittgenstein>
References: <20190919095903.19370-1-christian.brauner@ubuntu.com>
 <20190919095903.19370-4-christian.brauner@ubuntu.com>
 <ad7d2901-6639-3684-b71c-bdc1a6a020cc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ad7d2901-6639-3684-b71c-bdc1a6a020cc@kernel.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 11:13:46AM -0600, shuah wrote:
> On 9/19/19 3:59 AM, Christian Brauner wrote:
> > Test whether a syscall can be performed after having been intercepted by
> > the seccomp notifier. The test uses dup() and kcmp() since it allows us to
> > nicely test whether the dup() syscall actually succeeded by comparing whether
> > the fds refer to the same underlying struct file.
> > 
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Andy Lutomirski <luto@amacapital.net>
> > Cc: Will Drewry <wad@chromium.org>
> > Cc: Shuah Khan <shuah@kernel.org>
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Cc: Song Liu <songliubraving@fb.com>
> > Cc: Yonghong Song <yhs@fb.com>
> > Cc: Tycho Andersen <tycho@tycho.ws>
> > CC: Tyler Hicks <tyhicks@canonical.com>
> > Cc: stable@vger.kernel.org
> > Cc: linux-kselftest@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Cc: bpf@vger.kernel.org
> > ---
> > /* v1 */
> > - Christian Brauner <christian.brauner@ubuntu.com>:
> >    - adapt to new flag name SECCOMP_USER_NOTIF_FLAG_CONTINUE
> > 
> > /* v0 */
> > Link: https://lore.kernel.org/r/20190918084833.9369-5-christian.brauner@ubuntu.com
> > ---
> >   tools/testing/selftests/seccomp/seccomp_bpf.c | 102 ++++++++++++++++++
> >   1 file changed, 102 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
> > index e996d7b7fd6e..b0966599acb5 100644
> > --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> > +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> > @@ -44,6 +44,7 @@
> >   #include <sys/times.h>
> >   #include <sys/socket.h>
> >   #include <sys/ioctl.h>
> > +#include <linux/kcmp.h>
> >   #include <unistd.h>
> >   #include <sys/syscall.h>
> > @@ -167,6 +168,10 @@ struct seccomp_metadata {
> >   #define SECCOMP_RET_USER_NOTIF 0x7fc00000U
> > +#ifndef SECCOMP_USER_NOTIF_FLAG_CONTINUE
> > +#define SECCOMP_USER_NOTIF_FLAG_CONTINUE 0x00000001
> > +#endif
> > +
> >   #define SECCOMP_IOC_MAGIC		'!'
> >   #define SECCOMP_IO(nr)			_IO(SECCOMP_IOC_MAGIC, nr)
> >   #define SECCOMP_IOR(nr, type)		_IOR(SECCOMP_IOC_MAGIC, nr, type)
> > @@ -3481,6 +3486,103 @@ TEST(seccomp_get_notif_sizes)
> >   	EXPECT_EQ(sizes.seccomp_notif_resp, sizeof(struct seccomp_notif_resp));
> >   }
> > +static int filecmp(pid_t pid1, pid_t pid2, int fd1, int fd2)
> > +{
> > +#ifdef __NR_kcmp
> > +	return syscall(__NR_kcmp, pid1, pid2, KCMP_FILE, fd1, fd2);
> > +#else
> > +	errno = ENOSYS;
> > +	return -1;
> 
> This should be SKIP for kselftest so this isn't counted a failure.
> In this case test can't be run because of a missing dependency.

Right, I can just ifdef the whole test and report a skip.
