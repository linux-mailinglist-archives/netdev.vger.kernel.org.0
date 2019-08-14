Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1ADE8C858
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbfHNCQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:16:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728667AbfHNCQ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:16:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C3E5214C6;
        Wed, 14 Aug 2019 02:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749017;
        bh=C4D0mDMlx3c147kBHrBIOJv/3JAYC7VSSO0GjXgZndo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ALlL9ZlJOjs/xkLsOlEJNlho/lJsIvNXyKaxk0Ypwt+ZQZH6mdY0macSwiRDAiqzE
         /5+rcPQs2GyeEna49Ze8Oan7hnZmbwPkxsiivxTCad4AhpBfkKqfQoyCiUXkNeC4Z3
         4npdWTU9dWRM/GBcMd6bONFv3soi+xruhaS+zzeM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Xiayang <xywang.sjtu@sjtu.edu.cn>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 37/68] can: sja1000: force the string buffer NULL-terminated
Date:   Tue, 13 Aug 2019 22:15:15 -0400
Message-Id: <20190814021548.16001-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Xiayang <xywang.sjtu@sjtu.edu.cn>

[ Upstream commit cd28aa2e056cd1ea79fc5f24eed0ce868c6cab5c ]

strncpy() does not ensure NULL-termination when the input string size
equals to the destination buffer size IFNAMSIZ. The output string
'name' is passed to dev_info which relies on NULL-termination.

Use strlcpy() instead.

This issue is identified by a Coccinelle script.

Signed-off-by: Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/sja1000/peak_pcmcia.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/sja1000/peak_pcmcia.c b/drivers/net/can/sja1000/peak_pcmcia.c
index b8c39ede7cd51..179bfcd541f2f 100644
--- a/drivers/net/can/sja1000/peak_pcmcia.c
+++ b/drivers/net/can/sja1000/peak_pcmcia.c
@@ -487,7 +487,7 @@ static void pcan_free_channels(struct pcan_pccard *card)
 		if (!netdev)
 			continue;
 
-		strncpy(name, netdev->name, IFNAMSIZ);
+		strlcpy(name, netdev->name, IFNAMSIZ);
 
 		unregister_sja1000dev(netdev);
 
-- 
2.20.1

