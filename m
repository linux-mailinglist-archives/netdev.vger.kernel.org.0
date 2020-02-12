Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E21E159E9A
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 02:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgBLBmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 20:42:33 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43041 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727865AbgBLBmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 20:42:33 -0500
Received: by mail-pl1-f193.google.com with SMTP id p11so287328plq.10
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 17:42:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ngz+/gVLb2XY/PurYHv4XWKfX4UckAf1vcK+I4cFBEQ=;
        b=HUoj1//GyuWFqt3m9VybbV3AwjSrHRAl59Am19BNqg9sVZYweMUS2V6VtPNiUV3Hr9
         3iX3AHKCOsb8PbYagfhw22F6McppfK32sQdHHnmJFeHgzLo1Z0dJIFpd2sYiGSePx9ae
         lXJU7vA1fgvZvD27QMjvOYN5IfJDFexwQ7yNOKm6qvHMtPNMtU19gfGfKOKHcY7GdU3A
         d3wx/RQM2dORZvMyWKPlFHBw19Jn6w+sQo2hvqFoAdS7hPWtxDTk8Rfs+CyFEOSvAaVX
         MobTjW7fIkFn3B+uO1iL4MyeGMz8hMDUzWAUy2KLVj5/xLh0uGeaPDRHmhYcVtxaQJdR
         sEbQ==
X-Gm-Message-State: APjAAAW/tOIk9bIXjE39tmyGxcbuazBXbVv0GiFheHalZ16UK+vpLKv1
        Bfa0L+FxnKRV7Os2T6uSzIH4Kj+n33A=
X-Google-Smtp-Source: APXvYqwRhtFAIJ7IN8QMHzhZiHwv7pUopnqbM6HoLMljL7DbRGy+MsBO1/zG1jUzoBtAJ3e/abXuig==
X-Received: by 2002:a17:90a:ac0f:: with SMTP id o15mr6948086pjq.133.1581471752037;
        Tue, 11 Feb 2020 17:42:32 -0800 (PST)
Received: from f3.synalogic.ca (ag119225.dynamic.ppp.asahi-net.or.jp. [157.107.119.225])
        by smtp.gmail.com with ESMTPSA id 72sm6067843pfw.7.2020.02.11.17.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 17:42:31 -0800 (PST)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Michal=20Kube=C4=8Dek?= <mkubecek@suse.cz>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net 2/2] ipv6: Fix nlmsg_flags when splitting a multipath route
Date:   Wed, 12 Feb 2020 10:41:07 +0900
Message-Id: <20200212014107.110066-2-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200212014107.110066-1-bpoirier@cumulusnetworks.com>
References: <20200212014107.110066-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When splitting an RTA_MULTIPATH request into multiple routes and adding the
second and later components, we must not simply remove NLM_F_REPLACE but
instead replace it by NLM_F_CREATE. Otherwise, it may look like the netlink
message was malformed.

For example,
	ip route add 2001:db8::1/128 dev dummy0
	ip route change 2001:db8::1/128 nexthop via fe80::30:1 dev dummy0 \
		nexthop via fe80::30:2 dev dummy0
results in the following warnings:
[ 1035.057019] IPv6: RTM_NEWROUTE with no NLM_F_CREATE or NLM_F_REPLACE
[ 1035.057517] IPv6: NLM_F_CREATE should be set when creating new route

This patch makes the nlmsg sequence look equivalent for __ip6_ins_rt() to
what it would get if the multipath route had been added in multiple netlink
operations:
	ip route add 2001:db8::1/128 dev dummy0
	ip route change 2001:db8::1/128 nexthop via fe80::30:1 dev dummy0
	ip route append 2001:db8::1/128 nexthop via fe80::30:2 dev dummy0

Fixes: 27596472473a ("ipv6: fix ECMP route replacement")
Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 net/ipv6/route.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 4fbdc60b4e07..2931224b674e 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5198,6 +5198,7 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
 		 */
 		cfg->fc_nlinfo.nlh->nlmsg_flags &= ~(NLM_F_EXCL |
 						     NLM_F_REPLACE);
+		cfg->fc_nlinfo.nlh->nlmsg_flags |= NLM_F_CREATE;
 		nhn++;
 	}
 
-- 
2.25.0

