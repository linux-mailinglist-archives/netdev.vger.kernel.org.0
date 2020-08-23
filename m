Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE1724EC26
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 10:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgHWIVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 04:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgHWIVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 04:21:22 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11815C061573;
        Sun, 23 Aug 2020 01:21:22 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k13so2763939plk.13;
        Sun, 23 Aug 2020 01:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HorE3eSfXz4Gki6guH9XnAbsktXH9J/H5OfUk+fj9ww=;
        b=D9m4vGhhadKVAw7CoQBmjIajZLQNNltNmMM6DDOZqZzdNZoB0yI7WVyi0OXKbppRBo
         2U6LWFugxmTinh1FdA5xCI9UPTEb9d5izBpr47nrZeXk5PgTPWzD7GVYmrsS4okAgG4d
         /dGRUHaoNgNWVzGj0k+3JwnRb+sMi9+b78mT5Rh9y9GVFmnunZAOv928a2ikFBa88CF9
         QlxypZvyFajyAPumyDoidP5LkXzxA7T4cLZYDxKZAaIvvfqypORK8sQyKokiJl9OjmAK
         M677vY1Y6yT/u5grPENUNzXZzL3/Chz0JtqmqZT0FnemSOrSxRGGdqWar6C1MKnybOul
         cR2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HorE3eSfXz4Gki6guH9XnAbsktXH9J/H5OfUk+fj9ww=;
        b=ZQ+8omlOopra+WHH99c1tnrdR1/l0REq6Cb4j1De16v0vaTmatLMnjC3l0nLXRhYpT
         o7/LPGhpcSqUszuYuheZ/TDiY+r9fki3vU4QL5NOeTSDmgRBOCs3RKeDgu070FAtEpPs
         fjf1B4TCmK66qyZZF+80Tz7iTlhAZhT+hQWhwpVH1h5Dng7y8f/TMTE86I575q/8KSLs
         /sjGCDjNq0Aqs+CtOwrU+pbTfH1GzPYFRz/0rGKEo98kYa9ny8pq/8z2++K0LYf/ZVVH
         DLy5Vk/dB5xiM+AEyixtg8QkvC4wWJtdziQeF2PyFngOnDAwNmYWb/0O75A+Fpf0Fpuu
         8KVQ==
X-Gm-Message-State: AOAM5323Sasrog3SG1e95lRMSegTP7SLgnJ2C6/u5TWQK2R+3jz3OLkO
        /jUGXjrpM7kW2TklNqkCFZQ=
X-Google-Smtp-Source: ABdhPJxLf+kXTEY8tY4f4/a5bUzfIcFh3YpQnFiHe2KQmR1ZuODc+Zff+j2Fm43ZKu7SfHriVcLBSw==
X-Received: by 2002:a17:90a:a791:: with SMTP id f17mr412787pjq.136.1598170881504;
        Sun, 23 Aug 2020 01:21:21 -0700 (PDT)
Received: from localhost.localdomain ([157.32.237.182])
        by smtp.gmail.com with ESMTPSA id q17sm7416783pfh.32.2020.08.23.01.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 01:21:20 -0700 (PDT)
From:   Himadri Pandya <himadrispandya@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Himadri Pandya <himadrispandya@gmail.com>
Subject: [PATCH] net: usb: Fix uninit-was-stored issue in asix_read_cmd()
Date:   Sun, 23 Aug 2020 13:50:42 +0530
Message-Id: <20200823082042.20816-1-himadrispandya@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize the buffer before passing it to usb_read_cmd() function(s) to
fix the uninit-was-stored issue in asix_read_cmd().

Fixes: KMSAN: kernel-infoleak in raw_ioctl
Reported by: syzbot+a7e220df5a81d1ab400e@syzkaller.appspotmail.com

Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
---
 drivers/net/usb/asix_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index e39f41efda3e..a67ea1971b78 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -17,6 +17,8 @@ int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 
 	BUG_ON(!dev);
 
+	memset(data, 0, size);
+
 	if (!in_pm)
 		fn = usbnet_read_cmd;
 	else
-- 
2.17.1

