Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A17E1C0971
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgD3Vd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728079AbgD3Vdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 17:33:54 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB88DC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 14:33:53 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id h11so2812800plr.11
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 14:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Wegmr42YRvQ17z0Bfvenqch5XlVtJ3cgb5J58z+4rBY=;
        b=4JWQmW2tZw1q0yMUOmXmeru2Ptc+TS7S0NOn95r0e4BK7Zg/qN4rBx59uz6cJe32EU
         nUzuRvYVxoiv50tEsPbrXsp5JsnDkOu3miqnHZze3UhQcj9Mf29dSZ83TOKeZSXNhcVM
         wYmTLEqVvlpRzkhmd/B/4NRWa1BmCEwsMxnDQ0C70F/llPNNo7wT7ZyQ6+qvdrAcpZ+0
         Ba9xvMJjFn8VFs+AV0nRoERcMEh+uEcwiIbB6/phjRlRPbCrG9OUdrJbg5zgzGJczJ/u
         ILzrGXHbkoKQ8bVhCIVGwXjf6F44CbIE4XWvaC1J3AnVZpePpI5wYJmS+4P+WPLzSe2j
         ignQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Wegmr42YRvQ17z0Bfvenqch5XlVtJ3cgb5J58z+4rBY=;
        b=c7c37rKpiIIvcI+JjPaF+jOLw3AYMOthLHhipHcCIQaYZm6AkmC5Ilz8e5qkfv97yJ
         qjN+NJKW823q/6zRxwzS8+btKgiE8eF2rz+POJctVOCYSitZaJmZjZkWVHvK+vX0PWRx
         9lJkD6VJRMfebaNjwU4fUZS80wJxEaNPhtCfcCc8MT5UmVGH9mXYpmIZc/mg/MLI99WU
         IWlEzWJuYRWAfVEC9+ofjVYOO7t8S02MHudVmhZCyCWE1zXN4jBu/F4OawO4vLCskWex
         BFNV40twuQmEdYWf2sBA/DyBQmhkOCuGDDOWSDJgIoaRPcPl454kiFdwJuoIR5UiT2n6
         VElg==
X-Gm-Message-State: AGi0PuZ855/bph1mHSPZKs+638xbWvQPkm7s/rz4wmDXETyQQWd4527+
        NzGL8wjYI61Nutgb5ec6azIG74quWVM=
X-Google-Smtp-Source: APiQypJua5WII8Hrd9Ed3VN3kK8q8egtM7yu1al2aw/PK6BuL3siIg4ZzfOVcsAmC53CKPxoelyJCA==
X-Received: by 2002:a17:902:ab8d:: with SMTP id f13mr970932plr.58.1588282433196;
        Thu, 30 Apr 2020 14:33:53 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f9sm579086pgj.2.2020.04.30.14.33.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Apr 2020 14:33:52 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net 2/3] ionic: refresh devinfo after fw-upgrade
Date:   Thu, 30 Apr 2020 14:33:42 -0700
Message-Id: <20200430213343.44124-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430213343.44124-1-snelson@pensando.io>
References: <20200430213343.44124-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure we can report the new FW version after a
fw-upgrade has finished by re-reading the device's
fw version information.

Fixes: c672412f6172 ("ionic: remove lifs on fw reset")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index bbc6c79e0f04..6fcfb634d809 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2116,6 +2116,7 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 
 	dev_info(ionic->dev, "FW Up: restarting LIFs\n");
 
+	ionic_init_devinfo(ionic);
 	err = ionic_qcqs_alloc(lif);
 	if (err)
 		goto err_out;
-- 
2.17.1

