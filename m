Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490AC34DDBB
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 03:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhC3Bpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 21:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbhC3Bpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 21:45:33 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42FCC061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 18:45:32 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id w70so15026595oie.0
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 18:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ccpQasAofMpclBCXWbZ/eA4V3PBIfnLjEkxB4+leHIs=;
        b=Mu/AYUbzGkwMjFPldwyIDt8tHMpEu2rqtejiEDVvi4gY+2s0F1t4uJltNQTtRMsjEO
         ZSjZzS6wKOUqIqYNZxf1mVPKa+Rl9lMC3zlSD4QOYUuyPtiIMb1LlLkI0be7uiW86qeM
         XHkBG/P5GvVKtpjU9lLaKW731O3iJw4NgmUrKUaxnSjdUIBs5Um5oxti34BVGuUdz4yi
         FFj0L9iKm9GmBtZwAw7K32QLFroJPqi7UNCmHtxAX1bpFe8RrBYuTKrE97owzw3eiWpL
         6lr9CsOS3sQHH9c1tY1HgXZc8N2AV0gJJRIWwSCsluuTU+KYPDBpe9nH5TzqAhoFFkhr
         JgrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ccpQasAofMpclBCXWbZ/eA4V3PBIfnLjEkxB4+leHIs=;
        b=hzJNdB8Q5h8SawtDx+iPuFOxgg7SWozHGrahPKF6bWF/7iyPIF4LGsdTfBimgvC+By
         TWIryXp5oOGCFyhTmAj49Rb4ah0J8feVVeWQpWwOikHvqsEyVRSu95NwVqxSqJ8+fb8B
         X61uR00WYtGH85zG8JqF16Q6Cca8pf1tMxiMv1RHbBFnO/SFFUb77ukYlJqfZPvlK2b8
         O2uQ/H32fITDIh5FhyvnSnkVyDWI5P6y0NfaCO6M2mvSg/Aw1tjYTTDE3RjybaxGtKun
         i8rbeuMVSUAtxxgI9oXpR6+ZMCsQ1UF3MvLQhNzDpikA1Oh2ymsOFFQ12I7qzG2z2bmh
         eYwg==
X-Gm-Message-State: AOAM533I4NVfnoDRJQ+0fVIIUWI6klDuLsQ6TaEWu7YWByJu3Wdys1iL
        Mz4cN46QyHHeN6+0d0JCOqADA11j7js=
X-Google-Smtp-Source: ABdhPJxRGZE/w/GzzpRx0P1QP3zTOKgmSKFlNo021YviFyYimwzfZwGeXn8sdPttM5n900qAHJIXNQ==
X-Received: by 2002:aca:b6d7:: with SMTP id g206mr1426622oif.53.1617068731804;
        Mon, 29 Mar 2021 18:45:31 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:35b:834f:7126:8db])
        by smtp.googlemail.com with ESMTPSA id 24sm3742027oiq.11.2021.03.29.18.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 18:45:31 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next V6 3/6] net: add sysctl for enabling RFC 8335 PROBE messages
Date:   Mon, 29 Mar 2021 18:45:29 -0700
Message-Id: <45bed11694315c9a6fae1dc306e852fd9a30bcb3.1617067968.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1617067968.git.andreas.a.roeseler@gmail.com>
References: <cover.1617067968.git.andreas.a.roeseler@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Section 8 of RFC 8335 specifies potential security concerns of
responding to PROBE requests, and states that nodes that support PROBE
functionality MUST be able to enable/disable responses and that
responses MUST be disabled by default

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
Changes:
v1 -> v2:
 - Combine patches related to sysctl

v2 -> v3:
Suggested by Willem de Bruijn <willemdebruijn.kernel@gmail.com>
 - Use proc_dointvec_minmax with zero and one

v5 -> v6:
 - Add documentation to ip-sysctl.rst
---
 Documentation/networking/ip-sysctl.rst | 6 ++++++
 include/net/netns/ipv4.h               | 1 +
 net/ipv4/sysctl_net_ipv4.c             | 9 +++++++++
 3 files changed, 16 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index c7952ac5bd2f..4130bce40765 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1143,6 +1143,12 @@ icmp_echo_ignore_all - BOOLEAN
 
 	Default: 0
 
+icmp_echo_enable_probe - BOOLEAN
+        If set to one, then the kernel will respond to RFC 8335 PROBE
+        requests sent to it.
+
+        Default: 0
+
 icmp_echo_ignore_broadcasts - BOOLEAN
 	If set non-zero, then the kernel will ignore all ICMP ECHO and
 	TIMESTAMP requests sent to it via broadcast/multicast.
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index d377266d133f..9c8dd424d79b 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -84,6 +84,7 @@ struct netns_ipv4 {
 #endif
 
 	u8 sysctl_icmp_echo_ignore_all;
+	u8 sysctl_icmp_echo_enable_probe;
 	u8 sysctl_icmp_echo_ignore_broadcasts;
 	u8 sysctl_icmp_ignore_bogus_error_responses;
 	u8 sysctl_icmp_errors_use_inbound_ifaddr;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 442ff4be1bde..b1a340e8738f 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -599,6 +599,15 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
 	},
+	{
+		.procname	= "icmp_echo_enable_probe",
+		.data		= &init_net.ipv4.sysctl_icmp_echo_enable_probe,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE
+	},
 	{
 		.procname	= "icmp_echo_ignore_broadcasts",
 		.data		= &init_net.ipv4.sysctl_icmp_echo_ignore_broadcasts,
-- 
2.17.1

