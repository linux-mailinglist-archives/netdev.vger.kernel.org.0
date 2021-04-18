Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03301363693
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 18:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhDRQSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 12:18:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28357 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231684AbhDRQSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 12:18:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618762699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gtqF7+8hdOsOAqsZblGuMHHe5YxbPyqEJw9acCV3MPw=;
        b=V7z/HAw/PwPtEOIkFYmwh2aKhBNuknk8An3HAoTA3tErvLcBETqC9Hq6GGfdREu5B+aS6+
        uw4CbdFD5zh+rZYzlZHUPTCeVibTUjvbzJBgbrchdbJm/9YdZ+U0tDNHcHfFNVLZC4NBL4
        h9WYBWUJ8A2dJVoQRyQ8tWBN18CENaw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-lYJvDT76NgKpzdeP30YW3g-1; Sun, 18 Apr 2021 12:18:15 -0400
X-MC-Unique: lYJvDT76NgKpzdeP30YW3g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4231817469;
        Sun, 18 Apr 2021 16:18:13 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59DD1107D5C6;
        Sun, 18 Apr 2021 16:18:02 +0000 (UTC)
Date:   Sun, 18 Apr 2021 18:18:01 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        lorenzo.bianconi@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        sameehj@amazon.com, John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>, brouer@redhat.com
Subject: Re: [PATCH v8 bpf-next 00/14] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20210418181801.17166935@carbon>
In-Reply-To: <CAJ8uoz1MOYLzyy7xXq_fmpKDEakxSomzfM76Szjr5gWsqHc9jQ@mail.gmail.com>
References: <cover.1617885385.git.lorenzo@kernel.org>
        <CAJ8uoz1MOYLzyy7xXq_fmpKDEakxSomzfM76Szjr5gWsqHc9jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Apr 2021 16:27:18 +0200
Magnus Karlsson <magnus.karlsson@gmail.com> wrote:

> On Thu, Apr 8, 2021 at 2:51 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >
> > This series introduce XDP multi-buffer support. The mvneta driver is
> > the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
> > please focus on how these new types of xdp_{buff,frame} packets
> > traverse the different layers and the layout design. It is on purpose
> > that BPF-helpers are kept simple, as we don't want to expose the
> > internal layout to allow later changes.
> >
> > For now, to keep the design simple and to maintain performance, the XDP
> > BPF-prog (still) only have access to the first-buffer. It is left for
> > later (another patchset) to add payload access across multiple buffers.
> > This patchset should still allow for these future extensions. The goal
> > is to lift the XDP MTU restriction that comes with XDP, but maintain
> > same performance as before.
[...]
> >
> > [0] https://netdevconf.info/0x14/session.html?talk-the-path-to-tcp-4k-mtu-and-rx-zerocopy
> > [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
> > [2] https://netdevconf.info/0x14/session.html?tutorial-add-XDP-support-to-a-NIC-driver (XDPmulti-buffers section)  
> 
> Took your patches for a test run with the AF_XDP sample xdpsock on an
> i40e card and the throughput degradation is between 2 to 6% depending
> on the setup and microbenchmark within xdpsock that is executed. And
> this is without sending any multi frame packets. Just single frame
> ones. Tirtha made changes to the i40e driver to support this new
> interface so that is being included in the measurements.

Could you please share Tirtha's i40e support patch with me?

I would like to reproduce these results in my testlab, in-order to
figure out where the throughput degradation comes from.

> What performance do you see with the mvneta card? How much are we
> willing to pay for this feature when it is not being used or can we in
> some way selectively turn it on only when needed?

Well, as Daniel says performance wise we require close to /zero/
additional overhead, especially as you state this happens when sending
a single frame, which is a base case that we must not slowdown.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

