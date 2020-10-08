Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9424287879
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731341AbgJHPyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729753AbgJHPyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:16 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7D6C0613D3;
        Thu,  8 Oct 2020 08:54:16 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id y14so4628027pgf.12;
        Thu, 08 Oct 2020 08:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iR4S+vy+X8hSsoqTbdxoK8jm+a+g1MB2e+bQrH820wQ=;
        b=S5ZCJbOy7n/QZlWA+9mN1zhH/XpNcrf9RmWlfwED1GCGVd1W/J6PRDVAcVYXkcCjIc
         +9BiE0fJ+ET0F7Ce2xrG+CsCd2WMnsRgakevHI+KhA9fgcu8tZo034pH4rhK89WoI/9L
         DN7gK8yJTQ8N81tWiat1fqk49SEYk91bbY0DrB9c6k5cTPaK9bqvYV3JKgICHxszUaXu
         lU1D2EioQt5jD8owDbTrfRGyga3RWMWuUsEKOMr/cVnJWhO4K7bXxYHXE0i6mEVFudjb
         W5gxRxc6rVdtoBfbbwneh1fRmb/w8dCN+pTc9y0Z94jgR15pmBOw9IitRpW8fPyzmVeg
         mN4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iR4S+vy+X8hSsoqTbdxoK8jm+a+g1MB2e+bQrH820wQ=;
        b=fECsPeUeX7IYA7f6NjcoywxtG4zqFtikAlqGfCwDINH1z9LSztr5J91Fwoeq9EL5Nb
         VNv1PgI3iDpQPTj58xsBPeMOtll0XGgY+moV6WTj41JKtjFHlKa9qFNgintjWBHk8jkY
         nd+q3N15Fy0fWCh4z8uxTu1XV1ztXi7clizHDuen6ynjd9iaAuglP4zhlpX//2dV73lb
         OkYkFB/PR6UFjZGCfcM2Z8UNYq69He4rhYhV7vsiz+ER3PC6FzWZID+D00keJ/kaaptk
         IHjLElX1spam5YZDMD1dKQWO1iC/n+GiHJgFOdvgbZp2dOMqimNNdAY6vMTr+4qhtjGr
         K/lg==
X-Gm-Message-State: AOAM532OQB930zcI9bhWbbseF4a8MIn/jtedRn0sab/rbvgA24qCl4Nw
        8LsLTck7tVhPo+nH0qDkPUE=
X-Google-Smtp-Source: ABdhPJyT87bpPvkaVRP+RJzdz/UgAQnnKLWZ2eOQ7hEo672A+FnaboJHcfQUmxMmUe5y45OYuEivuw==
X-Received: by 2002:a17:90a:2a08:: with SMTP id i8mr8980567pjd.65.1602172456402;
        Thu, 08 Oct 2020 08:54:16 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:15 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 037/117] wl12xx: set tx_queue_len_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:49 +0000
Message-Id: <20201008155209.18025-37-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 2f01a1f58889 ("wl12xx: add driver")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ti/wl1251/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wl1251/debugfs.c b/drivers/net/wireless/ti/wl1251/debugfs.c
index 21d432532bc3..165e346bf383 100644
--- a/drivers/net/wireless/ti/wl1251/debugfs.c
+++ b/drivers/net/wireless/ti/wl1251/debugfs.c
@@ -214,6 +214,7 @@ static const struct file_operations tx_queue_len_ops = {
 	.read = tx_queue_len_read,
 	.open = simple_open,
 	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t tx_queue_status_read(struct file *file, char __user *userbuf,
-- 
2.17.1

