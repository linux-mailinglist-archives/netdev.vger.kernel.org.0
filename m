Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 250A61229FD
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 12:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfLQL3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 06:29:20 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54434 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbfLQL3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 06:29:20 -0500
Received: by mail-wm1-f67.google.com with SMTP id b19so2554603wmj.4
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 03:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=mA72j7+jOVwCAhxQRCwhK2wiXzUwaWalblDQES8UjtI=;
        b=wsbxCyUjuWmKeYSITzaTUcWTdag5+8V0qRZMb92jZAZ/WKbM23jwKgIzXcZiH9A7N+
         j2rg8k8ei1WArKkmfpImRWyeUeV5s+g0XvA0vDGFf2iEDM3pcJEraeXum1uLz9f06yhA
         mHxDpqIUGown7juQ6oKix6c+9r4poCzhul8COOLGS+KLdGF8rANSKjKpoYQnKSzxr41p
         bbG7JjE9IMBBdmRuXF7sUYoV4oxx1mJKng1YUb2OU8xMcZFMytMocI979GvyhSA5vIM8
         YdoxK/DRXTXQFlZPlIGPDuaixeMFPworHkr5NADJGOnKSTNTmDuZ5elDVDOeQ3uGxLhd
         7Ckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mA72j7+jOVwCAhxQRCwhK2wiXzUwaWalblDQES8UjtI=;
        b=Xhf8w5194SfvYPUzTY8iET2Tp59nMgKKFcPbRTEX75NsEXmipyQzci8nq1l3/EeTUK
         eOWR9iLG4cLMYp8OqGavnWpeiavUPBfniVnVi9Fg07Pyyp8ZpMRO8FAdm9JY+HAACoYQ
         Rks9kAGc+VxdTGqN2aU0Ii7VlfusfZUm4PCF8QX5keKTV9JtF9QMx20Y9AUSIuemha50
         cxhChFjoV2NLH4s3yiRpz/Y1UTS3fhjO7MCNt0NoDb1jRxyuX2NYgQSXeWi9EBddpqk2
         6eGJXb4xRnIvP1sUzn8BGKMpLWVmPXFw+5IsH4kNyw19of21CLSHPPcONtkgmHE8V+gt
         375g==
X-Gm-Message-State: APjAAAWX7y9e0pLPGNVpvaK0NTuYxYeuajwxH1dmyiFFGzaGpBToCVaw
        LQn13uXRmi3LRXNOBwIFIxqEJiHmHpdct3Odwy5QsX6zq3sRAmD3T8Zang5f2FpvJ28WY9iqpC9
        qTwsmjEl89K07EbrrjEX2owY9h0lh1JTjA29rfuIA3nwxdNxP2xhTYPD/NC/49loiXVMakRoSfQ
        ==
X-Google-Smtp-Source: APXvYqz66/mKVbZHtvvPiC5nF8GL5JuglLlkqMOzW8ls4rGVgp+Lk+RWP7zJbowb3PN4FbJo10WIGA==
X-Received: by 2002:a1c:2355:: with SMTP id j82mr5012664wmj.135.1576582157877;
        Tue, 17 Dec 2019 03:29:17 -0800 (PST)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id j12sm26326790wrw.54.2019.12.17.03.29.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 03:29:17 -0800 (PST)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net 1/1] nfp: flower: fix stats id allocation
Date:   Tue, 17 Dec 2019 11:28:56 +0000
Message-Id: <1576582136-26701-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As flower rules are added, they are given a stats ID based on the number
of rules that can be supported in firmware. Only after the initial
allocation of all available IDs does the driver begin to reuse those that
have been released.

The initial allocation of IDs was modified to account for multiple memory
units on the offloaded device. However, this introduced a bug whereby the
counter that controls the IDs could be decremented before the ID was
assigned (where it is further decremented). This means that the stats ID
could be assigned as -1/0xfffffff which is out of range.

Fix this by only decrementing the main counter after the current ID has
been assigned.

Fixes: 467322e2627f ("nfp: flower: support multiple memory units for filter offloads")
Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/metadata.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index 7c4a15e..5defd31 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -65,17 +65,17 @@ static int nfp_get_stats_entry(struct nfp_app *app, u32 *stats_context_id)
 	freed_stats_id = priv->stats_ring_size;
 	/* Check for unallocated entries first. */
 	if (priv->stats_ids.init_unalloc > 0) {
-		if (priv->active_mem_unit == priv->total_mem_units) {
-			priv->stats_ids.init_unalloc--;
-			priv->active_mem_unit = 0;
-		}
-
 		*stats_context_id =
 			FIELD_PREP(NFP_FL_STAT_ID_STAT,
 				   priv->stats_ids.init_unalloc - 1) |
 			FIELD_PREP(NFP_FL_STAT_ID_MU_NUM,
 				   priv->active_mem_unit);
-		priv->active_mem_unit++;
+
+		if (++priv->active_mem_unit == priv->total_mem_units) {
+			priv->stats_ids.init_unalloc--;
+			priv->active_mem_unit = 0;
+		}
+
 		return 0;
 	}
 
-- 
2.7.4

