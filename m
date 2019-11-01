Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8ABDEC4A3
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 15:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfKAOYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 10:24:40 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32809 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfKAOYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 10:24:39 -0400
Received: by mail-pg1-f193.google.com with SMTP id u23so6612860pgo.0
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 07:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qNMP2DUI9muUqsSG2DrAsJDDEz4pD/8p5Z2KkI73k2w=;
        b=YMSQDLwCkQ9D7Sjv3BZ2JEtUaIOKeQGpbV1eLbu67TlC1bacAWwPv/fyr/mDgdhA+0
         IhXUI9YUAJohjcB+X/Jy2Ck4zaIO1VCQSzXtDDSnkJ/v8WfJwSLx5Zf/QjgeoqfLMlTz
         kBq+VurhdGkuXnz1M/IaQXBWNVzZ8kH1RKFO3zVxRNOhkdjuOgi2V9DjOkqzB+Li+ux8
         V8GApF5/FA8849lTf407w1WGvWONnAgLJ3kYqFZi2qudJU9tEeMqBGrb46G6aeXv90a1
         PzNOxtmf+DERlUeoaBND4JEtMN6Aqn29NE9d/bvZugRu1QjBGYiUEaxH1Fd5mdDOe7TD
         dtkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qNMP2DUI9muUqsSG2DrAsJDDEz4pD/8p5Z2KkI73k2w=;
        b=T0IofvijcETDqzn7k5RUtEzwajFj2jiXQYpqCyEXsWy7Bc8rEMubQNNottnBtpk3hR
         kHFfw9qEIVRSfLPqCl+M0dSnF+jFENEJcjN+RBM4Z0Kjtx3I1+LEeagRU2V7HfawdeLW
         mJyh6f2k3KW8AXIJvqCgDywCXwhbNbuXDeOhGPnf8xAb38cjvNt2c2p7e2xgYpqk9jc0
         6X9VOFtNZxE8Xl1ZPIPLdUfnncBko4mUFGhSNi2oYA1EKJvOQ2n1VQJY5PwNKNy8hKip
         ljUvDIZVLapBxNzVl4HKp2mA5Cj9A1WKw9VBvlqrBaHwZg47XRYeOsikzNc0HiMxVm5h
         4dAg==
X-Gm-Message-State: APjAAAWRLVRS+azi2hV6Vlffq75BQhTKmOS7D+ca0WIQ7jsObXuScWVo
        brYl7iU/HBwNvFM0AGMVeJ0=
X-Google-Smtp-Source: APXvYqxUJI5vNrS6FrGh2YItyKO5+LYyTSponiJn+0llW9qKZPgtvI449KFffgsYXumQU2JDWyumDg==
X-Received: by 2002:a63:5b56:: with SMTP id l22mr14147735pgm.52.1572618278082;
        Fri, 01 Nov 2019 07:24:38 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([1.203.173.208])
        by smtp.gmail.com with ESMTPSA id c12sm8296499pfp.67.2019.11.01.07.24.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Nov 2019 07:24:37 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Paul Blakey <paulb@mellanox.com>
Subject: [PATCH net-next v6 09/10] net: openvswitch: don't unlock mutex when changing the user_features fails
Date:   Fri,  1 Nov 2019 22:23:53 +0800
Message-Id: <1572618234-6904-10-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
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
Tested-by: Greg Rose <gvrose8192@gmail.com>
Acked-by: William Tu <u9012063@gmail.com>
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

