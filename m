Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 504C815BCAD
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 11:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729787AbgBMKWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 05:22:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33712 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729428AbgBMKWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 05:22:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581589363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RJawu5LBgwAxVohobCwtiMac8libpoeqyXYf4pCGO/U=;
        b=evDmWlM+RO3kLBLH8CwGr4/ggkrktJE/THTKnHePrsXpxlhjia92/snRNwpYSKfauBKn3d
        BHBD2qsegCtwvkFWDV75/8KWTwL314xcvbStfDb13Ev6I2XBFO0zs52wZvd9yY9ntIml3y
        rc1cJB9jrkpY2lj4u6st528qnj/VDo8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-SDm4_RPvP0CSO2CviwLP-w-1; Thu, 13 Feb 2020 05:22:42 -0500
X-MC-Unique: SDm4_RPvP0CSO2CviwLP-w-1
Received: by mail-wr1-f72.google.com with SMTP id s13so2133491wrb.21
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 02:22:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RJawu5LBgwAxVohobCwtiMac8libpoeqyXYf4pCGO/U=;
        b=Xkxo9y2dRuN/LClnYxILkGoRnumR/X2d77cUbD9obzbdUjfyAiq1bng7JrwfelCP7Z
         ql6bj5hjVvZxOjJsNYhelGrprb9MY0Iun46ZswMMd6Y5IHvrTjvVZUnd8FSMVgrq9Not
         9+tLyi1NmIxsKBkotP3LdxxTWd818lPFYgIt7xlMoUNmS7FXTSrfFQ3TbQLy2gw+ULBJ
         2ke8154a7Vp99IVIVqmDuNvkFAezmq03uI/LrwOaCusIzKDQqwwDDFYD6O1mqPRx/Khr
         mj2t3zd3FFMg+h/JrsIpQ074ZmbFhMiAY9ECl5rF4Xvmq+ok8000Z9o5gfPen03PbPgO
         pcAw==
X-Gm-Message-State: APjAAAWvM5NVqEDUQgZLwGm0J0fTKp1hCdPVEKqBcGQCRqpyEJcsapxQ
        boN34XtdlmqiVziJ5o8+WZ0Xm+6S5BbKEUO/wLNQvFvj4gta/1FHvnkDC2Bu9X2gsoFYyCh9qU7
        VoZ24J5Oh4AHVzzXz
X-Received: by 2002:a5d:4bd0:: with SMTP id l16mr12774898wrt.271.1581589360770;
        Thu, 13 Feb 2020 02:22:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqxZok+6i5mVstis1EKCru8WK1qHwMGL4SAaqO+UL5gK18nZNhtrmJtJQasQQ7KXoB7x+YVDZw==
X-Received: by 2002:a5d:4bd0:: with SMTP id l16mr12774869wrt.271.1581589360458;
        Thu, 13 Feb 2020 02:22:40 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id d13sm2262196wrc.64.2020.02.13.02.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 02:22:39 -0800 (PST)
Date:   Thu, 13 Feb 2020 11:22:37 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Cc:     "stefanha@redhat.com" <stefanha@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] net: virtio_vsock: Fix race condition between bind and
 listen
Message-ID: <20200213102237.uyhfv5g2td5ayg2b@steredhat>
References: <668b0eda8823564cd604b1663dc53fbaece0cd4e.camel@intel.com>
 <20200213094130.vehzkr4a3pnoiogr@steredhat>
 <3448e588f11dad913e93dfce8031fbd60ba4c85b.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3448e588f11dad913e93dfce8031fbd60ba4c85b.camel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 09:51:36AM +0000, Boeuf, Sebastien wrote:
> Hi Stefano,
> 
> On Thu, 2020-02-13 at 10:41 +0100, Stefano Garzarella wrote:
> > Hi Sebastien,
> > 
> > On Thu, Feb 13, 2020 at 09:16:11AM +0000, Boeuf, Sebastien wrote:
> > > From 2f1276d02f5a12d85aec5adc11dfe1eab7e160d6 Mon Sep 17 00:00:00
> > > 2001
> > > From: Sebastien Boeuf <sebastien.boeuf@intel.com>
> > > Date: Thu, 13 Feb 2020 08:50:38 +0100
> > > Subject: [PATCH] net: virtio_vsock: Fix race condition between bind
> > > and listen
> > > 
> > > Whenever the vsock backend on the host sends a packet through the
> > > RX
> > > queue, it expects an answer on the TX queue. Unfortunately, there
> > > is one
> > > case where the host side will hang waiting for the answer and will
> > > effectively never recover.
> > 
> > Do you have a test case?
> 
> Yes I do. This has been a bug we've been investigating on Kata
> Containers for quite some time now. This was happening when using Kata
> along with Cloud-Hypervisor (which rely on the hybrid vsock
> implementation from Firecracker). The thing is, this bug is very hard
> to reproduce and was happening for Kata because of the connection
> strategy. The kata-runtime tries to connect a million times after it
> started the VM, just hoping the kata-agent will start to listen from
> the guest side at some point.

Maybe is related to something else. I tried the following which should be
your case simplified (IIUC):

guest$ python
    import socket
    s = socket.socket(socket.AF_VSOCK, socket.SOCK_STREAM)
    s.bind((socket.VMADDR_CID_ANY, 1234))

host$ python
    import socket
    s = socket.socket(socket.AF_VSOCK, socket.SOCK_STREAM)
    s.connect((3, 1234))

Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TimeoutError: [Errno 110] Connection timed out

> 
> > 
> > In the host, the af_vsock.c:vsock_stream_connect() set a timeout, so
> > if
> > the host try to connect before the guest starts listening, the
> > connect()
> > should return ETIMEDOUT if the guest does not answer anything.
> > 
> > Anyway, maybe the patch make sense anyway, changing a bit the
> > description
> > (if the host connect() receive the ETIMEDOUT).
> > I'm just concerned that this code is common between guest and host.
> > If a
> > malicious guest starts sending us wrong requests, we spend time
> > sending
> > a reset packet. But we already do that if we can't find the bound
> > socket,
> > so it might make sense.
> 
> Yes I don't think this is gonna cause more trouble, but at least we
> cannot end up in this weird situation I described.

Okay, but in the host, we can't trust the guest to answer, we should
handle this case properly.

> 
> I was just not sure if the function we should use to do the reset
> should be virtio_transport_reset_no_sock() or virtio_transport_reset()
> since at this point the socket is already bound.

I think you can safely use virtio_transport_reset() in this case.

Maybe we can add a test case to the vsock test suite (tools/testing/vsock)
to stress the connect.

Thanks,
Stefano

