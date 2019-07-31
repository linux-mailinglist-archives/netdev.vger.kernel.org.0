Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B637B7C786
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 17:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbfGaPvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 11:51:10 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34898 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfGaPvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 11:51:10 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hsqsa-0003he-2P; Wed, 31 Jul 2019 17:51:04 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2019-07-31
Date:   Wed, 31 Jul 2019 17:50:56 +0200
Message-Id: <20190731155057.23035-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

There's a fair number of changes here, so I thought I'd get them out.
I've included two Intel driver cleanups because Luca is on vacation,
I'm covering for him, and doing it all in one tree let me merge all
of the patches at once (including mac80211 that depends on that);
Kalle is aware.

Also, though this isn't very interesting yet, I've started looking at
weaning the wireless subsystem off the RTNL for all operations, as it
can cause significant lock contention, especially with slow USB devices.
The real patches for that are some way off, but one preparation here is
to use generic netlink's parallel_ops=true, to avoid trading one place
with contention for another in the future, and to avoid adding more
genl_family_attrbuf() usage (since that's no longer possible with the
parallel_ops setting).

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 00c33afbf9dd06f77a2f15117cd4bdc2a54b51d7:

  net: mvneta: use devm_platform_ioremap_resource() to simplify code (2019-07-25 17:28:11 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2019-07-31

for you to fetch changes up to f39b07fdfb688724fedabf5507e15eaf398f2500:

  mac80211: HE STA disassoc due to QOS NULL not sent (2019-07-31 13:26:41 +0200)

----------------------------------------------------------------
We have a reasonably large number of changes:
 * lots more HE (802.11ax) support, particularly things
   relevant for the the AP side, but also mesh support
 * debugfs cleanups from Greg
 * some more work on extended key ID
 * start using genl parallel_ops, as preparation for
   weaning ourselves off RTNL and getting parallelism
 * various other changes all over

----------------------------------------------------------------
Alexander Wetzel (3):
      mac80211_hwsim: Extended Key ID API update
      mac80211: Simplify Extended Key ID API
      mac80211: AMPDU handling for rekeys with Extended Key ID

Ard Biesheuvel (1):
      lib80211: use crypto API ccm(aes) transform for CCMP processing

Christophe JAILLET (1):
      mac80211_hwsim: Fix a typo in the name of function 'mac80211_hswim_he_capab()'

Colin Ian King (1):
      mac80211: add missing null return check from call to ieee80211_get_sband

Denis Kenzior (2):
      nl80211: document uapi for CMD_FRAME_WAIT_CANCEL
      nl80211: Include wiphy address setup in NEW_WIPHY

Emmanuel Grumbach (1):
      mac80211: pass the vif to cancel_remain_on_channel

Erik Stromdahl (1):
      mac80211: add tx dequeue function for process context

Greg Kroah-Hartman (4):
      iwlwifi: dvm: no need to check return value of debugfs_create functions
      iwlwifi: mvm: remove unused .remove_sta_debugfs callback
      mac80211: remove unused and unneeded remove_sta_debugfs callback
      cfg80211: no need to check return value of debugfs_create functions

Johannes Berg (6):
      cfg80211: clean up cfg80211_inform_single_bss_frame_data()
      cfg80211: don't parse MBSSID if transmitting BSS isn't created
      cfg80211: give all multi-BSSID BSS entries the same timestamp
      mac80211_hwsim: fill boottime_ns in netlink RX path
      cfg80211: use parallel_ops for genl
      nl80211: add strict start type

John Crispin (10):
      mac80211: add support for parsing ADDBA_EXT IEs
      mac80211: add xmit rate to struct ieee80211_tx_status
      mac80211: propagate struct ieee80211_tx_status into ieee80211_tx_monitor()
      mac80211: add struct ieee80211_tx_status support to ieee80211_add_tx_radiotap_header
      mac80211: HE: add Spatial Reuse element parsing support
      mac80211: fix ieee80211_he_oper_size() comment
      mac80211: propagate HE operation info into bss_conf
      mac80211: add support for the ADDBA extension element
      cfg80211: add support for parsing OBBS_PD attributes
      mac80211: allow setting spatial reuse parameters from bss_conf

Karthikeyan Periyasamy (1):
      mac80211: reject zero MAC address in add station

Lorenzo Bianconi (1):
      mac80211: add IEEE80211_KEY_FLAG_GENERATE_MMIE to ieee80211_key_flags

Michael Vassernis (1):
      cfg80211: fix dfs channels remain DFS_AVAILABLE after ch_switch

Sergey Matyukevich (2):
      cfg80211: refactor cfg80211_bss_update
      cfg80211: fix duplicated scan entries after channel switch

Shay Bar (1):
      mac80211: HE STA disassoc due to QOS NULL not sent

Sven Eckelmann (1):
      mac80211: implement HE support for mesh

 drivers/net/wireless/ath/ath10k/mac.c             |   3 +-
 drivers/net/wireless/ath/ath9k/main.c             |   3 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c       |  29 +--
 drivers/net/wireless/intel/iwlwifi/dvm/rs.h       |   4 -
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c       |   5 -
 drivers/net/wireless/mac80211_hwsim.c             |  20 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c       |   3 +-
 drivers/net/wireless/ti/wlcore/main.c             |   3 +-
 include/linux/ieee80211.h                         |  63 ++++-
 include/net/cfg80211.h                            |  15 ++
 include/net/mac80211.h                            |  53 ++++-
 include/uapi/linux/nl80211.h                      |  31 ++-
 net/mac80211/agg-rx.c                             |  72 +++++-
 net/mac80211/cfg.c                                |   7 +-
 net/mac80211/debugfs.c                            |   3 +-
 net/mac80211/driver-ops.h                         |   8 +-
 net/mac80211/he.c                                 |  39 ++++
 net/mac80211/ht.c                                 |   2 +-
 net/mac80211/ieee80211_i.h                        |  17 +-
 net/mac80211/key.c                                |  16 +-
 net/mac80211/main.c                               |  18 +-
 net/mac80211/mesh.c                               |  62 +++++
 net/mac80211/mesh.h                               |   4 +
 net/mac80211/mesh_plink.c                         |  12 +-
 net/mac80211/mlme.c                               |   7 +-
 net/mac80211/offchannel.c                         |   5 +-
 net/mac80211/rate.h                               |   9 -
 net/mac80211/sta_info.c                           |   1 -
 net/mac80211/status.c                             | 180 +++++++++++++--
 net/mac80211/trace.h                              |   7 +-
 net/mac80211/tx.c                                 |   5 +-
 net/mac80211/util.c                               |  60 +++++
 net/mac80211/wpa.c                                |   6 +-
 net/wireless/Kconfig                              |   2 +
 net/wireless/core.c                               |  17 +-
 net/wireless/core.h                               |   2 +
 net/wireless/lib80211_crypt_ccmp.c                | 197 +++++++---------
 net/wireless/nl80211.c                            | 182 ++++++++++++---
 net/wireless/scan.c                               | 269 ++++++++++++++--------
 40 files changed, 1070 insertions(+), 374 deletions(-)

