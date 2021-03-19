Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A44234119C
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 01:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbhCSAtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 20:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbhCSAsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 20:48:52 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75562C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 17:48:52 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id j25so4682774pfe.2
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 17:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=phmLneIwxWYJqm2E7oyjHLE5MF057wY3DtrYLKn96UY=;
        b=Dkx82eZYC1zOKg1YtdVEL/hz6mcV4nn93Ji9cDOyfoKKM030raBuchGjjlD0jiXZ96
         L/BtfLfjPmKFHya6fqjBYj9lu3em4fiHRViezYvXfz/nzfKqJGW1bu2uyHni+VA7iTSg
         iEVSLFSfsdUcK8QIjC7G9z1Cc0qSqGRYWRDqGsNuKVw80D7Nd7HUyIsaWGK+FxCoWsp/
         xCffcEDCsrfWFeGmSX85Ep1B8Rd0MZCYlSks2y5XyVLTAOEmjPjacbdyNcrTTiSvzEHI
         HmNCsrzCyvJ7p18oLifPgDi3JKY7+ni7QY/Dn5W5ecjW09tLYWDut4l2MErSLLqvqSUE
         LuGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=phmLneIwxWYJqm2E7oyjHLE5MF057wY3DtrYLKn96UY=;
        b=G1xSltaD5fAeo3Pz8NQwGEpMsySHQS8XNHtvBAMd1DS9FZKVe/tRWNa3B6TuNkKyyb
         ZCmqYQBoGeqP4pT6fm+STsZVsBZ94aQeaErM0iAOQ0J+00mUU1t4TFX9GMLwgRx3OtmZ
         2GO7d6b752we1ETk5Vewag//Cik+KyaR0A+wrBYMZhRm72GYUaDoMsZ6NS96Kh0mfGnT
         pJjgx2hZLA/4gO7AwwiLSQdq3J1vs6wtYcicjjE4k7gelMqnsblr9KsY8lfx6ddq1ifv
         M9VotTDx+87laFn+HocwH9Wmc0YEn2JkKKtFNqaojew4395hTJFx6NNG8nLOFfrOzKzI
         jheg==
X-Gm-Message-State: AOAM5313yw9IqpBwx5A0JhXlg2c4O6jxOB+3i6IARV3sqOdWq9Ms5l5m
        /xuPKKxEWkYxGxqmLFS0AnuhJ3rK0RI9bQ==
X-Google-Smtp-Source: ABdhPJzuu9SeoZqSdkm2B7I/axma3ldsh3lV7lHE6pW6BJmS66VbO4XumWtoPIKJarwkno457KOWiA==
X-Received: by 2002:a63:ab05:: with SMTP id p5mr9212869pgf.149.1616114931747;
        Thu, 18 Mar 2021 17:48:51 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i7sm3592949pfq.184.2021.03.18.17.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 17:48:51 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/7] ionic: fix unchecked reference
Date:   Thu, 18 Mar 2021 17:48:06 -0700
Message-Id: <20210319004810.4825-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210319004810.4825-1-snelson@pensando.io>
References: <20210319004810.4825-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can get to the counter without going through the pointer
that the robot complained about.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 83ec3c664790..18fcba4fc413 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -888,7 +888,7 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 	work_done = max(n_work, a_work);
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
 		flags |= IONIC_INTR_CRED_UNMASK;
-		lif->adminqcq->cq.bound_intr->rearm_count++;
+		intr->rearm_count++;
 	}
 
 	if (work_done || flags) {
-- 
2.17.1

