Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E345EF836C
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfKKXaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:30:07 -0500
Received: from correo.us.es ([193.147.175.20]:40956 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726902AbfKKXaH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 18:30:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8DA781C439A
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:30:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7CE05FB362
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:30:02 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 71D90D2B1E; Tue, 12 Nov 2019 00:30:02 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B5A3A8E5;
        Tue, 12 Nov 2019 00:30:00 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 00:30:00 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id ECDB342EF4E0;
        Tue, 12 Nov 2019 00:29:59 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, majd@mellanox.com, saeedm@mellanox.com
Subject: [PATCH net-next 0/6] netfilter flowtable hardware offload
Date:   Tue, 12 Nov 2019 00:29:50 +0100
Message-Id: <20191111232956.24898-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset adds hardware offload support for the flowtable
infrastructure [1]. This infrastructure provides a fast datapath for
the classic Linux forwarding path that users can enable through policy,
eg.

 table inet x {
      flowtable f {
               hook ingress priority 10 devices = { eth0, eth1 }
	       flags offload
      }
      chain y {
               type filter hook forward priority 0; policy accept;
               ip protocol tcp flow offload @f
      }
 }

This example above enables the fastpath for TCP traffic between devices
eth0 and eth1. Users can turn on the hardware offload through the
'offload' flag from the flowtable definition. If this new flag is not
specified, the software flowtable datapath is used.

This patchset is composed of 4 preparation patches:

#1 Move pointer to conntrack object to the flow_offload structure.
#2 Remove useless union from the flow_offload structure.
#3 Remove superfluous flow_offload_entry structure.
#4 Detach routing information from the flow_offload object to leave
   room to extend this infrastructure, eg. accelerate bridge forwarding.

And 2 patches to add the hardware offload control and data planes:

#5 Add the netlink control plane and the interface to set up the flowtable
   hardware offload. This includes a new NFTA_FLOWTABLE_FLAGS netlink
   attribute to convey the optional NF_FLOWTABLE_HW_OFFLOAD flag.
#6 Add the hardware offload datapath: This code uses the flow_offload
   API available at net/core/flow_offload.h to represent the flow
   through two flow_rule objects to configure an exact 5-tuple matching
   on each direction plus the corresponding forwarding actions, that is,
   the MAC address, NAT and checksum updates; and port redirection in
   order to configure the hardware datapath. This patch only supports
   for IPv4 support and statistics collection for flow aging as an initial
   step.

This patchset introduces a new flow_block callback type that needs to be
set up to configure the flowtable hardware offload.

The first client of this infrastructure follows up after this batch.
I would like to thank Mellanox for developing the first upstream driver
to use this infrastructure.

Please, apply.

[1] Documentation/networking/nf_flowtable.txt

Pablo Neira Ayuso (6):
  netfilter: nf_flow_table: move conntrack object to struct flow_offload
  netfilter: nf_flow_table: remove union from flow_offload structure
  netfilter: nf_flowtable: remove flow_offload_entry structure
  netfilter: nf_flow_table: detach routing information from flow description
  netfilter: nf_tables: add flowtable offload control plane
  netfilter: nf_flow_table: hardware offload support

 include/linux/netdevice.h                |   1 +
 include/net/netfilter/nf_flow_table.h    |  60 ++-
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/ipv4/netfilter/nf_flow_table_ipv4.c  |   2 +
 net/ipv6/netfilter/nf_flow_table_ipv6.c  |   2 +
 net/netfilter/Makefile                   |   3 +-
 net/netfilter/nf_flow_table_core.c       | 173 ++++---
 net/netfilter/nf_flow_table_inet.c       |   2 +
 net/netfilter/nf_flow_table_offload.c    | 758 +++++++++++++++++++++++++++++++
 net/netfilter/nf_tables_api.c            |  21 +-
 net/netfilter/nft_flow_offload.c         |   5 +-
 11 files changed, 955 insertions(+), 74 deletions(-)
 create mode 100644 net/netfilter/nf_flow_table_offload.c

-- 
2.11.0

