Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F86367916
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 07:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhDVFHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 01:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbhDVFHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 01:07:31 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E33C06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 22:06:57 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id y124-20020a1c32820000b029010c93864955so2457385wmy.5
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 22:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D2utWr3+IQN3QpqWssM7F+nO9xmc0OqxrHggaNQZ7us=;
        b=lIUnbdHwwuntyi+ReeYq+8aNiJWSsVh1y4WFaKGMU/DMP4XMArYxCcX/eIjT4Xm1tS
         1mkEHOos7zAIy6ovx3VwsA0+h5RlW3spLLguiJ1iMp6zu3M3Yew4aj2W4RMsV2cV04du
         6q78KIO8a/roJqUtqJxN/hKU/KruFrjacHVtkcLJh84Ps1wLK+u79uTN7NGmQlrvT37Q
         ol8lwTyA9W2ldf4zOIQ3YtOUIFLfKD1iGK4mZ0w7MR0TniiXyh45uBiO0ax3gJaH81UV
         O1LnBthOAWYKAATgLscr8fdIylaV0Lzp7O8damogWKRU1sM4tgq5Rex/eibGbMJky5at
         q1Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D2utWr3+IQN3QpqWssM7F+nO9xmc0OqxrHggaNQZ7us=;
        b=GOVycB835hc/IaQfIaUyFqysQTlpnccBsku6EXQoReF1OqUF2ID9wBfMGOGNSPa+xD
         iF5zOBJUJHJPpRSXr4rVXhJaduIW/cnWCICE2dm5RcOZwQXGCMDnGiw9OavK2VDRtbdT
         Cj9gNVoK5zSbKTaW1TSLVQ+P/CQ8QQYxbF8rypi+YG3m9qm3eqLkhkfa6shbHzIUcPK9
         38h6m5G3Eh3Fne8K8bZLQlys3Hbx7aJRYTqnz6ZgsEl6TfqwNANg1QbChhEShj7jE3Qp
         kUHgI4yb1AjeG7MYaTmTCu9ShfSw+lhoxX/eNhXnAk+lxZNPgNeL9GoJf9vXIIqfmuMB
         SZSg==
X-Gm-Message-State: AOAM530sYnuD8T7AL5PKG2vLL3GNKM/JnVZiq6KRcwV+IrkHRAHi2xtn
        usfI6DyOmf8A15kk7GCILkQjx6S1mvfeHDrubvNmHlfyUkrdXw==
X-Google-Smtp-Source: ABdhPJxuOwYxYzZ3qoWv+o1PRE91V/WBO5YHiCJW9Y0aNDDRKjJcKaucK+qKcQR5GDIcdljGVmCwAQNI0/GaQ9ZXG/c=
X-Received: by 2002:a1c:b342:: with SMTP id c63mr1678390wmf.162.1619068015922;
 Wed, 21 Apr 2021 22:06:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210420213517.24171-1-drt@linux.ibm.com> <60C99F56-617D-455B-9ACF-8CE1EED64D92@linux.vnet.ibm.com>
 <20210421064527.GA2648262@us.ibm.com>
In-Reply-To: <20210421064527.GA2648262@us.ibm.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Thu, 22 Apr 2021 00:06:45 -0500
Message-ID: <CAOhMmr4ckVFTZtSeHFHNgGPUA12xYO8WcUoakx7WdwQfSKBJhA@mail.gmail.com>
Subject: Re: [PATCH V2 net] ibmvnic: Continue with reset if set link down failed
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     Lijun Pan <ljp@linux.vnet.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tom Falcon <tlfalcon@linux.ibm.com>, netdev@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 2:25 AM Sukadev Bhattiprolu
<sukadev@linux.ibm.com> wrote:
>
> Lijun Pan [ljp@linux.vnet.ibm.com] wrote:
> >
> >
> > > On Apr 20, 2021, at 4:35 PM, Dany Madden <drt@linux.ibm.com> wrote:
> > >
> > > When ibmvnic gets a FATAL error message from the vnicserver, it marks
> > > the Command Respond Queue (CRQ) inactive and resets the adapter. If this
> > > FATAL reset fails and a transmission timeout reset follows, the CRQ is
> > > still inactive, ibmvnic's attempt to set link down will also fail. If
> > > ibmvnic abandons the reset because of this failed set link down and this
> > > is the last reset in the workqueue, then this adapter will be left in an
> > > inoperable state.
> > >
> > > Instead, make the driver ignore this link down failure and continue to
> > > free and re-register CRQ so that the adapter has an opportunity to
> > > recover.
> >
> > This v2 does not adddress the concerns mentioned in v1.
> > And I think it is better to exit with error from do_reset, and schedule a thorough
> > do_hard_reset if the the adapter is already in unstable state.
>
> We had a FATAL error and when handling it, we failed to send a
> link-down message to the VIOS. So what we need to try next is to
> reset the connection with the VIOS. For this we must talk to the
> firmware using the H_FREE_CRQ and H_REG_CRQ hcalls. do_reset()
> does just that in ibmvnic_reset_crq().
>
> Now, sure we can attempt a "thorough hard reset" which also does
> the same hcalls to reestablish the connection. Is there any
> other magic in do_hard_reset()? But in addition, it also frees lot
> more Linux kernel buffers and reallocates them for instance.

Working around everything in do_reset will make the code very difficult
to manage. Ultimately do_reset can do anything I am afraid, and do_hard_reset
can be removed completely or merged into do_reset.

>
> If we are having a communication problem with the VIOS, what is
> the point of freeing and reallocating Linux kernel buffers? Beside
> being inefficient, it would expose us to even more errors during
> reset under heavy workloads?

No real customer runs the system under that heavy load created by
HTX stress test, which can tear down any working system.

>
> From what I understand so far, do_reset() is complicated because
> it is attempting some optimizations.  If we are going to fall back
> to hard reset for every error we might as well drop the do_reset()
> and just do the "thorough hard reset" every time right?

I think such optimizations are catered for passing HTX tests. Whether
the optimization benefits the adapter, say making the adapter more stable,
I doubt it. I think there should be a trade off between optimization
and stability.
