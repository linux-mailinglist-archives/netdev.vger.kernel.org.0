Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E005C6E7980
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233072AbjDSMTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbjDSMTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:19:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CA65FCB
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 05:19:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5AFE6364E
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 12:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C70CC433EF;
        Wed, 19 Apr 2023 12:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681906759;
        bh=E26fVAtkfK4feWBOpmHcyLuT4z7Dfb4yOU8pU4A++Qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rA8Uuem9kTCT0GMJBEOdbux2RYyXfwY0Q7UBNMQ0gDG2/2Wl9m1jhNl2c2nAOuawG
         VkQSYBepITfD2HaYVBDTgyMWC6jh3tmsKDLoH0C1nvK0psw1o8f/uiYMFw3088oPWH
         jg2gBPjy41Dc3feo7u2dXnwEmwFd45+V0m/3dnd1JkoVyJpA48CIM2xMRIHI8FVCgU
         kuhe981AWyEVAP5xGyEjlyMTyk4tPEVwYEq0p3LoDu10AGgx1D0flc9Uw4jmcQQFSB
         YZtgUeJVm2Nbt7nDeTMvrOZsezKWBk1M3KaJL2e2EbhVia55duTeKHX0vSUwbmoUf2
         896mfeXJ7/olA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>
Subject: [PATCH xfrm 1/2] xfrm: release all offloaded policy memory
Date:   Wed, 19 Apr 2023 15:19:07 +0300
Message-Id: <c84041b660cf6b0f0886488e740cd43b0f21c341.1681906552.git.leon@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681906552.git.leon@kernel.org>
References: <cover.1681906552.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Failure to add offloaded policy will cause to the following
error once user will try to reload driver.

Unregister_netdevice: waiting for eth3 to become free. Usage count = 2

This was caused by xfrm_dev_policy_add() which increments reference
to net_device. That reference was supposed to be decremented
in xfrm_dev_policy_free(). However the latter wasn't called.

 unregister_netdevice: waiting for eth3 to become free. Usage count = 2
 leaked reference.
  xfrm_dev_policy_add+0xff/0x3d0
  xfrm_policy_construct+0x352/0x420
  xfrm_add_policy+0x179/0x320
  xfrm_user_rcv_msg+0x1d2/0x3d0
  netlink_rcv_skb+0xe0/0x210
  xfrm_netlink_rcv+0x45/0x50
  netlink_unicast+0x346/0x490
  netlink_sendmsg+0x3b0/0x6c0
  sock_sendmsg+0x73/0xc0
  sock_write_iter+0x13b/0x1f0
  vfs_write+0x528/0x5d0
  ksys_write+0x120/0x150
  do_syscall_64+0x3d/0x90
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: 919e43fad516 ("xfrm: add an interface to offload policy")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/xfrm/xfrm_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index d720e163ae6e..0e398a589536 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1980,6 +1980,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	if (err) {
 		xfrm_dev_policy_delete(xp);
+		xfrm_dev_policy_free(xp);
 		security_xfrm_policy_free(xp->security);
 		kfree(xp);
 		return err;
-- 
2.40.0

