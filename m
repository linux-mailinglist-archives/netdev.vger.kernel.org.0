Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4F6366029
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 21:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbhDTT1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 15:27:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233702AbhDTT1u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 15:27:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 076A4613E0;
        Tue, 20 Apr 2021 19:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618946837;
        bh=vbUd1HhsiYI8V3L0b0QYKz65hMBGEfOzc2WLKkl7gac=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bEaKFr1Mez65tCaYH1IIrFgT9JyFo/Pl1M4Efp9oO1TdTSE8Ds1fqd26oMD7U7ct7
         E0dxEKf3zaMKGYQNQEXHy08yuvBFx11M0FhvGHboGQ+FPfooR4EhOf5atEZu0aEh0K
         3vWRiTMuNuV9NdhubK6osKHfDRf6ajV/wrLPhVv0OV3BNrBBCg3p75FazIZSHQLxoK
         W4hXqk6qk0gjAImIQMN7favxfW4NtpzQH4Dz8aaFaKcBmVR11Gg9KXZTU+t4qf/byW
         Z2mWLkg/1yT/4elBYnLNH2Ov8uFrTu5Herj8C9bfEbO8rDm7xSjl7f2NfyzM+7jsVV
         NBtVLAfeJkJXQ==
Date:   Tue, 20 Apr 2021 12:27:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>,
        AceLan Kao <acelan.kao@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: called rtnl_unlock() before runpm resumes devices
Message-ID: <20210420122715.2066b537@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iJLSmtBNoDo8QJ6a0MzsHjdLB0Pf=cs9e4g8Y6-KuFiMQ@mail.gmail.com>
References: <20210420075406.64105-1-acelan.kao@canonical.com>
        <CANn89iJLSmtBNoDo8QJ6a0MzsHjdLB0Pf=cs9e4g8Y6-KuFiMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Apr 2021 10:34:17 +0200 Eric Dumazet wrote:
> On Tue, Apr 20, 2021 at 9:54 AM AceLan Kao <acelan.kao@canonical.com> wrote:
> >
> > From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
> >
> > The rtnl_lock() has been called in rtnetlink_rcv_msg(), and then in
> > __dev_open() it calls pm_runtime_resume() to resume devices, and in
> > some devices' resume function(igb_resum,igc_resume) they calls rtnl_lock()
> > again. That leads to a recursive lock.
> >
> > It should leave the devices' resume function to decide if they need to
> > call rtnl_lock()/rtnl_unlock(), so call rtnl_unlock() before calling
> > pm_runtime_resume() and then call rtnl_lock() after it in __dev_open().
> >
> >  
> 
> Hi Acelan
> 
> When was the bugg added ?
> Please add a Fixes: tag

For immediate cause probably:

Fixes: 9474933caf21 ("igb: close/suspend race in netif_device_detach")

> By doing so, you give more chances for reviewers to understand why the
> fix is not risky,
> and help stable teams work.

IMO the driver lacks internal locking. Taking rtnl from resume is just
one example, git history shows many more places that lacked locking and
got papered over with rtnl here.
