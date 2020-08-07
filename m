Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A435023F4CA
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 00:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgHGWS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 18:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgHGWS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 18:18:28 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F56C061A27
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 15:18:28 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k13so1819017plk.13
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 15:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ihUSU6TqQbA0JXbd19oZy506xASqHLLOMJEBd8n0p2U=;
        b=Wn/aVUaEpIsbJFU2rZwOaBv1mXyaL5z/lsmczIB5oCGwxqrmJk4Q9cz35ynOWmkGX9
         YO3gSWKXo0dBwU4Tny4oneJye9E+joTqkH+fW2jqJqHfVhkiKRo0DJfvkxHj6keeAQ6m
         +DhiIN6tSaI5j1+Bj8tLd/vDswmMKxo/tRIXo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ihUSU6TqQbA0JXbd19oZy506xASqHLLOMJEBd8n0p2U=;
        b=ajuYiHVWqmySP7b85KO9hljjaJsk99oYQTCCrrL9mDDfSlvt1OSJ0yXaHTVjjh/VkE
         JjR00zYWZ6Eja11mEcaWIs6RLkkZZhpRGTe0ckkpS8OQsSz5moQiHrLh/wM/vh1pJ7mO
         l7i52zlZ7wjtH/7Xg5v1UPZrZAqKdWN7tRzm1AA47BRrAIxU6eY8qSz6Erx4jbErjnos
         w+qSsrhpvrYC6BPd9iarRA7y+9jzFReQ6JVEi5+JaE/41vCKmwRqhUspYpuxJstnCzie
         f4XYYUDkvsXpuS5QUhobalJPrUfnkttOXkMMgj3zO3klS23l508hiPZG5PCgE7n48dqH
         L+/Q==
X-Gm-Message-State: AOAM532DvblbkfrnuwhbKxOp7JFxIcmEyLFlhJyXSloRh2FBgD5eQV2I
        vrgFo+LlS4olzNMe6tqYcDCUcqqVSgU=
X-Google-Smtp-Source: ABdhPJw13RGqkJjIaNqKZmvnuvXy1e+fEZ64kkiFX1oChLJZSE2IdRQiu9+MQd4tH+0QJtO8sJzmFg==
X-Received: by 2002:a17:90a:d98f:: with SMTP id d15mr15634958pjv.212.1596838707622;
        Fri, 07 Aug 2020 15:18:27 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a16sm14432615pfr.45.2020.08.07.15.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 15:18:26 -0700 (PDT)
Date:   Fri, 7 Aug 2020 15:18:25 -0700
From:   Kees Cook <keescook@chromium.org>
To:     John Stultz <john.stultz@linaro.org>
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
Subject: Re: [PATCH v7 3/9] net/scm: Regularize compat handling of
 scm_detach_fds()
Message-ID: <202008071516.83432C389@keescook>
References: <20200709182642.1773477-1-keescook@chromium.org>
 <20200709182642.1773477-4-keescook@chromium.org>
 <CANcMJZAcDAG7Dq7vo=M-SZwujj+BOKMh7wKvywHq+tEX3GDbBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANcMJZAcDAG7Dq7vo=M-SZwujj+BOKMh7wKvywHq+tEX3GDbBQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 07, 2020 at 01:29:24PM -0700, John Stultz wrote:
> On Thu, Jul 9, 2020 at 11:28 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > Duplicate the cleanups from commit 2618d530dd8b ("net/scm: cleanup
> > scm_detach_fds") into the compat code.
> >
> > Replace open-coded __receive_sock() with a call to the helper.
> >
> > Move the check added in commit 1f466e1f15cf ("net: cleanly handle kernel
> > vs user buffers for ->msg_control") to before the compat call, even
> > though it should be impossible for an in-kernel call to also be compat.
> >
> > Correct the int "flags" argument to unsigned int to match fd_install()
> > and similar APIs.
> >
> > Regularize any remaining differences, including a whitespace issue,
> > a checkpatch warning, and add the check from commit 6900317f5eff ("net,
> > scm: fix PaX detected msg_controllen overflow in scm_detach_fds") which
> > fixed an overflow unique to 64-bit. To avoid confusion when comparing
> > the compat handler to the native handler, just include the same check
> > in the compat handler.
> >
> > Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> 
> Hey Kees,
>   So during the merge window (while chasing a few other regressions),
> I noticed occasionally my Dragonboard 845c running AOSP having trouble
> with the web browser crashing or other apps hanging, and I've bisected
> the issue down to this change.
> 
> Unfortunately it doesn't revert cleanly so I can't validate reverting
> it sorts things against linus/HEAD.  Anyway, I wanted to check and see
> if you had any other reports of similar or any ideas what might be
> going wrong?

Hi; Yes, sorry for the trouble. I had a typo in a refactor of
SCM_RIGHTS. I suspect it'll be fixed by this:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1fa2c0a0c814fbae0eb3e79a510765225570d043

Can you verify Linus's latest tree works for you? If not, there might be
something else hiding in the corners...

Thanks!

-- 
Kees Cook
