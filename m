Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2D049EC47
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 21:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343856AbiA0UJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 15:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343849AbiA0UJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 15:09:49 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825D3C06173B;
        Thu, 27 Jan 2022 12:09:49 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 192so3831420pfz.3;
        Thu, 27 Jan 2022 12:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RkfqaIYdIflD5OrIVUZ3ltg7/5gsx64rX1PAV9PiRlk=;
        b=PKuRIZiAC8lWuO37QCM7QnFpEOPwpVOh73ngLaxQvAKXM+TShrd+ZTVHeiukqdYc1G
         FzhG9pxy4gjAtrO8vFCwZK75ZWZ/xT2UpDnYhNz256fQGoHJ1Q98vYbZmVtefLRvImon
         yteO0HGSfrmowCJ9qt2l10nW7+9BduHDSo6hBL66Abj9+/6/iBYOl0qB5lnJnCqp/QCy
         JrF/lF3vBXeDn1frlnLpdY1liCQc6rHKwZPY+wOhP0TwevpVSBKXjn2lJpYXXhjyg95L
         u00IaBjupO3Y2WEbCe2eU1j9boEVPm8tyfFlgm1otPbE1CWRwesyqgNEOnG5TPzswkwA
         tIfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RkfqaIYdIflD5OrIVUZ3ltg7/5gsx64rX1PAV9PiRlk=;
        b=GwFCfg3SS6h7E1DPTtzbVR404o82gWtQhI/+DQhT57xEsp3Zv2AZagBDtDShLUHmjo
         GPmcNx9J0lXrttEihZ+nowzPgm5dh48TKXNt+QIWJoT1g/cTNQwGQ3tH0/PVPH0/BfH5
         oXg32vh0WeRtck74fKANLrjickavkTNTBoxIibvz9zn5U04q2Ts3jWFT2mwAD/75WPca
         UFRW9+V+uJWjTrYDtTa5t+7vCyaF7k5PJ9lV2ZIuSF6oA6/ZF5zov2iet9NCZvq4eZg1
         A7LnKoy1vMMcks/DDZFUsAFxek+4KH8/XsWucAMU5is6frrs4tpSWa8zBbnzngKBr0xe
         unUQ==
X-Gm-Message-State: AOAM532ltnhAioCjrRAqxjIBehMxq2Z9miiRZc/O6wwTloFH6w0YL6KK
        2yvpQRWynoDWVp9XnTy0erk=
X-Google-Smtp-Source: ABdhPJz2BlCJ7i72gol7bA35OiGHesJ9FTrIqhv2J8Y6ozbv1dNkYJVEgmuBB06Vm0aly4O2cCm8tA==
X-Received: by 2002:aa7:8706:: with SMTP id b6mr4414467pfo.61.1643314189009;
        Thu, 27 Jan 2022 12:09:49 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ab5e:9016:8c9e:ba75])
        by smtp.gmail.com with ESMTPSA id y42sm5697892pfw.157.2022.01.27.12.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 12:09:48 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/3] SUNRPC: add netns refcount tracker to struct rpc_xprt
Date:   Thu, 27 Jan 2022 12:09:37 -0800
Message-Id: <20220127200937.2157402-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
In-Reply-To: <20220127200937.2157402-1-eric.dumazet@gmail.com>
References: <20220127200937.2157402-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/sunrpc/xprt.h | 1 +
 net/sunrpc/xprt.c           | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index 955ea4d7af0b2fea1300a46fad963df35f25810c..3cdc8d878d81122e3318447df4770100500403e4 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -284,6 +284,7 @@ struct rpc_xprt {
 	} stat;
 
 	struct net		*xprt_net;
+	netns_tracker		ns_tracker;
 	const char		*servername;
 	const char		*address_strings[RPC_DISPLAY_MAX];
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index a02de2bddb28b48bb6798327c0814e769314621b..5af484d6ba5e8bfb871768122009ee330c708c04 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1835,7 +1835,7 @@ EXPORT_SYMBOL_GPL(xprt_alloc);
 
 void xprt_free(struct rpc_xprt *xprt)
 {
-	put_net(xprt->xprt_net);
+	put_net_track(xprt->xprt_net, &xprt->ns_tracker);
 	xprt_free_all_slots(xprt);
 	xprt_free_id(xprt);
 	rpc_sysfs_xprt_destroy(xprt);
@@ -2027,7 +2027,7 @@ static void xprt_init(struct rpc_xprt *xprt, struct net *net)
 
 	xprt_init_xid(xprt);
 
-	xprt->xprt_net = get_net(net);
+	xprt->xprt_net = get_net_track(net, &xprt->ns_tracker, GFP_KERNEL);
 }
 
 /**
-- 
2.35.0.rc0.227.g00780c9af4-goog

