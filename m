Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B559F291CE7
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730629AbgJRTYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730604AbgJRTYH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:24:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8295522365;
        Sun, 18 Oct 2020 19:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049046;
        bh=unK3KpYy1Ml2lpFoNEJmYdq8PZYAjPcfXRHIKaQp7X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KjLS3qO6qtdbUfaGsv+9TxG98P5/qAdp9BvGVEp4nzR+o3khqLafZ4EsRw3NO+oXN
         F8PHMjL4LZhgT7/tPJou7dZ+Cd3iUcT7Jug/OEZBV7X+fZ3hkux95UYYPXNGWOH/us
         JunVyNYC8p7PAWO2bIy6hulpSPeiETo2QEpWnoEg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Yufen <wangyufen@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 75/80] brcm80211: fix possible memleak in brcmf_proto_msgbuf_attach
Date:   Sun, 18 Oct 2020 15:22:26 -0400
Message-Id: <20201018192231.4054535-75-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192231.4054535-1-sashal@kernel.org>
References: <20201018192231.4054535-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 6c151410d5b57e6bb0d91a735ac511459539a7bf ]

When brcmf_proto_msgbuf_attach fail and msgbuf->txflow_wq != NULL,
we should destroy the workqueue.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1595237765-66238-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index e3dd8623be4ec..c2705d7a4247e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -1619,6 +1619,8 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 					  BRCMF_TX_IOCTL_MAX_MSG_SIZE,
 					  msgbuf->ioctbuf,
 					  msgbuf->ioctbuf_handle);
+		if (msgbuf->txflow_wq)
+			destroy_workqueue(msgbuf->txflow_wq);
 		kfree(msgbuf);
 	}
 	return -ENOMEM;
-- 
2.25.1

