Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BAF287CFF
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbgJHUXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728779AbgJHUXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 16:23:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C11A22227;
        Thu,  8 Oct 2020 20:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602188611;
        bh=2IvZn8502JQYfPe1sBhtR8rxFTC2X3/y6ABBWuunGDM=;
        h=Date:From:To:Cc:Subject:From;
        b=sFY779kMwHZ2FqXZzyyWa8XhCeW6jwE4gatqpXqdQyiWj4xpKKAoXMqRfQjvXY1Wt
         CMoyQIQ2z0xAK6sSlfV5SafsBPL3tzEOTO1STaVFuYy8++ecV9gDaiRbITf8i8LPTJ
         XPjHltk4sEFoG/iJKWwaXEzUstjc9hVdLCLbDXlg=
Date:   Thu, 8 Oct 2020 13:23:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking
Message-ID: <20201008132329.7eaa0d77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Here is one more pull request with fixes from the networking tree,
selected with the filtering knobs for priority / risk / impact set
for -rc8 time.

 - add missing input validation in nl80211_del_key(), preventing
   out-of-bounds access
 
 - last minute fix / improvement of a MRP netlink (uAPI) interface
   introduced in 5.9 (current) release

 - fix "unresolved symbol" build error under CONFIG_NET w/o
   CONFIG_INET due to missing tcp_timewait_sock and
   inet_timewait_sock BTF.
 - fix 32 bit sub-register bounds tracking in the bpf verifier
   for OR case
 
 - tcp: fix receive window update in tcp_add_backlog()
 
 - openvswitch: handle DNAT tuple collision in conntrack-related
   code

 - r8169: wait for potential PHY reset to finish after applying
          a FW file, avoiding unexpected PHY behaviour and failures
	  later on

 - net: mscc: fix tail dropping watermarks for Ocelot switches

 - avoid use-after-free in macsec code after a call to the GRO layer
 - avoid use-after-free in sctp error paths
 
 - add a device id for Cellient MPL200 WWAN card

 - rxrpc: fix the xdr encoding of the contents read from an rxrpc key.
 - rxrpc: fix a BUG() for a unsupported encoding type.
 - rxrpc: fix missing _bh lock annotations.
 - rxrpc: fix acceptance handling for an incoming call where
          the incoming call is encrypted.
 - rxrpc: the server token keyring isn't network namespaced - 
          it belongs to the server, so there's no need.
	  Namespacing it means that request_key()
          fails to find it.
 - rxrpc: fix a leak of the server keyring.

----------------

The following changes since commit 7575fdda569b2a2e8be32c1a64ecb05d6f96a500:

  Merge tag 'platform-drivers-x86-v5.9-2' of git://git.infradead.org/linux-platform-drivers-x86 (2020-10-05 11:54:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to 28802e7c0c9954218d1830f7507edc9d49b03a00:

  net: usb: qmi_wwan: add Cellient MPL200 card (2020-10-08 12:26:31 -0700)

----------------------------------------------------------------
Anant Thazhemadam (2):
      net: usb: rtl8150: set random MAC address when set_ethernet_addr() fails
      net: wireless: nl80211: fix out-of-bounds access in nl80211_del_key()

Daniel Borkmann (1):
      bpf: Fix scalar32_min_max_or bounds tracking

David Howells (5):
      rxrpc: Downgrade the BUG() for unsupported token type in rxrpc_read()
      rxrpc: Fix some missing _bh annotations on locking conn->state_lock
      rxrpc: Fix accept on a connection that need securing
      rxrpc: The server keyring isn't network-namespaced
      rxrpc: Fix server keyring leak

David S. Miller (2):
      Merge branch 'Fix-tail-dropping-watermarks-for-Ocelot-switches'
      Merge tag 'rxrpc-fixes-20201005' of git://git.kernel.org/.../dhowells/linux-fs

Dumitru Ceara (1):
      openvswitch: handle DNAT tuple collision

Eric Dumazet (3):
      tcp: fix receive window update in tcp_add_backlog()
      sctp: fix sctp_auth_init_hmacs() error path
      macsec: avoid use-after-free in macsec_handle_frame()

Heiner Kallweit (1):
      r8169: consider that PHY reset may still be in progress after applying firmware

Henrik Bjoernlund (1):
      bridge: Netlink interface fix.

Jakub Kicinski (2):
      Merge git://git.kernel.org/.../bpf/bpf
      Merge tag 'mac80211-for-net-2020-10-08' of git://git.kernel.org/.../jberg/mac80211

Manivannan Sadhasivam (1):
      net: qrtr: ns: Fix the incorrect usage of rcu_read_lock()

Marc Dionne (1):
      rxrpc: Fix rxkad token xdr encoding

Paolo Abeni (1):
      mptcp: more DATA FIN fixes

Vladimir Oltean (2):
      net: mscc: ocelot: divide watermark value by 60 when writing to SYS_ATOP
      net: mscc: ocelot: warn when encoding an out-of-bounds watermark value

Wilken Gottwalt (1):
      net: usb: qmi_wwan: add Cellient MPL200 card

Yonghong Song (1):
      bpf: Fix "unresolved symbol" build error with resolve_btfids

 drivers/net/dsa/ocelot/felix_vsc9959.c     |   2 +
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   2 +
 drivers/net/ethernet/mscc/ocelot.c         |  12 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |   2 +
 drivers/net/ethernet/realtek/r8169_main.c  |   7 +
 drivers/net/macsec.c                       |   4 +-
 drivers/net/usb/qmi_wwan.c                 |   1 +
 drivers/net/usb/rtl8150.c                  |  16 +-
 include/uapi/linux/rxrpc.h                 |   2 +-
 kernel/bpf/verifier.c                      |   8 +-
 net/bridge/br_netlink.c                    |  26 ++-
 net/core/filter.c                          |   6 +
 net/ipv4/tcp_ipv4.c                        |   6 +-
 net/mptcp/options.c                        |  10 +-
 net/mptcp/subflow.c                        |   2 +-
 net/openvswitch/conntrack.c                |  22 ++-
 net/qrtr/ns.c                              |  76 +++++++--
 net/rxrpc/ar-internal.h                    |   7 +-
 net/rxrpc/call_accept.c                    | 263 +++++------------------------
 net/rxrpc/call_object.c                    |   5 +-
 net/rxrpc/conn_event.c                     |   8 +-
 net/rxrpc/key.c                            |  20 ++-
 net/rxrpc/recvmsg.c                        |  36 +---
 net/rxrpc/sendmsg.c                        |  15 +-
 net/sctp/auth.c                            |   1 +
 net/wireless/nl80211.c                     |   3 +
 26 files changed, 212 insertions(+), 350 deletions(-)
