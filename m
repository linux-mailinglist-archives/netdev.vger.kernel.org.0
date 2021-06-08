Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E672139F06A
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFHIKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:10:07 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:40469 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhFHIKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:10:05 -0400
Received: by mail-lf1-f41.google.com with SMTP id w33so30732259lfu.7;
        Tue, 08 Jun 2021 01:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lnqh2KFBanSAc5Sbde66Uudde2Nu0b01lQi+nfaMyCU=;
        b=DqsatKiRTA/YuW1kJivNqJcOmvLcRweI14FJc9DaMPE/P2aovac65RbISuumMiu5a8
         pjFMf/BR4PlGm0tF4lLduN2WPzXcOSyh6TEzBwI7rnia+X9Cw2MNOS5OKtA+FOzhFfDE
         9D++TqnrsSWsQdteYwLcmQxWL6qb7ePxgc5hIUtPO3jj3cIjLP0fzFYZDn6uUxeYtpsS
         A8/7af2U8HhngQ2TB+Ra9mtc4Gkom6BgSbGWavnM2VQqHzGu70KFd6aHGkeWDFLMe6KK
         fRmEEcSmvAg1IH+6sgXpoB/cAd8IDTMHf5796y4X5jcj1H9CRV7+IybGnmPcEXvJqYUC
         wcEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lnqh2KFBanSAc5Sbde66Uudde2Nu0b01lQi+nfaMyCU=;
        b=PAM2WkUsYO+69ETuQqeIxcfwzOOEpeYlWF542mJG4wagWenPD0fT8ZYUkQIH2w0Olp
         UvRU0+KNwOSFNpBUb/oYRcnnYTd1mW1A2B1QQH3C2QJi3qYhh8OMPSBjB5Kpl44kqRcw
         FjsmaJjLmWgG/TIfpILAYdXGesKE3XISuj5D1PAXix0QssBrfWhHaYnMzwlKy1LyqATP
         nDfiBlaoMM7K4fz0wYkVsnrvoadLw8vUuluJ7JvA+kqxSQs4BxPB7CfUIWf13a/0QrmK
         qeaYXhFufOoY+zJSsdZ8jVxAXkpYVua89jMzTwtUK8FAJvZS8CyRAuV1VeyZuPbBvlzG
         J7Qg==
X-Gm-Message-State: AOAM532XsDqbqNz+VWRQ5i9jfhvMisEcPSRB1jTWKis6M1iFcr4t0zJj
        WKAnDb3OFcA1gf3fTa64CzA=
X-Google-Smtp-Source: ABdhPJzPIltCu2GVDqjHbfuKru8AgxKbx64lQuNgfgDY/ZF4T9YYZPAo6iVbKfqhTp6FzkKNUNZIxA==
X-Received: by 2002:a19:f509:: with SMTP id j9mr14691310lfb.80.1623139631179;
        Tue, 08 Jun 2021 01:07:11 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id k21sm521789lfu.38.2021.06.08.01.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 01:07:10 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com
Subject: [PATCH v2] net: rds: fix memory leak in rds_recvmsg
Date:   Tue,  8 Jun 2021 11:06:41 +0300
Message-Id: <20210608080641.16543-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <CF68E17D-CC8A-4B30-9B67-4A0B0047FCE1@oracle.com>
References: <CF68E17D-CC8A-4B30-9B67-4A0B0047FCE1@oracle.com>
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

Changes in v2:
	Changed goto to break.

---
 net/rds/recv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/recv.c b/net/rds/recv.c
index 4db109fb6ec2..5b426dc3634d 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -714,7 +714,7 @@ int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 
 		if (rds_cmsg_recv(inc, msg, rs)) {
 			ret = -EFAULT;
-			goto out;
+			break;
 		}
 		rds_recvmsg_zcookie(rs, msg);
 
-- 
2.31.1

