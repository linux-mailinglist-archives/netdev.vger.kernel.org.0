Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25B0463903
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245112AbhK3PGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244478AbhK3PB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:01:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD77EC061761;
        Tue, 30 Nov 2021 06:53:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 836E1B81A42;
        Tue, 30 Nov 2021 14:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76396C53FCD;
        Tue, 30 Nov 2021 14:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283988;
        bh=U+AXvxMoXF3uSYEH6wRnPsYtCNVw/U6wbtrnfuEAncA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QeOJfE33v8WT9AVX1G4ujmy5zy9wiV4wtCdXpONmFIjIC7uNCIKGaqQY3sOpIhN/h
         5X6d/aWku/TZGz5fee/1685ZfwkL4XG5j2AdEQSrtpvzstK0g/Bv7Gon4J9nr0e0xh
         Xrii2QGAyhYMVcwmval0phg97/N2OwmBNy1Yaa88z99xD5JZHdR1A0Vmz6wjCqeUmE
         iWeF17ctewfsKWAT9KHAl/6Tv/8pPPDg16qWtl9W8raQAMsBwe/cEOzuzlaI8vhbq+
         q+pFSqasYYXysKYOkJMyOuq4DcSj42A9rE3yWVagQgPXI24/XVkGEM8BaGAid9enIb
         vshHl8hQGnI5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, rajur@chelsio.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/17] net: chelsio: cxgb4vf: Fix an error code in cxgb4vf_pci_probe()
Date:   Tue, 30 Nov 2021 09:52:36 -0500
Message-Id: <20211130145243.946407-12-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145243.946407-1-sashal@kernel.org>
References: <20211130145243.946407-1-sashal@kernel.org>
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
index 15029a5e62b9b..3c3ff62e4fea5 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -3202,6 +3202,7 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 	}
 	if (adapter->registered_device_map == 0) {
 		dev_err(&pdev->dev, "could not register any net devices\n");
+		err = -EINVAL;
 		goto err_disable_interrupts;
 	}
 
-- 
2.33.0

