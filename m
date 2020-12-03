Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79FA2CCBD0
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 02:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgLCBrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 20:47:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:42152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727026AbgLCBrp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 20:47:45 -0500
Date:   Wed, 2 Dec 2020 17:47:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606960024;
        bh=m609XWdYmpL7tXHyb0sLkMkj7EbmIxVvwW5LHg1YXsQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=YUWyBnkI7NNF9w7Emt1JNRBVSPrkuX2Fbg/g33+e8YB4YBU61N5mH3GXJMGE3rlu/
         mov2PrSTIbYhg8B9il9qa7w9HqgE6FD2YboYccjyaB9SL/3gROh7xCQfoGadd2gTGy
         dDB7AWmO/kr4ZbAympRJrZFlzWkzpQUAaa8UhAAo7cf74Q2kMNKqIPJgCEOeU1blXA
         azvBt6fOKzlJcGHvUu9kCf80vPzLVPQVC5T4OsZ5mALkVS4MCi+o2y4WqGiCNVaNpj
         BwajiFS5ik/kBM+ywjtqdp3Fip56tqU+ehp5lk15kOWSr3d1ywbDNqTA8S2P3ZKo7P
         hqye0TyR0M/hg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Dongdong Wang <wangdongdong@bytedance.com>,
        Thomas Graf <tgraf@suug.ch>, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>
Subject: Re: [Patch net] lwt: disable BH too in run_lwt_bpf()
Message-ID: <20201202174702.32c97a5e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CAM_iQpWfv59MoEJES1O=FhA4YsrB2nNGGaKzDmqcmXQXzc8gow@mail.gmail.com>
References: <20201201194438.37402-1-xiyou.wangcong@gmail.com>
        <20201202171032.029b1cd8@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <CAM_iQpWfv59MoEJES1O=FhA4YsrB2nNGGaKzDmqcmXQXzc8gow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Dec 2020 17:29:53 -0800 Cong Wang wrote:
> On Wed, Dec 2, 2020 at 5:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue,  1 Dec 2020 11:44:38 -0800 Cong Wang wrote:  
> > > From: Dongdong Wang <wangdongdong@bytedance.com>
> > >
> > > The per-cpu bpf_redirect_info is shared among all skb_do_redirect()
> > > and BPF redirect helpers. Callers on RX path are all in BH context,
> > > disabling preemption is not sufficient to prevent BH interruption.
> > >
> > > In production, we observed strange packet drops because of the race
> > > condition between LWT xmit and TC ingress, and we verified this issue
> > > is fixed after we disable BH.
> > >
> > > Although this bug was technically introduced from the beginning, that
> > > is commit 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure"),
> > > at that time call_rcu() had to be call_rcu_bh() to match the RCU context.
> > > So this patch may not work well before RCU flavor consolidation has been
> > > completed around v5.0.
> > >
> > > Update the comments above the code too, as call_rcu() is now BH friendly.
> > >
> > > Cc: Thomas Graf <tgraf@suug.ch>
> > > Cc: bpf@vger.kernel.org
> > > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > > Signed-off-by: Dongdong Wang <wangdongdong@bytedance.com>
> > > ---
> > >  net/core/lwt_bpf.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
> > > index 7d3438215f32..4f3cb7c15ddf 100644
> > > --- a/net/core/lwt_bpf.c
> > > +++ b/net/core/lwt_bpf.c
> > > @@ -39,12 +39,11 @@ static int run_lwt_bpf(struct sk_buff *skb, struct bpf_lwt_prog *lwt,
> > >  {
> > >       int ret;
> > >
> > > -     /* Preempt disable is needed to protect per-cpu redirect_info between
> > > -      * BPF prog and skb_do_redirect(). The call_rcu in bpf_prog_put() and
> > > -      * access to maps strictly require a rcu_read_lock() for protection,
> > > -      * mixing with BH RCU lock doesn't work.
> > > +     /* Preempt disable and BH disable are needed to protect per-cpu
> > > +      * redirect_info between BPF prog and skb_do_redirect().
> > >        */
> > >       preempt_disable();
> > > +     local_bh_disable();  
> >
> > Why not remove the preempt_disable()? Disabling BH must also disable
> > preemption AFAIK.  
> 
> It seems RT kernel still needs preempt disable:
> https://www.spinics.net/lists/kernel/msg3710124.html
> but my RT knowledge is not sufficient to tell. So I just follow the
> same pattern
> in x86 FPU (as of today):
> 
> static inline void fpregs_lock(void)
> {
>         preempt_disable();
>         local_bh_disable();
> }
> 
> static inline void fpregs_unlock(void)
> {
>         local_bh_enable();
>         preempt_enable();
> }
> 
> There are other similar patterns in the current code base, so if this
> needs a clean up, RT people can clean up them all together.

I see. GTK.

The patch seem good but it's probably best suited to the bpf tree, let
me reassign it in patchwork.
