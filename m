Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024053D2B5A
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 19:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhGVREO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 13:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhGVREN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 13:04:13 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66BBC061575;
        Thu, 22 Jul 2021 10:44:48 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m2-20020a17090a71c2b0290175cf22899cso312176pjs.2;
        Thu, 22 Jul 2021 10:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QBvZGfhGPqv586kA+QHlMrcDII1Zc0Zi0WxS7GJ3bzo=;
        b=VINP1t8dVL1tPyMdJJBMIZhsTXBtw4bbs6fEUyudHL0HiTKf5RS2be8FwKKfhG1x1T
         YWcYZboNGQw9lusFEu603vChK59+AC/kL9wmDQErSToQDV7Wii6PeIOVLhi2iOtP+rst
         l4QJEh0W2cqcQIk5EHXx+Mvbd0GugKrttZ0BOQvALqHrQ5I39f6j5DxcDgtoSyWo8uKL
         jddYzr6bptePJTIUx0JYgr5p1gPH6frtBDAduKxATY6PAH+RWnfxVVdofhL3A77qJY/f
         pD38ta2JjngDmTycE+gpInFd8+rdaJpKSKQpbagpdyVD51khRKCv4bSpjRSXPaBlfwAk
         ZEaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QBvZGfhGPqv586kA+QHlMrcDII1Zc0Zi0WxS7GJ3bzo=;
        b=jFqwEORqfbX4TrzygH3iP2DbXaesqxmyp2xJRcu3FP40x7p4qZD4SbjLZm1sqLdreT
         BoDgnsV48TjyXXOb7NnKuR84Xi2O+AR95c700XmGwKXjmOAQY1LEQu01xUTOdPe1jlhH
         TEcv3dlDkQfUVyabL0nlpaMM7ZaWt6umPrf4FN41wZxjZ0zaxF47ewdniE6hqJ6rWupK
         boTR+A4IvcFazezb8BIfFQA5WkhQcK5VgZ3coBc0XDddSw3uE8PAqqFS7zkssEivLqVz
         E0RVrQTuwVeVF008nqHuMJSZZO4PLkMnz9yvBdZFCwF6x6M/EygFq0nJSmoOBz6IJYnK
         sPnA==
X-Gm-Message-State: AOAM533F9ybWEKDMvHyVbjvTi3/kflMPpQY78gnLdrZBtiTCGPZ+ngR6
        JFmCAeqvAY7IPokd86awJAU=
X-Google-Smtp-Source: ABdhPJwLzBgrcFGsrw4o2GvSyiLGJ4FhAv2F1A8Y8vmLqPLJoWbIwXZ7BSLGx/42z8UhC/IACnXxJA==
X-Received: by 2002:a63:5952:: with SMTP id j18mr1054001pgm.366.1626975888187;
        Thu, 22 Jul 2021 10:44:48 -0700 (PDT)
Received: from localhost.localdomain ([1.240.193.107])
        by smtp.googlemail.com with ESMTPSA id t23sm31256840pfe.8.2021.07.22.10.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 10:44:47 -0700 (PDT)
From:   Kangmin Park <l4stpr0gr4m@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ipv6: decrease hop limit counter in ip6_forward()
Date:   Fri, 23 Jul 2021 02:44:43 +0900
Message-Id: <20210722174443.416867-1-l4stpr0gr4m@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Decrease hop limit counter when deliver skb to ndp proxy.

Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
---
 net/ipv6/ip6_output.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 01bea76e3891..aaaf9622cf2d 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -549,9 +549,10 @@ int ip6_forward(struct sk_buff *skb)
 	if (net->ipv6.devconf_all->proxy_ndp &&
 	    pneigh_lookup(&nd_tbl, net, &hdr->daddr, skb->dev, 0)) {
 		int proxied = ip6_forward_proxy_check(skb);
-		if (proxied > 0)
+		if (proxied > 0) {
+			hdr->hop_limit--;
 			return ip6_input(skb);
-		else if (proxied < 0) {
+		} else if (proxied < 0) {
 			__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
 			goto drop;
 		}
-- 
2.26.2

