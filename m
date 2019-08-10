Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCEB88735
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 02:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbfHJATH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 20:19:07 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46583 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfHJATH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 20:19:07 -0400
Received: by mail-qt1-f196.google.com with SMTP id j15so3952241qtl.13
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 17:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BF5cp4kr1ESL5BF8pbX0cSzVctiqSse7JHu1NXfDoNo=;
        b=f7hRKvBK/DREOEDmppaxEfXvnJsswpbeKNCSSaUZ0jtch3Zm4ahla/G+H8GHagw2IB
         mVRaWdDsDk6aXdP4/1pwJMLmdt9G04+fVG2240cvD6FfyS2PzENlS8xgShC42mfkDXhs
         8PA48dogNBHIqhXQ+GQcMJDUDy3BucxdWmRiQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BF5cp4kr1ESL5BF8pbX0cSzVctiqSse7JHu1NXfDoNo=;
        b=YT99zSw6DEFhnfM3GKZ8vG0+lljkcpyNw5jWYmh8PUirzMt9kmdOftEtz7X6mwG6kP
         KWm/P++FAKPC8hRySGNcBedE4puVEhQJs0MBIJ6MAbTFMLtnDqQa7CzY4kBDz+rrRpBf
         NkCRsJYSmz59T3uCY8yQdHFXtysiJiZ3nQqq9x35v6o+z3ne3c5wB9k/M+oKnxZnxOPu
         I1uULFkk0ZRu7z/yolhDl1WyDIVe2guYktvAdfqJsL2KNAmYEiPvlRXptwJiRmnhYw60
         f9rU3LultBAY8VhHe0VAEIpXDb/tsNSefQPLKlb9XFZJ4P0iqBL0hQZ1yXsaoCQVYs4p
         QOhg==
X-Gm-Message-State: APjAAAXlNEzWSWpcOy/0Z0ZVwiQBt9EcqFKtgUuA8IjTBjSvVrMDpzhv
        A4oT/soELDoEoGOlVkgLw8n1+Syg0oU=
X-Google-Smtp-Source: APXvYqyoP9IYeXuvN8Bl9qALDWhFm0wut1Uxg505r7LS4wYE+/IAD/nYiOOnoD4SEanp/Zkj5A9J9g==
X-Received: by 2002:ad4:5367:: with SMTP id e7mr6305288qvv.5.1565396345837;
        Fri, 09 Aug 2019 17:19:05 -0700 (PDT)
Received: from robot.nc.rr.com (cpe-2606-A000-111D-8179-B743-207D-F4F9-B992.dyn6.twc.com. [2606:a000:111d:8179:b743:207d:f4f9:b992])
        by smtp.googlemail.com with ESMTPSA id u16sm1230497qkj.107.2019.08.09.17.19.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 17:19:05 -0700 (PDT)
From:   Donald Sharp <sharpd@cumulusnetworks.com>
To:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: [PATCH 2/2] ip nexthop: Allow flush|list operations to specify a specific protocol
Date:   Fri,  9 Aug 2019 20:18:43 -0400
Message-Id: <20190810001843.32068-3-sharpd@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case where we have a large number of nexthops from a specific
protocol, allow the flush and list operations to take a protocol
to limit the commands scopes.

Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>
---
 ip/ipnexthop.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index f35aab52..bc8ab431 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -19,6 +19,7 @@ static struct {
 	unsigned int groups;
 	unsigned int ifindex;
 	unsigned int master;
+	unsigned int proto;
 } filter;
 
 enum {
@@ -34,7 +35,7 @@ static void usage(void) __attribute__((noreturn));
 static void usage(void)
 {
 	fprintf(stderr,
-		"Usage: ip nexthop { list | flush } SELECTOR\n"
+		"Usage: ip nexthop { list | flush } [ protocol ID ] SELECTOR\n"
 		"       ip nexthop { add | replace } id ID NH [ protocol ID ]\n"
 		"       ip nexthop { get| del } id ID\n"
 		"SELECTOR := [ id ID ] [ dev DEV ] [ vrf NAME ] [ master DEV ]\n"
@@ -109,6 +110,9 @@ static int flush_nexthop(struct nlmsghdr *nlh, void *arg)
 		return -1;
 	}
 
+	if (filter.proto && nhm->nh_protocol != filter.proto)
+		return 0;
+
 	parse_rtattr(tb, NHA_MAX, RTM_NHA(nhm), len);
 	if (tb[NHA_ID])
 		id = rta_getattr_u32(tb[NHA_ID]);
@@ -213,6 +217,9 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 		return -1;
 	}
 
+	if (filter.proto && filter.proto != nhm->nh_protocol)
+		return 0;
+
 	parse_rtattr(tb, NHA_MAX, RTM_NHA(nhm), len);
 
 	open_json_object(NULL);
@@ -473,6 +480,13 @@ static int ipnh_list_flush(int argc, char **argv, int action)
 			if (get_unsigned(&id, *argv, 0))
 				invarg("invalid id value", *argv);
 			return ipnh_get_id(id);
+		} else if (!matches(*argv, "protocol")) {
+			__u32 proto;
+
+			NEXT_ARG();
+			if (get_unsigned(&proto, *argv, 0))
+				invarg("invalid protocol value", *argv);
+			filter.proto = proto;
 		} else if (matches(*argv, "help") == 0) {
 			usage();
 		} else {
-- 
2.21.0

