Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C95E73367
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 18:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfGXQLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 12:11:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44522 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbfGXQLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 12:11:32 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4AA31C065115;
        Wed, 24 Jul 2019 16:11:32 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-49.rdu2.redhat.com [10.10.120.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99C761001B0F;
        Wed, 24 Jul 2019 16:11:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
cc:     dhowells@redhat.com, linux-afs@lists.infradead.org
Subject: Problem using skb_cow_data()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18912.1563984690.1@warthog.procyon.org.uk>
Date:   Wed, 24 Jul 2019 17:11:30 +0100
Message-ID: <18913.1563984690@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 24 Jul 2019 16:11:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I have a problem using skb_cow_data() in rxkad_verify_packet{,_1,_2}() and was
wondering if anyone can suggest a better way.

The problem is that the rxrpc packet receive routine, rxrpc_input_data(),
receives an skb from the udp socket, makes it its own and then, if it's a data
packet, stores one or more[*] pointers to the skb, each with its own usage
ref, in the rx ring.

[*] The Rx protocol allows combinable packets (jumbo packet) that need to be
    split and each segment treated as a separate data packet.

rxrpc_input_data() then drops its own ref to the packet.  Possibly
simultaneously, the receiving process wakes up and starts processing the
packets earmarked for it.  This involves decrypting the packets if necessary
(which is done in place in the skb).  To do this, the rxkad_verify_packet*()
functions call skb_cow_data() on the skb.  This, however:

 (a) Can race with the input which may not have released its ref yet.

 (b) Could be a jumbo packet with multiple refs on it in the rx ring.

This can result in an assertion failure in pskb_expand_head():

	BUG_ON(skb_shared(skb));

In this particular case it shouldn't be an issue since the input path merely
has to release a ref and the subsequent attachment points in the ring buffer
if it's a jumbo packet will not be looked at until the current attachment
point is finished with (data delivery has to proceed delivery).

So, some questions:

 (1) Do I actually have to call skb_cow_data()?

 (2) Can the assertion be relaxed?

 (3) Is it feasible to do decryption directly from an skb to the target
     iov_iter, thereby avoiding the need to modify the skb content and saving
     a copy and potentially a bunch of allocations?  This would seem to
     require calling something like skb_copy_and_hash_datagram_iter(), but
     with a bespoke cb function to copy from the skb to the iov_iter.

     This gets interesting if the target iov_iter is smaller than the content
     in the skb as decryption would have to be suspended until a new iov_iter
     comes along.

David
