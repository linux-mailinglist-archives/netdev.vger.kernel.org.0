Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1081821F921
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 20:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgGNSUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 14:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729024AbgGNSUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 14:20:23 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B75C08C5C1
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 11:20:22 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f7so23855777wrw.1
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 11:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HPlGFdGBPdOOnjWNIrp7n7fX2f6c5N2cri07SgmWmTg=;
        b=JB+J/nyt6TfGmfP1FNHzDlP0adDJxkUGVFw5/aitKXAyBNMl8DYy62MiTBc8Rk1QD+
         rm4HViH+6fsIyde6WYByrD91wRfXvfHvxs/vnOJ8wI0lqj0DgxgzvyrBe4aTsR1yCrzx
         47P82a7vcihTMuj/258naogm0mSiGnyx4C/10=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HPlGFdGBPdOOnjWNIrp7n7fX2f6c5N2cri07SgmWmTg=;
        b=oI2vJHxeA/NtbqQRHdagprciugASUdRy6itEtEk+TKVaed9QcDNP4pAlRyzuHTOlg/
         d/vekH/kja5TzSITNjdrHGk6ub65frsBLfP662spJNS7Z8Bhvi25XNQ9PtBqNEkvQJcl
         h9NCK67nbzpg7EwK8J39D1cz/+UhHbe8eEhBj7u3Xpoxrqx8kXK2hPrmFEts9oNIvhA6
         PmQHvOvoKAtSwJEs2IGSGgz84xpj9JT2+Zye+HecRq2F8v8VRBReyz7w6HNWcn5jRn0a
         jbTu2eSjsHsrTcQaHlZ7qcTtdNV/iPLGTvG4+etS76pGvenfTy85vPYeIKtJas+FBZHT
         QZuA==
X-Gm-Message-State: AOAM531gnfLYJ2wUM+wpdwCEapuEiUoBwR7f0/7EuxW1g92PEDpm7dJA
        XFl0FVYnNzWyn1sHk3egmYJOZCszPZr0CvGskFkCCQ==
X-Google-Smtp-Source: ABdhPJzTRetuwJgvNgpbAVJcEpxdMAupdArwCBSPE038dmzCtxo8SQiUfeNuFojjgzmNMeBkMFoGBcaYJM2tZf4UVL4=
X-Received: by 2002:a5d:4a45:: with SMTP id v5mr7440248wrs.228.1594750821121;
 Tue, 14 Jul 2020 11:20:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200709182642.1773477-1-keescook@chromium.org> <20200709182642.1773477-9-keescook@chromium.org>
In-Reply-To: <20200709182642.1773477-9-keescook@chromium.org>
From:   Will Drewry <wad@chromium.org>
Date:   Tue, 14 Jul 2020 13:20:08 -0500
Message-ID: <CAAFS_9Gx1=ytAqTPE3ygh6euJqDObcdg70-gzUuq3eHeWHR2HQ@mail.gmail.com>
Subject: Re: [PATCH v7 8/9] seccomp: Introduce addfd ioctl to seccomp user notifier
To:     Kees Cook <keescook@chromium.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Matt Denton <mpdenton@google.com>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@aculab.com>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>, Jann Horn <jannh@google.com>,
        Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 1:26 PM Kees Cook <keescook@chromium.org> wrote:
>
> From: Sargun Dhillon <sargun@sargun.me>
>
> The current SECCOMP_RET_USER_NOTIF API allows for syscall supervision over
> an fd. It is often used in settings where a supervising task emulates
> syscalls on behalf of a supervised task in userspace, either to further
> restrict the supervisee's syscall abilities or to circumvent kernel
> enforced restrictions the supervisor deems safe to lift (e.g. actually
> performing a mount(2) for an unprivileged container).
>
> While SECCOMP_RET_USER_NOTIF allows for the interception of any syscall,
> only a certain subset of syscalls could be correctly emulated. Over the
> last few development cycles, the set of syscalls which can't be emulated
> has been reduced due to the addition of pidfd_getfd(2). With this we are
> now able to, for example, intercept syscalls that require the supervisor
> to operate on file descriptors of the supervisee such as connect(2).
>
> However, syscalls that cause new file descriptors to be installed can not
> currently be correctly emulated since there is no way for the supervisor
> to inject file descriptors into the supervisee. This patch adds a
> new addfd ioctl to remove this restriction by allowing the supervisor to
> install file descriptors into the intercepted task. By implementing this
> feature via seccomp the supervisor effectively instructs the supervisee
> to install a set of file descriptors into its own file descriptor table
> during the intercepted syscall. This way it is possible to intercept
> syscalls such as open() or accept(), and install (or replace, like
> dup2(2)) the supervisor's resulting fd into the supervisee. One
> replacement use-case would be to redirect the stdout and stderr of a
> supervisee into log file descriptors opened by the supervisor.
>
> The ioctl handling is based on the discussions[1] of how Extensible
> Arguments should interact with ioctls. Instead of building size into
> the addfd structure, make it a function of the ioctl command (which
> is how sizes are normally passed to ioctls). To support forward and
> backward compatibility, just mask out the direction and size, and match
> everything. The size (and any future direction) checks are done along
> with copy_struct_from_user() logic.
>
> As a note, the seccomp_notif_addfd structure is laid out based on 8-byte
> alignment without requiring packing as there have been packing issues
> with uapi highlighted before[2][3]. Although we could overload the
> newfd field and use -1 to indicate that it is not to be used, doing
> so requires changing the size of the fd field, and introduces struct
> packing complexity.
>
> [1]: https://lore.kernel.org/lkml/87o8w9bcaf.fsf@mid.deneb.enyo.de/
> [2]: https://lore.kernel.org/lkml/a328b91d-fd8f-4f27-b3c2-91a9c45f18c0@rasmusvillemoes.dk/
> [3]: https://lore.kernel.org/lkml/20200612104629.GA15814@ircssh-2.c.rugged-nimbus-611.internal
>
> Suggested-by: Matt Denton <mpdenton@google.com>
> Link: https://lore.kernel.org/r/20200603011044.7972-4-sargun@sargun.me
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> Co-developed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Will Drewry <wad@chromium.org>
