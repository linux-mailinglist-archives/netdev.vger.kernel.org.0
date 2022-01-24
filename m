Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1A04989D0
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344351AbiAXS62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344433AbiAXSyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:54:40 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7558C06175D
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:27 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id p37so16896710pfh.4
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d9XEdqcvKhqXvvc9/6zlC8tzG3yqZE/13DygdJczKik=;
        b=kPUyimVXuNw/CddYTLIR2gwjaLsTHEMpyScoI8SPOYIZ17s6Nt1PLBY75lOLumtZA7
         prye1wfZpnduoHJDfV1NUuywHZvnhkd7dVEnRDzCKSmhljR4j/hjhBgt4/tud36uYNUk
         3ML5J9EgSiPe7uUsi9Hn654yVXmQJ5h0Gx8Z1oq7trpUfuZ1B3NAsDXAN1XpmhlQXwRA
         TxIjK7FxEDLi+C2rgVBElGtqKeVVW8DzjqSKXBr7YD98PDDv8RAvST25INP5A/gyUxao
         VkZsJSam9Efa6Ga0aINia2c1RxnzbjR1YGQc7fh4/iwnuklPe+XoOtAckxTA4CuGQplI
         xWRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d9XEdqcvKhqXvvc9/6zlC8tzG3yqZE/13DygdJczKik=;
        b=zg4TxiZMdJ0UfCERM10eN6uJV0gyIKWYidhfPg94cnElHIVQRwPC6y40+V7MkTjRf5
         xX6/z15FQKQXNiL/thVa7Sq+B6z/fpyCKpkixjawH9AjRNIOD1tHdHX7STDxWp9zbnwC
         k4eJwi36HbyQUKhwi+LnEiB1cwNyF2qMI7t9OSChrFXxfnCuxA1un8KH36PSmqz8Of1v
         ZJAHgPJ7M07MnkIqwf6DnlfRUaAjhwJ5CGB4piAeS61o49gbem2ukABS8CFLFqaMctlq
         epxV311pmdylHdYy1xddzQmuAEtCYt0avJClITUWxYCv2eXwDY8LPgajMB2hLg4huw44
         dZiQ==
X-Gm-Message-State: AOAM530m98vADlUKV6IvLMw7lymkQWTI9qQ6h13MO0MWTxxEvPYiws61
        6hqSrsTxfsSFSSO8YhwXHY/FUw==
X-Google-Smtp-Source: ABdhPJwagG5HzFD6ak/8A4fd0oTSd3XybUsHRdHvUzmcul2C8ZpRZ9ky2kCiLqylyTWqpng7a1QgNw==
X-Received: by 2002:a62:140a:0:b0:4c9:df3b:7443 with SMTP id 10-20020a62140a000000b004c9df3b7443mr3851408pfu.73.1643050407416;
        Mon, 24 Jan 2022 10:53:27 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id cq14sm85177pjb.33.2022.01.24.10.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:53:27 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 01/16] ionic: fix type complaint in ionic_dev_cmd_clean()
Date:   Mon, 24 Jan 2022 10:52:57 -0800
Message-Id: <20220124185312.72646-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124185312.72646-1-snelson@pensando.io>
References: <20220124185312.72646-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse seems to have gotten a little more picky lately and
we need to revisit this bit of code to make sparse happy.

warning: incorrect type in initializer (different address spaces)
   expected union ionic_dev_cmd_regs *regs
   got union ionic_dev_cmd_regs [noderef] __iomem *dev_cmd_regs
warning: incorrect type in argument 2 (different address spaces)
   expected void [noderef] __iomem *
   got unsigned int *
warning: incorrect type in argument 1 (different address spaces)
   expected void volatile [noderef] __iomem *
   got union ionic_dev_cmd *

Fixes: d701ec326a31 ("ionic: clean up sparse complaints")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 875f4ec42efe..a89ad768e4a0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -370,10 +370,10 @@ int ionic_adminq_post_wait_nomsg(struct ionic_lif *lif, struct ionic_admin_ctx *
 
 static void ionic_dev_cmd_clean(struct ionic *ionic)
 {
-	union __iomem ionic_dev_cmd_regs *regs = ionic->idev.dev_cmd_regs;
+	struct ionic_dev *idev = &ionic->idev;
 
-	iowrite32(0, &regs->doorbell);
-	memset_io(&regs->cmd, 0, sizeof(regs->cmd));
+	iowrite32(0, &idev->dev_cmd_regs->doorbell);
+	memset_io(&idev->dev_cmd_regs->cmd, 0, sizeof(idev->dev_cmd_regs->cmd));
 }
 
 int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
-- 
2.17.1

