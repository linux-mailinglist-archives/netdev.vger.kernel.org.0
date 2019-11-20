Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB171103093
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 01:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfKTAKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 19:10:49 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43057 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfKTAKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 19:10:48 -0500
Received: by mail-wr1-f68.google.com with SMTP id n1so25997980wra.10;
        Tue, 19 Nov 2019 16:10:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MoB+EnvvzF+TKOzDdDl2FIhJAJ8fgDbMtbJ023hVTI4=;
        b=n6HD1bl3yqCxiiZi/5cAU7oaqd3YvVeEzm0imWuGoncldGWUBcBJFY+tUYFnUvc6NR
         ruC3CkPh4rl7UQaou1MLZgqlZ3gbze8sWqx7fvrkYBgjxkDVQkMepCnFoa69p3ufqSus
         0UzveAt1dil/L3VK6mHkZxeC8Tpo8RuYqm7CgEmHaV/Led8vAg6QXk0ssyyct1K6cubq
         ByRJ7MYJ//J4apv+UBVkJqaTqEGtlYBCH+NuFPf9wSOMh0e100+aKvmfHEWH5/qz8Quw
         4QZz3p3h3qxHu15IRDch1dTPst+dBtvqdgxX9PZN+nHq/eBTMYhUyaewgWLIZgXSWwHB
         MQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MoB+EnvvzF+TKOzDdDl2FIhJAJ8fgDbMtbJ023hVTI4=;
        b=OmgKKv1GwtnrMMa2UQ1Uu6B2VJ7vdkHF6COUOfjJBcyul9nEHqUKXR9jfjq9/QzDNz
         n2RHfmGMd+KY2EBkirFnBPXXPd/fVNjgCoheK9d0bamkZwrY9+5pKjHVMtItPC5bsMBq
         DG5B6WPo5sQO3WNpbX4Tw3P7OQbTKq6bEQFVzGR2kE0kzkei+rigBEBNmpj4IPplq9TH
         FX5Pfe/tpVCAsDBZFuVmnK14jmcnEe8mku0+8T1S/SEGWH7IerH9YXXKoWEOFrpO8uJr
         ZULIdx6a+cqHtq/2XUAy3mgl2de43+8fL0PKZitRrF62TOKK6e5wwPBMnIRCmOOJMfP3
         Kqrw==
X-Gm-Message-State: APjAAAVXK0ZPPEVB2oAi1+pSwLhj7Tsp3K/Z+jvEUtnosAyYzThMpu95
        AymOr/4Ih1qigqcpdoJrh4poli55
X-Google-Smtp-Source: APXvYqyhCHFze67C4bKsGwkObAnuEKi1rv6KW1kAORRxBjQtICjr3+zanSk3P0TNEvtjwmazRR28VA==
X-Received: by 2002:adf:c401:: with SMTP id v1mr90873wrf.375.1574208645317;
        Tue, 19 Nov 2019 16:10:45 -0800 (PST)
Received: from localhost.localdomain ([2a02:a03f:40e1:9900:5dce:1599:e3b5:7d61])
        by smtp.gmail.com with ESMTPSA id r25sm4781457wmh.6.2019.11.19.16.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 16:10:44 -0800 (PST)
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH] xsk: fix xsk_poll()'s return type
Date:   Wed, 20 Nov 2019 01:10:42 +0100
Message-Id: <20191120001042.30830-1-luc.vanoostenryck@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xsk_poll() is defined as returning 'unsigned int' but the
.poll method is declared as returning '__poll_t', a bitwise type.

Fix this by using the proper return type and using the EPOLL
constants instead of the POLL ones, as required for __poll_t.

CC: Björn Töpel <bjorn.topel@intel.com>
CC: Magnus Karlsson <magnus.karlsson@intel.com>
CC: Jonathan Lemon <jonathan.lemon@gmail.com>
CC: netdev@vger.kernel.org
Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 net/xdp/xsk.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 9044073fbf22..7b59f36eec0d 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -418,10 +418,10 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	return __xsk_sendmsg(sk);
 }
 
-static unsigned int xsk_poll(struct file *file, struct socket *sock,
+static __poll_t xsk_poll(struct file *file, struct socket *sock,
 			     struct poll_table_struct *wait)
 {
-	unsigned int mask = datagram_poll(file, sock, wait);
+	__poll_t mask = datagram_poll(file, sock, wait);
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
 	struct net_device *dev;
@@ -443,9 +443,9 @@ static unsigned int xsk_poll(struct file *file, struct socket *sock,
 	}
 
 	if (xs->rx && !xskq_empty_desc(xs->rx))
-		mask |= POLLIN | POLLRDNORM;
+		mask |= EPOLLIN | EPOLLRDNORM;
 	if (xs->tx && !xskq_full_desc(xs->tx))
-		mask |= POLLOUT | POLLWRNORM;
+		mask |= EPOLLOUT | EPOLLWRNORM;
 
 	return mask;
 }
-- 
2.24.0

