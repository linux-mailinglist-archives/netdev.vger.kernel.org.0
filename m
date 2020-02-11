Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 638C615926C
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgBKPAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:00:44 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:34135 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728073AbgBKPAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 10:00:44 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 410fcb10;
        Tue, 11 Feb 2020 14:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=cvFTjpZLrJrQTfsSPNkWJAHA0
        1A=; b=sHpg9J+U15rSXI6n4dBy0pOqWY8ZmWdsB+M4ulixNEp7W93Wwu4fpAIK/
        ah2ulldMiWIV3W4DLW516E/4wAY/dCPJuNlV9VZfzqwOJxyZbEg6pebpu9PL8sJq
        5e6tYvm789ckVxaVv9EOrpf/vR2lLDCg+mkt+2tRkuaCTTzYVsPTL7lEzBcaF+Ud
        6NRvKQHT919rcMxI2T/fQtsSc/r6KvGwMhblnYrFEwrGnvOwHJDjqJrMH1NMIhPX
        nYEsHl4xjgN5nCSXWiEZsK7qCCCsxl1DSjNIhphlglNhkgeUsKWJQaqSpksCxtjE
        lQTxmaMuk73P8h9bV1iaB6IGPmeQw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 51c3b1ba (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 11 Feb 2020 14:58:58 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        netfilter-devel@vger.kernel.org
Subject: [PATCH v3 net 0/9] icmp: account for NAT when sending icmps from ndo layer
Date:   Tue, 11 Feb 2020 16:00:19 +0100
Message-Id: <20200211150028.688073-1-Jason@zx2c4.com>
In-Reply-To: <20200210141423.173790-2-Jason@zx2c4.com>
References: <20200210141423.173790-2-Jason@zx2c4.com>
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

Jason A. Donenfeld (9):
  icmp: introduce helper for nat'd source address in network device
    context
  gtp: use icmp_ndo_send helper
  sunvnet: use icmp_ndo_send helper
  xfrm: interface: use icmp_ndo_send helper
  wireguard: device: use icmp_ndo_send helper and remove skb_share_check
  firewire: remove skb_share_check from xmit path
  ipvlan: remove skb_share_check from xmit path
  fm10k: remove skb_share_check from xmit path
  benet: remove skb_share_check from xmit path

 drivers/firewire/net.c                        |  4 ---
 drivers/net/ethernet/emulex/benet/be_main.c   |  4 ---
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  5 ----
 drivers/net/ethernet/sun/sunvnet_common.c     | 23 +++------------
 drivers/net/gtp.c                             |  4 +--
 drivers/net/ipvlan/ipvlan_core.c              |  3 --
 drivers/net/wireguard/device.c                |  8 ++---
 include/linux/icmpv6.h                        |  6 ++++
 include/net/icmp.h                            |  6 ++++
 net/ipv4/icmp.c                               | 28 ++++++++++++++++++
 net/ipv6/ip6_icmp.c                           | 29 +++++++++++++++++++
 net/xfrm/xfrm_interface.c                     |  6 ++--
 tools/testing/selftests/wireguard/netns.sh    | 10 +++++++
 13 files changed, 90 insertions(+), 46 deletions(-)

-- 
2.25.0

