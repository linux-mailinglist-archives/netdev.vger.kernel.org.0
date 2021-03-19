Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A3934119B
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 01:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbhCSAtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 20:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbhCSAsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 20:48:51 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6770DC06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 17:48:51 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id v186so2550632pgv.7
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 17:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Jdvpti7gDLJUD7WSK/dQGqLb41HeEAoSo8BbTXmzOBc=;
        b=t+XGdZeaWam7sikJiCOVQKru/cxnQkVUFLck1o0OJLvjFyFFt9YhEr/E15npjycMSX
         GOE8K3/p/1wnaetfxFUfzQpHOjLZ+u1yftcEMXv5ZqbwQUllMbbRiKSeo5STd4rFNjOI
         qsIURA78OxJ1qJ1vilq/avsLAdGzqdwYz9YiLrHTxKXuF43Wd5exog3Ihh4Syc/X8RpQ
         tkAo+qoZwKZadQ3ml4MtVyPytpy08G626GHXtDHqPR4SR7sAaP5AI58NIztOVrIhQVJl
         VtipmcbZNL7/ungOCY5+iiG8/7PhjB6mRiTWfkWWRzR+rIHB9SlVWmwmTnwv9GT395fb
         Pc7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Jdvpti7gDLJUD7WSK/dQGqLb41HeEAoSo8BbTXmzOBc=;
        b=HZl0byFqGlMnpMoB55FmWPWEV5kge3DY5DGt4YzjYXPss82xiy9MWMYuYEy/eHTFbT
         vaCIDdmZzCshpw/S1zROb8EfLHgegaTcu8+OAhLek9caBqyTPeGhcdRbGjfLt58g8/xW
         Y+fx8Mi+SEk/z7eStG5rDU4v6fhEsn3K+52IPaURpe8m0hU1rKk0Ufxtt0j3tYGWCwF9
         98NwkpGoeycZ0QmDovBH9aLFeWnB49bR9bshsoOUp7F5a6uVsWTDz5Vi7fpuQSYNPm70
         M4YmdrF7A/Qhl33nMzUGWNNFv83G0Mw8bAp6YIa821LOCtjYuL7i7hVR9KqD9cK1cWFz
         cQWA==
X-Gm-Message-State: AOAM532JQjdHOwXI4p6qTu+oLfu1ckCFX52UG9UMtL3YJfeDdj5hNRtK
        6SoIDnVLVFLHGZ1+w487ajPPioHojfmCEQ==
X-Google-Smtp-Source: ABdhPJzxVkDtGb7jIPaJfTU/3peTFrb1MSnnYQNv1awcdHQUPv9fVMUi63SOleVQ1PN60whG2ZTMYw==
X-Received: by 2002:a65:4588:: with SMTP id o8mr8990930pgq.243.1616114930714;
        Thu, 18 Mar 2021 17:48:50 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i7sm3592949pfq.184.2021.03.18.17.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 17:48:50 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/7] ionic: simplify the intr_index use in txq_init
Date:   Thu, 18 Mar 2021 17:48:05 -0700
Message-Id: <20210319004810.4825-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210319004810.4825-1-snelson@pensando.io>
References: <20210319004810.4825-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The qcq->intr.index was set when the queue was allocated,
there is no need to reach around to find it.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 7ee6d2dbbb34..83ec3c664790 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -715,10 +715,8 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	unsigned int intr_index;
 	int err;
 
-	if (qcq->flags & IONIC_QCQ_F_INTR)
-		intr_index = qcq->intr.index;
-	else
-		intr_index = lif->rxqcqs[q->index]->intr.index;
+	intr_index = qcq->intr.index;
+
 	ctx.cmd.q_init.intr_index = cpu_to_le16(intr_index);
 
 	dev_dbg(dev, "txq_init.pid %d\n", ctx.cmd.q_init.pid);
-- 
2.17.1

