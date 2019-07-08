Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A836E625A3
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391000AbfGHQG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:06:26 -0400
Received: from mail.us.es ([193.147.175.20]:52644 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729665AbfGHQG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 12:06:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AF824FC5F5
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 18:06:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F89F1021A8
        for <netdev@vger.kernel.org>; Mon,  8 Jul 2019 18:06:21 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7EEF66D2B2; Mon,  8 Jul 2019 18:06:21 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9FD91DA7B6;
        Mon,  8 Jul 2019 18:06:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 18:06:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 767D94265A2F;
        Mon,  8 Jul 2019 18:06:17 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ogerlitz@mellanox.com, Manish.Chopra@cavium.com,
        marcelo.leitner@gmail.com, mkubecek@suse.cz,
        venkatkumar.duvvuru@broadcom.com, maxime.chevallier@bootlin.com,
        cphealy@gmail.com, netfilter-devel@vger.kernel.org
Subject: [PATCH net-next,v3 00/11] netfilter: add hardware offload infrastructure
Date:   Mon,  8 Jul 2019 18:06:02 +0200
Message-Id: <20190708160614.2226-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset adds support for Netfilter hardware offloads.

This patchset reuses the existing block infrastructure, the
netdev_ops->ndo_setup_tc() interface, TC_SETUP_CLSFLOWER classifier and
the flow rule API.

Patch #1 adds flow_block_cb_setup_simple(), most drivers do the same thing
         to set up flow blocks, to reduce the number of changes, consolidate
         codebase. Use _simple() postfix as requested by Jakub Kicinski.
         This new function resides in net/core/flow_offload.c

Patch #2 renames TC_BLOCK_{UN}BIND to FLOW_BLOCK_{UN}BIND.

Patch #3 renames TCF_BLOCK_BINDER_TYPE_* to FLOW_BLOCK_BINDER_TYPE_*.

Patch #4 adds flow_block_cb_alloc() and flow_block_cb_free() helper
         functions, this is the first patch of the flow block API.

Patch #5 adds the helper to deal with list operations in the flow block API.
         This includes flow_block_cb_lookup(), flow_block_cb_add() and
	 flow_block_cb_remove().

Patch #6 adds flow_block_cb_priv(), flow_block_cb_incref() and
         flow_block_cb_decref() which completes the flow block API.

Patch #7 updates the cls_api to use the flow block API from the new
         tcf_block_setup(). This infrastructure transports these objects
         via list (through the tc_block_offload object) back to the core
	 for registration.

            CLS_API                           DRIVER
        TC_SETUP_BLOCK    ---------->  setup flow_block_cb object &
                                 it adds object to flow_block_offload->cb_list
                                                |
            CLS_API     <-----------------------'
           registers                     list with flow blocks
         flow_block_cb &                   travels back to
       calls ->reoffload               the core for registration

         drivers allocate and sets up (configure the blocks), then
	 registration happens from the core (cls_api and netfilter).

Patch #8 updates drivers to use the flow block API.

Patch #9 removes the tcf block callback API, which is replaced by the
         flow block API.

Patch #10 adds the flow_block_cb_is_busy() helper to check if the block
	  is already used by a subsystem. This helper is invoked from
	  drivers. Once drivers are updated to support for multiple
	  subsystems, they can remove this check.

Patch #11 introduces basic netfilter hardware offload infrastructure
          for the ingress chain. This includes 5-tuple exact matching
          and accept / drop rule actions. Only basechains are supported
          at this stage, no .reoffload callback is implemented either.
          Default policy to "accept" is only supported for now.

        table netdev filter {
                flags offload;

                chain ingress {
                        type filter hook ingress device eth0 priority 0;

                        ip daddr 192.168.0.10 tcp dport 22 drop
                }
        }

This patchset reuses the existing tcf block callback API and it places it
in the flow block callback API in net/core/flow_offload.c.

This series aims to addres Jakub Kicinski's feedback, mostly targeting to
reducing the batch size and reordering patches.

Please, apply. Thanks.

Pablo Neira Ayuso (11):
  net: flow_offload: add flow_block_cb_setup_simple()
  net: flow_offload: rename TC_BLOCK_{UN}BIND to FLOW_BLOCK_{UN}BIND
  net: flow_offload: rename TCF_BLOCK_BINDER_TYPE_* to FLOW_BLOCK_BINDER_TYPE_*
  net: flow_offload: add flow_block_cb_alloc() and flow_block_cb_free()
  net: flow_offload: add list handling functions
  net: flow_offload: add flow_block_cb_{priv,incref,decref}()
  net: sched: use flow block API
  drivers: net: use flow block API
  net: sched: remove tcf block API
  net: flow_offload: add flow_block_cb_is_busy() and use it
  netfilter: nf_tables: add hardware offload support

 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  27 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c      |  29 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  27 +--
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  27 +--
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  36 +--
 drivers/net/ethernet/intel/igb/igb_main.c          |  27 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  30 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  30 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  76 +++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     | 103 +++++---
 drivers/net/ethernet/mscc/ocelot_ace.h             |   4 +-
 drivers/net/ethernet/mscc/ocelot_flower.c          |  47 ++--
 drivers/net/ethernet/mscc/ocelot_tc.c              |  46 ++--
 drivers/net/ethernet/netronome/nfp/abm/cls.c       |  22 +-
 drivers/net/ethernet/netronome/nfp/abm/main.h      |   2 +-
 drivers/net/ethernet/netronome/nfp/bpf/main.c      |  30 +--
 .../net/ethernet/netronome/nfp/flower/offload.c    |  83 ++++---
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  24 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  23 +-
 drivers/net/netdevsim/netdev.c                     |  29 +--
 include/net/flow_offload.h                         |  67 ++++++
 include/net/netfilter/nf_tables.h                  |  13 +
 include/net/netfilter/nf_tables_offload.h          |  76 ++++++
 include/net/pkt_cls.h                              |  89 +------
 include/uapi/linux/netfilter/nf_tables.h           |   2 +
 net/core/flow_offload.c                            | 118 ++++++++++
 net/dsa/slave.c                                    |  33 ++-
 net/netfilter/Makefile                             |   2 +-
 net/netfilter/nf_tables_api.c                      |  22 +-
 net/netfilter/nf_tables_offload.c                  | 261 +++++++++++++++++++++
 net/netfilter/nft_cmp.c                            |  53 +++++
 net/netfilter/nft_immediate.c                      |  31 +++
 net/netfilter/nft_meta.c                           |  27 +++
 net/netfilter/nft_payload.c                        | 187 +++++++++++++++
 net/sched/cls_api.c                                | 213 ++++++++---------
 net/sched/sch_ingress.c                            |   6 +-
 36 files changed, 1298 insertions(+), 624 deletions(-)
 create mode 100644 include/net/netfilter/nf_tables_offload.h
 create mode 100644 net/netfilter/nf_tables_offload.c

-- 
2.11.0

