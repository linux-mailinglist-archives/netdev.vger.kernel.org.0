Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02404179C69
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 00:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388646AbgCDXZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 18:25:54 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41789 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388513AbgCDXZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 18:25:53 -0500
Received: by mail-pf1-f193.google.com with SMTP id z65so1277641pfz.8
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 15:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9kK2gp8lH7DW4mExEB7VoodT66C5LLSkZSrlV7lTjOo=;
        b=fo76lB/MFXly1m9FTH7DfY8HBuYzJggI0umek+h4CBDoWcEidpSsv3thfLbt2CM6xY
         pNsYoqUz80ErbDMTmIJzOQdZ1L6wou8hAILc+jloKmS3XGhEYL+AlxxosEBUOO4QpscR
         CbVtJBSNcnKVGZisf+Sv773xrsp80GgBIzd7DCIGGkoBILb++yAN9HfMgu4//zYIps5B
         69/EdFyC9+vof7OrPf2gp1HbwQEeGl2LX8cAFXzVM10wdgyPLDbP4IU30OK/DFXlGmj8
         NydsEjXEu7z7+ytEeX5YjRc56b/xWfAaeg0M4XLTuKX3fUqoKjZSvK0+3t1pqYOCPa2E
         MeQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9kK2gp8lH7DW4mExEB7VoodT66C5LLSkZSrlV7lTjOo=;
        b=p8kXEDDshKqdeGo03QaWjyo5YrAhqpaZ67CDH2TkkmVNkgZ/Ny3/I1j2OxhHRVnYOH
         eMhcl/7rhdlBta7rZq3ukQuagx1EioZkaos52qba4ZSXYq50wsFA+cVcOVvTzwFgUNPU
         vNT9Vuc44EVwch7JW/HFRCI4OwU9+5x3v4JWj7GvF7FJRzkLvV47gq1LPBa3MhNbGHYC
         chHt00rQ39oo/8uQwYiJ7xbCnleFosM5kOK3LuLl3VF7IyGbxh8HntGQpXgwBOCAz393
         RmXjKb4QAhjENRTf7mOVcMOdhrVptrJI+nKFNwvLJUrRe3Bd7xeLBxPEKG8xFiWJ7ebI
         XxwA==
X-Gm-Message-State: ANhLgQ3yksCw+80Y4Z0BYPUPnVS0sDU4pibut5j6o+9OWUdnGpyc2ACr
        2dYtLu+VbpVo9WnvvVrDEz4=
X-Google-Smtp-Source: ADFU+vvpCaKpmF/0U00E36N50kl7wBCwvhlun4jPbovMUyIMTu7oIUyH13cVCt6naKwKYQKuJ9sE/A==
X-Received: by 2002:a63:d0c:: with SMTP id c12mr4702005pgl.173.1583364352705;
        Wed, 04 Mar 2020 15:25:52 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id 70sm3724228pjz.45.2020.03.04.15.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 15:25:51 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next v2 3/3] net: rmnet: use GFP_KERNEL instead of GFP_ATOMIC
Date:   Wed,  4 Mar 2020 23:25:43 +0000
Message-Id: <20200304232543.12589-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the current code, rmnet_register_real_device() and rmnet_newlink()
are using GFP_ATOMIC.
But, these functions are allowed to sleep.
So, GFP_KERNEL can be used.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1->v2:
 - This patch is not changed

 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 63d0c2017ee5..1305522f72d6 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -57,7 +57,7 @@ static int rmnet_register_real_device(struct net_device *real_dev)
 	if (rmnet_is_real_dev_registered(real_dev))
 		return 0;
 
-	port = kzalloc(sizeof(*port), GFP_ATOMIC);
+	port = kzalloc(sizeof(*port), GFP_KERNEL);
 	if (!port)
 		return -ENOMEM;
 
@@ -127,7 +127,7 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 		return -ENODEV;
 	}
 
-	ep = kzalloc(sizeof(*ep), GFP_ATOMIC);
+	ep = kzalloc(sizeof(*ep), GFP_KERNEL);
 	if (!ep)
 		return -ENOMEM;
 
-- 
2.17.1

