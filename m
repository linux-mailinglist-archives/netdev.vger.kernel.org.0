Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19ADC6440CF
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235653AbiLFJzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbiLFJyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:54:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE3E26AFA;
        Tue,  6 Dec 2022 01:51:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D67261601;
        Tue,  6 Dec 2022 09:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99076C433D6;
        Tue,  6 Dec 2022 09:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320302;
        bh=+8+Ux6nDxDfufnP+0mYx0tNmTaU1NGMLxRJgPue+i+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fs8HwPI2BvbF493Moyt1kquastMJC1vx4MMZNdHz5h1yOSu+ltH5piXZRH8/cJ/YM
         kYvwgaDpJkGaRmbKftoWNQirUdlOjE7NP+PYTvbN+IltvhGuJ+FQjpFNuXOVHeY5H6
         Nbj3voxAi7e3qZf352fWy3N79HJg9hlylLEa3Nk9eyz5StqOzYq6jCwITlq0IkGuRj
         kNLhFm858JnmIMnkHzV3ucBlhtNW5jR1yXj8qRQ5FFjJbP8hS+JtmSbJy4PxL7A3z1
         qe+p72OJJ3iZ8A3UuEQ6AWbYQjhz3e+duLs+eFlaAnUHdy9xpN/kPhlw8zwPyU1pPN
         siyiLalmJS2aA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/4] net: loopback: use NET_NAME_PREDICTABLE for name_assign_type
Date:   Tue,  6 Dec 2022 04:51:28 -0500
Message-Id: <20221206095128.987873-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221206095128.987873-1-sashal@kernel.org>
References: <20221206095128.987873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[ Upstream commit 31d929de5a112ee1b977a89c57de74710894bbbf ]

When the name_assign_type attribute was introduced (commit
685343fc3ba6, "net: add name_assign_type netdev attribute"), the
loopback device was explicitly mentioned as one which would make use
of NET_NAME_PREDICTABLE:

    The name_assign_type attribute gives hints where the interface name of a
    given net-device comes from. These values are currently defined:
...
      NET_NAME_PREDICTABLE:
        The ifname has been assigned by the kernel in a predictable way
        that is guaranteed to avoid reuse and always be the same for a
        given device. Examples include statically created devices like
        the loopback device [...]

Switch to that so that reading /sys/class/net/lo/name_assign_type
produces something sensible instead of returning -EINVAL.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/loopback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 30612497643c..daef41ce2349 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -206,7 +206,7 @@ static __net_init int loopback_net_init(struct net *net)
 	int err;
 
 	err = -ENOMEM;
-	dev = alloc_netdev(0, "lo", NET_NAME_UNKNOWN, loopback_setup);
+	dev = alloc_netdev(0, "lo", NET_NAME_PREDICTABLE, loopback_setup);
 	if (!dev)
 		goto out;
 
-- 
2.35.1

