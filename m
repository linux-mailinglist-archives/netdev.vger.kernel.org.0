Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE1EC198831
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 01:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgC3XYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 19:24:55 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45617 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728876AbgC3XYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 19:24:55 -0400
Received: by mail-oi1-f193.google.com with SMTP id l22so17280884oii.12
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 16:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AfGz/WUWOWJUNUddn1vR6gY4zq6NlynuXX3ZTIKVOpE=;
        b=tN2J9Su/GB8ddEV/gYJVXqNO1Vgq8NJKzoZWKDLLNwAWy0rE3zZbMh3zKYHY890bPi
         DbKxn1Q4xfUWsp8UCDKWu3XO2Gr5QgDzLII+xda9jHG0+W44eUwBy/GDuWceCwuSncJi
         IuGMqrTTWjwaGjasQnODpwUDswmcNIRhPcZt3LotOfe2DkMHBkVtAWuJFmYdYxcYcqvP
         68oNdgIdvVYmb5HYDxDGAYSs8EzGLV2mggfikVGBqeP+1g2zef71idtpAGtl0Nm4msku
         aOEBUisZYDkWQcFkWikryC7eD+fkuINa9qsV/+VsSwRANpIJ5BHt1mtzFknXkVp1phrw
         9ycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AfGz/WUWOWJUNUddn1vR6gY4zq6NlynuXX3ZTIKVOpE=;
        b=RRGD3dsTSSZNn/3vtEeTG3ptG4sYAQa86PhtO9s79zQ9W99BI8jnqbWJ3+kAl0oCLA
         PTFKaHzQmaB9PNlyghQPGXNt8D5EeQloCBSX9Ds5S3eBrxLfR+7+O6FAKaKO0SxXT7Wx
         ReP19ikTezDw7YUmWM9kTQzapRJv0zaVrhB/oJU2eUGczwrN9SKYA+AGY0tOa/njbbuX
         vERqiY8bmb1B+6fGFZs+k7k00NL04UyzUiUDXDe2kPx+kLEsqc+78e9yetOFiAmbdsdp
         XV1r6y782JmjhVoFvnkLj+ZtPyqbJEaGrr5ouhQYf79JaBPyg20rNsxFZBCvSNDgvtMc
         w3pg==
X-Gm-Message-State: ANhLgQ3NRBeO33nIpT0zOEbDxZlGbmHr0axoFq7ue5So92qk9MaGVL2v
        +CN92gS/oLAr+mA9ua24kLtrt4BWvgTUmmCRohc=
X-Google-Smtp-Source: ADFU+vsa2dyd9gvKAERxfd0Gla0wVdKZmQDBGtp3KJH44U4XZBWvAsr8W09nfceI425mS6CMdI4AjivBT5+RhfA1Isg=
X-Received: by 2002:a05:6808:648:: with SMTP id z8mr366001oih.72.1585610694006;
 Mon, 30 Mar 2020 16:24:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200328191259.17145-1-xiyou.wangcong@gmail.com> <20200330213514.GT19865@paulmck-ThinkPad-P72>
In-Reply-To: <20200330213514.GT19865@paulmck-ThinkPad-P72>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 30 Mar 2020 16:24:42 -0700
Message-ID: <CAM_iQpUu6524ZyZDBu=nkuhpubyGBTHEJ-HK8qrpCW=EEKGujw@mail.gmail.com>
Subject: Re: [Patch net] net_sched: add a temporary refcnt for struct tcindex_data
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 2:35 PM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Sat, Mar 28, 2020 at 12:12:59PM -0700, Cong Wang wrote:
> > Although we intentionally use an ordered workqueue for all tc
> > filter works, the ordering is not guaranteed by RCU work,
> > given that tcf_queue_work() is esstenially a call_rcu().
> >
> > This problem is demostrated by Thomas:
> >
> >   CPU 0:
> >     tcf_queue_work()
> >       tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
> >
> >   -> Migration to CPU 1
> >
> >   CPU 1:
> >      tcf_queue_work(&p->rwork, tcindex_destroy_work);
> >
> > so the 2nd work could be queued before the 1st one, which leads
> > to a free-after-free.
> >
> > Enforcing this order in RCU work is hard as it requires to change
> > RCU code too. Fortunately we can workaround this problem in tcindex
> > filter by taking a temporary refcnt, we only refcnt it right before
> > we begin to destroy it. This simplifies the code a lot as a full
> > refcnt requires much more changes in tcindex_set_parms().
> >
> > Reported-by: syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com
> > Fixes: 3d210534cc93 ("net_sched: fix a race condition in tcindex_destroy()")
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> > Cc: Jiri Pirko <jiri@resnulli.us>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
>
> Looks plausible, but what did you do to verify that the structures
> were in fact being freed?  See below for more detail.

I ran the syzbot reproducer for about 20 minutes, there was no
memory leak reported after scanning.

Thanks.
