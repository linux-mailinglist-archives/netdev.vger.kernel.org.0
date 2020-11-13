Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0402B26C7
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgKMVar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgKMVao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 16:30:44 -0500
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4587C094240
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 13:30:43 -0800 (PST)
Received: by mail-qv1-xf44.google.com with SMTP id x13so5375741qvk.8
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 13:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=p9cmsU0CLi5tDhUSce4W56NG03m1gfWpOTNcudHv6mk=;
        b=LntATJHKoayQxbIf2gR5COo4Sh4QVFH+KEfFYss+PxJ1FrYILV6wWxKgLqrrzpV6NS
         Qj1W+q6kBK/CEoHPj8GbX6zf6oWw4JbkXVjpldpgxATqV/7e4r/YwI2UJ5rUYb3RsaJz
         832OUi+U9sdNXVKP5Skc82+awpjfN2yKzrVrQi9ag4qvz5rQV2KMAK2wZZzog5CTujKW
         aKiimqDZn5dqvr/QtQREJuoI0/AIPPZ2IBUnyhPBeMJ+R+uDQr/RRcCFZRyoKpbJds/M
         KDXO5iWVEi1JEKQA15eZ1Q/CRPP94mbzI9xUo7ztaIgX/5w6RD60BDQnrFFMhtvsCyGN
         t4bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=p9cmsU0CLi5tDhUSce4W56NG03m1gfWpOTNcudHv6mk=;
        b=ahM+rbtZrOTJECkIeqvsRrqyYJA1SyO2JRZJTn7vdVlvEbU3090Pt25JVrZyJx3GjM
         Yo+B8OgXMtQUaKuIqKmRbeAv/9WRmeTzlR1syB9N4t/LCvQGPK8KqPAVHt+huGljaix9
         y+vrG8+aHNueojrrR4b0cAHqlzpBf3X57exSUFDyqXTAq+t6HN2PudwDW+vX2Yq08L37
         ciYV/bASBGejsrXvqfVmMuJwgHg5Xh9uOX5MoemIss0CqwPY8rKUy2dyaGc7WBD5hg2A
         7TSFrXF5cXNI8vwnjOxoanblanxQyTqRFPRGpStj2UKM/E+c6gkUIGHaEueJ+bgJq08G
         RGZg==
X-Gm-Message-State: AOAM530o3I4PoJI3Oba0AeU1Vn4AZYFXf5Wf9neP3LkwPhaC33HdBZIp
        0dKt3loN3pb7+kHMERZmUidkAZ4bTH2Gxz3mmw==
X-Google-Smtp-Source: ABdhPJzAO3kTUUIz6ySjW3XiOLT/TmYChj1SbHd/uzIxPN5qqJk5DRmd3PVoC/4dXeRlBdgEknnhLw==
X-Received: by 2002:a05:6214:1805:: with SMTP id o5mr4484226qvw.41.1605303042527;
        Fri, 13 Nov 2020 13:30:42 -0800 (PST)
Received: from localhost (pool-96-230-24-152.bstnma.fios.verizon.net. [96.230.24.152])
        by smtp.gmail.com with ESMTPSA id p48sm8060359qtp.67.2020.11.13.13.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 13:30:41 -0800 (PST)
Subject: [PATCH] netlabel: fix an uninitialized warning in
 netlbl_unlabel_staticlist()
From:   Paul Moore <paul@paul-moore.com>
To:     netdev@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Date:   Fri, 13 Nov 2020 16:30:40 -0500
Message-ID: <160530304068.15651.18355773009751195447.stgit@sifl>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Static checking revealed that a previous fix to
netlbl_unlabel_staticlist() leaves a stack variable uninitialized,
this patches fixes that.

Fixes: 866358ec331f ("netlabel: fix our progress tracking in netlbl_unlabel_staticlist()")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 net/netlabel/netlabel_unlabeled.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index fc55c9116da0..ccb491642811 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -1167,7 +1167,7 @@ static int netlbl_unlabel_staticlist(struct sk_buff *skb,
 	u32 skip_bkt = cb->args[0];
 	u32 skip_chain = cb->args[1];
 	u32 skip_addr4 = cb->args[2];
-	u32 iter_bkt, iter_chain, iter_addr4 = 0, iter_addr6 = 0;
+	u32 iter_bkt, iter_chain = 0, iter_addr4 = 0, iter_addr6 = 0;
 	struct netlbl_unlhsh_iface *iface;
 	struct list_head *iter_list;
 	struct netlbl_af4list *addr4;

