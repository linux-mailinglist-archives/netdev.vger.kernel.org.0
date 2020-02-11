Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E8C159A02
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 20:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbgBKTr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 14:47:27 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:52685 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728448AbgBKTr0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 14:47:26 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 6f9f2e92;
        Tue, 11 Feb 2020 19:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=op6WHeg/1QNzAvID/xPxIANnoAU=; b=Cscf9pi2nx6HIkrtBbsF
        FKduWr+brblH2UsJby6zVRkbUHpUAJN8WQ/bB/GS+446Z6ZJQ6wdheAszbpsRCeT
        WZGh7xYtvmKoiO2GOyBKeN0SwXgpK+WYrj3f4htCVa+CMytzqfUcItwWfiehHYQ+
        KBAAOI6zKV1v6pqZnWvPt8a/Xm7YWaT5V4uFabgSd87VOgpkZ/601D7mHTTdldVn
        t5x2KPExc5t7+um62la6aLgztkqTvKJ4gNllYOUjHtFRt66n6czHfp7B7l4PJSXu
        EXi1KgdVeLc9+x6SfwynUh6ESJGzOsRDqnsmECmzP4LCFw0slpFs96wZfmdn1NV4
        +Q==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 699ceed6 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 11 Feb 2020 19:45:39 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        netfilter-devel@vger.kernel.org
Subject: [PATCH v4 net 0/5] icmp: account for NAT when sending icmps from ndo layer
Date:   Tue, 11 Feb 2020 20:47:04 +0100
Message-Id: <20200211194709.723383-1-Jason@zx2c4.com>
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

Changes v3->v4:
- Add back the skb_shared checking, since the previous assumption isn't
  actually true [Eric]. This implies dropping the additional patches v3 had
  for removing skb_share_check from various drivers. We can revisit that
  general set of ideas later, but that's probably better suited as a net-next
  patchset rather than this stable one which is geared at fixing bugs. So,
  this implements things in the safe conservative way.

Changes v2->v3:
- Add selftest to ensure this actually does what we want and never regresses.
- Check the size of the skb header before operating on it.
- Use skb_ensure_writable to ensure we can modify the cloned skb [Florian].
- Conditionalize this on IPS_SRC_NAT so we don't do anything unnecessarily
  [Florian].
- It turns out that since we're calling these from the xmit path,
  skb_share_check isn't required, so remove that [Florian]. This simplifes the
  code a bit too. **The supposition here is that skbs passed to ndo_start_xmit
  are _never_ shared. If this is not correct NOW IS THE TIME TO PIPE UP, for
  doom awaits us later.**
- While investigating the shared skb business, several drivers appeared to be
  calling it incorrectly in the xmit path, so this series also removes those
  unnecessary calls, based on the supposition mentioned in the previous point.

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
  icmp: introduce helper for nat'd source address in network device
    context
  gtp: use icmp_ndo_send helper
  sunvnet: use icmp_ndo_send helper
  wireguard: device: use icmp_ndo_send helper
  xfrm: interface: use icmp_ndo_send helper

 drivers/net/ethernet/sun/sunvnet_common.c  | 23 +++------------
 drivers/net/gtp.c                          |  4 +--
 drivers/net/wireguard/device.c             |  4 +--
 include/linux/icmpv6.h                     |  6 ++++
 include/net/icmp.h                         |  6 ++++
 net/ipv4/icmp.c                            | 33 +++++++++++++++++++++
 net/ipv6/ip6_icmp.c                        | 34 ++++++++++++++++++++++
 net/xfrm/xfrm_interface.c                  |  6 ++--
 tools/testing/selftests/wireguard/netns.sh | 11 +++++++
 9 files changed, 101 insertions(+), 26 deletions(-)

-- 
2.25.0

