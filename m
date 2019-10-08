Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B13A3CF901
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbfJHL5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:57:14 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36414 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730495AbfJHL5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:57:13 -0400
Received: by mail-pg1-f195.google.com with SMTP id 23so10136410pgk.3
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 04:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5h+mm5b4p4hFAu72NQVMEV1XO70kNtCw7rgNvqIUP0k=;
        b=Lft/jDQwQMmxW8vz3qfryH6qdSZJENkWQJNJbAykTeXkXLKq+ti8Nd2H9oNMxXT9nj
         cAXZxYqyuCdyRrOQmaO65KpbsoYoCKRMRSz5/Z+HpPrNP/ahBSQWw+80onSxQZozpWs/
         adqhA71eoZ8GMJkyJIyup3qzrIQe9QvcKiwmv8lHU49xyPRAAHy9d9TZ+YcGVvGOyqiV
         z4glThNVMYE+WFFqCPiI7cN1pctv0yZ/yw7y1fqQsMqpFcAZhSfNqE0fRLXQKgNc4JXk
         jF7T0yQC7jmyyuGrzmgVpDLoeyGy6ceM7t9OdwyardwlXz7RUXzf5/L8Ou63IzfSwuE6
         oDwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5h+mm5b4p4hFAu72NQVMEV1XO70kNtCw7rgNvqIUP0k=;
        b=fxOPiXWoz5L0X7IyQygNzHc1febFcAH1Nxiom25xKBz9DcVpIRtBSpqW2dOANn8SJI
         EGHxE1W0tXNz85cZu4I3cMhlGHb96uh9VMEf3Hq2svwJemh4fobQqjxsGvrKvWgjGJoO
         W23oRVGsd4Rsl/lGo6GtTBj+g0B+A1wrev79CGqZaLeZ08mpTdqzWx6GFH6I7mhBVxWC
         2gRQTUVj+B3aBcvbmZlaojMqx3gAQeiWYRn2tQK8YU8teiVVPCLQbaQPERe3GMqhmUIt
         avrTzzSKqd1LRrgP0p/QZ4PTQgXlIoEdMdJ3bXc7De12ejNDIXCj/9dwxiZjh0Seepea
         XPKA==
X-Gm-Message-State: APjAAAXRdrcV8JbgK/EAvWgh764SdmEGXK94Oy2PH47oV1lxDw1v+YNc
        nKYR5jN+rBygOhahdEG1z28=
X-Google-Smtp-Source: APXvYqyZ3ijlK3hcaCT4febHsrNG4+IDSj6UzsxRcqNPg+VTrE5uLhuRpbQs96L+KLge+V2m8HraWQ==
X-Received: by 2002:a62:7c47:: with SMTP id x68mr38852107pfc.178.1570535832511;
        Tue, 08 Oct 2019 04:57:12 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id b14sm18149932pfi.95.2019.10.08.04.57.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:57:11 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Paul Blakey <paulb@mellanox.com>
Subject: [PATCH net-next v2 09/10] net: openvswitch: don't unlock mutex when changing the user_features fails
Date:   Tue,  8 Oct 2019 09:00:37 +0800
Message-Id: <1570496438-15460-10-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Unlocking of a not locked mutex is not allowed.
Other kernel thread may be in critical section while
we unlock it because of setting user_feature fail.

Fixes: 95a7233c4 ("net: openvswitch: Set OvS recirc_id from tc chain index")
Cc: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/datapath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 9fea7e1..aeb76e4 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1657,6 +1657,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 				ovs_dp_reset_user_features(skb, info);
 		}
 
+		ovs_unlock();
 		goto err_destroy_meters;
 	}
 
@@ -1673,7 +1674,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 
 err_destroy_meters:
-	ovs_unlock();
 	ovs_meters_exit(dp);
 err_destroy_ports_array:
 	kfree(dp->ports);
-- 
1.8.3.1

