Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FC92EC9DF
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 06:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbhAGFMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 00:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbhAGFMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 00:12:08 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E030C0612F1
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 21:11:28 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id v3so2869162plz.13
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 21:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ekDmBCw0Ka3p56Nn52+5Qv41+dOfGLCxA/iFP0nf5vE=;
        b=tZzOgkHxL0B4a4TNyPpfGFL3148zpSU1nNAnTUIDQfKOvxPin/BT1j2iSXiZwXUeRe
         t5xtHuH41rdloWgZpyHyalxsFizY7/Fd9XgV13NSm3mQcoIer7T+v2U8w7V8O86D8vpO
         AkOC1emNqaSc42FqSShVB+xM8UlN4J1knq90NkRyeAmpkUXCfAOc42jmfRPf5S7pIdT2
         J8M/yAfGrfH1DuemYtzBW5IObeD0XF7kyStGD28IZuj1K7Qn+6arzljG6qhWcLjh2FJs
         OsJAoo8HCQllgeBiptyXW3DtbjQG1Hx9kw9Mwfo9s9RZ692YmQiUmJrRUETr2vfHAIkS
         JFTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ekDmBCw0Ka3p56Nn52+5Qv41+dOfGLCxA/iFP0nf5vE=;
        b=syYi0/y1m9jny/fMDGLK2AMOTe0+tvw8/uLxQka7lemeYEAREzRgFFu/zt+2O/1oyN
         JnDPslwgWHTQHuO21uBeRi9cNE/QZi0QM+zdjcGUOTfvRH54TIb2W9/4CA4wx0H6D+Gf
         3E0pbiLIM2vX8BleSF8noC5D7vOwjFQl+UX1plsBbrP4LNocnz+shEJ0iiruv8qEb0C2
         vgHyuTkV7ysu/KOmHp6MgBQKLR/9jmOWR1KRL6yKopP3f7aoCPND256rQdushFegBYQL
         0sZUdljeYffI6rvc5UB3ig2Xl3ks7iW2c+63yIAsx5EqbuBW1BtqgOzTyCcvaorMGFy4
         kTHA==
X-Gm-Message-State: AOAM531Cjd2TWoRbdbRELyutQQo6S71qMhzuX5pUzOvsDjxanJpdP4D2
        Yi0rGHjMVmWaF94rQ/8jZFwjJrbhuXeD6Q==
X-Google-Smtp-Source: ABdhPJx61yj1XP10jSsXMYO7RWfIz8uAt+aj0rGLWSrXMvdbaONkGDFeyYT4knjXQZCXWL4BbNoivQ==
X-Received: by 2002:a17:902:8bcc:b029:dc:45d9:f8b2 with SMTP id r12-20020a1709028bccb02900dc45d9f8b2mr7741623plo.62.1609996287688;
        Wed, 06 Jan 2021 21:11:27 -0800 (PST)
Received: from localhost (natp-s01-129-78-56-229.gw.usyd.edu.au. [129.78.56.229])
        by smtp.gmail.com with ESMTPSA id l190sm4043590pfl.205.2021.01.06.21.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 21:11:27 -0800 (PST)
From:   Baptiste Lepers <baptiste.lepers@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, willemb@google.com,
        netdev@vger.kernel.org, baptiste.lepers@gmail.com
Subject: [PATCH] udp: Prevent reuseport_select_sock from reading uninitialized socks
Date:   Thu,  7 Jan 2021 16:11:10 +1100
Message-Id: <20210107051110.12247-1-baptiste.lepers@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

reuse->socks[] is modified concurrently by reuseport_add_sock. To
prevent reading values that have not been fully initialized, only read
the array up until the last known safe index instead of incorrectly
re-reading the last index of the array.

Fixes: acdcecc61285f ("udp: correct reuseport selection with connected
sockets")
Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>
---
 net/core/sock_reuseport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index bbdd3c7b6cb5..b065f0a103ed 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -293,7 +293,7 @@ struct sock *reuseport_select_sock(struct sock *sk,
 			i = j = reciprocal_scale(hash, socks);
 			while (reuse->socks[i]->sk_state == TCP_ESTABLISHED) {
 				i++;
-				if (i >= reuse->num_socks)
+				if (i >= socks)
 					i = 0;
 				if (i == j)
 					goto out;
-- 
2.17.1

