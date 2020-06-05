Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9391EF7A2
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 14:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgFEM1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 08:27:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727774AbgFEM0R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 08:26:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 842E620E65;
        Fri,  5 Jun 2020 12:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591359977;
        bh=/51UB73oQJP/xzjynBeIGd3a0RtH/qRTV5Ds9Nniz8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmAMkUO4Heq3681IH1ITS8//CAERibsA/7GAQP0UGjU+K2poWcDpDfcEMUOqb0dva
         7C2+2umW9yqEFrGJ4suXqPIXe3YDgFK8/kymRNPdnjCFy4DHznh/6vPOU6oO8Icmy2
         OSmawbikURJnkTwJpbIL+yk3b0ypv9VPHvVtDxzQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 6/8] NFC: st21nfca: add missed kfree_skb() in an error path
Date:   Fri,  5 Jun 2020 08:26:07 -0400
Message-Id: <20200605122609.2882841-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200605122609.2882841-1-sashal@kernel.org>
References: <20200605122609.2882841-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 3decabdc714ca56c944f4669b4cdec5c2c1cea23 ]

st21nfca_tm_send_atr_res() misses to call kfree_skb() in an error path.
Add the missed function call to fix it.

Fixes: 1892bf844ea0 ("NFC: st21nfca: Adding P2P support to st21nfca in Initiator & Target mode")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st21nfca/dep.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/st21nfca/dep.c b/drivers/nfc/st21nfca/dep.c
index fd08be2917e6..7399eb2c5e1d 100644
--- a/drivers/nfc/st21nfca/dep.c
+++ b/drivers/nfc/st21nfca/dep.c
@@ -184,8 +184,10 @@ static int st21nfca_tm_send_atr_res(struct nfc_hci_dev *hdev,
 		memcpy(atr_res->gbi, atr_req->gbi, gb_len);
 		r = nfc_set_remote_general_bytes(hdev->ndev, atr_res->gbi,
 						  gb_len);
-		if (r < 0)
+		if (r < 0) {
+			kfree_skb(skb);
 			return r;
+		}
 	}
 
 	info->dep_info.curr_nfc_dep_pni = 0;
-- 
2.25.1

