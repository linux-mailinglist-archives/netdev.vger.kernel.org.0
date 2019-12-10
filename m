Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0E7118FAB
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 19:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbfLJSUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 13:20:43 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39886 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbfLJSUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 13:20:43 -0500
Received: by mail-lf1-f67.google.com with SMTP id y1so3192349lfb.6
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 10:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Ae7UIGpNEHz7iGfPkceuKpB+MrsFQDuX6RhFbGqe0Y=;
        b=k/388TNcIhySZdszmwn3OVElLIp0GlyUViI5CrM1FOzsP/VdPYT/NQg6L1/aXdqT5o
         r9tqSxo+mWbUHpVZDEM8KfsBga873ngfqe/soBD+41hQ6doUTXBZTl1vB6ZK25Djxc0O
         GXXR6Eo2FylISrE1wY1mFS+xBpAKeQbkWe7ryNh0+GGFmNscCtiLxE7BXhP9jzBbn7qm
         OEHPEktQGvHbg/d0It0wSDOonJC5D96uFbm5QBkMlqw8q068R29t0BPG5Vb/GisQl1mw
         Gw6FOvST5qD+euhzHOxoU2XuSSct3w3YfPmoHNQ4LHPJUg5Bhsx4UHl14Dsh2T7U7/kO
         oF5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Ae7UIGpNEHz7iGfPkceuKpB+MrsFQDuX6RhFbGqe0Y=;
        b=BftiZjDEUU5zlHv8UsKWU++/wkg5Juxknzk1oSNx1lyjQ886KHTWbUbp+zBusJK677
         EdZTffwvH7JQGhtCghsNRj2wAsxWpp5Fw3AG5/MllV0iBiYrqeocsOEQ+5J8LT4CRvTw
         s042JNREW+iRN/6/pMUf6yden7LrwDKtZnENuIks6eNPizaipw1HvWkuLc0y2DwS7vV1
         NFZ9+9/v6cZTSLA/Etq4G2JZS1C+QgXjS0w77jvzYJtQbbm0H03h3NtK/hdtZjYFbRMt
         SJCDl4alnVCmK3SOWR7C7vbTs0GyS4tj5NOfPbjqwCkw2gZd/6OSuW8TJo7RvXvTiLDV
         LY7w==
X-Gm-Message-State: APjAAAWjhLmbc7Gwbm8aiQoOqbmK1GPHdmBe+EW9CIHCJem5I0z0IDRf
        zB8zSmkWTenB0kgCknlhMZTEU5C2wPE=
X-Google-Smtp-Source: APXvYqxTT5175wCjk8EKC+j/wf94VM/2tBIseu86CeUEAwdHxqvfG4ChPrhJcp1d006iQTvGDDRZOw==
X-Received: by 2002:a19:ac43:: with SMTP id r3mr20114994lfc.156.1576002041227;
        Tue, 10 Dec 2019 10:20:41 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x84sm2054181lfa.97.2019.12.10.10.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 10:20:40 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next] Revert "nfp: abm: fix memory leak in nfp_abm_u32_knode_replace"
Date:   Tue, 10 Dec 2019 10:20:32 -0800
Message-Id: <20191210182032.24077-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 78beef629fd9 ("nfp: abm: fix memory leak in
nfp_abm_u32_knode_replace").

The quoted commit does not fix anything and resulted in a bogus
CVE-2019-19076.

If match is NULL then it is known there is no matching entry in
list, hence, calling nfp_abm_u32_knode_delete() is pointless.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/abm/cls.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/abm/cls.c b/drivers/net/ethernet/netronome/nfp/abm/cls.c
index 9f8a1f69c0c4..23ebddfb9532 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/cls.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
@@ -176,10 +176,8 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
 	u8 mask, val;
 	int err;
 
-	if (!nfp_abm_u32_check_knode(alink->abm, knode, proto, extack)) {
-		err = -EOPNOTSUPP;
+	if (!nfp_abm_u32_check_knode(alink->abm, knode, proto, extack))
 		goto err_delete;
-	}
 
 	tos_off = proto == htons(ETH_P_IP) ? 16 : 20;
 
@@ -200,18 +198,14 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
 		if ((iter->val & cmask) == (val & cmask) &&
 		    iter->band != knode->res->classid) {
 			NL_SET_ERR_MSG_MOD(extack, "conflict with already offloaded filter");
-			err = -EOPNOTSUPP;
 			goto err_delete;
 		}
 	}
 
 	if (!match) {
 		match = kzalloc(sizeof(*match), GFP_KERNEL);
-		if (!match) {
-			err = -ENOMEM;
-			goto err_delete;
-		}
-
+		if (!match)
+			return -ENOMEM;
 		list_add(&match->list, &alink->dscp_map);
 	}
 	match->handle = knode->handle;
@@ -227,7 +221,7 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink,
 
 err_delete:
 	nfp_abm_u32_knode_delete(alink, knode);
-	return err;
+	return -EOPNOTSUPP;
 }
 
 static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,
-- 
2.23.0

