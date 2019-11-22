Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61D32106434
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbfKVGNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:13:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729516AbfKVGNy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 01:13:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3F7920707;
        Fri, 22 Nov 2019 06:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403233;
        bh=5PDxv2/YHr0FuhBfzhJ5z8m8H8XgdsUBLgg/TREY904=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPCEyiSzDAG0kp8PS1X9YxgJWMXVW40Xx8+Du3tVnsitWak7tBU19mcetK1nfCY1r
         IWL16f6V3ZvvV0jXswAGBtBPxl+l1fQKFL3/GAoIypnFNW5DzVMYIuXXF5YjiWWpWt
         YaY/F1PuWiIWM1uWsNPxEC8XaZ97v08cZCVVxY1A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 46/68] net/net_namespace: Check the return value of register_pernet_subsys()
Date:   Fri, 22 Nov 2019 01:12:39 -0500
Message-Id: <20191122061301.4947-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122061301.4947-1-sashal@kernel.org>
References: <20191122061301.4947-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 0eb987c874dc93f9c9d85a6465dbde20fdd3884c ]

In net_ns_init(), register_pernet_subsys() could fail while registering
network namespace subsystems. The fix checks the return value and
sends a panic() on failure.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net_namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 087ce1598b746..01bfe28b20a19 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -778,7 +778,8 @@ static int __init net_ns_init(void)
 
 	mutex_unlock(&net_mutex);
 
-	register_pernet_subsys(&net_ns_ops);
+	if (register_pernet_subsys(&net_ns_ops))
+		panic("Could not register network namespace subsystems");
 
 	rtnl_register(PF_UNSPEC, RTM_NEWNSID, rtnl_net_newid, NULL, NULL);
 	rtnl_register(PF_UNSPEC, RTM_GETNSID, rtnl_net_getid, rtnl_net_dumpid,
-- 
2.20.1

