Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5ADA41AF7A
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240867AbhI1M5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:57:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240852AbhI1M5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:57:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B83EB6120D;
        Tue, 28 Sep 2021 12:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632833736;
        bh=jB/QpcfxY9y6Dmusvk7HAqbu8vgl9cqrzA7TMCLGhHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t66YjspOHwZxtfV15xwYG188/MswDWJTGbmujXPE7G7/2TiSL5P0kWn7vdR3VD1s1
         99kyrBeEqMhUrQjp+YBpgMRbJKaQTOUMbTbSdtRbUtkkFWtH80vWcT7bV9s1OL8e5C
         bzo5vlqtX3jR9isUK//AWIWPZMaEFyQPvwqha+twVRbGdLPfVZuU3rlYwAd9Hh0Tuz
         6PJEw5cm+qmpNhRKwqEhwysXDQM9INrtfWWC3qaXeTaKLQfwEehcGnVbeX+PnKsYF0
         UCVsIm40zGPk/QGIvScFrESer5sNCjDMVYhopgkxF48AJVUValAYd4UVGNDe3tgEDv
         sPBNoejNwJRUg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, pabeni@redhat.com,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        juri.lelli@redhat.com, netdev@vger.kernel.org
Subject: [RFC PATCH net-next 8/9] net: delay device_del until run_todo
Date:   Tue, 28 Sep 2021 14:54:59 +0200
Message-Id: <20210928125500.167943-9-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928125500.167943-1-atenart@kernel.org>
References: <20210928125500.167943-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the deletion of the device from unregister_netdevice_many to
netdev_run_todo and move it outside the rtnl lock.

12 years ago was reported an ABBA deadlock between net-sysfs and the
netdevice unregistration[1]. The issue was the following:

              A                            B

   unregister_netdevice_many         sysfs access
   rtnl_lock                         sysfs refcount
				     rtnl_lock
   drain sysfs files
   => waits for B                    => waits for A

This was avoided thanks to two patches[2][3], which used rtnl_trylock in
net-sysfs and restarted the syscall when the rtnl lock was already
taken. This way kernfs nodes were not blocking the netdevice
unregistration anymore.

This was fine at the time but is now causing some issues: creating and
moving interfaces makes userspace (systemd, NetworkManager or others) to
spin a lot as syscalls are restarted, which has an impact on
performance. This happens for example when creating pods. While
userspace applications could be improved, fixing this in-kernel has the
benefit of fixing the root cause of the issue.

The sysfs removal is done in device_del, and moving it outside of the
rtnl lock does fix the initial deadlock. With that the trylock/restart
logic can be removed in a following-up patch.

[1] https://lore.kernel.org/netdev/49A4D5D5.5090602@trash.net/
(I'm referencing the full thread but the sysfs issue was discussed later
in the thread).
[2] 336ca57c3b4e ("net-sysfs: Use rtnl_trylock in sysfs methods.")
[3] 5a5990d3090b ("net: Avoid race between network down and sysfs")

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/dev.c       | 2 ++
 net/core/net-sysfs.c | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a1eab120bb50..d774fbec5d63 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10593,6 +10593,8 @@ void netdev_run_todo(void)
 			continue;
 		}
 
+		device_del(&dev->dev);
+
 		dev->reg_state = NETREG_UNREGISTERED;
 
 		netdev_wait_allrefs(dev);
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 21c3fdeccf20..e754f00c117b 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1955,8 +1955,6 @@ void netdev_unregister_kobject(struct net_device *ndev)
 	remove_queue_kobjects(ndev);
 
 	pm_runtime_set_memalloc_noio(dev, false);
-
-	device_del(dev);
 }
 
 /* Create sysfs entries for network device. */
-- 
2.31.1

