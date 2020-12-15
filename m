Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E882DB2E3
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730958AbgLORbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:31:33 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:46112 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730031AbgLORbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:31:22 -0500
Received: from ironmsg07-lv.qualcomm.com (HELO ironmsg07-lv.qulacomm.com) ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 15 Dec 2020 09:30:42 -0800
X-QCInternal: smtphost
Received: from ironmsg02-blr.qualcomm.com ([10.86.208.131])
  by ironmsg07-lv.qulacomm.com with ESMTP/TLS/AES256-SHA; 15 Dec 2020 09:30:40 -0800
X-QCInternal: smtphost
Received: from youghand-linux.qualcomm.com ([10.206.66.115])
  by ironmsg02-blr.qualcomm.com with ESMTP; 15 Dec 2020 23:00:38 +0530
Received: by youghand-linux.qualcomm.com (Postfix, from userid 2370257)
        id 45E3A20F17; Tue, 15 Dec 2020 23:00:37 +0530 (IST)
From:   Youghandhar Chintala <youghand@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        dianders@chromium.org, briannorris@chromium.org,
        pillair@codeaurora.org
Subject: [PATCH 0/3] mac80211: Trigger disconnect for STA during recovery
Date:   Tue, 15 Dec 2020 23:00:34 +0530
Message-Id: <20201215173034.5939-1-youghand@codeaurora.org>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Pillai <pillair@codeaurora.org>

Currently in case of target hardware restart ,we just reconfig and
re-enable the security keys and enable the network queues to start
data traffic back from where it was interrupted.

Many ath10k wifi chipsets have sequence numbers for the data
packets assigned by firmware and the mac sequence number will
restart from zero after target hardware restart leading to mismatch
in the sequence number expected by the remote peer vs the sequence
number of the frame sent by the target firmware.

This mismatch in sequence number will cause out-of-order packets
on the remote peer and all the frames sent by the device are dropped
until we reach the sequence number which was sent before we restarted
the target hardware

In order to fix this, we trigger a disconnect in case of hardware
restart. After this there will be a fresh connection and thereby
avoiding the dropping of frames by remote peer.

The right fix would be to pull the entire data path into the host
which is not feasible or would need lots of complex/inefficient
datapath changes.

Rakesh Pillai (1):
  ath10k: Set wiphy flag to trigger sta disconnect on hardware restart

Youghandhar Chintala (2):
  cfg80211: Add wiphy flag to trigger STA disconnect after hardware
    restart
  mac80211: Add support to trigger sta disconnect on hardware restart

 drivers/net/wireless/ath/ath10k/core.c | 15 +++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  3 +++
 drivers/net/wireless/ath/ath10k/mac.c  |  3 +++
 include/net/cfg80211.h                 |  4 ++++
 net/mac80211/ieee80211_i.h             |  3 +++
 net/mac80211/mlme.c                    |  9 +++++++++
 net/mac80211/util.c                    | 22 +++++++++++++++++++---
 7 files changed, 56 insertions(+), 3 deletions(-)

-- 
2.7.4

