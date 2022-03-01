Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C002C4C96A6
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 21:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbiCAUZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 15:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238888AbiCAUX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 15:23:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E0B8F981;
        Tue,  1 Mar 2022 12:21:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59E9E60C1E;
        Tue,  1 Mar 2022 20:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7C9C340F1;
        Tue,  1 Mar 2022 20:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646166071;
        bh=RvXug01H9kluAEqabwUZGjwgNYTE/wBoZUtVrQZmwb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pd2p17hyUgQUU8QgN9hPriWSLOlFECl0x2q1QPw6jCtHIl6QkOS93cUHecaz9knO1
         Z4sVFWwam78nkZAtUOx8LMY7RYKs3yqO4hS8Ue6pzZnrjZEwfuvDkLO92eCAm32bzM
         k+mNS5ehK8gvKeh5kj+SkZFDS/OfXKU6376Uqmcteo4+4yDkacFv5IV7Xu+sOuU6KJ
         K7qkomWjjXA9nDVn1pY4DwWCjyOuZt/qPpd5rapMMsyHIT9BALyeODRW+sBN4rK57/
         n2onTDHJFuFvAmYG5H0ItQZ8U0ixVAx4LyiJpk3lv/n4eLoKhmPp4GAqAQxGmcNwYy
         AliO66PVrC0qQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Paul Durrant <paul@xen.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, wei.liu@kernel.org,
        davem@davemloft.net, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 4/7] Revert "xen-netback: remove 'hotplug-status' once it has served its purpose"
Date:   Tue,  1 Mar 2022 15:20:42 -0500
Message-Id: <20220301202046.19220-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301202046.19220-1-sashal@kernel.org>
References: <20220301202046.19220-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>

[ Upstream commit 0f4558ae91870692ce7f509c31c9d6ee721d8cdc ]

This reverts commit 1f2565780e9b7218cf92c7630130e82dcc0fe9c2.

The 'hotplug-status' node should not be removed as long as the vif
device remains configured. Otherwise the xen-netback would wait for
re-running the network script even if it was already called (in case of
the frontent re-connecting). But also, it _should_ be removed when the
vif device is destroyed (for example when unbinding the driver) -
otherwise hotplug script would not configure the device whenever it
re-appear.

Moving removal of the 'hotplug-status' node was a workaround for nothing
calling network script after xen-netback module is reloaded. But when
vif interface is re-created (on xen-netback unbind/bind for example),
the script should be called, regardless of who does that - currently
this case is not handled by the toolstack, and requires manual
script call. Keeping hotplug-status=connected to skip the call is wrong
and leads to not configured interface.

More discussion at
https://lore.kernel.org/xen-devel/afedd7cb-a291-e773-8b0d-4db9b291fa98@ipxe.org/T/#u

Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Paul Durrant <paul@xen.org>
Link: https://lore.kernel.org/r/20220222001817.2264967-1-marmarek@invisiblethingslab.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/xenbus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 78c56149559ce..6b678ab0a31f7 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -499,6 +499,7 @@ static void backend_disconnect(struct backend_info *be)
 		unsigned int queue_index;
 
 		xen_unregister_watchers(vif);
+		xenbus_rm(XBT_NIL, be->dev->nodename, "hotplug-status");
 #ifdef CONFIG_DEBUG_FS
 		xenvif_debugfs_delif(vif);
 #endif /* CONFIG_DEBUG_FS */
-- 
2.34.1

