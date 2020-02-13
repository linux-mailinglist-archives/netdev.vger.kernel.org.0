Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2D315C941
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 18:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgBMRO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 12:14:59 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51456 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728089AbgBMRO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 12:14:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581614097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ST2CLJ0H82FNDZtznzOuYwg1vhJglQoq0jGLrw6wI+4=;
        b=gsIH3wiwbAr2JjgVMGBjNog1wENcoJViqYlO2Yfzy2xCKzQiBuumO8mHqeZCuSyglbS9RD
        v4h+DFe9Aejd+P/+9/oXriNK0jATVQ0NP6whE34Z98bNTfHJbK+sGljdRemdhpHMspODVD
        9GP8Y4PRnuGfFFdr/0kWSCUjFGDgqUU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-j066IN0UNCa99rBEHr3DJg-1; Thu, 13 Feb 2020 12:14:53 -0500
X-MC-Unique: j066IN0UNCa99rBEHr3DJg-1
Received: by mail-wr1-f72.google.com with SMTP id m15so2586443wrs.22
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 09:14:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ST2CLJ0H82FNDZtznzOuYwg1vhJglQoq0jGLrw6wI+4=;
        b=c1okGIdqNRtpymZIMD9SxNczqU4DRwD/FLdKkAjih+sGuLejUdmqs6LirhDkmKBSmz
         rhH8/HnccXDZiWfPUsqEWAvuwvBbaQLxJfNG7PGeNLKTpJ7/Ak2E3XIlJ2FPXXIurU85
         kfve0oMLhT26opRFnV4QmRsLoO5gXFPwwcga0ARs66S8PoxGtQxLitvTOTvuyXUC7pwK
         v3mjljCSX0kYZ8/N1CJEDHvaGfFpjz0oEFnWAr+PD4eGnxwE0ACij9vp2bOthfEvq1Pd
         zHXcrxe7h5hJsBh4da2rJqylUdKQ8RFe67+LDr4/0YrHWeEg53YaErtRUa4tOHzQKorh
         FpgA==
X-Gm-Message-State: APjAAAVJdr82PyAnuayFDqJ3vLrH9sJf3gcWM8rlS/VdC72bF0Ned05W
        iAlY37DdcLru8R0VddJ9dhQ8Zh1xw0KMccHvM7Oc75dftDX4LLXKpMpfTv41VCR3VFuBtEHIgRk
        edStlUtyfMGaGs6kR
X-Received: by 2002:adf:e483:: with SMTP id i3mr22197446wrm.215.1581614091916;
        Thu, 13 Feb 2020 09:14:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqxd59gPxIuCxQnOaD0ZgBTfL3xi7/72QWvWt0pIVGEStJ7+Hgj7FSFhGdAhvaQter9A1Bq6OA==
X-Received: by 2002:adf:e483:: with SMTP id i3mr22197430wrm.215.1581614091669;
        Thu, 13 Feb 2020 09:14:51 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id c77sm3749441wmd.12.2020.02.13.09.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 09:14:51 -0800 (PST)
Date:   Thu, 13 Feb 2020 18:14:48 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Cc:     "stefanha@redhat.com" <stefanha@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] net: virtio_vsock: Fix race condition between bind and
 listen
Message-ID: <CAGxU2F6v99haTtnGP8FT-GKuDEG03uDip+L-NFe3yFZJt7jUxQ@mail.gmail.com>
References: <668b0eda8823564cd604b1663dc53fbaece0cd4e.camel@intel.com>
 <20200213094130.vehzkr4a3pnoiogr@steredhat>
 <3448e588f11dad913e93dfce8031fbd60ba4c85b.camel@intel.com>
 <20200213102237.uyhfv5g2td5ayg2b@steredhat>
 <1d4c3958d8b75756341548e7d51ccf42397c2d27.camel@intel.com>
 <20200213113949.GA544499@stefanha-x1.localdomain>
 <20200213130458.ugu6rx6cv4k6v5rh@steredhat>
 <ee9a929c3b9c5b958bf6399a5048a3c9b6ea4aae.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee9a929c3b9c5b958bf6399a5048a3c9b6ea4aae.camel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 5:51 PM Boeuf, Sebastien <sebastien.boeuf@intel.com> wrote:
>
> On Thu, 2020-02-13 at 14:04 +0100, Stefano Garzarella wrote:
> > On Thu, Feb 13, 2020 at 11:39:49AM +0000, Stefan Hajnoczi wrote:
> > > On Thu, Feb 13, 2020 at 10:44:18AM +0000, Boeuf, Sebastien wrote:
> > > > On Thu, 2020-02-13 at 11:22 +0100, Stefano Garzarella wrote:
> > > > > On Thu, Feb 13, 2020 at 09:51:36AM +0000, Boeuf, Sebastien
> > > > > wrote:
> > > > > > Hi Stefano,
> > > > > >
> > > > > > On Thu, 2020-02-13 at 10:41 +0100, Stefano Garzarella wrote:
> > > > > > > Hi Sebastien,
> > > > > > >
> > > > > > > On Thu, Feb 13, 2020 at 09:16:11AM +0000, Boeuf, Sebastien
> > > > > > > wrote:
> > > > > > > > From 2f1276d02f5a12d85aec5adc11dfe1eab7e160d6 Mon Sep 17
> > > > > > > > 00:00:00
> > > > > > > > 2001
> > > > > > > > From: Sebastien Boeuf <sebastien.boeuf@intel.com>
> > > > > > > > Date: Thu, 13 Feb 2020 08:50:38 +0100
> > > > > > > > Subject: [PATCH] net: virtio_vsock: Fix race condition
> > > > > > > > between
> > > > > > > > bind
> > > > > > > > and listen
> > > > > > > >
> > > > > > > > Whenever the vsock backend on the host sends a packet
> > > > > > > > through
> > > > > > > > the
> > > > > > > > RX
> > > > > > > > queue, it expects an answer on the TX queue.
> > > > > > > > Unfortunately,
> > > > > > > > there
> > > > > > > > is one
> > > > > > > > case where the host side will hang waiting for the answer
> > > > > > > > and
> > > > > > > > will
> > > > > > > > effectively never recover.
> > > > > > >
> > > > > > > Do you have a test case?
> > > > > >
> > > > > > Yes I do. This has been a bug we've been investigating on
> > > > > > Kata
> > > > > > Containers for quite some time now. This was happening when
> > > > > > using
> > > > > > Kata
> > > > > > along with Cloud-Hypervisor (which rely on the hybrid vsock
> > > > > > implementation from Firecracker). The thing is, this bug is
> > > > > > very
> > > > > > hard
> > > > > > to reproduce and was happening for Kata because of the
> > > > > > connection
> > > > > > strategy. The kata-runtime tries to connect a million times
> > > > > > after
> > > > > > it
> > > > > > started the VM, just hoping the kata-agent will start to
> > > > > > listen
> > > > > > from
> > > > > > the guest side at some point.
> > > > >
> > > > > Maybe is related to something else. I tried the following which
> > > > > should be
> > > > > your case simplified (IIUC):
> > > > >
> > > > > guest$ python
> > > > >     import socket
> > > > >     s = socket.socket(socket.AF_VSOCK, socket.SOCK_STREAM)
> > > > >     s.bind((socket.VMADDR_CID_ANY, 1234))
> > > > >
> > > > > host$ python
> > > > >     import socket
> > > > >     s = socket.socket(socket.AF_VSOCK, socket.SOCK_STREAM)
> > > > >     s.connect((3, 1234))
> > > > >
> > > > > Traceback (most recent call last):
> > > > >   File "<stdin>", line 1, in <module>
> > > > > TimeoutError: [Errno 110] Connection timed out
> > > >
> > > > Yes this is exactly the simplified case. But that's the point, I
> > > > don't
> > > > think the timeout is the best way to go here. Because this means
> > > > that
> > > > when we run into this case, the host side will wait for quite
> > > > some time
> > > > before retrying, which can cause a very long delay before the
> > > > communication with the guest is established. By simply answering
> > > > the
> > > > host with a RST packet, we inform it that nobody's listening on
> > > > the
> > > > guest side yet, therefore the host side will close and try again.
> > >
> > > My expectation is that TCP/IP will produce ECONNREFUSED in this
> > > case but
> > > I haven't checked.  Timing out is weird behavior.
> >
> > I just tried and yes, TCP/IP produces ECONNREFUSED. The same error
> > returned
> > when no one's bound to the port.
> >
> > Instead virtio-vsock returns ECONNRESET in the last case.
> > I'm not sure it's correct (looking at the man page connect(2) it
> > would
> > seem not), but if I understood correctly VMCI returns the same
> > ECONNRESET in this case.
> >
> > > In any case, the reference for virtio-vsock semantics is:
> > > 1. How does VMCI (VMware) vsock behave?  We strive to be compatible
> > > with
> > > the VMCI transport.
> >
> > Looking at the code, it looks like VMCI returns ECONNRESET in this
> > case,
> > so this patch should be okay. (I haven't tried it)
> >
> > > 2. If there is no clear VMCI behavior, then we look at TCP/IP
> > > because
> > > those semantics are expected by most applications.
> > >
> > > This bug needs a test case in tools/testings/vsock/ and that test
> > > case
> > > will run against VMCI, virtio-vsock, and Hyper-V.  Doing that will
> > > answer the question of how VMCI handles this case.
> >
> > I agree.
>
> I'm trying to write the test but I'm kinda stuck as I have no way to

Great!

> ensure the proper timing between the test on the server(guest) and the
> test on from the client(host).
>
> Basically I was thinking about creating a new test reusing
> test_stream_connection_reset() from vsock_test.c. The reused function
> would be used for the run_client callback, while I would define a new
> function for the run_server. I wanted to basically do a bind only, and
> don't go up to the listen/accept calls.
> Problem is, the server won't block after the bind is done, and I don't
> know how much the test should wait between the bind and the end.
> I would like to show that even when the server reaches the point where
> the socket is bound, the connect will still return with ECONNRESET. The
> same test without the patch would simply hang till we hit the timeout
> on the client side.
> Does that make sense? And how much time should I wait for after the
> bind on the server side?

You can use control_writeln() and control_expectln() from control.c to
syncronize server and client. The control path uses a TCP/IP socket.

You can do something like this:

server                           client

s = socket();                    s = socket();
bind(s, ...);
control_writeln("BIND");
                                 control_expectln("BIND");
                                 connect(s, ...);
                                 # check ret and errno
                                 control_writeln("DONE");
control_expectln("DONE");
close(s);                        close(s);

Cheers,
Stefano

