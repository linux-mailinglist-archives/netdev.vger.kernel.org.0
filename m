Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316F21D1B54
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389581AbgEMQlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:41:53 -0400
Received: from correo.us.es ([193.147.175.20]:53944 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389405AbgEMQlx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 12:41:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 52EBA27F8AB
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 18:41:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39EE2115417
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 18:41:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2DF62958B4; Wed, 13 May 2020 18:41:50 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E0EBD20670;
        Wed, 13 May 2020 18:41:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 13 May 2020 18:41:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 870EA42EF4E0;
        Wed, 13 May 2020 18:41:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, vladbu@mellanox.com, jiri@resnulli.us,
        kuba@kernel.org, saeedm@mellanox.com, michael.chan@broadcom.com
Subject: [PATCH 0/8 net] the indirect flow_block offload, revisited
Date:   Wed, 13 May 2020 18:41:32 +0200
Message-Id: <20200513164140.7956-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset fixes the indirect flow_block support for the tc CT action
offload. Please, note that this batch is probably slightly large for the
net tree, however, I could not find a simple incremental fix.

= The problem

The nf_flow_table_indr_block_cb() function provides the tunnel netdevice
and the indirect flow_block driver callback. From this tunnel netdevice,
it is not possible to obtain the tc CT flow_block. Note that tc qdisc
and netfilter backtrack from the tunnel netdevice to the tc block /
netfilter chain to reach the flow_block object. This allows them to
clean up the hardware offload rules if the tunnel device is removed.

= What is the indirect flow_block infrastructure?

The indirect flow_block infrastructure allows drivers to offload
tc/netfilter rules that belong to software tunnel netdevices, e.g.
vxlan.

This indirect flow_block infrastructure relates tunnel netdevices with
drivers because there is no obvious way to relate these two things
from the control plane.

= How does the indirect flow_block work before this patchset?

Front-ends register the indirect flow_block callback through
flow_indr_add_block_cb() if they support for offloading tunnel
netdevices.

== Setting up an indirect flow_block

1) Drivers track tunnel netdevices via NETDEV_{REGISTER,UNREGISTER} events.
   If there is a new tunnel netdevice that the driver can offload, then the
   driver invokes __flow_indr_block_cb_register() with the new tunnel
   netdevice and the driver callback. The __flow_indr_block_cb_register()
   call iterates over the list of the front-end callbacks.

2) The front-end callback sets up the flow_block_offload structure and it
   invokes the driver callback to set up the flow_block.

3) The driver callback now registers the flow_block structure and it
   returns the flow_block back to the front-end.

4) The front-end gets the flow_block object and it is now ready to
   offload rules for this tunnel netdevice.

A simplified callgraph is represented below.

        Front-end                      Driver

                                   NETDEV_REGISTER
                                         |
                         __flow_indr_block_cb_register(netdev, cb_priv, driver_cb)
                                         | [1]
            .----------  frontend_indr_block_cb(cb_priv, driver_cb)
            |
   setup_flow_block_offload(bo)
            | [2]
   driver_cb(bo, cb_priv) ---------------.
                                         |
                                  set up flow_blocks [3]
                                         |
   add rules to flow_block <-------------'
   TC_SETUP_CLSFLOWER [4]

== Releasing the indirect flow_block

There are two possibilities, either tunnel netdevice is removed or
a netdevice (port representor) is removed.

=== Tunnel netdevice is removed

Driver waits for the NETDEV_UNREGISTER event that announces the tunnel
netdevice removal. Then, it calls __flow_indr_block_cb_unregister() to
remove the flow_block and rules.  Callgraph is very similar to the one
described above.

=== Netdevice is removed (port representor)

Driver calls __flow_indr_block_cb_unregister() to remove the existing
netfilter/tc rule that belong to the tunnel netdevice.

= How does the indirect flow_block work after this patchset?

Drivers register the indirect flow_block setup callback through
flow_indr_dev_register() if they support for offloading tunnel
netdevices.

== Setting up an indirect flow_block

1) Frontends check if dev->netdev_ops->ndo_setup_tc is unset. If so,
   frontends call flow_indr_dev_setup_offload(). This call invokes
   the drivers' indirect flow_block setup callback.

2) The indirect flow_block setup callback sets up a flow_block structure
   which relates the tunnel netdevice and the driver.

3) The front-end uses flow_block and offload the rules.

Note that the operational to set up (non-indirect) flow_block is very
similar.

== Releasing the indirect flow_block

=== Tunnel netdevice is removed

This calls flow_indr_dev_setup_offload() to set down the flow_block and
remove the offloaded rules. This alternate path is exercised if
dev->netdev_ops->ndo_setup_tc is unset.

=== Netdevice is removed (port representor)

If a netdevice is removed, then it might need to to clean up the
offloaded tc/netfilter rules that belongs to the tunnel netdevice:

1) The driver invokes flow_indr_dev_unregister() when a netdevice is
   removed.

2) This call iterates over the existing indirect flow_blocks
   and it invokes the cleanup callback to let the front-end remove the
   tc/netfilter rules. The cleanup callback already provides the
   flow_block that the front-end needs to clean up.

        Front-end                      Driver

                                         |
                            flow_indr_dev_unregister(...)
                                         |
                         iterate over list of indirect flow_block
                               and invoke cleanup callback
                                         |
            .-----------------------------
            |
            .
   frontend_flow_block_cleanup(flow_block)
            .
            |
           \/
   remove rules to flow_block
      TC_SETUP_CLSFLOWER

= About this patchset

This patchset aims to address the existing TC CT problem while
simplifying the indirect flow_block infrastructure. Saving 300 LoC in
the flow_offload core and the drivers. The operational gets aligned with
the (non-indirect) flow_blocks logic. Patchset is composed of:

Patch #1 add nf_flow_table_gc_cleanup() which is required by the
         netfilter's flowtable new indirect flow_block approach.

Patch #2 adds the flow_block_indr object which is actually part of
         of the flow_block object. This stores the indirect flow_block
	 metadata such as the tunnel netdevice owner and the cleanup
	 callback (in case the tunnel netdevice goes away).

	 This patch adds flow_indr_dev_{un}register() to allow drivers
         to offer netdevice tunnel hardware offload to the front-ends.
	 Then, front-ends call flow_indr_dev_setup_offload() to invoke
	 the drivers to set up the (indirect) flow_block.

Patch #3 add the tcf_block_offload_init() helper function, this is
	 a preparation patch to adapt the tc front-end to use this
	 new indirect flow_block infrastructure.

Patch #4 updates the tc and netfilter front-ends to use the new
	 indirect flow_block infrastructure.

Patch #5 updates the mlx5 driver to use the new indirect flow_block
	 infrastructure.

Patch #6 updates the nfp driver to use the new indirect flow_block
         infrastructure.

Patch #7 updates the bnxt driver to use the new indirect flow_block
         infrastructure.

Patch #8 removes the indirect flow_block infrastructure version 1,
         now that frontends and drivers have been translated to
	 version 2 (coming in this patchset).

Please, apply.

Pablo Neira Ayuso (8):
  netfilter: nf_flowtable: expose nf_flow_table_gc_cleanup()
  net: flow_offload: consolidate indirect flow_block infrastructure
  net: cls_api: add tcf_block_offload_init()
  net: use flow_indr_dev_setup_offload()
  mlx5: update indirect block support
  nfp: update indirect block support
  bnxt_tc: update indirect block support
  net: remove indirect block netdev event registration

 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  51 +--
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  83 +----
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   5 -
 .../net/ethernet/netronome/nfp/flower/main.c  |  11 +-
 .../net/ethernet/netronome/nfp/flower/main.h  |   7 +-
 .../ethernet/netronome/nfp/flower/offload.c   |  35 +-
 include/net/flow_offload.h                    |  28 +-
 include/net/netfilter/nf_flow_table.h         |   2 +
 net/core/flow_offload.c                       | 301 +++++++-----------
 net/netfilter/nf_flow_table_core.c            |   6 +-
 net/netfilter/nf_flow_table_offload.c         |  85 +----
 net/netfilter/nf_tables_offload.c             |  69 ++--
 net/sched/cls_api.c                           | 157 +++------
 14 files changed, 251 insertions(+), 590 deletions(-)

--
2.20.1

