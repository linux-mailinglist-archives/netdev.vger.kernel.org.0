Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 198E3F45E9
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 12:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732608AbfKHLi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:38:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732378AbfKHLiZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E82D21D7F;
        Fri,  8 Nov 2019 11:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213105;
        bh=UuQWW+L4IQqGuH0JRhMtWTxzuWW1bEjd2yHLLq7S33Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mnSExosS69sGCRGnfG+W8JiSSuvjHAyDOYilCjs2LIMhx3QL8TUioXWfOdKA6tSkF
         OLKxXjbKBlyD2LcAW9bXMXkduiXY3t1uQvu7JRkzsRX0+StlAd7kbuk4eyM5B3e4LJ
         ArMlYGWWbION/e0evk9nqZS0QW4moySLekYS7Oxk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 028/205] wil6210: fix invalid memory access for rx_buff_mgmt debugfs
Date:   Fri,  8 Nov 2019 06:34:55 -0500
Message-Id: <20191108113752.12502-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

[ Upstream commit 4405b632e3da839defec966e4b0be44d0c5e3102 ]

Check rx_buff_mgmt is allocated before accessing its internal fields.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 51c3330bc316f..ceace95b1595c 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1263,6 +1263,9 @@ static int wil_rx_buff_mgmt_debugfs_show(struct seq_file *s, void *data)
 	int num_active;
 	int num_free;
 
+	if (!rbm->buff_arr)
+		return -EINVAL;
+
 	seq_printf(s, "  size = %zu\n", rbm->size);
 	seq_printf(s, "  free_list_empty_cnt = %lu\n",
 		   rbm->free_list_empty_cnt);
-- 
2.20.1

