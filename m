Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24986EC4A0
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 15:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbfKAOYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 10:24:31 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34809 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfKAOYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 10:24:31 -0400
Received: by mail-pg1-f195.google.com with SMTP id e4so6611253pgs.1
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 07:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wcdpZmmeZAo/k2NkvkUCVVJa5T89dwfwECWke5u/oEE=;
        b=QdfwaJboLYLlCyiwyGwg7xfY/wZVKYhrHqbrec8/lp+RNryGrJZ584pxVa51L3KISq
         HlrlWy03VT2BubOJ9MyIZR7+x2GIFN6YeYW/0kpJvRjPwaaIjTgdw11f//TzLuj2qnWh
         eQYarQjkR+71jla6srqCL/pC9jQ5mQvVkBJsGzmmtABaDVA3rTqHNfcBVGrbBKKfbOSO
         /JdHbCL5u8k0/8TwjRt1KuQAWXLg0MgvfYqAZDXdy1JPhdirCj8iHrssxLjtWjdv/jVW
         fJarMAxiYsYCu+LwawCmuRamMkrBpW7308DWWL6L8zdZ/t6G+Y4w35d3UYA8lg58aJNq
         54BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wcdpZmmeZAo/k2NkvkUCVVJa5T89dwfwECWke5u/oEE=;
        b=cnmlUJfhtK8eLJ6akCyHyd8KIEsuToKnGtlJ8aBhhxIG/7/ErjS6DTApW3/Fzh1Pt7
         l/JFFmkSmdG0d0FK2HWtzxONtV4rhAl9bzG7TEnngJtHwWTMvaQIMzDgjAa0xVhMgfPy
         yC80qGhvB7a2g3ve+qYdHn0BGzc4LjayZQ/RT1ljK9A3IkX56c1D/6W7Re4WYETyDULO
         hHYYXvupWi6dmXWu0kkjgHUpK4JoRIlIcwdeRfaUC6FX8OS+JhxmSrSACAIGDzHVnW5R
         G0dFTlF14NzgAHWB6NHn9O4psXdq63wHNJU1MNxMaukzAhhSepPZNO8ihnsNAaInNjcd
         MZhw==
X-Gm-Message-State: APjAAAUhi+s9sJ9gfPEJoh02vOs/zG0Qgk/X0WFpYxV6ohE+ks265Ief
        ReZh7hLyBk2jWl96OZ+uJmI=
X-Google-Smtp-Source: APXvYqwJmTFhmV7lDzszpmeZ3DLL5+wVdBKVPjRxmx71enTrftOOdaG5SYiajc5mj8DVK0wPM70W7A==
X-Received: by 2002:a17:90a:24b:: with SMTP id t11mr15837371pje.77.1572618270220;
        Fri, 01 Nov 2019 07:24:30 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([1.203.173.208])
        by smtp.gmail.com with ESMTPSA id c12sm8296499pfp.67.2019.11.01.07.24.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Nov 2019 07:24:29 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v6 07/10] net: openvswitch: add likely in flow_lookup
Date:   Fri,  1 Nov 2019 22:23:51 +0800
Message-Id: <1572618234-6904-8-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The most case *index < ma->max, and flow-mask is not NULL.
We add un/likely for performance.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Tested-by: Greg Rose <gvrose8192@gmail.com>
Acked-by: William Tu <u9012063@gmail.com>
---
 net/openvswitch/flow_table.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 96757e2..9f5a06e 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -519,7 +519,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 	struct sw_flow_mask *mask;
 	int i;
 
-	if (*index < ma->max) {
+	if (likely(*index < ma->max)) {
 		mask = rcu_dereference_ovsl(ma->masks[*index]);
 		if (mask) {
 			flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
@@ -534,7 +534,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 			continue;
 
 		mask = rcu_dereference_ovsl(ma->masks[i]);
-		if (!mask)
+		if (unlikely(!mask))
 			break;
 
 		flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
-- 
1.8.3.1

