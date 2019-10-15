Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55C4AD918D
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393348AbfJPMux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:50:53 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38735 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391437AbfJPMuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 08:50:52 -0400
Received: by mail-pf1-f196.google.com with SMTP id h195so14677535pfe.5
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 05:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OQEEYsmRkKzu9TtGovz6XYfXyWzBs/Q6P9JLMlXDN7c=;
        b=THQbjyNNODM4ft1lCIR+4gihbs0/iyMMaFt87VNbFIGUarRgqNIunYC52PdAjQpnf1
         IY5u2RRRyTUcRt02Hs/gAqmdSOsZCTPylHWeSaHNKZSlLzeK8UrR89nt/HncFEtZF0Sa
         h/QsVpQlKCfGJrWzfcwl5EiOBnyw9/95glxVNm7MsLL3F5G3Z/53VFmp9LRM77vwqxg6
         ymXF+hQqGeBHyxHk0IAAGc6QsVgbnv15k+F7UJgUm42Vyq1qVU7RVs0MVKh/sYZHjHKz
         yjFNlioDiLemoBtgjEfd7lG5VEON4R6Q5Xdj6TEIDp/6u48g4lHH8qWbHoe6x/yKHYL1
         1oGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OQEEYsmRkKzu9TtGovz6XYfXyWzBs/Q6P9JLMlXDN7c=;
        b=r7oUhLDr/Qlw0n4xfluN5G2jifvOweXZ1p+06Gh9iPh/WfwE/06y/lOdrZwEeAIpv0
         f2t6YW4muIWWMi8NsX1XwftJ6P4LxyA8wRTyznqEzzK2Bv86QkBsWKgm2UD742rF5uUJ
         wq6aMGbSrOuJtW6rh9C1s43+UqCJRwxM9dKTMDbZhyAOPmTUGffI/uOWPnzNgWDMtIto
         VI77iP/musyCk/CYs6bw8wdQjzhVGdobRba/zLpsJQrP16UND1tbBG5mYDEW20XtuC8c
         Eu8/ltl8qTo3uJAXii75D/scxYsFsNta3zV8WZX8GpZ83zTXhBmQLNVOvbG8cFbs4NqS
         bgMg==
X-Gm-Message-State: APjAAAXkBZIGXI2K0GCbV2tQC5K0h7ZZ3IPWa06yHz2G4Otn9tvMSNSC
        kHsY/gbwN3y5g2OUrPZOAU4=
X-Google-Smtp-Source: APXvYqxDgjBARu93kHuKXrdpTZif6XCSPRIn/F7fIT/5cxDFtNYmvU4NKR3lrDZZ3yT90z5mZl2Klg==
X-Received: by 2002:a62:4d04:: with SMTP id a4mr44307154pfb.60.1571230250981;
        Wed, 16 Oct 2019 05:50:50 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d19sm2747339pjz.5.2019.10.16.05.50.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 05:50:50 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Paul Blakey <paulb@mellanox.com>
Subject: [PATCH net-next v4 09/10] net: openvswitch: don't unlock mutex when changing the user_features fails
Date:   Tue, 15 Oct 2019 18:30:39 +0800
Message-Id: <1571135440-24313-10-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
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

