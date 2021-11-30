Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD7F46390A
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245294AbhK3PHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244756AbhK3PCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:02:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7ED8C08EA71;
        Tue, 30 Nov 2021 06:53:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91EA3B81A21;
        Tue, 30 Nov 2021 14:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8872DC53FCF;
        Tue, 30 Nov 2021 14:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284036;
        bh=L/vkYAiPnUZOw0+RA29NGcdgiSkdtnKXz6T1fAVsn5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdSecbZoyyW4C52fsrRXN19+gMY/9eh33yBlaPT9HWfD/lqfyHHJdq4jwfrv2ojH0
         Rlml9BI1OvMYexgLtaR4WiP5E6uUkJt+ZIY/9nVC1ahzHQ+CK0rvsBk63Ld9Jl3NYu
         O47vLzeiHA9oYXgS7hhanJ1oY8wjp6v1NyK/nw5lo31YK+cQXEdf+ASR+p77h24Em2
         FzfLu8DpKtM5yabv06AojINdBQAp9mkIa3OB0vEiUMQRq+HMp0MBG1ekLveUBxDV9m
         MZTowuJZZ7QfpzG+cvt8uU1n45vc8FMWnncblJIEtF0iQPvhPMOEaEevZnjvseWaFg
         aD3+Og5yIKAMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, rajur@chelsio.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 08/12] net: chelsio: cxgb4vf: Fix an error code in cxgb4vf_pci_probe()
Date:   Tue, 30 Nov 2021 09:53:36 -0500
Message-Id: <20211130145341.946891-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145341.946891-1-sashal@kernel.org>
References: <20211130145341.946891-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit b82d71c0f84a2e5ccaaa7571dfd5c69e0e2cfb4a ]

During the process of driver probing, probe function should return < 0
for failure, otherwise kernel will treat value == 0 as success.

Therefore, we should set err to -EINVAL when
adapter->registered_device_map is NULL. Otherwise kernel will assume
that driver has been successfully probed and will cause unexpected
errors.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 17db5be9d2b7a..d350797ce1245 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -3064,6 +3064,7 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 	}
 	if (adapter->registered_device_map == 0) {
 		dev_err(&pdev->dev, "could not register any net devices\n");
+		err = -EINVAL;
 		goto err_disable_interrupts;
 	}
 
-- 
2.33.0

