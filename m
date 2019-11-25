Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A06108F2E
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 14:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbfKYNtr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 25 Nov 2019 08:49:47 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51657 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727695AbfKYNtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 08:49:47 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-QRTmXylINfK3YtMXU9UuAg-1; Mon, 25 Nov 2019 08:49:42 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15950993DB;
        Mon, 25 Nov 2019 13:49:41 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-31.ams2.redhat.com [10.36.116.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FD9C600C6;
        Mon, 25 Nov 2019 13:49:39 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next v7 0/6] ipsec: add TCP encapsulation support (RFC 8229)
Date:   Mon, 25 Nov 2019 14:48:56 +0100
Message-Id: <cover.1574685542.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: QRTmXylINfK3YtMXU9UuAg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
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

[0] https://tools.ietf.org/html/rfc8229
[1] https://patchwork.ozlabs.org/patch/859107/
[2] https://netdevconf.org/0x13/session.html?talk-ipsec-encap

Changes since v6:
 - fix sparse warning in patch 6/6

Changes since v5:
 - rebase patch 1/6 on top of ipsec-next (conflict with commits
   7c422d0ce975 ("net: add READ_ONCE() annotation in
   __skb_wait_for_more_packets()") and 3f926af3f4d6 ("net: use
   skb_queue_empty_lockless() in busy poll contexts"))

Changes since v4:
 - prevent combining sockmap with espintcp, as this does not work
   properly and I can't see a use case for it

Changes since v3:
 - fix sparse warning related to RCU tag on icsk_ulp_data

Changes since v2:
 - rename config option to INET_ESPINTCP and move it to
   net/ipv4/Kconfig (patch 6/6)

Changes since v1:
 - drop patch 1, already present in the tree as commit bd95e678e0f6
   ("bpf: sockmap, fix use after free from sleep in psock backlog
   workqueue")
 - patch 1/6: fix doc error reported by kbuild test robot <lkp@intel.com>
 - patch 6/6, fix things reported by Steffen Klassert:
   - remove unneeded goto and improve error handling in
     esp_output_tcp_finish
   - clean up the ifdefs by providing dummy implementations of those
     functions
   - fix Kconfig select, missing NET_SOCK_MSG

Sabrina Dubroca (6):
  net: add queue argument to __skb_wait_for_more_packets and
    __skb_{,try_}recv_datagram
  xfrm: introduce xfrm_trans_queue_net
  xfrm: add route lookup to xfrm4_rcv_encap
  esp4: prepare esp_input_done2 for non-UDP encapsulation
  esp4: split esp_output_udp_encap and introduce esp_output_encap
  xfrm: add espintcp (RFC 8229)

 include/linux/skbuff.h    |  11 +-
 include/net/espintcp.h    |  39 +++
 include/net/xfrm.h        |   4 +
 include/uapi/linux/udp.h  |   1 +
 net/core/datagram.c       |  27 +-
 net/ipv4/Kconfig          |  11 +
 net/ipv4/esp4.c           | 264 ++++++++++++++++++--
 net/ipv4/udp.c            |   3 +-
 net/ipv4/xfrm4_protocol.c |   9 +
 net/unix/af_unix.c        |   7 +-
 net/xfrm/Makefile         |   1 +
 net/xfrm/espintcp.c       | 509 ++++++++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_input.c     |  21 +-
 net/xfrm/xfrm_policy.c    |   7 +
 net/xfrm/xfrm_state.c     |   3 +
 15 files changed, 871 insertions(+), 46 deletions(-)
 create mode 100644 include/net/espintcp.h
 create mode 100644 net/xfrm/espintcp.c

-- 
2.23.0

