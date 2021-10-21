Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DC34357AA
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 02:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbhJUA1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 20:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232559AbhJUA0Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 20:26:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B346F61208;
        Thu, 21 Oct 2021 00:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775849;
        bh=dvmS/3+wKffXFp5H4Wbw2bRep6wqx8nbVPuPvQXFW3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmP8Pdt9V77ZREsjWxhE2EkW7FGT7kxOGcTCQisIMqiPSOydkEIjIiejaSeMn3h3s
         JuAGRfeN/einiwhwYmW6E+N7AUxNMhz8jeRad9eQo5X0KvmQnlgtgAxg3efOPBLmnh
         QQO3S/cNDlihBZ1GBm4Ujn7nlo9DeORyoEaR22s7pgK5O7b+voO1DYMyzpoyU7gBHA
         Au9HX91MvaBaKtGIPjelqT/iFRZyQbNcVMJkeOzm/VRHOFlfh87kY7n3OUmbygttDx
         LhYSL3C8pS8YSpa2qWe7mdJ6xDHc7BouWj2ejjy2cuWYhVms0IsZFRi/p4EBFUemyJ
         QOkGcA/adh7kg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        bongsu.jeon@samsung.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/7] nfc: nci: fix the UAF of rf_conn_info object
Date:   Wed, 20 Oct 2021 20:23:58 -0400
Message-Id: <20211021002404.1129946-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002404.1129946-1-sashal@kernel.org>
References: <20211021002404.1129946-1-sashal@kernel.org>
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

