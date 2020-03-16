Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A61F186556
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 08:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbgCPG7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 02:59:53 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35345 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729723AbgCPG7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 02:59:53 -0400
Received: by mail-pj1-f67.google.com with SMTP id mq3so8121050pjb.0;
        Sun, 15 Mar 2020 23:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eYiMJvzhgU8cefu9p/MQZ5kiTc4aQrMez5IEQVm5JBQ=;
        b=TRfm9/B4gRFAcCC55jE5RaVV0vmnjxrYFvjtTjkrmgerr/XbVypOdOi6wnkZhUIFd7
         JnIjaywX0wnTUsBgsph4ZFny1zoArct+omSuqJYexPFVNNvcaA3PsHiSkvGyJzOaoE5b
         BOtJhvlWEHMpRzz0kBK/6uR2ErJXZ4w4ekkwzQ8yXBT+a7LGnxBIh6HDLuXD7KJdDA8S
         265wqayBZ1aRhMNOerV4XS9rX0pyFAx6nTO0NeyXePiIyIDSxJ+KkapXdq8Ymt7AP9LA
         SE5wPIo8xkdV44XSmr8FqL25QAWUEYf1LxPoizMsBE0OmiATrjbxSC6LT4vTTbNfgHj2
         HJEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eYiMJvzhgU8cefu9p/MQZ5kiTc4aQrMez5IEQVm5JBQ=;
        b=gqkeu/dvJw9l/4F7UUVvVGG4bIGAuiKdfiG4vhZcr0nFkyH9tHYUJwmvNX3e08Pswl
         zROTWLsxwnGznVCQvrrMpu7rLW8shOUnvGS6gUxrXqqgskvaFh3kN4zD0A3Yn8erQ0de
         sPRjGd9vUu/PeatRNlGJuqXVbb9ENN196AY9QSXn3EGUYDDsAjRe+vQ+vWHm9uLP1AXg
         KiWrdxE7y+T6jbI9wSiQVRMlqnt/3nsuOevZETaajjlouKJ7YPVv2LprAozte0alP8tS
         Z4m7wIBTmMnISQAuRA+Aj7qD6xyxcFDzIMvL5rkrvUfxRf4L9W2Ea2BD7leMAKMQagQ+
         UstQ==
X-Gm-Message-State: ANhLgQ1oMuq05ATPB4frcDln2AYYhmxgp9r5LlYoIFnYQFX+gC6+felN
        zbHgbNQAmyMrymAEGb/QuBA=
X-Google-Smtp-Source: ADFU+vs4k0yrj7Ym3y5Tl5ybhCCG7hiX4pdR2mu8G0rZbALQoIBX9Pplw0st5yHEoVLU+nrrBSb4wA==
X-Received: by 2002:a17:902:421:: with SMTP id 30mr3282708ple.271.1584341992275;
        Sun, 15 Mar 2020 23:59:52 -0700 (PDT)
Received: from VM_0_35_centos.localdomain ([150.109.62.251])
        by smtp.gmail.com with ESMTPSA id x70sm54634841pgd.37.2020.03.15.23.59.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Mar 2020 23:59:51 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH] drm/lease: fix potential race in fill_object_idr
Date:   Mon, 16 Mar 2020 14:59:43 +0800
Message-Id: <1584341983-11245-1-git-send-email-hqjagain@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should hold idr_mutex for idr_alloc.

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 drivers/gpu/drm/drm_lease.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_lease.c b/drivers/gpu/drm/drm_lease.c
index b481caf..427ee21 100644
--- a/drivers/gpu/drm/drm_lease.c
+++ b/drivers/gpu/drm/drm_lease.c
@@ -418,6 +418,7 @@ static int fill_object_idr(struct drm_device *dev,
 		goto out_free_objects;
 	}
 
+	mutex_lock(&dev->mode_config.idr_mutex);
 	/* add their IDs to the lease request - taking into account
 	   universal planes */
 	for (o = 0; o < object_count; o++) {
@@ -437,7 +438,7 @@ static int fill_object_idr(struct drm_device *dev,
 		if (ret < 0) {
 			DRM_DEBUG_LEASE("Object %d cannot be inserted into leases (%d)\n",
 					object_id, ret);
-			goto out_free_objects;
+			goto out_unlock;
 		}
 		if (obj->type == DRM_MODE_OBJECT_CRTC && !universal_planes) {
 			struct drm_crtc *crtc = obj_to_crtc(obj);
@@ -445,20 +446,22 @@ static int fill_object_idr(struct drm_device *dev,
 			if (ret < 0) {
 				DRM_DEBUG_LEASE("Object primary plane %d cannot be inserted into leases (%d)\n",
 						object_id, ret);
-				goto out_free_objects;
+				goto out_unlock;
 			}
 			if (crtc->cursor) {
 				ret = idr_alloc(leases, &drm_lease_idr_object, crtc->cursor->base.id, crtc->cursor->base.id + 1, GFP_KERNEL);
 				if (ret < 0) {
 					DRM_DEBUG_LEASE("Object cursor plane %d cannot be inserted into leases (%d)\n",
 							object_id, ret);
-					goto out_free_objects;
+					goto out_unlock;
 				}
 			}
 		}
 	}
 
 	ret = 0;
+out_unlock:
+	mutex_unlock(&dev->mode_config.idr_mutex);
 out_free_objects:
 	for (o = 0; o < object_count; o++) {
 		if (objects[o])
-- 
1.8.3.1

