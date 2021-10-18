Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B33743196B
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbhJRMlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbhJRMlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 08:41:03 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DDEC06176C;
        Mon, 18 Oct 2021 05:38:49 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id i15so4726843uap.0;
        Mon, 18 Oct 2021 05:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3D7vJ2CO2XMEmMZh2MVP6JvkEYwgmfgFmLBCLmoiFCU=;
        b=SyS5M378yS/ljDYnutUpPjvYWUz2wikfuz5/vW6GtZmZ/iLUuiTyJZE313Gk/gMmvk
         ZbV3KNcI9welOW2jO+dIx4okltfVVIGoDjjA0ILQXdCkUKgJGaH+r9YJUcLpUP3I7NI/
         M5JBLSVPZ+7rIXDlyuMqJeYKoUA8qo32wmsLwLwj5IL1IkNpgBxmwRnbFqmgJVuiFSaO
         QCL4JSp0eetDd1AgwPWohbm2EhHndOxiqWQDEq92M1opfqRYPfEZ/MEAPnpGgKjSQN8E
         dFGcOlAOU+bSlZXjqMQDutnE5nuDH7zTLnvz9xXiMSjiagLAwJvKC7abkQP8K5Yxwq3w
         rq5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3D7vJ2CO2XMEmMZh2MVP6JvkEYwgmfgFmLBCLmoiFCU=;
        b=UDi1B038jDV2jETrNuGr3f3P5BQ0KzRvr95H8uGBf6YSS5fPU/1X1bacK8Ur+5VZRN
         R2MZb/TtI+irw8R+AexXXzJ+EwpKca+kkPC6UDU9gKu1q/W0mDgyH9ptRX2esg8EmSru
         ch1yOmYVaFfJA0ol7FVZBYoJF6K2sHTPJb1cFhAnU49UEsBNyeQ/zb6qL6cqoxGpbBSG
         Uy8ovbXlv0+w0z9YTMWpohAbPowG13Qg39Z8GT7bfIlmIbOdFYlfkBLVGyymaQQHjT6e
         hl+Cvb65Ce6cL15aWqa8RvNJp23bHep6ymW13GT4ijTd0lnwZQRZnDK82vbrrMKWFmYw
         gDYQ==
X-Gm-Message-State: AOAM532e04vn7aOqX15rTm1HvZpTLYT6G9RUITYtKpeD38v728la1uMI
        ApM+dupzvF8G30L4UN3kn+dogeXLGtA=
X-Google-Smtp-Source: ABdhPJxG7g83ycJI57AwYWA3/6RkZu5SescbZexsGiLyijgwEwIO7IyVvQMR2fJJNnQ7fveD3YVH6w==
X-Received: by 2002:ab0:6e91:: with SMTP id b17mr25871332uav.117.1634560727995;
        Mon, 18 Oct 2021 05:38:47 -0700 (PDT)
Received: from nyarly.rlyeh.local ([179.233.244.167])
        by smtp.gmail.com with ESMTPSA id k1sm8585304uaq.0.2021.10.18.05.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 05:38:47 -0700 (PDT)
From:   Thiago Rafael Becker <trbecker@gmail.com>
To:     linux-nfs@vger.kernel.org
Cc:     Thiago Rafael Becker <tbecker@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thiago Rafael Becker <trbecker@gmail.com>
Subject: [PATCH] sunrpc: bug on rpc_task_set_client when no client is present.
Date:   Mon, 18 Oct 2021 09:38:12 -0300
Message-Id: <20211018123812.71482-1-trbecker@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we pass a NULL client to rpc_task_set_client and no client is
attached to the task, then the kernel will crash later. Antecipate the
crash by checking if a client is available for the task.

Signed-off-by: Thiago Rafael Becker <trbecker@gmail.com>
---
 net/sunrpc/clnt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index f056ff931444..ccbc9a9715da 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1076,7 +1076,7 @@ void rpc_task_set_transport(struct rpc_task *task, struct rpc_clnt *clnt)
 static
 void rpc_task_set_client(struct rpc_task *task, struct rpc_clnt *clnt)
 {
-
+	BUG_ON(clnt == NULL && task->tk_client == NULL);
 	if (clnt != NULL) {
 		rpc_task_set_transport(task, clnt);
 		task->tk_client = clnt;
-- 
2.31.1

