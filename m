Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE275467048
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378281AbhLCCvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243536AbhLCCvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:51:54 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5859EC061757
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:48:31 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so1317630pjb.1
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0ueK711Sqj023gTBd/tQUmqv75JSIuZMHZ4ezZabzok=;
        b=KlUDesw8YSizLlQhEfHdLI9QCaWH2ugPczTJSmFz4qf49JfvNhVu2ck9fJqgROWX7L
         x2sIOSnVQ2PBv1vi0buoXBG0b4cmC+ocjLhnLSrP2ZdOXNSQ6zt1XbWrVNdrcUpmrRF7
         kwaATo/2Ijxq1KkgFktTsZGZqiruqN41aprvwqaV9Gd6Z8/6RqkSfYd4s+f/KW/RwK5Z
         ERo0EiyrTVCEjOF3audO+9alxYlZ48N7NXzfq2HWyu2XHGbt13bSlT6ZgDsO3iXzgNOa
         BxTgPjxcN25Ym/J4buszCzizMtulgOcllayQ7p9BJJ+heU610lBoBcgyTO/PUnWikfDh
         bosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0ueK711Sqj023gTBd/tQUmqv75JSIuZMHZ4ezZabzok=;
        b=K65hXerG/9Sd+C9o+j6s6K33K6zBRJ5Lf613sEexaWArze6ckLbpmiAmsJWJjyPh4A
         89A9fEI4TTptXhF6lpfobkfFm3rRBIqS9lkkDTZC/ts/5d/n6T2Mza1mmL1wPfjLBlJA
         BZg3Qe7Iog9QHOAUnvZAdEHAE0kVA1EZSfCSlXxxKI5wECOx3paEIkAKLH2CVz3UgOEV
         Ql26LE0b2qxU+JZ9dVAOq98MVrpvkdhhA3RvyzTQUOXljHFH/QoeFHw7n22xz8aBWJK8
         RjhP9Qh922g6iKlDOjAUwnysW8IfYfWM/QpETLuBRRESL+mt6tXqq2uQuovDopI8Hswh
         qbkA==
X-Gm-Message-State: AOAM530g1ZFP9ZIfqPjMgNcj2WalySA27uk2KNx5VnrvqFFyWGl+BzYE
        9srKkouWaVJPS4yR250eWsQ=
X-Google-Smtp-Source: ABdhPJw7kHjDgxV4vbW8Mt6LiAxPh1MEjLdqnzCfNIj7jeLeJaXv5MPYRi6cMMc9R7fxXsEj0hdhCQ==
X-Received: by 2002:a17:90b:3b8e:: with SMTP id pc14mr10367006pjb.129.1638499710942;
        Thu, 02 Dec 2021 18:48:30 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:48:30 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 23/23] netpoll: add net device refcount tracker to struct netpoll
Date:   Thu,  2 Dec 2021 18:46:40 -0800
Message-Id: <20211203024640.1180745-24-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/netconsole.c | 2 +-
 include/linux/netpoll.h  | 1 +
 net/core/netpoll.c       | 4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index ccecba908ded61370f8fc408ea53aa1ff305aca3..ab8cd555102083c2f0179898681489b987afe5b0 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -721,7 +721,7 @@ static int netconsole_netdev_event(struct notifier_block *this,
 				__netpoll_cleanup(&nt->np);
 
 				spin_lock_irqsave(&target_list_lock, flags);
-				dev_put(nt->np.dev);
+				dev_put_track(nt->np.dev, &nt->np.dev_tracker);
 				nt->np.dev = NULL;
 				nt->enabled = false;
 				stopped = true;
diff --git a/include/linux/netpoll.h b/include/linux/netpoll.h
index e6a2d72e0dc7a6929d32a2e994f24719e073121e..bd19c4b91e31204e85d30884720b761116d5c036 100644
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -24,6 +24,7 @@ union inet_addr {
 
 struct netpoll {
 	struct net_device *dev;
+	netdevice_tracker dev_tracker;
 	char dev_name[IFNAMSIZ];
 	const char *name;
 
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index edfc0f8011f88a7d46d69e94c6343489369fa78c..db724463e7cd5089d85d8f75a77ad83bbece82dc 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -776,7 +776,7 @@ int netpoll_setup(struct netpoll *np)
 	err = __netpoll_setup(np, ndev);
 	if (err)
 		goto put;
-
+	netdev_tracker_alloc(ndev, &np->dev_tracker, GFP_KERNEL);
 	rtnl_unlock();
 	return 0;
 
@@ -853,7 +853,7 @@ void netpoll_cleanup(struct netpoll *np)
 	if (!np->dev)
 		goto out;
 	__netpoll_cleanup(np);
-	dev_put(np->dev);
+	dev_put_track(np->dev, &np->dev_tracker);
 	np->dev = NULL;
 out:
 	rtnl_unlock();
-- 
2.34.1.400.ga245620fadb-goog

