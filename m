Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BC339E7AA
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 21:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhFGTnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 15:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbhFGTnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 15:43:18 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB627C061574;
        Mon,  7 Jun 2021 12:41:15 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id e11so23759596ljn.13;
        Mon, 07 Jun 2021 12:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z8D7EP2ZXRo81V/Iibvxl9tc2KeLwiTlPeliqLE5Xwg=;
        b=Sqb1NYOa8vHwXP3ElbXmXIQUG9dhhuJtAdEv1ZZa1iQF+yHfhAwGBWXzd4x0FSrF5i
         xc4u7/dPLXxCCamCLIYTyx9HoXPBV/+EdFlDOfPHqWRWL5qE/1LWYlita4PVUw4nHhzA
         XhF3NbLx+eJ0ItCMTma0mkNDUbm72PyewEw9Yqc/nLCugMghg/CNkZSxkST9e60HnQ3c
         1rCv/ClYQrZOAyKYCq9AZiUa8CuC7Tuy6n8w3mNfI6O0he9dvS79olfTvUbF2UumoTJD
         Xb2SJvIt97DysKYl2475kcoR+tji2SVDzU81StRI5uTXR1nJLzEhOxXZT/GUQbaER9y0
         F7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z8D7EP2ZXRo81V/Iibvxl9tc2KeLwiTlPeliqLE5Xwg=;
        b=el6kLLHEGb4BFHPVeYcnFc3lkxIifkw7toSc66VUBcZ+VokWdUqPJ+sjzCUi4LIvbx
         /KCILDrgkWPd9ouegr3B4x9zYWfSYzQUt1h5n3VRTEgWnTlyrYM8feCoakFBWGujKp8A
         0eamnZzEc1hHs+AtLJdgYi1BqarNuBO5M2qVfUvyF4jr6Rgm2VjPCSnUCw0F4tfeGnAp
         pOi6WV2mhZjEUDX2GFos9uY/e3fQJbZKuosYgm+U2UBE6MN+dG4+YTEmvJ9BVDYhM4wZ
         UUK+JrrazWCbj7Z4XJmZtq2K6He98khVI83HhXq8PgI8OFf+DbFlNApTRSdEnrxxPrlZ
         r9dw==
X-Gm-Message-State: AOAM530SxLdqeSkLZWhYi4lZC7vqeCgaxtcM+g7Bbzg7t74M2X3cf+LC
        G4oQZF591K5f7KjK+jedPHI=
X-Google-Smtp-Source: ABdhPJw0gv5os//4zZ7uIHsRUPvsAoxDmXosX1GUW6X5G9iPQpPEnuEUpRJig52/WV+foGZSojv2cg==
X-Received: by 2002:a2e:9e57:: with SMTP id g23mr15942260ljk.123.1623094874132;
        Mon, 07 Jun 2021 12:41:14 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id k10sm1118272ljm.39.2021.06.07.12.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 12:41:13 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com
Subject: [PATCH] net: rds: fix memory leak in rds_recvmsg
Date:   Mon,  7 Jun 2021 22:41:02 +0300
Message-Id: <20210607194102.2883-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported memory leak in rds. The problem
was in unputted refcount in case of error.

int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
		int msg_flags)
{
...

	if (!rds_next_incoming(rs, &inc)) {
		...
	}

After this "if" inc refcount incremented and

	if (rds_cmsg_recv(inc, msg, rs)) {
		ret = -EFAULT;
		goto out;
	}
...
out:
	return ret;
}

in case of rds_cmsg_recv() fail the refcount won't be
decremented. And it's easy to see from ftrace log, that
rds_inc_addref() don't have rds_inc_put() pair in
rds_recvmsg() after rds_cmsg_recv()

 1)               |  rds_recvmsg() {
 1)   3.721 us    |    rds_inc_addref();
 1)   3.853 us    |    rds_message_inc_copy_to_user();
 1) + 10.395 us   |    rds_cmsg_recv();
 1) + 34.260 us   |  }

Fixes: bdbe6fbc6a2f ("RDS: recv.c")
Reported-and-tested-by: syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/rds/recv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rds/recv.c b/net/rds/recv.c
index 4db109fb6ec2..3fa16c339bfe 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -714,7 +714,7 @@ int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 
 		if (rds_cmsg_recv(inc, msg, rs)) {
 			ret = -EFAULT;
-			goto out;
+			goto out_put;
 		}
 		rds_recvmsg_zcookie(rs, msg);
 
@@ -740,6 +740,7 @@ int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		break;
 	}
 
+out_put:
 	if (inc)
 		rds_inc_put(inc);
 
-- 
2.31.1

