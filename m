Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2147F1B66
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 17:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732313AbfKFQeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 11:34:44 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43234 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbfKFQen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 11:34:43 -0500
Received: by mail-pl1-f196.google.com with SMTP id a18so10533242plm.10
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 08:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qK2dQSoweQbBBKHZOM7uNxvQiTxKcXN16AkZs90CTPw=;
        b=mvPBIFDDvlPAyFSjNne+7EcmXRpvCoQf5Es9SvuLssHr4t9fBXAiCw9BPnbNx12cJ1
         0aWh+klGwEHfzR/wLR3pEq90xwlm4LzrTLc8qiKu+ZOVjUo277f9PVJSyCSLrniUjCj4
         UBjFNEJex/Wp+FmQYL1Q1gHH9jBN6BScTikJM238CLPoQp4cAYszOqnyUhdhZWaJIK7z
         p5F6/6f4HbEgKlQDNpm2lXrH/CLo2yJahoMc5l154dWnP3hNnB8v//sr0mjuEbE/CIrt
         Y0X74yphim3vp/XO1UyUQcR/BESVW/uP+bEBhIi1SVkSX29GGG14YYArT41SiZlq+EJ9
         uldQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qK2dQSoweQbBBKHZOM7uNxvQiTxKcXN16AkZs90CTPw=;
        b=VO+Ilpj2jaIDbU+WtFUQw5Wpz21n872yKgEYUKrJ8E2uu4gZODlQheeWG8iAdMrlR3
         cQFsYel8obSCAEilQkmZOCHp2P1caYEk0XAS9wGpCIED0yLcuZNX4VVcfDGsQQ/dhLXX
         SJ6w/ocMjodU08oLRBB08RYchnsIiYhGFXh7XwAgbVkCf9LQGTo8sXBphZuVRYVozDj8
         zglR6+S6uphHzydCgE5tnZXrtNLLlstQxhKvn1fXoqBV3Sh6abo/3EAsh70jk0rY3KVM
         8JiRzIBaDsC31/uDg02DxSfFf2s7msX4FixBvNz30rwWPAkJhvK4k1toAaZOLd6szaUa
         AhPA==
X-Gm-Message-State: APjAAAWJoFHlbHSwC6ncZ3VmZvVq9D3ft8TmuARXf3JJfDfOSdaiOeh+
        FcFu1LxnLkjrxpkuQxFJ+ts=
X-Google-Smtp-Source: APXvYqz+kua88HsIlshoFzYFIrRMGNCGedCM93HhJqGZZwDdMkeYKsJhwXOlFi7U0dhvf2gjK+HF7A==
X-Received: by 2002:a17:902:a987:: with SMTP id bh7mr3425837plb.181.1573058082214;
        Wed, 06 Nov 2019 08:34:42 -0800 (PST)
Received: from local.opencloud.tech.localdomain ([1.203.173.208])
        by smtp.gmail.com with ESMTPSA id m67sm3261390pje.32.2019.11.06.08.34.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Nov 2019 08:34:41 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     ee07b291@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2] net: openvswitch: select vport upcall portid directly
Date:   Thu,  7 Nov 2019 00:34:28 +0800
Message-Id: <1573058068-7073-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The commit 69c51582ff786 ("dpif-netlink: don't allocate per
thread netlink sockets"), in Open vSwitch ovs-vswitchd, has
changed the number of allocated sockets to just one per port
by moving the socket array from a per handler structure to
a per datapath one. In the kernel datapath, a vport will have
only one socket in most case, if so select it directly in
fast-path.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
v2: drectly -> directly in the commit title
---
 net/openvswitch/vport.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 3fc38d16c456..5da9392b03d6 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -403,8 +403,9 @@ u32 ovs_vport_find_upcall_portid(const struct vport *vport, struct sk_buff *skb)
 
 	ids = rcu_dereference(vport->upcall_portids);
 
-	if (ids->n_ids == 1 && ids->ids[0] == 0)
-		return 0;
+	/* If there is only one portid, select it in the fast-path. */
+	if (ids->n_ids == 1)
+		return ids->ids[0];
 
 	hash = skb_get_hash(skb);
 	ids_index = hash - ids->n_ids * reciprocal_divide(hash, ids->rn_ids);
-- 
2.23.0

