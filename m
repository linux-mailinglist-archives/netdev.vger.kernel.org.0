Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C443D9268
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 17:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbhG1P4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 11:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230144AbhG1P4n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 11:56:43 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D12C360D07;
        Wed, 28 Jul 2021 15:56:40 +0000 (UTC)
Date:   Wed, 28 Jul 2021 11:56:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jann Horn <jannh@google.com>
Cc:     Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Qitao Xu <qitao.xu@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-hardening@vger.kernel.org
Subject: Re: tracepoints and %p [was: Re: [Patch net-next resend v2] net:
 use %px to print skb address in trace_netif_receive_skb]
Message-ID: <20210728115633.614e9bd9@oasis.local.home>
In-Reply-To: <CAG48ez0b-t_kJXVeFixYMoqRa-g1VRPUhFVknttiBYnf-cjTyg@mail.gmail.com>
References: <20210715055923.43126-1-xiyou.wangcong@gmail.com>
        <202107230000.B52B102@keescook>
        <CAG48ez0b-t_kJXVeFixYMoqRa-g1VRPUhFVknttiBYnf-cjTyg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Jul 2021 17:13:12 +0200
Jann Horn <jannh@google.com> wrote:

> +tracing maintainers
> 
> On Fri, Jul 23, 2021 at 9:09 AM Kees Cook <keescook@chromium.org> wrote:
> > On Wed, Jul 14, 2021 at 10:59:23PM -0700, Cong Wang wrote:  
> > > From: Qitao Xu <qitao.xu@bytedance.com>
> > >
> > > The print format of skb adress in tracepoint class net_dev_template
> > > is changed to %px from %p, because we want to use skb address
> > > as a quick way to identify a packet.  
> >
> > No; %p was already hashed to uniquely identify unique addresses. This
> > is needlessly exposing kernel addresses with no change in utility. See
> > [1] for full details on when %px is justified (almost never).
> >  
> > > Note, trace ring buffer is only accessible to privileged users,
> > > it is safe to use a real kernel address here.  
> >
> > That's not accurate either; there is a difference between uid 0 and
> > kernel mode privilege levels.
> >
> > Please revert these:
> >
> >         851f36e40962408309ad2665bf0056c19a97881c
> >         65875073eddd24d7b3968c1501ef29277398dc7b
> >
> > And adjust this to replace %px with %p:
> >
> >         70713dddf3d25a02d1952f8c5d2688c986d2f2fb
> >
> > Thanks!
> >
> > -Kees  
> 
> Hi Kees,
> 
> as far as I understand, the printf format strings for tracepoints
> don't matter for exposing what data is exposed to userspace - the raw
> data, not the formatted data, is stored in the ring buffer that
> userspace can access via e.g. trace_pipe_raw (see
> https://www.kernel.org/doc/Documentation/trace/ftrace.txt), and the
> data can then be formatted **by userspace tooling** (e.g.
> libtraceevent). As far as I understand, the stuff that root can read
> via debugfs is the data stored by TP_fast_assign() (although root
> _can_ also let the kernel do the printing and read it in text form).
> Maybe Steven Rostedt can help with whether that's true and provide
> more detail on this.

That is exactly what is happening. I wrote the following to the replied
text up at the top, then noticed you basically stated the same thing
here ;-)

"You can get the raw data from the trace buffers directly via the
trace_pipe_raw. The data is copied directly without any processing. The
TP_fast_assign() adds the data into the buffer, and the printf() is
only reading what's in that buffer. The hashing happens later. If you
read the buffers directly, you get all the data you want."

> 
> In my view, the ftrace subsystem, just like the BPF subsystem, is
> root-only debug tracing infrastructure that can and should log
> detailed information about kernel internals, no matter whether that
> information might be helpful to attackers, because if an attacker is
> sufficiently privileged to access this level of debug information,
> that's beyond the point where it makes sense to worry about exposing
> kernel pointers. But even if you disagree, I don't think that ftrace
> format strings are relevant here.

Anyway, those patches are not needed. (Kees is going to hate me).

Since a345a6718bd56 added in 5.12, you can just do:

 # trace-cmd start -e net_dev_start_xmit
 # trace-cmd show
[..]
            sshd-1853    [007] ...1  1995.000611: net_dev_start_xmit: dev=em1 queue_mapping=0 skbaddr=00000000f8c47ebd vlan_tagged=0 vlan_proto=0x0000 vlan_tci=0x0000 protocol=0x0800 ip_summed=3 len=150 data_len=84 network_offset=14 transport_offset_valid=1 transport_offset=34 tx_flags=0 gso_size=0 gso_segs=1 gso_type=0x1

Notice the value of skbaddr=00000000f8c47ebd ?

Now I do:

	# trace-cmd start -O nohash-ptr -e net_dev_start_xmit
	# trace-cmd show
[..]
            sshd-1853    [007] ...1  2089.462722: net_dev_start_xmit: dev= queue_mapping=0 skbaddr=ffff8cfbc3ffd0e0 vlan_tagged=0 vlan_proto=0x0000 vlan_tci=0x0000 protocol=0x0800 ip_summed=3 len=150 data_len=84 network_offset=14 transport_offset_valid=1 transport_offset=34 tx_flags=0 gso_size=0 gso_segs=1 gso_type=0x1

And now we have:

skbaddr=ffff8cfbc3ffd0e0

-- Steve
