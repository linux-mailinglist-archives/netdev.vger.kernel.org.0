Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E41A575D8
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfF0Acw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:32:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727038AbfF0Acu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:32:50 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C720A216E3;
        Thu, 27 Jun 2019 00:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595569;
        bh=x0tnoCKzwMTbTEg97X/tWGRnfg/9tEHvhYDSiwOpIs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKolNvQhiTm1XqfpMo0hQSqXLhpsx5ozSaqbqMllXtC93Iue0yIy5W02DU9Wxfn8r
         oLDFfCjM0YfN7LDY9YyMheSodv+wVI/GJfh1isqwArj5Jh4AbYBMv67/GXmqYSryej
         3Ccg14aeLo7aYiBwJPIRpfrJMdmMIDm8WgoYFfok=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.1 43/95] ibmvnic: Do not close unopened driver during reset
Date:   Wed, 26 Jun 2019 20:29:28 -0400
Message-Id: <20190627003021.19867-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>

[ Upstream commit 1f94608b0ce141be5286dde31270590bdf35b86a ]

Check driver state before halting it during a reset. If the driver is
not running, do nothing. Otherwise, a request to deactivate a down link
can cause an error and the reset will fail.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 3dfb2d131eb7..71bf895409a1 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1751,7 +1751,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 
 	ibmvnic_cleanup(netdev);
 
-	if (adapter->reset_reason != VNIC_RESET_MOBILITY &&
+	if (reset_state == VNIC_OPEN &&
+	    adapter->reset_reason != VNIC_RESET_MOBILITY &&
 	    adapter->reset_reason != VNIC_RESET_FAILOVER) {
 		rc = __ibmvnic_close(netdev);
 		if (rc)
-- 
2.20.1

