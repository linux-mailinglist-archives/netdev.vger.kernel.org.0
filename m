Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C01C1410E3
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 19:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgAQShX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 13:37:23 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34581 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726603AbgAQShX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 13:37:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579286241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cLTS+/3Ohbu8u/u6hwQjq6amgnE2zZD2tJdjwtHQ7Mg=;
        b=g1VGS5LkPFQE8n3GFRwRHc5eqFmgwrBpkABfagaVbRorWRA1B1usvIcuOATbhRQuSr4cRO
        uC5D/6aJ+TQ/mB9qY8LUgma0ceUDAv/M9m7ABQWZC0FJoOx9lwltpEdlkbbL4Iw67QW9ks
        mn3KkUjj4ynx3AixgH6JjONL+nRLPBg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-nXvgQ28bOsiGPhU4uJUwfA-1; Fri, 17 Jan 2020 13:37:20 -0500
X-MC-Unique: nXvgQ28bOsiGPhU4uJUwfA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71CC014E2;
        Fri, 17 Jan 2020 18:37:19 +0000 (UTC)
Received: from ovpn-118-117.ams2.redhat.com (unknown [10.36.118.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4082881200;
        Fri, 17 Jan 2020 18:37:18 +0000 (UTC)
Message-ID: <ccba63296f3e2b736c16e19f8ab5cbf60f648457.camel@redhat.com>
Subject: Re: [PATCH net 3/3] udp: avoid bulk memory scheduling on memory
 pressure.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 17 Jan 2020 19:37:17 +0100
In-Reply-To: <e1417ad9-8c2f-7640-4bed-96aa753f28f3@gmail.com>
References: <cover.1579281705.git.pabeni@redhat.com>
         <749f8a12b2caf634249e7590597f0c53e5b37c7a.1579281705.git.pabeni@redhat.com>
         <e1417ad9-8c2f-7640-4bed-96aa753f28f3@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 2020-01-17 at 09:51 -0800, Eric Dumazet wrote:
> On 1/17/20 9:27 AM, Paolo Abeni wrote:
> > Williem reported that after commit 0d4a6608f68c ("udp: do rmem bulk
> > free even if the rx sk queue is empty") the memory allocated by
> > an almost idle system with many UDP sockets can grow a lot.
> > 
> > This change addresses the issue enabling memory pressure tracking
> > for UDP and flushing the fwd allocated memory on dequeue if the
> > UDP protocol is under memory pressure.
> > 
> > Note that with this patch applied, the system allocates more
> > liberally memory for UDP sockets while the total memory usage is
> > below udp_mem[1], while the vanilla kernel would allow at most a
> > single page per socket when UDP memory usage goes above udp_mem[0]
> > - see __sk_mem_raise_allocated().
> > 
> > Reported-and-diagnosed-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > Fixes: commit 0d4a6608f68c ("udp: do rmem bulk free even if the rx sk queue is empty")

Thank you for the feedback.

> Not a proper Fixes: tag
> 
> Frankly I would rather revert this patch, unless you show how much things were improved.

unpatched version:

# ensure we will hit memory pressure
echo "5000 10000 20000" > /proc/sys/net/ipv4/udp_mem

# run the repro from Willem
./repro.py

# it get stuck after opening a bunch of sockets, because
# __udp_enqueue_schedule_skb() hits the memory limit
# and packets are dropped.

patched kernel:
echo "5000 10000 20000" > /proc/sys/net/ipv4/udp_mem
./repro.py
# completes successfully, output trimmed
sockets: used 10179
TCP: inuse 4 orphan 0 tw 0 alloc 7 mem 1
UDP: inuse 4 mem 19860
UDPLITE: inuse 0
RAW: inuse 0
FRAG: inuse 0 memory 0

To complete successfully with an unpatched kernel the reproducer
requires memory limits 1 or 2 order of magnitude greaters.

> Where in the UDP code the forward allocations will be released while udp_memory_pressure
> is hit ?

fwd memory is released by udp_rmem_release(), so every time some
process tries to read from any UDP socket. Surely less effective than
the TCP infrastructure, but that other option looks overkill for UDP?!?

Thanks,

Paolo

