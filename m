Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5FB211941B
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbfLJVN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:13:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729307AbfLJVNZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE00321556;
        Tue, 10 Dec 2019 21:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012404;
        bh=YaRFw59OtT6P7jbzbduuUwlOA6GgY/U8CP3IEaag63s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JEnglAoCB1FWSYWsfKJpuzB1vEt5wRbgxQjx36dSQRn3xj8AhzI1q0uhqkHOjpWdq
         2SEHjzirnzULDdZ74lnQ9Wo8ZL271P8NplfLDxYSv7X1wAfZUSgHV9uW9ej1p6LYW/
         VBiZ51jpbU9bmcIG+IrmVH65EvXzTHZ1PA1b3Tv0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 323/350] net: ethernet: ti: ale: clean ale tbl on init and intf restart
Date:   Tue, 10 Dec 2019 16:07:08 -0500
Message-Id: <20191210210735.9077-284-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 7fe579dfb90fcdf0c7722f33c772d5f0d1bc7cb6 ]

Clean CPSW ALE on init and intf restart (up/down) to avoid reading obsolete
or garbage entries from ALE table.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw_ale.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 84025dcc78d59..e7c24396933e9 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -779,6 +779,7 @@ void cpsw_ale_start(struct cpsw_ale *ale)
 void cpsw_ale_stop(struct cpsw_ale *ale)
 {
 	del_timer_sync(&ale->timer);
+	cpsw_ale_control_set(ale, 0, ALE_CLEAR, 1);
 	cpsw_ale_control_set(ale, 0, ALE_ENABLE, 0);
 }
 
@@ -862,6 +863,7 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params *params)
 					ALE_UNKNOWNVLAN_FORCE_UNTAG_EGRESS;
 	}
 
+	cpsw_ale_control_set(ale, 0, ALE_CLEAR, 1);
 	return ale;
 }
 
-- 
2.20.1

