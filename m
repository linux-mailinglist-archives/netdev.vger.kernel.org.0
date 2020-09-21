Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F52272579
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbgIUN1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbgIUN1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:27:04 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A569C061755;
        Mon, 21 Sep 2020 06:27:04 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kKLqQ-008F3B-Tv; Mon, 21 Sep 2020 15:27:03 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2020-09-21
Date:   Mon, 21 Sep 2020 15:26:57 +0200
Message-Id: <20200921132658.26869-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

And for net-next, we have a bit more content. There's more
in the pipeline for S1G (see below), but I figure I'd "flush"
this out, in particular so Felix can take advantage of it in
the driver updates.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 1d39cd8cf75f79d082ee97f5fd2a6286bcc692c1:

  mptcp: fix integer overflow in mptcp_subflow_discard_data() (2020-09-17 18:04:48 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2020-09-21

for you to fetch changes up to 7fba53ebb5b2d89d95b697f4c42c73c6fb7ba0c6:

  mac80211: fix some encapsulation offload kernel-doc (2020-09-18 14:06:20 +0200)

----------------------------------------------------------------
This time we have:
 * some AP-side infrastructure for FILS discovery and
   unsolicited probe resonses
 * a major rework of the encapsulation/header conversion
   offload from Felix, to fit better with e.g. AP_VLAN
   interfaces
 * performance fix for VHT A-MPDU size, don't limit to HT
 * some initial patches for S1G (sub 1 GHz) support, more
   will come in this area
 * minor cleanups

----------------------------------------------------------------
Aloka Dixit (4):
      nl80211: Add FILS discovery support
      mac80211: Add FILS discovery support
      nl80211: Unsolicited broadcast probe response support
      mac80211: Unsolicited broadcast probe response support

Felix Fietkau (15):
      mac80211: add missing queue/hash initialization to 802.3 xmit
      mac80211: check and refresh aggregation session in encap offload tx
      mac80211: skip encap offload for tx multicast/control packets
      mac80211: set info->control.hw_key for encap offload packets
      mac80211: rework tx encapsulation offload API
      mac80211: reduce duplication in tx status functions
      mac80211: remove tx status call to ieee80211_sta_register_airtime
      mac80211: swap NEED_TXPROCESSING and HW_80211_ENCAP tx flags
      mac80211: notify the driver when a sta uses 4-address mode
      mac80211: optimize station connection monitor
      mac80211: unify 802.3 (offload) and 802.11 tx status codepath
      mac80211: support using ieee80211_tx_status_ext to free skbs without status info
      mac80211: extend ieee80211_tx_status_ext to support bulk free
      mac80211: reorganize code to remove a forward declaration
      mac80211: allow bigger A-MSDU sizes in VHT, even if HT is limited

Johannes Berg (2):
      cfg80211: add missing kernel-doc for S1G band capabilities
      mac80211: fix some encapsulation offload kernel-doc

Thomas Pedersen (5):
      ieee80211: redefine S1G bits with GENMASK
      nl80211: advertise supported channel width in S1G
      cfg80211: regulatory: handle S1G channels
      nl80211: correctly validate S1G beacon head
      nl80211: support setting S1G channels

Wright Feng (1):
      cfg80211: add more comments for ap_isolate in bss_parameters

YueHaibing (1):
      lib80211: Remove unused macro DRV_NAME

 drivers/net/wireless/ath/ath11k/dp_tx.c |    4 +-
 drivers/net/wireless/ath/ath11k/mac.c   |   65 +-
 include/linux/ieee80211.h               |  156 +--
 include/net/cfg80211.h                  |   64 ++
 include/net/mac80211.h                  |  103 +-
 include/uapi/linux/nl80211.h            |   95 ++
 net/mac80211/cfg.c                      |   96 +-
 net/mac80211/debugfs.c                  |    1 +
 net/mac80211/driver-ops.h               |   29 +
 net/mac80211/ieee80211_i.h              |   19 +-
 net/mac80211/iface.c                    | 1573 ++++++++++++++++---------------
 net/mac80211/key.c                      |   15 -
 net/mac80211/mesh_hwmp.c                |    4 +-
 net/mac80211/mesh_ps.c                  |    2 +-
 net/mac80211/mlme.c                     |   56 +-
 net/mac80211/rx.c                       |   11 +-
 net/mac80211/sta_info.h                 |    2 -
 net/mac80211/status.c                   |  213 ++---
 net/mac80211/trace.h                    |   33 +
 net/mac80211/tx.c                       |  170 ++--
 net/mac80211/vht.c                      |    4 -
 net/wireless/chan.c                     |  130 ++-
 net/wireless/lib80211.c                 |    2 -
 net/wireless/nl80211.c                  |  127 ++-
 net/wireless/reg.c                      |   70 +-
 net/wireless/util.c                     |   32 +
 26 files changed, 1858 insertions(+), 1218 deletions(-)

