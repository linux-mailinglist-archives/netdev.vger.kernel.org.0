Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C9FB3CF3
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 16:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731056AbfIPOy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 10:54:57 -0400
Received: from rs07.intra2net.com ([85.214.138.66]:57598 "EHLO
        rs07.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730902AbfIPOy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 10:54:56 -0400
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Sep 2019 10:54:55 EDT
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rs07.intra2net.com (Postfix) with ESMTPS id EE0641500131;
        Mon, 16 Sep 2019 16:45:34 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id B5563760;
        Mon, 16 Sep 2019 16:45:34 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.100,VDF=8.16.23.112)
X-Spam-Status: 
X-Spam-Level: 0
Received: from localhost (storm.m.i2n [172.16.1.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.m.i2n (Postfix) with ESMTPS id B770D6D6;
        Mon, 16 Sep 2019 16:45:32 +0200 (CEST)
Date:   Mon, 16 Sep 2019 16:45:32 +0200
From:   Thomas Jarosch <thomas.jarosch@intra2net.com>
To:     netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [bisected] UDP / xfrm: NAT-T packets with bad UDP checksum get
 dropped
Message-ID: <20190916144532.kj7mbpfspe3sdlka@intra2net.com>
References: <20190912151353.2w7jakdrqljkfbsq@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912151353.2w7jakdrqljkfbsq@intra2net.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> After a few hours of bisecting with a test VM,
> this commit was identified to cause the packet drop:
> 
> *******************
> commit 0a80966b1043c3e2dc684140f155a3fded308660
> Author: Tom Herbert <therbert@google.com>
> Date:   Wed May 7 16:52:39 2014 -0700
> 
>     net: Verify UDP checksum before handoff to encap
> 
>     Moving validation of UDP checksum to be done in UDP not encap layer.
> 
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index f2d05d7be743..54ea0a3a48f1 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1495,6 +1495,10 @@ int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
>                 if (skb->len > sizeof(struct udphdr) && encap_rcv != NULL) {
>                         int ret;
>  
> +                       /* Verify checksum before giving to encap */
> +                       if (udp_lib_checksum_complete(skb))
> +                               goto csum_error;
> +
>                         ret = encap_rcv(sk, skb);
>                         if (ret <= 0) {
>                                 UDP_INC_STATS_BH(sock_net(sk),
> ..
> *******************
> 
> This commit is part of kernel 3.16. Reverting the commit
> brings back the VPN connection using kernel 4.19.67.

..brings back the VPN connection when there's no iptables firewall involved ^^

As soon as netfilter is active, the packets get eaten again.
I've bisected this down to another commit, basically it's "broken" in 4.19.1
and works with with 4.19 vanilla. The commit in question:

*************************************
# git bisect good
4fb0dc97de1cd79399ab0c556f096d8db2bac278 is the first bad commit
commit 4fb0dc97de1cd79399ab0c556f096d8db2bac278
Author: Sean Tranchetti <stranche@codeaurora.org>
Date:   Tue Oct 23 16:04:31 2018 -0600

    net: udp: fix handling of CHECKSUM_COMPLETE packets

    [ Upstream commit db4f1be3ca9b0ef7330763d07bf4ace83ad6f913 ]

    Current handling of CHECKSUM_COMPLETE packets by the UDP stack is
    incorrect for any packet that has an incorrect checksum value.

    udp4/6_csum_init() will both make a call to
    __skb_checksum_validate_complete() to initialize/validate the csum
    field when receiving a CHECKSUM_COMPLETE packet. When this packet
    fails validation, skb->csum will be overwritten with the pseudoheader
    checksum so the packet can be fully validated by software, but the
    skb->ip_summed value will be left as CHECKSUM_COMPLETE so that way
    the stack can later warn the user about their hardware spewing bad
    checksums. Unfortunately, leaving the SKB in this state can cause
    problems later on in the checksum calculation.

    Since the the packet is still marked as CHECKSUM_COMPLETE,
    udp_csum_pull_header() will SUBTRACT the checksum of the UDP header
    from skb->csum instead of adding it, leaving us with a garbage value
    in that field. Once we try to copy the packet to userspace in the
    udp4/6_recvmsg(), we'll make a call to skb_copy_and_csum_datagram_msg()
    to checksum the packet data and add it in the garbage skb->csum value
    to perform our final validation check.

    Since the value we're validating is not the proper checksum, it's possible
    that the folded value could come out to 0, causing us not to drop the
    packet. Instead, we believe that the packet was checksummed incorrectly
    by hardware since skb->ip_summed is still CHECKSUM_COMPLETE, and we attempt
    to warn the user with netdev_rx_csum_fault(skb->dev);

    Unfortunately, since this is the UDP path, skb->dev has been overwritten
    by skb->dev_scratch and is no longer a valid pointer, so we end up
    reading invalid memory.

    This patch addresses this problem in two ways:
            1) Do not use the dev pointer when calling netdev_rx_csum_fault()
               from skb_copy_and_csum_datagram_msg(). Since this gets called
               from the UDP path where skb->dev has been overwritten, we have
               no way of knowing if the pointer is still valid. Also for the
               sake of consistency with the other uses of
               netdev_rx_csum_fault(), don't attempt to call it if the
               packet was checksummed by software.

            2) Add better CHECKSUM_COMPLETE handling to udp4/6_csum_init().
               If we receive a packet that's CHECKSUM_COMPLETE that fails
               verification (i.e. skb->csum_valid == 0), check who performed
               the calculation. It's possible that the checksum was done in
               software by the network stack earlier (such as Netfilter's
               CONNTRACK module), and if that says the checksum is bad,
               we can drop the packet immediately instead of waiting until
               we try and copy it to userspace. Otherwise, we need to
               mark the SKB as CHECKSUM_NONE, since the skb->csum field
               no longer contains the full packet checksum after the
               call to __skb_checksum_validate_complete().

    Fixes: e6afc8ace6dd ("udp: remove headers from UDP packets before queueing")
    Fixes: c84d949057ca ("udp: copy skb->truesize in the first cache line")
    Cc: Sam Kumar <samanthakumar@google.com>
    Cc: Eric Dumazet <edumazet@google.com>
    Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
*************************************

Reverting this commit and the previously mentioned one
0a80966b1043c3e2dc684140f155a3fded308660
("net: Verify UDP checksum before handoff to encap")
brings back the VPN tunnel using 4.19.57 including the full iptables firewall.
(I had the firewall disabled during my earlier tests)

Given the patch description above, this commit is not something I want to revert.
I tried playing around with the CHECKSUM netfilter target, but it just seems
to fill in missing checksums, not overwrite invalid ones.

My next step is to figure out what brand and model exactly the
"unknown home router" is and if there's a firmware update available.

If it can be fixed by replacing / upgrading the home router, I will go this 
route and cross my fingers this will by a one time VPN tunnel incident
after the major kernel 3.14 -> 4.19 upgrade.

Cheers,
Thomas
