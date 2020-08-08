Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A7E23F6C9
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 09:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgHHHR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 03:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgHHHR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 03:17:58 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E74C061A28
        for <netdev@vger.kernel.org>; Sat,  8 Aug 2020 00:17:57 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id l60so2087245pjb.3
        for <netdev@vger.kernel.org>; Sat, 08 Aug 2020 00:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eCir4Ayk72PEJKd/j3pe7BJGzgEnAkyDXiuG2Izic9E=;
        b=J7Jeyp1bV8d1URPGbqvopRR/3Xv35lGlgk3bx/aVLux30Z0Cmt4M/ru2/CBSKrc2Yn
         LEJbOfinClv/JPRyH+MHFh9ugxQs5r4SbmaNlbh5n8VMkUwpagi9FtI+PHeqB3dPKLZF
         bpEda01yNbqZ47Ba6PWHX3rxvgyf6J7BQX6EQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eCir4Ayk72PEJKd/j3pe7BJGzgEnAkyDXiuG2Izic9E=;
        b=jXUIBFz70M/3HPCKl/bRFBDUlREHV4x35FYxE8UiDFo54cpyOyNQ18RBvVo8pQv0x+
         PpmY66x28LLNcxNdrDOE0Uaoor20xvn3l8w9u/1czKRmqrhfFiUVI/M+R5PoOzO+AoE6
         CAhK4vwTMTGvA9QExnV5SGLptlJQj07AmiYGzDGcVd32wWoC4qbt4IQxQ6ykjtF4tN1U
         uUDc5GA3G1lFgNXOAn2b8AJtNlPg4DrbtVTZvirVejRebN7m/y8cuPX1FxnooB51rytz
         unex9rDVfkT63SW+2jo7fS+nI/TJ46r+hQvykbtetON0C24cZACZ30yK+NiVzZesWQNv
         fAEQ==
X-Gm-Message-State: AOAM531G2vBxKYZvU+sWysPXNmmzqz2IRITedlP67Q9PE9IjE+/QzGr5
        +vALQDwJZ2q5OMG8U1rEeWcnjg==
X-Google-Smtp-Source: ABdhPJx+ciLdH6ySwDMsUNQtApGD+XkDqifS0PpDf22ilxzYv3YOdIibv7N9AvGktGE1tc4I58GOOA==
X-Received: by 2002:a17:90a:bc41:: with SMTP id t1mr16615267pjv.181.1596871077273;
        Sat, 08 Aug 2020 00:17:57 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j142sm16303934pfd.100.2020.08.08.00.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2020 00:17:56 -0700 (PDT)
Date:   Sat, 8 Aug 2020 00:17:55 -0700
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
        containers@lists.linux-foundation.org,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Amit Pundir <amit.pundir@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH v7 3/9] net/scm: Regularize compat handling of
 scm_detach_fds()
Message-ID: <202008080017.1298B0C@keescook>
References: <20200709182642.1773477-1-keescook@chromium.org>
 <20200709182642.1773477-4-keescook@chromium.org>
 <CANcMJZAcDAG7Dq7vo=M-SZwujj+BOKMh7wKvywHq+tEX3GDbBQ@mail.gmail.com>
 <202008071516.83432C389@keescook>
 <CALAqxLXqjEN0S+eGeFA_obaunBK_+xqKbQtdQj1w+wegz-6U5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLXqjEN0S+eGeFA_obaunBK_+xqKbQtdQj1w+wegz-6U5w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 07, 2020 at 05:02:15PM -0700, John Stultz wrote:
> On Fri, Aug 7, 2020 at 3:18 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Fri, Aug 07, 2020 at 01:29:24PM -0700, John Stultz wrote:
> > > On Thu, Jul 9, 2020 at 11:28 AM Kees Cook <keescook@chromium.org> wrote:
> > > >
> > > > Duplicate the cleanups from commit 2618d530dd8b ("net/scm: cleanup
> > > > scm_detach_fds") into the compat code.
> > > >
> > > > Replace open-coded __receive_sock() with a call to the helper.
> > > >
> > > > Move the check added in commit 1f466e1f15cf ("net: cleanly handle kernel
> > > > vs user buffers for ->msg_control") to before the compat call, even
> > > > though it should be impossible for an in-kernel call to also be compat.
> > > >
> > > > Correct the int "flags" argument to unsigned int to match fd_install()
> > > > and similar APIs.
> > > >
> > > > Regularize any remaining differences, including a whitespace issue,
> > > > a checkpatch warning, and add the check from commit 6900317f5eff ("net,
> > > > scm: fix PaX detected msg_controllen overflow in scm_detach_fds") which
> > > > fixed an overflow unique to 64-bit. To avoid confusion when comparing
> > > > the compat handler to the native handler, just include the same check
> > > > in the compat handler.
> > > >
> > > > Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > > ---
> > >
> > > Hey Kees,
> > >   So during the merge window (while chasing a few other regressions),
> > > I noticed occasionally my Dragonboard 845c running AOSP having trouble
> > > with the web browser crashing or other apps hanging, and I've bisected
> > > the issue down to this change.
> > >
> > > Unfortunately it doesn't revert cleanly so I can't validate reverting
> > > it sorts things against linus/HEAD.  Anyway, I wanted to check and see
> > > if you had any other reports of similar or any ideas what might be
> > > going wrong?
> >
> > Hi; Yes, sorry for the trouble. I had a typo in a refactor of
> > SCM_RIGHTS. I suspect it'll be fixed by this:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1fa2c0a0c814fbae0eb3e79a510765225570d043
> >
> > Can you verify Linus's latest tree works for you? If not, there might be
> > something else hiding in the corners...
> 
> Thanks so much! Yes, I just updated to Linus' latest and the issue has
> disappeared!
> 
> thanks again!

Whew; sorry again and thanks for testing! :)

-- 
Kees Cook
