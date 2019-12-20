Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0BD5127B22
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 13:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfLTMfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 07:35:47 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43534 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbfLTMfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 07:35:46 -0500
Received: by mail-wr1-f65.google.com with SMTP id d16so9237486wre.10
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 04:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IRpKIsD/yB4vcd9IA4DUk/Dk0C5/lQ3QEN9LiBEzJKw=;
        b=YvYqSCCYtcTHeYH/5+EY11ylF+otqD9onDvqW/fvsjXpRPF0jj5pOZu/h+FTyiojyb
         qFenKu2blIHxLoXgikWOgUBsXeJ4FpIXmCqfHTbl5EkYCcWQxcTYXebCA4G4ip6KdQtW
         znwuxDcH7XDyhVzK4FKLfoTxpRS8kEKLGqr5a8d7cmCj5XpXwDtMKgFwiq1y/yM//5ma
         JVkpycuxbvHz6qisqtO7ItlPA1n7L8nL5ZIel0j1n62lBeqmB9Y0dhdIxWA3u9sLeMgO
         RGO5RDk7+fXaqqzF6PgZZvHwQbCjif55PLWwrmt4PX9HLJ12hZ7dnABpDxWB8HTDFe0L
         kPIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IRpKIsD/yB4vcd9IA4DUk/Dk0C5/lQ3QEN9LiBEzJKw=;
        b=HsImiuZdxAG+lQlb8rO7o6OrKLzrfhESyWRrX7IR9mLIWmM+Q6ip9gRU/CpT4YVmbX
         RAJ/4eZn2/YXSeq1zfvn15hNDIgxgyitlukTYgXnNknpUi3erLhmOD9f0FFLc/GmtILk
         CyJ3QTcKqb0VhpH6Z0M8+jabzFCAW9ur3ofDzmtJ5S1V4M7s1wsv1ZzVCOzNy2VaZ15D
         fGyBo8mn7b4Z462xlU0IvjrDy+RhZRmlK0+0G0tHw8XaqGrJ/OShcfV5rVzpHvUnYDj7
         5bgfErYQ4MemhXRa+UBJMUVKJDQjbsxQBajZe7P2SH9TY0B0I06qik1w+ALo7BXyXwQw
         iDgw==
X-Gm-Message-State: APjAAAU5IDoRnmdc6SbjVi0W5Pdk4yTKQOqFHNH45yfsSxf/qLw89Xyh
        FFMHuksZ+PgpfN9W65dlfqq9DabHohU=
X-Google-Smtp-Source: APXvYqwp20mSspCdG0EKPw9petWdizPHawRYpWJQ5goNgO7Ke2HY7yUfOmlfAFFCEi6zs2cUREWMFw==
X-Received: by 2002:a5d:4805:: with SMTP id l5mr14641245wrq.3.1576845344797;
        Fri, 20 Dec 2019 04:35:44 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id n14sm9398133wmi.26.2019.12.20.04.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 04:35:44 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, leon@kernel.org, tariqt@mellanox.com,
        ayal@mellanox.com, vladbu@mellanox.com, michaelgur@mellanox.com,
        moshe@mellanox.com, mlxsw@mellanox.com
Subject: [patch net-next 1/4] net: call call_netdevice_unregister_net_notifiers from unregister
Date:   Fri, 20 Dec 2019 13:35:39 +0100
Message-Id: <20191220123542.26315-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191220123542.26315-1-jiri@resnulli.us>
References: <20191220123542.26315-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The function does the same thing as the existing code, so rather call
call_netdevice_unregister_net_notifiers() instead of code duplication.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/dev.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2c277b8aba38..2c90722195f8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1764,7 +1764,6 @@ EXPORT_SYMBOL(register_netdevice_notifier);
 
 int unregister_netdevice_notifier(struct notifier_block *nb)
 {
-	struct net_device *dev;
 	struct net *net;
 	int err;
 
@@ -1775,16 +1774,9 @@ int unregister_netdevice_notifier(struct notifier_block *nb)
 	if (err)
 		goto unlock;
 
-	for_each_net(net) {
-		for_each_netdev(net, dev) {
-			if (dev->flags & IFF_UP) {
-				call_netdevice_notifier(nb, NETDEV_GOING_DOWN,
-							dev);
-				call_netdevice_notifier(nb, NETDEV_DOWN, dev);
-			}
-			call_netdevice_notifier(nb, NETDEV_UNREGISTER, dev);
-		}
-	}
+	for_each_net(net)
+		call_netdevice_unregister_net_notifiers(nb, net);
+
 unlock:
 	rtnl_unlock();
 	up_write(&pernet_ops_rwsem);
-- 
2.21.0

