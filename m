Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF0526018E
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbgIGQcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730632AbgIGQcd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:32:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71C1E207DE;
        Mon,  7 Sep 2020 16:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496351;
        bh=wOb0MOvzDb/ZrwrJ3pg48ni2ycaY2oXkvvjZPPz+c+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/XDQhQdTpl4VVJ3vhgHR9D0GwHMRfNkKm5ziRoVlBrW44uiYhxJmvb//PM8a81vJ
         rnYPfvGAD8oALyzx00qw92DhSBdXu5sjMZo+2nrfmwoUiZCe8kztmft1St7COqCFpK
         F5t+SoB3LmBwzHlORspZy2BU8YqNBjbpsJnOYf4Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 08/53] NFC: st95hf: Fix memleak in st95hf_in_send_cmd
Date:   Mon,  7 Sep 2020 12:31:34 -0400
Message-Id: <20200907163220.1280412-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163220.1280412-1-sashal@kernel.org>
References: <20200907163220.1280412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit f97c04c316d8fea16dca449fdfbe101fbdfee6a2 ]

When down_killable() fails, skb_resp should be freed
just like when st95hf_spi_send() fails.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st95hf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 9642971e89cea..4578547659839 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -966,7 +966,7 @@ static int st95hf_in_send_cmd(struct nfc_digital_dev *ddev,
 	rc = down_killable(&stcontext->exchange_lock);
 	if (rc) {
 		WARN(1, "Semaphore is not found up in st95hf_in_send_cmd\n");
-		return rc;
+		goto free_skb_resp;
 	}
 
 	rc = st95hf_spi_send(&stcontext->spicontext, skb->data,
-- 
2.25.1

