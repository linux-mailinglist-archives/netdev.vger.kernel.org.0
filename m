Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A63D1FDB2B
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgFRBKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727010AbgFRBKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9284E21924;
        Thu, 18 Jun 2020 01:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442633;
        bh=QqpywQU4j7DlGriZrifQlD4J68J04/CqPP3jGYn/NXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGHJLnTG+VUdw58PsvAaI3Dafr5ITIjHVO+aFe0KzHS9cVlduWCcJm3NjyO2VhPJO
         i8YahpdLBNS/3xbUIsQmFE1+h7IMHes8PxNew7esYv1Ljynee35QjccXZq48L9Qdxk
         6KhTjS49LOJIu68+MpnRSH3N3K2CkXzGCW7G9Fjg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.7 110/388] ibmvnic: Flush existing work items before device removal
Date:   Wed, 17 Jun 2020 21:03:27 -0400
Message-Id: <20200618010805.600873-110-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>

[ Upstream commit 6954a9e4192b86d778fb52b525fd7b62d51b1147 ]

Ensure that all scheduled work items have completed before continuing
with device removal and after further event scheduling has been
halted. This patch fixes a bug where a scheduled driver reset event
is processed following device removal.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 197dc5b2c090..1b4d04e4474b 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5184,6 +5184,9 @@ static int ibmvnic_remove(struct vio_dev *dev)
 	adapter->state = VNIC_REMOVING;
 	spin_unlock_irqrestore(&adapter->state_lock, flags);
 
+	flush_work(&adapter->ibmvnic_reset);
+	flush_delayed_work(&adapter->ibmvnic_delayed_reset);
+
 	rtnl_lock();
 	unregister_netdevice(netdev);
 
-- 
2.25.1

