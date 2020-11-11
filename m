Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95AE72AF9EC
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 21:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgKKUoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 15:44:18 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:36967 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgKKUoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 15:44:17 -0500
Date:   Wed, 11 Nov 2020 20:44:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1605127454; bh=cjnSs7ggKuxNW/h5Wnq+CXkLVSWDuqP6wXc3zMUiSOA=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=bV+XkA5q3D9jxeC3YIesV5yGTAjx3vv/JBTesm6v1zru4MyGkKBFRMZwfoyR3Hsz0
         bZPrBmw5+eop5UT8vCChwTW/ieUzI6bcuLYm9JmVsw+DKmEhhHTnZvKjK9fxEzLC0g
         oUUQGUV6UwDiuEu8btxMUpK9AFoq/Lh704g7kql24ESVYGgYo6W0A5HaeeA7Kw0WD+
         Tvv3Cxltp08zYm8QCum3dtkxvp/iILQSIURXfXiK4GEDbcbk0E8ox/D7C0qi9TUCF7
         uj79/YbkeePMozxqVqHWaTP8ZyY5hwYja8m1QdGsEll/hi0XX/H/sC+Q4PBLe2hNCJ
         L2yYTnBXmQ4+A==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v5 net 0/2] net: udp: fix Fast/frag0 UDP GRO
Message-ID: <hjGOh0iCOYyo1FPiZh6TMXcx3YCgNs1T1eGKLrDz8@cp4-web-037.plabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing UDP GSO fraglists forwarding through driver that uses
Fast GRO (via napi_gro_frags()), I was observing lots of out-of-order
iperf packets:

[ ID] Interval           Transfer     Bitrate         Jitter
[SUM]  0.0-40.0 sec  12106 datagrams received out-of-order

Simple switch to napi_gro_receive() or any other method without frag0
shortcut completely resolved them.

I've found two incorrect header accesses in GRO receive callback(s):
 - udp_hdr() (instead of udp_gro_udphdr()) that always points to junk
   in "fast" mode and could probably do this in "regular".
   This was the actual bug that caused all out-of-order delivers;
 - udp{4,6}_lib_lookup_skb() -> ip{,v6}_hdr() (instead of
   skb_gro_network_header()) that potentionally might return odd
   pointers in both modes.

Each patch addresses one of these two issues.

This doesn't cover a support for nested tunnels as it's out of the
subject and requires more invasive changes. It will be handled
separately in net-next series.

Credits:
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>

Since v4 [0]:
 - split the fix into two logical ones (Willem);
 - replace ternaries with plain ifs to beautify the code (Jakub);
 - drop p->data part to reintroduce it later in abovementioned set.

Since v3 [1]:
 - restore the original {,__}udp{4,6}_lib_lookup_skb() and use
   private versions of them inside GRO code (Willem).

Since v2 [2]:
 - dropped redundant check introduced in v2 as it's performed right
   before (thanks to Eric);
 - udp_hdr() switched to data + off for skbs from list (also Eric);
 - fixed possible malfunction of {,__}udp{4,6}_lib_lookup_skb() with
   Fast/frag0 due to ip{,v6}_hdr() usage (Willem).

Since v1 [3]:
 - added a NULL pointer check for "uh" as suggested by Willem.

[0] https://lore.kernel.org/netdev/Ha2hou5eJPcblo4abjAqxZRzIl1RaLs2Hy0oOAgF=
s@cp4-web-036.plabs.ch
[1] https://lore.kernel.org/netdev/MgZce9htmEtCtHg7pmWxXXfdhmQ6AHrnltXC41zO=
oo@cp7-web-042.plabs.ch
[2] https://lore.kernel.org/netdev/0eaG8xtbtKY1dEKCTKUBubGiC9QawGgB3tVZtNqV=
dY@cp4-web-030.plabs.ch
[3] https://lore.kernel.org/netdev/YazU6GEzBdpyZMDMwJirxDX7B4sualpDG68ADZYv=
JI@cp4-web-034.plabs.ch

Alexander Lobakin (2):
  net: udp: fix UDP header access on Fast/frag0 UDP GRO
  net: udp: fix IP header access and skb lookup on Fast/frag0 UDP GRO

 net/ipv4/udp_offload.c | 19 ++++++++++++++++---
 net/ipv6/udp_offload.c | 17 +++++++++++++++--
 2 files changed, 31 insertions(+), 5 deletions(-)

--=20
2.29.2


