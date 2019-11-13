Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFAA7FA564
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbfKMBxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:53:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:42762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727514AbfKMBxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:53:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D14A5204EC;
        Wed, 13 Nov 2019 01:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609996;
        bh=EnyyH4Gnn0E8+qOWwE4uOz6+S+a2zftDJp8SNn1mVxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDL9yU4sXXa255wRJDubc9+QCKYY5VJrC3G570bUO9WHZ7v01HFgsfQpufoDMJryJ
         jK//iPrrmsRRTw6uGw5B29PcQ2hRbIMBu3j4Hxz2x7pie8VuTVhXv+v+wzjloYz+oP
         MMp4nblWejqfG4/DJ/4g6t2+PADFasCugRtGb9n0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 105/209] qtnfmac: drop error reports for out-of-bounds key indexes
Date:   Tue, 12 Nov 2019 20:48:41 -0500
Message-Id: <20191113015025.9685-105-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[ Upstream commit 35da3fe63b8647ce3cc52fccdf186a60710815fb ]

On disconnect wireless core attempts to remove all the supported keys.
Following cfg80211_ops conventions, firmware returns -ENOENT code
for the out-of-bound key indexes. This is a normal behavior,
so no need to report errors for this case.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 05b93f301ca08..ff8a46c9595e1 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -521,9 +521,16 @@ static int qtnf_del_key(struct wiphy *wiphy, struct net_device *dev,
 	int ret;
 
 	ret = qtnf_cmd_send_del_key(vif, key_index, pairwise, mac_addr);
-	if (ret)
-		pr_err("VIF%u.%u: failed to delete key: idx=%u pw=%u\n",
-		       vif->mac->macid, vif->vifid, key_index, pairwise);
+	if (ret) {
+		if (ret == -ENOENT) {
+			pr_debug("VIF%u.%u: key index %d out of bounds\n",
+				 vif->mac->macid, vif->vifid, key_index);
+		} else {
+			pr_err("VIF%u.%u: failed to delete key: idx=%u pw=%u\n",
+			       vif->mac->macid, vif->vifid,
+			       key_index, pairwise);
+		}
+	}
 
 	return ret;
 }
-- 
2.20.1

