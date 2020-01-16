Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97E2013F317
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436942AbgAPSkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:40:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:54328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389380AbgAPRMI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:12:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2EB02469D;
        Thu, 16 Jan 2020 17:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194727;
        bh=JY4h9u0i3eLa86Jb7UVUvJn58bgtbKsaAFtjDrUG4bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0pVVC9ejX8ru8XZFFASZh7U1kNn6JKW5DVnqC4/D1zmo1kDPuqZhmT2np9vAFw+x
         W3eDZU47wQaz/Pg0glhQnQsF+ZSPCo9NimhBG2IvMsWaG5MU4dSOj7LIwIdTlUWtaZ
         Mln5pa3vCSM109f1vxlKQYBD0NSpl7NtSznshcqE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 561/671] net: aquantia: Fix aq_vec_isr_legacy() return value
Date:   Thu, 16 Jan 2020 12:03:19 -0500
Message-Id: <20200116170509.12787-298-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 31aefe14bc9f56566041303d733fda511d3a1c3e ]

The irqreturn_t type is an enum or an unsigned int in GCC.  That
creates to problems because it can't detect if the
self->aq_hw_ops->hw_irq_read() call fails and at the end the function
always returns IRQ_HANDLED.

drivers/net/ethernet/aquantia/atlantic/aq_vec.c:316 aq_vec_isr_legacy() warn: unsigned 'err' is never less than zero.
drivers/net/ethernet/aquantia/atlantic/aq_vec.c:329 aq_vec_isr_legacy() warn: always true condition '(err >= 0) => (0-u32max >= 0)'

Fixes: 970a2e9864b0 ("net: ethernet: aquantia: Vector operations")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index 82582fa54d5d..72aa2a4c4d66 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -309,15 +309,13 @@ irqreturn_t aq_vec_isr_legacy(int irq, void *private)
 {
 	struct aq_vec_s *self = private;
 	u64 irq_mask = 0U;
-	irqreturn_t err = 0;
+	int err;
 
-	if (!self) {
-		err = -EINVAL;
-		goto err_exit;
-	}
+	if (!self)
+		return IRQ_NONE;
 	err = self->aq_hw_ops->hw_irq_read(self->aq_hw, &irq_mask);
 	if (err < 0)
-		goto err_exit;
+		return IRQ_NONE;
 
 	if (irq_mask) {
 		self->aq_hw_ops->hw_irq_disable(self->aq_hw,
@@ -325,11 +323,10 @@ irqreturn_t aq_vec_isr_legacy(int irq, void *private)
 		napi_schedule(&self->napi);
 	} else {
 		self->aq_hw_ops->hw_irq_enable(self->aq_hw, 1U);
-		err = IRQ_NONE;
+		return IRQ_NONE;
 	}
 
-err_exit:
-	return err >= 0 ? IRQ_HANDLED : IRQ_NONE;
+	return IRQ_HANDLED;
 }
 
 cpumask_t *aq_vec_get_affinity_mask(struct aq_vec_s *self)
-- 
2.20.1

