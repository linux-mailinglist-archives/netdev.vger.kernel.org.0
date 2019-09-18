Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5FBB6918
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 19:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387794AbfIRRaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 13:30:03 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35827 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbfIRRaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 13:30:03 -0400
Received: by mail-pl1-f195.google.com with SMTP id s17so288007plp.2
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 10:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GUxs3ppBWjO6MvWeEa5OPViHs5o2PNpYpDSgemqtMKU=;
        b=MBFaKfnAunKPJzeuvir2VqnMxhnWK27CCeerc22oy+A19xqjzPiI7wD6vVQ6qYhOwK
         kG5j6/le65zDAy6TKhXfvNwzVPleX2r+h3VC3w0Sdqs5smyn/1nloTqrLwVFivS3+Jw8
         +tJdsaW2QjuFQxKripj59KUr7CgEEfadLTX6U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GUxs3ppBWjO6MvWeEa5OPViHs5o2PNpYpDSgemqtMKU=;
        b=cu3TiAg/UgV8qJDiYMsDelpwPer6ASI4+SZNJhlCI56JfaFWKZK5Pl21Y3pFMtWcnk
         mO3xEasmwJ2FxxqcO1R1ViX/g83cxI1T9lKz7KR8uwpFDhssP9gtAO4ICP4xlq9OwFp0
         U14bNOWz+7QXX2xH1U6RH9CqkKV0xEGsMWWiqCcg9GM7wnkau3e8UR5V94aToM5BM5F4
         nuNZ3+5VrLdfFBBwhIu9H/KXQuv9r3hI3xEl65R15jr1joyNP2zPIXwuSkL8heM/qNgY
         qCWonFftlglGvvutMgm+aanr1+TqQDbOCmq4fcevUOhTnScIVYJC4hSDMElG3+y3dxSh
         R1ig==
X-Gm-Message-State: APjAAAVJIwV7+qyRB7QiXNrUBa6kW5Twc7JBPs/Zjx23gynmhyw/4Znv
        5gmbTZr74ktWyT8IDyb22We2xg==
X-Google-Smtp-Source: APXvYqz2fE+Or3qClARFl8tcu+gzAJlmtllJFa2j2ZTrTLIYt/MmOrrS7xSYwcMKS2c2wevFxCkkMg==
X-Received: by 2002:a17:902:758a:: with SMTP id j10mr5397703pll.233.1568827802416;
        Wed, 18 Sep 2019 10:30:02 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a29sm9816765pfr.152.2019.09.18.10.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 10:30:01 -0700 (PDT)
Date:   Wed, 18 Sep 2019 10:30:00 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     luto@amacapital.net, jannh@google.com, wad@chromium.org,
        shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Tycho Andersen <tycho@tycho.ws>,
        Tyler Hicks <tyhicks@canonical.com>
Subject: Re: [PATCH 1/4] seccomp: add SECCOMP_RET_USER_NOTIF_ALLOW
Message-ID: <201909181018.E3CEC9A81@keescook>
References: <20190918084833.9369-1-christian.brauner@ubuntu.com>
 <20190918084833.9369-2-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918084833.9369-2-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 10:48:30AM +0200, Christian Brauner wrote:
> This allows the seccomp notifier to continue a syscall. A positive
> discussion about this feature was triggered by a post to the
> ksummit-discuss mailing list (cf. [3]) and took place during KSummit
> (cf. [1]) and again at the containers/checkpoint-restore
> micro-conference at Linux Plumbers.
> 
> Recently we landed seccomp support for SECCOMP_RET_USER_NOTIF (cf. [4])
> which enables a process (watchee) to retrieve an fd for its seccomp
> filter. This fd can then be handed to another (usually more privileged)
> process (watcher). The watcher will then be able to receive seccomp
> messages about the syscalls having been performed by the watchee.
> 
> This feature is heavily used in some userspace workloads. For example,
> it is currently used to intercept mknod() syscalls in user namespaces
> aka in containers.
> The mknod() syscall can be easily filtered based on dev_t. This allows
> us to only intercept a very specific subset of mknod() syscalls.
> Furthermore, mknod() is not possible in user namespaces toto coelo and
> so intercepting and denying syscalls that are not in the whitelist on
> accident is not a big deal. The watchee won't notice a difference.
> 
> In contrast to mknod(), a lot of other syscall we intercept (e.g.
> setxattr()) cannot be easily filtered like mknod() because they have
> pointer arguments. Additionally, some of them might actually succeed in
> user namespaces (e.g. setxattr() for all "user.*" xattrs). Since we
> currently cannot tell seccomp to continue from a user notifier we are
> stuck with performing all of the syscalls in lieu of the container. This
> is a huge security liability since it is extremely difficult to
> correctly assume all of the necessary privileges of the calling task
> such that the syscall can be successfully emulated without escaping
> other additional security restrictions (think missing CAP_MKNOD for
> mknod(), or MS_NODEV on a filesystem etc.). This can be solved by
> telling seccomp to resume the syscall.
> 
> One thing that came up in the discussion was the problem that another
> thread could change the memory after userspace has decided to let the
> syscall continue which is a well known TOCTOU with seccomp which is
> present in other ways already.
> The discussion showed that this feature is already very useful for any
> syscall without pointer arguments. For any accidentally intercepted
> non-pointer syscall it is safe to continue.
> For syscalls with pointer arguments there is a race but for any cautious
> userspace and the main usec cases the race doesn't matter. The notifier
> is intended to be used in a scenario where a more privileged watcher
> supervises the syscalls of lesser privileged watchee to allow it to get
> around kernel-enforced limitations by performing the syscall for it
> whenever deemed save by the watcher. Hence, if a user tricks the watcher
> into allowing a syscall they will either get a deny based on
> kernel-enforced restrictions later or they will have changed the
> arguments in such a way that they manage to perform a syscall with
> arguments that they would've been allowed to do anyway.
> In general, it is good to point out again, that the notifier fd was not
> intended to allow userspace to implement a security policy but rather to
> work around kernel security mechanisms in cases where the watcher knows
> that a given action is safe to perform.
> 
> /* References */
> [1]: https://linuxplumbersconf.org/event/4/contributions/560
> [2]: https://linuxplumbersconf.org/event/4/contributions/477
> [3]: https://lore.kernel.org/r/20190719093538.dhyopljyr5ns33qx@brauner.io
> [4]: commit 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
> 
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Will Drewry <wad@chromium.org>
> Cc: Tycho Andersen <tycho@tycho.ws>
> CC: Tyler Hicks <tyhicks@canonical.com>
> Cc: Jann Horn <jannh@google.com>
> ---
>  include/uapi/linux/seccomp.h |  2 ++
>  kernel/seccomp.c             | 24 ++++++++++++++++++++----
>  2 files changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
> index 90734aa5aa36..2c23b9aa6383 100644
> --- a/include/uapi/linux/seccomp.h
> +++ b/include/uapi/linux/seccomp.h
> @@ -76,6 +76,8 @@ struct seccomp_notif {
>  	struct seccomp_data data;
>  };
>  
> +#define SECCOMP_RET_USER_NOTIF_ALLOW 0x00000001

nit: I'd like to avoid confusion here about what "family" these flags
belong to. "SECCOMP_RET_..." is used for the cBPF filter return action
value, so let's instead call this:

#define SECCOMP_USER_NOTIF_CONTINUE	BIT(0)

I'm thinking of "continue" as slightly different from "allow", in the
sense that I'd like to hint that this doesn't mean arguments could have
been reliably "filtered" via user notification.

And at the same time, please add a giant comment about this in the
header that details the purpose ("check if I should do something on
behalf of the process") and not "is this safe to allow?", due to the
argument parsing ToCToU.

> -static void seccomp_do_user_notification(int this_syscall,
> +static bool seccomp_do_user_notification(int this_syscall,

I'd prefer this stay an "int", just to keep it similar to the other
functions that are checked in __seccomp_filter().

> +	/* perform syscall */

nit: expand this commit to something like "Userspace requests we
continue and perform syscall".

> +	if (flags & SECCOMP_RET_USER_NOTIF_ALLOW)
> +		return false;

return 0;

> +
>  	syscall_set_return_value(current, task_pt_regs(current),
>  				 err, ret);
> +	return true;

return -1;

(This makes it look more like a "skip on failure")

> +	if (resp.flags & ~SECCOMP_RET_USER_NOTIF_ALLOW)
> +		return -EINVAL;
> +
> +	if ((resp.flags & SECCOMP_RET_USER_NOTIF_ALLOW) &&
> +	    (resp.error || resp.val))
>  		return -EINVAL;

Ah yeah, good idea.

Beyond these nits, yes, looks good and should help the usability of this
feature. Thanks for getting it written and tested!

-- 
Kees Cook
