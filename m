Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBD9381368
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbhENVwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:52:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230247AbhENVwo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 17:52:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72BDF6145B;
        Fri, 14 May 2021 21:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621029092;
        bh=UrQTKq6eDOpcEy53oylkG4Jq2Q9f5+I8Yceo4M4Zl+M=;
        h=Date:From:To:Cc:Subject:From;
        b=SCqmCHInnTLr81xmiVlFOGuH47epGHjG1lm1r9D1PR+yEk+H/cluUocXu7FzsJqVf
         GAfNUjLvLYr9GsuZBFCxGkh7ZcksKfP/aH1mn8posKFOd6ENFiGB1o+irdGwDfKGnR
         3xkSpjquNHLr0LbSsSalxzDbaOIqn4g9CLrbQxQ6SlDOt9CXPROxS9r6/Nb6uEEs5a
         9J2J6DxFqUoEr1myamupT6HdhQjT38XgsTd57RvnRSsGr0tXF4lkFFpfXov5nYR4Uq
         nTYKF0F0XYDreFWEMZsvAY3NuWN1gP/YrEMoll8XduxJe/AWugdQOA1M1veLdObnH8
         DBsE12z8EVbvg==
Date:   Fri, 14 May 2021 16:52:09 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     ceph-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] ceph: Replace zero-length array with flexible array
 member
Message-ID: <20210514215209.GA33310@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare
having a dynamically sized set of trailing elements in a structure.
Kernel code should always use “flexible array members”[1] for these
cases. The older style of one-element or zero-length arrays should
no longer be used[2].

Notice that, in this case, sizeof(au->reply_buf) translates to zero,
becase in the original code reply_buf is a zero-length array. Now that
reply_buf is transformed into a flexible array, the mentioned line of
code is now replaced by a literal 0.

Also, as a safeguard, explicitly assign NULL to
auth->authorizer_reply_buf, as no heap is allocated for it, therefore
it should not be accessible.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/ceph/auth_none.c | 4 ++--
 net/ceph/auth_none.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ceph/auth_none.c b/net/ceph/auth_none.c
index 70e86e462250..10ee16d2cbf0 100644
--- a/net/ceph/auth_none.c
+++ b/net/ceph/auth_none.c
@@ -111,8 +111,8 @@ static int ceph_auth_none_create_authorizer(
 	auth->authorizer = (struct ceph_authorizer *) au;
 	auth->authorizer_buf = au->buf;
 	auth->authorizer_buf_len = au->buf_len;
-	auth->authorizer_reply_buf = au->reply_buf;
-	auth->authorizer_reply_buf_len = sizeof (au->reply_buf);
+	auth->authorizer_reply_buf_len = 0;
+	auth->authorizer_reply_buf = NULL;
 
 	return 0;
 }
diff --git a/net/ceph/auth_none.h b/net/ceph/auth_none.h
index 4158f064302e..3c68c0ee3dab 100644
--- a/net/ceph/auth_none.h
+++ b/net/ceph/auth_none.h
@@ -16,7 +16,7 @@ struct ceph_none_authorizer {
 	struct ceph_authorizer base;
 	char buf[128];
 	int buf_len;
-	char reply_buf[0];
+	char reply_buf[];
 };
 
 struct ceph_auth_none_info {
-- 
2.27.0

