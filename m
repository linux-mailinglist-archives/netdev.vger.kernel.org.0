Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E57B0E9566
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 04:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfJ3Dsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 23:48:55 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37548 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbfJ3Dsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 23:48:54 -0400
Received: by mail-pl1-f193.google.com with SMTP id p13so327270pll.4
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 20:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qNMP2DUI9muUqsSG2DrAsJDDEz4pD/8p5Z2KkI73k2w=;
        b=eG558GlhtTsyH33lgqqFu+v4qQSqCoIdD/FBj01HVilT7o8JTd/dUNBwxWHyWmYk9q
         JlC+hMMl+T+Ityi6jZ/4hTr/19hwL+JHtjD5KVrqUykIxhUp7R2BNC4YfQ+ellvh0ht4
         sGE8ht7sTgdU1a+YoHQ7pMBXYu1R8z2ezKDnn35n6OPm1h2lV1hU/c2tQLfz89RFdsr5
         OhjbDLLsU7pc5jTob4TgSx83xbuhLZwQ5wwd8s3SrUpNEuhOl8DKDQwS2kUYNpfs/tAX
         4kuY60nppsGLxhaacbzYXHpezViwVKZzx5I920DXFvkzkVueiHrlj1H2cKEnXaI6SHRf
         3mbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qNMP2DUI9muUqsSG2DrAsJDDEz4pD/8p5Z2KkI73k2w=;
        b=V7eyzj2RaS0XCFFwKhLzSTyZ2j5k+JgSl9e/SF4L8g6NtN748N4eeQ2Whu+frMQ4Bc
         I5m72mmKsEYF8LP6CakR3Qk+bQ4IW3J32MDEvjI69yb4t3s/XaMCFZhljeLjgdVLR1GO
         H3/LBxPzT91Sj/Jt+UVMFkmbi4lN+0OmcBIlLap7yLCnZY32J3CVLASdLxMMO6Jfwr61
         Nkcu/YWav/swt+zO7CzKeL6PY8zDye9GR2gmCCL4E3YL5CSBVrqTK0XwhrmIH2iJag8m
         SiNHEYYGOsG47Sbj5FFyyi3E/hm0/oa6QSe5nCEC2LacrxlY4p+1PBkviMGDTOjUQVVb
         0Sjw==
X-Gm-Message-State: APjAAAV2m9CfRGYH+Fbx5mkYz0oD3GGXtWdjN9OpoR8zsuio0tEHZzG2
        8mguJPFiKmDZl3UoM49L5do=
X-Google-Smtp-Source: APXvYqwXm5ESDLi+/bd/4RLgpPJKv03S97HQgXMQUuo+QcciSVFqfGDF33fRn+3Kn+Nbr8i52xBmEg==
X-Received: by 2002:a17:902:142:: with SMTP id 60mr2366200plb.38.1572407333207;
        Tue, 29 Oct 2019 20:48:53 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id l22sm632390pgj.4.2019.10.29.20.48.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Oct 2019 20:48:52 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Paul Blakey <paulb@mellanox.com>
Subject: [PATCH net-next v5 09/10] net: openvswitch: don't unlock mutex when changing the user_features fails
Date:   Sat, 19 Oct 2019 16:08:43 +0800
Message-Id: <1571472524-73832-10-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571472524-73832-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571472524-73832-1-git-send-email-xiangxia.m.yue@gmail.com>
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

