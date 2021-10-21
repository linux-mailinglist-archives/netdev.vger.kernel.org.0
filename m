Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF0A4356F7
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 02:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhJUAXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 20:23:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231562AbhJUAXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 20:23:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D61C61354;
        Thu, 21 Oct 2021 00:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775681;
        bh=oaoViWmLKml3gk3oxSqvx0sQ0cyPPOBkMf25mGyrx2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tk8e1+7mUJEWNrFoDUuko8gadRzS+jOlbp4r8oPxsbNIJR0oE2z/bG9ki+++CxxJy
         Vomx1P1j3qO6wyTQnWooJTrVNZZBVvIpWZ7vcAaGUO+rXUZ2ZbNqPz/3NZV0RR8M6t
         1iictA6I55vD1l/UNMtC6uCoIOWoy+j8ZDU6RZ+kUi8E4lcJGAZJwbiV3h0MmcEWyA
         +IbtO3ok+pQBDnAe6bL5hnSyjtZHcPljo0bsMkk/9GXQr9IdigHWk6Fi7CrSBRa6tN
         hFY1Nd0ic2BVWVGA0tWmdNYY0mSIWlSvwsvMHgrKIqUtT3QixJRLahC6mV02Ro+Fqc
         D4ueRKGIQvftw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        bongsu.jeon@samsung.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 14/26] nfc: nci: fix the UAF of rf_conn_info object
Date:   Wed, 20 Oct 2021 20:20:11 -0400
Message-Id: <20211021002023.1128949-14-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002023.1128949-1-sashal@kernel.org>
References: <20211021002023.1128949-1-sashal@kernel.org>
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
index e9605922a322..49cbc44e075d 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -330,6 +330,8 @@ static void nci_core_conn_close_rsp_packet(struct nci_dev *ndev,
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

