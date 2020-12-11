Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF372D7E70
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 19:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389331AbgLKSrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 13:47:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388009AbgLKSq3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 13:46:29 -0500
Date:   Fri, 11 Dec 2020 10:45:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607712348;
        bh=vq7bQM3DXTCBGxuTRrXjVx4jcyD7Jiq6JLDy65/2dbY=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=JECrMjjthufSyLYA3in7PoJvwcOIxZTdx6yQGryDlx73zqhkhTSq6aTpfhwQHZcUH
         ZkFDePlVsbOx3fTnn54CXPi3/WrnvKBKZCUji5JErN1og0Th6bNgUqSopADarsYyLb
         1YG1llHixG0UkkDloYRY4vY4aY5eL8xSDiTmqqi+BIYHkFf2YTnfyVesHfgCRxdHfM
         QUYqCdzTUYWWq03Jb9fxQkzKFaQrg+yO/mERelymOGYNhSS+UGhJ5jIKODcb3dbrFm
         5Xnkt2MtugzKSE9qO2RqL95jyaRU3cmoyonlQ2Rc7VE0UNcFwVocJEuoy4MNr4E+pI
         TE1psYP4YZ3ig==
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Boris Pismenny <borispismenny@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, davem@davemloft.net,
        saeedm@nvidia.com, hch@lst.de, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: Re: [PATCH v1 net-next 02/15] net: Introduce direct data placement
 tcp offload
Message-ID: <20201211104445.30684242@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5cadcfa0-b992-f124-f006-51872c86b804@gmail.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-3-borisp@mellanox.com>
 <6f48fa5d-465c-5c38-ea45-704e86ba808b@gmail.com>
 <f52a99d2-03a4-6e9f-603e-feba4aad0512@gmail.com>
 <65dc5bba-13e6-110a-ddae-3d0c260aa875@gmail.com>
 <ab298844-c95e-43e6-b4bb-fe5ce78655d8@gmail.com>
 <921a110f-60fa-a711-d386-39eeca52199f@gmail.com>
 <20201210180108.3eb24f2b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <5cadcfa0-b992-f124-f006-51872c86b804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Dec 2020 19:43:57 -0700 David Ahern wrote:
> On 12/10/20 7:01 PM, Jakub Kicinski wrote:
> > On Wed, 9 Dec 2020 21:26:05 -0700 David Ahern wrote:  
> >> Yes, TCP is a byte stream, so the packets could very well show up like this:
> >>
> >>  +--------------+---------+-----------+---------+--------+-----+
> >>  | data - seg 1 | PDU hdr | prev data | TCP hdr | IP hdr | eth |
> >>  +--------------+---------+-----------+---------+--------+-----+
> >>  +-----------------------------------+---------+--------+-----+
> >>  |     payload - seg 2               | TCP hdr | IP hdr | eth |
> >>  +-----------------------------------+---------+--------+-----+
> >>  +-------- +-------------------------+---------+--------+-----+
> >>  | PDU hdr |    payload - seg 3      | TCP hdr | IP hdr | eth |
> >>  +---------+-------------------------+---------+--------+-----+
> >>
> >> If your hardware can extract the NVMe payload into a targeted SGL like
> >> you want in this set, then it has some logic for parsing headers and
> >> "snapping" an SGL to a new element. ie., it already knows 'prev data'
> >> goes with the in-progress PDU, sees more data, recognizes a new PDU
> >> header and a new payload. That means it already has to handle a
> >> 'snap-to-PDU' style argument where the end of the payload closes out an
> >> SGL element and the next PDU hdr starts in a new SGL element (ie., 'prev
> >> data' closes out sgl[i], and the next PDU hdr starts sgl[i+1]). So in
> >> this case, you want 'snap-to-PDU' but that could just as easily be 'no
> >> snap at all', just a byte stream and filling an SGL after the protocol
> >> headers.  
> > 
> > This 'snap-to-PDU' requirement is something that I don't understand
> > with the current TCP zero copy. In case of, say, a storage application  
> 
> current TCP zero-copy does not handle this and it can't AFAIK. I believe
> it requires hardware level support where an Rx queue is dedicated to a
> flow / socket and some degree of header and payload splitting (header is
> consumed by the kernel stack and payload goes to socket owner's memory).

Yet, Google claims to use the RX ZC in production, and with a CX3 Pro /
mlx4 NICs.

Simple workaround that comes to mind is have the headers and payloads
on separate TCP streams. That doesn't seem too slick.. but neither is
the 4k MSS, so maybe that's what Google does?

> > which wants to send some headers (whatever RPC info, block number,
> > etc.) and then a 4k block of data - how does the RX side get just the
> > 4k block a into a page so it can zero copy it out to its storage device?
> > 
> > Per-connection state in the NIC, and FW parsing headers is one way,
> > but I wonder how this record split problem is best resolved generically.
> > Perhaps by passing hints in the headers somehow?
> > 
> > Sorry for the slight off-topic :)
> >   
> Hardware has to be parsing the incoming packets to find the usual
> ethernet/IP/TCP headers and TCP payload offset. Then the hardware has to
> have some kind of ULP processor to know how to parse the TCP byte stream
> at least well enough to find the PDU header and interpret it to get pdu
> header length and payload length.

The big difference between normal headers and L7 headers is that one is
at ~constant offset, self-contained, and always complete (PDU header
can be split across segments).

Edwin Peer did an implementation of TLS ULP for the NFP, it was
complex. Not to mention it's L7 protocol ossification.

To put it bluntly maybe it's fine for smaller shops but I'm guessing
it's going to be a hard sell to hyperscalers and people who don't like
to be locked in to HW.

> At that point you push the protocol headers (eth/ip/tcp) into one buffer
> for the kernel stack protocols and put the payload into another. The
> former would be some page owned by the OS and the latter owned by the
> process / socket (generically, in this case it is a kernel level
> socket). In addition, since the payload is spread across multiple
> packets the hardware has to keep track of TCP sequence number and its
> current place in the SGL where it is writing the payload to keep the
> bytes contiguous and detect out-of-order.
> 
> If the ULP processor knows about PDU headers it knows when enough
> payload has been found to satisfy that PDU in which case it can tell the
> cursor to move on to the next SGL element (or separate SGL). That's what
> I meant by 'snap-to-PDU'.
> 
> Alternatively, if it is any random application with a byte stream not
> understood by hardware, the cursor just keeps moving along the SGL
> elements assigned it for this particular flow.
> 
> If you have a socket whose payload is getting offloaded to its own queue
> (which this set is effectively doing), you can create the queue with
> some attribute that says 'NVMe ULP', 'iscsi ULP', 'just a byte stream'
> that controls the parsing when you stop writing to one SGL element and
> move on to the next. Again, assuming hardware support for such attributes.
> 
> I don't work for Nvidia, so this is all supposition based on what the
> patches are doing.

Ack, these patches are not exciting (to me), so I'm wondering if there
is a better way. The only reason NIC would have to understand a ULP for
ZC is to parse out header/message lengths. There's gotta be a way to
pass those in header options or such...

And, you know, if we figure something out - maybe we stand a chance
against having 4 different zero copy implementations (this, TCP,
AF_XDP, netgpu) :(
