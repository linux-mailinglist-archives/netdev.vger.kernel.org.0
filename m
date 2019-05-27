Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C89D12B25F
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 12:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfE0Koy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 06:44:54 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40163 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfE0Kox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 06:44:53 -0400
Received: by mail-wr1-f66.google.com with SMTP id t4so8173345wrx.7
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 03:44:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=g7/E66m+Y5O11ad07XoDt/U2/tfNbfwyooMkLIABrSc=;
        b=gy1cZMX4p/hiXttGo19wgAlK6g3hHQYxsLDCuQvrtHBSSTbLiS7bNDSxggAO51GFTn
         V9lde9tr6wQpG25E8C066ub1GEKeAf1BePhflFM4KpDhwr+ri0KI3VdHq4nYbLUYPfgc
         3H0rBEoxbALpzjVRt+dYlvkI0QK6Y9GqU97HGj1DV8ObBbNDZzTq2IeUKRZpB3R8tqjl
         Bel50fXwgGLJEISMyZDRH4ZsLLYV9NA9SGTyuR4Qmmq9o80VcjFjBNIc6RWLJfCQErkS
         o6p9jdXOA//ghS7SYdd3+z6zsLeY6nnI3QSOMqBTWHYlDs6xH5Qy5FJ6wTf5496+nGn0
         UljQ==
X-Gm-Message-State: APjAAAXj7gZB+Vmr20gnpWyQxSZnopCjwE4XSqk/eSYzur1/tDx+8xE4
        2B1ASyZWSESKg7vxS5ICSk0sUQ==
X-Google-Smtp-Source: APXvYqx1oj7W4JcA1flQE6/rA6W3MWgDoNHwmWsFdDA1eG7T9OCNKarfuwL///oDSMUce596R4TlPg==
X-Received: by 2002:adf:eec9:: with SMTP id a9mr21243585wrp.281.1558953890683;
        Mon, 27 May 2019 03:44:50 -0700 (PDT)
Received: from steredhat (host253-229-dynamic.248-95-r.retail.telecomitalia.it. [95.248.229.253])
        by smtp.gmail.com with ESMTPSA id 8sm9120825wmf.18.2019.05.27.03.44.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 03:44:49 -0700 (PDT)
Date:   Mon, 27 May 2019 12:44:47 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>
Cc:     netdev@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vishnu Dasa <vdasa@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [RFC] vsock: proposal to support multiple transports at runtime
Message-ID: <20190527104447.gd23h2dsnmit75ry@steredhat>
References: <20190514081543.f6nphcilgjuemlet@steredhat>
 <20190523153703.GC19296@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523153703.GC19296@stefanha-x1.localdomain>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 04:37:03PM +0100, Stefan Hajnoczi wrote:
> On Tue, May 14, 2019 at 10:15:43AM +0200, Stefano Garzarella wrote:
> > Hi guys,
> > I'm currently interested on implement a multi-transport support for VSOCK in
> > order to handle nested VMs.
> > 
> > As Stefan suggested me, I started to look at this discussion:
> > https://lkml.org/lkml/2017/8/17/551
> > Below I tried to summarize a proposal for a discussion, following the ideas
> > from Dexuan, Jorgen, and Stefan.
> > 
> > 
> > We can define two types of transport that we have to handle at the same time
> > (e.g. in a nested VM we would have both types of transport running together):
> > 
> > - 'host side transport', it runs in the host and it is used to communicate with
> >   the guests of a specific hypervisor (KVM, VMWare or HyperV)
> > 
> >   Should we support multiple 'host side transport' running at the same time?
> > 
> > - 'guest side transport'. it runs in the guest and it is used to communicate
> >   with the host transport
> 
> I find this terminology confusing.  Perhaps "host->guest" (your 'host
> side transport') and "guest->host" (your 'guest side transport') is
> clearer?

I agree, "host->guest" and "guest->host" are better, I'll use them.

> 
> Or maybe the nested virtualization terminology of L2 transport (your
> 'host side transport') and L0 transport (your 'guest side transport')?
> Here we are the L1 guest and L0 is the host and L2 is our nested guest.
>

I'm confused, if L2 is the nested guest, it should be the
'guest side transport'. Did I miss anything?

Maybe it is another point to your first proposal :)

> > 
> > 
> > The main goal is to find a way to decide what transport use in these cases:
> > 1. connect() / sendto()
> > 
> > 	a. use the 'host side transport', if the destination is the guest
> > 	   (dest_cid > VMADDR_CID_HOST).
> > 	   If we want to support multiple 'host side transport' running at the
> > 	   same time, we should assign CIDs uniquely across all transports.
> > 	   In this way, a packet generated by the host side will get directed
> > 	   to the appropriate transport based on the CID
> 
> The multiple host side transport case is unlikely to be necessary on x86
> where only one hypervisor uses VMX at any given time.  But eventually it
> may happen so it's wise to at least allow it in the design.
> 

Okay, I was in doubt, but I'll keep it in the design.

> > 
> > 	b. use the 'guest side transport', if the destination is the host
> > 	   (dest_cid == VMADDR_CID_HOST)
> 
> Makes sense to me.
> 
> > 
> > 
> > 2. listen() / recvfrom()
> > 
> > 	a. use the 'host side transport', if the socket is bound to
> > 	   VMADDR_CID_HOST, or it is bound to VMADDR_CID_ANY and there is no
> > 	   guest transport.
> > 	   We could also define a new VMADDR_CID_LISTEN_FROM_GUEST in order to
> > 	   address this case.
> > 	   If we want to support multiple 'host side transport' running at the
> > 	   same time, we should find a way to allow an application to bound a
> > 	   specific host transport (e.g. adding new VMADDR_CID_LISTEN_FROM_KVM,
> > 	   VMADDR_CID_LISTEN_FROM_VMWARE, VMADDR_CID_LISTEN_FROM_HYPERV)
> 
> Hmm...VMADDR_CID_LISTEN_FROM_KVM, VMADDR_CID_LISTEN_FROM_VMWARE,
> VMADDR_CID_LISTEN_FROM_HYPERV isn't very flexible.  What if my service
> should only be available to a subset of VMware VMs?

You're right, it is not very flexible.

> 
> Instead it might be more appropriate to use network namespaces to create
> independent AF_VSOCK addressing domains.  Then you could have two
> separate groups of VMware VMs and selectively listen to just one group.
> 

Does AF_VSOCK support network namespace or it could be another
improvement to take care? (IIUC is not currently supported)

A possible issue that I'm seeing with netns is if they are used for
other purpose (e.g. to isolate the network of a VM), we should have
multiple instances of the application, one per netns.

> > 
> > 	b. use the 'guest side transport', if the socket is bound to local CID
> > 	   different from the VMADDR_CID_HOST (guest CID get with
> > 	   IOCTL_VM_SOCKETS_GET_LOCAL_CID), or it is bound to VMADDR_CID_ANY
> > 	   (to be backward compatible).
> > 	   Also in this case, we could define a new VMADDR_CID_LISTEN_FROM_HOST.
> 
> Two additional topics:
> 
> 1. How will loading af_vsock.ko change?

I'd allow the loading of af_vsock.ko without any transport.
Maybe we should move the MODULE_ALIAS_NETPROTO(PF_VSOCK) from the
vmci_transport.ko to the af_vsock.ko, but this can impact the VMware
driver.

>    In particular, can an
>    application create a socket in af_vsock.ko without any loaded
>    transport?  Can it enter listen state without any loaded transport
>    (this seems useful with VMADDR_CID_ANY)?

I'll check if we can allow listen sockets without any loaded transport,
but I think could be a nice behaviour to have.

> 
> 2. Does your proposed behavior match VMware's existing nested vsock
>    semantics?

I'm not sure, but I tried to follow the Jorgen's answers to the original
thread. I hope that this proposal matches the VMware semantic.

@Jorgen, do you have any advice?

Thanks,
Stefano
