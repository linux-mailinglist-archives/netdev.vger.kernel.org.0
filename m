Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82D6262AC5
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbgIIIqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729692AbgIIIpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:45:55 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974A9C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:45:55 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d6so1538971pfn.9
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4Twzxw1B2BEXICvcuXXK4ahrEJies/qQr9k/p5ftbOo=;
        b=EaCEMsMEGo3pbOyQaPyknRxZH2ZWYedKwBjs85xwVFsjDvh5LoSZ1A8ln0G27Jn3hj
         Swac8IiLoFPErwr62cwBWHwep4QXb0+z74Qj4Bh29r8lHQmdNsf/IHEuV9aP7pmYYhhP
         iv2yq91u0OA+8P1VE8BhkmrdykGkwjLfvvQejHE9IIsnjuQPQNJBHgtxF/EbDe2hQlRG
         0wcmekwxouJSyx+UsaDvEqzMa191rLgykBxfaNTzqpXvO5KVZ7h+pTbr9LL3PkJqzcfj
         Mo2coLa5ubwBknXk20g1zVaCsI/6RAT1S/OSnVb6lMq9MuKoNZM8Bh+qvibWK9iIl8zU
         mR/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Twzxw1B2BEXICvcuXXK4ahrEJies/qQr9k/p5ftbOo=;
        b=NKgi0I+P0IKWuAKwAcZ5lffpFDam5EW5sh/YhI9VUwL4UkeM/5QnQQkuhKFc3/4QIJ
         SKgQbD73Ki1epYsKy37YzO5CX3wuvCRp3Il1DD9i2BxXwtBXn3mbveQbTXKSLiZQLdPu
         O1z7PIqN4AJ/PDDAhFCXGMk738fiyLzjTZegOeoy2ciCTUm61Gdmb0Rhhw3Ipadgrc7U
         bb56SxXLKi76LzgYnsAJV4RNErV5tMBRTovDDIYVYQAj6s5psY5Awbvu5XgB82jOWEXL
         yglF2+B+Sw1ePsF8GRXuMvcGdUixIdrSFWIIXAE3Pdev8CK9tfO5eIY5mKKJb2N+6WZP
         XrgQ==
X-Gm-Message-State: AOAM533GaVjSdDXq4znepMg2OEjap5U8aOxHytb81blHznDZ9RbQKWvF
        9QMaZBkBkyzVQnjrllaPKWM=
X-Google-Smtp-Source: ABdhPJy+NQnKZ9XfRiD6bsaFOKTt3HWqbCQpyuPDNRMVOi3Z52twqsHitVL0s223U+RB45LFbgI19A==
X-Received: by 2002:aa7:958f:: with SMTP id z15mr2553632pfj.162.1599641155209;
        Wed, 09 Sep 2020 01:45:55 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:45:54 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 09/20] ethernet: ehea: convert tasklets to use new tasklet_setup() API
Date:   Wed,  9 Sep 2020 14:14:59 +0530
Message-Id: <20200909084510.648706-10-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200909084510.648706-1-allen.lkml@gmail.com>
References: <20200909084510.648706-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/ethernet/ibm/ehea/ehea_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 3153d62cc73e..c2e740475786 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -1212,9 +1212,9 @@ static void ehea_parse_eqe(struct ehea_adapter *adapter, u64 eqe)
 	}
 }
 
-static void ehea_neq_tasklet(unsigned long data)
+static void ehea_neq_tasklet(struct tasklet_struct *t)
 {
-	struct ehea_adapter *adapter = (struct ehea_adapter *)data;
+	struct ehea_adapter *adapter = from_tasklet(adapter, t, neq_tasklet);
 	struct ehea_eqe *eqe;
 	u64 event_mask;
 
@@ -3417,8 +3417,7 @@ static int ehea_probe_adapter(struct platform_device *dev)
 		goto out_free_ad;
 	}
 
-	tasklet_init(&adapter->neq_tasklet, ehea_neq_tasklet,
-		     (unsigned long)adapter);
+	tasklet_setup(&adapter->neq_tasklet, ehea_neq_tasklet);
 
 	ret = ehea_create_device_sysfs(dev);
 	if (ret)
-- 
2.25.1

