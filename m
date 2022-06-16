Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278E054DBDB
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 09:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359399AbiFPHel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 03:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359463AbiFPHej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 03:34:39 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C902738
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 00:34:37 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id x4so753744pfj.10
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 00:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ac1YqhjN/8jt/FIqKqQl68yGfu9Y4o75Lcix15wsNpo=;
        b=f/G7O0zHvDI7aLzAZOX3467WVvsDUJyYMMMK3ZDLAVFDz++3XyZN4I8unSaSczDmcS
         WoLe2inNE/kY56r1oP9hCXqtVgd1OZtZiLg4HlfRfsx/LcH4FYw2wmGYZ2T1ejsQN75Y
         /pNQ9nDIa4nFr69axV2ynKev/klPeKYlY3a9YtokfwrwhxXt1/vTe5/2JNOVCPyj/IVw
         ky0swKC/qdPahaxH+E2rBuViJ9vf4lJUsM5bGxSz78tUzM7I2wxZBfi6nesN2QjB5FVK
         gVRItaajqMKgSkOK4GawslxrzXVuKvOyeFJtmSpv/2J+uxxCt4BDvPdv0jrn3wyBPorn
         iSqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ac1YqhjN/8jt/FIqKqQl68yGfu9Y4o75Lcix15wsNpo=;
        b=Le/wf9+WjF3XRJmKEGrJtikUE/af8e8XmwpUEScUt9Hpr8AAq7dz31kCB6r8gyaZiG
         I4M03WSLu9oCczLW0Lo6W8gdD9YxqxgvOu1PaEGX7N+KipfxtKxbyZlG61Q54gjKKDZP
         ARuR5QhregiinSbmrG6Tdv9r1vZkqsWkD5b+nWH4P4fWlA4SEVkSH66EoWX9SkSfG8L4
         IWnPpUeY/hfX9DGlof8JKrjxFzNRzxBrJ14rHS9G6Pe4LCcRSWtaI8zwExMSbfx/by/6
         qDyVt9HOlm2crZLN5wLg6X6y21OTCpXOsdRVL2wQ+QCvxhJeuijkJ0WAuCuvaVenYze5
         uTfA==
X-Gm-Message-State: AJIora9HEUyTlLww5iDSiJy4BPKYT7Oa8I+FNdO3Q0iVsUkYxxc/W+sl
        0gP3jduXEMLg/Aqs8SshSRs=
X-Google-Smtp-Source: AGRyM1tMawE1wvTj93Q583epzrlAbakJ3IAQvQRhrMoH3DmprqBwFSE70qtVNwbXExUKEXPA1oquOw==
X-Received: by 2002:a63:5b04:0:b0:3fc:61a1:da0d with SMTP id p4-20020a635b04000000b003fc61a1da0dmr3236907pgb.177.1655364877393;
        Thu, 16 Jun 2022 00:34:37 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a62:9af3:cae6:d868])
        by smtp.gmail.com with ESMTPSA id ij15-20020a170902ab4f00b00166304d082bsm927069plb.73.2022.06.16.00.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 00:34:36 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net: fix data-race in dev_isalive()
Date:   Thu, 16 Jun 2022 00:34:34 -0700
Message-Id: <20220616073434.1511461-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
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

dev_isalive() is called under RTNL or dev_base_lock protection.

This means that changes to dev->reg_state should be done with both locks held.

syzbot reported:

BUG: KCSAN: data-race in register_netdevice / type_show

write to 0xffff888144ecf518 of 1 bytes by task 20886 on cpu 0:
register_netdevice+0xb9f/0xdf0 net/core/dev.c:10050
lapbeth_new_device drivers/net/wan/lapbether.c:414 [inline]
lapbeth_device_event+0x4a0/0x6c0 drivers/net/wan/lapbether.c:456
notifier_call_chain kernel/notifier.c:87 [inline]
raw_notifier_call_chain+0x53/0xb0 kernel/notifier.c:455
__dev_notify_flags+0x1d6/0x3a0
dev_change_flags+0xa2/0xc0 net/core/dev.c:8607
do_setlink+0x778/0x2230 net/core/rtnetlink.c:2780
__rtnl_newlink net/core/rtnetlink.c:3546 [inline]
rtnl_newlink+0x114c/0x16a0 net/core/rtnetlink.c:3593
rtnetlink_rcv_msg+0x811/0x8c0 net/core/rtnetlink.c:6089
netlink_rcv_skb+0x13e/0x240 net/netlink/af_netlink.c:2501
rtnetlink_rcv+0x18/0x20 net/core/rtnetlink.c:6107
netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
netlink_unicast+0x58a/0x660 net/netlink/af_netlink.c:1345
netlink_sendmsg+0x661/0x750 net/netlink/af_netlink.c:1921
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg net/socket.c:734 [inline]
__sys_sendto+0x21e/0x2c0 net/socket.c:2119
__do_sys_sendto net/socket.c:2131 [inline]
__se_sys_sendto net/socket.c:2127 [inline]
__x64_sys_sendto+0x74/0x90 net/socket.c:2127
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x46/0xb0

read to 0xffff888144ecf518 of 1 bytes by task 20423 on cpu 1:
dev_isalive net/core/net-sysfs.c:38 [inline]
netdev_show net/core/net-sysfs.c:50 [inline]
type_show+0x24/0x90 net/core/net-sysfs.c:112
dev_attr_show+0x35/0x90 drivers/base/core.c:2095
sysfs_kf_seq_show+0x175/0x240 fs/sysfs/file.c:59
kernfs_seq_show+0x75/0x80 fs/kernfs/file.c:162
seq_read_iter+0x2c3/0x8e0 fs/seq_file.c:230
kernfs_fop_read_iter+0xd1/0x2f0 fs/kernfs/file.c:235
call_read_iter include/linux/fs.h:2052 [inline]
new_sync_read fs/read_write.c:401 [inline]
vfs_read+0x5a5/0x6a0 fs/read_write.c:482
ksys_read+0xe8/0x1a0 fs/read_write.c:620
__do_sys_read fs/read_write.c:630 [inline]
__se_sys_read fs/read_write.c:628 [inline]
__x64_sys_read+0x3e/0x50 fs/read_write.c:628
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x46/0xb0

value changed: 0x00 -> 0x01

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 20423 Comm: udevd Tainted: G W 5.19.0-rc2-syzkaller-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/core/dev.c       | 25 +++++++++++++++----------
 net/core/net-sysfs.c |  1 +
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 08ce317fcec89609f6f8e9335b3d9f57e813024d..8e6f2296120662eb91a918a26c18f4396194ad79 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -397,16 +397,18 @@ static void list_netdevice(struct net_device *dev)
 /* Device list removal
  * caller must respect a RCU grace period before freeing/reusing dev
  */
-static void unlist_netdevice(struct net_device *dev)
+static void unlist_netdevice(struct net_device *dev, bool lock)
 {
 	ASSERT_RTNL();
 
 	/* Unlink dev from the device chain */
-	write_lock(&dev_base_lock);
+	if (lock)
+		write_lock(&dev_base_lock);
 	list_del_rcu(&dev->dev_list);
 	netdev_name_node_del(dev->name_node);
 	hlist_del_rcu(&dev->index_hlist);
-	write_unlock(&dev_base_lock);
+	if (lock)
+		write_unlock(&dev_base_lock);
 
 	dev_base_seq_inc(dev_net(dev));
 }
@@ -10043,11 +10045,11 @@ int register_netdevice(struct net_device *dev)
 		goto err_uninit;
 
 	ret = netdev_register_kobject(dev);
-	if (ret) {
-		dev->reg_state = NETREG_UNREGISTERED;
+	write_lock(&dev_base_lock);
+	dev->reg_state = ret ? NETREG_UNREGISTERED : NETREG_REGISTERED;
+	write_unlock(&dev_base_lock);
+	if (ret)
 		goto err_uninit;
-	}
-	dev->reg_state = NETREG_REGISTERED;
 
 	__netdev_update_features(dev);
 
@@ -10329,7 +10331,9 @@ void netdev_run_todo(void)
 			continue;
 		}
 
+		write_lock(&dev_base_lock);
 		dev->reg_state = NETREG_UNREGISTERED;
+		write_unlock(&dev_base_lock);
 		linkwatch_forget_dev(dev);
 	}
 
@@ -10810,9 +10814,10 @@ void unregister_netdevice_many(struct list_head *head)
 
 	list_for_each_entry(dev, head, unreg_list) {
 		/* And unlink it from device chain. */
-		unlist_netdevice(dev);
-
+		write_lock(&dev_base_lock);
+		unlist_netdevice(dev, false);
 		dev->reg_state = NETREG_UNREGISTERING;
+		write_unlock(&dev_base_lock);
 	}
 	flush_all_backlogs();
 
@@ -10959,7 +10964,7 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 	dev_close(dev);
 
 	/* And unlink it from device chain */
-	unlist_netdevice(dev);
+	unlist_netdevice(dev, true);
 
 	synchronize_net();
 
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index e319e242dddf005492147fb066dbe0cfa56d2636..a3642569fe535f798e81708df55544a68039d09e 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -33,6 +33,7 @@ static const char fmt_dec[] = "%d\n";
 static const char fmt_ulong[] = "%lu\n";
 static const char fmt_u64[] = "%llu\n";
 
+/* Caller holds RTNL or dev_base_lock */
 static inline int dev_isalive(const struct net_device *dev)
 {
 	return dev->reg_state <= NETREG_REGISTERED;
-- 
2.36.1.476.g0c4daa206d-goog

