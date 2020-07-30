Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6235F2338E7
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730493AbgG3TV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730475AbgG3TV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:21:59 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8A6C061574;
        Thu, 30 Jul 2020 12:21:58 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 11so26728297qkn.2;
        Thu, 30 Jul 2020 12:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=agaThPhartfIHs0CEVdT0S0oqKuMNdJA/yYlXtKqgNk=;
        b=FyRMSHJbJlHdwbK7O7cNCShcgYOjQ/O59qUAUFfx4KS+mcIV0USH78zqh+JpriUN4P
         zUT87eXfKUEjQk6A+SJdwFOHRQ246AByRhfbIUWJtIIj27EJz78aucu4KRz3Ge6LzRzC
         5zD16l0ZqNaGBSbPH/V4IJrgHRlSuAgKV8OTIM/GBnQMGBg/No74TCnfKfX5SyySLuzv
         EmRaQtgF4mDtZBY9cB9aMePCezuNGr27rLbcFhvMIG2t7lwDGfSmTTTJlNoBhDxmxFjP
         i+u5Y2joONJm3KIpGVfSbUhLHLRNEtA0ZcqI5h/7kSe0/1k0cCmI2ZRfQ5EsUF8Rut2P
         DtUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=agaThPhartfIHs0CEVdT0S0oqKuMNdJA/yYlXtKqgNk=;
        b=IAhtleAp1AIn6EjLobIQiyNSWEQ2ALS5a9b96tUQQp8WL3QKMCVu59Fv+gVE6JxMIC
         7tTPlnTyJpIAQh3DA5At57X3pBKQmYr8cICXRQFBMFwU0tEDevwKaGm/lKcdXLYfMg/b
         bwqp4SFCfY1hSYrYgPf/R4wkoadgom3GKNrLpbgrf2fKGSGzRmTSAJr6LxufXLLcd096
         1xb5xxsWfIkvcizshTzEuyftIirZuuEPPRBq9PtoD0lxYceV02cUNAZgdeBGyA907YY/
         5teN/is0GEjfGJmAH9kDhptZyRpx1vuwOye1M+/0DnsMpg+tvHJnxYj08H+XigzgPOpE
         OtYg==
X-Gm-Message-State: AOAM532BZM8J5btHTErDYWFX+TY+PfEBcPPW3D4kjddkHHXElYnkSqMm
        5MAPZ3IhciVaNXGn8GbEwg==
X-Google-Smtp-Source: ABdhPJwWCgUMsoFCCaoH1/xFyEBTGW5Q+V6fazGvqkm22JCMJGkInRBxDqiFpodkc6+juDwBXBZwtg==
X-Received: by 2002:ae9:e507:: with SMTP id w7mr730223qkf.264.1596136918051;
        Thu, 30 Jul 2020 12:21:58 -0700 (PDT)
Received: from localhost.localdomain (c-76-119-149-155.hsd1.ma.comcast.net. [76.119.149.155])
        by smtp.gmail.com with ESMTPSA id c205sm4994572qkg.98.2020.07.30.12.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 12:21:57 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak in rds_notify_queue_get()
Date:   Thu, 30 Jul 2020 15:20:26 -0400
Message-Id: <20200730192026.110246-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rds_notify_queue_get() is potentially copying uninitialized kernel stack
memory to userspace since the compiler may leave a 4-byte hole at the end
of `cmsg`.

In 2016 we tried to fix this issue by doing `= { 0 };` on `cmsg`, which
unfortunately does not always initialize that 4-byte hole. Fix it by using
memset() instead.

Cc: stable@vger.kernel.org
Fixes: f037590fff30 ("rds: fix a leak of kernel memory")
Fixes: bdbe6fbc6a2f ("RDS: recv.c")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
Note: the "real" copy_to_user() happens in put_cmsg(), where
`cmlen - sizeof(*cm)` equals to `sizeof(cmsg)`.

Reference: https://lwn.net/Articles/417989/

$ pahole -C "rds_rdma_notify" net/rds/recv.o
struct rds_rdma_notify {
	__u64                      user_token;           /*     0     8 */
	__s32                      status;               /*     8     4 */

	/* size: 16, cachelines: 1, members: 2 */
	/* padding: 4 */
	/* last cacheline: 16 bytes */
};

 net/rds/recv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rds/recv.c b/net/rds/recv.c
index c8404971d5ab..aba4afe4dfed 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -450,12 +450,13 @@ static int rds_still_queued(struct rds_sock *rs, struct rds_incoming *inc,
 int rds_notify_queue_get(struct rds_sock *rs, struct msghdr *msghdr)
 {
 	struct rds_notifier *notifier;
-	struct rds_rdma_notify cmsg = { 0 }; /* fill holes with zero */
+	struct rds_rdma_notify cmsg;
 	unsigned int count = 0, max_messages = ~0U;
 	unsigned long flags;
 	LIST_HEAD(copy);
 	int err = 0;
 
+	memset(&cmsg, 0, sizeof(cmsg));	/* fill holes with zero */
 
 	/* put_cmsg copies to user space and thus may sleep. We can't do this
 	 * with rs_lock held, so first grab as many notifications as we can stuff
-- 
2.25.1

