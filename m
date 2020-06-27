Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B5C20BFF8
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 10:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgF0IHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 04:07:25 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:48179 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbgF0IHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 04:07:25 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 9b8f9681;
        Sat, 27 Jun 2020 07:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=LnCgSdqF60yVcFxYRNhJ6MXY+T8=; b=ZjBvC6dYR+cwt0i5lj0a
        5Zq3q71V0NCoN4jZKr7iTuNAaGyUB+ZPEttzmd+S4sKYyst4efIdAJT6PxIuJZwS
        FbMEDlmgFiAEmQB3ce4O2PFVLdbcbGKEgmS9rUKvv+LCy5Zg9+DANcJuoTeDwT5G
        KHTpQhr6CU0aKSt3THknKFAlcovISIp8dQuF74mZZ2NgxnsXqUmJGDORzmJjZrta
        Z81oeNoNSQFTRplTvhxRA4OaySKBE6qvm5BGy/uA7ZF43/TuYsqdilHy7Kk97NbL
        Z5JbVEsaTpjPWCWvb5rYrW92RBO6VtdNFUWEqmFrY9HfyvMCQFKh22UPX2gdkOt1
        lg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f8dd3dc1 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 27 Jun 2020 07:48:01 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Hans Wippel <ndev@hwipl.net>
Subject: [PATCH net 0/5] support AF_PACKET for layer 3 devices
Date:   Sat, 27 Jun 2020 02:07:08 -0600
Message-Id: <20200627080713.179883-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hans reported that packets injected by a correct-looking and trivial
libpcap-based program was not being accepted by wireguard. In
investigating that, I noticed that a few devices weren't properly
handling AF_PACKET- injected packes, and so this series introduces a bit
of shared infrastructure to support that.

The basic problem begins with socket(AF_PACKET, SOCK_RAW,
htons(ETH_P_ALL)) sockets. When sendto is called, AF_PACKET examines the
headers of the packet with this logic:

static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
{
    if ((!skb->protocol || skb->protocol == htons(ETH_P_ALL)) &&
        sock->type == SOCK_RAW) {
        skb_reset_mac_header(skb);
        skb->protocol = dev_parse_header_protocol(skb);
    }

    skb_probe_transport_header(skb);
}

The middle condition there triggers, and we jump to
dev_parse_header_protocol. Note that this is the only caller of
dev_parse_header_protocol in the kernel, and I assume it was designed
for this purpose:

static inline __be16 dev_parse_header_protocol(const struct sk_buff *skb)
{
    const struct net_device *dev = skb->dev;

    if (!dev->header_ops || !dev->header_ops->parse_protocol)
        return 0;
    return dev->header_ops->parse_protocol(skb);
}

Since AF_PACKET already knows which netdev the packet is going to, the
dev_parse_header_protocol function can see if that netdev has a way it
prefers to figure out the protocol from the header. This, again, is the
only use of parse_protocol in the kernel. At the moment, it's only used
with ethernet devices, via eth_header_parse_protocol. This makes sense,
as mostly people are used to AF_PACKET-injecting ethernet frames rather
than layer 3 frames. But with nothing in place for layer 3 netdevs, this
function winds up returning 0, and skb->protocol then is set to 0, and
then by the time it hits the netdev's ndo_start_xmit, the driver doesn't
know what to do with it.

This is a problem because drivers very much rely on skb->protocol being
correct, and routinely reject packets where it's incorrect. That's why
having this parsing happen for injected packets is quite important. In
wireguard, ipip, and ipip6, for example, packets from AF_PACKET are just
dropped entirely. For tun devices, it's sort of uglier, with the tun
"packet information" header being passed to userspace containing a bogus
protocol value. Some userspace programs are ill-equipped to deal with
that. (But of course, that doesn't happen with tap devices, which
benefit from the similar shared infrastructure for layer 2 netdevs,
further motiviating this patchset for layer 3 netdevs.)

This patchset addresses the issue by first adding a layer 3 header parse
function, much akin to the existing one for layer 2 packets, and then
adds a shared header_ops structure that, also much akin to the existing
one for layer 2 packets. Then it wires it up to a few immediate places
that stuck out as requiring it, and does a bit of cleanup.

This patchset seems like it's fixing real bugs, so it might be
appropriate for stable. But they're also very old bugs, so if you'd
rather not backport to stable, that'd make sense to me too.

Jason A. Donenfeld (5):
  net: ip_tunnel: add header_ops for layer 3 devices
  net: ipip: implement header_ops->parse_protocol for AF_PACKET
  wireguard: implement header_ops->parse_protocol for AF_PACKET
  wireguard: queueing: make use of ip_tunnel_parse_protocol
  tun: implement header_ops->parse_protocol for AF_PACKET

 drivers/net/tun.c                |  2 ++
 drivers/net/wireguard/device.c   |  1 +
 drivers/net/wireguard/queueing.h | 19 ++-----------------
 drivers/net/wireguard/receive.c  |  2 +-
 include/net/ip_tunnels.h         |  3 +++
 net/ipv4/ip_tunnel_core.c        | 19 +++++++++++++++++++
 net/ipv4/ipip.c                  |  1 +
 net/ipv6/ip6_tunnel.c            |  1 +
 8 files changed, 30 insertions(+), 18 deletions(-)

Cc: Hans Wippel <ndev@hwipl.net>
-- 
2.27.0

