Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05339FB817
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 19:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbfKMSvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 13:51:37 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33525 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727582AbfKMSvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 13:51:37 -0500
Received: by mail-pg1-f194.google.com with SMTP id h27so1941345pgn.0
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 10:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=7G3k1Npis6Ug8KuaTYrL9wL4coQNwf55SFRmPVfpiaE=;
        b=EpAmnW6k8EXLXqJG5QCpQ4ejx5H+c8J30kkEZFWynmwLRIASU6AP6o2+gmzSJtCWbM
         oTlOfEAptNlKoGm8Z0wzkAzo1ok32+I4T9g1YYhYLWPxU5SGUv7GjVgxCG7aQKNyH730
         n6dvfSzpreHhVtsgrY0D1h7Y0JLDDGfiWdE9M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7G3k1Npis6Ug8KuaTYrL9wL4coQNwf55SFRmPVfpiaE=;
        b=V0KQ+0b30QZ1Jqt+efZXeONPap8MGohHQ07Ev7AERbIsnrcID0pZZlXk5dH1AGN4j+
         yx051k3xjLYTi+oy6apdqgcfE19YUiQXCAcfsFoihB5shr2V7hbT6i4BjtPpDGKdNKiV
         yYY1VGk/jARHfD5wm3IEDF19qBeOIxuuxJnZJmplKhc0HqFpKAfT4NvEcECElmEq0ffC
         hfmFjfzu8CO05JJGdG5YEl1dlJ2diMZMR16Qc/V/Vlg6C7MMJDrJ27TMP+tyotGXmdIa
         VE+Dd1Wd2VJoEQDlfJWpqb1cnVNUc4Lio5IyBLY0IU6HrR0+fK3P6vPXkhhw6VGBA2Tx
         w/rQ==
X-Gm-Message-State: APjAAAWkQm5ogP084w7h99yAKxxSw8lMxoZPXpzpWFEiAqnqtdK4E7L1
        H3xXqAyxR2cuxFGiEBDJNlG5qg==
X-Google-Smtp-Source: APXvYqzIJ7l2nzK6j+ie/36d2d8yvrzt9ufXcx5l8IL0vR9rRRKAgFF5fWFC6x0Nt/eGpUp8c4sVZw==
X-Received: by 2002:a62:7bd3:: with SMTP id w202mr5982952pfc.200.1573671096821;
        Wed, 13 Nov 2019 10:51:36 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z13sm5112296pgz.42.2019.11.13.10.51.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Nov 2019 10:51:36 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, olof@lixom.net,
        Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>
Subject: [PATCH net-next] bnxt_en: Fix array overrun in bnxt_fill_l2_rewrite_fields().
Date:   Wed, 13 Nov 2019 13:51:19 -0500
Message-Id: <1573671079-27248-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>

Fix the array overrun while keeping the eth_addr and eth_addr_mask
pointers as u16 to avoid unaligned u16 access.  These were overlooked
when modifying the code to use u16 pointer for proper alignment.

Fixes: 90f906243bf6 ("bnxt_en: Add support for L2 rewrite")
Reported-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 174412a..0cc6ec5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -166,8 +166,8 @@ bnxt_fill_l2_rewrite_fields(struct bnxt_tc_actions *actions,
 			actions->l2_rewrite_dmac[j] = cpu_to_be16(*(p + j));
 	}
 
-	if (!is_wildcard(&eth_addr_mask[ETH_ALEN], ETH_ALEN)) {
-		if (!is_exactmatch(&eth_addr_mask[ETH_ALEN], ETH_ALEN))
+	if (!is_wildcard(&eth_addr_mask[ETH_ALEN / 2], ETH_ALEN)) {
+		if (!is_exactmatch(&eth_addr_mask[ETH_ALEN / 2], ETH_ALEN))
 			return -EINVAL;
 		/* FW expects smac to be in u16 array format */
 		p = &eth_addr[ETH_ALEN / 2];
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
index 2867549..10c62b0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
@@ -64,9 +64,9 @@ struct bnxt_tc_tunnel_key {
 
 #define bnxt_eth_addr_key_mask_invalid(eth_addr, eth_addr_mask)		\
 	((is_wildcard(&(eth_addr)[0], ETH_ALEN) &&			\
-	 is_wildcard(&(eth_addr)[ETH_ALEN], ETH_ALEN)) ||		\
+	 is_wildcard(&(eth_addr)[ETH_ALEN / 2], ETH_ALEN)) ||		\
 	(is_wildcard(&(eth_addr_mask)[0], ETH_ALEN) &&			\
-	 is_wildcard(&(eth_addr_mask)[ETH_ALEN], ETH_ALEN)))
+	 is_wildcard(&(eth_addr_mask)[ETH_ALEN / 2], ETH_ALEN)))
 
 struct bnxt_tc_actions {
 	u32				flags;
-- 
2.5.1

