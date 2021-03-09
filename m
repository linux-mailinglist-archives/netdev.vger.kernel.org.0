Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A2B333002
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 21:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbhCIUfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 15:35:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231510AbhCIUfG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 15:35:06 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 059576522E;
        Tue,  9 Mar 2021 20:35:05 +0000 (UTC)
Date:   Tue, 9 Mar 2021 15:35:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        mingo@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: add net namespace inode for all net_dev events
Message-ID: <20210309153504.0b06ded1@gandalf.local.home>
In-Reply-To: <fffda629-0028-2824-2344-3507b75d9188@gmail.com>
References: <20210309044349.6605-1-tonylu@linux.alibaba.com>
        <20210309124011.709c6cd3@gandalf.local.home>
        <5fda3ef7-d760-df4f-e076-23b635f6c758@gmail.com>
        <20210309150227.48281a18@gandalf.local.home>
        <fffda629-0028-2824-2344-3507b75d9188@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Mar 2021 13:17:23 -0700
David Ahern <dsahern@gmail.com> wrote:

> On 3/9/21 1:02 PM, Steven Rostedt wrote:
> > On Tue, 9 Mar 2021 12:53:37 -0700
> > David Ahern <dsahern@gmail.com> wrote:
> >   
> >> Changing the order of the fields will impact any bpf programs expecting
> >> the existing format  
> > 
> > I thought bpf programs were not API. And why are they not parsing this
> > information? They have these offsets hard coded???? Why would they do that!
> > The information to extract the data where ever it is has been there from
> > day 1! Way before BPF ever had access to trace events.  
> 
> BPF programs attached to a tracepoint are passed a context - a structure
> based on the format for the tracepoint. To take an in-tree example, look
> at samples/bpf/offwaketime_kern.c:
> 
> ...
> 
> /* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
> struct sched_switch_args {
>         unsigned long long pad;
>         char prev_comm[16];
>         int prev_pid;
>         int prev_prio;
>         long long prev_state;
>         char next_comm[16];
>         int next_pid;
>         int next_prio;
> };
> SEC("tracepoint/sched/sched_switch")
> int oncpu(struct sched_switch_args *ctx)
> {
> 
> ...
> 
> Production systems do not typically have toolchains installed, so
> dynamic generation of the program based on the 'format' file on the
> running system is not realistic. That means creating the programs on a
> development machine and installing on the production box. Further, there
> is an expectation that a bpf program compiled against version X works on
> version Y. Changing the order of the fields will break such programs in
> non-obvious ways.

The size of the fields and order changes all the time in various events. I
recommend doing so *all the time*. If you upgrade a kernel, then all the bpf
programs you have for that kernel should also be updated. You can't rely on
fields being the same, size or order. The best you can do is expect the
field to continue to exist, and that's not even a guarantee.

I'm not sure how that sample is used. I can't find "oncpu()" anywhere in
that directory besides where it is defined, and I wouldn't think a bpf
program would just blindly map the fields without verifying them.


-- Steve
