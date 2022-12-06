Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858CF6440B7
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbiLFJxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235504AbiLFJwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:52:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3B0165BF;
        Tue,  6 Dec 2022 01:51:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7210CB818E8;
        Tue,  6 Dec 2022 09:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D8DC433B5;
        Tue,  6 Dec 2022 09:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320288;
        bh=wObvOxVgY81+JnwDbGQdVQsAyZ8ybz3FsHdnVYGLBTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SjShlCQdY9YHYUjKJ70RmSw09fK41/0q/l0uqInpbOswZKfgQ8HCpWnDM6jVmuM6/
         cCFd997iAUZAwVLCISvGqVLzum8F/QF34Pn2iRADXylvzq83yhOHQP/a3bkPeTy+VG
         X/lY2mWKCECt9efpntIz/sm1tpY0bLhFX9NMZx6gBHeMgS6QedT0j8l9r4TRKDYYsn
         vqdvsfYFgdrzdNR3WNz02qdOigKgNrfCeeNywrs44RVU5pO5J6mu4jrJJdH9s07c1H
         s7JYPhUu138GGX1AmIRhJbIyf6Te0SZSSYM/UePuO+dFfOPH7Isl+iKnrZs467sVK6
         aFxcvs6Q2ot2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 5/5] net: loopback: use NET_NAME_PREDICTABLE for name_assign_type
Date:   Tue,  6 Dec 2022 04:51:11 -0500
Message-Id: <20221206095112.987799-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221206095112.987799-1-sashal@kernel.org>
References: <20221206095112.987799-1-sashal@kernel.org>
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
index d192936b76cf..7863918592db 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -210,7 +210,7 @@ static __net_init int loopback_net_init(struct net *net)
 	int err;
 
 	err = -ENOMEM;
-	dev = alloc_netdev(0, "lo", NET_NAME_UNKNOWN, loopback_setup);
+	dev = alloc_netdev(0, "lo", NET_NAME_PREDICTABLE, loopback_setup);
 	if (!dev)
 		goto out;
 
-- 
2.35.1

