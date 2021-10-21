Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2117F43572D
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 02:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhJUAZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 20:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhJUAYa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 20:24:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70BE760FED;
        Thu, 21 Oct 2021 00:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775735;
        bh=gLRJdovnqHg24/LRNN4qF3W4ybwGjt2JWPTpGO1DmCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqeWr5L1qx+CVcvexNpuZZjgyZ3sELZXsy2d53XAVo3ZctSfevodxJ6Exhu0Vmt7w
         z4L9x3mloz9xcZQyLWZ25zGHOJXDXbg7LYpZniTfx+nTBHcUABv5vk3G+lqui9h2A3
         yHVG0QPoDpVJhqjcCnQzWikzrKmY5VwNTbDJpfEJNbOyhRG7loeiBm0VD3S9VR8Ejv
         +2EKFtT16pJtW6eSMXuvlrwv0KiWxw48L9EdYbJTChRzkmIEVvM5AF/M8NQXRhGspR
         mtP6DMEbnUYLP0kSAFBUEQI7GSVAsjuTXxofs+jze6AA64tuZ904S+eNHA5OA9fLUz
         t9QueLS1ccyMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        bongsu.jeon@samsung.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/14] nfc: nci: fix the UAF of rf_conn_info object
Date:   Wed, 20 Oct 2021 20:21:47 -0400
Message-Id: <20211021002155.1129292-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002155.1129292-1-sashal@kernel.org>
References: <20211021002155.1129292-1-sashal@kernel.org>
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

