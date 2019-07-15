Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4D8E68E3F
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387449AbfGOOEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:04:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387969AbfGOOEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:04:45 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A599217F9;
        Mon, 15 Jul 2019 14:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199484;
        bh=sdE4boDjVaUMIjTlvIuSSQG68cEy/8u4cYX8/mB3o7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GEGxJ9WD2CM+f1V56aX10rsD0HyPkCf/obyRNJov8iD8vv1OhmzxbUgPiMhykfmYB
         THw5HbyrAlWGCcFgrz4nrp4yf4qj9LZSrfpTf5nnCXOaWydfeBz2SZZeY/zLJ/LeUv
         u3s+GdsOe6Vi/V2BMj0eDzzF7DINcXPg1oEY/5uY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        syzbot+d454a826e670502484b8@syzkaller.appspotmail.com,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 018/219] batman-adv: fix for leaked TVLV handler.
Date:   Mon, 15 Jul 2019 10:00:19 -0400
Message-Id: <20190715140341.6443-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

[ Upstream commit 17f78dd1bd624a4dd78ed5db3284a63ee807fcc3 ]

A handler for BATADV_TVLV_ROAM was being registered when the
translation-table was initialized, but not unregistered when the
translation-table was freed.  Unregister it.

Fixes: 122edaa05940 ("batman-adv: tvlv - convert roaming adv packet to use tvlv unicast packets")
Reported-by: syzbot+d454a826e670502484b8@syzkaller.appspotmail.com
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Sven Eckelmann <sven@narfation.org
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 26c4e2493ddf..abad64eb7dc4 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -3826,6 +3826,8 @@ static void batadv_tt_purge(struct work_struct *work)
  */
 void batadv_tt_free(struct batadv_priv *bat_priv)
 {
+	batadv_tvlv_handler_unregister(bat_priv, BATADV_TVLV_ROAM, 1);
+
 	batadv_tvlv_container_unregister(bat_priv, BATADV_TVLV_TT, 1);
 	batadv_tvlv_handler_unregister(bat_priv, BATADV_TVLV_TT, 1);
 
-- 
2.20.1

