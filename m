Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D9843579F
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 02:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbhJUA1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 20:27:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232384AbhJUAZ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 20:25:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0D5660EE3;
        Thu, 21 Oct 2021 00:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775822;
        bh=dvmS/3+wKffXFp5H4Wbw2bRep6wqx8nbVPuPvQXFW3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kioiDJ/Cm2CgOl3aT2iz8CmzFPDq2rRCiSQJ+3HKEHKNx1c9lzShcb2eDCiXFXZ9C
         BTCIUwSjj1vFQ69kRz9l4fw2kywHPKnlXsLFHw3i+NzYI7+z/b9cDQlncpvIfAPElW
         bS61siA0BTedXSnTsDlRcy+4cMlawDMnX64eHTerWbFU/EHpSZSCX/7UAXwFl+pkWq
         r7CdwG3XowRI+CNq6zTgIfgFP1dBQHViD/5uckyCbguE5N7C2d0zxMxpaM3ZulFTNZ
         uARkfyeY43WTYwTyawP739jADlgYzpI7uNvwZyc0xVHJQt9As8+LCTPP69Yhz5kh6T
         KqV/ppXVU+w2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        bongsu.jeon@samsung.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/9] nfc: nci: fix the UAF of rf_conn_info object
Date:   Wed, 20 Oct 2021 20:23:28 -0400
Message-Id: <20211021002333.1129824-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002333.1129824-1-sashal@kernel.org>
References: <20211021002333.1129824-1-sashal@kernel.org>
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
index e3bbf1937d0e..7681f89dc312 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -289,6 +289,8 @@ static void nci_core_conn_close_rsp_packet(struct nci_dev *ndev,
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

