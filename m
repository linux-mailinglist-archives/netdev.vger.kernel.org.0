Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0297121CB41
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 22:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbgGLUHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 16:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729012AbgGLUHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 16:07:20 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4CEC061794
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 13:07:20 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1juiFp-0002cv-Gm; Sun, 12 Jul 2020 22:07:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     aconole@redhat.com, sbrivio@redhat.com
Subject: [PATCH net-next 0/3] vxlan, geneve: allow to turn off PMTU updates on encap socket
Date:   Sun, 12 Jul 2020 22:07:02 +0200
Message-Id: <20200712200705.9796-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are existing deployments where a vxlan or geneve interface is part
of a bridge.

In this case, MTU may look like this:

bridge mtu: 1450
vxlan (bridge port) mtu: 1450
other bridge ports: 1450

physical link (used by vxlan) mtu: 1500.

This makes sure that vxlan overhead (50 bytes) doesn't bring packets over the
1500 MTU of the physical link.

Unfortunately, in some cases, PMTU updates on the encap socket
can bring such setups into a non-working state: no traffic will pass
over the vxlan port (physical link) anymore.
Because of the bridge-based usage of the vxlan interface, the original
sender never learns of the change in path mtu and TCP clients will retransmit
the over-sized packets until timeout.


When this happens, a 'ip route flush cache' in the netns holding
the vxlan interface resolves the problem, i.e. the network is capable
of transporting the packets and the PMTU update is bogus.

Another workaround is to enable 'net.ipv4.tcp_mtu_probing'.

This patch series allows to configure vxlan and geneve interfaces
to ignore path mtu updates.
This is only useful in cases where the vxlan/geneve interface is
part of a bridge (which prevents clients from receiving pmtu updates)
and where all involved links are known to be able to handle link-mtu
sized packets.

Florian Westphal (3):
      udp_tunnel: allow to turn off path mtu discovery on encap sockets
      vxlan: allow to disable path mtu learning on encap socket
      geneve: allow disabling of pmtu detection on encap sk

 drivers/net/geneve.c         | 59 ++++++++++++++++++++++++++++++++++++----
 drivers/net/vxlan.c          | 65 ++++++++++++++++++++++++++++++++++++++------
 include/net/ipv6.h           |  7 +++++
 include/net/udp_tunnel.h     |  2 ++
 include/net/vxlan.h          |  2 ++
 include/uapi/linux/if_link.h |  2 ++
 net/ipv4/udp_tunnel_core.c   |  2 ++
 net/ipv6/ip6_udp_tunnel.c    |  7 +++++
 8 files changed, 131 insertions(+), 15 deletions(-)

