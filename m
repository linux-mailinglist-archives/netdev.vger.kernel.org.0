Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3594237AE9C
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 20:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhEKSqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 14:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbhEKSqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 14:46:09 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0C0C061574;
        Tue, 11 May 2021 11:45:02 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lgXNM-007b3L-VM; Tue, 11 May 2021 20:45:01 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2021-05-11
Date:   Tue, 11 May 2021 20:44:53 +0200
Message-Id: <20210511184454.164893-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

So exciting times, for the first pull request for fixes I
have a bunch of security things that have been under embargo
for a while - see more details in the tag below, and at the
patch posting message I linked to.

I organized with Kalle to just have a single set of fixes
for mac80211 and ath10k/ath11k, we don't know about any of
the other vendors (the mac80211 + already released firmware
is sufficient to fix iwlwifi.)

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 297c4de6f780b63b6d2af75a730720483bf1904a:

  net: dsa: felix: re-enable TAS guard band mode (2021-05-10 14:48:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2021-05-11

for you to fetch changes up to 210f563b097997ce917e82feab356b298bfd12b0:

  ath11k: Drop multicast fragments (2021-05-11 20:16:30 +0200)

----------------------------------------------------------------
Several security issues in the 802.11 implementations were found by
Mathy Vanhoef (New York University Abu Dhabi), and this contains the
fixes developed for mac80211 and specifically Qualcomm drivers, I'm
sending this together (as agreed with Kalle) to have just a single
set of patches for now. We don't know about other vendors though.

More details in the patch posting:
https://lore.kernel.org/r/20210511180259.159598-1-johannes@sipsolutions.net

----------------------------------------------------------------
Johannes Berg (5):
      mac80211: drop A-MSDUs on old ciphers
      mac80211: add fragment cache to sta_info
      mac80211: check defrag PN against current frame
      mac80211: prevent attacks on TKIP/WEP as well
      mac80211: do not accept/forward invalid EAPOL frames

Mathy Vanhoef (4):
      mac80211: assure all fragments are encrypted
      mac80211: prevent mixed key and fragment cache attacks
      mac80211: properly handle A-MSDUs that start with an RFC 1042 header
      cfg80211: mitigate A-MSDU aggregation attacks

Sriram R (3):
      ath10k: Validate first subframe of A-MSDU before processing the list
      ath11k: Clear the fragment cache during key install
      ath11k: Drop multicast fragments

Wen Gong (6):
      mac80211: extend protection against mixed key and fragment cache attacks
      ath10k: add CCMP PN replay protection for fragmented frames for PCIe
      ath10k: drop fragments with multicast DA for PCIe
      ath10k: drop fragments with multicast DA for SDIO
      ath10k: drop MPDU which has discard flag set by firmware for SDIO
      ath10k: Fix TKIP Michael MIC verification for PCIe

 drivers/net/wireless/ath/ath10k/htt.h     |   1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c  | 201 ++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/rx_desc.h |  14 ++-
 drivers/net/wireless/ath/ath11k/dp_rx.c   |  34 +++++
 drivers/net/wireless/ath/ath11k/dp_rx.h   |   1 +
 drivers/net/wireless/ath/ath11k/mac.c     |   6 +
 include/net/cfg80211.h                    |   4 +-
 net/mac80211/ieee80211_i.h                |  36 ++----
 net/mac80211/iface.c                      |  11 +-
 net/mac80211/key.c                        |   7 ++
 net/mac80211/key.h                        |   2 +
 net/mac80211/rx.c                         | 150 +++++++++++++++++-----
 net/mac80211/sta_info.c                   |   6 +-
 net/mac80211/sta_info.h                   |  33 ++++-
 net/mac80211/wpa.c                        |  13 +-
 net/wireless/util.c                       |   7 +-
 16 files changed, 441 insertions(+), 85 deletions(-)

