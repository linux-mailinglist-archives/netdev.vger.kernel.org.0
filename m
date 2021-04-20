Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D9F365FF0
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 21:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhDTTBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 15:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233624AbhDTTBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 15:01:17 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4580DC06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 12:00:45 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id n127so9035264wmb.5
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 12:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=JAvXww5KpPllCzIfU9TOhaX3UQasePrevleotlPtQ6g=;
        b=ruJhKboeBg2f03bDwwN0vJBvcFBmmu2w59bdryD2vsmfptH6UCjuQmLpVGsiyrVeSh
         CFET9LChxniLW5JiQ9M1idMINVQniuWtyI3I4NEvA99Qq+lX+SX6wbq3kptj6DSPVb4k
         +w6ujtAEPZkakJAK69pmu7kILsjncgMF+mjCYCt1dhRFygPUTgHdPexCmA8XGbILD59A
         1Lsl3rgNvA61f5r5UtrfZYMYtKHg9FPSh2Z2mxDEIDoL7T+NKu7o1Gv1cX4DguV7tTsz
         Tu2T1vFoVl9yMiORGQzi/7+i7U1CdXPtpSEn2zkryUbJO0mdhZO9KV10aGsuW8oPAGmb
         XBEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JAvXww5KpPllCzIfU9TOhaX3UQasePrevleotlPtQ6g=;
        b=clQORlM67epxs3IRGcQcFptRvd1ntSB6o/UwCvvTk/J+Tsy8bk+0DGHSk1JaS0t/Da
         hnX8iQDFAUHY8FaCtipwqB4pl351+SecO3vuRFFDPuPwDwZYuZUDIOEnEAW1rmU1B1BO
         kyCGiQ5AMHkeERC4v47si1EqgKmNIKUs5nmfsblybx5jzZAMuMKMTRS7ZjBLhjgB0lkw
         /WMyZ/gtKBsNv4UqMr4YIyLc3lQTr5knvCzvHXzfm9k+l9IOI7WSgiFJ4kviTFAn9qQk
         qtVi5u09ZN0MBZIRE9mhjwDTUoTxmmtUZz86UU7Vc1AfeEux6AYgk/reYCzatN2dtE+N
         E3zQ==
X-Gm-Message-State: AOAM532oUVrG4qA/fl3oMnSAD0zydzlLb20lOfOx1gCUMsbfH/v+M1wB
        qS/8cVV/XUEjQM3pOGIQjJi86w==
X-Google-Smtp-Source: ABdhPJxBW9i1SYzET+kKO3ABZj+zmDFwK4cFDK8y4+BuWt/vDXS2al2U2+VCcyGOABY6AilKQR0e5Q==
X-Received: by 2002:a1c:e006:: with SMTP id x6mr5962928wmg.40.1618945243918;
        Tue, 20 Apr 2021 12:00:43 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:c0c4:7b2:36d2:4bec])
        by smtp.gmail.com with ESMTPSA id h5sm3942491wmq.23.2021.04.20.12.00.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Apr 2021 12:00:43 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next] net: wwan: Fix bit ops double shift
Date:   Tue, 20 Apr 2021 21:09:57 +0200
Message-Id: <1618945797-11091-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bit operation helpers such as test_bit, clear_bit, etc take bit
position as parameter and not value. Current usage causes double
shift => BIT(BIT(0)). Fix that in wwan_core and mhi_wwan_ctrl.

Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wwan/mhi_wwan_ctrl.c | 8 +++++---
 drivers/net/wwan/wwan_core.c     | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
index 1fc2376..1bc6b69 100644
--- a/drivers/net/wwan/mhi_wwan_ctrl.c
+++ b/drivers/net/wwan/mhi_wwan_ctrl.c
@@ -7,9 +7,11 @@
 #include <linux/wwan.h>
 
 /* MHI wwan flags */
-#define MHI_WWAN_DL_CAP		BIT(0)
-#define MHI_WWAN_UL_CAP		BIT(1)
-#define MHI_WWAN_RX_REFILL	BIT(2)
+enum mhi_wwan_flags {
+	MHI_WWAN_DL_CAP,
+	MHI_WWAN_UL_CAP,
+	MHI_WWAN_RX_REFILL,
+};
 
 #define MHI_WWAN_MAX_MTU	0x8000
 
diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index b618b79..5be5e1e 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -26,7 +26,7 @@ static int wwan_major;
 #define to_wwan_port(d) container_of(d, struct wwan_port, dev)
 
 /* WWAN port flags */
-#define WWAN_PORT_TX_OFF	BIT(0)
+#define WWAN_PORT_TX_OFF	0
 
 /**
  * struct wwan_device - The structure that defines a WWAN device
-- 
2.7.4

