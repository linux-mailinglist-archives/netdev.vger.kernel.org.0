Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4527313E1E4
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgAPQwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:52:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:35034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727030AbgAPQwH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:52:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBF68205F4;
        Thu, 16 Jan 2020 16:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193526;
        bh=PO5UrKv+1oavjwSv21QQ7l+Tp/RWVsrVvNfUXTsAb48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGV2hS6GGyEjcQPjLSpwASa+e/J+NSD2bP6eIsc5CoGyiYbSvEulGxqr/WGUjNte/
         kWhcmbAnvTFzH+EmByTvrRw8iEpROc7zvKpB/zbiBrVh+KJ9xFqhlGitySPQeeQ+v5
         gMWnMV7q6CSo5BaRGLksroa5mQ2Y3RIGMC+xphJQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Paul Blakey <paulb@mellanox.com>,
        Greg Rose <gvrose8192@gmail.com>,
        William Tu <u9012063@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        dev@openvswitch.org
Subject: [PATCH AUTOSEL 5.4 096/205] net: openvswitch: don't unlock mutex when changing the user_features fails
Date:   Thu, 16 Jan 2020 11:41:11 -0500
Message-Id: <20200116164300.6705-96-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

[ Upstream commit 4c76bf696a608ea5cc555fe97ec59a9033236604 ]

Unlocking of a not locked mutex is not allowed.
Other kernel thread may be in critical section while
we unlock it because of setting user_feature fail.

Fixes: 95a7233c4 ("net: openvswitch: Set OvS recirc_id from tc chain index")
Cc: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Tested-by: Greg Rose <gvrose8192@gmail.com>
Acked-by: William Tu <u9012063@gmail.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 23f67b8fdeaa..3eed90bfa2bf 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1667,6 +1667,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 				ovs_dp_reset_user_features(skb, info);
 		}
 
+		ovs_unlock();
 		goto err_destroy_meters;
 	}
 
@@ -1683,7 +1684,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 
 err_destroy_meters:
-	ovs_unlock();
 	ovs_meters_exit(dp);
 err_destroy_ports_array:
 	kfree(dp->ports);
-- 
2.20.1

