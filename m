Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1BA2A83C9
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 17:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730447AbgKEQpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 11:45:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbgKEQpa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 11:45:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51A4D20936;
        Thu,  5 Nov 2020 16:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604594729;
        bh=4SWGNbCFLyKGsk/M1/t0kkiFliROsmYiJgGbNKZM+XQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LGerKNYuDhu7gfN82ZJjjMxcqKOQ2bhQ9nne4hvW4ovxqq9cP9RZ8a/s0MVz8UnLp
         T+gil3TjFwRt9idv+E97y+5APT0yPs0YkFJ9e0aZOgYHJYfYjlK02FXwvQ3pld+yTg
         16vAWA0BfVPsDI5bjPw9wDmrWrm31+sEVXAt1pIk=
Date:   Thu, 5 Nov 2020 17:46:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net,
        kernel-team@fb.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [RFC PATCH bpf-next 4/5] bpf: load and verify kernel module BTFs
Message-ID: <20201105164616.GA1201462@kroah.com>
References: <20201105045140.2589346-1-andrii@kernel.org>
 <20201105045140.2589346-5-andrii@kernel.org>
 <20201105083925.68433e51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105083925.68433e51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 08:39:25AM -0800, Jakub Kicinski wrote:
> On Wed, 4 Nov 2020 20:51:39 -0800 Andrii Nakryiko wrote:
> > Add kernel module listener that will load/validate and unload module BTF.
> > Module BTFs gets ID generated for them, which makes it possible to iterate
> > them with existing BTF iteration API. They are given their respective module's
> > names, which will get reported through GET_OBJ_INFO API. They are also marked
> > as in-kernel BTFs for tooling to distinguish them from user-provided BTFs.
> > 
> > Also, similarly to vmlinux BTF, kernel module BTFs are exposed through
> > sysfs as /sys/kernel/btf/<module-name>. This is convenient for user-space
> > tools to inspect module BTF contents and dump their types with existing tools:
> 
> Is there any precedent for creating per-module files under a new
> sysfs directory structure? My intuition would be that these files 
> belong under /sys/module/

Ick, why?  What's wrong with them under btf?  The module core code
"owns" the /sys/modules/ tree.  If you want others to mess with that, it
will get tricky.


> Also the CC list on these patches is quite narrow. You should have 
> at least CCed the module maintainer. Adding some folks now.
> 
> > [vmuser@archvm bpf]$ ls -la /sys/kernel/btf
> > total 0
> > drwxr-xr-x  2 root root       0 Nov  4 19:46 .
> > drwxr-xr-x 13 root root       0 Nov  4 19:46 ..
> > 
> > ...
> > 
> > -r--r--r--  1 root root     888 Nov  4 19:46 irqbypass
> > -r--r--r--  1 root root  100225 Nov  4 19:46 kvm
> > -r--r--r--  1 root root   35401 Nov  4 19:46 kvm_intel
> > -r--r--r--  1 root root     120 Nov  4 19:46 pcspkr
> > -r--r--r--  1 root root     399 Nov  4 19:46 serio_raw
> > -r--r--r--  1 root root 4094095 Nov  4 19:46 vmlinux
> > 
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >  include/linux/bpf.h    |   2 +
> >  include/linux/module.h |   4 +
> >  kernel/bpf/btf.c       | 193 +++++++++++++++++++++++++++++++++++++++++
> >  kernel/bpf/sysfs_btf.c |   2 +-
> >  kernel/module.c        |  32 +++++++
> >  5 files changed, 232 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 2fffd30e13ac..3cb89cd7177b 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -36,9 +36,11 @@ struct seq_operations;
> >  struct bpf_iter_aux_info;
> >  struct bpf_local_storage;
> >  struct bpf_local_storage_map;
> > +struct kobject;
> >  
> >  extern struct idr btf_idr;
> >  extern spinlock_t btf_idr_lock;
> > +extern struct kobject *btf_kobj;

I don't see any Documentation/ABI/ updates for the sysfs changes here,
did I miss it?

thanks,

greg k-h
