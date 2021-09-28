Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DD441AF79
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240865AbhI1M5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:57:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240852AbhI1M5M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:57:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D820961209;
        Tue, 28 Sep 2021 12:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632833733;
        bh=Fs3VNYn5umW+YMZuXLhjRbr7s55rOpQRQOxWbxeldn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GIc7SzL/bSu4rmJn5/M5u0rCdv5W5jE5ko4AB4ACZI95zdiE0oCaHd4kHwoY6eoe/
         HViPGT+maGAj93oPnKpnTgmnjzcN1pGZkh06XdBA87uSqgcXRGMli7Ds3NhDhOah8g
         AJ98WQzTRRGLDzPu+g/MbFKso5Uw6RqB6Kgt7cQMbBsZrGNNAbtRGvr6Ymphr7F61R
         gTWRUHxYHQ5xiKnIf3hGcEGYOA6tfxzPc7w+ohURrw7lTNjc2tMS4JnNd38cKUbetu
         RRcgKPy9b+aneFHa2uBCxMZo6+9aujEGzcbz3MjWSp3h9OOlLHLh/2py0IPfJZK/Wt
         Iij2D0+j5B2cw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, pabeni@redhat.com,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        juri.lelli@redhat.com, netdev@vger.kernel.org
Subject: [RFC PATCH net-next 7/9] net: delay the removal of the name nodes until run_todo
Date:   Tue, 28 Sep 2021 14:54:58 +0200
Message-Id: <20210928125500.167943-8-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928125500.167943-1-atenart@kernel.org>
References: <20210928125500.167943-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keep the node name collision detection working until the last
registration stage, by delaying the removal of the name nodes in
run_todo. This allows to perform unregistration operations being
sensitive to name collisions, in run_todo. As run_todo has sections of
code running without the rtnl lock taken, this will allow to perform
some of those operations not under this lock (when possible).

While we move the removal of the name node until a late unregistration
stage, we still want to avoid returning a net device reference when it's
being unregistered (calling __dev_get_by_name for example). We keep this
logic by setting the node name dev reference to NULL. This follows the
logic of __dev_get_by_name. Altnames are in the same list, they are not
special here.

From now on we have to be strict on the use of __dev_get_by_name vs
netdev_name_node_lookup. One is designed to get the device, the other
one to lookup in the list of currently reserved names. Current users
should have been fixed by previous patches.

One side effect is there is now a window between unregistering the
netdevice and running the todo where names are still reserved and can't
be used for new device creation.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/dev.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 02f9d505dbe2..a1eab120bb50 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10611,10 +10611,15 @@ void netdev_run_todo(void)
 		if (dev->needs_free_netdev)
 			free_netdev(dev);
 
-		/* Report a network device has been unregistered */
 		rtnl_lock();
+		unlist_netdevice_name(dev);
+		synchronize_net();
+		netdev_name_node_free(dev->name_node);
+
 		dev_net(dev)->dev_unreg_count--;
 		__rtnl_unlock();
+
+		/* Report a network device has been unregistered */
 		wake_up(&netdev_unregistering_wq);
 
 		/* Free network device */
@@ -11039,7 +11044,12 @@ void unregister_netdevice_many(struct list_head *head)
 	list_for_each_entry(dev, head, unreg_list) {
 		/* And unlink it from device chain. */
 		unlist_netdevice(dev);
-		unlist_netdevice_name(dev);
+
+		/* Unreference the net device from the node name. From this
+		 * point on the node name is only used for naming collision
+		 * detection.
+		 */
+		dev->name_node->dev = NULL;
 
 		dev->reg_state = NETREG_UNREGISTERING;
 	}
@@ -11072,7 +11082,6 @@ void unregister_netdevice_many(struct list_head *head)
 		dev_mc_flush(dev);
 
 		netdev_name_node_alt_flush(dev);
-		netdev_name_node_free(dev->name_node);
 
 		if (dev->netdev_ops->ndo_uninit)
 			dev->netdev_ops->ndo_uninit(dev);
-- 
2.31.1

