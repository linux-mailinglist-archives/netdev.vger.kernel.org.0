Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5BB9644072
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbiLFJwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235245AbiLFJvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:51:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05174B84E;
        Tue,  6 Dec 2022 01:50:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A947EB818E8;
        Tue,  6 Dec 2022 09:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF95C433B5;
        Tue,  6 Dec 2022 09:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320250;
        bh=ge5RUukD9XT75lLSEX4INDIWUIQdr5aLW7fIKhgF9ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XGHEiSXLBwnrk0uI9zkXQl3Ox7VAE9LteoG/U8Zjv3D3teTzxk0anMkLCfWvQ3XA8
         tys5RF5Cuk3At8NhEoZ7Lx6TWVp777uknw7Km1EO0CZD2bn4MsdOUBx+5XYj4GV1Ci
         O+bqThByBHgVMy65ybntn+THL4vGP4oRaZejT32XwoBJryKICWxDecNyaNtL7/bRx2
         cM/DTvMKZ4z0kMpD3otsdWh/FOmwPB0aG7BxOuqOpBsRSMUqWyO6NYqqOQbmNSddcY
         hNpIgqVnR9l8bbUiI6+nWPuiJZ3Z52MRCgGKIXPh4ag7FsgTXsPq8MByv63X0ZTzJL
         OpGw2v3VmGe1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/10] net: loopback: use NET_NAME_PREDICTABLE for name_assign_type
Date:   Tue,  6 Dec 2022 04:50:25 -0500
Message-Id: <20221206095027.987587-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221206095027.987587-1-sashal@kernel.org>
References: <20221206095027.987587-1-sashal@kernel.org>
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
index a1c77cc00416..498e5c8013ef 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -208,7 +208,7 @@ static __net_init int loopback_net_init(struct net *net)
 	int err;
 
 	err = -ENOMEM;
-	dev = alloc_netdev(0, "lo", NET_NAME_UNKNOWN, loopback_setup);
+	dev = alloc_netdev(0, "lo", NET_NAME_PREDICTABLE, loopback_setup);
 	if (!dev)
 		goto out;
 
-- 
2.35.1

