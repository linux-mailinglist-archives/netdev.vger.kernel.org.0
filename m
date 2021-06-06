Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD0239CF57
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 15:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhFFNcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 09:32:14 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:46963 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhFFNcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 09:32:13 -0400
Received: by mail-pj1-f46.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso8682335pjb.5;
        Sun, 06 Jun 2021 06:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hYcKAmYrkT12yrCkZCPxBOfTA321ZJWoXkYrMXfOxJ0=;
        b=WQueEqbo2NBlKjvZ6KO/rLFnz5TpCCSTcmQMDcf8qtQHRJyp6tjkvQqjMDDvRWNvg/
         ojY8msMKfjue0x9xNFLV3t9l/kCCZeo4JZAtzeTrJkJn3SFMywdU2rbl7Bd9WakOBlRt
         YAkrkqMw8+KgLDVnCzFAlNQ2pzF9dRv5CMtiVoVq1m4MkFGfG+VbcraT09mYoB0nW95S
         S4POp00X3jRUtpk/R9SiR0aACf9o8cOZZo8DgNZhtn9cFN5sK4dLesBr9cQ176nXSfwd
         miSgxm/3GlEik79UCHguP4u3DWg9W5kiYmjWSfiZLY9AHLffbf2fsBGYawntp6VsMINT
         VOvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hYcKAmYrkT12yrCkZCPxBOfTA321ZJWoXkYrMXfOxJ0=;
        b=Fc+X3mdYqrZusJ5JqQ6vxTRjVjSbrXfZ9vCyDwjXNfyYdCw1GSU3FBZYxqa7AjVYIY
         76z5Hyw6D5qVsVDpO5u/07TVjXw3XQf1z/uEjdmttdn7LpyGY1lfib7eUmXxP9pmhucV
         ETUswCyka919Sm9v17lFixL0qfa9Li5XpQuauHhBOp80Ktx+YLsA1mdE4kTE710ihaX9
         PqhpLvwSvYZ4yDXRITlNjDLD+2v3HnNrbugKXAmnbUmNK+D/LuMZMJh6eIXGJq9jvUOL
         qnVOpZkjQb6fdtmNDvxOv0WfqGNhyk576Es5URPpBfsz31NyLuedLL1mEYneQNU33/Nw
         9CLA==
X-Gm-Message-State: AOAM531Z9HhHOLcRu2UjwWJjJetLN/mOvMpE6mYXI5Jy8d69HC/Bl7DB
        KR5v2hp5fUmjCUmpw7tUpy8=
X-Google-Smtp-Source: ABdhPJyj2di16bPb/HKfLXkHVUGrsIbLZuBW9vI9YNQDT8Dz2RXLca9RdoJpECF8q1i5AX0DFaPRow==
X-Received: by 2002:a17:90b:4504:: with SMTP id iu4mr15678423pjb.110.1622986150087;
        Sun, 06 Jun 2021 06:29:10 -0700 (PDT)
Received: from ndr730u.nd.solarflarecom.com ([182.71.24.30])
        by smtp.googlemail.com with ESMTPSA id bv3sm8252826pjb.1.2021.06.06.06.29.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Jun 2021 06:29:09 -0700 (PDT)
From:   Gautam Dawar <gdawar.xilinx@gmail.com>
Cc:     martinh@xilinx.com, hanand@xilinx.com, gdawar@xilinx.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vhost-vdpa: log warning message if vhost_vdpa_remove gets blocked
Date:   Sun,  6 Jun 2021 18:59:09 +0530
Message-Id: <20210606132909.177640-1-gdawar.xilinx@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gautam Dawar <gdawar@xilinx.com>

If some module invokes vdpa_device_unregister (usually in the module
unload function) when the userspace app (eg. QEMU) which had opened
the vhost-vdpa character device is still running, vhost_vdpa_remove()
function will block indefinitely in call to wait_for_completion().

This causes the vdpa_device_unregister caller to hang and with a
usual side-effect of rmmod command not returning when this call
is in the module_exit function.

This patch converts the wait_for_completion call to its timeout based
counterpart (wait_for_completion_timeout) and also adds a warning
message to alert the user/administrator about this hang situation.

To eventually fix this problem, a mechanism will be required to let
vhost-vdpa module inform the userspace of this situation and
userspace will close the descriptor of vhost-vdpa char device.
This will enable vhost-vdpa to continue with graceful clean-up.

Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index bfa4c6ef554e..572b64d09b06 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1091,7 +1091,11 @@ static void vhost_vdpa_remove(struct vdpa_device *vdpa)
 		opened = atomic_cmpxchg(&v->opened, 0, 1);
 		if (!opened)
 			break;
-		wait_for_completion(&v->completion);
+		wait_for_completion_timeout(&v->completion,
+					    msecs_to_jiffies(1000));
+		dev_warn_ratelimited(&v->dev,
+				     "%s waiting for /dev/%s to be closed\n",
+				     __func__, dev_name(&v->dev));
 	} while (1);
 
 	put_device(&v->dev);
-- 
2.30.1

