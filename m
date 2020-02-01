Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2B214F8FF
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 17:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgBAQn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 11:43:29 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37257 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbgBAQn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 11:43:29 -0500
Received: by mail-pg1-f194.google.com with SMTP id q127so5317525pga.4
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 08:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KWQ6U7y+NNNCv/NEUC9blB6SvFonN8ksMD1WD7eHwm0=;
        b=ScZRWRT9wpQRE6Ir1wr75Pvpc0YDdBG5YRJCcdyjoHFT0WJIkasX45bBnaB4ZpHud0
         Foze1SgYYGN3lt0TrwNjPP5RFffsp47ClUzTvhP1iprSNj2WmvGBZm0wwQQHjetxQ6/O
         tRqgwfQ1Y0IyFT7Tq2X0z4LFTAe6g9DCF40U6/wdkHJ1OIOWyDHkk4aoVbGqhGsPvlY2
         NFgzx8W5pNqwnfiiwKFei4m3XeROgcyHwQ/dPdLiCv09mn0RDOxB1D4mpiPGhAxXMG+p
         fjwkbpN+Zy/JR/STqkFLPIZufCHW/FKUX8c7ZfaSoToAKwjsNtZThwOuaYFAvEpjPLKS
         KZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KWQ6U7y+NNNCv/NEUC9blB6SvFonN8ksMD1WD7eHwm0=;
        b=FiutZ1QdqSrGx5cKQZ+WEoTKTS5/9pDx8gfG+/mdxJVgehswSpNvCZQfkCe8ggtydf
         bIKP3OAzVpe0/im0L32BJhU8C61WZas/Rl7kq2NM3MlBAO1c4FqJm2JFgRZ73EE22zYA
         HpGRQPHzDFgg7evXWPt2lfKUqqATffPhOhOv1N+zmkGMubmftBe/e3WsPG2Czr5JPpBh
         X7Vn9cXBp7lAkyRI0fPrCaLaCPqkbYGEE/P6Bj0iP/dK0mA6w7zgsAZfki5gwwKmJXI+
         k5Lki1TbFMxBXgS6iaSW2IVmXfsa2kZ2QQ4YEaAWeaGOi7hjTAzFjwmiL4qthK61UZ0D
         fzOw==
X-Gm-Message-State: APjAAAWq3Fm3PlzW+7uvVo7A3mCTptAO2clcJgZWVHnb5tBVNdr8OD4W
        JJs2W6QYlSAZVFP3bzl0R/0=
X-Google-Smtp-Source: APXvYqzJ2+I2hlCeycNN/YxNCGxhlCXkO0hQPM/0GE3Jhxb+FOq1sIe8mtsPAO2M3GsXTFUcNEVYUw==
X-Received: by 2002:a63:fa50:: with SMTP id g16mr16052265pgk.202.1580575408268;
        Sat, 01 Feb 2020 08:43:28 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f9sm14304383pfd.141.2020.02.01.08.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 08:43:27 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v3 4/7] netdevsim: fix stack-out-of-bounds in nsim_dev_debugfs_init()
Date:   Sat,  1 Feb 2020 16:43:22 +0000
Message-Id: <20200201164322.10080-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When netdevsim dev is being created, a debugfs directory is created.
The variable "dev_ddir_name" is 16bytes device name pointer and device
name is "netdevsim<dev id>".
The maximum dev id length is 10.
So, 16bytes for device name isn't enough.

Test commands:
    modprobe netdevsim
    echo "1000000000 0" > /sys/bus/netdevsim/new_device

Splat looks like:
[  249.622710][  T900] BUG: KASAN: stack-out-of-bounds in number+0x824/0x880
[  249.623658][  T900] Write of size 1 at addr ffff88804c527988 by task bash/900
[  249.624521][  T900]
[  249.624830][  T900] CPU: 1 PID: 900 Comm: bash Not tainted 5.5.0+ #322
[  249.625691][  T900] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  249.626712][  T900] Call Trace:
[  249.627103][  T900]  dump_stack+0x96/0xdb
[  249.627639][  T900]  ? number+0x824/0x880
[  249.628173][  T900]  print_address_description.constprop.5+0x1be/0x360
[  249.629022][  T900]  ? number+0x824/0x880
[  249.629569][  T900]  ? number+0x824/0x880
[  249.630105][  T900]  __kasan_report+0x12a/0x170
[  249.630717][  T900]  ? number+0x824/0x880
[  249.631201][  T900]  kasan_report+0xe/0x20
[  249.631723][  T900]  number+0x824/0x880
[  249.632235][  T900]  ? put_dec+0xa0/0xa0
[  249.632716][  T900]  ? rcu_read_lock_sched_held+0x90/0xc0
[  249.633392][  T900]  vsnprintf+0x63c/0x10b0
[  249.633983][  T900]  ? pointer+0x5b0/0x5b0
[  249.634543][  T900]  ? mark_lock+0x11d/0xc40
[  249.635200][  T900]  sprintf+0x9b/0xd0
[  249.635750][  T900]  ? scnprintf+0xe0/0xe0
[  249.636370][  T900]  nsim_dev_probe+0x63c/0xbf0 [netdevsim]
[ ... ]

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Fixes: ab1d0cc004d7 ("netdevsim: change debugfs tree topology")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2 -> v3:
 - Include Reviewed-by tag

v1 -> v2:
 - Update Fixes tag
 - Do not use arbitary 32 bytes for dev_ddir_name

 drivers/net/netdevsim/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 06b178be3017..273a24245d0b 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -73,7 +73,7 @@ static const struct file_operations nsim_dev_take_snapshot_fops = {
 
 static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 {
-	char dev_ddir_name[16];
+	char dev_ddir_name[sizeof(DRV_NAME) + 10];
 
 	sprintf(dev_ddir_name, DRV_NAME "%u", nsim_dev->nsim_bus_dev->dev.id);
 	nsim_dev->ddir = debugfs_create_dir(dev_ddir_name, nsim_dev_ddir);
-- 
2.17.1

