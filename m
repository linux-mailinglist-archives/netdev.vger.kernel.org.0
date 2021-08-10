Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1013A3E56A0
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237928AbhHJJSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237320AbhHJJSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:18:45 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DFBC061799;
        Tue, 10 Aug 2021 02:18:24 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id u16so20151068ple.2;
        Tue, 10 Aug 2021 02:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w+XOmb9EKTUysSLlZUkv3LmEhzI+OrIVJ3S44VA1yDo=;
        b=corIsdxSFyN7QcwU9IowkhXaEYzWaCYQjd/rt+eGl7DB/oby6g5Tk6+IEW+amdTKf/
         7ev3yYjnd1m6WgPzbZr13U1M2J8sv4xlQJ5RHuOGeu4XJzas7SbTcGY1vbyApklVl8Tt
         I7gxzpvYi++OMmtAMf3HhycHVUbcjXeTBPF2XADmn+JynjVbrxDrKzWMHdQZdgNqIiNO
         YN5C9CCOETRD+JGjsCgsteP4M+knjMNQHi1iPTXVhcqwzzD1NpmryFcWf2McEBbf8QpK
         UzN3kdrRGaCBjAk3zDnIYVNCItikepEcBz3Iibgx3CVog2iw26cN66kCOLTeKe4QYARI
         hrMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w+XOmb9EKTUysSLlZUkv3LmEhzI+OrIVJ3S44VA1yDo=;
        b=WYi+Q73ZFCdeNsxZ0OoGBNIaiulxX3gsbgs/b4iPleJ5RZEbdYhzNlcV4T6e+DyoNA
         kuu0EYoNyhnZdcg21EPSsoCD9SWbI6iCEqgQ2YAu1ueYXm2p0ojCOZsTJN01r931OJ5l
         IIcRQHqWWb7VwYmg/l9sRcGSCn6zD1u7ksVjHD0xxk/wVSRGsTCg9dqDjW2Hs0BZb4jP
         +tXr3wTaCvxZZixIEdezBCqv61ZqlIQBOgaHHXB1YU9dI/1Vm1jCZQO3U4yM85gVXTWR
         wG+GGlDUAZIe89W18TCA8OnQO6KXNhvZzIGhrrBF9MpXj+x7JTIEdBY9TNtpwaezy3CG
         Dy6g==
X-Gm-Message-State: AOAM531b8r5Bfax1LrGfoAXmYwyZ0SCyzrOGH+lRgAdvH9iERSWCqQ1t
        mAQzPODsqj2fW8gp0Q/X6EM=
X-Google-Smtp-Source: ABdhPJznUQMbjUf5j9hsDN3vDvvQ9YB0D2WEhdHvBC4TfnelnS19szODZs9Te4i0BiGtx0L8QFXU1w==
X-Received: by 2002:a17:90b:296:: with SMTP id az22mr3854614pjb.79.1628587103929;
        Tue, 10 Aug 2021 02:18:23 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.40])
        by smtp.gmail.com with ESMTPSA id k6sm2252089pjl.55.2021.08.10.02.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 02:18:23 -0700 (PDT)
From:   Tuo Li <islituo@gmail.com>
To:     sridhar.samudrala@intel.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, Tuo Li <islituo@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH] net: core: Fix possible null-pointer dereference in failover_slave_register()
Date:   Tue, 10 Aug 2021 02:18:00 -0700
Message-Id: <20210810091800.291272-1-islituo@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable fops is checked in:
  if (fops && fops->slave_pre_register &&
    fops->slave_pre_register(slave_dev, failover_dev))

This indicates that it can be NULL.
However, it is dereferenced when calling netdev_rx_handler_register():
  err = netdev_rx_handler_register(slave_dev, fops->slave_handle_frame,
                    failover_dev);

To fix this possible null-pointer dereference, check fops first, and if 
it is NULL, assign -EINVAL to err.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
---
 net/core/failover.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/failover.c b/net/core/failover.c
index b5cd3c727285..113a4dacdf48 100644
--- a/net/core/failover.c
+++ b/net/core/failover.c
@@ -63,8 +63,11 @@ static int failover_slave_register(struct net_device *slave_dev)
 	    fops->slave_pre_register(slave_dev, failover_dev))
 		goto done;
 
-	err = netdev_rx_handler_register(slave_dev, fops->slave_handle_frame,
+	if (fops)
+		err = netdev_rx_handler_register(slave_dev, fops->slave_handle_frame,
 					 failover_dev);
+	else
+		err = -EINVAL;
 	if (err) {
 		netdev_err(slave_dev, "can not register failover rx handler (err = %d)\n",
 			   err);
-- 
2.25.1

