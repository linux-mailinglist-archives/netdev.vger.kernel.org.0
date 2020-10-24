Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3273297CF7
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 16:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443542AbgJXOxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 10:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437496AbgJXOxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Oct 2020 10:53:24 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778B2C0613CE;
        Sat, 24 Oct 2020 07:53:23 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id l15so6012053wmi.3;
        Sat, 24 Oct 2020 07:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OvxvbCK3gChEXNktCxCghpQANg+WJeJo/1Eq0X3W6wc=;
        b=dae5oWKcrSjs6iXed3yr6KwpZ6a8DlUYtYNbiJpVuZbswBWMx2ZkjvlmPvb522zBMI
         /1ZEqNq21dFAWsD4ZovjDXAzNNZD703eKt+KFxga0J3KMjQ3gwwMgZlKqIy0uKMSIgwl
         GyLS2tl7UN+QIcHEZJ0b/cFsVZa1t5FNG5Okb2g0HUI076IA86S05aMtcEWb9YSq9Wb3
         8HLXyheu4/Xn32azrBwF/RZ7vjxK7Fk29wt0epDDzw7bTGv9aWpQP391MjulTPzhvxW3
         Lv3Eq9cJMwyh8pc+hptqM8w8zyRyP9ysZh1spPdOSfNwiqDGMZLrNHasNOJ0nIjiv6S+
         7cSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OvxvbCK3gChEXNktCxCghpQANg+WJeJo/1Eq0X3W6wc=;
        b=OkIxfJ0ojn3RyNSVLiAFcMor7rTNzDZ0ozGh6BVIFaTRtPWSVn5xHkVtN/1XZKZEvd
         Bw3XNAt6zSkut+TFsEVnbULJmng0/Bw2vtF3S5WQnaeOWwUmR4msA3C8gYmaXHv7KQXd
         mWhFDPJRc3rmv8aAbai7Iv+pTqHXb/cWvG+5HagAAJmAg0OvqeZPX/J4CPB4SQkfhXC0
         ctnFcGWB4HvXdqjJo1Sh6axL3W2zuaTNvzjsAXGUI3+sOpKNfdPLtOu/cWR7Nz5eMEhO
         J6NCJ8k1xYSd4rgZfiFeQREnCdkLd1TzGexsTsbNJk2gxI3pwFIqbf4SFKje3Kz9tPH9
         Y0Dg==
X-Gm-Message-State: AOAM531oiN9FDskss1AQJuHUsEaJe/uhW1x1oIxEJNDvwM9xw+CK8bO4
        6cs0vA9du8K/yPRWdCDUZDogcgkPdX3kTg==
X-Google-Smtp-Source: ABdhPJyL55MqJGEtqbg6gn8l1r2+b22Q5Os83L7473HpA1/k4PlKqBfAmyg6IkzpV6GQxkPnSlx9nQ==
X-Received: by 2002:a1c:8093:: with SMTP id b141mr7298051wmd.139.1603551202205;
        Sat, 24 Oct 2020 07:53:22 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id d2sm10896551wrq.34.2020.10.24.07.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2020 07:53:21 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Artur Molchanov <arturmolchanov@gmail.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/sunrpc: Fix return value from proc_do_xprt()
Date:   Sat, 24 Oct 2020 15:52:40 +0100
Message-Id: <20201024145240.23245-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit c09f56b8f68d ("net/sunrpc: Fix return value for sysctl
sunrpc.transports") attempted to add error checking for the call to
memory_read_from_buffer(), however its return value was assigned to a
size_t variable, so any negative values would be lost in the cast. Fix
this.

Addresses-Coverity-ID: 1498033: Control flow issues (NO_EFFECT)
Fixes: c09f56b8f68d ("net/sunrpc: Fix return value for sysctl sunrpc.transports")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 net/sunrpc/sysctl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/sysctl.c b/net/sunrpc/sysctl.c
index a18b36b5422d..c95a2b84dd95 100644
--- a/net/sunrpc/sysctl.c
+++ b/net/sunrpc/sysctl.c
@@ -62,6 +62,7 @@ rpc_unregister_sysctl(void)
 static int proc_do_xprt(struct ctl_table *table, int write,
 			void *buffer, size_t *lenp, loff_t *ppos)
 {
+	ssize_t bytes_read;
 	char tmpbuf[256];
 	size_t len;
 
@@ -70,12 +71,14 @@ static int proc_do_xprt(struct ctl_table *table, int write,
 		return 0;
 	}
 	len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
-	*lenp = memory_read_from_buffer(buffer, *lenp, ppos, tmpbuf, len);
+	bytes_read = memory_read_from_buffer(buffer, *lenp, ppos, tmpbuf, len);
 
-	if (*lenp < 0) {
+	if (bytes_read < 0) {
 		*lenp = 0;
 		return -EINVAL;
 	}
+
+	*lenp = bytes_read;
 	return 0;
 }
 
-- 
2.29.1

