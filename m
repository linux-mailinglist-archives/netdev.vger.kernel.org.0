Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B314604DA
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 07:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbhK1GG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 01:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbhK1GEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 01:04:24 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8C1C061756;
        Sat, 27 Nov 2021 22:01:09 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so11102404pjb.4;
        Sat, 27 Nov 2021 22:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aLJ/lxXELr8am2FtU26Nt2UvXeJI3sLnmcAPGHnyFqo=;
        b=V1/h7Kiu6O8Ho1jMG6tmVjWFZE6ZBZg+1mXeP/HPfqT8R/OsOfskzAkOieZgM4rKQg
         BPhvK9bb49LlM6Y4/UJHSdXf8Arz8Qf4c0zAK3bf4WQFxw3h+PdN2qus6qoNRhubLZVQ
         KFB0tQkBMSJm2uwEGNrxZJKvq04dDdYaBGtQZ0sX1yLuxWWpLedxcSxb72AyOq3btO6D
         v3djU5dk+mzMPTwkWBXDTr/AsbGKgNM72T0phC4kHd6mYCxtp0lowp3qGhr+Nh1+Tdf2
         HhTAPjPmFfpDlZ8uyhjAzxEADZNpIAXGLSv3wMYvCypm+QVYXL9yaqecnJ2KBtWZRUYV
         oTXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aLJ/lxXELr8am2FtU26Nt2UvXeJI3sLnmcAPGHnyFqo=;
        b=C93Patv0u9WurjOSXfojfHO+fSqytJ1UQc1F2Q1zRj7FDc2AZGuFjAp+p70jzbIUlH
         q9QocgUGQ7n1M0MuebakdO/lNMxvGgu8pmi6kP9FMM6FC62wqH8ZyFxHVnSUlIs7htgP
         gzj20RGwsjHGzjuOqA53YZMJc0dChqM+4Np1dEdKh7v84KWhgMMRyGZESe+awekQYTjl
         PokxO/j+NJRtNi1nBjs6xRIVErUEpPbyvmvZGQKgdxMaa2GfaMYlC3CbDxsbRtzSPRCO
         b9/tzf55K2xwj1S8bVaU1G3kQqcb8aCrYHDF2skjMrvBnk3pSr1vstuWwDHA9UCqsvQY
         XsQA==
X-Gm-Message-State: AOAM530prlvniXAgfDbvR27BJBuEHugN9nErKmp9Oe8con+ZLIFiTwck
        ScAeMQH1XXVSvN8XwaPh/84=
X-Google-Smtp-Source: ABdhPJyn1r3AZo5z2nmDFExlnhZOMgIFEVUmn+Qi7LZzk6UFgM5Kw6+Nn881Yk8GJm4hN/I0LW541g==
X-Received: by 2002:a17:902:ab14:b0:143:77d8:2558 with SMTP id ik20-20020a170902ab1400b0014377d82558mr50491570plb.54.1638079268890;
        Sat, 27 Nov 2021 22:01:08 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id t4sm12989664pfq.163.2021.11.27.22.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 22:01:08 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, imagedong@tencent.com, ycheng@google.com,
        kuniyu@amazon.co.jp, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next] net: snmp: add statistics for tcp small queue check
Date:   Sun, 28 Nov 2021 14:01:02 +0800
Message-Id: <20211128060102.6504-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Once tcp small queue check failed in tcp_small_queue_check(), the
throughput of tcp will be limited, and it's hard to distinguish
whether it is out of tcp congestion control.

Add statistics of LINUX_MIB_TCPSMALLQUEUEFAILURE for this scene.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- use NET_INC_STATS() instead of __NET_INC_STATS()
---
 include/uapi/linux/snmp.h | 1 +
 net/ipv4/proc.c           | 1 +
 net/ipv4/tcp_output.c     | 5 ++++-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 904909d020e2..e32ec6932e82 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -292,6 +292,7 @@ enum
 	LINUX_MIB_TCPDSACKIGNOREDDUBIOUS,	/* TCPDSACKIgnoredDubious */
 	LINUX_MIB_TCPMIGRATEREQSUCCESS,		/* TCPMigrateReqSuccess */
 	LINUX_MIB_TCPMIGRATEREQFAILURE,		/* TCPMigrateReqFailure */
+	LINUX_MIB_TCPSMALLQUEUEFAILURE,		/* TCPSmallQueueFailure */
 	__LINUX_MIB_MAX
 };
 
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index f30273afb539..43b7a77cd6b4 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -297,6 +297,7 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TCPDSACKIgnoredDubious", LINUX_MIB_TCPDSACKIGNOREDDUBIOUS),
 	SNMP_MIB_ITEM("TCPMigrateReqSuccess", LINUX_MIB_TCPMIGRATEREQSUCCESS),
 	SNMP_MIB_ITEM("TCPMigrateReqFailure", LINUX_MIB_TCPMIGRATEREQFAILURE),
+	SNMP_MIB_ITEM("TCPSmallQueueFailure", LINUX_MIB_TCPSMALLQUEUEFAILURE),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 2e6e5a70168e..835a556a597a 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2524,8 +2524,11 @@ static bool tcp_small_queue_check(struct sock *sk, const struct sk_buff *skb,
 		 * test again the condition.
 		 */
 		smp_mb__after_atomic();
-		if (refcount_read(&sk->sk_wmem_alloc) > limit)
+		if (refcount_read(&sk->sk_wmem_alloc) > limit) {
+			NET_INC_STATS(sock_net(sk),
+				      LINUX_MIB_TCPSMALLQUEUEFAILURE);
 			return true;
+		}
 	}
 	return false;
 }
-- 
2.30.2

