Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F6E2A8B27
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 01:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732636AbgKFAMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 19:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729162AbgKFAMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 19:12:33 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB68FC0613D2
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 16:12:32 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id v12so2650709pfm.13
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 16:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RzMJ5I54EBNjTKdQhYz0zoJbUVPD0Jjli8LFYU8UorI=;
        b=j9VGIlz6kxk5ynOxCJdEf0yuZcp8D9wsgHB/c2XkRvAHmEdAvY9Jqz2jsFaOytNfG3
         iT9n5p0uaAZFgsHvc5Id+RaPWmizI5mYBPew8tlLpcDfz2NsTNhUpLyIQVK5Di5wV8aE
         VdZ8XMHkQ7ezdHYgclPrPpobUcTgySHurlqx9BLjtKua+pd1TxWCl700bGGqbXv8uJ9r
         VMGKC1oc+5RD6FjsVtyNlXPzl0wOcjr/k4paNMb48I3q6VObnc8YyKRvULfllq9sRDGr
         fW1r8RejTzA1Gg4nTOnoeXwvRKGGdEiZLp3S3Cs66FSmKQ3RnDGHzsvxf6HqY1H2+UJz
         oKZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RzMJ5I54EBNjTKdQhYz0zoJbUVPD0Jjli8LFYU8UorI=;
        b=Y/0Num1jV9rQbWJF91knDA8+d1RV68ZzhszYoztXBcJJROCPP9khiygJiw6dWhfoBA
         OwrfHNJVhHWjFnSd8pQu/UqejaXS2YIgqfcqwzolgi84OP2McF4Lc3N+yDAB97tk/WX+
         fxuaiINgyKIiGzKloOKVuCaA3u4ot4SVJfQ3C4QphM1QOmOHhrToHCGk3jfWGtZblz1y
         cIrWgHnAwlPZQ/cVom8i39fOLgjSQhOpWs1eWggCMfDc2CvyuGyr2KVf9YOBxeNu2/oT
         9n/DbAB94HCP/qQsxTJ5NEfJFE0MaIo8qizn6E4eRaeQiJ5FuWoMkReaE84gLgWm42HP
         rnoA==
X-Gm-Message-State: AOAM530EkQ4woH4oZ+Bm1jReFD3/wDIIKmbKmQ7c79MbALYQcLipGZOb
        G8nMQEHewjSBCCl37kGkUmvq+Vbs2vr0hQ==
X-Google-Smtp-Source: ABdhPJwEPHxh39/0PjO1rZygNffylevCu/o97s/X4N4K4bAZG+6YJ7PD+wbhez9iYvWNn6vZtiVMgw==
X-Received: by 2002:a17:90a:c381:: with SMTP id h1mr77998pjt.2.1604621552240;
        Thu, 05 Nov 2020 16:12:32 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 22sm3236009pjb.40.2020.11.05.16.12.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2020 16:12:31 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 2/8] ionic: check for link after netdev registration
Date:   Thu,  5 Nov 2020 16:12:14 -0800
Message-Id: <20201106001220.68130-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106001220.68130-1-snelson@pensando.io>
References: <20201106001220.68130-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Request a link check as soon as the netdev is registered rather
than waiting for the watchdog to go off in order to get the
interface operational a little more quickly.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 5457fb5d69ed..519d544821af 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2959,6 +2959,8 @@ int ionic_lif_register(struct ionic_lif *lif)
 		dev_err(lif->ionic->dev, "Cannot register net device, aborting\n");
 		return err;
 	}
+
+	ionic_link_status_check_request(lif, true);
 	lif->registered = true;
 	ionic_lif_set_netdev_info(lif);
 
-- 
2.17.1

