Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9D5157D37
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 15:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbgBJOPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 09:15:16 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:46911 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbgBJOPQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 09:15:16 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id bdbfefa7;
        Mon, 10 Feb 2020 14:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=S84KG6qYHBBvrUjNlU6vz3MKLCQ=; b=FLeDUtnUFoig/5/NVW2H
        I4ADCI4q8Y5OVlqhJQysDXOwcRJXIcLfYmlztlrCyMc9T0gorxI4nfKfeFQYIq5t
        8K9aVeG/xrI6uYnWLl9xtf9Sm0AqqU3LFcV1fw5P1AuLAe51veUebk5VTYNNbbeA
        syNGdpo2gQW3t5C+ol4UancdoVoDp7W/8c1SlOh97YJl7KwZlRnqnuBBT/KzKFvH
        JY/mwYbWTz+HAxtLBc3ahr8LpDgzCbaPjRTJe3WZoiNP8HhOoApz+bZf6v0bAEq7
        eQ3XSAfhQoSPhY1vzcbtAin14o20YcT0bb+XZEddUbC70CcBAxV+oNfWc4ivdzYe
        1w==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id cfc07e64 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 10 Feb 2020 14:13:39 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        netfilter-devel@vger.kernel.org
Subject: [PATCH v2 net 0/5] icmp: account for NAT when sending icmps from ndo layer
Date:   Mon, 10 Feb 2020 15:14:18 +0100
Message-Id: <20200210141423.173790-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ICMP routines use the source address for two reasons:

1. Rate-limiting ICMP transmissions based on source address, so
   that one source address cannot provoke a flood of replies. If
   the source address is wrong, the rate limiting will be
   incorrectly applied.

2. Choosing the interface and hence new source address of the
   generated ICMP packet. If the original packet source address
   is wrong, ICMP replies will be sent from the wrong source
   address, resulting in either a misdelivery, infoleak, or just
   general network admin confusion.

Most of the time, the icmp_send and icmpv6_send routines can just reach
down into the skb's IP header to determine the saddr. However, if
icmp_send or icmpv6_send is being called from a network device driver --
there are a few in the tree -- then it's possible that by the time
icmp_send or icmpv6_send looks at the packet, the packet's source
address has already been transformed by SNAT or MASQUERADE or some other
transformation that CONNTRACK knows about. In this case, the packet's
source address is most certainly the *wrong* source address to be used
for the purpose of ICMP replies.

Rather, the source address we want to use for ICMP replies is the
original one, from before the transformation occurred.

Fortunately, it's very easy to just ask CONNTRACK if it knows about this
packet, and if so, how to fix it up. The saddr is the only field in the
header we need to fix up, for the purposes of the subsequent processing
in the icmp_send and icmpv6_send functions, so we do the lookup very
early on, so that the rest of the ICMP machinery can progress as usual.

Changes v1->v2:
- icmpv6 takes subtly different types than icmpv4, like u32 instead of be32,
  u8 instead of int.
- Since we're technically writing to the skb, we need to make sure it's not
  a shared one [Dave, 2017].
- Restore the original skb data after icmp_send returns. All current users
  are freeing the packet right after, so it doesn't matter, but future users
  might not.
- Remove superfluous route lookup in sunvnet [Dave].
- Use NF_NAT instead of NF_CONNTRACK for condition [Florian].
- Include this cover letter [Dave].

Cc: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org

Jason A. Donenfeld (5):
  icmp: introduce helper for NAT'd source address in network device
    context
  gtp: use icmp_ndo_send helper
  sunvnet: use icmp_ndo_send helper
  wireguard: use icmp_ndo_send helper
  xfrm: interface: use icmp_ndo_send helper

 drivers/net/ethernet/sun/sunvnet_common.c | 23 +++--------------
 drivers/net/gtp.c                         |  4 +--
 drivers/net/wireguard/device.c            |  4 +--
 include/linux/icmpv6.h                    |  6 +++++
 include/net/icmp.h                        |  6 +++++
 net/ipv4/icmp.c                           | 29 ++++++++++++++++++++++
 net/ipv6/ip6_icmp.c                       | 30 +++++++++++++++++++++++
 net/xfrm/xfrm_interface.c                 |  6 ++---
 8 files changed, 82 insertions(+), 26 deletions(-)

-- 
2.25.0

