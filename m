Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4EB5EA638
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 14:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbiIZMdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 08:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236254AbiIZMcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 08:32:31 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552B1D98E3
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 04:10:59 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id l14so13256627eja.7
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 04:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=h2V8ELpIryQAbY8td0umQBuSPCmA0EOhyDXgC3lIzTw=;
        b=peKu1oV8oTIf9doG2i9KFDQc938nS8IXqQyUxoIizPbvdSWmyKTfOXmwtwh/ByIgzW
         JWX/ifpkouDtc5cQpynP+ilDAgNxJqmwn4m+gkNwVR6vrq5v6b+qTSfFRMV4i7h85ucW
         qLaseo49qzcDhrYqF6M/fs1yFh5soL9c8uKEmtLAWsy3XNm3aJOFUvBJycVCi+NrARmA
         c3KEWUcxEGtKKPkRJLaG3GxPFc0eSx1gUinZJrT6zkCuTgsnC6CWsGyZaq16U+nf07cK
         4KCgIop2rH5D83kGy6mNDHeaNiuweWpvXeBwxwWML4hUGq9Y8NdUclnS8eji8vG9eg8x
         a/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=h2V8ELpIryQAbY8td0umQBuSPCmA0EOhyDXgC3lIzTw=;
        b=LzUXfFP/kETd+HbUn3cdbFcY8NHeuqx7jsu9SKHOtOj1KgcxIp1qV7DyjOCPT1cl1A
         2kIldWk1jf0I0o5pYkc9WhFxvyQT3AAjtXVbMsYyjg/jCQYBoxL+HoGEcSbP0JmzepQy
         VvwDoK/CINzNi9t5N0r3/fPGqbSSdyNfuzJZBtslgo2/T8N/Bgwy6B/Qw1rSSgaqEB4X
         YIjwOxfRJU5k4lP1gOI3K2Idma6fnJ9WIb9b7Nh+OEgTd9zEJBY4RufDdGjGXumIfqp7
         4nod7IXlxiowJp7aS1H2MkfysUdXVfz8sAq4eTUJ/pRaOhRn2ZQkiWCfSNLXqhNV85eP
         k+IQ==
X-Gm-Message-State: ACrzQf2SMcmM3KHwH/5UUc0cX5ruCjC5/2p0qC9pXNr0a5ntPWfN6cJf
        SjeGV9HfMngKsIKk1XxsLlxN5eCCQN6U0qqiN5Q=
X-Google-Smtp-Source: AMsMyM5tDRgkg/VtM3mMlwLRXjJp85U1qhXaEzfMR3szfPyoX8t9j/7n330yxbttBd5IYd0J/tU3LQ==
X-Received: by 2002:a17:907:3d94:b0:782:60bc:c896 with SMTP id he20-20020a1709073d9400b0078260bcc896mr16828319ejc.701.1664190584784;
        Mon, 26 Sep 2022 04:09:44 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r5-20020aa7cb85000000b0045467008dd0sm11219185edt.35.2022.09.26.04.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 04:09:44 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        snelson@pensando.io, drivers@pensando.io, f.fainelli@gmail.com,
        yangyingliang@huawei.com
Subject: [patch net-next 3/3] ionic: change order of devlink port register and netdev register
Date:   Mon, 26 Sep 2022 13:09:38 +0200
Message-Id: <20220926110938.2800005-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220926110938.2800005-1-jiri@resnulli.us>
References: <20220926110938.2800005-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Make sure that devlink port is registered first and register netdev
after. Unregister netdev before devlnk port unregister.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c  | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 0a7a757494bc..ce436e97324a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -320,16 +320,16 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			dev_err(dev, "Cannot enable existing VFs: %d\n", err);
 	}
 
-	err = ionic_lif_register(ionic->lif);
+	err = ionic_devlink_register(ionic);
 	if (err) {
-		dev_err(dev, "Cannot register LIF: %d, aborting\n", err);
+		dev_err(dev, "Cannot register devlink: %d\n", err);
 		goto err_out_deinit_lifs;
 	}
 
-	err = ionic_devlink_register(ionic);
+	err = ionic_lif_register(ionic->lif);
 	if (err) {
-		dev_err(dev, "Cannot register devlink: %d\n", err);
-		goto err_out_deregister_lifs;
+		dev_err(dev, "Cannot register LIF: %d, aborting\n", err);
+		goto err_out_deregister_devlink;
 	}
 
 	mod_timer(&ionic->watchdog_timer,
@@ -337,8 +337,8 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
-err_out_deregister_lifs:
-	ionic_lif_unregister(ionic->lif);
+err_out_deregister_devlink:
+	ionic_devlink_unregister(ionic);
 err_out_deinit_lifs:
 	ionic_vf_dealloc(ionic);
 	ionic_lif_deinit(ionic->lif);
@@ -380,8 +380,8 @@ static void ionic_remove(struct pci_dev *pdev)
 	del_timer_sync(&ionic->watchdog_timer);
 
 	if (ionic->lif) {
-		ionic_devlink_unregister(ionic);
 		ionic_lif_unregister(ionic->lif);
+		ionic_devlink_unregister(ionic);
 		ionic_lif_deinit(ionic->lif);
 		ionic_lif_free(ionic->lif);
 		ionic->lif = NULL;
-- 
2.37.1

