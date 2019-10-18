Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3907DC7D4
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 16:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634233AbfJROx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 10:53:27 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:46235 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732002AbfJROx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 10:53:26 -0400
Received: by mail-oi1-f194.google.com with SMTP id k25so5404862oiw.13
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 07:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zvCPb+I01tLtDHLzHrOjl0EhtTbTVyTc15YBlVhsjow=;
        b=kZJl6rDoYcgTjP5w3M5A2iATfBN/C/OHAfoM3SiPWZXHFF9DEFV6Q2PD1HvssE8LpZ
         DQkJ2f5OZFY+dxqQgt7htFLakvW3pHtgNP+OAEs3WtusHvGkdFkW4mOohxn/3icNTSjl
         TxSkbAyn6oGCwe24VwduhyDOcV85V3An6U7kesEKPquUPiNKsofrdkPvDDcsQZAA3pWr
         /uGLR+bJ4ge1fjYEWeaxRgg6GGHJV8GSxrdV9icY/v7JgwnXhXyiULEiNcGNsba1Rp6p
         I5/XikN1GEh/NqyiBfmzPpV53bMAnVrdc+cqWeUuilLM5gj5apdsuZiJpmb+ROigEwpR
         YslA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zvCPb+I01tLtDHLzHrOjl0EhtTbTVyTc15YBlVhsjow=;
        b=faNo0gi2cVAbbJyjphYD37W5Ct7o7paImojywj2favYaJRdmihr2QnaExBOIZhfbsl
         RxOQp7aHJx6l6olr4r8cNSjE3DFP7/G0FSfZKVLJlyB9Fe7mXneBCexF29nK5vxPFl0C
         Re+iusCF/8jKp6oPL+abP+LsJn58kLkYM7BOBjjMVCuzliAmBvBcNvSDjaSze48u6MJ1
         qiW4On1fN4GTGyK1yh6cgfOIJA0rrzixx7FBltXfTJF22ysiTUY7dhZvIHLsrvi2b5US
         wPXWfDopuOCYU5RGB2AKQsf0Fk+tk5xso9Wu3j7eyaVTRW6nHGa+D47psofuHJzIeW/h
         Tckg==
X-Gm-Message-State: APjAAAW+QaCZ4htR4tk8xQT5uG63XOWEtr0DTNuDKeCMUoSPVGSM5A3w
        kiiqVEsoF/6oOwhSHK69uhzigl9hH3207YB4HVc0eg==
X-Google-Smtp-Source: APXvYqy3yngFNfe4hHqnnB0BhxUiwfIxhHgwscyWwkSuoSZgev9YJCMY9KGFKJHtTRy6ZXYnt0Vbjt0vUbIDIexYAJY=
X-Received: by 2002:aca:5c06:: with SMTP id q6mr8519219oib.175.1571410404041;
 Fri, 18 Oct 2019 07:53:24 -0700 (PDT)
MIME-Version: 1.0
References: <20191017212858.13230-1-axboe@kernel.dk> <20191017212858.13230-2-axboe@kernel.dk>
 <CAG48ez0G2y0JS9=S2KmePO3xq-5DuzgovrLFiX4TJL-G897LCA@mail.gmail.com>
 <0fb9d9a0-6251-c4bd-71b0-6e34c6a1aab8@kernel.dk> <CAG48ez181=JoYudXee0KbU0vDZ=EbxmgB7q0mmjaA0gyp6MFBQ@mail.gmail.com>
 <a54329d5-a128-3ccd-7a12-f6cadaa20dbf@kernel.dk> <CAG48ez1SDQNHjgFku4ft4qw9hdv1g6-sf7-dxuU_tJSx+ofV-w@mail.gmail.com>
 <dbcf874d-8484-9c27-157a-c2752181acb5@kernel.dk>
In-Reply-To: <dbcf874d-8484-9c27-157a-c2752181acb5@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 18 Oct 2019 16:52:58 +0200
Message-ID: <CAG48ez3KwaQ3DVH1VoWxFWTG2ZfCQ6M0oyv5vZqkLgY0QDEdiw@mail.gmail.com>
Subject: Re: [PATCH 1/3] io_uring: add support for async work inheriting files table
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 4:43 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 10/18/19 8:40 AM, Jann Horn wrote:
> > On Fri, Oct 18, 2019 at 4:37 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 10/18/19 8:34 AM, Jann Horn wrote:
> >>> On Fri, Oct 18, 2019 at 4:01 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>> On 10/17/19 8:41 PM, Jann Horn wrote:
> >>>>> On Fri, Oct 18, 2019 at 4:01 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>> This is in preparation for adding opcodes that need to modify files
> >>>>>> in a process file table, either adding new ones or closing old ones.
> >>> [...]
> >>>> Updated patch1:
> >>>>
> >>>> http://git.kernel.dk/cgit/linux-block/commit/?h=for-5.5/io_uring-test&id=df6caac708dae8ee9a74c9016e479b02ad78d436
> >>>
> >>> I don't understand what you're doing with old_files in there. In the
> >>> "s->files && !old_files" branch, "current->files = s->files" happens
> >>> without holding task_lock(), but current->files and s->files are also
> >>> the same already at that point anyway. And what's the intent behind
> >>> assigning stuff to old_files inside the loop? Isn't that going to
> >>> cause the workqueue to keep a modified current->files beyond the
> >>> runtime of the work?
> >>
> >> I simply forgot to remove the old block, it should only have this one:
> >>
> >> if (s->files && s->files != cur_files) {
> >>          task_lock(current);
> >>          current->files = s->files;
> >>          task_unlock(current);
> >>          if (cur_files)
> >>                  put_files_struct(cur_files);
> >>          cur_files = s->files;
> >> }
> >
> > Don't you still need a put_files_struct() in the case where "s->files
> > == cur_files"?
>
> I want to hold on to the files for as long as I can, to avoid unnecessary
> shuffling of it. But I take it your worry here is that we'll be calling
> something that manipulates ->files? Nothing should do that, unless
> s->files is set. We didn't hide the workqueue ->files[] before this
> change either.

No, my worry is that the refcount of the files_struct is left too
high. From what I can tell, the "do" loop in io_sq_wq_submit_work()
iterates over multiple instances of struct sqe_submit. If there are
two sqe_submit instances with the same ->files (each holding a
reference from the get_files_struct() in __io_queue_sqe()), then:

When processing the first sqe_submit instance, current->files and
cur_files are set to $user_files.
When processing the second sqe_submit instance, nothing happens
(s->files == cur_files).
After the loop, at the end of the function, put_files_struct() is
called once on $user_files.

So get_files_struct() has been called twice, but put_files_struct()
has only been called once. That leaves the refcount too high, and by
repeating this, an attacker can make the refcount wrap around and then
cause a use-after-free.
