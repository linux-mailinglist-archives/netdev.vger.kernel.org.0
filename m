Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90F02D6DEE
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 03:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391865AbgLKCCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 21:02:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:53166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391697AbgLKCBy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 21:01:54 -0500
Date:   Thu, 10 Dec 2020 18:01:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607652070;
        bh=U3G+zi7pmaYGKuSH8xCXbxcIkSxlzauUGmc+rVx93Kc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=jU1hEJtdDilAgpRuotPOe5kC6RiSjucat+/ZOh8js0NC2U58tJ57d77obbN0CK3Fd
         eEq3hsegQcNn3dL46R4fesrcCziiB4gXybrFOgvVldlFmrqf3318EQhK7XSHFnSt3e
         rwnY4eJHpQwCtaU/vtJqvl6mU2efLX99NxH6PaXAndxsYjZZFTE4SykYIzsLlWJbJ7
         Dq1zYme95OODaaLuH+d9StH0FdpN9Th5E1g642p09gro4/+Svh+iQ7mbMS4zsOby7c
         qIprwoxYuBFG/YojcP05pEU4T8PIT66Llhrz26qnd00MQEKup1fbppXWTbHOnd0gsg
         FLEN1bfid9OPg==
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
Message-ID: <20201210180108.3eb24f2b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <921a110f-60fa-a711-d386-39eeca52199f@gmail.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
        <20201207210649.19194-3-borisp@mellanox.com>
        <6f48fa5d-465c-5c38-ea45-704e86ba808b@gmail.com>
        <f52a99d2-03a4-6e9f-603e-feba4aad0512@gmail.com>
        <65dc5bba-13e6-110a-ddae-3d0c260aa875@gmail.com>
        <ab298844-c95e-43e6-b4bb-fe5ce78655d8@gmail.com>
        <921a110f-60fa-a711-d386-39eeca52199f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Dec 2020 21:26:05 -0700 David Ahern wrote:
> Yes, TCP is a byte stream, so the packets could very well show up like this:
> 
>  +--------------+---------+-----------+---------+--------+-----+
>  | data - seg 1 | PDU hdr | prev data | TCP hdr | IP hdr | eth |
>  +--------------+---------+-----------+---------+--------+-----+
>  +-----------------------------------+---------+--------+-----+
>  |     payload - seg 2               | TCP hdr | IP hdr | eth |
>  +-----------------------------------+---------+--------+-----+
>  +-------- +-------------------------+---------+--------+-----+
>  | PDU hdr |    payload - seg 3      | TCP hdr | IP hdr | eth |
>  +---------+-------------------------+---------+--------+-----+
> 
> If your hardware can extract the NVMe payload into a targeted SGL like
> you want in this set, then it has some logic for parsing headers and
> "snapping" an SGL to a new element. ie., it already knows 'prev data'
> goes with the in-progress PDU, sees more data, recognizes a new PDU
> header and a new payload. That means it already has to handle a
> 'snap-to-PDU' style argument where the end of the payload closes out an
> SGL element and the next PDU hdr starts in a new SGL element (ie., 'prev
> data' closes out sgl[i], and the next PDU hdr starts sgl[i+1]). So in
> this case, you want 'snap-to-PDU' but that could just as easily be 'no
> snap at all', just a byte stream and filling an SGL after the protocol
> headers.

This 'snap-to-PDU' requirement is something that I don't understand
with the current TCP zero copy. In case of, say, a storage application
which wants to send some headers (whatever RPC info, block number,
etc.) and then a 4k block of data - how does the RX side get just the
4k block a into a page so it can zero copy it out to its storage device?

Per-connection state in the NIC, and FW parsing headers is one way,
but I wonder how this record split problem is best resolved generically.
Perhaps by passing hints in the headers somehow?

Sorry for the slight off-topic :)
