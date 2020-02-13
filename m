Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FABF15BEED
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 14:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbgBMNFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 08:05:07 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46809 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729557AbgBMNFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 08:05:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581599105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1mq5klN3+WoTH1K92zwePu0E14H5UOkpkSxrnP4PktE=;
        b=M2nknZeCq4B14MbKpKMAC08kATBY6n/U3/lnaVeZ36kiK61jh6+qmjk1N1pe75Bm8+khBa
        AOaUNxRl2AHnQeALY3Y04WEm1SU+ugxLN3iSGvOwTxbAGcEpCljUpW5dbLvIL5VCo4xG3c
        BO6D4iHxbE09mjJ78kqXJQ0i8hjhBus=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-_Nq1F4f_O7Oy2WWchmXu8Q-1; Thu, 13 Feb 2020 08:05:03 -0500
X-MC-Unique: _Nq1F4f_O7Oy2WWchmXu8Q-1
Received: by mail-wr1-f69.google.com with SMTP id 90so2304108wrq.6
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 05:05:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1mq5klN3+WoTH1K92zwePu0E14H5UOkpkSxrnP4PktE=;
        b=NQUeEN5rZOZqaYQ2hML7QIKle7d68JLuy+nZvLgVeca6r1o+K4ILovwknX8yqVRr6P
         DbxF0+ACDrOHb0qoaOSjV7hdNbBVondPA5c1qGMQd2MFvN0SsJa2ZHqvMcHvMW7W4Je4
         sPlSp5Xohvd4s9k3MXpLZkQd0UpLYrGthCCinhYTFYH0kdDGkwN9XiM005/MpDyfAXBl
         jrP7XupZoyIeEGJJFlUIXQr9QN5r44xxsfaKqJl89La0tqGyyw/CXLtwxOcyD2bcj6Xk
         1AVrQib8cXe9/s/qBd5bEfCIltFnvMvqbT5bglHM8lnJudPAmrH6xRYafLBFUrFk7tyY
         NXeA==
X-Gm-Message-State: APjAAAU5Pp2RnvzGkVnCD9rVzylZhqkAjAvn20HAU0k0mq7fkXOcG4ik
        iEFxXPVkXcDR5EndmxV+S4dDVNl/yzmPkUEN8PrMxJPR0thluJ4wYoJuTJYBuCWLWiGvCqQYWZF
        eYkdOtextZRY/AO1x
X-Received: by 2002:a5d:61d1:: with SMTP id q17mr22103105wrv.156.1581599101757;
        Thu, 13 Feb 2020 05:05:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqz0IKKEr7BFwDoP/ryDKSdYQ/yXOcrIe9C2JpXKl35t0Bc4QPIT2HLCT+Mh/mQcaFNszaqn2g==
X-Received: by 2002:a5d:61d1:: with SMTP id q17mr22103087wrv.156.1581599101514;
        Thu, 13 Feb 2020 05:05:01 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id x21sm2739754wmi.30.2020.02.13.05.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 05:05:01 -0800 (PST)
Date:   Thu, 13 Feb 2020 14:04:58 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     "Boeuf, Sebastien" <sebastien.boeuf@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] net: virtio_vsock: Fix race condition between bind and
 listen
Message-ID: <20200213130458.ugu6rx6cv4k6v5rh@steredhat>
References: <668b0eda8823564cd604b1663dc53fbaece0cd4e.camel@intel.com>
 <20200213094130.vehzkr4a3pnoiogr@steredhat>
 <3448e588f11dad913e93dfce8031fbd60ba4c85b.camel@intel.com>
 <20200213102237.uyhfv5g2td5ayg2b@steredhat>
 <1d4c3958d8b75756341548e7d51ccf42397c2d27.camel@intel.com>
 <20200213113949.GA544499@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213113949.GA544499@stefanha-x1.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 11:39:49AM +0000, Stefan Hajnoczi wrote:
> On Thu, Feb 13, 2020 at 10:44:18AM +0000, Boeuf, Sebastien wrote:
> > On Thu, 2020-02-13 at 11:22 +0100, Stefano Garzarella wrote:
> > > On Thu, Feb 13, 2020 at 09:51:36AM +0000, Boeuf, Sebastien wrote:
> > > > Hi Stefano,
> > > > 
> > > > On Thu, 2020-02-13 at 10:41 +0100, Stefano Garzarella wrote:
> > > > > Hi Sebastien,
> > > > > 
> > > > > On Thu, Feb 13, 2020 at 09:16:11AM +0000, Boeuf, Sebastien wrote:
> > > > > > From 2f1276d02f5a12d85aec5adc11dfe1eab7e160d6 Mon Sep 17
> > > > > > 00:00:00
> > > > > > 2001
> > > > > > From: Sebastien Boeuf <sebastien.boeuf@intel.com>
> > > > > > Date: Thu, 13 Feb 2020 08:50:38 +0100
> > > > > > Subject: [PATCH] net: virtio_vsock: Fix race condition between
> > > > > > bind
> > > > > > and listen
> > > > > > 
> > > > > > Whenever the vsock backend on the host sends a packet through
> > > > > > the
> > > > > > RX
> > > > > > queue, it expects an answer on the TX queue. Unfortunately,
> > > > > > there
> > > > > > is one
> > > > > > case where the host side will hang waiting for the answer and
> > > > > > will
> > > > > > effectively never recover.
> > > > > 
> > > > > Do you have a test case?
> > > > 
> > > > Yes I do. This has been a bug we've been investigating on Kata
> > > > Containers for quite some time now. This was happening when using
> > > > Kata
> > > > along with Cloud-Hypervisor (which rely on the hybrid vsock
> > > > implementation from Firecracker). The thing is, this bug is very
> > > > hard
> > > > to reproduce and was happening for Kata because of the connection
> > > > strategy. The kata-runtime tries to connect a million times after
> > > > it
> > > > started the VM, just hoping the kata-agent will start to listen
> > > > from
> > > > the guest side at some point.
> > > 
> > > Maybe is related to something else. I tried the following which
> > > should be
> > > your case simplified (IIUC):
> > > 
> > > guest$ python
> > >     import socket
> > >     s = socket.socket(socket.AF_VSOCK, socket.SOCK_STREAM)
> > >     s.bind((socket.VMADDR_CID_ANY, 1234))
> > > 
> > > host$ python
> > >     import socket
> > >     s = socket.socket(socket.AF_VSOCK, socket.SOCK_STREAM)
> > >     s.connect((3, 1234))
> > > 
> > > Traceback (most recent call last):
> > >   File "<stdin>", line 1, in <module>
> > > TimeoutError: [Errno 110] Connection timed out
> > 
> > Yes this is exactly the simplified case. But that's the point, I don't
> > think the timeout is the best way to go here. Because this means that
> > when we run into this case, the host side will wait for quite some time
> > before retrying, which can cause a very long delay before the
> > communication with the guest is established. By simply answering the
> > host with a RST packet, we inform it that nobody's listening on the
> > guest side yet, therefore the host side will close and try again.
> 
> My expectation is that TCP/IP will produce ECONNREFUSED in this case but
> I haven't checked.  Timing out is weird behavior.

I just tried and yes, TCP/IP produces ECONNREFUSED. The same error returned
when no one's bound to the port.

Instead virtio-vsock returns ECONNRESET in the last case.
I'm not sure it's correct (looking at the man page connect(2) it would
seem not), but if I understood correctly VMCI returns the same
ECONNRESET in this case.

> 
> In any case, the reference for virtio-vsock semantics is:
> 1. How does VMCI (VMware) vsock behave?  We strive to be compatible with
> the VMCI transport.

Looking at the code, it looks like VMCI returns ECONNRESET in this case,
so this patch should be okay. (I haven't tried it)

> 2. If there is no clear VMCI behavior, then we look at TCP/IP because
> those semantics are expected by most applications.
> 
> This bug needs a test case in tools/testings/vsock/ and that test case
> will run against VMCI, virtio-vsock, and Hyper-V.  Doing that will
> answer the question of how VMCI handles this case.

I agree.

Thanks,
Stefano

