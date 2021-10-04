Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A2B420A54
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 13:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhJDLrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 07:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhJDLru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 07:47:50 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E48C061745;
        Mon,  4 Oct 2021 04:46:01 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z20so12357326edc.13;
        Mon, 04 Oct 2021 04:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=Ewvfb9TfoOrB3wjVZosaVIDfp3qUGnihOrSho0ZmSw8=;
        b=UGzdLUxzYx/3rJlY199GS8BnPIVwwYWR7WtOio2DSVcI7jmy8LAE+vUJ/9Ay2OtjYh
         LucVch9Zwko3HjRSNhXcrVjWFqfEtor4sTOjkqc6We4+kEDWt0/LWKv/DCIxwJfyb6Sn
         ENsl9LBFY20ZJ2lCjUU47RgvE8M20Gz/r4Ne9p5MaZ0ufS266eBvFRcryiNcfiq7XWKw
         ukgqoYiVHMSRzrse4s8xuGpdY4iRRQeDtSYPndLFDwlM7/Y8X9bjmJVgmMba3Po6m8Cs
         GgL+tcgoKCtlzONracSYeRPK8dIZiKelgXSfXIQtoUPxU5/6XtO2StgIfjz5a6JAox72
         kGXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ewvfb9TfoOrB3wjVZosaVIDfp3qUGnihOrSho0ZmSw8=;
        b=tx26m5khF4bV1aeAiNkCDd1byTVoSmK0QtgUlIJFw14qCGw3zLxlATVby2eKMvCRFQ
         LdAbjRxZVSt/yTmvcVjGTNiyFvqNNWP0DHjovfhs6d6SrKvgXLEJQbEC2MR2/TsZQgtx
         gkUU5RCWR4xlc35n+ny6uTw7obRl7UrvwVSJoeJmsZmcJWeCV1rVwREmwwAk+LRnHWfM
         ULAsIHdp0zHlYAnJ0rZ8mZyzXRTQs69/9637/lMK9QaVw/XF37LTRx3DobWCDG863Cpy
         IEyuBi5RaPjQR6uYINFLSQ079ah564C9Pefvxq0An4Whd6KoIhlWgE5ndT0541lAHnGU
         n1og==
X-Gm-Message-State: AOAM530MHqwksgvi5jzmrOGn1ijImsJG9tUU2zyTmXSPPtakfnUReuzE
        oEZBYtZfK4groLeQe6lw1r0=
X-Google-Smtp-Source: ABdhPJwqc/nsfxXFBK2UgZvXBUEQYE8w0KDIJe2tszoXCjURtk+kTG43VFauU+TFsnkjywjUGxQOsg==
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr16818056ejc.69.1633347959389;
        Mon, 04 Oct 2021 04:45:59 -0700 (PDT)
Received: from LABNL-ITC-SW01.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id z5sm7250251edm.82.2021.10.04.04.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 04:45:58 -0700 (PDT)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH 1/1] drivers: net: mhi: fix error path in mhi_net_newlink
Date:   Mon,  4 Oct 2021 13:46:01 +0200
Message-Id: <20211004114601.13870-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix double free_netdev when mhi_prepare_for_transfer fails.

This is a back-port of upstream:
commit 4526fe74c3c509 ("drivers: net: mhi: fix error path in mhi_net_newlink")

Fixes: 13adac032982 ("net: mhi_net: Register wwan_ops for link creation")
Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
Hello Greg,

if maintainers ack, this should go just to 5.14 branch.

Thanks,
Daniele
---
 drivers/net/mhi/net.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index e60e38c1f09d..5e49f7a919b6 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -337,7 +337,7 @@ static int mhi_net_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
 	/* Start MHI channels */
 	err = mhi_prepare_for_transfer(mhi_dev);
 	if (err)
-		goto out_err;
+		return err;
 
 	/* Number of transfer descriptors determines size of the queue */
 	mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
@@ -347,7 +347,7 @@ static int mhi_net_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
 	else
 		err = register_netdev(ndev);
 	if (err)
-		goto out_err;
+		return err;
 
 	if (mhi_netdev->proto) {
 		err = mhi_netdev->proto->init(mhi_netdev);
@@ -359,8 +359,6 @@ static int mhi_net_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
 
 out_err_proto:
 	unregister_netdevice(ndev);
-out_err:
-	free_netdev(ndev);
 	return err;
 }
 
-- 
2.30.2

