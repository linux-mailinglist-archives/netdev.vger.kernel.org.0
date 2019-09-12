Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31F73B11E1
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 17:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732931AbfILPN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 11:13:58 -0400
Received: from rp02.intra2net.com ([62.75.181.28]:56536 "EHLO
        rp02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732572AbfILPN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 11:13:58 -0400
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rp02.intra2net.com (Postfix) with ESMTPS id 984FE100111;
        Thu, 12 Sep 2019 17:13:55 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id 6E5F964B;
        Thu, 12 Sep 2019 17:13:55 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.94,VDF=8.16.23.36)
X-Spam-Status: 
X-Spam-Level: 0
Received: from localhost (storm.m.i2n [172.16.1.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.m.i2n (Postfix) with ESMTPS id 562E25D2;
        Thu, 12 Sep 2019 17:13:53 +0200 (CEST)
Date:   Thu, 12 Sep 2019 17:13:53 +0200
From:   Thomas Jarosch <thomas.jarosch@intra2net.com>
To:     netdev@vger.kernel.org
Cc:     Tom Herbert <therbert@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [bisected] UDP / xfrm: NAT-T packets with bad UDP checksum get
 dropped
Message-ID: <20190912151353.2w7jakdrqljkfbsq@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello together,

after updating many machines already from 3.14 to 4.19.67,
one site showed a non-working IPSec VPN connection with 4.19.x.

This IPSec connection is using UDP NAT traversal on port 4500.
The tunnel gets established fine, but no data flows.
Output of "ip xfrm state" looked sane.

The TRACE iptables firewall target showed the UDP packets
on port 4500 get accepted as expected. Still they didn't appear
in "ip xfrm monitor" and vanish somewhere in the kernel,
no error counter in /proc/net/xfrm_state increased at all.

After a few hours of bisecting with a test VM,
this commit was identified to cause the packet drop:

*******************
commit 0a80966b1043c3e2dc684140f155a3fded308660
Author: Tom Herbert <therbert@google.com>
Date:   Wed May 7 16:52:39 2014 -0700

    net: Verify UDP checksum before handoff to encap

    Moving validation of UDP checksum to be done in UDP not encap layer.

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index f2d05d7be743..54ea0a3a48f1 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1495,6 +1495,10 @@ int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
                if (skb->len > sizeof(struct udphdr) && encap_rcv != NULL) {
                        int ret;
 
+                       /* Verify checksum before giving to encap */
+                       if (udp_lib_checksum_complete(skb))
+                               goto csum_error;
+
                        ret = encap_rcv(sk, skb);
                        if (ret <= 0) {
                                UDP_INC_STATS_BH(sock_net(sk),
..
*******************

This commit is part of kernel 3.16. Reverting the commit
brings back the VPN connection using kernel 4.19.67.

I didn't spot the checksum error initially since wireshark and tcpdump
need to be explicitly told to verify checksums and there's a warning
about checksum offloading messing with it.

Further tracing showed the UDP packets leave the source
site with a zero UDP checksum and arrive, after passing
an unknown home router and a few other routers,
with a bogus UDP checksum on the destination side.

I've disabled rx and tx checksum offloading on the target test VM
and also on a router in between, but the packet dumps just
contain a fixed value as UDP checksum (f.e. 0x91c4).

RFC 3948 specifies how ESP packets should be encapsulated
using UDP for NAT traveral:
https://tools.ietf.org/html/rfc3948

*******************
2.1. UDP-Encapsulated ESP Header Format

the IPv4 UDP Checksum SHOULD be transmitted as a zero value, and
receivers MUST NOT depend on the UDP checksum being a zero value.


3.5.  Tunnel Mode ESP Decapsulation

1.  The UDP header is removed from the packet.
*******************

I'm wondering how the RFC should be interpreted here
regarding the UDP checksumming?

As far as I can tell it doesn't mention the UDP checksum
should be verified before decapsulation, the ESP packets
will provide proper data authentication anyway.

Cheers,
Thomas
