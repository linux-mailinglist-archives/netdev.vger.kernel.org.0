Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13779F635D
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 03:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbfKJCvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:51:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730034AbfKJCvn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:51:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9F1222790;
        Sun, 10 Nov 2019 02:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354302;
        bh=b3iUeq6i7vf0R43JzFyu9ugI+yVa/N6wfBFwjYHU+Vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBkhy/mwLAv9FHh2PXgKDi5Fpjk/XCnh1qFJOPCHUtEtcsSaahx33lhQjVLonsPIs
         2n/vhMuJ0X112NCcX00r+jrMLGEZ1yiv4uJO/p/OoQYsx2UWb8f2c7mX5+DWdat3fo
         by0APut8sNs2vsw3PQFfmSuBfZSNpqnLFDPc6iqw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 38/40] Bluetooth: L2CAP: Detect if remote is not able to use the whole MPS
Date:   Sat,  9 Nov 2019 21:50:30 -0500
Message-Id: <20191110025032.827-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110025032.827-1-sashal@kernel.org>
References: <20191110025032.827-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit a5c3021bb62b970713550db3f7fd08aa70665d7e ]

If the remote is not able to fully utilize the MPS choosen recalculate
the credits based on the actual amount it is sending that way it can
still send packets of MTU size without credits dropping to 0.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index c25f1e4846cde..302c3bacb0247 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6795,6 +6795,16 @@ static int l2cap_le_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 		chan->sdu_len = sdu_len;
 		chan->sdu_last_frag = skb;
 
+		/* Detect if remote is not able to use the selected MPS */
+		if (skb->len + L2CAP_SDULEN_SIZE < chan->mps) {
+			u16 mps_len = skb->len + L2CAP_SDULEN_SIZE;
+
+			/* Adjust the number of credits */
+			BT_DBG("chan->mps %u -> %u", chan->mps, mps_len);
+			chan->mps = mps_len;
+			l2cap_chan_le_send_credits(chan);
+		}
+
 		return 0;
 	}
 
-- 
2.20.1

