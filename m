Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728CE325B36
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 02:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhBZBTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 20:19:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhBZBTj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 20:19:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3967564F1A;
        Fri, 26 Feb 2021 01:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614302338;
        bh=fnDS0CnXuapisNlVwDzZuiObaMNOWGSunBlLSem9k64=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ef8i8zprdJTQeyXTQaBErGQvt5Je87BoW6/VJ+OIWHXUbVVdRShGHQnjFzZIGgXbF
         05DyQNwtRAptoaqsK0h/f46Ktye82OgDxgZ3zq5bx7OhkDVkk4NQLV8QLZWkyBiux0
         bq3TQJmVP4THoMQ/KiN0bRTsPmVMVU0/xoKl5kX9+0OiHY09DC4C949SUhLgnQun10
         Vfgzv/lznuIv9RPRyf9wwQGvkPdcj1UVEEEZv2XJP/pQQ8ew+6g3gSq2gGHISokN+R
         DmdgrIRo/Ua09WcpHfDbQmlz/vO3Fq+2xfBfwmMXEuwZpRnPvjWa0pqDex9bgEcdEr
         3/m5ENRi4d52g==
Date:   Thu, 25 Feb 2021 17:18:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy
 poll
Message-ID: <20210225171857.798e6c81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_DnoQ8OLm731burXB58d9PfSPNU7_MvbeX_Ly1Grk2XbA@mail.gmail.com>
References: <20210223234130.437831-1-weiwan@google.com>
        <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
        <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
        <20210224162059.7949b4e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR15MB27873FF52B109480173366B8BD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
        <20210224180329.306b2207@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_CEz-CaK_rCyGzRA8=WNspu2Uia5UasJ266f=p5uiqYkw@mail.gmail.com>
        <20210225002115.5f6215d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_DdccvmymRWEtggHgqb9dQ6NjK8rsrA03HH+r7mzt=5uw@mail.gmail.com>
        <20210225150048.23ed87c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_DnoQ8OLm731burXB58d9PfSPNU7_MvbeX_Ly1Grk2XbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Feb 2021 16:16:20 -0800 Wei Wang wrote:
> On Thu, Feb 25, 2021 at 3:00 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 25 Feb 2021 10:29:47 -0800 Wei Wang wrote:  
> > > Hmm... I don't think the above patch would work. Consider a situation that:
> > > 1. At first, the kthread is in sleep mode.
> > > 2. Then someone calls napi_schedule() to schedule work on this napi.
> > > So ____napi_schedule() is called. But at this moment, the kthread is
> > > not yet in RUNNING state. So this function does not set SCHED_THREAD
> > > bit.
> > > 3. Then wake_up_process() is called to wake up the thread.
> > > 4. Then napi_threaded_poll() calls napi_thread_wait().  
> >
> > But how is the task not in running state outside of napi_thread_wait()?
> >
> > My scheduler knowledge is rudimentary, but AFAIU off CPU tasks which
> > were not put to sleep are still in RUNNING state, so unless we set
> > INTERRUPTIBLE the task will be running, even if it's stuck in cond_resched().
>
> I think the thread is only in RUNNING state after wake_up_process() is
> called on the thread in ____napi_schedule(). Before that, it should be
> in INTERRUPTIBLE state. napi_thread_wait() explicitly calls
> set_current_state(TASK_INTERRUPTIBLE) when it finishes 1 round of
> polling.

Are you concerned about it not being in RUNNING state after it's
spawned but before it's first parked?

> > > woken is false
> > > and SCHED_THREAD bit is not set. So the kthread will go to sleep again
> > > (in INTERRUPTIBLE mode) when schedule() is called, and waits to be
> > > woken up by the next napi_schedule().
> > > That will introduce arbitrary delay for the napi->poll() to be called.
> > > Isn't it? Please enlighten me if I did not understand it correctly.  
> >
> > Probably just me not understanding the scheduler :)
> >  
> > > I personally prefer to directly set SCHED_THREAD bit in ____napi_schedule().
> > > Or stick with SCHED_BUSY_POLL solution and replace kthread_run() with
> > > kthread_create().  
> >
> > Well, I'm fine with that too, no point arguing further if I'm not
> > convincing anyone. But we need a fix which fixes the issue completely,
> > not just one of three incarnations.  
> 
> Alexander and Eric,
> Do you guys have preference on which approach to take?
> If we keep the current SCHED_BUSY_POLL patch, I think we need to
> change kthread_run() to kthread_create() to address the warning Martin
> reported.
> Or if we choose to set SCHED_THREADED, we could keep kthread_run().
> But there is 1 extra set_bit() operation.

To be clear extra set_bit() only if thread is running, which if IRQ
coalescing works should be rather rare.
