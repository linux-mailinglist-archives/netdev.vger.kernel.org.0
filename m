Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC95435757
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 02:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhJUAZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 20:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231728AbhJUAZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 20:25:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 007B560EE3;
        Thu, 21 Oct 2021 00:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775767;
        bh=gLRJdovnqHg24/LRNN4qF3W4ybwGjt2JWPTpGO1DmCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSSMM3j7alTdPTRQEswS2BX96oZQP8eWedF/0A1bwetgxs9ukJ3ZUQO1WXOJU1gLq
         4oQS+dGxXAkH0S+fX8tGp3a1KmM4GfM4aAoR4VDl97jh0EOyfY3X1B5hgc3MrlqWA5
         38HvAl45OtfjnnjArZc5f0+xp2wHTgMffSmDWBmJ6EjMaFrgd9l9OZiZ2LPDLv2sml
         YcEV2LlrbCf46Fxo4jVngPkrO/qAMadKtKYn7HPNAjd38inrdIBQbl3A70XdnM5So/
         geF9V/LKGKMxusimkmFmQ2HKBfWMYagLDkrPdgrlr9XwxiAjswv1wbvWzWkNhp+MnD
         HSilO64XQpKTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        bongsu.jeon@samsung.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/11] nfc: nci: fix the UAF of rf_conn_info object
Date:   Wed, 20 Oct 2021 20:22:31 -0400
Message-Id: <20211021002238.1129482-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002238.1129482-1-sashal@kernel.org>
References: <20211021002238.1129482-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 1b1499a817c90fd1ce9453a2c98d2a01cca0e775 ]

The nci_core_conn_close_rsp_packet() function will release the conn_info
with given conn_id. However, it needs to set the rf_conn_info to NULL to
prevent other routines like nci_rf_intf_activated_ntf_packet() to trigger
the UAF.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/rsp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
index a48297b79f34..b0ed2b47ac43 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -277,6 +277,8 @@ static void nci_core_conn_close_rsp_packet(struct nci_dev *ndev,
 							 ndev->cur_conn_id);
 		if (conn_info) {
 			list_del(&conn_info->list);
+			if (conn_info == ndev->rf_conn_info)
+				ndev->rf_conn_info = NULL;
 			devm_kfree(&ndev->nfc_dev->dev, conn_info);
 		}
 	}
-- 
2.33.0

