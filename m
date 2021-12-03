Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5839F467B5D
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 17:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352658AbhLCQdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 11:33:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37906 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234626AbhLCQdc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 11:33:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=s5CFF4TrjGlUs1cRl76tnkbtSBkYcEP8rf0bapGQTq0=; b=Cq0Nifsm4L7wz5xEHn4MslYjH9
        Vq3IY+TFxoi+IY58l6uXCLcQlM0sgbVdTJWSy9z4Q9kX7rcWpqXmjh8IviSl5bMhrhT7ty0UjPIMY
        IGDUGrtnYJC9PNFct365CQDLNTrxxjIoQ8K5xamoZCZaYd/naO12eYSw7I7FcO9JvJy8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mtBRZ-00FRQ8-CS; Fri, 03 Dec 2021 17:29:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/3 v3] Fix traceroute in the presence of SRv6
Date:   Fri,  3 Dec 2021 17:29:23 +0100
Message-Id: <20211203162926.3680281-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
v3
Move helpers into seg6.c

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

