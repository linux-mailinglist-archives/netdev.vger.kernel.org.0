Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC042289FB
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbgGUUe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730434AbgGUUeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:34:19 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB08C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:34:19 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id k27so16106pgm.2
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SYYO7N9ip/SgkV9r389TblDeOHwHXYcZZ/zsFY0lPOI=;
        b=UVnHdJAZNydw+HRqu8iX6J8nWXly9NJtxgGmzddLngUiuq8fD/9D7WKioevjJ1JzD9
         PIWdkF5IBq2hl+4sqJITFhJGaRJ6Aml8llOLNEJw6broQeJfAxbQX/WQ919Aw9uKVUIx
         VJi6gbVIHYvjERZu6SJxXt4hZG2ADgkhFhW6yCCM07r7iBE5zImA48ylec6FUJ+y+j/Z
         RJLFcPGoIn4aXNVjAAp6SrZrOQLoUr4Bfysk1wYZofafEvoM3r6O+TJ58ZtXpS2bRVZE
         MxnJvCPBod7uNZvxvdMkC6PLWFOPWCGHVq8TG+poBNTEprOCnK8KDLp8zdbc0bT/5/0e
         /sbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SYYO7N9ip/SgkV9r389TblDeOHwHXYcZZ/zsFY0lPOI=;
        b=O9Bt6tftLoIGVpiTQSXwo+Exh5tVuWRSl7bGqJGRbSVM4uZtP7TmjXnkmnjdn/6P52
         6u1qL2r0ZupmTm6pOu8C3pWPgBggXtmZO7NFausz72+5odFJwdG067ez4ikAPRAF8wK7
         mwgW9XOz0uW7Cy7NjM/X45NvF5YZLr7GclUc0LC0a70yfcIdWpyvx9Hqhmr/rA0Je1Rx
         gp5PQkDj+0M84ShiDLqKh2oFru6S0AxDq3a1sCDHUoSCUCoY6pQmzF1L0QrN/aNi9z6L
         9a9B0ZyRuS+L7h/XAUvqdRqHbTiAT2Q8hhdDB2qHwz00mGMdcxX0djbYHhmCslO3M0Ox
         UAyA==
X-Gm-Message-State: AOAM533mnkBn8p68NO2gtCGjgGjOEiXfvWg4sWTB8BUHSktSAM/0KCpp
        yNl3gStmzjYTrXlSERwDJEa4/HStSY8=
X-Google-Smtp-Source: ABdhPJxlLQ5nCwH+byTwDh0Saz4iaE3ehkw/X9ho9aAMQ+/S78HP0Rt5DUWhEFvA8G+Lrz7xHfN22Q==
X-Received: by 2002:a63:3e09:: with SMTP id l9mr24730409pga.235.1595363659208;
        Tue, 21 Jul 2020 13:34:19 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p11sm4075107pjb.3.2020.07.21.13.34.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 13:34:18 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/6] ionic: update eid test for overflow
Date:   Tue, 21 Jul 2020 13:34:07 -0700
Message-Id: <20200721203409.3432-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721203409.3432-1-snelson@pensando.io>
References: <20200721203409.3432-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix up our comparison to better handle a potential (but largely
unlikely) wrap around.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index bbfa25cd3294..db60c5405a58 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -719,7 +719,7 @@ static bool ionic_notifyq_service(struct ionic_cq *cq,
 	eid = le64_to_cpu(comp->event.eid);
 
 	/* Have we run out of new completions to process? */
-	if (eid <= lif->last_eid)
+	if ((s64)(eid - lif->last_eid) <= 0)
 		return false;
 
 	lif->last_eid = eid;
-- 
2.17.1

