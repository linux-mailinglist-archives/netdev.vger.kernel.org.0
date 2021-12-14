Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4DF04740B2
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 11:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbhLNKpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 05:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbhLNKpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 05:45:44 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917B4C061574;
        Tue, 14 Dec 2021 02:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=HTc0NEIwIfaemjmwtA9usH0K3xhOw0FIrPWzzLfx8YM=; t=1639478743; x=1640688343; 
        b=Rp00jp/F7uTud7Ju79r8VEL4WKPXI1YbJwk3A2Xf2G7B+m+LIOoy4NJbdJvry0AM2o9EL1N2nEL
        erO08rmnwu/vcRCjcjCvT/bepXaqCqV2v3TkyDFCwJdcd/lqBWmDvLD2PrY9rUx4CneEZJaTDxk5s
        3E8T6Sekv1C2aveICprfCsRM51m+tOw7Nb8YbKpf5Qb2wEP9xHsqhtnCqEMecEXFvctEx66aqzoPM
        qoKT2IEAjoWhJ63+dJ4+o1Wwf6d61xvgkNRgC+hB8MdkpM6eXCOMLveF66LTg7mwe+yZwtwM+iZpU
        MYIHeBxHfwvfU3ed3VaJyoSAg+6prXh/l6Mg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mx5JU-00BDoR-Va;
        Tue, 14 Dec 2021 11:45:41 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2021-12-14
Date:   Tue, 14 Dec 2021 11:45:36 +0100
Message-Id: <20211214104537.16995-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Sorry - I accumulated more stuff than I'd like due to
various other competing priorities...

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 49573ff7830b1186011f5f2e9c08935ec5fc39b6:

  Merge branch 'tls-splice_read-fixes' (2021-11-25 19:28:21 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2021-12-14

for you to fetch changes up to 13dee10b30c058ee2c58c5da00339cc0d4201aa6:

  mac80211: do drv_reconfig_complete() before restarting all (2021-12-14 11:22:20 +0100)

----------------------------------------------------------------
A fairly large number of fixes this time:
 * fix a station info memory leak on insert collisions
 * a rate control fix for retransmissions
 * two aggregation setup fixes
 * reload current regdomain when reloading database
 * a locking fix in regulatory work
 * a probe request allocation size fix in mac80211
 * apply TCP vs. aggregation (sk pacing) on mesh
 * fix ordering of channel context update vs. station
   state
 * set up skb->dev for mesh forwarding properly
 * track QoS data frames only for admission control to
   avoid out-of-bounds read (found by syzbot)
 * validate extended element ID vs. existing data to
   avoid out-of-bounds read (found by syzbot)
 * fix locking in mac80211 aggregation TX setup
 * fix traffic stall after HW restart when TXQs are used
 * fix ordering of reconfig/restart after HW restart
 * fix interface type for extended aggregation capability
   lookup

----------------------------------------------------------------
Ahmed Zaki (1):
      mac80211: fix a memory leak where sta_info is not freed

Felix Fietkau (3):
      mac80211: fix rate control for retransmitted frames
      mac80211: fix regression in SSN handling of addba tx
      mac80211: send ADDBA requests using the tid/queue of the aggregation session

Finn Behrens (2):
      nl80211: reset regdom when reloading regdb
      nl80211: remove reload flag from regulatory_request

Ilan Peer (2):
      cfg80211: Acquire wiphy mutex on regulatory work
      mac80211: Fix the size used for building probe request

Johannes Berg (7):
      mac80211: track only QoS data frames for admission control
      mac80211: add docs for ssn in struct tid_ampdu_tx
      mac80211: agg-tx: don't schedule_and_wake_txq() under sta->lock
      mac80211: validate extended element ID is present
      mac80211: fix lookup when adding AddBA extension element
      mac80211: mark TX-during-stop for TX in in_reconfig
      mac80211: do drv_reconfig_complete() before restarting all

Maxime Bizon (1):
      mac80211: fix TCP performance on mesh interface

Mordechay Goodstein (1):
      mac80211: update channel context before station state

Xing Song (1):
      mac80211: set up the fwd_skb->dev for mesh forwarding

 net/mac80211/agg-rx.c     |  5 +++--
 net/mac80211/agg-tx.c     | 16 +++++++++++-----
 net/mac80211/driver-ops.h |  5 ++++-
 net/mac80211/mlme.c       | 13 ++++++++++---
 net/mac80211/rx.c         |  1 +
 net/mac80211/sta_info.c   | 21 ++++++++++++---------
 net/mac80211/sta_info.h   |  2 ++
 net/mac80211/tx.c         | 10 +++++-----
 net/mac80211/util.c       | 23 ++++++++++++++---------
 net/wireless/reg.c        | 30 ++++++++++++++++++++++++++++--
 10 files changed, 90 insertions(+), 36 deletions(-)

