Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FBC4A6757
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 22:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbiBAVtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 16:49:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59168 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235863AbiBAVtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 16:49:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643752161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a5WqlN/Vt3/poLxTRygvp8Var//X1m9eHee1pCfKA+k=;
        b=R8F6jlTa4e8bLuxkqRbjXiUp3FnUHDoQ3YDyd+uOg37SOiPtMs3JCQwCU91D57X3Fo98Po
        dB0OqzGGIKBMlXCuBCjeoCGDErOStI41qwL/4TXqyxqFkmOTYS4pJPddQRSjKAC+b2bsAM
        MXG8NsdlJTyM2d2N7v6EUv/ABdSdpuM=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-GwH5Vr3CMGqAhHPplhW67Q-1; Tue, 01 Feb 2022 16:49:20 -0500
X-MC-Unique: GwH5Vr3CMGqAhHPplhW67Q-1
Received: by mail-ot1-f69.google.com with SMTP id j2-20020a9d7d82000000b005a12a0fb4b0so10162513otn.5
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 13:49:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a5WqlN/Vt3/poLxTRygvp8Var//X1m9eHee1pCfKA+k=;
        b=LdMuBuJzTbuPldWMPrr+Ce82bFCEKx033kzc/A7drrdS+yd5obf3kmjQS4zZyt1EVY
         InyHflyHIyMWGWZ+Sj+I1Rsofc/P4anmEAMXu2/ERYRluUZBBis+STfF2IN98euD3oO5
         1lDdFTLXpvhVd9eoBZ4o5F614hpNDoa3OqKzzoSyC7ERM2StA5wOzA2lmFtcWpgcQUM1
         dn3p0FiOpf/lswugoFP3STBZkCqRLnq60NvR9QvC9kcDsgRp9DOJ0FUIm66Dd893OXFi
         5BgFPYdtioEJWMoIMEw+KKniD8AJ1DMIcUjnu8VBygNdESLLtL5I81LRbSj8TY/PoPg1
         OwqA==
X-Gm-Message-State: AOAM530W4TnUw0nL2bgoQOT9oUockjvltkHvhHZXb3gKRJfHzlYiazVn
        CgtsBJJ++7xB+2B5FwJ4z7JD1KPjxKdKAOL7zVDyO2HoI3XMszbYuP+HGY4vqj+q41pnTrh0Cxo
        BeSMYO9rkr96MbHi7
X-Received: by 2002:a05:6808:16a7:: with SMTP id bb39mr2650826oib.108.1643752159250;
        Tue, 01 Feb 2022 13:49:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGgQnF49PRqfEYF4qSSLQEJXF6QJ0lb4qGPlxPxVP+UmZ8uLWHoPy6yySkRPVvAMVRzrIMqQ==
X-Received: by 2002:a05:6808:16a7:: with SMTP id bb39mr2650806oib.108.1643752158861;
        Tue, 01 Feb 2022 13:49:18 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e7sm4281385oow.47.2022.02.01.13.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 13:49:18 -0800 (PST)
Date:   Tue, 1 Feb 2022 14:49:16 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Message-ID: <20220201144916.14f75ca5.alex.williamson@redhat.com>
In-Reply-To: <20220201183620.GL1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
        <20220130160826.32449-9-yishaih@nvidia.com>
        <20220131164318.3da9eae5.alex.williamson@redhat.com>
        <20220201003124.GZ1786498@nvidia.com>
        <20220201100408.4a68df09.alex.williamson@redhat.com>
        <20220201183620.GL1786498@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Feb 2022 14:36:20 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Feb 01, 2022 at 10:04:08AM -0700, Alex Williamson wrote:
> 
> > Ok, let me parrot back to see if I understand.  -ENOTTY will be
> > returned if the ioctl doesn't exist, in which case device_state is
> > untouched and cannot be trusted.  At the same time, we expect the user
> > to use the feature ioctl to make sure the ioctl exists, so it would
> > seem that we've reclaimed that errno if we believe the user should
> > follow the protocol.  
> 
> I don't follow - the documentation says what the code does, if you get
> ENOTTY returned then you don't get the device_state too. Saying the
> user shouldn't have called it in the first place is completely
> correct, but doesn't change the device_state output.

The documentation says "...the device state output is not reliable", and
I have to question whether this qualifies as a well specified,
interoperable spec with such language.  We're essentially asking users
to keep track that certain errnos result in certain fields of the
structure _maybe_ being invalid.

> > +       if (!device->ops->migration_set_state)
> > +               return -EOPNOTSUPP;
> > 
> > Should return -ENOTTY, just as the feature does.    
> 
> As far as I know the kernel 'standard' is:
>  - ENOTTY if the ioctl cmd # itself is not understood
>  - E2BIG if the ioctl arg is longer than the kernel understands
>  - EOPNOTSUPP if the ioctl arg contains data the kernel doesn't
>    understand (eg flags the kernel doesn't know about), or the
>    kernel understands the request but cannot support it for some
>    reason.
>  - EINVAL if the ioctl arg contains data the kernel knows about but
>    rejects (ie invalid combinations of flags)
> 
> VFIO kind of has its own thing, but I'm not entirely sure what the
> rules are, eg you asked for EOPNOTSUPP in the other patch, and here we
> are asking for ENOTTY?
> 
> But sure, lets make it ENOTTY.

I'd move your first example of EOPNOTSUPP to EINVAL.  To me, the user
providing bits/fields/values that are undefined in an invalid argument.
I've typically steered away from the extended errnos in favor of things
in the base set, so as you noted, there are currently no instances of
EOPNOTSUPP in vfio.  In the case we discussed of a user trying to do
SET/GET on a feature that only supports GET/SET could go either way,
it's an invalid argument for the feature and in this case the user can
determine the supported arguments via the PROBE interface.  But when I
start seeing multiple tests that all result in an EINVAL return, then I
wonder if a different errno might help user debugging.  EINVAL is
acceptable in the case I noted, but maybe another errno could be more
descriptive.

In the immediate example here, userspace really has no reason to see a
difference in the ioctl between lack of kernel support for migration
altogether and lack of device support for migration.  So I'd fall back
to the ioctl is not known "for this device", -ENOTTY.

Now you're making me wonder how much I care to invest in semantic
arguments over extended errnos :-\
 
> > But it's also for future unsupported ops, but couldn't we also
> > specify that the driver must fill final_state with the current
> > device state for any such case.  We also have this:
> > 
> > +       if (set_state.argsz < minsz || set_state.flags)
> > +               return -EOPNOTSUPP;
> > 
> > Which I think should be -EINVAL.  
> 
> That would match the majority of other VFIO tests.
> 
> > That leaves -EFAULT, for example:
> > 
> > +       if (copy_from_user(&set_state, arg, minsz))
> > +               return -EFAULT;
> > 
> > Should we be able to know the current device state in core code such
> > that we can fill in device state here?  
> 
> There is no point in doing a copy_to_user() to the same memory if a
> copy_from_user() failed, so device_state will still not be returned.

Duh, good point.
 
> We don't know the device_state in the core code because it can only be
> read under locking that is controlled by the driver. I hope when we
> get another driver merged that we can hoist the locking, but right now
> I'm not really sure - it is a complicated lock.

The device cannot self transition to a new state, so if the core were
to serialize this ioctl then the device_state provided by the driver is
valid, regardless of its internal locking.

Whether this ioctl should be serialized anyway is probably another good
topic to breach.  Should a user be able to have concurrent ioctls
setting conflicting states?

> > I think those changes would go a ways towards fully specified behavior
> > instead of these wishy washy unreliable return values.  Then we could  
> 
> Huh? It is fully specified already. These changes just removed
> EOPNOTSUPP from the list where device_state isn't filled in. It is OK,
> but it is not really different...

Hmm, "output is not reliable" is fully specified?  We can't really make
use of return flags to identify valid fields either since the copy-out
might fault.  I'd suggest that ioctl return structure is only valid at
all on success and we add a GET interface to return the current device
state on errno given the argument above that driver locking is
irrelevant because the device cannot self transition.

> >  "If this function fails and returns -1 then..."
> > 
> > Could we clarify that to s/function/ioctl/?  It caused me a moment of
> > confusion for the returned -errnos.  
> 
> Sure.
> 
> > > > Should we be bumping a reference on the device FD such that we can't
> > > > have outstanding migration FDs with the device closed (and
> > > > re-assigned to a new user)?    
> > > 
> > > The driver must ensure any activity triggered by the migration FD
> > > against the vfio_device is halted before close_device() returns, just
> > > like basically everything else connected to open/close_device(). mlx5
> > > does this by using the same EOF sanitizing the FSM logic uses.
> > > 
> > > Once sanitized the f_ops should not be touching the vfio_device, or
> > > even have a pointer to it, so there is no reason to connect the two
> > > FDs together. I'd say it is a red flag if a driver proposes to do
> > > this, likely it means it has a problem with the open/close_device()
> > > lifetime model.  
> > 
> > Maybe we just need a paragraph somewhere to describe the driver
> > responsibilities and expectations in managing the migration FD,
> > including disconnecting it after end of stream and access relative to
> > the open state of the vfio_device.  Seems an expanded descriptions
> > somewhere near the declaration in vfio_device_ops would be appropriate.  
> 
> Yes that is probably better than in the uapi header.
> 
> > > I'm not sure what the overall VFIO vision is here.. Are we abandoning
> > > traditional ioctls in favour of a multiplexer? Calling the multiplexer
> > > ioctl "feature" is a bit odd..  
> > 
> > Is it really?  VF Token support is a feature that a device might have
> > and we can use the same interface to probe that it exists as well as
> > set the UUID token.  We're using it to manipulate the state of a device
> > feature.
> > 
> > If we're only looking for a means to expose that a device has support
> > for something, our options are a flag bit on the vfio_device_info or a
> > capability on that ioctl.  It's arguable that the latter might be a
> > better option for VFIO_DEVICE_FEATURE_MIGRATION since its purpose is
> > only to return a flags field, ie. we're not interacting with a feature,
> > we're exposing a capability with fixed properties.  
> 
> I looked at this, and decided against it on practical reasons.
> 
> I've organized this so the core code can do more work for the driver,
> which means the core code supplies the support info back to
> userspace. VFIO_DEVICE_INFO is currently open coded in every single
> driver and lifting that to get the same support looks like a huge
> pain. Even if we try to work it backwards somehow, we'd need to
> re-organize vfio-pci so other drivers can contribute to the cap chain -
> which is another ugly looking thing.
> 
> On top of that, qemu becomes much less straightforward as we have to
> piggy back on the existing vfio code instead of just doing a simple
> ioctl to get back the small support info back. There is even an
> unpleasing mandatory user/kernel memory allocation and double ioctl in
> the caps path.
> 
> The feature approach is much better, it has a much cleaner
> implementation in user/kernel. I think we should focus on it going
> forward and freeze caps.

Ok, I'm not demanding a capability interface.
 
> > > It complicates the user code a bit, it is more complicated to invoke the
> > > VFIO_DEVICE_FEATURE (check the qemu patch to see the difference).  
> > 
> > Is it really any more than some wrapper code?  Are there objections to
> > this sort of multiplexer?  
> 
> There isn't too much reason to do this kind of stuff. Each subsystem
> gets something like 4 million ioctl numbers within its type, we will
> never run out of unique ioctls.
> 
> Normal ioctls have a nice simplicity to them, adding layers creates
> complexity, feature is defiantly more complex to implement, and cap
> is a whole other level of more complex. None of this is necessary.
> 
> I don't know what "cluttering" means here, I'd prefer we focus on
> things that give clean code and simple implementations than arbitary
> aesthetics.

It's entirely possible that I'm overly averse to ioctl proliferation,
but for every new ioctl we need to take a critical look at the proposed
API, use case, applicability, and extensibility.  That isn't entirely
removed when we use something like this generic feature ioctl, but I
consider it substantially reduced since we're working within an
existing framework.  A direct ioctl might be able to slightly
streamline the interface (I don't think that significantly matters in
this case), but on the other hand, defining this as a feature within an
existing interface provides consistency and compartmentalization.

> > > Either way I don't have a strong opinion, please have a think and let
> > > us know which you'd like to follow.  
> > 
> > I'm leaning towards a capability for migration support flags and a
> > feature for setting the state, but let me know if this looks like a bad
> > idea for some reason.  Thanks,  
> 
> I don't want to touch capabilities, but we can try to use feature for
> set state. Please confirm this is what you want.

It's a team sport, but to me it seems like it fits well both in my
mental model of interacting with a device feature, without
significantly altering the uAPI you're defining anyway.
 
> You'll want the same for the PRE_COPY related information too?

I hadn't gotten there yet.  It seems like a discontinuity to me that
we're handing out new FDs for data transfer sessions, but then we
require the user to come back to the device to query about the data its
reading through that other FD.  Should that be an ioctl on the data
stream FD itself?  Is there a use case for also having it on the
STOP_COPY FD?
 
> If we are into these very minor nitpicks does this mean you are OK
> with all the big topics now?

I'm not hating it, but I'd like to see buy-in from others who have a
vested interest in supporting migration.  I don't see Intel or Huawei
on the Cc list and the original collaborators of the v1 interface from
NVIDIA have been silent through this redesign.  Thanks,

Alex

