Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB25E24F5F5
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 10:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbgHXIzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 04:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730164AbgHXIzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 04:55:41 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEF2C061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 01:55:41 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id i20so6707016qkk.8
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 01:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4+DPdTdqNuyBoVS4RbQIr9UMaA1D5lYrJkHWf4GkHBQ=;
        b=MH1x+F6HuXwDNwXoyQJcunv0GP2bLigkIo02yDGCp7PNi8rBk8ujHLvQ40AyCg0Ish
         bVOgBrCJBjKQDAsN2axhHWiMVDLlNaLSa4jVdTFGsyD1bxAY7bAUKWfGLCh66oKH7HXm
         r5S1vNkuLKXbrXt+Kkx8kg+ZOzUiA+qTnK9115FlM3dbVxZ8wwd8Ws+FCr/iWe8iYcmQ
         fioom413+yIGdKEYzOfAOqEv5jVs4G9hm7XluPo+/08F33geafgjLLW0u30RPSJoxMNR
         JkPRvuciD+M1L7XY/rePVkakQNglMsQgKBXPRfN203c5Q8bcg3/dsDr8ij0k3buKaSDp
         uaww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4+DPdTdqNuyBoVS4RbQIr9UMaA1D5lYrJkHWf4GkHBQ=;
        b=ZwM5TtfaLj4fnzRfi6WwrAKXYRFJjhRjV9Xj7VRxmigLP/a73FqXisLtowbqeVHsLR
         pkwPi6FhZeCWeODWB283B3ISpEgnWfiRHkxvUzN9t48jdMH1lgYxiocbXV6pTYlfdQF7
         QrRd2RkIimlMtzPuzJ84EqbCHUR1hYm99/MhcIZlKlol0iWZ0GBstGqQgtjimNi9ogLc
         5vV/45ydRTzG7gdM0Zwy+b6MZvac9tNQhRzkeq6CNjtMYJvS1vGsUVposK43FXwb0E77
         kALMvH2xYsoDZj7HFmCDBNPy2JQWJ/L9zcn7we+p1FdKUztUwnxGPbVaMLNxMuLPJWH0
         zd2Q==
X-Gm-Message-State: AOAM532QTeeOOGoLM89dnN4ohvYVO1aBnvAVMhgFmTf6gRoRvNIEh+mn
        ttS70H6y5AFyp2pVqDn8uEoQNpoRpGaeX8VcsqG8Eg==
X-Google-Smtp-Source: ABdhPJweKUqUpQomWynHHhtNTqvLsvrsIrDv2Gk4h+l3xzPB0RswtWfNznQ1EDCUE/qCzmGdN7Zdxc63Y4doRjkGvHY=
X-Received: by 2002:a05:620a:134b:: with SMTP id c11mr1857358qkl.256.1598259339701;
 Mon, 24 Aug 2020 01:55:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200823082042.20816-1-himadrispandya@gmail.com>
 <CACT4Y+Y1TpqYowNXj+OTcQwH-7T4n6PtPPa4gDWkV-np5KhKAQ@mail.gmail.com>
 <20200823101924.GA3078429@kroah.com> <CACT4Y+YbDODLRFn8M5QcY4CazhpeCaunJnP_udXtAs0rYoASSg@mail.gmail.com>
 <20200823105808.GB87391@kroah.com>
In-Reply-To: <20200823105808.GB87391@kroah.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 24 Aug 2020 10:55:28 +0200
Message-ID: <CACT4Y+ZiZQK8WBre9E4777NPaRK4UDOeZOeMZOQC=5tDsDu23A@mail.gmail.com>
Subject: Re: [PATCH] net: usb: Fix uninit-was-stored issue in asix_read_cmd()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Himadri Pandya <himadrispandya@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 23, 2020 at 12:57 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sun, Aug 23, 2020 at 12:31:03PM +0200, Dmitry Vyukov wrote:
> > On Sun, Aug 23, 2020 at 12:19 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Sun, Aug 23, 2020 at 11:26:27AM +0200, Dmitry Vyukov wrote:
> > > > On Sun, Aug 23, 2020 at 10:21 AM Himadri Pandya
> > > > <himadrispandya@gmail.com> wrote:
> > > > >
> > > > > Initialize the buffer before passing it to usb_read_cmd() function(s) to
> > > > > fix the uninit-was-stored issue in asix_read_cmd().
> > > > >
> > > > > Fixes: KMSAN: kernel-infoleak in raw_ioctl
> > > > > Reported by: syzbot+a7e220df5a81d1ab400e@syzkaller.appspotmail.com
> > > > >
> > > > > Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
> > > > > ---
> > > > >  drivers/net/usb/asix_common.c | 2 ++
> > > > >  1 file changed, 2 insertions(+)
> > > > >
> > > > > diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> > > > > index e39f41efda3e..a67ea1971b78 100644
> > > > > --- a/drivers/net/usb/asix_common.c
> > > > > +++ b/drivers/net/usb/asix_common.c
> > > > > @@ -17,6 +17,8 @@ int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> > > > >
> > > > >         BUG_ON(!dev);
> > > > >
> > > > > +       memset(data, 0, size);
> > > >
> > > > Hi Himadri,
> > > >
> > > > I think the proper fix is to check
> > > > usbnet_read_cmd/usbnet_read_cmd_nopm return value instead.
> > > > Memsetting data helps to fix the warning at hand, but the device did
> > > > not send these 0's and we use them as if the device did send them.
> > >
> > > But, for broken/abusive devices, that really is the safest thing to do
> > > here.  They are returning something that is obviously not correct, so
> > > either all callers need to check the size received really is the size
> > > they asked for, or we just plod onward with a 0 value like this.  Or we
> > > could pick some other value, but that could cause other problems if it
> > > is treated as an actual value.
> >
> > Do we want callers to do at least some error check (e.g. device did
> > not return anything at all, broke, hang)?
> > If yes, then with a separate helper function that fails on short
> > reads, we can get both benefits at no additional cost. User code will
> > say "I want 4 bytes, anything that is not 4 bytes is an error" and
> > then 1 error check will do. In fact, it seems that that was the
> > intention of whoever wrote this code (they assumed no short reads),
> > it's just they did not actually implement that "anything that is not 4
> > bytes is an error" part.
> >
> >
> > > > Perhaps we need a separate helper function (of a bool flag) that will
> > > > fail on incomplete reads. Maybe even in the common USB layer because I
> > > > think we've seen this type of bug lots of times and I guess there are
> > > > dozens more.
> > >
> > > It's not always a failure, some devices have protocols that are "I could
> > > return up to a max X bytes but could be shorter" types of messages, so
> > > it's up to the caller to check that they got what they really asked for.
> >
> > Yes, that's why I said _separate_ helper function. There seems to be
> > lots of callers that want exactly this -- "I want 4 bytes, anything
> > else is an error". With the current API it's harder to do - you need
> > additional checks, additional code, maybe even additional variables to
> > store the required size. APIs should make correct code easy to write.
>
> I guess I already answered both of these in my previous email...
>
> > > Yes, it's more work to do this checking.  However converting the world
> > > over to a "give me an error value if you don't read X number of bytes"
> > > function would also be the same amount of work, right?
> >
> > Should this go into the common USB layer then?
> > It's weird to have such a special convention on the level of a single
> > driver. Why are rules for this single driver so special?...
>
> They aren't special at all, so yes, we should be checking for a short
> read everywhere.  That would be the "correct" thing to do, I was just
> suggesting a "quick fix" here, sorry.

Re quick fix, I guess it depends on the amount of work for the larger
fix and if we can find volunteers (thanks Himadri!). We need to be
practical as well.

Re:
        retval = usb_control_msg(....., data, data_size, ...);
        if (retval < buf_size) {

There may be a fine line between interfaces and what code they
provoke. Let me describe my reasoning.

Yes, the current interface allows writing correct code with moderate
amount of effort. Yet we see cases where it's used incorrectly, maybe
people were just a little bit lazy, or maybe they did not understand
how to use it properly (nobody reads the docs, and it's also
reasonable to assume that if you ask for N bytes and the function does
not fail, then you get N bytes).

Currently to write correct code (1) we need a bit of duplication,
which gets worse if data_size is actually some lengthy expression
(X+Y*Z), maybe one will need an additional variable to use it
correctly.
(2) one needs to understand the contract;
(3) may be subject to the following class of bugs (after some copy-paste:
        retval = usb_control_msg(....., data, 4, ...);
        if (retval < 2) {
This class of bugs won't be necessary immediately caught by kernel
testing systems (can have long life-time).

I would add a "default" function (with shorter name) that does full read:

if (!usb_control_msg(, ...., data, 4))

and a function with longer name to read variable-size data:

n = usb_control_msg_variable_length(, ...., data, sizeof(data)));

The full read should be "the default" (shorter name), because if you
need full read and use the wrong function, it won't be caught by
testing (most likely long-lived bug). Whereas if you use full read for
lengthy variable size data read, this will be immediately caught
during any testing (even manual) -- you ask for 4K, you get fewer
bytes, all your reads fail.
So having "full read" easier to spell will lead to fewer bugs by design.
