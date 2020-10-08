Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DB4287823
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731369AbgJHPwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729982AbgJHPwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:52:40 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B85C061755;
        Thu,  8 Oct 2020 08:52:40 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k8so4343048pfk.2;
        Thu, 08 Oct 2020 08:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R5JUG43ZrxWmAgwHEyoGhWX+Ovce6LVlcxgpntyv0KM=;
        b=Mr2/0e5j11+f3fA5RfHkdOijEjaT6BztMBWXIYayGBS9BjF71orGHkAvhjoDnye0p+
         aF1oTAVHUCF6A7ujrp93D0UPZQRPP8GeompMf1C9rQNiAsFY1NKfEfdgfA9DO8P9EAPc
         jVgt02zR/ii/ZuBCWi01holtRUpsl5hljHT5pIbYsW5nc52ssYZ5iZisdMu/EScrV2Vq
         5cXl50+YwlxdnlZoEJ/EMug6UjofVQA36xXXsouNO6Y/2fi6aK6RZnQr01iinxYr3axd
         ipOGPdCu7juGVCECsdXFw5GHZY1ZyfevRKeY+lGletTNNGubSaX4cdxidcps+d89FOgh
         fdaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R5JUG43ZrxWmAgwHEyoGhWX+Ovce6LVlcxgpntyv0KM=;
        b=kOhDP82UIuK0qm6MZK8HRkz8CI0BHvC/PH11jXaX0Fu7NQVniH45FJtEGLpyAalwSf
         sEnvZY/1r1+kaK0BV015jdl87P31LKHqfRiiltg1tFIsQyn/bw9fHJFyY0kIggz/1XkN
         NHVB0K8MJ0qRNp0K+7HEYFR+uT5V4O/QDKPZWhcq6eCWo4bcgGw2XP06qNfnBlYco4CD
         4sFqx6faXjDba9Ko5GSzbBw2zd5n1UQA0VyFUtcZ5aRY8MJsugoebR0/eyTpGvQJrXxQ
         j2AXtNNagWTgH+8yyer5eOOlKQOWxiuJjAEEO3FWzD1zYg9NTFRxbdPqWgXiTQ+jmKhZ
         wucA==
X-Gm-Message-State: AOAM530hXbwTxo5pX2mMVG2mv8TALc9kMpp1m+zyjKBR4DCp6XXNXx62
        V2qpvpOiogOFPZMyEwXnjyk=
X-Google-Smtp-Source: ABdhPJxVsfmZ1e2q2Qw6Pb6qECDKozzB+GLKx9FIO+IG5pQgg6ACEauSrfXo83Qnap7sdBaOeQUYcg==
X-Received: by 2002:a63:c20f:: with SMTP id b15mr7836254pgd.8.1602172359825;
        Thu, 08 Oct 2020 08:52:39 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:52:39 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 006/117] mac80211: set KEY_OPS_W.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:18 +0000
Message-Id: <20201008155209.18025-6-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: d0a77c6569ab ("mac80211: allow writing TX PN in debugfs")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/mac80211/debugfs_key.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index ea5908465f2e..b5fe68b683e7 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -39,6 +39,7 @@ static const struct file_operations key_ ##name## _ops = {		\
 	.write = key_##name##_write,					\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define KEY_FILE(name, format)						\
-- 
2.17.1

