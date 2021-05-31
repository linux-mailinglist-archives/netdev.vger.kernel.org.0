Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F4B3966C6
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 19:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhEaRV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 13:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbhEaRUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 13:20:40 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40996C0431FC;
        Mon, 31 May 2021 08:34:35 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso195798pji.0;
        Mon, 31 May 2021 08:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YIxlSk91TuUABFkgr/k5Yi3OXLq37Uwi7gnEsi3Btt4=;
        b=qA1l1Pe1DWi2hEyakId/vhm80G9PN4zkftLWig/60q0ofmynv4I1G8aZ4XXV8vQXbj
         WVB3kXNm6E9OQqjJHiGyxRZ4c1O7V6o3ncjQi0a93RiGYfFi0E8e13d2PiXvRRCrvXeo
         PxyrN926RykD739bnPk8dOe43GPF0cRbDyF+0JY/9LeFfP/QNriKZ1VCACRAz+ZLWGpS
         ebwNvVgr1Hm4u180TAnKmKaDiv3MKIAflhjnlBVeS/Jox/Qzzz1CtYBWk8lY9KeIvlCw
         079N4B+ZGg1KzzZQBPpXNkkBwkWpqlhD5eooQ/TctDSzGJQMcJDEIgewQN8d9v1Dn0Uy
         qJOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YIxlSk91TuUABFkgr/k5Yi3OXLq37Uwi7gnEsi3Btt4=;
        b=MEo2pALqI07o9n8WYQfD+2n6uBfxVJm7eeVVMDauOC8qev/JLSXYqDMmw15PBYbP4A
         /FhYvxf4aielTZwkGzHl/q8FOPWaJXFs9FQt6kT1q5HaZa8nhAErrFuGCGcyvNd5kKqK
         speVMhhtVcpVU+NKuOP7dgxAPyoEVBg8S+epmjDig1njCXz/vUoMe2c+ZpnZ0P5RfUcL
         WGU2inTeT9ZrRH3gbfKswOUce+0KezyAuaPByNtJBOEOGaLU5X/h27QZgM4mTiOl13qC
         M4hKMjHyUV6IgYz6tfvWq3w7U56QmmNqWtvvN8OEcqorkXb3Ed5XGeUcEQ3TL4idGqh1
         xlYQ==
X-Gm-Message-State: AOAM5307BxTkcIe/IAMqMYxsqHAI2TKIZnaoOuQTXKe/qqbjV8MLODr5
        TTrBuL+9QJQ3BpjA1g68Inh3XGZ5ylqw9Q==
X-Google-Smtp-Source: ABdhPJxBeDoQ03UvPdZrXyEDANCwqA6KpN9Fw8xlBY8PZqLQZjNg5gycu4uQgC25e5/u1f8AccrWlg==
X-Received: by 2002:a17:90a:aa12:: with SMTP id k18mr19852008pjq.232.1622475274796;
        Mon, 31 May 2021 08:34:34 -0700 (PDT)
Received: from WRT-WX9.. ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id q91sm4369382pja.50.2021.05.31.08.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 08:34:34 -0700 (PDT)
From:   Changbin Du <changbin.du@gmail.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kici nski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Changbin Du <changbin.du@gmail.com>, stable@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>
Subject: [PATCH] nsfs: fix oops when ns->ops is not provided
Date:   Mon, 31 May 2021 23:34:10 +0800
Message-Id: <20210531153410.93150-1-changbin.du@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should not create inode for disabled namespace. A disabled namespace
sets its ns->ops to NULL. Kernel could panic if we try to create a inode
for such namespace.

Here is an example oops in socket ioctl cmd SIOCGSKNS when NET_NS is
disabled. Kernel panicked wherever nsfs trys to access ns->ops since the
proc_ns_operations is not implemented in this case.

[7.670023] Unable to handle kernel NULL pointer dereference at virtual address 00000010
[7.670268] pgd = 32b54000
[7.670544] [00000010] *pgd=00000000
[7.671861] Internal error: Oops: 5 [#1] SMP ARM
[7.672315] Modules linked in:
[7.672918] CPU: 0 PID: 1 Comm: systemd Not tainted 5.13.0-rc3-00375-g6799d4f2da49 #16
[7.673309] Hardware name: Generic DT based system
[7.673642] PC is at nsfs_evict+0x24/0x30
[7.674486] LR is at clear_inode+0x20/0x9c

So let's reject such request for disabled namespace.

Signed-off-by: Changbin Du <changbin.du@gmail.com>
Cc: <stable@vger.kernel.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David Laight <David.Laight@ACULAB.COM>
---
 fs/nsfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 800c1d0eb0d0..6c055eb7757b 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -62,6 +62,10 @@ static int __ns_get_path(struct path *path, struct ns_common *ns)
 	struct inode *inode;
 	unsigned long d;
 
+	/* In case the namespace is not actually enabled. */
+	if (!ns->ops)
+		return -EOPNOTSUPP;
+
 	rcu_read_lock();
 	d = atomic_long_read(&ns->stashed);
 	if (!d)
-- 
2.30.2

