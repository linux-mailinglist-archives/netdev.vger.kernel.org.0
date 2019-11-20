Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAE4A10361B
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 09:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbfKTIjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 03:39:12 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:42945 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfKTIjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 03:39:11 -0500
Received: by mail-pg1-f178.google.com with SMTP id q17so12971239pgt.9
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 00:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xAGvmCTTbiFZa1QD8p7bE0Fit3+vMtBk+hQsXBR0Omg=;
        b=dkONEBDmB99HrgTrs18mo1W17bGWN23AI7/JWAWCW45D7gxAp6Rd4BlrH7PXHwzojP
         iYncy4ZE5PEaE0kuTNaLWBIbaCn6zRJvoXKooC1v+VmTTOGYzP5MFgDwvrPgQbADbM5l
         mTwuZwu/IaslxTW+JpEJ7JoINFcMmzzsB2hh/k/3dklmmPvoWQhtDhcpd6RZPQHg57V5
         K6Fm6ZDjMerIb9WlAVhcYTrgD4ypZUfQrt+XOn4Nl18vE3MkYEl0GrK+1tpu0/O4jtDp
         fJuvizu9c1xjZlgbXVRP2UmeqiOuy2jq/GN21JsSTSOwnLDEWJhnjnI5f6RKxKXge/Zj
         /+hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xAGvmCTTbiFZa1QD8p7bE0Fit3+vMtBk+hQsXBR0Omg=;
        b=oZT2EaTxGE5Hhi73Qo0iYHsWwTj729PmeSEtyYOSYscH05zCPz5yO6NO5wiP82ZXvB
         jZ9jYu59QbBp9tM3kus0dsN0mDDQPo9QD7S8iylvbrd64Et/+uX1fTvmekyfGDUCpmkr
         FLcXXJRFEHfoOvcJCMcfDQw8YPD0ZBZ9kDNsBjxJA//Ju575BBz63ULSkDtu4g420Y3J
         iKn7T0xsAa7Td3ANPo8Mlu4tia5z6IMKghi5TRqklHPU3DDPu4Gto9xPWg0zmYFhLMwk
         QeqY+K5GAzzkPeX/npSYu93QrCipNrm1WFp4m1ActaFNI8244Lvud4kNRh0bSB2WsGbG
         IWkQ==
X-Gm-Message-State: APjAAAX8iEZnqtMq1j151WSWSOkPaBhHD7EPFxBnozWh4DPYJLzKGqF4
        cgwNAud2zKYQUDmkzsGaC37fDq1O+y3PmQ==
X-Google-Smtp-Source: APXvYqwBsw7kaGOfL/uBa86iygBtGTI6DdSDOqhNRyNVgK3LMTYJQV1KYybh5iaG0iFHO4g+r1l1Ng==
X-Received: by 2002:a62:7f93:: with SMTP id a141mr2592526pfd.82.1574239150890;
        Wed, 20 Nov 2019 00:39:10 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z11sm31300917pfg.117.2019.11.20.00.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 00:39:10 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Benc <jbenc@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net-next] tcp: warn if offset reach the maxlen limit when using snprintf
Date:   Wed, 20 Nov 2019 16:38:08 +0800
Message-Id: <20191120083808.16382-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191114102831.23753-1-liuhangbin@gmail.com>
References: <20191114102831.23753-1-liuhangbin@gmail.com>
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

Since using scnprintf may hide the limit error, while the buffer is still
enough now, let's just add a WARN_ON_ONCE in case it reach the limit
in future.

v2: Use WARN_ON_ONCE as Jiri and Eric suggested.

Suggested-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv4/sysctl_net_ipv4.c | 4 ++++
 net/ipv4/tcp_cong.c        | 6 ++++++
 net/ipv4/tcp_ulp.c         | 3 +++
 3 files changed, 13 insertions(+)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 59ded25acd04..c9eaf924df63 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -340,6 +340,10 @@ static int proc_tcp_fastopen_key(struct ctl_table *table, int write,
 				user_key[i * 4 + 1],
 				user_key[i * 4 + 2],
 				user_key[i * 4 + 3]);
+
+		if (WARN_ON_ONCE(off >= tbl.maxlen - 1))
+			break;
+
 		if (i + 1 < n_keys)
 			off += snprintf(tbl.data + off, tbl.maxlen - off, ",");
 	}
diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index c445a81d144e..3737ec096650 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -256,6 +256,9 @@ void tcp_get_available_congestion_control(char *buf, size_t maxlen)
 		offs += snprintf(buf + offs, maxlen - offs,
 				 "%s%s",
 				 offs == 0 ? "" : " ", ca->name);
+
+		if (WARN_ON_ONCE(offs >= maxlen))
+			break;
 	}
 	rcu_read_unlock();
 }
@@ -285,6 +288,9 @@ void tcp_get_allowed_congestion_control(char *buf, size_t maxlen)
 		offs += snprintf(buf + offs, maxlen - offs,
 				 "%s%s",
 				 offs == 0 ? "" : " ", ca->name);
+
+		if (WARN_ON_ONCE(offs >= maxlen))
+			break;
 	}
 	rcu_read_unlock();
 }
diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
index 4849edb62d52..12ab5db2b71c 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -92,6 +92,9 @@ void tcp_get_available_ulp(char *buf, size_t maxlen)
 		offs += snprintf(buf + offs, maxlen - offs,
 				 "%s%s",
 				 offs == 0 ? "" : " ", ulp_ops->name);
+
+		if (WARN_ON_ONCE(offs >= maxlen))
+			break;
 	}
 	rcu_read_unlock();
 }
-- 
2.19.2

