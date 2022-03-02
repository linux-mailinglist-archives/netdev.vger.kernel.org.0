Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268994C9EAB
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 08:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239945AbiCBHzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 02:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239939AbiCBHzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 02:55:10 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7425FF0D
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 23:54:28 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id o18-20020a05600c4fd200b003826701f847so2091832wmq.4
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 23:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c6ICxqVOSDwYzpmIgcIPvPKtPkRYYwDZ/CKEoQLZ0fM=;
        b=NLNs1JvRIKsLEPITfEpZjQaSA9a9V1Ue2S2zsgYeosZEvHK82+MU7cO3poSVeWiINz
         RcXv1iu4ahiLT/HU9X5BxwYq69RLB7MIaPwxl/7Jp3dTzJpsJ9SocZ6U2FlmPrY7RzOT
         dwi6GJAHOyB6XrRA7JGIBGWCrVv1BuzTruyWN4iCqDfmmaGIJpqb2BXlIyDuNhfrQ8cu
         yhPguc027tZ0SYDzTZC6aiP6j+tf9y3a7gYPFKo6Hf9x8uMOqQyrqqpXVmZzmiO0PsUx
         +NTeyRbXEsVufHRGrLBe64pcia/ospSlkb38q+7rjlmozPgLAwTE4CI4EZZcL5nSQ7sx
         0Rhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c6ICxqVOSDwYzpmIgcIPvPKtPkRYYwDZ/CKEoQLZ0fM=;
        b=WhKWKxVfmkc6HeKlhfaT9j/Kzmwqf3AqqKzo/mHkQHNHHgZQhjEdlBsxsGszdkRm44
         RpD+tblz2wl+12bcqwtLJQhCOZBEGxZIevz/C4eGe8wgvabTa4V2INIpPISCvN4yDWVE
         7XC744sBBCfDJjl/YfHpeW8SD1QZl1F88ZUb0ZcpAGmuHnWdHX/MoyDFgfUomIZUwKhc
         TqhzxkNmH38zgdweyIEKE69/6s2iCxRzfDQPRs+zLzHIclvkGU2wUhgYxC6bipuJYzPP
         IOV6TqMbtxhQK57/aHbjs2mqEZcXmvA/KT77lL4A4tWdqhmP/aVr0VqC30Yb0Ymg2WwW
         L5RQ==
X-Gm-Message-State: AOAM531mmYsBINUEnOnvXjCkpmuXOqSKl7onbON1c+LkiP72v3CsWaQF
        vM9DlLaE2L3T9HYe14jDnPFevA==
X-Google-Smtp-Source: ABdhPJzeg9BJNdGu68uugP5ZRd/ZsHrKT5Kky4Ce44uKg6fonCFHYVnL94JIefllJ03DLHGf6n3diA==
X-Received: by 2002:a7b:c091:0:b0:381:8179:a7b with SMTP id r17-20020a7bc091000000b0038181790a7bmr6341366wmh.195.1646207666772;
        Tue, 01 Mar 2022 23:54:26 -0800 (PST)
Received: from joneslee.c.googlers.com.com (205.215.190.35.bc.googleusercontent.com. [35.190.215.205])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc84e000000b0038100c9a593sm6906498wml.45.2022.03.01.23.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 23:54:26 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, mst@redhat.com, jasowang@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: [PATCH 1/1] vhost: Protect the virtqueue from being cleared whilst still in use
Date:   Wed,  2 Mar 2022 07:54:21 +0000
Message-Id: <20220302075421.2131221-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vhost_vsock_handle_tx_kick() already holds the mutex during its call
to vhost_get_vq_desc().  All we have to do is take the same lock
during virtqueue clean-up and we mitigate the reported issues.

Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/vhost/vhost.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 59edb5a1ffe28..bbaff6a5e21b8 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -693,6 +693,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 	int i;
 
 	for (i = 0; i < dev->nvqs; ++i) {
+		mutex_lock(&dev->vqs[i]->mutex);
 		if (dev->vqs[i]->error_ctx)
 			eventfd_ctx_put(dev->vqs[i]->error_ctx);
 		if (dev->vqs[i]->kick)
@@ -700,6 +701,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 		if (dev->vqs[i]->call_ctx.ctx)
 			eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
 		vhost_vq_reset(dev, dev->vqs[i]);
+		mutex_unlock(&dev->vqs[i]->mutex);
 	}
 	vhost_dev_free_iovecs(dev);
 	if (dev->log_ctx)
-- 
2.35.1.574.g5d30c73bfb-goog

