Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6074D4769
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 13:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242175AbiCJMzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 07:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242164AbiCJMzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 07:55:46 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D852149BB6
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 04:54:45 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d2d45c0df7so40152747b3.1
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 04:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ALSEL9LuFnUnMtyCTwSaJ5peLevtVaPVQNw8s0gGmYc=;
        b=ci8JBoLY9CVkwI6WXFy9WtOx9m3rfVZc/kGB5sxqbJikGXlqbc4lL8FjBkbulP3Wbm
         XCqjKB1DTKQsf4zr9LLhVPtUs2H1Q5igDlig9ow2SaOD3uKfpvPozcH6QSWE9h/UsSTx
         TJMEy7Fz1F0gMKjinR5PgwpV0C/vzgcL/dcKMWy3D1UQyj/N7t6xmpAWUnFNAcYc9w1u
         z0akyImx3j1WsQUSGG2Fek+DO8Lhw6I5gUMRwosYpXXtRGKJZpvRgieHItv1Tloxlfhe
         mhXVVvrmpf1wh6O7hyXkJff152WH5obzk9NCzMovmD9QKt+CNtyHNmYqPQtSI9RGogDf
         9u9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ALSEL9LuFnUnMtyCTwSaJ5peLevtVaPVQNw8s0gGmYc=;
        b=JUZRGCKNmqdg473qWC1dX5pD2f3avtVo2wyIxBNQ+jJPLFCFs7hX1GwIgocD99mDVx
         tlvdyrYi/g2GZ/4t9sXH8+GrZJS5YSN/dUPvyO8LG8Q+9t2NsX19uye8Aa7DEq0XFNEr
         009CuTxSHGU9TaILjpu1b3e42kbBeO+9e8Y+E42gE/pFlQ0OdewVW4SXSz1YyGGGNo02
         xCjjXWuThUZBaq4bLdMvjUYt3SGyKfo8IrUJc81cisuyfS594YUsr0b/PrtOqRe7lP+k
         sHIqBt9s2Zg6FiY7mVZ323WQrmM2y06L+WmsMLmBRfMOTSdRdpV0kkreWY4bhynzlyBS
         QV5w==
X-Gm-Message-State: AOAM530go342960N1l9e7f0yYeWRrUBqPr/W9EEmbg+Gv36EnXvbnk3A
        4Zi4SHBn6KvfNV4ZMKnVvOYN5JBaDkY=
X-Google-Smtp-Source: ABdhPJzPy1RIfW7vIpIF4tXdPm5d7e8fNO6KZUOMpBotMG3yiqrhNGAMEiYKF5k+3RsRj8uhHhLJHGy3a/U=
X-Received: from jiyong.seo.corp.google.com ([2401:fa00:d:11:f59e:134:eb7:e1d2])
 (user=jiyong job=sendgmr) by 2002:a0d:c103:0:b0:2d6:43a0:ff33 with SMTP id
 c3-20020a0dc103000000b002d643a0ff33mr3664738ywd.13.1646916884383; Thu, 10 Mar
 2022 04:54:44 -0800 (PST)
Date:   Thu, 10 Mar 2022 21:54:24 +0900
In-Reply-To: <20220310125425.4193879-1-jiyong@google.com>
Message-Id: <20220310125425.4193879-2-jiyong@google.com>
Mime-Version: 1.0
References: <20220310125425.4193879-1-jiyong@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 1/2] vsock: each transport cycles only on its own sockets
From:   Jiyong Park <jiyong@google.com>
To:     sgarzare@redhat.com, stefanha@redhat.com, mst@redhat.com,
        jasowang@redhat.com, davem@davemloft.net, kuba@kernel.org
Cc:     adelva@google.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiyong Park <jiyong@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 drivers/vhost/vsock.c            | 4 ++++
 net/vmw_vsock/virtio_transport.c | 7 +++++++
 net/vmw_vsock/vmci_transport.c   | 5 +++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 37f0b4274113..853ddac00d5b 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -722,6 +722,10 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
 	 * executing.
 	 */
 
+	/* Only handle our own sockets */
+	if (vsk->transport != &vhost_transport.transport)
+		return;
+
 	/* If the peer is still valid, no need to reset connection */
 	if (vhost_vsock_get(vsk->remote_addr.svm_cid))
 		return;
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index fb3302fff627..61b24eb31d4b 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -24,6 +24,7 @@
 static struct workqueue_struct *virtio_vsock_workqueue;
 static struct virtio_vsock __rcu *the_virtio_vsock;
 static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
+static struct virtio_transport virtio_transport; /* forward declaration */
 
 struct virtio_vsock {
 	struct virtio_device *vdev;
@@ -357,11 +358,17 @@ static void virtio_vsock_event_fill(struct virtio_vsock *vsock)
 
 static void virtio_vsock_reset_sock(struct sock *sk)
 {
+	struct vsock_sock *vsk = vsock_sk(sk);
+
 	/* vmci_transport.c doesn't take sk_lock here either.  At least we're
 	 * under vsock_table_lock so the sock cannot disappear while we're
 	 * executing.
 	 */
 
+	/* Only handle our own sockets */
+	if (vsk->transport != &virtio_transport.transport)
+		return;
+
 	sk->sk_state = TCP_CLOSE;
 	sk->sk_err = ECONNRESET;
 	sk_error_report(sk);
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 7aef34e32bdf..cd2f01513fae 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -803,6 +803,11 @@ static void vmci_transport_handle_detach(struct sock *sk)
 	struct vsock_sock *vsk;
 
 	vsk = vsock_sk(sk);
+
+	/* Only handle our own sockets */
+	if (vsk->transport != &vmci_transport)
+		return;
+
 	if (!vmci_handle_is_invalid(vmci_trans(vsk)->qp_handle)) {
 		sock_set_flag(sk, SOCK_DONE);
 
-- 
2.35.1.723.g4982287a31-goog

