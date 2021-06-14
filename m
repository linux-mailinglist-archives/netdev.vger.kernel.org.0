Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD36B3A6AA1
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 17:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbhFNPkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 11:40:39 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:42598 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbhFNPkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 11:40:36 -0400
Received: by mail-pg1-f178.google.com with SMTP id i34so8936625pgl.9;
        Mon, 14 Jun 2021 08:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k0S1cmvYXsguMzhn//4kJjmpVofxyX3uWpaVIXA04XY=;
        b=RdfUGhVGFRZUhJaIg6tmSBAzhW2dDn+0dJ/8oEa+w5mP7UHzck/r9lTG7T2WwnY13w
         5zqIUZj8oIqr5ZDL97A+hACiJFJ9q19DiaIe3QJsGO4HjSRAWctmz9GYRB72/PljDh7U
         i2cKAwo+uGY0ahOh7Xurf+jIJ6fVR7uPSljJ+sVgmPYy7gInoHF3Y6yCWF3kcarnTNBn
         P8uCHaNDdtxQ/wdc7kBuENjJx0rMT0YV2mFshOBNXGd6WbvbNEY5RAkN/1FPd+4PXNQr
         yFOhIycBuSWzSfbM7xeQy+FzkSv28G/VGITt8KQr6FJnC2eEyTyRP3CveTNXRdj524LD
         OmeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k0S1cmvYXsguMzhn//4kJjmpVofxyX3uWpaVIXA04XY=;
        b=ZmMuf6iI9vKTkzqefqMbpTmgqapZ/Jow1Guizx1FN52bk5tHfWk3NUCd4ncRTWlVC6
         xkpAHIe73Qv7ffqRrzUWtGwspI0x1xzAw1u1G5lGYHj0NkRvSCfgFwZ4glDJasgyGDW9
         1Q2XF5KT+g2/NHyLCHpbsYCFe3zkbe0Txdm25Gplhmc+B9mPXu0poRenOhydt+iIzBj0
         x2wQUFn32PbGIrXwLKbT9SU/6z0hPmMAZkaB77ecSTNV+EwLJ+FreIGZx7xBykp4+LOu
         Yvk+jrf8NSd93wH2R/N5geXsNRUibJ8nVfc28qnEQmauvxn/HVFLDIsCN07w36XLdlrk
         pIEQ==
X-Gm-Message-State: AOAM532EU0DR1I4o7iRNKlsnQkHowj6PsyQ/zYnWKCxaDVEhQZe5dRi7
        u1p01QP3e261Vs7mYVdeFrY=
X-Google-Smtp-Source: ABdhPJyE7XZOKUhHvkQqFzcFoLFmaeIi7yd9MTxC3uYdE+DkmYD9+fvnMjRYrO2FAvGcZO8wB199dA==
X-Received: by 2002:a63:d213:: with SMTP id a19mr17878821pgg.28.1623685045224;
        Mon, 14 Jun 2021 08:37:25 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.34])
        by smtp.gmail.com with ESMTPSA id z18sm1216630pfe.214.2021.06.14.08.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 08:37:24 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     steve.glendinning@shawell.net, davem@davemloft.net,
        kuba@kernel.org, paskripkin@gmail.com
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH] net: usb: fix possible use-after-free in smsc75xx_bind
Date:   Mon, 14 Jun 2021 23:37:12 +0800
Message-Id: <20210614153712.2172662-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
fails to clean up the work scheduled in smsc75xx_reset->
smsc75xx_set_multicast, which leads to use-after-free if the work is
scheduled to start after the deallocation. In addition, this patch also
removes one dangling pointer - dev->data[0].

This patch calls cancel_work_sync to cancel the schedule work and set
the dangling pointer to NULL.

Fixes: 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/usb/smsc75xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index b286993da67c..f81740fcc8d5 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1504,7 +1504,10 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	return 0;
 
 err:
+	cancel_work_sync(&pdata->set_multicast);
 	kfree(pdata);
+	pdata = NULL;
+	dev->data[0] = 0;
 	return ret;
 }
 
-- 
2.25.1

