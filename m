Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E21E24DEDA
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 19:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgHURrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 13:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgHURrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 13:47:41 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AABEC061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 10:47:41 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id g15so1204528plj.6
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 10:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=a8OwdJbq6UtF5fLgwb2XK+E8mnUyeFCCe7CNVV+4zz8=;
        b=f9n99AuoH2O8dyURfkLb6m/Eu+WocRsJpgcZKUjoclwCNJYzi52qse85F8aVVIJfzr
         nqC+6eGBduLWNwf1dlDCqv7IvM4I+6PBDImmW0+TJkygDXTylaKS3C9PzBSB4jw1AlRV
         MCDheM8YxZIRNRT/CNcN26JVfvymINv9uVtzR+GAPpMpobWw1u/52wstfn1RIRcFFTJ/
         H7AWsBq7Mbj4jOYEKkvhpF2Q1YHV05FC2TcOvWnK5/8XIr0IgSdflb/Mqyu2+iFfzKJU
         a0RVDIx7aFOAonfc2Ma8YzSSAlcyVLF5l/cmMGnDUbcCLNDoICnM5YNpdPPd+eICgLgN
         ImQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=a8OwdJbq6UtF5fLgwb2XK+E8mnUyeFCCe7CNVV+4zz8=;
        b=dXY1eYKWxYhk5lSmp4hv+ZAybJXO9hqCrFC0XYs7MiNganwBhMwU0+nFT3fm8kicLj
         9MxE2xCTc12hqFTAnOu9HZggUg+gFARzuhM/4EKxNqdncdeV9CqnYJ5JA7FnT+OsJLJ3
         0NxKNuoZfMOhwwPndHIioJtPVkFhn1VUXwQItRtkACq99lmUeLeDOABUVbuDB8KS0X6C
         yOgrvM1ieCoBhV8VHVKIrZZPS2UlxMYZGlSTGIDGQSM8rcIB+jcWbd0+3O49ZXPaYCTE
         CpCXEQ2c3/EgJTI2Rrt5YPqRR7NFpB6VTS479rqZPZyxUn+/0GvGqIIkqcb9aA3eiN2h
         ZOMw==
X-Gm-Message-State: AOAM533pra4DsOg/N5gQmJGpUaa8fE2EitZ9ntnDryT1t6nwda6ejS+p
        FxjbkH2F5Ga7JCRwnAmiKQ4CtH7sM7e+ZQ==
X-Google-Smtp-Source: ABdhPJzg8bIxfAsDJkBZmSATkNXE7DhFXRzXcW3Kvm8MQ6de9zZS/X/CNTKl00pKw3gdITZ5zP16aQ==
X-Received: by 2002:a17:902:8e8a:: with SMTP id bg10mr3245757plb.281.1598032060810;
        Fri, 21 Aug 2020 10:47:40 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id o38sm2794446pgb.38.2020.08.21.10.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 10:47:39 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next] ipvlan: advertise link netns via netlink
Date:   Fri, 21 Aug 2020 17:47:32 +0000
Message-Id: <20200821174732.8181-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assign rtnl_link_ops->get_link_net() callback so that IFLA_LINK_NETNSID is
added to rtnetlink messages.

Test commands:
    ip netns add nst
    ip link add dummy0 type dummy
    ip link add ipvlan0 link dummy0 type ipvlan
    ip link set ipvlan0 netns nst
    ip netns exec nst ip link show ipvlan0

Result:
    ---Before---
    6: ipvlan0@if5: <BROADCAST,MULTICAST> ...
        link/ether 82:3a:78:ab:60:50 brd ff:ff:ff:ff:ff:ff

    ---After---
    12: ipvlan0@if11: <BROADCAST,MULTICAST> ...
        link/ether 42:b1:ad:57:4e:27 brd ff:ff:ff:ff:ff:ff link-netnsid 0
                                                           ~~~~~~~~~~~~~~

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/ipvlan/ipvlan_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 5bca94c99006..60b7d93bb834 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -684,6 +684,13 @@ static const struct nla_policy ipvlan_nl_policy[IFLA_IPVLAN_MAX + 1] =
 	[IFLA_IPVLAN_FLAGS] = { .type = NLA_U16 },
 };
 
+static struct net *ipvlan_get_link_net(const struct net_device *dev)
+{
+	struct ipvl_dev *ipvlan = netdev_priv(dev);
+
+	return dev_net(ipvlan->phy_dev);
+}
+
 static struct rtnl_link_ops ipvlan_link_ops = {
 	.kind		= "ipvlan",
 	.priv_size	= sizeof(struct ipvl_dev),
@@ -691,6 +698,7 @@ static struct rtnl_link_ops ipvlan_link_ops = {
 	.setup		= ipvlan_link_setup,
 	.newlink	= ipvlan_link_new,
 	.dellink	= ipvlan_link_delete,
+	.get_link_net   = ipvlan_get_link_net,
 };
 
 int ipvlan_link_register(struct rtnl_link_ops *ops)
-- 
2.17.1

