Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A67B35D883
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhDMHJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhDMHJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 03:09:30 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6557C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 00:09:09 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id bs7so7109761qvb.12
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 00:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hV7Z7P462n1e7aUjy94FQET4e7ZXE2xXWIC+nmDti7A=;
        b=f6JXdSdp0v0YfKv6dWMPdZ6nngQuCQBaRLHCjadkTS+ZiJzSgswgJQRxnItbjXm1EG
         QY7ZFA1sRZqlH+cvw9oFoZA3mG2JhaZqxvbt3USXZwNiZ8+Snkv/K/NgiwVFNi6sct1O
         wRoSGtKV7rAccagkOY1+phsju0wFJGqo9SBM4PDCrwzH3W2hm6u3gqFokSjN5YRt9HC3
         7JRZkh14CK2zFrzANzGpgTg4HIte2SzxFb7N3DqOf9Wlqr3uVNWqFMfq/hHhugTwH/VA
         wT2gb+0Dw2Mz+nxlRQR9hbDIIjyKgDKmEDvIwqHP5bn0U0qfp7EurTrH7iOYzWKQRl5+
         NrZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hV7Z7P462n1e7aUjy94FQET4e7ZXE2xXWIC+nmDti7A=;
        b=UUaSO3tHLrNbnKLgSUKJW3hnclv/GyfQC8Ndz+j2T7AcFH27XrB+Dwdeb/UN3a7EPM
         fNNBUdJW0KdG52DORpuUdOADyxjSPjJSmNX/rwGDh7ZC0UkRO4C8YbZhXOhTtg3/T6lz
         YwKVePBvyx27PRI4jtzxT6sPDs5m3vcC/nkj5lXZn7ZPZ60gghPQAAihMAhpGHt6FalO
         R+PQoR0OkZa9+kNyyUtJn++J4TEty+1rcPnaigCCmQ64yW5e0022PPtist7HeItB3oH1
         CjyXyUHxJ0bAWHsVsXZMAt8raCyQuU9+d1f5Z3IPKOLGP7sIyCppqWQZQynSVEGyf6u1
         /doA==
X-Gm-Message-State: AOAM5302LqXjPbKwTo6OBlQjxSsAd7vNrbNSYYrvekGixO5yKdmpaGej
        /hrzqObzp+wMW46Zj9y7J5JzQfxiDkJBGQ==
X-Google-Smtp-Source: ABdhPJzoWUIyppcrT3wX56SyffeetcVF21CSkwOg/WbPV9R79yLQLIUg7HSW5N3Vr60Iq5C7KpF/aw==
X-Received: by 2002:a0c:d7d2:: with SMTP id g18mr31408548qvj.42.1618297748870;
        Tue, 13 Apr 2021 00:09:08 -0700 (PDT)
Received: from jrr-vaio.onthefive.com (2603-6010-7221-eda3-0000-0000-0000-1d7d.res6.spectrum.com. [2603:6010:7221:eda3::1d7d])
        by smtp.gmail.com with ESMTPSA id k4sm9500582qke.13.2021.04.13.00.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 00:09:08 -0700 (PDT)
From:   Jonathon Reinhart <jonathon.reinhart@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jonathon Reinhart <jonathon.reinhart@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH] net: Make tcp_allowed_congestion_control readonly in non-init netns
Date:   Tue, 13 Apr 2021 03:08:48 -0400
Message-Id: <20210413070848.7261-1-jonathon.reinhart@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, tcp_allowed_congestion_control is global and writable;
writing to it in any net namespace will leak into all other net
namespaces.

tcp_available_congestion_control and tcp_allowed_congestion_control are
the only sysctls in ipv4_net_table (the per-netns sysctl table) with a
NULL data pointer; their handlers (proc_tcp_available_congestion_control
and proc_allowed_congestion_control) have no other way of referencing a
struct net. Thus, they operate globally.

Because ipv4_net_table does not use designated initializers, there is no
easy way to fix up this one "bad" table entry. However, the data pointer
updating logic shouldn't be applied to NULL pointers anyway, so we
instead force these entries to be read-only.

These sysctls used to exist in ipv4_table (init-net only), but they were
moved to the per-net ipv4_net_table, presumably without realizing that
tcp_allowed_congestion_control was writable and thus introduced a leak.

Because the intent of that commit was only to know (i.e. read) "which
congestion algorithms are available or allowed", this read-only solution
should be sufficient.

The logic added in recent commit
31c4d2f160eb: ("net: Ensure net namespace isolation of sysctls")
does not and cannot check for NULL data pointers, because
other table entries (e.g. /proc/sys/net/netfilter/nf_log/) have
.data=NULL but use other methods (.extra2) to access the struct net.

Fixes: 9cb8e048e5d9: ("net/ipv4/sysctl: show tcp_{allowed, available}_congestion_control in non-initial netns")
Signed-off-by: Jonathon Reinhart <jonathon.reinhart@gmail.com>
---
 net/ipv4/sysctl_net_ipv4.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index a09e466ce11d..a62934b9f15a 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1383,9 +1383,19 @@ static __net_init int ipv4_sysctl_init_net(struct net *net)
 		if (!table)
 			goto err_alloc;
 
-		/* Update the variables to point into the current struct net */
-		for (i = 0; i < ARRAY_SIZE(ipv4_net_table) - 1; i++)
-			table[i].data += (void *)net - (void *)&init_net;
+		for (i = 0; i < ARRAY_SIZE(ipv4_net_table) - 1; i++) {
+			if (table[i].data) {
+				/* Update the variables to point into
+				 * the current struct net
+				 */
+				table[i].data += (void *)net - (void *)&init_net;
+			} else {
+				/* Entries without data pointer are global;
+				 * Make them read-only in non-init_net ns
+				 */
+				table[i].mode &= ~0222;
+			}
+		}
 	}
 
 	net->ipv4.ipv4_hdr = register_net_sysctl(net, "net/ipv4", table);
-- 
2.20.1

