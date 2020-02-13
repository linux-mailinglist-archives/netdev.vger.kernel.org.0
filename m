Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF9015BD47
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 12:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbgBMLDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 06:03:05 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30604 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729511AbgBMLDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 06:03:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581591781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AVZjTtPT9BC7uyYP1H9zKyGGB+mGylhZ9/tJmLOCmOM=;
        b=Y0JtNMc4xy+C+gpC3dVkol1WqIVYCtaPNHbW+p5ZIqFpwgLAO1LKd3RzHrm+guwNqH5Bsf
        GWIL7HdsppNz+UNt8KIOoUyfCS2yZV0AouJTA1xRUSMuiSdf2+uM6XBLnViesc++FixiWl
        9ynDAeqXJSGNe1TExP8y0sMZOD5iSUA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-9HCuDAGJMO60Aq3HBODmWA-1; Thu, 13 Feb 2020 06:02:55 -0500
X-MC-Unique: 9HCuDAGJMO60Aq3HBODmWA-1
Received: by mail-wr1-f71.google.com with SMTP id p8so2185298wrw.5
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 03:02:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AVZjTtPT9BC7uyYP1H9zKyGGB+mGylhZ9/tJmLOCmOM=;
        b=RsSDLHSVCORnyAK4NK5lxm9o/ZPDEcu4NGgITfbu7ufQSKZr3tyoV6fO0JGh0b/BTp
         PDz73v54e2EAN/4PmYH8OVez9HWxtf5tSGg/LtM/m4dl8fVMug0vmtXgn/VmUI6KmeLu
         osENtP36sb4jvkn67B/N8jLWfhCtPT2b/i2Tgi8G7M7eK2r+7/3VyyIIMsHuUMGjBbJ9
         Bds0M6PyrkxTrjWttebtmBXuhvlu7A+AXdRVRop0QBWuOlDdj5g9pBkoM1kzXPcQgXUV
         pmVMW+pdJE4cgl7cTFOsyvK3pJU8XmmiHiPfiPLSD9aNuN5Q104uiRZM6zrLkCnAF8HD
         5IFw==
X-Gm-Message-State: APjAAAUajbyBeinMETuZeQ+4yS+o9rAsdkgZTsOXMwVwSsi9qtBcfE0v
        2vYfJr5vcLMK3tNraR766ttrjwTaMJY40QpReGIAWF1paFEPAFQpt5mlq6LpsNg70TfYgjJFGqN
        PBfeM6wuHUeXs88Ky
X-Received: by 2002:a1c:4008:: with SMTP id n8mr5232656wma.121.1581591774114;
        Thu, 13 Feb 2020 03:02:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqxSpzHMfAJwOSUOSj94W7ENBPeJM6Zbkkq3LjWC5FBHMYcUZtanUZnvYCf3bSp6vRaiA+fX/g==
X-Received: by 2002:a1c:4008:: with SMTP id n8mr5232635wma.121.1581591773866;
        Thu, 13 Feb 2020 03:02:53 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id f207sm2716900wme.9.2020.02.13.03.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 03:02:53 -0800 (PST)
Date:   Thu, 13 Feb 2020 12:02:51 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Cc:     "stefanha@redhat.com" <stefanha@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] net: virtio_vsock: Fix race condition between bind and
 listen
Message-ID: <20200213110251.2unj3sykwpku6dd7@steredhat>
References: <668b0eda8823564cd604b1663dc53fbaece0cd4e.camel@intel.com>
 <20200213094130.vehzkr4a3pnoiogr@steredhat>
 <3448e588f11dad913e93dfce8031fbd60ba4c85b.camel@intel.com>
 <20200213102237.uyhfv5g2td5ayg2b@steredhat>
 <1d4c3958d8b75756341548e7d51ccf42397c2d27.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d4c3958d8b75756341548e7d51ccf42397c2d27.camel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 10:44:18AM +0000, Boeuf, Sebastien wrote:
> On Thu, 2020-02-13 at 11:22 +0100, Stefano Garzarella wrote:
> > On Thu, Feb 13, 2020 at 09:51:36AM +0000, Boeuf, Sebastien wrote:
> > > Hi Stefano,
> > > 
> > > On Thu, 2020-02-13 at 10:41 +0100, Stefano Garzarella wrote:
> > > > Hi Sebastien,
> > > > 
> > > > On Thu, Feb 13, 2020 at 09:16:11AM +0000, Boeuf, Sebastien wrote:
> > > > > From 2f1276d02f5a12d85aec5adc11dfe1eab7e160d6 Mon Sep 17
> > > > > 00:00:00
> > > > > 2001
> > > > > From: Sebastien Boeuf <sebastien.boeuf@intel.com>
> > > > > Date: Thu, 13 Feb 2020 08:50:38 +0100
> > > > > Subject: [PATCH] net: virtio_vsock: Fix race condition between
> > > > > bind
> > > > > and listen
> > > > > 
> > > > > Whenever the vsock backend on the host sends a packet through
> > > > > the
> > > > > RX
> > > > > queue, it expects an answer on the TX queue. Unfortunately,
> > > > > there
> > > > > is one
> > > > > case where the host side will hang waiting for the answer and
> > > > > will
> > > > > effectively never recover.
> > > > 
> > > > Do you have a test case?
> > > 
> > > Yes I do. This has been a bug we've been investigating on Kata
> > > Containers for quite some time now. This was happening when using
> > > Kata
> > > along with Cloud-Hypervisor (which rely on the hybrid vsock
> > > implementation from Firecracker). The thing is, this bug is very
> > > hard
> > > to reproduce and was happening for Kata because of the connection
> > > strategy. The kata-runtime tries to connect a million times after
> > > it
> > > started the VM, just hoping the kata-agent will start to listen
> > > from
> > > the guest side at some point.
> > 
> > Maybe is related to something else. I tried the following which
> > should be
> > your case simplified (IIUC):
> > 
> > guest$ python
> >     import socket
> >     s = socket.socket(socket.AF_VSOCK, socket.SOCK_STREAM)
> >     s.bind((socket.VMADDR_CID_ANY, 1234))
> > 
> > host$ python
> >     import socket
> >     s = socket.socket(socket.AF_VSOCK, socket.SOCK_STREAM)
> >     s.connect((3, 1234))
> > 
> > Traceback (most recent call last):
> >   File "<stdin>", line 1, in <module>
> > TimeoutError: [Errno 110] Connection timed out
> 
> Yes this is exactly the simplified case. But that's the point, I don't
> think the timeout is the best way to go here. Because this means that
> when we run into this case, the host side will wait for quite some time
> before retrying, which can cause a very long delay before the
> communication with the guest is established. By simply answering the
> host with a RST packet, we inform it that nobody's listening on the
> guest side yet, therefore the host side will close and try again.

Yes, make sense.

I just wanted to point out that the host shouldn't get stuck if the
guest doesn't respond. So it's weird that this happens and it might be
related to some other problem.

> 
> > 
> > > > In the host, the af_vsock.c:vsock_stream_connect() set a timeout,
> > > > so
> > > > if
> > > > the host try to connect before the guest starts listening, the
> > > > connect()
> > > > should return ETIMEDOUT if the guest does not answer anything.
> > > > 
> > > > Anyway, maybe the patch make sense anyway, changing a bit the
> > > > description
> > > > (if the host connect() receive the ETIMEDOUT).
> > > > I'm just concerned that this code is common between guest and
> > > > host.
> > > > If a
> > > > malicious guest starts sending us wrong requests, we spend time
> > > > sending
> > > > a reset packet. But we already do that if we can't find the bound
> > > > socket,
> > > > so it might make sense.
> > > 
> > > Yes I don't think this is gonna cause more trouble, but at least we
> > > cannot end up in this weird situation I described.
> > 
> > Okay, but in the host, we can't trust the guest to answer, we should
> > handle this case properly.
> 
> Well I cannot agree more with the "we cannot trust the guest"
> philosophy, but in this case the worst thing that can happen is the
> guest shooting himself in the foot because it would simply prevent the
> connection from happening.
> 
> And I agree setting up a timeout from the host side is still a good
> idea for preventing from such DOS attack.
> 
> But as I mentioned above, in the normal use case, this allows for
> better responsiveness when it comes to establish the connection as fast
> as possible.

Sure, maybe you can rewrite a bit the commit (title and body) to explain
this.

> 
> > 
> > > I was just not sure if the function we should use to do the reset
> > > should be virtio_transport_reset_no_sock() or
> > > virtio_transport_reset()
> > > since at this point the socket is already bound.
> > 
> > I think you can safely use virtio_transport_reset() in this case.
> 
> I've just tried it and unfortunately it doesn't work. I think that's
> because the connection has not been properly established yet, so we
> cannot consider being in this case.
> Using virtio_transport_reset_no_sock() seems like the less intrusive
> function here.

Oh sorry, I also put a comment on virtio_transport_reset() to say to use it
only on connected sockets and not listeners.
In this case it's a listener, sorry for the wrong suggestion.

Thanks,
Stefano

