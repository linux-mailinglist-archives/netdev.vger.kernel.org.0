Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815691EF7AC
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 14:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgFEM22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 08:28:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbgFEM0H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 08:26:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4A4E20B80;
        Fri,  5 Jun 2020 12:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591359966;
        bh=/51UB73oQJP/xzjynBeIGd3a0RtH/qRTV5Ds9Nniz8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgJspoA1GeL2JZ3ERpZ12RqzNoABuqFore+3Vxq2uBNAiL6+ved/cv8jPW7V09W6K
         pBf8GtcnZl8NE0L5NvmVGP/sW2W22BWxERsO6yavevPb8G3sqxERf8hE6/w660Tpen
         W0/orqfpn8Tuv/pUXWwwsvmpzPG/s+CqqaPI33Qw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 7/9] NFC: st21nfca: add missed kfree_skb() in an error path
Date:   Fri,  5 Jun 2020 08:25:55 -0400
Message-Id: <20200605122558.2882712-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200605122558.2882712-1-sashal@kernel.org>
References: <20200605122558.2882712-1-sashal@kernel.org>
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

