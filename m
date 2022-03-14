Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AF24D7DB8
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 09:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237490AbiCNIoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 04:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236675AbiCNIoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 04:44:18 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066C411C27
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 01:43:08 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id q20so8842130wmq.1
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 01:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h8sJyHrz9MSFv6aQ5rNLhY6H2EgY9rxFKZSrrjXt/DA=;
        b=SFQws5dWS5IMGrfAnDPxae+Am8l7I6/hNpKN2OmjbEYBGOqYImlF1vqLR1AWOKjxuz
         Y3SmnYVN3rl4rC4EoSP+NPG+5KWZz++GAzeOoGAbPT/KVHXn4ANsb5wfn5v3kGdtF/ZJ
         64EyjWFnJczi6FbxWHPRo3MnjGRwix9kCikrysBaeN1/ylzG2nUNblB3tW3v/OKTS6xt
         gCceRq2GOmUuCVyDsRt62GwnhO3ZZLyEg6TLLo0DIi2fWEIRL1kSiGcyV/KP1hV5Ur/m
         w9PIORH6GoAPa2fq9IRxdWhZhrnbnpECthh2qm72hq+KeXISV48tviEmpezl7l3KW+gs
         s/OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h8sJyHrz9MSFv6aQ5rNLhY6H2EgY9rxFKZSrrjXt/DA=;
        b=Xm7Xv3HxAE3LZ/9zvXZtVwbCr4Cei+D1NSkjidhX2301A8Qn0c5pzxkl025hWwOiqH
         cJkGQ4Ie7HtbapTKaMp/pglAT7q7ml2MPrwXludteI5XLiZUobNkgWC69hKW6KjRQ/za
         iayomI3vpyFrucLHqFso46efa2MV4SoZF8c0B+BG4H8btPBhD/W4pPOMwIdy4zS8mAEg
         Ihqv3Y8zjw8Rk257bYqXMUyfBwqbXHPODcjMKyQsbVMYmiXFPRMlCk58JRj48Lw+qPPs
         1Fww2pY74SmLiI6s+S+gp6ojeeVupE/OLHiJL0gOexGxr+N6LUJAMAofA2UJOzQz/U1e
         4cbw==
X-Gm-Message-State: AOAM532hKN3cFneLg6yX9HnOvXukyBvVEYr3QxxSwRoPBp2/QaLMOG6i
        prMtZ13Nd+ISWgKpq4QeYdedpw==
X-Google-Smtp-Source: ABdhPJzc9uprjBGpnv4mgjX60WyBxgufdLW4uQZcYLKXmRnyMUHGBSCkV5UyRJf8/ADueYqZriWJIQ==
X-Received: by 2002:a05:600c:4249:b0:385:a7bc:b37 with SMTP id r9-20020a05600c424900b00385a7bc0b37mr24170451wmm.185.1647247386565;
        Mon, 14 Mar 2022 01:43:06 -0700 (PDT)
Received: from joneslee.c.googlers.com.com (205.215.190.35.bc.googleusercontent.com. [35.190.215.205])
        by smtp.gmail.com with ESMTPSA id v14-20020adfd18e000000b0020373e5319asm13416678wrc.103.2022.03.14.01.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 01:43:06 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, mst@redhat.com, jasowang@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/1] vhost: Protect the virtqueue from being cleared whilst still in use
Date:   Mon, 14 Mar 2022 08:43:02 +0000
Message-Id: <20220314084302.2933167-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vhost_vsock_handle_tx_kick() already holds the mutex during its call
to vhost_get_vq_desc().  All we have to do here is take the same lock
during virtqueue clean-up and we mitigate the reported issues.

Also WARN() as a precautionary measure.  The purpose of this is to
capture possible future race conditions which may pop up over time.

Cc: <stable@vger.kernel.org>
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
2.35.1.723.g4982287a31-goog

