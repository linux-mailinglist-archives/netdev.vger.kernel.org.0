Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549C646DA20
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 18:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238234AbhLHRms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 12:42:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46010 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238574AbhLHRmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 12:42:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=h5fFw0E4ol+OLYs0WKk0ZYA0jt9CH7RzPUZXG+AprRY=; b=M8vSxnlaKlNLA6zr5BTwxaxMk1
        I4tf4CuWgOI1GOvZhR4AComKCS0wwH303Qrdv693rk5DIZe/bc6otWwjtE5z96wg3pSLYxnjHRaRx
        ox1zUAVkPVzGjcQO1z+hZfWJVoFY4Xb39NcdODJscdReAiOVt4EOf11bDKeLWNNgXhqo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mv0to-00FuGS-96; Wed, 08 Dec 2021 18:38:36 +0100
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
Subject: [PATCH net-next v4 0/3] Fix traceroute in the presence of SRv6
Date:   Wed,  8 Dec 2021 18:38:28 +0100
Message-Id: <20211208173831.3791157-1-andrew@lunn.ch>
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
v3:
Move helpers into seg6.c
v4:
Move short helper into header file.
Rework getting SRH destination address

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

