Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656F43BD194
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238549AbhGFLjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:39:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237476AbhGFLgL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF28461DAE;
        Tue,  6 Jul 2021 11:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570879;
        bh=AOANztogWG+byXD6GqBWGWH2rCikFuzKCOSb6tGVcgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUrkiYs6gy3O/227zyaWPYP24G2tRC2X32bdTU3umoyZZoCm2JOfDi6o680vOcX7E
         Woyw3RV64eT3fK1FY+/AHnobMYoQg0okTT8NMol9WrAPstkEsmbYn0iuNbPWuwXBLJ
         oMjQAe2hrZ1miQT77RiR6YEf5kQK3TN+S5HQ7mRogfQk6USr48iLY5REw2jTDzdKS+
         Yk1IABhifILR8kdMaTYQg7TxfHpGarHGXUC/PlBEcH8t4GFBaAsov4odxWw4POZ+sm
         FuQbvyusur+ZpO9iIX36WkEewT3+wmNf3ssV0S+ydAkMXLXl1768OwqT8NQif9SCer
         AmBOMPMrJHEQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/45] atm: iphase: fix possible use-after-free in ia_module_exit()
Date:   Tue,  6 Jul 2021 07:27:11 -0400
Message-Id: <20210706112749.2065541-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112749.2065541-1-sashal@kernel.org>
References: <20210706112749.2065541-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 1c72e6ab66b9598cac741ed397438a52065a8f1f ]

This module's remove path calls del_timer(). However, that function
does not wait until the timer handler finishes. This means that the
timer handler may still be running after the driver's remove function
has finished, which would result in a use-after-free.

Fix by calling del_timer_sync(), which makes sure the timer handler
has finished, and unable to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/iphase.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 2b29598791e8..16eb0266a59a 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -3301,7 +3301,7 @@ static void __exit ia_module_exit(void)
 {
 	pci_unregister_driver(&ia_driver);
 
-        del_timer(&ia_timer);
+	del_timer_sync(&ia_timer);
 }
 
 module_init(ia_module_init);
-- 
2.30.2

