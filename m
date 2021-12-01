Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716ED465711
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 21:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352852AbhLAU3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 15:29:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34400 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245632AbhLAU3B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 15:29:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=KL/aOrBLcCZExmX50+8oMzVHAFp/bG6pyDYVCK5HEX4=; b=1CIMUcREcxQIFqN4ZwR6E2guEo
        o7Pf+/djgfbEwgwVqpfUJ6pWPowA7zFl2GDQ29YzDnIvqnJ5UmaPyJtTIs2UzGZMLlM/QoFrE8pwu
        1eKv+UYRCnfKq/2RFvSxYo4IXRHIYEpW564t351MLb6VwqR/8GvkGEwm9fdZ7cnTM824=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1msWAS-00FGA8-88; Wed, 01 Dec 2021 21:25:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [patch RFC net-next 0/3 v2] Fix traceroute in the presence of SRv6
Date:   Wed,  1 Dec 2021 21:25:16 +0100
Message-Id: <20211201202519.3637005-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC: This my first time working on SRv6 and ICMP. Comments very welcome.

When using SRv6 the destination IP address in the IPv6 header is not
always the true destination, it can be a router along the path that
SRv6 is using.

When ICMP reports an error, e.g, time exceeded, which is what
traceroute uses, it included the packet which invoked the error into
the ICMP message body. Upon receiving such an ICMP packet, the
invoking packet is examined and an attempt is made to find the socket
which sent the packet, so the error can be reported. Lookup is
performed using the source and destination address. If the
intermediary router IP address from the IP header is used, the lookup
fails. It is necessary to dig into the header and find the true
destination address in the Segment Router header, SRH.

v2:
Play games with the skb->network_header rather than clone the skb

Patch 1 exports a helper which can find the SRH in a packet
Patch 2 does the actual examination of the invoking packet
Patch 3 makes use of the results when trying to find the socket.

Andrew Lunn (3):
  seg6: export get_srh() for ICMP handling
  icmp: ICMPV6: Examine invoking packet for Segment Route Headers.
  udp6: Use Segment Routing Header for dest address if present

 include/linux/ipv6.h  |  2 ++
 include/net/seg6.h    |  1 +
 net/ipv6/icmp.c       | 36 +++++++++++++++++++++++++++++++++++-
 net/ipv6/seg6.c       | 29 +++++++++++++++++++++++++++++
 net/ipv6/seg6_local.c | 33 ++-------------------------------
 net/ipv6/udp.c        |  7 +++++++
 6 files changed, 76 insertions(+), 32 deletions(-)

-- 
2.33.1

