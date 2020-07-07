Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE34216CB0
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 14:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgGGMW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 08:22:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38950 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgGGMWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 08:22:25 -0400
Received: from ip5f5af08c.dynamic.kabel-deutschland.de ([95.90.240.140] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jsmcA-0006wX-2H; Tue, 07 Jul 2020 12:22:22 +0000
Date:   Tue, 7 Jul 2020 14:22:20 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@lst.de>
Cc:     linux-kernel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@ACULAB.COM>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v6 4/7] pidfd: Replace open-coded partial receive_fd()
Message-ID: <20200707122220.cazzek4655gj4tj7@wittgenstein>
References: <20200706201720.3482959-1-keescook@chromium.org>
 <20200706201720.3482959-5-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200706201720.3482959-5-keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 01:17:17PM -0700, Kees Cook wrote:
> The sock counting (sock_update_netprioidx() and sock_update_classid()) was
> missing from pidfd's implementation of received fd installation. Replace
> the open-coded version with a call to the new receive_fd()
> helper.
> 
> Thanks to Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com> for
> catching a missed fput() in an earlier version of this patch.
> 
> Fixes: 8649c322f75c ("pid: Implement pidfd_getfd syscall")
> Reviewed-by: Sargun Dhillon <sargun@sargun.me>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Thanks!
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

Christoph, Kees,

So while the patch is correct it leaves 5.6 and 5.7 with a bug in the
pidfd_getfd() implementation and that just doesn't seem right. I'm
wondering whether we should introduce:

void sock_update(struct file *file)
{
	struct socket *sock;
	int error;

	sock = sock_from_file(file, &error);
	if (sock) {
		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
		sock_update_classid(&sock->sk->sk_cgrp_data);
	}
}

and switch pidfd_getfd() over to:

diff --git a/kernel/pid.c b/kernel/pid.c
index f1496b757162..c26bba822be3 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -642,10 +642,12 @@ static int pidfd_getfd(struct pid *pid, int fd)
        }

        ret = get_unused_fd_flags(O_CLOEXEC);
-       if (ret < 0)
+       if (ret < 0) {
                fput(file);
-       else
+       } else {
+               sock_update(file);
                fd_install(ret, file);
+       }

        return ret;
 }

first thing in the series and then all of the other patches on top of it
so that we can Cc stable for this and that can get it backported to 5.6,
5.7, and 5.8.

Alternatively, I can make this a separate bugfix patch series which I'll
send upstream soonish. Or we have specific patches just for 5.6, 5.7,
and 5.8. Thoughts?

Thanks!
Christian
