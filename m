Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179201AA121
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 14:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409026AbgDOLnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 07:43:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409003AbgDOLnd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 07:43:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2D0D214AF;
        Wed, 15 Apr 2020 11:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951013;
        bh=r2aI73LLBLm0iYUVrWWkWJG9n9Bcu77tZZmdLbdw6lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2uwO2Ksc14dHPlJyhq/Iju3+0HOzpbdxRL866Z232BCeOO+V6KHQqOWsS0sqHm0p
         Caf76qdkDebGtg1gPYeors/ak4SDQM6doEZ6PFkWdxUu1walpvk+0egB7hanlBfs9N
         mXfGpyNVf9gRh8tQgXhBFxEH5/tYTty8HeAn5k0g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Herat Ramani <herat@chelsio.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 056/106] cxgb4: fix MPS index overwrite when setting MAC address
Date:   Wed, 15 Apr 2020 07:41:36 -0400
Message-Id: <20200415114226.13103-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Herat Ramani <herat@chelsio.com>

[ Upstream commit 41aa8561ca3fc5748391f08cc5f3e561923da52c ]

cxgb4_update_mac_filt() earlier requests firmware to add a new MAC
address into MPS TCAM. The MPS TCAM index returned by firmware is
stored in pi->xact_addr_filt. However, the saved MPS TCAM index gets
overwritten again with the return value of cxgb4_update_mac_filt(),
which is wrong.

When trying to update to another MAC address later, the wrong MPS TCAM
index is sent to firmware, which causes firmware to return error,
because it's not the same MPS TCAM index that firmware had sent
earlier to driver.

So, fix by removing the wrong overwrite being done after call to
cxgb4_update_mac_filt().

Fixes: 3f8cfd0d95e6 ("cxgb4/cxgb4vf: Program hash region for {t4/t4vf}_change_mac()")
Signed-off-by: Herat Ramani <herat@chelsio.com>
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index b11ba4565c20b..9934c8b0f0b07 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3110,7 +3110,6 @@ static int cxgb_set_mac_addr(struct net_device *dev, void *p)
 		return ret;
 
 	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
-	pi->xact_addr_filt = ret;
 	return 0;
 }
 
-- 
2.20.1

