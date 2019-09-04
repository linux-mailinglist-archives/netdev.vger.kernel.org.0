Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAC8A8A98
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731842AbfIDQAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731786AbfIDP75 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D22D20820;
        Wed,  4 Sep 2019 15:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612796;
        bh=kq4pdFmtcMw82+SxqAXPhY8B6WPqlfQZGcEo6PI8wQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I2dlvUFgJ705ofWZRwh7B4+2D+wPTFJHOV6b0PQn1H5Bfib4CNDnehFcoasA3gkuO
         ch3kibbMGPtYlE6n6pA/Tjg153NTw1ESye0Tk5ZeR8XuT7ZBAGmyDmSEPCFN16JQ+N
         /6xmphQFZoCpEgB8gNBiIRu8pMVhISgara7H2IMw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        Michael Symolkin <Michael.Symolkin@aquantia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 90/94] net: aquantia: linkstate irq should be oneshot
Date:   Wed,  4 Sep 2019 11:57:35 -0400
Message-Id: <20190904155739.2816-90-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <Igor.Russkikh@aquantia.com>

[ Upstream commit 5c47e3ba6fe52465603cf9d816b3371e6881d649 ]

Declaring threaded irq handler should also indicate the irq is
oneshot. It is oneshot indeed, because HW implements irq automasking
on trigger.

Not declaring this causes some kernel configurations to fail
on interface up, because request_threaded_irq returned an err code.

The issue was originally hidden on normal x86_64 configuration with
latest kernel, because depending on interrupt controller, irq driver
added ONESHOT flag on its own.

Issue was observed on older kernels (4.14) where no such logic exists.

Fixes: 4c83f170b3ac ("net: aquantia: link status irq handling")
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Reported-by: Michael Symolkin <Michael.Symolkin@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 41172fbebddd3..1a2b090652930 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -390,7 +390,7 @@ int aq_nic_start(struct aq_nic_s *self)
 						   self->aq_nic_cfg.link_irq_vec);
 			err = request_threaded_irq(irqvec, NULL,
 						   aq_linkstate_threaded_isr,
-						   IRQF_SHARED,
+						   IRQF_SHARED | IRQF_ONESHOT,
 						   self->ndev->name, self);
 			if (err < 0)
 				goto err_exit;
-- 
2.20.1

