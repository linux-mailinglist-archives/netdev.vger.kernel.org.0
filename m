Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7F745FD18
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 07:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349492AbhK0Gbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 01:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349543AbhK0G3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 01:29:33 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A532C061574;
        Fri, 26 Nov 2021 22:26:19 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so8950412pjj.0;
        Fri, 26 Nov 2021 22:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J90DFPTT8E11OvYFuVIpDzpExwac8T+1kF7pq0lAYBg=;
        b=ZxVAwWnCOnFQr8KV4KxOGYqI9K8lQDEs2raANPMTijsapKcsbeGlnFn/Gu6uiOoinB
         1/5iOtCs4Kah8DDJ5ChBJbFPqLdcT4ZeJmaf/GOQ0v3SQRCrxIl6kASeHf2dsLL1OePa
         Iqwxyjw/iJxb4c9vTIFTD/hZCcH6lIbf87VWrgZByDHcyeSyfcMKyT5kar4wk3OeaTN2
         Q0iaO0C/1yrXBkp0Fppd4AyRrjSdK8L+kc6EqGBjinGae4JWfJ3pI7/pRuxKTloFGWoE
         MgJrvmJOuLUN7EVhO2Irf1ChdNubHcSG/wKoT7JOniAqBfjF+e4VzJ0VNJazPNuamhJR
         8C9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J90DFPTT8E11OvYFuVIpDzpExwac8T+1kF7pq0lAYBg=;
        b=TjqfDQIlOcnGUtMKI7dL25D24QI7rKmgeMF0F+LV5gIPnaI5Oiaawc8Pg47Rm7iNCg
         WB2/U4mAXc4kJT0QfXFL7T2jg61rkRDUKMJqldkx8ugNFyJoLUWIKTVrgZRJlslVzhHS
         D4Bs02bE6EdzJhlYoNLAftYkQK5hRuVo8WX1MJd6185pnwY4LfFYAQMCkiMfRIu6VNJ0
         h52YifCD5EeZYiiAAykRgG7AsWDwl9dfRl1QL/qJAS07Rn1/nbeXjS3bnTNjxZEKvb5s
         Tb0ClAMBrYXKQwvphy8GMCIQ+JJN2jJQw9Kgce2nzxXI7WYWh9vL9hQgekPhtltBHDx2
         ggqw==
X-Gm-Message-State: AOAM530upLxAXmdbZVOKgu/XnBDob5p+O55QXRPCQBNdwppusnE0mQJh
        V6x1+HRiN6L2o1Wqh7IYEPo=
X-Google-Smtp-Source: ABdhPJwNQ80etv50fMI8PvRF4OBD5hEkopxb/ceVYO87YnnmFN7iP10q0ixd4xTp8emsFscoK66DnQ==
X-Received: by 2002:a17:902:7b82:b0:143:a6d6:34ab with SMTP id w2-20020a1709027b8200b00143a6d634abmr42977443pll.30.1637994378941;
        Fri, 26 Nov 2021 22:26:18 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id s24sm8786703pfm.100.2021.11.26.22.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 22:26:18 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, ycheng@google.com, imagedong@tencent.com,
        kuniyu@amazon.co.jp, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: snmp: add statistics for tcp small queue check
Date:   Sat, 27 Nov 2021 14:26:08 +0800
Message-Id: <20211127062608.22100-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
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
index 2e6e5a70168e..5b978c402eb4 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2524,8 +2524,11 @@ static bool tcp_small_queue_check(struct sock *sk, const struct sk_buff *skb,
 		 * test again the condition.
 		 */
 		smp_mb__after_atomic();
-		if (refcount_read(&sk->sk_wmem_alloc) > limit)
+		if (refcount_read(&sk->sk_wmem_alloc) > limit) {
+			__NET_INC_STATS(sock_net(sk),
+					LINUX_MIB_TCPSMALLQUEUEFAILURE);
 			return true;
+		}
 	}
 	return false;
 }
-- 
2.27.0

