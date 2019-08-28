Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E07F89F77F
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 02:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbfH1Aoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 20:44:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbfH1Aog (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 20:44:36 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B41A7208CB;
        Wed, 28 Aug 2019 00:44:34 +0000 (UTC)
Date:   Tue, 27 Aug 2019 20:44:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Message-ID: <20190827204433.3af91faf@gandalf.local.home>
In-Reply-To: <CALCETrUOHRMkBRJi_s30CjZdOLDGtdMOEgqfgPf+q0x+Fw7LtQ@mail.gmail.com>
References: <20190827205213.456318-1-ast@kernel.org>
        <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
        <20190827192144.3b38b25a@gandalf.local.home>
        <CALCETrUOHRMkBRJi_s30CjZdOLDGtdMOEgqfgPf+q0x+Fw7LtQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 16:34:47 -0700
Andy Lutomirski <luto@kernel.org> wrote:

> > > CAP_TRACING does not override normal permissions on sysfs or debugfs.
> > > This means that, unless a new interface for programming kprobes and
> > > such is added, it does not directly allow use of kprobes.  
> >
> > kprobes can be created in the tracefs filesystem (which is separate from
> > debugfs, tracefs just gets automatically mounted
> > in /sys/kernel/debug/tracing when debugfs is mounted) from the
> > kprobe_events file. /sys/kernel/tracing is just the tracefs
> > directory without debugfs, and was created specifically to allow
> > tracing to be access without opening up the can of worms in debugfs.  
> 
> I think that, in principle, CAP_TRACING should allow this, but I'm not
> sure how to achieve that.  I suppose we could set up
> inode_operations.permission on tracefs, but what exactly would it do?
> Would it be just like generic_permission() except that it would look
> at CAP_TRACING instead of CAP_DAC_OVERRIDE?  That is, you can use
> tracefs if you have CAP_TRACING *or* acl access?  Or would it be:
> 
> int tracing_permission(struct inode *inode, int mask)
> {
>   if (!capable(CAP_TRACING))
>     return -EPERM;
> 
>   return generic_permission(inode, mask);
> }

Perhaps we should make a group for it?

> 
> Which would mean that you need ACL *and* CAP_TRACING, so
> administrators would change the mode to 777.  That's a bit scary.
> 
> And this still doesn't let people even *find* tracefs, since it's
> hidden in debugfs.
> 
> So maybe make CAP_TRACING override ACLs but also add /sys/fs/tracing
> and mount tracefs there, too, so that regular users can at least find
> the mountpoint.

I think you missed what I said. It's not hidden in /sys/kernel/debug.
If you enable tracefs, you have /sys/kernel/tracing created, and is
completely separate from debugfs. I only have it *also* automatically
mounted to /sys/kernel/debug/tracing for backward compatibility
reasons, as older versions of trace-cmd will only mount debugfs (as
root), and expect to find it there.

 mount -t tracefs nodev /sys/kernel/tracing

-- Steve

> 
> >
> > Should we allow CAP_TRACING access to /proc/kallsyms? as it is helpful
> > to convert perf and trace-cmd's function pointers into names. Once you
> > allow tracing of the kernel, hiding /proc/kallsyms is pretty useless.  
> 
> I think we should.

