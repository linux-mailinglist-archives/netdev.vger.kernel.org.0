Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46EF6118B7C
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 15:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfLJOuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 09:50:21 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33033 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727145AbfLJOuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 09:50:21 -0500
Received: by mail-pg1-f196.google.com with SMTP id 6so9028850pgk.0
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 06:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=d/sFjGcUkhT3L4fkcva+WJBqGZwTGpVVTgTSnXLnUII=;
        b=RKiGnir5WPQP0O37KQe7LAbvc4ssrESo2aglUSEkAqauruWQflZXRSGmILZdzVlv2q
         OlLZ+fkYUp6Z7W61JRgRhvHSpONlZFbzr/qVzsUp4Q2Us+EtAuLVjkcIMRe9kPvTE/CI
         DWZRAartp9+KMKZK1waXSui9CNNmMOyJgSAHKJnR1+kBeaS8FqGcCbW4UcZTP8mcO8Qx
         Pm7X01Aq59KBtVksBGXZp06lTjo+DNObMK5DJ6uhWaawZYN+Jhq4uQaPLDhdWT9LjOuF
         1L+4TTZNlD3bIsnH1/9Zrq3s5ARHRadsZms5bj9kqNTjWWR933M2pUCxP//VLqED1+fG
         CI9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=d/sFjGcUkhT3L4fkcva+WJBqGZwTGpVVTgTSnXLnUII=;
        b=Zb4YK9KZa3qARPwUAnu7sYdeS6jmsWJd7h15jsuH1n4Xh8rwXzVu3ll7OL0CTJgQOd
         iK7+pY4S2gCy2IEHgm3TXuKbDxJRKAQVP2Ex7yZERJibpnimBtd5cWf70sPEFNKPGJst
         IuG+2zkebFAoEv51m3AxpILS3DkagSmpo4n2zU3zEQnD2fqnAIG1zdobsY7xH7NlWbJb
         j1kmSU2pjhkc2dTgmW/M6ox3YgLdcdKRu3TokIBCtq8i3kCEldjWelJqWKq5Mx/U85nb
         +LflS1yP85y12XSh+8xEmw19UvhefNGRNkq27E2XpMKiL+p3YkwbTP5DBTIFVpUQI3Ma
         +Pvg==
X-Gm-Message-State: APjAAAX0m987bMAeLnFVmtV6tY3zjYGgCIoj3gbuv9cJ6DzgGKccxDqa
        5tLl6drxdgEawH4TL5m4YUw=
X-Google-Smtp-Source: APXvYqzc9CmNgf2JzjIDpi3Elf4oRxVbF6zcp/J7fKrKyPzUtTUBmT1x26vSlmDveUxEoLeJJ0eHsw==
X-Received: by 2002:aa7:9a99:: with SMTP id w25mr32661637pfi.94.1575989420522;
        Tue, 10 Dec 2019 06:50:20 -0800 (PST)
Received: from local.opencloud.tech.localdomain ([115.171.62.114])
        by smtp.gmail.com with ESMTPSA id p16sm3694384pgi.50.2019.12.10.06.50.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Dec 2019 06:50:19 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     markb@mellanox.com, saeedm@dev.mellanox.co.il
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next] net/mlx5e: Support accept action on nic table
Date:   Tue, 10 Dec 2019 22:49:42 +0800
Message-Id: <1575989382-7195-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

In one case, we may forward packets from one vport
to others, but only one packets flow will be accepted,
which destination ip was assign to VF.

+-----+     +-----+            +-----+
| VFn |     | VF1 |            | VF0 | accept
+--+--+     +--+--+  hairpin   +--^--+
   |           | <--------------- |
   |           |                  |
+--+-----------v-+             +--+-------------+
|   eswitch PF1  |             |   eswitch PF0  |
+----------------+             +----------------+

tc filter add dev $PF0 protocol all parent ffff: prio 1 handle 1 \
	flower skip_sw action mirred egress redirect dev $VF0_REP
tc filter add dev $VF0 protocol ip  parent ffff: prio 1 handle 1 \
	flower skip_sw dst_ip $VF0_IP action pass
tc filter add dev $VF0 protocol all parent ffff: prio 2 handle 2 \
	flower skip_sw action mirred egress redirect dev $VF1

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0d5d84b..f91e057e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2839,6 +2839,10 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
+		case FLOW_ACTION_ACCEPT:
+			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			break;
 		case FLOW_ACTION_DROP:
 			action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
 			if (MLX5_CAP_FLOWTABLE(priv->mdev,
-- 
1.8.3.1

