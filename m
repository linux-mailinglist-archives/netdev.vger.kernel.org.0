Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76011149523
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 12:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgAYLRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 06:17:15 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40170 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgAYLRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 06:17:14 -0500
Received: by mail-wm1-f65.google.com with SMTP id t14so2027883wmi.5
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 03:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n9FwnkG/pZDMawiKnRiV50zh8KR6jlMi42yP2RzVrJE=;
        b=QbPsuvqFWFOwA82t2Xrv9TsGBCKtM/EhPTohw8qN5kBK3CXCV8yZCZg1n4V8dt/Gs9
         kbp3GLj2L4j0fEWmvwPE8wMGwrjJf5/1URJaPWmYOq4OELYqbq56kmMql73VU90vWK8R
         QJgmXVlKMfFAxdzTsUe3caMxflhTPQLALVh3XhxAr5Q6DZFJHDwjpkS9lyvx/Bi1dBI9
         Ga6DaeBSIELig4jz2KhGYtQ/raWjjE4h7kjbvx1QRyggquPMZPc95rC7Pt2rTrMiu8RX
         MnzfIyzCqu6sEQvx8f4d0+d0FcUqOVZ1SK1NjyiGqBkLigfPeTWNLcLIyaF9jDSF9LTe
         BwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n9FwnkG/pZDMawiKnRiV50zh8KR6jlMi42yP2RzVrJE=;
        b=mHUCf1mU0X8cBYeNKvwF6NpQzkO7OsewR76rIpTBKNZyj6PBW11ma88eSGv3NSbKGO
         hyqNi6yjej863poUY0ME4Se9ONwtWlQT6Q6dkMeG4GWsKyxkLyVO8Vq9llJ9XSIkmfj2
         8smLNjxXNcVpRARNKMZnwL5L7vnDZjCa+dlj9rAxerHoi0VihhRWeNnygGfsxNtjIEW1
         3UcEzA8viTcl/LA9dziMprM062XdvSSzVWB0Ig/7DTf7BEOWMkMtQvsmxwvVF6mt+K/o
         MPLx9YsvgcyaqafTzhsIylyUWvJARp9ZVy5f2Z1Pmkkx7CseP3S/EC8TV0YUfFiuAcfm
         eAjg==
X-Gm-Message-State: APjAAAWagUzFo6VzaIX4BrEVb4UPHj31tgYwrFnBMFkqst6kD7ksXVU5
        yBBt7Pq8owGqM7C0peg5WOrDc/wa6NE=
X-Google-Smtp-Source: APXvYqxNwAqpwMGVFpBeycFna82a5LagSr/ybkrm1/XtfXgMljnb3QvufXXMHJSNq/tWOtfmilRCKA==
X-Received: by 2002:a1c:238e:: with SMTP id j136mr1314852wmj.33.1579951032464;
        Sat, 25 Jan 2020 03:17:12 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f127sm10297921wma.4.2020.01.25.03.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 03:17:12 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, leon@kernel.org, tariqt@mellanox.com,
        ayal@mellanox.com, vladbu@mellanox.com, michaelgur@mellanox.com,
        moshe@mellanox.com, mlxsw@mellanox.com, dsahern@gmail.com
Subject: [patch net-next v2 1/4] net: call call_netdevice_unregister_net_notifiers from unregister
Date:   Sat, 25 Jan 2020 12:17:06 +0100
Message-Id: <20200125111709.14566-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200125111709.14566-1-jiri@resnulli.us>
References: <20200125111709.14566-1-jiri@resnulli.us>
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
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 net/core/dev.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 4dcc1b390667..3cacfb7184e8 100644
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

