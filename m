Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77D5DFF00D
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731027AbfKPPwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:52:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730999AbfKPPwU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:52:20 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E53520842;
        Sat, 16 Nov 2019 15:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919539;
        bh=pm4J433S+H+C6Sxgui/dBAeNPiQ5Rk3ZCpsfCJCntLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=df6Wy+u+lH+AHD8WLcpze6Ao25lqDOVjcIqc9Ch2aj2yaghl5AHCS+xyEkTC0lhsi
         yst4R9IYy698YTTCNyfKjUvTDIrTk5R+va+ydr2Pn02FNR1ERWfZUmW472bkwFVyxA
         TldPTWI+a2zpic9NqOYUNFOOJoy1+vMcfZdkrU9Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Radu Rendec <radu.rendec@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 55/99] macsec: let the administrator set UP state even if lowerdev is down
Date:   Sat, 16 Nov 2019 10:50:18 -0500
Message-Id: <20191116155103.10971-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 07bddef9839378bd6f95b393cf24c420529b4ef1 ]

Currently, the kernel doesn't let the administrator set a macsec device
up unless its lower device is currently up. This is inconsistent, as a
macsec device that is up won't automatically go down when its lower
device goes down.

Now that linkstate propagation works, there's really no reason for this
limitation, so let's remove it.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Reported-by: Radu Rendec <radu.rendec@gmail.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index d2a3825376be5..a48ed0873cc72 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2798,9 +2798,6 @@ static int macsec_dev_open(struct net_device *dev)
 	struct net_device *real_dev = macsec->real_dev;
 	int err;
 
-	if (!(real_dev->flags & IFF_UP))
-		return -ENETDOWN;
-
 	err = dev_uc_add(real_dev, dev->dev_addr);
 	if (err < 0)
 		return err;
-- 
2.20.1

