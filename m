Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD6423F3C8
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 22:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgHGU3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 16:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHGU3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 16:29:36 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD37DC061756;
        Fri,  7 Aug 2020 13:29:36 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id z17so2834611ill.6;
        Fri, 07 Aug 2020 13:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uq3Rm3BodEbHoD3xpm4HpbWX1fCXnHobKwQS9eSoca4=;
        b=BM8RHOdk46N+DeGLK9WTKkMYUkIB4fexT7uOlF79JjFH11zN1g/IDmLcSQCtkuwngn
         r46/DeVJjrv9lKfKrdHHQuVScjeQiOaKJSwY9wjuNTdWsvRjDUnl/HHzqs9EO/081Miq
         wdI2AiaNkAx1NGAuG5qdMcXHvZpdqekA0Kev49MF9WOrn83XpMBgp7ehIKkOjE7e46lU
         0z4BAQ/F1aXYZRnjf9q0LZ3RtANjeAyQlZf/9+8HxqhjShyGSfgA08uIf/J6h/3t12Z7
         CFEZMpvZW0kN1Vv59hHqIaQOdsKTVw9clSzgmhVFD88DVHzDLqks3CY76+d/yK4x4VWx
         It1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uq3Rm3BodEbHoD3xpm4HpbWX1fCXnHobKwQS9eSoca4=;
        b=bMAg/EcUny46Z97LH0cHSqCgGJmNXfSrV2vcBSCRl+TMFvyfKxrKH4ifVabVszmNDu
         HBoHINHjapbQ0hwukZwJ0AWAQoPmD+GDv1bMG0TPk2ciKJd/eLC/i6FRx5Li+X/Gtfcz
         4nl6iqoAI/P0xRR1qmdQzzq36QyvT8lkKlkHJaKlEgG69SnzzEdPymfFICVFmxRZHi+f
         KC55Hx9pt63Qh1sUNsIIYomMlITeiNEvLp8WM5G3WQBxfuaIlm06ky1YWpcWGnJD61UQ
         LkUmLw4F2KUqNj9kIQBaGjToSt1DAis9P3FtAH1kM/x6NUE1gfsZ0zldGATrn5O6/heC
         wnEg==
X-Gm-Message-State: AOAM531qq0Qd2m/95YfFoor9JwYgELQZPX46AGeXviqu2IZDDBgwxXn6
        ROPhsftgCf9R+0eBnjq+soJuReE0vm6/HwCfK10=
X-Google-Smtp-Source: ABdhPJwC9P+sOC25h3PoOSP50YpPCTyAOEUT0secwM5VyYf3NZXaBzxAMi6eRm+95YX8Kh14rxVqTZmqDD/zYQktLX0=
X-Received: by 2002:a92:5e9c:: with SMTP id f28mr6357090ilg.302.1596832176074;
 Fri, 07 Aug 2020 13:29:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200709182642.1773477-1-keescook@chromium.org> <20200709182642.1773477-4-keescook@chromium.org>
In-Reply-To: <20200709182642.1773477-4-keescook@chromium.org>
From:   John Stultz <john.stultz@linaro.org>
Date:   Fri, 7 Aug 2020 13:29:24 -0700
Message-ID: <CANcMJZAcDAG7Dq7vo=M-SZwujj+BOKMh7wKvywHq+tEX3GDbBQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/9] net/scm: Regularize compat handling of scm_detach_fds()
To:     Kees Cook <keescook@chromium.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@aculab.com>,
        Christoph Hellwig <hch@lst.de>,
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
        netdev <netdev@vger.kernel.org>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Amit Pundir <amit.pundir@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 11:28 AM Kees Cook <keescook@chromium.org> wrote:
>
> Duplicate the cleanups from commit 2618d530dd8b ("net/scm: cleanup
> scm_detach_fds") into the compat code.
>
> Replace open-coded __receive_sock() with a call to the helper.
>
> Move the check added in commit 1f466e1f15cf ("net: cleanly handle kernel
> vs user buffers for ->msg_control") to before the compat call, even
> though it should be impossible for an in-kernel call to also be compat.
>
> Correct the int "flags" argument to unsigned int to match fd_install()
> and similar APIs.
>
> Regularize any remaining differences, including a whitespace issue,
> a checkpatch warning, and add the check from commit 6900317f5eff ("net,
> scm: fix PaX detected msg_controllen overflow in scm_detach_fds") which
> fixed an overflow unique to 64-bit. To avoid confusion when comparing
> the compat handler to the native handler, just include the same check
> in the compat handler.
>
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Hey Kees,
  So during the merge window (while chasing a few other regressions),
I noticed occasionally my Dragonboard 845c running AOSP having trouble
with the web browser crashing or other apps hanging, and I've bisected
the issue down to this change.

Unfortunately it doesn't revert cleanly so I can't validate reverting
it sorts things against linus/HEAD.  Anyway, I wanted to check and see
if you had any other reports of similar or any ideas what might be
going wrong?

thanks
-john
