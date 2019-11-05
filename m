Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6268EF0A3C
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 00:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbfKEXgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 18:36:07 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36564 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729494AbfKEXgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 18:36:07 -0500
Received: by mail-pl1-f195.google.com with SMTP id g9so10496530plp.3
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 15:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+dI7MiyBB+iXW8BQ+7ZKzCd+BTMCNqpW0pfsa8pFCAo=;
        b=nybYfJTawQJBbdoYSmA0BY7OktvgaHtDt/mYS58hsW0N6XIel76UQdFBjzP9TGKg0f
         9a60Yz0fHy1ycGVIBXk0BsrkyLw6U9mwHQCsIuzgZz+zYpxXR+qtH98SgqnBD7I3xhfA
         u0CGs6WhdbwtKvk/KqMQoyT5leJodW6ypm1tavP9XMpE4AxCTqzOr/8R9xhva6Q9X4Ie
         iD/wdbDJYYfI1Gm0gOvXFrCFjvz6MjJKOtUbDszImsT6gTxJzH04q4F4b6JzBtjg5u31
         1PHlQxJi+jyVNPRHPVvp8oN7i7ySuRdPAd/pBAbactut1qqjzxx9Ra964zdyBtecpFK+
         OHDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+dI7MiyBB+iXW8BQ+7ZKzCd+BTMCNqpW0pfsa8pFCAo=;
        b=N1LWP2MYiQb3vlCOobDeQNyCFoXL4VxDBpG18Pl7NDh72RxYFx/NZl/TFZn96NNt7Y
         zQw4gkLlts+kAcWhxQifqkzU7NiEFSI8+UYAp4oprNEXLlxenokf5eLpiItgeQ8Ecl3J
         xa8dI/UkpaNs1fn/sgFCAh0JOdMg+OgazHG2Zu0HwgdaEPXN11jqhY13bJJNifaSHqiL
         IxlWxMVmpZIMq7GQ81P1ZcXXmgwgUFZGRkOZF7/1E22nxk8FMH0e4eZKaeQ9uHJ+Iurn
         DiMk2RgwTsBdQJShQo9GRZfvCLHvlcOcFuUhYRS22lJQ2TmTjlr4e77fdK6qKb07G38H
         2VzQ==
X-Gm-Message-State: APjAAAXzf+iJPFgyLgJt8sHjir6ZXrJr8c1dz/+ht600gQk0FjbIO6Mh
        PgMxM7+2RSi7gN8K2kXCZ3bFP6FzuYE=
X-Google-Smtp-Source: APXvYqzt6M24pj2Xm/yQdLNplmm/0bPjcaqtdKevtytMhCUhgL+deRJ6ATe7eQ+b3by8vWZ8zXJJEw==
X-Received: by 2002:a17:902:ba91:: with SMTP id k17mr24528370pls.100.1572996966320;
        Tue, 05 Nov 2019 15:36:06 -0800 (PST)
Received: from sc9-mailhost2.vmware.com ([66.170.99.95])
        by smtp.gmail.com with ESMTPSA id q26sm17952175pgk.60.2019.11.05.15.36.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 05 Nov 2019 15:36:05 -0800 (PST)
From:   William Tu <u9012063@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dev@openvswitch.org, i.maximets@ovn.org, echaudro@redhat.com,
        bjorn.topel@intel.com, magnus.karlsson@intel.com
Subject: [PATCH net-next] xsk: Enable shared umem support.
Date:   Tue,  5 Nov 2019 15:35:38 -0800
Message-Id: <1572996938-23957-1-git-send-email-u9012063@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the shared umem feature is not supported in libbpf.
The patch removes the refcount check in libbpf to enable use of
shared umem.  Also, a umem can be shared by multiple netdevs,
so remove the checking at xsk_bind.

Tested using OVS at:
https://mail.openvswitch.org/pipermail/ovs-dev/2019-November/364392.html

Signed-off-by: William Tu <u9012063@gmail.com>
---
 net/xdp/xsk.c       |  5 -----
 tools/lib/bpf/xsk.c | 10 +++++-----
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 6040bc2b0088..0f2b16e275e3 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -697,11 +697,6 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 			sockfd_put(sock);
 			goto out_unlock;
 		}
-		if (umem_xs->dev != dev || umem_xs->queue_id != qid) {
-			err = -EINVAL;
-			sockfd_put(sock);
-			goto out_unlock;
-		}
 
 		xdp_get_umem(umem_xs->umem);
 		WRITE_ONCE(xs->umem, umem_xs->umem);
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 74d84f36a5b2..e6c4eb077dcd 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -579,16 +579,13 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	struct sockaddr_xdp sxdp = {};
 	struct xdp_mmap_offsets off;
 	struct xsk_socket *xsk;
+	bool shared;
 	int err;
 
 	if (!umem || !xsk_ptr || !rx || !tx)
 		return -EFAULT;
 
-	if (umem->refcount) {
-		pr_warn("Error: shared umems not supported by libbpf.\n");
-		return -EBUSY;
-	}
-
+	shared = !!(usr_config->bind_flags & XDP_SHARED_UMEM);
 	xsk = calloc(1, sizeof(*xsk));
 	if (!xsk)
 		return -ENOMEM;
@@ -687,6 +684,9 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	sxdp.sxdp_queue_id = xsk->queue_id;
 	sxdp.sxdp_flags = xsk->config.bind_flags;
 
+	if (shared)
+		sxdp.sxdp_shared_umem_fd = umem->fd;
+
 	err = bind(xsk->fd, (struct sockaddr *)&sxdp, sizeof(sxdp));
 	if (err) {
 		err = -errno;
-- 
2.7.4

