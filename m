Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66CC4C4A68
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242830AbiBYQTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240344AbiBYQTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:19:40 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44404D252
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 08:19:06 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id z4so5032741pgh.12
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 08:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CkORx6feTWcIVb/+J3IGkD/JXSP6RbiMUz2u262N/4s=;
        b=KuWNlQwSiSNR/B4DiD4iHvuAsy7Mv7JEWPMF4X5zzr6HDsnlZ19L5mrnFhtfEoHa0w
         VHIMoPMBTnIV3sN78ez1Le3jn7m1xJxTzS9o124W+0WEdnvgMZOm7ucbXfdkZpF/rUYV
         Vr3DrN/M9nY9UAEVzHiB2IioxcVBoWXWs7qwBIp6LHUDRiyiaza47N0of2Xv4T18mSi5
         8hQqDIiEMQPyfOev4jQjf4XxePM9Kpnl5GY5W21whi19phbefLcAriCm4IkkPr/2ELl1
         t55co4KIIeKWXBhTSMrs94xIotpNFsr3vpGYASiFw9XEhRPwyfkeMr2rqFhVJEvYUFe2
         m7fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CkORx6feTWcIVb/+J3IGkD/JXSP6RbiMUz2u262N/4s=;
        b=3/WQVYEXeT2J3orSyeLfqdEKu2xO/+eGut+V+0hX1+sBo/9plhOF1Og/uzSV4FYatw
         OipbY3c2PmW3r7J35fe2aP0MH4PYQlQOH8VnSubRHcaHhNF/v/+Qq0zL/h5ULRT1JUXY
         nz3Bg0ZIBF5csNL2NV9Yd8uSm8AdmJ55AGl0Yqoxw3WmVUaGaRW/L7nEW/6nYOCLcLhA
         GJE/fVLYOVu5vgxwAy+Uv/aFZCBlrEF/bMZ89dHZcIE5QHMrANOocoPMUdWh+ZROIp8u
         5ztkq+d9AgzTMZorm/lUgyE5vvQwP/6B4T8Po5O36jckKU2M3bV6cdKYUf3XnIui0IRL
         0+wQ==
X-Gm-Message-State: AOAM531eAL2xqTjGMIVxyxodMh1MSWgKlPOoTUK4gsH12R2v1jMc1G0Z
        paY0rThSRFEcsAzvlXoYGUAm0BA35/4=
X-Google-Smtp-Source: ABdhPJzm/HkPXpQCn+UNMSafc5IkDqZ8CfdApZ+Bq3GsB3mrJ7DHz5RV2BC6w9fnaic3evQEaG6jKA==
X-Received: by 2002:a63:3d81:0:b0:373:b34e:7d5e with SMTP id k123-20020a633d81000000b00373b34e7d5emr6739973pga.397.1645805946144;
        Fri, 25 Feb 2022 08:19:06 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a16e:cb94:cb11:b5e])
        by smtp.gmail.com with ESMTPSA id k7-20020a63ff07000000b00372dc67e854sm3183094pgi.14.2022.02.25.08.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 08:19:05 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net/sysctl: avoid two synchronize_rcu() calls
Date:   Fri, 25 Feb 2022 08:18:55 -0800
Message-Id: <20220225161855.489923-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Both rps_sock_flow_sysctl() and flow_limit_cpu_sysctl()
are using synchronize_rcu() right before freeing memory
either by vfree() or kfree()

They can switch to kvfree_rcu(ptr) and kfree_rcu(ptr) to benefit
from asynchronous mode, instead of blocking the current thread.

Note that kvfree_rcu(ptr) and kfree_rcu(ptr) eventually can
have to use synchronize_rcu() in some memory pressure cases.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sysctl_net_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index dbeb8ecbcd98f0aa6c02c650f925b05faf23ecad..7123fe7feeac634023d4e73247db0a20e3fcc383 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -103,8 +103,7 @@ static int rps_sock_flow_sysctl(struct ctl_table *table, int write,
 			if (orig_sock_table) {
 				static_branch_dec(&rps_needed);
 				static_branch_dec(&rfs_needed);
-				synchronize_rcu();
-				vfree(orig_sock_table);
+				kvfree_rcu(orig_sock_table);
 			}
 		}
 	}
@@ -142,8 +141,7 @@ static int flow_limit_cpu_sysctl(struct ctl_table *table, int write,
 				     lockdep_is_held(&flow_limit_update_mutex));
 			if (cur && !cpumask_test_cpu(i, mask)) {
 				RCU_INIT_POINTER(sd->flow_limit, NULL);
-				synchronize_rcu();
-				kfree(cur);
+				kfree_rcu(cur);
 			} else if (!cur && cpumask_test_cpu(i, mask)) {
 				cur = kzalloc_node(len, GFP_KERNEL,
 						   cpu_to_node(i));
-- 
2.35.1.574.g5d30c73bfb-goog

