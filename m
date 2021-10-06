Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB9842384A
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 08:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235442AbhJFGnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 02:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbhJFGnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 02:43:18 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F80C061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 23:41:26 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id p13so5989677edw.0
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 23:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pdu3L4NcADl5/G5Um0qOHZnkRaHAuNI8Eb+mCI5eyS8=;
        b=AVwKpGdJUn/R1epCnnXQYH/pfwHOaH/JXZPuc8j+i5lXnNds01gKE0+wuI2e90TDkc
         yn3mO5+fad4+DFjpOT/uW7zGl5pT4M26ITpeOJo5oqwsGQSB0fsNR73onVfg4zFL0owg
         dl4fA5wiD3aPVWMg45+DlVvyaj0Cegoe4tCqgkTu/yM9n4gQOxN5ASA5uLghlwLA6XTK
         v/ACBA8fnzc1O4BuZW71a+7B7LP19Ksy9LOrmetTzpg15oLfA/teKBRUrDevG+FLjbf5
         R9HJ3exbWuY3xNBoh1m6En5v+Y+OOPdbzDP7i99ZwuEz4nfrbeWlRC/2N3WHWynx0PYe
         WByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pdu3L4NcADl5/G5Um0qOHZnkRaHAuNI8Eb+mCI5eyS8=;
        b=Zc3kgRPbI2BWZvLDfH5b0WDise9/xBXsxNLQWAgOsgswl5YjLzRLaqboaySll7jeOa
         O0FC3feUsxXnssG8hBIYlNkNjsJJTnUheJL9g5INmAXyQQg5j0U2WhH2uMhA8KkWJpTd
         0vea42idgFmuNDVN38vTxcZiTCYKC6VlyXgxXGNLaRQu94Mm0GGKEBVw8nLGNrPVZ6f4
         tuIZzIOnbq3QyYB8vuyQmdN1P3ibOI8JF6vXA1AtWXgu5qjuxuVFEcvU/gF5MupoHsSs
         tZ4M9SXzK2G3VHSUVQ3KL6P/q3bflZLOpGd9Vcx4mmFLwa4l9/Mi0ttlY97DNejo6bC3
         a0WQ==
X-Gm-Message-State: AOAM5329Tf/1QKQmhWnQwn7ekTXHv5aWifR9BPvHMk+mirpXaMQmM8aj
        yhAM7TWVu4SL/BdkO3bvIszanyxiKLGZtA==
X-Google-Smtp-Source: ABdhPJxvGXj8M4U8KpLXtoUNaCuUbErJCTg1uetkDqBc2vak335773SMWTZIIlQsegg+RKpDC/7Umw==
X-Received: by 2002:a17:907:2071:: with SMTP id qp17mr19546937ejb.41.1633502484828;
        Tue, 05 Oct 2021 23:41:24 -0700 (PDT)
Received: from localhost ([45.153.160.140])
        by smtp.gmail.com with ESMTPSA id dd3sm2079178ejb.55.2021.10.05.23.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 23:41:24 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     Siva Reddy Kallam <siva.kallam@broadcom.com>
Cc:     prashant@broadcom.com, mchan@broadcom.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net: tg3: fix obsolete check of !err
Date:   Wed,  6 Oct 2021 00:41:20 -0600
Message-Id: <20211006064120.25585-1-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

The err variable is checked for true or false a few lines above.  When
!err is checked again, it always evaluates to true.  Therefore we should
skip this check.

We should also group the adjacent statements together for readability.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index d95b11480865..5a50ea75094f 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -11202,34 +11202,30 @@ static void tg3_reset_task(struct work_struct *work)
 	err = tg3_init_hw(tp, true);
 	if (err) {
 		tg3_full_unlock(tp);
 		tp->irq_sync = 0;
 		tg3_napi_enable(tp);
 		/* Clear this flag so that tg3_reset_task_cancel() will not
 		 * call cancel_work_sync() and wait forever.
 		 */
 		tg3_flag_clear(tp, RESET_TASK_PENDING);
 		dev_close(tp->dev);
 		goto out;
 	}
 
 	tg3_netif_start(tp);
-
 	tg3_full_unlock(tp);
-
-	if (!err)
-		tg3_phy_start(tp);
-
+	tg3_phy_start(tp);
 	tg3_flag_clear(tp, RESET_TASK_PENDING);
 out:
 	rtnl_unlock();
 }
 
 static int tg3_request_irq(struct tg3 *tp, int irq_num)
 {
 	irq_handler_t fn;
 	unsigned long flags;
 	char *name;
 	struct tg3_napi *tnapi = &tp->napi[irq_num];
 
 	if (tp->irq_cnt == 1)
 		name = tp->dev->name;
