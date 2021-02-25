Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5192D325A05
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 00:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbhBYXBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 18:01:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:43140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhBYXBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 18:01:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AAB964DFF;
        Thu, 25 Feb 2021 23:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614294049;
        bh=mk4DiEsR8Th8rb/vY+JjWOH6kWDwS+qN1qotOpAcomQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aFD8TTtJNzpcvYUqD27eEinout0L11CCUXK34a3XrzfYmWl2EujkFi1sWkZMDt7RV
         Q0wkwWKmwzl1cy8C8AurIrPWTcbufbXFC/F4LFM32x/imyfD6baSts+CXjCyBFchJ7
         qN3wvvjIUdLvFFS1HP7xs9wavx6HWMgtVFMzJjZ09N1dDeEeoCfpZoA2asOrUgmAST
         HsMEDie5sxkw2hbLsn3VzGKzShkHBZc906L03TnzmG70SK0xsUBvVavLe8j8NTIXW+
         WYaSTcNcRpJ/kQt6hM1C7m9x8jkvJWLyZuP4jaZYgJT4bMd3AlJ30c7PJF1nAYVmea
         7+ahLdrFUPXHA==
Date:   Thu, 25 Feb 2021 15:00:48 -0800
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
Message-ID: <20210225150048.23ed87c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_DdccvmymRWEtggHgqb9dQ6NjK8rsrA03HH+r7mzt=5uw@mail.gmail.com>
References: <20210223234130.437831-1-weiwan@google.com>
        <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Feb 2021 10:29:47 -0800 Wei Wang wrote:
> Hmm... I don't think the above patch would work. Consider a situation that:
> 1. At first, the kthread is in sleep mode.
> 2. Then someone calls napi_schedule() to schedule work on this napi.
> So ____napi_schedule() is called. But at this moment, the kthread is
> not yet in RUNNING state. So this function does not set SCHED_THREAD
> bit.
> 3. Then wake_up_process() is called to wake up the thread.
> 4. Then napi_threaded_poll() calls napi_thread_wait().

But how is the task not in running state outside of napi_thread_wait()?

My scheduler knowledge is rudimentary, but AFAIU off CPU tasks which
were not put to sleep are still in RUNNING state, so unless we set
INTERRUPTIBLE the task will be running, even if it's stuck in cond_resched().

> woken is false
> and SCHED_THREAD bit is not set. So the kthread will go to sleep again
> (in INTERRUPTIBLE mode) when schedule() is called, and waits to be
> woken up by the next napi_schedule().
> That will introduce arbitrary delay for the napi->poll() to be called.
> Isn't it? Please enlighten me if I did not understand it correctly.

Probably just me not understanding the scheduler :)

> I personally prefer to directly set SCHED_THREAD bit in ____napi_schedule().
> Or stick with SCHED_BUSY_POLL solution and replace kthread_run() with
> kthread_create().

Well, I'm fine with that too, no point arguing further if I'm not
convincing anyone. But we need a fix which fixes the issue completely,
not just one of three incarnations.
