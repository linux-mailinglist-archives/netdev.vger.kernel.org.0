Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE7A96C42
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731057AbfHTWdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:03 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36958 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730273AbfHTWdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GxTIh4cmWkVOtrD1iokze/SbDbjMj9pKgoHN18Zrovo=; b=acrowvxFRXoIUSeWIpl9Sf15X
        DKoV6vrK5pJW6yQSAjD0btOaeI09gAhiQykunMsj/6OOJtlc2HtQXZpLfQ+zhUAaECtlt76UrisAw
        JggmVOTgxUBt3vGF44EyW12b5TiGJqeQfx7KgXtRYpEXFXpLxwH43OtqfQZIFRuu2K2iZdEc5f2gf
        1Zpa8OlEUsv0xRiahSoFxUDigDTmy4xKTBNPQzcv3SNIPOzL5OOs+bte8ZyGV5JOFr7wpHxqkR12p
        4VXZjhePX3Ca4T1ogv95pRIEY2ZcAfv+eBjrDpDBp99A+bColMqxAyUmTBJKLcvxMuJehnwyZJEng
        czB+QYUOQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgX-0005pW-K4; Tue, 20 Aug 2019 22:33:01 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 00/38] Convert networking to use the XArray
Date:   Tue, 20 Aug 2019 15:32:21 -0700
Message-Id: <20190820223259.22348-1-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Hello good networking folks,

I am attempting to convert all IDR and radix tree users over to the
XArray API so we can remove the radix tree code from the kernel.  This
process is already underway, and you can see all the conversions in a
git tree [1].  

The set of conversions I am submitting to you today are only compile
tested.  I would appreciate it if those who are responsible for each
module could take on the job of making sure I didn't break anything.
Review is, of course, also welcome.

The primary difference between the IDR/radix tree and XArray APIs is that
the XArray embeds a spinlock.  This enables the ability to defragment
the slabs which contain XArray nodes, and for most users results in an
easier-to-use API.

There are a lot of smaller tweaks in the XArray API compared to the radix
tree or IDR APIs.  For example, there is no more preallocation of memory;
instead the XArray will drop the lock if needed to allocate memory.

Ideally, you'd include the patch for your module into your next pull
request to Dave and they'd land upstream in 5.4.  These patches are
against current net-next.  If you'd like to change whitespace or comments
or so on, please just do that; this is your code and I've got a lot of
other patches I need to whip into shape.

[1] http://git.infradead.org/users/willy/linux-dax.git/shortlog/refs/heads/xarray-conv
Some of these conversions are known to be buggy, so I would not recommend
actually running this tree.

Matthew Wilcox (Oracle) (38):
  mlx4: Convert cq_table->tree to XArray
  mlx4: Convert srq_table->tree to XArray
  mlx4: Convert qp_table_tree to XArray
  mlx5: Convert cq_table to XArray
  mlx5: Convert mlx5_qp_table to XArray
  mlx5: Convert counters_idr to XArray
  mlx5: Convert fpga IDRs to XArray
  nfp: Convert to XArray
  ath10k: Convert pending_tx to XArray
  ath10k: Convert mgmt_pending_tx IDR to XArray
  mt76: Convert token IDR to XArray
  mwifiex: Convert ack_status_frames to XArray
  ppp: Convert units_idr to XArray
  tap: Convert minor_idr to XArray
  nfp: Convert internal ports to XArray
  qrtr: Convert qrtr_nodes to XArray
  qrtr: Convert qrtr_ports to XArray
  rxrpc: Convert to XArray
  9p: Convert reqs IDR to XArray
  9p: Convert fids IDR to XArray
  9p: Move lock from client to trans_fd
  sctp: Convert sctp_assocs_id to XArray
  cls_api: Convert tcf_net to XArray
  cls_u32: Convert tc_u_common->handle_idr to XArray
  cls_u32: Convert tc_u_hnode->handle_idr to XArray
  cls_bpf: Convert handle_idr to XArray
  cls_bpf: Remove list of programs
  cls_bpf: Use XArray marks to accelerate re-offload
  cls_flower: Convert handle_idr to XArray
  cls_flower: Use XArray list of filters in fl_walk
  cls_flower: Use XArray marks instead of separate list
  cls_basic: Convert handle_idr to XArray
  act_api: Convert action_idr to XArray
  net_namespace: Convert netns_ids to XArray
  tipc: Convert conn_idr to XArray
  netlink: Convert genl_fam_idr to XArray
  mac80211: Convert ack_status_frames to XArray
  mac80211: Convert function_inst_ids to XArray

 drivers/infiniband/hw/mlx4/cq.c               |   2 +-
 drivers/net/ethernet/mellanox/mlx4/cq.c       |  30 ++---
 drivers/net/ethernet/mellanox/mlx4/mlx4.h     |   9 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c       |  37 ++---
 drivers/net/ethernet/mellanox/mlx4/srq.c      |  33 ++---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  27 +---
 .../ethernet/mellanox/mlx5/core/fpga/tls.c    |  54 +++-----
 .../ethernet/mellanox/mlx5/core/fpga/tls.h    |   6 +-
 .../ethernet/mellanox/mlx5/core/fs_counters.c |  31 ++---
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c  |  38 ++----
 drivers/net/ethernet/netronome/nfp/abm/main.c |   4 +-
 drivers/net/ethernet/netronome/nfp/abm/main.h |   4 +-
 .../net/ethernet/netronome/nfp/abm/qdisc.c    |  33 ++---
 .../net/ethernet/netronome/nfp/flower/main.c  |  44 +++---
 .../net/ethernet/netronome/nfp/flower/main.h  |  12 +-
 drivers/net/ppp/ppp_generic.c                 |  73 +++-------
 drivers/net/tap.c                             |  32 ++---
 drivers/net/wireless/ath/ath10k/core.h        |   2 +-
 drivers/net/wireless/ath/ath10k/htt.h         |   2 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c      |  31 ++---
 drivers/net/wireless/ath/ath10k/mac.c         |   4 +-
 drivers/net/wireless/ath/ath10k/txrx.c        |   2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c     |   8 +-
 drivers/net/wireless/ath/ath10k/wmi.c         |  43 +++---
 drivers/net/wireless/marvell/mwifiex/init.c   |   4 +-
 drivers/net/wireless/marvell/mwifiex/main.c   |  10 +-
 drivers/net/wireless/marvell/mwifiex/main.h   |   4 +-
 drivers/net/wireless/marvell/mwifiex/txrx.c   |   4 +-
 drivers/net/wireless/marvell/mwifiex/wmm.c    |  15 +--
 .../net/wireless/mediatek/mt76/mt7615/init.c  |  11 +-
 .../net/wireless/mediatek/mt76/mt7615/mac.c   |  24 ++--
 .../wireless/mediatek/mt76/mt7615/mt7615.h    |   4 +-
 include/linux/mlx4/device.h                   |   4 +-
 include/linux/mlx4/qp.h                       |   2 +-
 include/linux/mlx5/driver.h                   |  11 +-
 include/linux/mlx5/qp.h                       |   2 +-
 include/net/9p/client.h                       |  11 +-
 include/net/act_api.h                         |   6 +-
 include/net/net_namespace.h                   |   2 +-
 include/net/sctp/sctp.h                       |   5 +-
 net/9p/client.c                               |  65 ++++-----
 net/9p/trans_fd.c                             |  37 ++---
 net/9p/trans_rdma.c                           |   1 -
 net/9p/trans_virtio.c                         |   1 -
 net/core/net_namespace.c                      |  65 ++++-----
 net/mac80211/cfg.c                            |  70 ++++------
 net/mac80211/ieee80211_i.h                    |  12 +-
 net/mac80211/iface.c                          |  16 +--
 net/mac80211/main.c                           |  20 ++-
 net/mac80211/status.c                         |   6 +-
 net/mac80211/tx.c                             |  16 +--
 net/mac80211/util.c                           |  30 +----
 net/netlink/genetlink.c                       |  46 +++----
 net/qrtr/qrtr.c                               |  66 ++++-----
 net/rxrpc/af_rxrpc.c                          |   2 +-
 net/rxrpc/ar-internal.h                       |   3 +-
 net/rxrpc/conn_client.c                       |  49 +++----
 net/rxrpc/conn_object.c                       |   2 +-
 net/sched/act_api.c                           | 127 +++++++-----------
 net/sched/cls_api.c                           |  27 +---
 net/sched/cls_basic.c                         |  56 +++-----
 net/sched/cls_bpf.c                           |  74 +++++-----
 net/sched/cls_flower.c                        | 114 ++++++----------
 net/sched/cls_u32.c                           |  63 ++++-----
 net/sctp/associola.c                          |  34 ++---
 net/sctp/protocol.c                           |   6 -
 net/sctp/sm_make_chunk.c                      |   2 +-
 net/sctp/socket.c                             |   6 +-
 net/tipc/topsrv.c                             |  49 ++-----
 70 files changed, 650 insertions(+), 1102 deletions(-)

-- 
2.23.0.rc1

