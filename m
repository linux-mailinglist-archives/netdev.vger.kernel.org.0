Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF41534F1D7
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 21:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbhC3Twk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 15:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbhC3Tw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 15:52:28 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BF1C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 12:52:28 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id y2so6708791plg.5
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 12:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wtdnyZve1zf5hHise/TtlCTCKeg9DkAbAnGlNUYiSZ0=;
        b=Q26dtBbiwrv9B0mJTCkaFX/8xFBF53F2TXmqEqryH6hy1UGhdZDpGawXzWkplzUA5M
         X/NJ2piWuF0O06knWAuMlkMo7aZSBDFmblJ68cp7mcVhIfOjCw2+dHRMg2kUgSGJdtYW
         NGFypdqD3EUJQGn2gxqWpWmm1g7dRtHVaXScF9nyD0Dm/rMFeIgCxBsudNGuzQAai3Q+
         j6QrECZOxKGAMtguNber+OOShVyWkW4RQqWqnIrVF4ZnSB+49paH2zz30kqaDKy5VWNq
         bVKKgEI2eJcsbTV27+AX7jRApY5fRF/4EcZZcSy85Ji14JTN5NoDNLUYj68nb0gLeTIu
         S78Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wtdnyZve1zf5hHise/TtlCTCKeg9DkAbAnGlNUYiSZ0=;
        b=m4Qjko0lnANqQHtvKWygTwM9aKvkYjUsk27jz0UfsJ/VvWQKKzIKULIqQnq36NXAMy
         5Mj84grQZBp18+Z2t7WnlW/4LFD66LhR1dLc2QzdJ0WPSh5qK0/ZvCEqx5pVpOE6TZpI
         gn38ZDdl9ZGhVAdRhUg8cGUoCdgNPI7mtvnceEiMnunyq9q/gca0hFP3oNvMLYtqAbuJ
         +2fF+isWogc+mFahB010DnAISwYYse7dXUjXJcXpCmKDM71ZoVU36wRQ2uPdFdMesBB4
         XqWnhJKCzBmImkqNrM1Png+4wyEaePAXNVnxwPYdqeCphf3cfQwgQM/KpkRYEbRdlxXK
         Dw4A==
X-Gm-Message-State: AOAM530/cBAcYswEYsv3p/SzNk0aJLmLugGuBpj3Fv1Xlihws/VdF6xj
        4hMd/09lWYg9oksQUbeACBhwYJ1Qwb94zw==
X-Google-Smtp-Source: ABdhPJwpM8Y8/J1S8tDBb03OjMmyrugM+X1JT8WhTtPzi9U5h2OOITnYF0uDtEbCOpoc/1yQgBHenQ==
X-Received: by 2002:a17:902:8c92:b029:e6:60ad:6924 with SMTP id t18-20020a1709028c92b02900e660ad6924mr34584026plo.16.1617133947757;
        Tue, 30 Mar 2021 12:52:27 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id y8sm20433pge.56.2021.03.30.12.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 12:52:27 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/4] ionic: fix sizeof usage
Date:   Tue, 30 Mar 2021 12:52:08 -0700
Message-Id: <20210330195210.49069-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210330195210.49069-1-snelson@pensando.io>
References: <20210330195210.49069-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the actual pointer that we care about as the subject of the
sizeof, rather than a struct name.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 889d234e2ffa..a51be25723a5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -676,20 +676,20 @@ static int ionic_qcqs_alloc(struct ionic_lif *lif)
 
 	err = -ENOMEM;
 	lif->txqcqs = devm_kcalloc(dev, lif->ionic->ntxqs_per_lif,
-				   sizeof(struct ionic_qcq *), GFP_KERNEL);
+				   sizeof(*lif->txqcqs), GFP_KERNEL);
 	if (!lif->txqcqs)
 		goto err_out;
 	lif->rxqcqs = devm_kcalloc(dev, lif->ionic->nrxqs_per_lif,
-				   sizeof(struct ionic_qcq *), GFP_KERNEL);
+				   sizeof(*lif->rxqcqs), GFP_KERNEL);
 	if (!lif->rxqcqs)
 		goto err_out;
 
 	lif->txqstats = devm_kcalloc(dev, lif->ionic->ntxqs_per_lif,
-				     sizeof(struct ionic_tx_stats), GFP_KERNEL);
+				     sizeof(*lif->txqstats), GFP_KERNEL);
 	if (!lif->txqstats)
 		goto err_out;
 	lif->rxqstats = devm_kcalloc(dev, lif->ionic->nrxqs_per_lif,
-				     sizeof(struct ionic_rx_stats), GFP_KERNEL);
+				     sizeof(*lif->rxqstats), GFP_KERNEL);
 	if (!lif->rxqstats)
 		goto err_out;
 
-- 
2.17.1

