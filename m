Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FBD4357BE
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 02:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhJUA22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 20:28:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231493AbhJUA0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 20:26:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13CCC613A3;
        Thu, 21 Oct 2021 00:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775872;
        bh=e2a7wykQIQgoocBC1Glgb9Z8xdwyFo1gb+Rb3N/O0xU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jsiJBtD9AIqp2/rIW82vBuh2ois+EWev8au9c+EwYrM5+wQifLIYLLZeDId5XAIGb
         A6HQOCuYzadxbSPH7UiHhHQzXKyeeTS0kwkLzuz5HXwt4N/R4r/gnHUiKD5jQ2dt8C
         exITpNHYW5Vlcu7RZzQPL9WrL4l5efaR+bEeV4PEF6ZGzBws75vKN+zRNgHUTSRv3m
         ueW5aV38OeQsRujDMxarm4rhmj5HhqRHMpF7QUjriXUK0iSz9hpDQPUdyzOQJ3itzb
         nqdgWzrRWI/TYsgxkH15i17y8Z00zTwr/cHJyN2L4BlXGsavkouaYg3p7Fe5Sig7iT
         fNoFCIxT7Ao2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        bongsu.jeon@samsung.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 2/7] nfc: nci: fix the UAF of rf_conn_info object
Date:   Wed, 20 Oct 2021 20:24:21 -0400
Message-Id: <20211021002427.1130044-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002427.1130044-1-sashal@kernel.org>
References: <20211021002427.1130044-1-sashal@kernel.org>
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
index 9b6eb913d801..74e4d5e8c275 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -274,6 +274,8 @@ static void nci_core_conn_close_rsp_packet(struct nci_dev *ndev,
 		conn_info = nci_get_conn_info_by_conn_id(ndev, ndev->cur_id);
 		if (conn_info) {
 			list_del(&conn_info->list);
+			if (conn_info == ndev->rf_conn_info)
+				ndev->rf_conn_info = NULL;
 			devm_kfree(&ndev->nfc_dev->dev, conn_info);
 		}
 	}
-- 
2.33.0

