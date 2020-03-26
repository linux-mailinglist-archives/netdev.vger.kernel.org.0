Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F29701942D8
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 16:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgCZPRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 11:17:32 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:49488 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgCZPRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 11:17:32 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jHUGA-00Bc7c-3P; Thu, 26 Mar 2020 16:17:30 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-03-26
Date:   Thu, 26 Mar 2020 16:17:24 +0100
Message-Id: <20200326151725.117792-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

I don't know if you were planning to send another pull request to
Linus, but at least if he doesn't release on Sunday then I still
have a few security fixes - we (particularly Jouni) noticed that
frames remaining in the queue may go out unencrypted when a client
disconnects from a mac80211-based AP. We developed a few fixes for
this, which I'm including here (with more description in the tag)
along with a few small other fixes.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 2de9780f75076c1a1f122cbd39df0fa545284724:

  net: core: dev.c: fix a documentation warning (2020-03-17 23:39:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2020-03-26

for you to fetch changes up to b95d2ccd2ccb834394d50347d0e40dc38a954e4a:

  mac80211: set IEEE80211_TX_CTRL_PORT_CTRL_PROTO for nl80211 TX (2020-03-26 15:54:12 +0100)

----------------------------------------------------------------
We have the following fixes:
 * drop data packets if there's no key for them anymore, after
   there had been one, to avoid sending them in clear when
   hostapd removes the key before it removes the station and
   the packets are still queued
 * check port authorization again after dequeue, to avoid
   sending packets if the station is no longer authorized
 * actually remove the authorization flag before the key so
   packets are also dropped properly because of this
 * fix nl80211 control port packet tagging to handle them as
   packets allowed to go out without encryption
 * fix NL80211_ATTR_CHANNEL_WIDTH outgoing netlink attribute
   width (should be 32 bits, not 8)
 * don't WARN in a CSA scenario that happens on some APs
 * fix HE spatial reuse element size calculation

----------------------------------------------------------------
Ilan Peer (1):
      cfg80211: Do not warn on same channel at the end of CSA

Johannes Berg (5):
      nl80211: fix NL80211_ATTR_CHANNEL_WIDTH attribute type
      ieee80211: fix HE SPR size calculation
      mac80211: drop data frames without key on encrypted links
      mac80211: mark station unauthorized before key removal
      mac80211: set IEEE80211_TX_CTRL_PORT_CTRL_PROTO for nl80211 TX

Jouni Malinen (1):
      mac80211: Check port authorization in the ieee80211_tx_dequeue() case

 include/linux/ieee80211.h  |  4 ++--
 net/mac80211/debugfs_sta.c |  3 ++-
 net/mac80211/key.c         | 20 ++++++++++++--------
 net/mac80211/sta_info.c    |  7 ++++++-
 net/mac80211/sta_info.h    |  1 +
 net/mac80211/tx.c          | 39 +++++++++++++++++++++++++++++++++------
 net/wireless/nl80211.c     |  2 +-
 net/wireless/scan.c        |  6 +++++-
 8 files changed, 62 insertions(+), 20 deletions(-)

