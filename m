Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6664E642F6E
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbiLERsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbiLERrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:47:33 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9533724099
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:46:08 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id d13so8705091qvj.8
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 09:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5T3jnRIbqMbqd3rv79oWwfZVeKgpni8GVvT92hRYQT8=;
        b=oAPpWDNjt4QgQO/xbsWYtNYK0Zf3ry2Umkne4OgYm/wukSGBIFs66HxWUEchW1pmHf
         poyCuyPu59Xw7Aula7e8B7FGoQyL00z7EFrk7raxlniiRIzq5yEEUkdB2sBZtcCFLXmW
         +rv7LLKN78PCaRBjpMUrQo6PmVC9/ceOVWKFr7hsndinuHJIEFcI3BjbHZCiguOolw0/
         UZL2ibtnUJMPez+UGbaO0NzmNYLKjaAbbwOwOuK0dNLQiOtBTiGA23OGN/ZZvmKhvxzo
         1mnfRT3Ta0LRXgM6sT/KPbTJw6oD+RK0GVhqHJXL0RIVUKQfZk8o/Togin1Q5nidyI8N
         9oBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5T3jnRIbqMbqd3rv79oWwfZVeKgpni8GVvT92hRYQT8=;
        b=1LccymuJYAOndDCtBogHOHqHvOuSOu4VM168HxAtUpuPnU3/LNJJBfoc9vtA/V3u7A
         n4ph3NogVOVhFefpdWVcGfhQygmD+oizvbAUxxb5Czz7XuFSMQ+tkGesIZWlmhkXuGFS
         Xsq/6jTKE0GN3ms4OiZcGE9EPc/y/lJ6VM25b7I6aVr4mqRie8Tysbd0oqSv39iIOeSn
         kNd2QIByEgdZHkdEUEXtyPiRRp7nsYQTgIfwfctLqXuqvG4x6E1utNhgdquJlGlppEvB
         42x+zVfDKmwMOsvKPvD/0aFdEki7DxEFRCeMZ9d2JceyXvqg8WOu+svLr4E7+TfwPPCE
         nsUQ==
X-Gm-Message-State: ANoB5pkJqwBTnFZrhqtv+BZofpyi3iiaRxbCMgKHUHamFeNTyOJhfjHb
        Yd/IsjZAB/yZl3ql78fIyIYA/m85BfcReg==
X-Google-Smtp-Source: AA0mqf4QwxfqChlBW9eMgTB+nBC4JuThc6WzdgTDS5r1ZPA3Sc9IYSORYQ+GGDb38UGR2LCc9tlI6g==
X-Received: by 2002:a05:6214:5e0a:b0:4c7:51d4:e8d4 with SMTP id li10-20020a0562145e0a00b004c751d4e8d4mr10848713qvb.18.1670262367291;
        Mon, 05 Dec 2022 09:46:07 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i11-20020a05620a248b00b006ee949b8051sm13287895qkn.51.2022.12.05.09.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 09:46:06 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        LiLiang <liali@redhat.com>
Subject: [PATCH net] team: prevent ipv6 link local address on port devices
Date:   Mon,  5 Dec 2022 12:46:05 -0500
Message-Id: <32ee765d2240163f1cbd5d99db6233f276857ccb.1670262365.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The similar fix from commit c2edacf80e15 ("bonding / ipv6: no addrconf
for slaves separately from master") is also needed in Team. Otherwise,
DAD and RS packets to be sent from the slaves in turn can confuse the
switches and cause them to incorrectly update their forwarding tables
as Liang noticed in the test with activebackup mode.

Note that the patch also sets IFF_MASTER flag for Team dev accordingly
while IFF_SLAVE flag is set for port devs. Although IFF_MASTER flag is
not really used in Team, it's good to show in 'ip link':

  eth1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP>
  team0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP>

Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
Reported-by: LiLiang <liali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/team/team.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 62ade69295a9..5b187913cfec 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1127,6 +1127,7 @@ static void team_upper_dev_unlink(struct team *team, struct team_port *port)
 {
 	netdev_upper_dev_unlink(port->dev, team->dev);
 	port->dev->priv_flags &= ~IFF_TEAM_PORT;
+	port->dev->flags &= ~IFF_SLAVE;
 }
 
 static void __team_port_change_port_added(struct team_port *port, bool linkup);
@@ -1212,6 +1213,7 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 		goto err_port_enter;
 	}
 
+	port_dev->flags |= IFF_SLAVE;
 	err = dev_open(port_dev, extack);
 	if (err) {
 		netdev_dbg(dev, "Device %s opening failed\n",
@@ -1312,6 +1314,7 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 	dev_close(port_dev);
 
 err_dev_open:
+	port_dev->flags &= ~IFF_SLAVE;
 	team_port_leave(team, port);
 	team_port_set_orig_dev_addr(port);
 
@@ -2171,6 +2174,7 @@ static void team_setup(struct net_device *dev)
 	dev->ethtool_ops = &team_ethtool_ops;
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = team_destructor;
+	dev->flags |= IFF_MASTER;
 	dev->priv_flags &= ~(IFF_XMIT_DST_RELEASE | IFF_TX_SKB_SHARING);
 	dev->priv_flags |= IFF_NO_QUEUE;
 	dev->priv_flags |= IFF_TEAM;
-- 
2.31.1

