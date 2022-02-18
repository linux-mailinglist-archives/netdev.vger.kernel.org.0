Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F044BB2C9
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 08:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiBRHCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 02:02:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiBRHCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 02:02:12 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04BA17AB3
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 23:01:54 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id y11so1635815pfa.6
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 23:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FGNvQsrD1bSTYYeyxoUueU7G5Ak4FXULke0q6ShFb+A=;
        b=mgQYho6bowg8A64b4jzl2ywlaSliZjeHp8GGuLFAs7tBDzTmvb7KQMG/nG6tzLumq5
         Pssvd98mCwWxLp+HMlmhKQe95Tq+Spg5XxjtEuSAY+v0Z/MKxOgiAuQL5YWUL7P4f9+s
         W6/WaUeGpvzS3DHSemfdZYKSRt2DX8g1wpD6912T0av6Vyd106bJJBcT8qLirZhEddTE
         NzIZbq02/lN2Yo/H48EixF5iUSOCetOfb8dujuNg4odtmNltRGBZNAkcvqDttHjOt/Yl
         oKb5FcykuZ+tVuVNaNAScwsg76rUF286ML2h0/bM4HVmjzKJKDRK93wQmWSFXc6/6SQQ
         kQuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FGNvQsrD1bSTYYeyxoUueU7G5Ak4FXULke0q6ShFb+A=;
        b=2yMdHkWmJBjlQ0OWzgw8NrFLDQknVA7n7dKE+c0vyA68cDDuRjRjZxb7Lz+af1Eqdw
         upS0k/Vyqrqjzx1D3Zrwk0NGTtowSuBOeVuTOi60DVt/MOVJyX/2vsEHIv6MyglEipBp
         +0wALgAj8j2rQssggKUO4DKJAQro0WUzRH8RIlq5xsfsQjo1OrlivBUO8zmPm/XEd7Qn
         CVp+wYgngm7I8b43C1NfHtkx5iZtOy4x2GLL3JHtFl6iZUVd/jLAkCSirgkq3Y5wbPrQ
         7F2CVQAWmzc0bTHph6o8nZteFXB4Gl1Bi+6kunibdmvUhpkDuQWcBPqX+V1yqozFnCWE
         ytJw==
X-Gm-Message-State: AOAM530o6DZyl+11kv7MCEzqQY89OLfYv4yDdOx77pqVs+DaF8usK2A7
        gEZ/HKWAHwwpWsjrckuo/3s=
X-Google-Smtp-Source: ABdhPJz3PnsL+NWUrPAxzKJ+DQP3T5XmUhinFt/xUEbjapAwyMhfz03cqrzcSAYyNpLzkVGNVMrDPg==
X-Received: by 2002:a63:3111:0:b0:373:a1fa:8998 with SMTP id x17-20020a633111000000b00373a1fa8998mr5214867pgx.415.1645167714282;
        Thu, 17 Feb 2022 23:01:54 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5c60:79a8:8f41:618f])
        by smtp.gmail.com with ESMTPSA id f16sm1882021pfa.147.2022.02.17.23.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 23:01:53 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next] bridge: switch br_net_exit to batch mode
Date:   Thu, 17 Feb 2022 23:01:50 -0800
Message-Id: <20220218070150.2628980-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
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

cleanup_net() is competing with other rtnl users.

Instead of calling br_net_exit() for each netns,
call br_net_exit_batch() once.

This gives cleanup_net() ability to group more devices
and call unregister_netdevice_many() only once for all bridge devices.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index 1fac72cc617ff7e1851b715860a95e9a1247b9b1..b1dea3febeea49f4e0882a1df64e09fc1db6b3b4 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -342,23 +342,26 @@ void br_opt_toggle(struct net_bridge *br, enum net_bridge_opts opt, bool on)
 		clear_bit(opt, &br->options);
 }
 
-static void __net_exit br_net_exit(struct net *net)
+static void __net_exit br_net_exit_batch(struct list_head *net_list)
 {
 	struct net_device *dev;
+	struct net *net;
 	LIST_HEAD(list);
 
 	rtnl_lock();
-	for_each_netdev(net, dev)
-		if (netif_is_bridge_master(dev))
-			br_dev_delete(dev, &list);
+
+	list_for_each_entry(net, net_list, exit_list)
+		for_each_netdev(net, dev)
+			if (netif_is_bridge_master(dev))
+				br_dev_delete(dev, &list);
 
 	unregister_netdevice_many(&list);
+
 	rtnl_unlock();
-
 }
 
 static struct pernet_operations br_net_ops = {
-	.exit	= br_net_exit,
+	.exit_batch	= br_net_exit_batch,
 };
 
 static const struct stp_proto br_stp_proto = {
-- 
2.35.1.265.g69c8d7142f-goog

