Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F1F30BBF7
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 11:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBBKUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 05:20:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46021 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229483AbhBBKUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 05:20:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612261124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RmJ/G6EA66t96nbY9N8Io7dTd26aYtR+D4uaVhjBc7w=;
        b=LvPn43p8rRVgN3e+4ZNk9J7DL789VuskfiJyWCK1mJlowVY4xeFnEcTjtm/kFfD//cxef2
        /xg9JfYaPEk5zRr8pCsRHYKR4/oiDDU+G/vGncvV/QJSBLP/Rndmxv50v1o2g9PCDjDwD6
        Cqw0SQrhDvOxMu9AkcKaXQRWjiq4ojM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-kAaaqFZUNLK9Uk1JMI6LSA-1; Tue, 02 Feb 2021 05:18:41 -0500
X-MC-Unique: kAaaqFZUNLK9Uk1JMI6LSA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9ADAA801B12;
        Tue,  2 Feb 2021 10:18:40 +0000 (UTC)
Received: from ovpn-115-101.ams2.redhat.com (ovpn-115-101.ams2.redhat.com [10.36.115.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 742F060BE5;
        Tue,  2 Feb 2021 10:18:39 +0000 (UTC)
Message-ID: <a24db624cb6b2df98e95b18bbcd55eca53c116ae.camel@redhat.com>
Subject: Re: make sendmsg/recvmsg process multiple messages at once
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Menglong Dong <menglong8.dong@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Date:   Tue, 02 Feb 2021 11:18:38 +0100
In-Reply-To: <20210201200733.4309ef71@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <CADxym3ba8R6fN3O5zLAw-e7q0gjFxBd_WUKjq0hTP+JpAbJEKg@mail.gmail.com>
         <20210201200733.4309ef71@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-02-01 at 20:07 -0800, Jakub Kicinski wrote:
> On Mon, 1 Feb 2021 20:41:45 +0800 Menglong Dong wrote:
> > I am thinking about making sendmsg/recvmsg process multiple messages
> > at once, which is possible to reduce the number of system calls.
> > 
> > Take the receiving of udp as an example, we can copy multiple skbs to
> > msg_iov and make sure that every iovec contains a udp package.
> > 
> > Is this a good idea? This idea seems clumsy compared to the incoming
> > 'io-uring' based zerocopy, but maybe it can help...

Indeed since the introduction of some security vulnerability
mitigation, syscall overhead is relevant and amortizing it with bulk
operations gives very measurable performances gain.

Potentially bulk operation also reduce RETPOLINE overhead, but AFAICS
all the indirect calls in the relevant code path has been already
mitigated with the indirect call wrappers.

Note that you can already process several packets with a single syscall
using sendmmsg/recvmmsg. Both have issues with error reporting and
timeout and IIRC still don't amortize the overhead introduced e.g. by
CONFIG_HARDENED_USERCOPY.

Additionally, recvmmsg/sendmmsg are not cache-friendly. As noted by
Eric long time ago:

https://marc.info/?l=linux-netdev&m=148010858826712&w=2

perf tests in lab with recvmmsg/sendmmsg could be great, but
performance with real workload much less. You could try fine-tuning the
bulk size (mmsg nr) for your workload and H/W. Likely a burst size
above 8 is a no go.

For the TX path there is already a better option - for some specific
workload - using UDP_SEGMENT.

In the RX path, for bulk transfer, you could try enabling UDP_GRO.

As far as I can see, the idea you are proposing will be quite
alike recvmmsg(), with the possible additional benefit of bulk dequeue
from the UDP receive queue. Note that this latter optimization, since
commmit 2276f58ac5890, will give very little perfomance gain.

In the TX path there is no lock at all for the uncorking case, so the
performance gain should come only from the bulk syscall.

You will probably also need to cope with cmsg and msgname, so overall I
don't see much differences from recvmmsg()/sendmmsg(), did I misread
something?

Thanks!

Paolo

