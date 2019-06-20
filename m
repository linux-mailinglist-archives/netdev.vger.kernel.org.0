Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 452364DA91
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 21:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfFTTtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 15:49:35 -0400
Received: from mail.us.es ([193.147.175.20]:53838 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbfFTTtf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 15:49:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BF3CAB6C8F
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:49:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8E9F5DA706
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:49:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 46339DA708; Thu, 20 Jun 2019 21:49:29 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E706DDA702;
        Thu, 20 Jun 2019 21:49:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Jun 2019 21:49:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id AA4804265A2F;
        Thu, 20 Jun 2019 21:49:25 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        cphealy@gmail.com
Subject: [PATCH net-next 00/12] netfilter: add hardware offload infrastructure
Date:   Thu, 20 Jun 2019 21:49:05 +0200
Message-Id: <20190620194917.2298-1-pablo@netfilter.org>
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

Patch #1 moves tcf_block_cb code before the indirect block
	 infrastructure to avoid forward declarations in the next
	 patches. This is just a preparation patch.

Patch #2 adds tcf_block_cb_alloc() to allocate flow block callbacks.

Patch #3 adds tcf_block_cb_free() to release flow block callbacks.

Patch #4 adds the tcf_block_setup() infrastructure, which allows drivers
         to set up flow block callbacks. This infrastructure transports
         these objects via list (through the tc_block_offload object)
	 back to the core for registration.

            CLS_API                           DRIVER
        TC_SETUP_BLOCK    ---------->  setup flow_block_cb object &
                                 it adds object to flow_block_offload->cb_list
                                                |
            CLS_API     <-----------------------'
           registers                     list if flow block
         flow_block_cb &                   travels back to
       calls ->reoffload               the core for registration

Patch #5 extends tcf_block_cb_alloc() to allow drivers to set a release
	 callback that is invoked from tcf_block_cb_free() to release
         private driver block information.

Patch #6 adds tcf_setup_block_offload(), this helper function is used by
         most drivers to setup the block, including common bind and
         unbind operations.

Patch #7 adapts drivers to use the infrastructure introduced in Patch #4.

Patch #8 stops exposing the tc block structure to drivers, by caching
	 the only information that drivers need, ie. block is shared
	 flag.

Patch #9 removes the tcf_block_cb_register() / _unregister()
	 infrastructure, since it is now unused after Patch #7.

Patch #10 moves the flow_block API to the net/core/flow_offload.c core.
          This renames tcf_block_cb to flow_block_cb as well as the
	  functions to allocate, release, lookup and setup flow block
	  callbacks.

Patch #11 makes sure that only one flow block callback per device is
          possible by now. This means only one of the ethtool / tc /
          netfilter subsystems can use hardware offloads, until drivers
	  are updated to remove this limitation.

Patch #12 introduces basic netfilter hardware offload infrastructure
	  for the ingress chain. This includes 5-tuple matching and
          accept / drop actions. Only basechains are supported at this
          stage, no .reoffload callback is implemented either.

Please, apply, thanks.

Pablo Neira Ayuso (12):
  net: sched: move tcf_block_cb before indr_block
  net: sched: add tcf_block_cb_alloc()
  net: sched: add tcf_block_cb_free()
  net: sched: add tcf_block_setup()
  net: sched: add release callback to struct tcf_block_cb
  net: sched: add tcf_setup_block_offload()
  net: use tcf_block_setup() infrastructure
  net: cls_api: do not expose tcf_block to drivers
  net: sched: remove tcf_block_cb_{register,unregister}()
  net: flow_offload: add flow_block_cb API
  net: flow_offload: don't allow block sharing until drivers support this
  netfilter: nf_tables: add hardware offload support

 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  26 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c      |  28 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  26 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  26 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  35 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  24 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  27 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  27 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  62 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  87 ++--
 drivers/net/ethernet/mscc/ocelot_ace.h             |   4 +-
 drivers/net/ethernet/mscc/ocelot_flower.c          |  45 +-
 drivers/net/ethernet/mscc/ocelot_tc.c              |  28 +-
 drivers/net/ethernet/netronome/nfp/abm/cls.c       |  19 +-
 drivers/net/ethernet/netronome/nfp/abm/main.h      |   2 +-
 drivers/net/ethernet/netronome/nfp/bpf/main.c      |  29 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |  63 ++-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  23 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  22 +-
 drivers/net/netdevsim/netdev.c                     |  26 +-
 include/net/flow_offload.h                         |  52 +++
 include/net/netfilter/nf_tables.h                  |  13 +
 include/net/netfilter/nf_tables_offload.h          |  76 ++++
 include/net/pkt_cls.h                              |  90 +---
 include/uapi/linux/netfilter/nf_tables.h           |   2 +
 net/core/flow_offload.c                            | 121 +++++
 net/dsa/slave.c                                    |  16 +-
 net/netfilter/Makefile                             |   2 +-
 net/netfilter/nf_tables_api.c                      |  22 +-
 net/netfilter/nf_tables_offload.c                  | 233 ++++++++++
 net/netfilter/nft_cmp.c                            |  53 +++
 net/netfilter/nft_immediate.c                      |  31 ++
 net/netfilter/nft_meta.c                           |  27 ++
 net/netfilter/nft_payload.c                        | 187 ++++++++
 net/sched/cls_api.c                                | 502 ++++++++++-----------
 35 files changed, 1305 insertions(+), 751 deletions(-)
 create mode 100644 include/net/netfilter/nf_tables_offload.h
 create mode 100644 net/netfilter/nf_tables_offload.c

-- 
2.11.0

