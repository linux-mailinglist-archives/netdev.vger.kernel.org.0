Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC3B18A50B
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgCRU6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:58:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728258AbgCRU5B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:57:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06518208E4;
        Wed, 18 Mar 2020 20:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584565020;
        bh=CsM8V2CQnyjC90orvntK+0kSmFRCj8crCFyUUVSPRKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BbOIyhGjzdUvb31a5qUOS4lcoBK+vpRRZ/E/l1YeMPv6E9Z/MDCtuWicpco3FUgA3
         nBNnpAlq7olR/Lnzi04eUxwCzDBu/EQk8sm0+WeAQkq2i/6g+W05AkfpGVvzTihGhc
         Saa+Z4/Fk1E9aoIBpCprmHzu8G2+9tIEcWAHBny4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dominik Czarnota <dominik.b.czarnota@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 10/12] sxgbe: Fix off by one in samsung driver strncpy size arg
Date:   Wed, 18 Mar 2020 16:56:46 -0400
Message-Id: <20200318205648.17937-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205648.17937-1-sashal@kernel.org>
References: <20200318205648.17937-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dominik Czarnota <dominik.b.czarnota@gmail.com>

[ Upstream commit f3cc008bf6d59b8d93b4190e01d3e557b0040e15 ]

This patch fixes an off-by-one error in strncpy size argument in
drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c. The issue is that in:

        strncmp(opt, "eee_timer:", 6)

the passed string literal: "eee_timer:" has 10 bytes (without the NULL
byte) and the passed size argument is 6. As a result, the logic will
also accept other, malformed strings, e.g. "eee_tiXXX:".

This bug doesn't seem to have any security impact since its present in
module's cmdline parsing code.

Signed-off-by: Dominik Czarnota <dominik.b.czarnota@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 413ea14ab91f7..56cdc01c58477 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -2315,7 +2315,7 @@ static int __init sxgbe_cmdline_opt(char *str)
 	if (!str || !*str)
 		return -EINVAL;
 	while ((opt = strsep(&str, ",")) != NULL) {
-		if (!strncmp(opt, "eee_timer:", 6)) {
+		if (!strncmp(opt, "eee_timer:", 10)) {
 			if (kstrtoint(opt + 10, 0, &eee_timer))
 				goto err;
 		}
-- 
2.20.1

