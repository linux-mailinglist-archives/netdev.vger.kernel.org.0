Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC7818A597
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgCRVCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:02:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727231AbgCRUzv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:55:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 829E6208CA;
        Wed, 18 Mar 2020 20:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564951;
        bh=I5hn+26qGqtFIORQfWtcZqngIEBWE6NORvMAshb68Ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+07VRsg9QTwKuKlSvY/i5PDDPm2PCB2F7wIcVytCe41+i+DtRVO88b1YDrf5cdFG
         ckKYF9otA+wPbO3qHRi8sfrx/eYfa/tYEJ6FJKDKaFpNyN1cq6ytaIOoehLthqh9TT
         5KrP232vrNZCqP1caNPQL1zePReUzAr9VRB3vawc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 35/37] net: systemport: fix index check to avoid an array out of bounds access
Date:   Wed, 18 Mar 2020 16:55:07 -0400
Message-Id: <20200318205509.17053-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205509.17053-1-sashal@kernel.org>
References: <20200318205509.17053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit c0368595c1639947839c0db8294ee96aca0b3b86 ]

Currently the bounds check on index is off by one and can lead to
an out of bounds access on array priv->filters_loc when index is
RXCHK_BRCM_TAG_MAX.

Fixes: bb9051a2b230 ("net: systemport: Add support for WAKE_FILTER")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 6f8649376ff06..3fdf135bad56e 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2168,7 +2168,7 @@ static int bcm_sysport_rule_set(struct bcm_sysport_priv *priv,
 		return -ENOSPC;
 
 	index = find_first_zero_bit(priv->filters, RXCHK_BRCM_TAG_MAX);
-	if (index > RXCHK_BRCM_TAG_MAX)
+	if (index >= RXCHK_BRCM_TAG_MAX)
 		return -ENOSPC;
 
 	/* Location is the classification ID, and index is the position
-- 
2.20.1

