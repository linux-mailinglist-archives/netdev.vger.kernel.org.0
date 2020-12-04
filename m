Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D222CE664
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 04:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgLDDRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 22:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727474AbgLDDRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 22:17:37 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9055BC061A54
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 19:16:57 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id bj5so2342287plb.4
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 19:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=unBJBYdJa7K6GwvokZQDCPmEMeNN5XNEhIq5Z4evB24=;
        b=iVnbkn3uEffoGNwzXjPRLE3qHej5rA0Ovf2JvVtGmJq5eeUW55rLXAJ+WsffJLHa29
         3DbIOTV2G8zBhwF9QPlnrLaltkkrcmoR6aGsvKaix33jRRFTP6/RthqeM73DywhfZ7HI
         RyV9H8CpQloZQFZvFvdaA6PlDuHnKqKRJELzQ7UIVkfAdVKGjb5L1Lpfr4W6pZhY3j27
         VBNv58zSSivLas6Utv2P6UqB3ivj6RU9WvrycLqyvs/Axwu5PyGK3zzl6RU7BjoT5Xuv
         hASV72yc88LzRKEdm42lVMiC8HyquFdZLTTeEFMSWWWSQ298Tix6rLKijFy0hatvl7Uz
         4ByQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=unBJBYdJa7K6GwvokZQDCPmEMeNN5XNEhIq5Z4evB24=;
        b=ujvPdgPjtepOtECva/6ZbzZ9GL3E4dRjra2p0Rd8v6mm753vP9HW5Xmh6KTy5M4/w2
         KPOEhyX7m8K7LftPoucpbCnf3FV6qczE6skHed1nQujC4982CyK7JXuRwH5QiaH/tk6i
         UxUQgrdzxTtR2J301gvQgQKhBPo1/SaLS5oLJTi3Hvfj/B3H1qSM63hKvYXI05fhufHg
         U2PJIZtPZll9LAvoMFSgtEpKYPUrCU9vipBpgQfOcY9MxneY1pBfSHil/2EtgaiGWbZs
         7GbnfG+CKrNUjYVuXeameno8RPGhLYvlnBMCIl/mPsbPJk2AK7i+3lN21bMFzVDdx74b
         XIdw==
X-Gm-Message-State: AOAM530aAGFgo5b9eUxZyE2MTqBaf2Sg8PAMEBTOC8JoxiZEAkJmE1qK
        +TRKoFYC+nItuVfQdtJ4KsE=
X-Google-Smtp-Source: ABdhPJwD8+nR8gFw8O220s1mDziWkfvT0ZynZYBPY6DHaqFRa45r0vQHb3NC3JZTZAPLetmkpeeObw==
X-Received: by 2002:a17:90a:6588:: with SMTP id k8mr2177650pjj.197.1607051816765;
        Thu, 03 Dec 2020 19:16:56 -0800 (PST)
Received: from clinic20-Precision-T3610.hsd1.ca.comcast.net ([2601:648:8400:9ef4:bf20:728e:4c43:a644])
        by smtp.gmail.com with ESMTPSA id q19sm3042251pff.101.2020.12.03.19.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 19:16:56 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 4/6] net: add sysctl for enabling RFC 8335 PROBE messages
Date:   Thu,  3 Dec 2020 19:16:55 -0800
Message-Id: <a7fc58bf02c18df714c19d68b788f670cb8597a9.1607050389.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1607050388.git.andreas.a.roeseler@gmail.com>
References: <cover.1607050388.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Section 8 of RFC 8335 specifies potential security concerns of
responding to PROBE requests, and states that nodes that support PROBE
functionality MUST be able to enable/disable responses and it is
disabled by default. 

Add sysctl to enable responses to PROBE messages. 

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
 net/ipv4/sysctl_net_ipv4.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 3e5f4f2e705e..f9f0e9d7394f 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -599,6 +599,13 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
 	},
+	{
+		.procname	= "icmp_echo_enable_probe",
+		.data		= &init_net.ipv4.sysctl_icmp_echo_enable_probe,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
 	{
 		.procname	= "icmp_echo_ignore_broadcasts",
 		.data		= &init_net.ipv4.sysctl_icmp_echo_ignore_broadcasts,
-- 
2.25.1

