Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79D53CA19E
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 17:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239304AbhGOPs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 11:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238143AbhGOPs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 11:48:28 -0400
X-Greylist: delayed 493 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 15 Jul 2021 08:45:35 PDT
Received: from caffeine.csclub.uwaterloo.ca (caffeine.csclub.uwaterloo.ca [IPv6:2620:101:f000:4901:c5c:0:caff:e12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A371BC06175F;
        Thu, 15 Jul 2021 08:45:35 -0700 (PDT)
Received: by caffeine.csclub.uwaterloo.ca (Postfix, from userid 20367)
        id E30DB463ACA; Thu, 15 Jul 2021 11:37:20 -0400 (EDT)
Date:   Thu, 15 Jul 2021 11:37:20 -0400
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Len Sorensen <lsorense@csclub.uwaterloo.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: macvlan breaks garp for vrrp
Message-ID: <20210715153720.GA2378@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
From:   lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are seeing an occational problem where a node in a cluster running
vrrp stops being able to send packets to the current master due to having
the wrong arp entry for the virtual IP.  It appears that what happens
is that if around the time vrrp changes who the master is, a packet is
sent from the new master to another node, that node will learn the mac
of the virtual IP as the mac of the physical interface of the master
(since it always transmits from the physical mac, not the virtual mac).
In most cases nodes seem to correctly send an arp request for the
virtual IP and get back the virtual mac (from the maclan interface
used by keepalived with use_vmac enabled), in which case all is fine.
Only if the timing is unlucky do you end up learning the wrong mac and
then you can no longer send packets back to the master since it doesn't
accept packets on the physical interface mac, only the virtual mac.

Of course one would have thought that the garp sent by the master would
take care of the problem, but unfortunately the macvlan code is not
allowing garp packets with a source mac macthing the macvlan interface to
reach the physical interface.  The code causing this is below.  keepalived
uses MACVLAN_MODE_PRIVATE which does not match the condition, so the code
tries to do its work and consumes the packet, and the physical interface
hence never gets to see it, and the arp table is hence not corrected.
I can't actually make sense of what this code is trying to do in this
case where the source mac of the packet matches the macvlan interface,
even though it was received from outside (from the current master in
the vrrp cluster).

        port = macvlan_port_get_rcu(skb->dev);
          if (is_multicast_ether_addr(eth->h_dest)) {
                  unsigned int hash;

                  skb = ip_check_defrag(dev_net(skb->dev), skb, IP_DEFRAG_MACVLAN);                                                                                           if (!skb)
                          return RX_HANDLER_CONSUMED;
                  *pskb = skb;
                  eth = eth_hdr(skb);
                  if (macvlan_forward_source(skb, port, eth->h_source))
                          return RX_HANDLER_CONSUMED;
                  src = macvlan_hash_lookup(port, eth->h_source);  <- this of course has a match
                  if (src && src->mode != MACVLAN_MODE_VEPA &&     <- so this is true and eats the packet
                      src->mode != MACVLAN_MODE_BRIDGE) {
                          /* forward to original port. */
                          vlan = src;
                          ret = macvlan_broadcast_one(skb, vlan, eth, 0) ?:
                                netif_rx(skb);
                          handle_res = RX_HANDLER_CONSUMED;
                          goto out;
                  }

                  hash = mc_hash(NULL, eth->h_dest);
                  if (test_bit(hash, port->mc_filter))
                          macvlan_broadcast_enqueue(port, src, skb);

                  return RX_HANDLER_PASS;
          }

If I patch it to do:

                   if (src && src->mode != MACVLAN_MODE_VEPA &&
+                      src->mode != MACVLAN_MODE_PRIVATE &&
                       src->mode != MACVLAN_MODE_BRIDGE) {

the problem goes away, but since I don't understand what the idea of
this code was, that doesn't feel safe.

Can someone that understands the point of this code perhaps give an idea
how to correctly fix this?  Definitely packets received with the same
mac address as this macvlan should still be able to make it through to
the underlying interface, since that is how vrrp is supposed to operate
per the RFC.  Having the wrong arp entry is bad since each time we
receive a packet we increase the timeout so it never ages out, even
though it is the wrong mac address for actually replying (due to how
macvlan interfaces seem to work).

So far this doesn't seem to happen very often since the timing has to
be just "wrong" on the packets, but I have now seen it 4 or 5 times in
the last year.  The solution each time was to manually delete the arp
entry for the virtual IP on the affected node, after which it correctly
arp'd for the right mac and everything worked again.

To test it I would manually set a temp arp entry using the physical mac of
the interface on the master as the arp entry, and see if the garp ever
fixed it, and it did not until I made my small patch, after which it
does fix the arp table reliably as far as I can tell.

-- 
Len Sorensen
