Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFF04D4809
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 14:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241582AbiCJN3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 08:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234416AbiCJN3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 08:29:43 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F49478050
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 05:28:42 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2dd2c5ef10eso40209217b3.14
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 05:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Y7gj1hh0DB6tOe5ZHLoKoc4NT1CoUMRgYUbu9GMxm2c=;
        b=PcVpr1GuJ8GWX7vf+TIimRwnGcf2+y85xAnLxuU2LUy2f3fQvacSZe04/oqKr+rH9u
         z+Mzxnr08X1dcLD0Jay42IB6TJ5iGT0POTC0ttrQUJB1d61SU9fVUqhqUXx0zC5okjsX
         0KX5+vyrQtwS5RL2K7LAYxFrds7AusjU+jQBzD48W1TRgQEmYztDpXMuKKywO7n/PaWb
         /NQ60qbU+NJGzv0bccEORsiLVxhvmwKtUg3rORQFjXWU+/SNjP/fFGAQoaL/T5JtfHRA
         MVach1kF0AFBZPtTCqeb/cE2ZeVUIJ1PzwUCGEeJCUamNwv40I1K6AkyAUKlmtSSS8rR
         NJMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Y7gj1hh0DB6tOe5ZHLoKoc4NT1CoUMRgYUbu9GMxm2c=;
        b=FIy7qw6yb4FY9CJesnIG6szaIHNWrCkQuTtISaFxnYpU08x7GpbDprvXbqh8j+SEZa
         wO4Hil9M3eVgf50bBsU5SsXPUAJGOybd6OpeNDdTTsLoXbWMW8sC0DpNpRHO6TY7ToB6
         2jn3Xab6JwcNmEL5K5x8laz7cWXr3Mw28APu8LuOw4nNw9UppevB7hwhDE2vITYuQTdn
         rZM5Lqr9pLTs36I38lImiiTnNqDjK45tdbrwtlN3haTy+JsmQAIZZAj3qNg5HlDleVFZ
         70VppUwf7GJoBQxu9+6bhMYysCU4G4HAlxGIDIf9tgtP26LDzBczmfWuLR3eNxTYmqYg
         9bdw==
X-Gm-Message-State: AOAM5332ZHcv5pmtS9wXxli5xFt31nL6+2g7+mZHABCCkqcIpk5NFVYQ
        SaPLzDYLoalkcPjINVdbody2XPtmkdk=
X-Google-Smtp-Source: ABdhPJzwtkhkPUqBI9gHc2Q828U5TjP3S4ysN896s6N7UbdNSqH6k6QsxiSTVNH6MbtAUxTir1E/uiQLaqI=
X-Received: from jiyong.seo.corp.google.com ([2401:fa00:d:11:f59e:134:eb7:e1d2])
 (user=jiyong job=sendgmr) by 2002:a25:7903:0:b0:622:3940:7c7c with SMTP id
 u3-20020a257903000000b0062239407c7cmr4031710ybc.334.1646918921467; Thu, 10
 Mar 2022 05:28:41 -0800 (PST)
Date:   Thu, 10 Mar 2022 22:28:29 +0900
Message-Id: <20220310132830.88203-1-jiyong@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2] vsock: each transport cycles only on its own sockets
From:   Jiyong Park <jiyong@google.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     adelva@google.com, Jiyong Park <jiyong@google.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When iterating over sockets using vsock_for_each_connected_socket, make
sure that a transport filters out sockets that don't belong to the
transport.

There actually was an issue caused by this; in a nested VM
configuration, destroying the nested VM (which often involves the
closing of /dev/vhost-vsock if there was h2g connections to the nested
VM) kills not only the h2g connections, but also all existing g2h
connections to the (outmost) host which are totally unrelated.

Tested: Executed the following steps on Cuttlefish (Android running on a
VM) [1]: (1) Enter into an `adb shell` session - to have a g2h
connection inside the VM, (2) open and then close /dev/vhost-vsock by
`exec 3< /dev/vhost-vsock && exec 3<&-`, (3) observe that the adb
session is not reset.

[1] https://android.googlesource.com/device/google/cuttlefish/

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Signed-off-by: Jiyong Park <jiyong@google.com>
---
Changes in v2:
  - Squashed into a single patch

 drivers/vhost/vsock.c            | 3 ++-
 include/net/af_vsock.h           | 3 ++-
 net/vmw_vsock/af_vsock.c         | 9 +++++++--
 net/vmw_vsock/virtio_transport.c | 7 +++++--
 net/vmw_vsock/vmci_transport.c   | 3 ++-
 5 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 37f0b4274113..e6c9d41db1de 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -753,7 +753,8 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
 
 	/* Iterating over all connections for all CIDs to find orphans is
 	 * inefficient.  Room for improvement here. */
-	vsock_for_each_connected_socket(vhost_vsock_reset_orphans);
+	vsock_for_each_connected_socket(&vhost_transport.transport,
+					vhost_vsock_reset_orphans);
 
 	/* Don't check the owner, because we are in the release path, so we
 	 * need to stop the vsock device in any case.
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index ab207677e0a8..f742e50207fb 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -205,7 +205,8 @@ struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr);
 struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
 					 struct sockaddr_vm *dst);
 void vsock_remove_sock(struct vsock_sock *vsk);
-void vsock_for_each_connected_socket(void (*fn)(struct sock *sk));
+void vsock_for_each_connected_socket(struct vsock_transport *transport,
+				     void (*fn)(struct sock *sk));
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
 bool vsock_find_cid(unsigned int cid);
 
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 38baeb189d4e..f04abf662ec6 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -334,7 +334,8 @@ void vsock_remove_sock(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(vsock_remove_sock);
 
-void vsock_for_each_connected_socket(void (*fn)(struct sock *sk))
+void vsock_for_each_connected_socket(struct vsock_transport *transport,
+				     void (*fn)(struct sock *sk))
 {
 	int i;
 
@@ -343,8 +344,12 @@ void vsock_for_each_connected_socket(void (*fn)(struct sock *sk))
 	for (i = 0; i < ARRAY_SIZE(vsock_connected_table); i++) {
 		struct vsock_sock *vsk;
 		list_for_each_entry(vsk, &vsock_connected_table[i],
-				    connected_table)
+				    connected_table) {
+			if (vsk->transport != transport)
+				continue;
+
 			fn(sk_vsock(vsk));
+		}
 	}
 
 	spin_unlock_bh(&vsock_table_lock);
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index fb3302fff627..5afc194a58bb 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -24,6 +24,7 @@
 static struct workqueue_struct *virtio_vsock_workqueue;
 static struct virtio_vsock __rcu *the_virtio_vsock;
 static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
+static struct virtio_transport virtio_transport; /* forward declaration */
 
 struct virtio_vsock {
 	struct virtio_device *vdev;
@@ -384,7 +385,8 @@ static void virtio_vsock_event_handle(struct virtio_vsock *vsock,
 	switch (le32_to_cpu(event->id)) {
 	case VIRTIO_VSOCK_EVENT_TRANSPORT_RESET:
 		virtio_vsock_update_guest_cid(vsock);
-		vsock_for_each_connected_socket(virtio_vsock_reset_sock);
+		vsock_for_each_connected_socket(&virtio_transport.transport,
+						virtio_vsock_reset_sock);
 		break;
 	}
 }
@@ -662,7 +664,8 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	synchronize_rcu();
 
 	/* Reset all connected sockets when the device disappear */
-	vsock_for_each_connected_socket(virtio_vsock_reset_sock);
+	vsock_for_each_connected_socket(&virtio_transport.transport,
+					virtio_vsock_reset_sock);
 
 	/* Stop all work handlers to make sure no one is accessing the device,
 	 * so we can safely call virtio_reset_device().
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 7aef34e32bdf..735d5e14608a 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -882,7 +882,8 @@ static void vmci_transport_qp_resumed_cb(u32 sub_id,
 					 const struct vmci_event_data *e_data,
 					 void *client_data)
 {
-	vsock_for_each_connected_socket(vmci_transport_handle_detach);
+	vsock_for_each_connected_socket(&vmci_transport,
+					vmci_transport_handle_detach);
 }
 
 static void vmci_transport_recv_pkt_work(struct work_struct *work)

base-commit: 3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b
-- 
2.35.1.723.g4982287a31-goog

