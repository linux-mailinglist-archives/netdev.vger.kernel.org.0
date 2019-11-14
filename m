Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3223EFC427
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKNK2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:28:48 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40948 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfKNK2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 05:28:47 -0500
Received: by mail-pf1-f194.google.com with SMTP id r4so3919394pfl.7
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 02:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jAazhFAd8DNPuYHJfFS+L4hreqg5zG8buaV81e27Gvs=;
        b=k5MbUl6KhxwmrBOOQSg6uTKM9jsAImnDdh2Vg/KkkeN0qju2NdgTom8qBJv7X1FPI6
         15tlStDyyLnsMDabhstPRYxbrBE2Z311jeC67+VM2fw0Z43cdeKloVqtWEO3EN7CajVe
         qiZtv9W2XqG8df1JmehZwI3kPdJ/ecJ+VoU8GkGVCiGIbcqDn6D/FtbUc8iTlb3t21he
         7ju1sqbxstSg/dZW9RK0MJs95yPHjesqbVKIhBTZpYZJzJsW5/cyjNLmG+30Gw8OH/em
         RjJPCXFtnFoVW0d9JMHKKQtux4Zg+sshBJeR2C+9VHOjdgO7C5cjddOc3jZqUUzDyJhF
         0rSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jAazhFAd8DNPuYHJfFS+L4hreqg5zG8buaV81e27Gvs=;
        b=mcBUOl/H5k/W8nXI0fFozN87olOAeFig0zSW/wG+NRdLqwDi8F1/YdoSckRQwqQ4gY
         2wJ9V0aaRxJg2x3du8yCLpOKVxBNcHzjeLcAuoAoxir/mAltB4/7coZmIqqD1B9diz6Y
         ur69+KGPEHAFqQYXTFlCawgo2k7sv7Wjy0imxZ2bMoBFfgzRuOMt9kgo0WTf8J3Ryy1W
         KdX/bxDCQaDuUmnFeE3o/WSQDPLcaBV3VU6UZWmrWWJnoiLSED2gf/QBpu5mu2L1BndE
         JS+9MxtTtrXxid5UlVozNC3qRC27h8RXCAFAwNd1TSX0kK+Kb3DLGIVoLfIubvnXmxM9
         yT7Q==
X-Gm-Message-State: APjAAAUx3K70xaXnsoLmQj4AjL54EgStbPAY+heRi5ICIaMKJDS3G7qS
        CZ1JBR31zrABKvpSIu2d+zQZRiPZRVfafw==
X-Google-Smtp-Source: APXvYqy9GpYX7YCvg70FW2H/BFR1bNjfW0SUk0cIS0DEqvKAuoqnhO6bbcE0pEvJlpoyNYnnDn/5Kg==
X-Received: by 2002:a65:6482:: with SMTP id e2mr6286050pgv.20.1573727327019;
        Thu, 14 Nov 2019 02:28:47 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z11sm7796171pfg.117.2019.11.14.02.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 02:28:46 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Benc <jbenc@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] tcp: switch snprintf to scnprintf
Date:   Thu, 14 Nov 2019 18:28:31 +0800
Message-Id: <20191114102831.23753-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

snprintf returns the number of chars that would be written, not number
of chars that were actually written. As such, 'offs' may get larger than
'tbl.maxlen', causing the 'tbl.maxlen - offs' being < 0, and since the
parameter is size_t, it would overflow.

Currently, the buffer is still enough, but for future design, use scnprintf
would be safer.

Suggested-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv4/sysctl_net_ipv4.c | 14 +++++++-------
 net/ipv4/tcp_cong.c        | 12 ++++++------
 net/ipv4/tcp_ulp.c         |  6 +++---
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 59ded25acd04..ed804cf68026 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -334,14 +334,14 @@ static int proc_tcp_fastopen_key(struct ctl_table *table, int write,
 		user_key[i] = le32_to_cpu(key[i]);
 
 	for (i = 0; i < n_keys; i++) {
-		off += snprintf(tbl.data + off, tbl.maxlen - off,
-				"%08x-%08x-%08x-%08x",
-				user_key[i * 4],
-				user_key[i * 4 + 1],
-				user_key[i * 4 + 2],
-				user_key[i * 4 + 3]);
+		off += scnprintf(tbl.data + off, tbl.maxlen - off,
+				 "%08x-%08x-%08x-%08x",
+				 user_key[i * 4],
+				 user_key[i * 4 + 1],
+				 user_key[i * 4 + 2],
+				 user_key[i * 4 + 3]);
 		if (i + 1 < n_keys)
-			off += snprintf(tbl.data + off, tbl.maxlen - off, ",");
+			off += scnprintf(tbl.data + off, tbl.maxlen - off, ",");
 	}
 
 	ret = proc_dostring(&tbl, write, buffer, lenp, ppos);
diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index c445a81d144e..d84a09bd0201 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -253,9 +253,9 @@ void tcp_get_available_congestion_control(char *buf, size_t maxlen)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(ca, &tcp_cong_list, list) {
-		offs += snprintf(buf + offs, maxlen - offs,
-				 "%s%s",
-				 offs == 0 ? "" : " ", ca->name);
+		offs += scnprintf(buf + offs, maxlen - offs,
+				  "%s%s",
+				  offs == 0 ? "" : " ", ca->name);
 	}
 	rcu_read_unlock();
 }
@@ -282,9 +282,9 @@ void tcp_get_allowed_congestion_control(char *buf, size_t maxlen)
 	list_for_each_entry_rcu(ca, &tcp_cong_list, list) {
 		if (!(ca->flags & TCP_CONG_NON_RESTRICTED))
 			continue;
-		offs += snprintf(buf + offs, maxlen - offs,
-				 "%s%s",
-				 offs == 0 ? "" : " ", ca->name);
+		offs += scnprintf(buf + offs, maxlen - offs,
+				  "%s%s",
+				  offs == 0 ? "" : " ", ca->name);
 	}
 	rcu_read_unlock();
 }
diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
index 4849edb62d52..c338cae13842 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -89,9 +89,9 @@ void tcp_get_available_ulp(char *buf, size_t maxlen)
 	*buf = '\0';
 	rcu_read_lock();
 	list_for_each_entry_rcu(ulp_ops, &tcp_ulp_list, list) {
-		offs += snprintf(buf + offs, maxlen - offs,
-				 "%s%s",
-				 offs == 0 ? "" : " ", ulp_ops->name);
+		offs += scnprintf(buf + offs, maxlen - offs,
+				  "%s%s",
+				  offs == 0 ? "" : " ", ulp_ops->name);
 	}
 	rcu_read_unlock();
 }
-- 
2.19.2

