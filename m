Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64E23EB18
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 21:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbfD2Tu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 15:50:26 -0400
Received: from mail.us.es ([193.147.175.20]:41656 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729113AbfD2Tu0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 15:50:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 689371031AC
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 21:50:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 541C6DA70A
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 21:50:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 45CF0DA70D; Mon, 29 Apr 2019 21:50:24 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0914BDA706;
        Mon, 29 Apr 2019 21:50:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 29 Apr 2019 21:50:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BAA384265A31;
        Mon, 29 Apr 2019 21:50:21 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH 0/9 net-next,v2] connection tracking support for bridge
Date:   Mon, 29 Apr 2019 21:50:05 +0200
Message-Id: <20190429195014.4724-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset adds connection tracking support for the bridge family.

Behaviour is similar to what users are used to in classic connection
tracking: the new `nf_conntrack_bridge' module registers the bridge
hooks on-demand in case that the policy relies on ct state information.

Since we may see vlan / overlay packets, users can map different vlans /
overlays to conntrack zones to avoid conflicts with overlapping
conntrack entries via ruleset policy.

Patch 6 to 9 updates Netfilter codebase, more specifically:

* Patch 6/9 adds infrastructure to register and to unregister the
  nf_conntrack_bridge as a module via nf_ct_bridge_register() and
  nf_ct_bridge_unregister(). This allows us to transparently the
  existing ct extensions to match on the ct state with no changes.

* Patch 7/9 adds IPv4 conntrack support for bridge. This add the
  nf_conntrack_bridge module which registers two hooks, one at
  bridge prerouting and another at bridge postrouting. For traffic that
  is being forwarded, a conntrack entry is created at bridge prerouting
  and confirmed at bridge postrouting. ARP packets are explicitly
  untracked. We also follow the "do not drop packets from conntrack", as
  invalid packets can be just dropped via policy.

* Patch 8/9 adds IPv6 support for conntrack bridge.

* Patch 9/9 enables classic IPv4/IPv6 conntrack to deal with local
  traffic, ie. when the bridge interface has an IP address, hence
  packets are passed up to the IP stack for local handling are confirmed
  by the classic IPv4/IPv6 conntrack hooks. This allows users to define
  stateful filtering policies from the bridge prerouting chain. For
  outgoing traffic, the recommended solution is to define the stateful
  policy from the classic IPv4/IPv6 output hooks.

Then, patchset from 1 to 5 extract code from ip_do_fragment() in IPv4
(as well as the equivalent function in IPv6) to reuse code to build a
custom function to refragment traffic which:

1) does not modify fragment geometry. There are few corner case
   exceptions, such as linearized skbuffs (those coming from nfqueue
   and a few ct helpers) and cloned skbuffs (port flooding in case
   destination port is not yet known for this packet and also in case
   of taps), in these cases geometry is lost for us.

2) drops the packets in case maximum fragment seen is larger than mtu.

3) does not assume the IPv4 control buffer layout.

4) does not deal with sockets, the refragmentation codebase is only
   exercised for forwarded/bridged traffic from the bridge prerouting
   path, where no socket information is available, ie. not local
   traffic.

Reusing existing code would result in introducing a per-cpu area to pass
extra parameters that classic ip_do_fragment() does not require. So this
batch extracts code from the refragmentation core to share it with the
new custom bridge refragmentation routine.

More specifically, these patches are:

* Patches 1/9 and 2/9 add the fraglist splitter. This infrastructure
  extracts the code from ip_do_fragment() to split a fraglist into
  fragments, then call the output callback for each fragmented skbuff.
  The API consists of ip_fraglist_init() to start the iterator internal
  state, then ip_fraglist_prepare() to restore restore the IPv4 header
  in the fragment and, finally, ip_fraglist_next() to obtain the
  fragmented skbuff from the fraglist. Similar API is introduced for
  IPv6.

* Patches 3/9 and 4/9 add the fragment transformer. This
  infrastructure extracts the code from ip_do_fragment() to split a
  linearized skbuff into fragmented skbuffs. This is also useful for the
  skbuff clone case, needed in case of floods to multiple bridge ports
  or when passing packets to the tap (ie. tcpdump), so this transformer
  can also deal with fraglists. The API consists of ip6_frag_init() to
  start the internal state of the transformer and ip6_frag_next() to build
  and fetch a fragment.

* Patches 5/9 moves the IPCB specific code away from these two
  new APIs, so it can be used from the bridge without saving and
  restoring the control buffer area.

v2:
* Fix English typos in patch descriptions.

Pablo Neira Ayuso (9):
  net: ipv4: add skbuff fraglist splitter
  net: ipv6: add skbuff fraglist splitter
  net: ipv4: split skbuff into fragments transformer
  net: ipv6: split skbuff into fragments transformer
  net: ipv4: place cb handling away from fragmentation iterators
  netfilter: nf_conntrack: allow to register bridge support
  netfilter: bridge: add connection tracking system
  netfilter: nf_conntrack_bridge: add support for IPv6
  netfilter: nf_conntrack_bridge: register inet conntrack for bridge

 include/linux/netfilter_ipv6.h              |  50 ++++
 include/net/ip.h                            |  39 +++
 include/net/ipv6.h                          |  44 +++
 include/net/netfilter/nf_conntrack.h        |   1 +
 include/net/netfilter/nf_conntrack_bridge.h |  20 ++
 include/net/netfilter/nf_conntrack_core.h   |   3 +
 net/bridge/br_device.c                      |   1 +
 net/bridge/br_private.h                     |   1 +
 net/bridge/netfilter/Kconfig                |  14 +
 net/bridge/netfilter/Makefile               |   3 +
 net/bridge/netfilter/nf_conntrack_bridge.c  | 433 ++++++++++++++++++++++++++++
 net/ipv4/ip_output.c                        | 309 ++++++++++++--------
 net/ipv6/ip6_output.c                       | 315 +++++++++++---------
 net/ipv6/netfilter.c                        | 123 ++++++++
 net/netfilter/nf_conntrack_proto.c          | 126 ++++++--
 15 files changed, 1206 insertions(+), 276 deletions(-)
 create mode 100644 include/net/netfilter/nf_conntrack_bridge.h
 create mode 100644 net/bridge/netfilter/nf_conntrack_bridge.c

-- 
2.11.0

