Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC2F21192A
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 03:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgGBBcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 21:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729172AbgGBB02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 21:26:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C24E20884;
        Thu,  2 Jul 2020 01:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653187;
        bh=2iQA6mqimRsMV25dNMf7E6m/TlOIfN2OM6I+gFbKVQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+e98XblPKHqeURh7SVlaSxlCftCc5H++2RYnT9oe5QpPU0fn1jlhSaepsLZUZvRn
         ffgtm3CNSxZgwp59kP6WJrtesvjWeN7IDFwA5VRvAeGsbv3XJPAwS5TkmCTQHeP+Sd
         ANEeHxDjLfQVcStUFuDhaxyjlN7GxIfXm8tm6bKA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Christensen <drc@linux.vnet.ibm.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/27] tg3: driver sleeps indefinitely when EEH errors exceed eeh_max_freezes
Date:   Wed,  1 Jul 2020 21:25:58 -0400
Message-Id: <20200702012615.2701532-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012615.2701532-1-sashal@kernel.org>
References: <20200702012615.2701532-1-sashal@kernel.org>
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
index a12962702611f..be845df050399 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18229,8 +18229,8 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
 
 	rtnl_lock();
 
-	/* We probably don't have netdev yet */
-	if (!netdev || !netif_running(netdev))
+	/* Could be second call or maybe we don't have netdev yet */
+	if (!netdev || tp->pcierr_recovery || !netif_running(netdev))
 		goto done;
 
 	/* We needn't recover from permanent error */
-- 
2.25.1

