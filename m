Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCB1986C4
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 23:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbfHUVqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 17:46:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33068 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727874AbfHUVqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 17:46:00 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7BFC130821C2;
        Wed, 21 Aug 2019 21:45:59 +0000 (UTC)
Received: from hog.localdomain, (ovpn-204-30.brq.redhat.com [10.40.204.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CC0E194B9;
        Wed, 21 Aug 2019 21:45:57 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 0/7] ipsec: add TCP encapsulation support (RFC 8229)
Date:   Wed, 21 Aug 2019 23:46:18 +0200
Message-Id: <cover.1566395202.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 21 Aug 2019 21:45:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces support for TCP encapsulation of IKE and ESP
messages, as defined by RFC 8229 [0]. It is an evolution of what
Herbert Xu proposed in January 2018 [1] that addresses the main
criticism against it, by not interfering with the TCP implementation
at all. The networking stack now has infrastructure for this: TCP ULPs
and Stream Parsers.

The first patches are preparation and refactoring, and the final patch
adds the feature.

The main omission in this submission is IPv6 support. ESP
encapsulation over UDP with IPv6 is currently not supported in the
kernel either, as UDP encapsulation is aimed at NAT traversal, and NAT
is not frequently used with IPv6.

Some of the code is taken directly, or slightly modified, from Herbert
Xu's original submission [1]. The ULP and strparser pieces are
new. This work was presented and discussed at the IPsec workshop and
netdev 0x13 conference [2] in Prague, last March.

An equivalent of patch #1 (skbuff: Avoid sleeping in
skb_send_sock_locked) is already present in other trees (but not
ipsec-next) as commit bd95e678e0f6 ("bpf: sockmap, fix use after free
from sleep in psock backlog workqueue"), I'm only including it here so
that this patchset works correctly on top of ipsec-next/master.

No changes in the patchset since the RFC.

[0] https://tools.ietf.org/html/rfc8229
[1] https://patchwork.ozlabs.org/patch/859107/
[2] https://netdevconf.org/0x13/session.html?talk-ipsec-encap

Herbert Xu (1):
  skbuff: Avoid sleeping in skb_send_sock_locked

Sabrina Dubroca (6):
  net: add queue argument to __skb_wait_for_more_packets and
    __skb_{,try_}recv_datagram
  xfrm: introduce xfrm_trans_queue_net
  xfrm: add route lookup to xfrm4_rcv_encap
  esp4: prepare esp_input_done2 for non-UDP encapsulation
  esp4: split esp_output_udp_encap and introduce esp_output_encap
  xfrm: add espintcp (RFC 8229)

 include/linux/skbuff.h    |  11 +-
 include/net/espintcp.h    |  38 +++
 include/net/xfrm.h        |   4 +
 include/uapi/linux/udp.h  |   1 +
 net/core/datagram.c       |  26 +-
 net/core/skbuff.c         |   1 +
 net/ipv4/esp4.c           | 262 ++++++++++++++++++--
 net/ipv4/udp.c            |   3 +-
 net/ipv4/xfrm4_protocol.c |   9 +
 net/unix/af_unix.c        |   7 +-
 net/xfrm/Kconfig          |   9 +
 net/xfrm/Makefile         |   1 +
 net/xfrm/espintcp.c       | 505 ++++++++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_input.c     |  21 +-
 net/xfrm/xfrm_policy.c    |   7 +
 net/xfrm/xfrm_state.c     |   3 +
 16 files changed, 862 insertions(+), 46 deletions(-)
 create mode 100644 include/net/espintcp.h
 create mode 100644 net/xfrm/espintcp.c

-- 
2.22.0

