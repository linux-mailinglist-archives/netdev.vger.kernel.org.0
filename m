Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D201A9E2F
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 13:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409421AbgDOLsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 07:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409408AbgDOLsB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 07:48:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C874821707;
        Wed, 15 Apr 2020 11:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951280;
        bh=WLolElHMTnMxmTQuBmH3/DlNfQo9VbUZguyx/Au5DVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdjnGJLatJHjh2Z6Qm/+ZFWnD7MMNySakahJIE/oIu0Vo6zbOGPMcLUo14om+eD2R
         VAkCHR3Kl7NF5gSkUB9Es4eXggVhGDp1rpfM6tpOVIgFksP0zljlQn8dpFkOAJyPfz
         b3gMHSoi9C7ftqfkMageemdWUQa1Eob0cujAheMA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Palethorpe <rpalethorpe@suse.com>,
        Kees Cook <keescook@chromium.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, security@kernel.org, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 10/21] slcan: Don't transmit uninitialized stack data in padding
Date:   Wed, 15 Apr 2020 07:47:37 -0400
Message-Id: <20200415114748.15713-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114748.15713-1-sashal@kernel.org>
References: <20200415114748.15713-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Palethorpe <rpalethorpe@suse.com>

[ Upstream commit b9258a2cece4ec1f020715fe3554bc2e360f6264 ]

struct can_frame contains some padding which is not explicitly zeroed in
slc_bump. This uninitialized data will then be transmitted if the stack
initialization hardening feature is not enabled (CONFIG_INIT_STACK_ALL).

This commit just zeroes the whole struct including the padding.

Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
Fixes: a1044e36e457 ("can: add slcan driver for serial/USB-serial CAN adapters")
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: linux-can@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: security@kernel.org
Cc: wg@grandegger.com
Cc: mkl@pengutronix.de
Cc: davem@davemloft.net
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/slcan.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 94b37c60fdd06..d0435c7631ff9 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -147,7 +147,7 @@ static void slc_bump(struct slcan *sl)
 	u32 tmpid;
 	char *cmd = sl->rbuff;
 
-	cf.can_id = 0;
+	memset(&cf, 0, sizeof(cf));
 
 	switch (*cmd) {
 	case 'r':
@@ -186,8 +186,6 @@ static void slc_bump(struct slcan *sl)
 	else
 		return;
 
-	*(u64 *) (&cf.data) = 0; /* clear payload */
-
 	/* RTR frames may have a dlc > 0 but they never have any data bytes */
 	if (!(cf.can_id & CAN_RTR_FLAG)) {
 		for (i = 0; i < cf.can_dlc; i++) {
-- 
2.20.1

