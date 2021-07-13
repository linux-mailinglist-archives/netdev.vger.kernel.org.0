Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B309E3C6F0F
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 12:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235790AbhGMLBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 07:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235390AbhGMLBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 07:01:49 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BA9C0613DD;
        Tue, 13 Jul 2021 03:58:59 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id v6so12342362lfp.6;
        Tue, 13 Jul 2021 03:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D9zpTdN6p7SwNXQB1vuqj99Xdu6Hr8oPzuitgbMbnZk=;
        b=ZTn/WbFDqY9SPvf3lVVTkPfOrI5ttwO9SW0TSXDm2iFHdX8XB5zQ2x6G4XYT1UgUpg
         a3H+KqkJfkuVMp7uYIX22W7rEp/V06WBquLqI0hgEqBEbIfkkzz4XDNfv34OPNRNZEGn
         ZOK7klAN++kcFMvp2Kj52zf7rO57FcF6co/QtpeZYUdTF9l0WnjqXndAb/ORhNfoQKLH
         COAB5jL6JuLSEki7Un8IrS3SBUNqtPykbLHhfDM0g36cGC/X+DB75JdNtMgLjiEQ0ALX
         OmDvh/92srotT25b0RFy3APdl/KRPDP2sUPtLJMuVX6asw8DfDikuXAv8dFPLqAie7NS
         9lIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D9zpTdN6p7SwNXQB1vuqj99Xdu6Hr8oPzuitgbMbnZk=;
        b=iYJ+fjK7a+p/t6dLo1d/jLQLAVfmUvLEu7EU8Mj3/a7A00BZ23mqcUh9SUTvJVe/kV
         nWwMUL6NNwYYqinx2NlSlHotpXVp2QV7Gj9qaTO5EsbUy6xEImVxmvUi5XmbtG2GdCzo
         cVN3eUJnBxDw5dxVNr/ZdwrxIKZ6565ea6Ea3YPAyrQzsDBGqIzuXWmrcbA5huMKXWeU
         KNUesNu6rIlh75hDLZFRGzBdPUKp4E6ESnipfFjlnJpRlf7ySpY1FyfhpnTIFjnpuIDu
         uHmJeRhXpdIZHFz80LwWSCP8KGUiv+zVwhf6Zj9oIPA+K40SkP4KUFh+wwp7zAdzXxOj
         wN4Q==
X-Gm-Message-State: AOAM530Nt++gAQ1Uzji/ThU9GxOovvLT+oqFcwuTulxtPMUnNUEct9ub
        0Jrg06ihRARSqQ3vQiBbhLtrV6VGubcnlw==
X-Google-Smtp-Source: ABdhPJzfXrm6xvAzy0gVpRtApq3vqO52EaQJHWWR3f0EimmrNTPumFpYfZ2b3NJLxHtx0ULx1SP+vw==
X-Received: by 2002:a05:6512:230d:: with SMTP id o13mr2900964lfu.557.1626173937603;
        Tue, 13 Jul 2021 03:58:57 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.115])
        by smtp.gmail.com with ESMTPSA id i67sm208006lji.60.2021.07.13.03.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 03:58:57 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     macro@orcam.me.uk, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH] net: fddi: fix UAF in fza_probe
Date:   Tue, 13 Jul 2021 13:58:53 +0300
Message-Id: <20210713105853.8979-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fp is netdev private data and it cannot be
used after free_netdev() call. Using fp after free_netdev()
can cause UAF bug. Fix it by moving free_netdev() after error message.

Fixes: 61414f5ec983 ("FDDI: defza: Add support for DEC FDDIcontroller 700
TURBOchannel adapter")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/fddi/defza.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/fddi/defza.c b/drivers/net/fddi/defza.c
index 14f07050b6b1..0de2c4552f5e 100644
--- a/drivers/net/fddi/defza.c
+++ b/drivers/net/fddi/defza.c
@@ -1504,9 +1504,8 @@ static int fza_probe(struct device *bdev)
 	release_mem_region(start, len);
 
 err_out_kfree:
-	free_netdev(dev);
-
 	pr_err("%s: initialization failure, aborting!\n", fp->name);
+	free_netdev(dev);
 	return ret;
 }
 
-- 
2.32.0

