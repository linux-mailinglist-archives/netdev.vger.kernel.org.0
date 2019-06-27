Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6C4587DA
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfF0RAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbfF0RAj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 13:00:39 -0400
Received: from localhost (unknown [89.205.128.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF7152146E;
        Thu, 27 Jun 2019 17:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561654838;
        bh=DFQcHsSzr0TGMEOwXupolW96eUaCDcWYfmbazJB4+9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K8GhsgvqOpUcPSpFh7qOnThoXQy1cmMQx3v3IReQ7ErW2Svj7xTbvKyVCUvZDskz6
         pQnWZmcgNjoVVQ81ibpNRhp+JTgPdQWY+/ATUrEraJadScY0mBFy1LUPksns/lrtDV
         3YobGd42AEMtYwdlR/PuQxMBk4IJU5aqPCEXrJgM=
Date:   Fri, 28 Jun 2019 01:00:32 +0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jannh@google.com" <jannh@google.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Message-ID: <20190627170032.GA10304@kroah.com>
References: <20190625182303.874270-1-songliubraving@fb.com>
 <20190625182303.874270-2-songliubraving@fb.com>
 <9bc166ca-1ef0-ee1e-6306-6850d4008174@iogearbox.net>
 <5A472047-F329-43C3-9DBC-9BCFC0A19F1C@fb.com>
 <20190627000830.GB527@kroah.com>
 <94404006-0D7E-4226-9167-B1DFAF7FEB2A@fb.com>
 <20190627163723.GA9643@kroah.com>
 <48E35F58-0DAD-40BA-993F-8AB76587A93B@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E35F58-0DAD-40BA-993F-8AB76587A93B@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 04:51:20PM +0000, Song Liu wrote:
> 
> 
> > On Jun 27, 2019, at 9:37 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > On Thu, Jun 27, 2019 at 01:00:03AM +0000, Song Liu wrote:
> >> 
> >> 
> >>> On Jun 26, 2019, at 5:08 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >>> 
> >>> On Wed, Jun 26, 2019 at 03:17:47PM +0000, Song Liu wrote:
> >>>>>> +static struct miscdevice bpf_dev = {
> >>>>>> +	.minor		= MISC_DYNAMIC_MINOR,
> >>>>>> +	.name		= "bpf",
> >>>>>> +	.fops		= &bpf_chardev_ops,
> >>>>>> +	.mode		= 0440,
> >>>>>> +	.nodename	= "bpf",
> >>>>> 
> >>>>> Here's what kvm does:
> >>>>> 
> >>>>> static struct miscdevice kvm_dev = {
> >>>>>      KVM_MINOR,
> >>>>>      "kvm",
> >>>>>      &kvm_chardev_ops,
> >>>>> };
> >>> 
> >>> Ick, I thought we converted all of these to named initializers a long
> >>> time ago :)
> >>> 
> >>>>> Is there an actual reason that mode is not 0 by default in bpf case? Why
> >>>>> we need to define nodename?
> >>>> 
> >>>> Based on my understanding, mode of 0440 is what we want. If we leave it 
> >>>> as 0, it will use default value of 0600. I guess we can just set it to 
> >>>> 0440, as user space can change it later anyway. 
> >>> 
> >>> Don't rely on userspace changing it, set it to what you want the
> >>> permissions to be in the kernel here, otherwise you have to create a new
> >>> udev rule and get it merged into all of the distros.  Just do it right
> >>> the first time and there is no need for it.
> >>> 
> >>> What is wrong with 0600 for this?  Why 0440?
> >> 
> >> We would like root to own the device, and let users in a certain group 
> >> to be able to open it. So 0440 is what we need. 
> > 
> > But you are doing a "write" ioctl here, right?  So don't you really need
> 
> By "write", you meant that we are modifying a bit in task_struct, right?
> In that sense, we probably need 0220?

You need some sort of write permission to modify something in the kernel :)

> > And why again is this an ioctl instead of a syscall?  What is so magic
> > about the file descriptor here?
> 
> We want to control the permission of this operation via this device. 
> Users that can open the device would be able to run the ioctl. I think 
> syscall cannot achieve control like this, unless we introduce something 
> like CAP_BPF_ADMIN?

Ah, yeah, ick, no, don't go there...

And you can more easily "control" access to this device node from
containers as well.  Ok, that makes sense to me.

thanks,

greg k-h
