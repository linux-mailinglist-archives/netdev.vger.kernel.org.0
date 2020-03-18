Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B7718A591
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgCRVCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728500AbgCRU4A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:56:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 976732098B;
        Wed, 18 Mar 2020 20:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564959;
        bh=UznoJOSHLBhMhOVJNFY5p5Oz83QB4h1QIyL4ApQmhD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0PwUoRVX51pQgh026TxTMQ4vLoeez2A3jIL74kEOWEzw6s+kr3JSQZJSi6kWY3uaw
         flVCf4/NSFh6F4lLpNMCuNbJ6O7/nu//T0E+Ccir++7Cgq7HokdvF/+YrTYx3KyICb
         nLah6hMVymC+Kr+yT0AQpmvZIRwHQ0QmhAjRIiqw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        syzbot+a98f2016f40b9cd3818a@syzkaller.appspotmail.com,
        syzbot+ac36b6a33c28a491e929@syzkaller.appspotmail.com,
        Hillf Danton <hdanton@sina.com>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 03/28] batman-adv: Don't schedule OGM for disabled interface
Date:   Wed, 18 Mar 2020 16:55:30 -0400
Message-Id: <20200318205555.17447-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205555.17447-1-sashal@kernel.org>
References: <20200318205555.17447-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 8e8ce08198de193e3d21d42e96945216e3d9ac7f ]

A transmission scheduling for an interface which is currently dropped by
batadv_iv_ogm_iface_disable could still be in progress. The B.A.T.M.A.N. V
is simply cancelling the workqueue item in an synchronous way but this is
not possible with B.A.T.M.A.N. IV because the OGM submissions are
intertwined.

Instead it has to stop submitting the OGM when it detect that the buffer
pointer is set to NULL.

Reported-by: syzbot+a98f2016f40b9cd3818a@syzkaller.appspotmail.com
Reported-by: syzbot+ac36b6a33c28a491e929@syzkaller.appspotmail.com
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_iv_ogm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 8b3f9441b3a01..5d5e5401a9ea2 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -926,6 +926,10 @@ static void batadv_iv_ogm_schedule(struct batadv_hard_iface *hard_iface)
 	    (hard_iface->if_status == BATADV_IF_TO_BE_REMOVED))
 		return;
 
+	/* interface already disabled by batadv_iv_ogm_iface_disable */
+	if (!*ogm_buff)
+		return;
+
 	/* the interface gets activated here to avoid race conditions between
 	 * the moment of activating the interface in
 	 * hardif_activate_interface() where the originator mac is set and
-- 
2.20.1

