Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF3D1E6E1
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 04:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfEOCnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 22:43:05 -0400
Received: from mail-oi1-f201.google.com ([209.85.167.201]:56104 "EHLO
        mail-oi1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfEOCnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 22:43:04 -0400
Received: by mail-oi1-f201.google.com with SMTP id c64so476516oia.22
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 19:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ob+vLKe5H33XUJM8d7V/kjmCLjNr0p4vL/5e6MImH/w=;
        b=ibA0pVzavinrgwyhoetnJLbMGWhQGzkIBDAflhQhDVZyAts/b7h6wTJt/WQHrOb2wo
         ER7MkgSbQGiJtT2s2ppQOYUEwfqGyAaTC8oWJJ/A/gDiWTq7OTEgsw8LptdcSVHDIvKi
         U2wOdcKjiMcUlc80040Cw+ylbzioOdgPRJTqWev8chIwqO1at/Nf+y0HxC7Jvoxd6QrJ
         Nl/Qh5uSVRfJYDZnH4NGDh87AUElv4UU7VVeX39CdmRDfQqFGGlEccaEAldShwawvXNM
         CIsIcOUj7+H16tGt9qqFRIezCx1IHWqKA7Afzn61Bi0bWczBk7wjjykxnfwXiORWDr0D
         FtJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ob+vLKe5H33XUJM8d7V/kjmCLjNr0p4vL/5e6MImH/w=;
        b=aR/IIsHyw9AlRp3YqdBWHYRxHgMJjco1oVm1u3zc/Pmx5b0dimb1tlxaa8AhJQV0Zc
         TBFKgK3CJJslgyNQ+fzAnQJffbSK2bgqp1oFXFKqpA3n69vpBEJtJEhIlSqd/5pVOZy/
         I0qCudHFNlN8dRKLOooR17YBOR+PpYzAE/MkXPdYU0NbCjIe6Btnou/x9DIfXHR6SW9u
         0P84Bkc3N8wBYevYsfJSiJwEHCJ3F5o6ym7leLvSt2FN7SuwCfmQIoB/dbUuU20GyfXX
         gtbPR4D9D8N2jW6+K2EiugGfPHcioWuUmiUmfUw1hQlYQRcrvgI74MdznAfS3NOR2gGI
         6C6A==
X-Gm-Message-State: APjAAAUcLYkHMQoHvu9XOQ7ZlRPCu7Fh5sXQ3SrfN4ZmdkBUNNv96C7E
        yPQgMSuf78ZbrxaazSn+ecO2VvMvHZ0DfTrX2IKqMXC7uCf1rR8F/gHcRk3JxHmyT0P9xH/J9Cj
        ngTjSABHeoXhOyNrg8LmgniW/CIAtnvSkECKNYa+ixxztE2NUVt8FYuSgJlc=
X-Google-Smtp-Source: APXvYqzwcp2cARwy84vq7TlAF4AH5oSd4dC6bHG9O7qCoEkwyd0Z5qa8nuj0I5P6u62sq7mvTdJaCjDqDw==
X-Received: by 2002:aca:fccf:: with SMTP id a198mr643792oii.69.1557888183969;
 Tue, 14 May 2019 19:43:03 -0700 (PDT)
Date:   Tue, 14 May 2019 19:42:57 -0700
Message-Id: <20190515024257.36838-1-fengc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH bpf] bpf: relax inode permission check for retrieving bpf program
From:   Chenbo Feng <fengc@google.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@android.com, lorenzo@google.com, maze@google.com,
        daniel@iogearbox.net, ast@kernel.org,
        Chenbo Feng <fengc@google.com>
Content-Type: text/plain; charset="utf-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For iptable module to load a bpf program from a pinned location, it
only retrieve a loaded program and cannot change the program content so
requiring a write permission for it might not be necessary.
Also when adding or removing an unrelated iptable rule, it might need to
flush and reload the xt_bpf related rules as well and triggers the inode
permission check. It might be better to remove the write premission
check for the inode so we won't need to grant write access to all the
processes that flush and restore iptables rules.

Signed-off-by: Chenbo Feng <fengc@google.com>
---
 kernel/bpf/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index bc53e5b20ddc..84a80b02db99 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -518,7 +518,7 @@ int bpf_obj_get_user(const char __user *pathname, int flags)
 static struct bpf_prog *__get_prog_inode(struct inode *inode, enum bpf_prog_type type)
 {
 	struct bpf_prog *prog;
-	int ret = inode_permission(inode, MAY_READ | MAY_WRITE);
+	int ret = inode_permission(inode, MAY_READ);
 	if (ret)
 		return ERR_PTR(ret);
 
-- 
2.21.0.1020.gf2820cf01a-goog

