Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4C82C877C
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 16:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgK3POa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 10:14:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726826AbgK3PO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 10:14:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606749183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/MePX1ZszYuvuFQZo3H/Mi1gp+EM28WbYjn/W27p3a8=;
        b=NZrIOZ9+MIReqxuzqDFyiLrxz4AA3IZCJ6fhkpkhY/NCdkzoRd1zIsVw1Ckq/zubLcO2iR
        s0JssDEMAhTDxeeaemt5yPC+wwnKW7UsjesKOYVwvYp5BZn2QmOGkEs7NIKJaY6vxywUKe
        bwcznPEMW1+KFoI94wZPDlV344NcRvc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-6rgHHd03OQ6nJDcejc31PA-1; Mon, 30 Nov 2020 10:13:01 -0500
X-MC-Unique: 6rgHHd03OQ6nJDcejc31PA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6BA6190A7BA;
        Mon, 30 Nov 2020 15:12:58 +0000 (UTC)
Received: from carbon (unknown [10.36.110.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A6AD19C44;
        Mon, 30 Nov 2020 15:12:49 +0000 (UTC)
Date:   Mon, 30 Nov 2020 16:12:49 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        brouer@redhat.com
Subject: Re: [PATCHv2 bpf-next] samples/bpf: add xdp program on egress for
 xdp_redirect_map
Message-ID: <20201130161249.18f7ca43@carbon>
In-Reply-To: <20201130131020.GC277949@localhost.localdomain>
References: <20201110124639.1941654-1-liuhangbin@gmail.com>
        <20201126084325.477470-1-liuhangbin@gmail.com>
        <54642499-57d7-5f03-f51e-c0be72fb89de@fb.com>
        <20201130075107.GB277949@localhost.localdomain>
        <20201130103208.6d5305e2@carbon>
        <20201130131020.GC277949@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 21:10:20 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> On Mon, Nov 30, 2020 at 10:32:08AM +0100, Jesper Dangaard Brouer wrote:
> > > I plan to write a example about vlan header modification based on egress
> > > index. I will post the patch later.  
> > 
> > I did notice the internal thread you had with Toke.  I still think it
> > will be more simple to modify the Ethernet mac addresses.  Adding a
> > VLAN id tag is more work, and will confuse benchmarks.  You are  
> 
> I plan to only modify the vlan id if there has. 

This sentence is not complete, but because of the internal thread I
know/assume that you mean, that you will only modify the vlan id if
there is already another VLAN tag in the packet. Let me express that
this is not good enough. This is not a feasible choice.

> If you prefer to modify the mac address, which way you'd like? Set
> src mac to egress interface's MAC?

Yes, that will be a good choice, to use the src mac from the egress
interface.  This would simulate part of what is needed for L3/routing.

Can I request that the dst mac is will be the incoming src mac?
Or if you are user-friendly add option that allows to set dst mac.

This is close to what swap-MAC (swap_src_dst_mac) is used for.  Let me
explain in more details, why this is practical.  It is practical
because then the Ethernet frame will be a valid frame that is received
by the sending interface.  Thus, if you redirect back same interface
(like XDP_TX, but testing xdp_do_redirect code) then you can check on
traffic generator if all frames were actually forwarded.  This is
exactly what the Red Hat performance team's Trex packet generator setup
does to validate and find the zero-loss generator rate.


> > As Alexei already pointed out, you assignment is to modify the packet
> > in the 2nd devmap XDP-prog.  Why: because you need to realize that this
> > will break your approach to multicast in your previous patchset.
> > (Yes, the offlist patch I gave you, that move running 2nd devmap
> > XDP-prog to a later stage, solved this packet-modify issue).  
> 
> BTW, it looks with your patch, the counter on egress would make more sense.
> Should I add the counter after your patch posted?

As I tried to explain.  Regardless, I want a counter that counts the
times the 2nd devmap attached XDP-program runs.  This is not a counter
that counts egress packets.  This is a counter that show that the 2nd
devmap attached XDP-program is running.  I don't know how to make this
more clear.

We do need ANOTHER counter that report how many packets are transmitted
on the egress device.  I'm thinking we can simply read:

 /sys/class/net/mlx5p1/statistics/tx_packets

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

