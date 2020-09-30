Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD9227F0B5
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 19:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbgI3RtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 13:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbgI3RtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 13:49:00 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AFBC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 10:49:00 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id y14so1507496pgf.12
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 10:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fU2c4c7iM/48MX+o4q+fyiFqE7snGU7LBCYm26MndCc=;
        b=XNgATelFyYMwnBU/kuhCeEYiPiLyRxoEs4FW7+vKX+eQBim9AmrSwCXWbsGIH7PGAx
         grJa2rGSrYpW+jZke4HYnUpYjYOLzMr+gEOp51VHFrjFNGBdCoidOWhaCVnB0cxiyB35
         TVm7RVwKAfXK5CJUNlMj7/dDM8xtP7CE/iwt3NJLVa7dyiZr3nqRpB7UpdTZWPqi6YTw
         D/EyUBfW5qk9wQ8KsnuB9JG4Lnty3386gVL+Hcncd/+MHGZ/d1WHQRf3Pr7WgayX7iJT
         Yp9uiFUmln2OXenx6OY/cVsA//nYSjFd4xO+QpL5oJrM0BkbFhow28LyE05kEuYzEHBS
         CXBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fU2c4c7iM/48MX+o4q+fyiFqE7snGU7LBCYm26MndCc=;
        b=WK/Hd0hFCUUwEEekpmxUoaLdj/fDVv2uS7h4MyRMdklVbHk122AnTVFlUg3etbytps
         EtCTuuJvwskOH8Nzv1Y3qqdNYhNUHiyagoAF19t3a8/k0t5KfzjwGW7TsB/STLqAzYdi
         4Qh+aseBzbWX/WVh6ncVTOdBnGSenH7gJ1Yi/s9ia1qjwlyCPZjsgSI/6ixhBqMi04DH
         I+dTBRzG3uLuFzKmaVgAxZaBeJtJAK5tK+72JRAauselFwb7GuG07q4WZgIwCZrZiE+3
         Fss+fIiFigrAypkKe3QrvguqcsypdPcWzm7Q5q8SyAYelMVtSO/PFT6YfqQjCnlMPk4E
         hpKQ==
X-Gm-Message-State: AOAM530u7cPjOPpS28C/cpQoTYD9s1nKXi79czNIayXzwRnSrA8ECnn9
        7CQWeoTb2n6T+bzJQyHL7sqTLl+8GuwCrQ==
X-Google-Smtp-Source: ABdhPJyYsA0PSOzhF89XtPAjVJ2jIzmJ9Z9e/T7P1idei/kKH+fzHcJrh8UVEjEnrDtOL1JODZJwfA==
X-Received: by 2002:a63:f961:: with SMTP id q33mr2832800pgk.95.1601488139510;
        Wed, 30 Sep 2020 10:48:59 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id l13sm2993974pgq.33.2020.09.30.10.48.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Sep 2020 10:48:59 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 2/2] ionic: prevent early watchdog check
Date:   Wed, 30 Sep 2020 10:48:28 -0700
Message-Id: <20200930174828.39657-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200930174828.39657-1-snelson@pensando.io>
References: <20200930174828.39657-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In one corner case scenario, the driver device lif setup can
get delayed such that the ionic_watchdog_cb() timer goes off
before the ionic->lif is set, thus causing a NULL pointer panic.
We catch the problem by checking for a NULL lif just a little
earlier in the callback.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 16b6b65e8319..545c99b15df8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -19,9 +19,12 @@ static void ionic_watchdog_cb(struct timer_list *t)
 	mod_timer(&ionic->watchdog_timer,
 		  round_jiffies(jiffies + ionic->watchdog_period));
 
+	if (!ionic->lif)
+		return;
+
 	hb = ionic_heartbeat_check(ionic);
 
-	if (hb >= 0 && ionic->lif)
+	if (hb >= 0)
 		ionic_link_status_check_request(ionic->lif, false);
 }
 
-- 
2.17.1

