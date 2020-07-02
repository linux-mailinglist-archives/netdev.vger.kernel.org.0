Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2D6211891
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 03:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbgGBB3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 21:29:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729448AbgGBB1U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 21:27:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4816620748;
        Thu,  2 Jul 2020 01:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653240;
        bh=MeKeOAlNFA1dCY/9kVwr8uC2xH0StdwaBh9S8iz1+GQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=19Fjp8hwvpFSTMPzuqR78Hu7fVHsTzAAf4JnVaw5elvfv1AaqYVLpgQtJgi1GLDQv
         vr4Y23Vh9gwAliH5GbsX72koDmYVsC6nqBjA6cnwijYpRP70/56e9shoy6VkSvVnzV
         ENnA3Xk+mBhePq5i4C6PVKiDitxZp9FOTAdNVJAg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Christensen <drc@linux.vnet.ibm.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 06/13] tg3: driver sleeps indefinitely when EEH errors exceed eeh_max_freezes
Date:   Wed,  1 Jul 2020 21:27:05 -0400
Message-Id: <20200702012712.2701986-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012712.2701986-1-sashal@kernel.org>
References: <20200702012712.2701986-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Christensen <drc@linux.vnet.ibm.com>

[ Upstream commit 3a2656a211caf35e56afc9425e6e518fa52f7fbc ]

The driver function tg3_io_error_detected() calls napi_disable twice,
without an intervening napi_enable, when the number of EEH errors exceeds
eeh_max_freezes, resulting in an indefinite sleep while holding rtnl_lock.

Add check for pcierr_recovery which skips code already executed for the
"Frozen" state.

Signed-off-by: David Christensen <drc@linux.vnet.ibm.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index c069a04a6e7e2..5790b35064a8d 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18174,8 +18174,8 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
 
 	rtnl_lock();
 
-	/* We probably don't have netdev yet */
-	if (!netdev || !netif_running(netdev))
+	/* Could be second call or maybe we don't have netdev yet */
+	if (!netdev || tp->pcierr_recovery || !netif_running(netdev))
 		goto done;
 
 	/* We needn't recover from permanent error */
-- 
2.25.1

