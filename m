Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A535646DE77
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 23:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237544AbhLHWlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 17:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236539AbhLHWlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 17:41:18 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8F7C061746;
        Wed,  8 Dec 2021 14:37:45 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id t9so6632128wrx.7;
        Wed, 08 Dec 2021 14:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ltEh61NUR5opsmEls4nl8qwF170eYcG3QnbnvsYmLkc=;
        b=Vv1SnbI3Hnmh/yVAYnhqqnaCYZW/MWbUHZQ574aDiL95EWaS9us80hpNVP57iFaGSm
         331JvFk7M8N0PL1+E3v1P0NRDUsDEWGWqoUttdDvUJtD9zVPm0D6J9juH6yLmNYDVpr2
         Uos/3n84IFMmegHCsQQx3NzhrLTTnhLKoWRGa8IZsGZlA16khSgixXfW5qALU7s0QFjw
         1AIGn69RFK+U1rVSib/xnGAaF7wYj1kj2lwZrUgVwuFnDcWtZF6ulKibSybipdjo8e+w
         qXHC7sYYsd5kV+kFkU9xOrVvLMVRIcBLmGVQCKl4v3vrkIfUxhrJs5iVQB8riA5ejioJ
         QKlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ltEh61NUR5opsmEls4nl8qwF170eYcG3QnbnvsYmLkc=;
        b=u40gJFakYa9mJeM0S0jMhqBHp2ZPryxNZWJWJKA5JIaJAINqhN+aV8PeV7qX03cGbX
         hQiDlX5C3A7dZryscv6/YAmbyvgqA8Mszvt//rudfgShVLtrv0jMwdrKZmjRfQ3ft/Qj
         GzYikPqh6dyWW+hOVVAbg+ylsbWdtinADOtmoULdeH2EUHFfsRCIDYO1ovl9rLOTR8uv
         qOLFm9ytvfubqX0+aevYwCipTfXl8dZDZ85m0fgISBg6oqiZAOdEGEFJo6B+eLWuH5hK
         LSLYbF/fKSn0posNmgE9fO/gJAFZ4EW1XyHaz2Xbljbf5Mmp30dY8qmMdCFPMNVaz9fQ
         1GUw==
X-Gm-Message-State: AOAM530OHhQp6mBnRomNRc9ZpRnd6KXC3Yhb205gFSNnY/KsqHMb6W/R
        guAlA1DcmRH7AicpSSALgio=
X-Google-Smtp-Source: ABdhPJw14QKUmBDLUvt7AbHOxb6KmnlLuia4Ejrt7gieEu7zj7nD8l/9Pf/+40qNSkKWuBwex673fg==
X-Received: by 2002:adf:dc12:: with SMTP id t18mr1808383wri.566.1639003064320;
        Wed, 08 Dec 2021 14:37:44 -0800 (PST)
Received: from localhost.localdomain ([217.113.240.86])
        by smtp.gmail.com with ESMTPSA id n184sm6957308wme.2.2021.12.08.14.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 14:37:43 -0800 (PST)
From:   =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>
To:     kys@microsoft.com
Cc:     haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, davem@davemloft.net, sumit.semwal@linaro.org,
        christian.koenig@amd.com, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>
Subject: [PATCH] net: mana: Fix memory leak in mana_hwc_create_wq
Date:   Wed,  8 Dec 2021 23:37:23 +0100
Message-Id: <20211208223723.18520-1-jose.exposito89@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If allocating the DMA buffer fails, mana_hwc_destroy_wq was called
without previously storing the pointer to the queue.

In order to avoid leaking the pointer to the queue, store it as soon as
it is allocated.

Addresses-Coverity-ID: 1484720 ("Resource leak")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
---
 drivers/net/ethernet/microsoft/mana/hw_channel.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 34b971ff8ef8..078d6a5a0768 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -480,16 +480,16 @@ static int mana_hwc_create_wq(struct hw_channel_context *hwc,
 	if (err)
 		goto out;
 
-	err = mana_hwc_alloc_dma_buf(hwc, q_depth, max_msg_size,
-				     &hwc_wq->msg_buf);
-	if (err)
-		goto out;
-
 	hwc_wq->hwc = hwc;
 	hwc_wq->gdma_wq = queue;
 	hwc_wq->queue_depth = q_depth;
 	hwc_wq->hwc_cq = hwc_cq;
 
+	err = mana_hwc_alloc_dma_buf(hwc, q_depth, max_msg_size,
+				     &hwc_wq->msg_buf);
+	if (err)
+		goto out;
+
 	*hwc_wq_ptr = hwc_wq;
 	return 0;
 out:
-- 
2.25.1

