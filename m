Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5C623A976
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 17:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgHCPfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 11:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgHCPfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 11:35:05 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2FCC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 08:35:05 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id f9so2781pju.4
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 08:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=gTtBRSzq0CEtu4NsIES9D/wYZ1FEY+3VPzbHpcqbh0c=;
        b=Nc6sDRe0CN+YLlPVdxOj+MmjImW+NkkMGG0pMT7PGskUM5lpwh2ij5IQZQDlgFYSeI
         J0Klgl93aEgZeF/sEuGVeGG/xpwec24qNiFbbSCFPIeqwWOvtfw5KXqyf6QynliQ7bBB
         fv6+HLK0xPSfZGoGB/u0SgbSHdVuw6iTgbJkZufwbNYqKDBiDzQT86NG+bAXwx+QiHMH
         qnVkG76zB40Qb4gT2Z4kKES2AFwyzYB9rx2RR8NQteF3Ni7f5dd0tvnmQC0P2K94Vca1
         ngdZ2vml2YT41tsbGJWYWC5LUHF7avTPnWnI2rzXSuO3/AT0NmRTq6yNsO2XgZpo8856
         bJ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=gTtBRSzq0CEtu4NsIES9D/wYZ1FEY+3VPzbHpcqbh0c=;
        b=KBZez8iRm0pfQ0dOVBgkXSgXQJjV+t5aGUxEaoLmPKAt4jn08ag9tFM+W+KC5Rqu2B
         7UNbCt0dMHT/Lf1g2gWEBhzHpwn22aNQ4+3MyVML9ZGqhRIdf/kYX53N0kUp4iVW9GMC
         uONk2B4QWPkMEwW8cu63/3s+nbxMN6Fe1TyegwDdqHIyRYPCCmCtGd7Pax/RIGhyyOFH
         ZbE9iuhfBkSgtOxsJy+wuX9yuGeoC7MZVU6vQF91VFKYh28OM0+RMdixdd4HOxZZiwJq
         5eTLOJ9/jtbJnFWs46HtB9QBtfrNVi9kKmaQniaNN+rXADCYEcjHIkuKNqCU43NTDhvi
         FFGQ==
X-Gm-Message-State: AOAM530yTNkrpyYz7RZYPnKooLs9r6T+qmFz//gpU/10YBvMcguOT0w8
        64cUYbEEKx5EXs0oJAs3qla3he73wLM=
X-Google-Smtp-Source: ABdhPJxTl5mFRSUmEvpfwgk4mwLzf0nzhnD/ZW7yOC/q4uBg4blE5muJQhVRwvNiuCf2iAxdN6facg==
X-Received: by 2002:a17:90a:3ac5:: with SMTP id b63mr18524402pjc.3.1596468904571;
        Mon, 03 Aug 2020 08:35:04 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y8sm18599846pjj.17.2020.08.03.08.35.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Aug 2020 08:35:03 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH net 1/2] ipv6: add ipv6_dev_find()
Date:   Mon,  3 Aug 2020 23:34:46 +0800
Message-Id: <7ba2ca17347249b980731e7a76ba3e24a9e37720.1596468610.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1596468610.git.lucien.xin@gmail.com>
References: <cover.1596468610.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1596468610.git.lucien.xin@gmail.com>
References: <cover.1596468610.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is to add an ip_dev_find like function for ipv6, used to find
the dev by saddr.

It will be used by TIPC protocol. So also export it.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/addrconf.h |  2 ++
 net/ipv6/addrconf.c    | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 8418b7d..ba3f6c15 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -97,6 +97,8 @@ bool ipv6_chk_custom_prefix(const struct in6_addr *addr,
 
 int ipv6_chk_prefix(const struct in6_addr *addr, struct net_device *dev);
 
+struct net_device *ipv6_dev_find(struct net *net, const struct in6_addr *addr);
+
 struct inet6_ifaddr *ipv6_get_ifaddr(struct net *net,
 				     const struct in6_addr *addr,
 				     struct net_device *dev, int strict);
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 840bfdb..857d6f9 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1983,6 +1983,45 @@ int ipv6_chk_prefix(const struct in6_addr *addr, struct net_device *dev)
 }
 EXPORT_SYMBOL(ipv6_chk_prefix);
 
+/**
+ * ipv6_dev_find - find the first device with a given source address.
+ * @net: the net namespace
+ * @addr: the source address
+ *
+ * The caller should be protected by RCU, or RTNL.
+ */
+struct net_device *ipv6_dev_find(struct net *net, const struct in6_addr *addr)
+{
+	unsigned int hash = inet6_addr_hash(net, addr);
+	struct inet6_ifaddr *ifp, *result = NULL;
+	struct net_device *dev = NULL;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(ifp, &inet6_addr_lst[hash], addr_lst) {
+		if (net_eq(dev_net(ifp->idev->dev), net) &&
+		    ipv6_addr_equal(&ifp->addr, addr)) {
+			result = ifp;
+			break;
+		}
+	}
+
+	if (!result) {
+		struct rt6_info *rt;
+
+		rt = rt6_lookup(net, addr, NULL, 0, NULL, 0);
+		if (rt) {
+			dev = rt->dst.dev;
+			ip6_rt_put(rt);
+		}
+	} else {
+		dev = result->idev->dev;
+	}
+	rcu_read_unlock();
+
+	return dev;
+}
+EXPORT_SYMBOL(ipv6_dev_find);
+
 struct inet6_ifaddr *ipv6_get_ifaddr(struct net *net, const struct in6_addr *addr,
 				     struct net_device *dev, int strict)
 {
-- 
2.1.0

