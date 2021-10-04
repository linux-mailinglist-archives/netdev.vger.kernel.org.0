Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054054207C5
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 11:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhJDJFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 05:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbhJDJFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 05:05:30 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0F5C061746
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 02:03:41 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id p13so33861760edw.0
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 02:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1OXM5xYEvBEtIyncEW1wWzLj9wqHwe9KS0RSuWzENts=;
        b=ogz0OBqDI5kZqPg6M3tdzTneHEgAsKeLtkgrUQ9sS1QrfIiFIZ1nHK2FCCQNLBYCdM
         uTXPaKHCYNPHuK66BvrwHcRKTyKoiXGxc+tyqlN3ygQBpmyUGCeMka7Gu7tIGEq4EX1H
         867Y7PNOE2lgYYH7G+WPZn/UBoAg9Olfl0LEWu+TiTjlkjnpySDeXyaJK0Ku0KMkGuYT
         cymuHwFvi/cN0BSPN5uiorR/fT7c3iUJvix0zlEWsGyP+iqilGhVJ60wuFSHli2vsjsa
         aKCG8rSTYnq/dljXIK7UtCKugelaBPGjpkITG4nxpnjucDmgghvDw7G8AJH/ZJqec2Ax
         //DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1OXM5xYEvBEtIyncEW1wWzLj9wqHwe9KS0RSuWzENts=;
        b=sA7gjyLFg9STvx9kPiKZvOViOfre1JAB9JQjthf/HOgPybjp/L7BvB5PT54zuSRknj
         6w0hkMD7LMVTX4yi93IAA5qAf8IQrIRaftdWS8HcDMmDZicZJcf6ZNVz9SIeLne2dgwk
         zWYUVn55OKbK2+WwHA1yEiUE/nBV76CW656YXM5FfIlcMwR+l0pmyYNemjxjFIhi2LnH
         Iom+unsL5Fc0oj1Cge2ve1JxyQrQ3jFnYzsUglVpvMykm0UFBRm++O2L2LKq7OhW9vak
         ipPReqsrCuSIQq6VxB9KtmvXIwunS0ulVcw1Yaa2IRlXSaTKywMxlsLLYUge0c/nk2RE
         YXqw==
X-Gm-Message-State: AOAM530rbetRZLXGtwooK77JwdLOligQxJ54iX1PqV4KOqEn1GZE/Y33
        5NVtqXGEXNZ9l/pf46+tgUOPqIyIZQaGpVEo
X-Google-Smtp-Source: ABdhPJzYOz7Q+xoXQCrvqMCbgWe84RltAWGukgCWgXe8NwlY5mNhKVGkTA9/tQ0+KAHdvJ1Guk0zOQ==
X-Received: by 2002:a17:906:39cd:: with SMTP id i13mr15293017eje.227.1633338220158;
        Mon, 04 Oct 2021 02:03:40 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m9sm6348949edl.66.2021.10.04.02.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 02:03:39 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next] ip: nexthop: keep cache netlink socket open
Date:   Mon,  4 Oct 2021 12:03:28 +0300
Message-Id: <20211004090328.2329012-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <c036dc79-0d78-df8b-343b-fa9a913bd5cf@gmail.com>
References: <c036dc79-0d78-df8b-343b-fa9a913bd5cf@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Since we use the cache netlink socket for each nexthop we can keep it open
instead of opening and closing it on every add call. The socket is opened
once, on the first add call and then reused for the rest.

Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
I actually had this in my initial patchset, but switched it with the
open/close on each call. TBH, I don't recall why, perhaps to be the same
as the link cache. I don't see a reason not to keep the socket open.

I've re-run the stress test and the selftests, all look good.

 ip/ipnexthop.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index b4d44a86429c..83a5540e771c 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -35,6 +35,7 @@ enum {
 			NLMSG_ALIGN(sizeof(struct nhmsg))))
 
 static struct hlist_head nh_cache[NH_CACHE_SIZE];
+static struct rtnl_handle nh_cache_rth = { .fd = -1 };
 
 static void usage(void) __attribute__((noreturn));
 
@@ -563,14 +564,15 @@ static int __ipnh_cache_parse_nlmsg(const struct nlmsghdr *n,
 
 static struct nh_entry *ipnh_cache_add(__u32 nh_id)
 {
-	struct rtnl_handle cache_rth = { .fd = -1 };
 	struct nlmsghdr *answer = NULL;
 	struct nh_entry *nhe = NULL;
 
-	if (rtnl_open(&cache_rth, 0) < 0)
+	if (nh_cache_rth.fd < 0 && rtnl_open(&nh_cache_rth, 0) < 0) {
+		nh_cache_rth.fd = -1;
 		goto out;
+	}
 
-	if (__ipnh_get_id(&cache_rth, nh_id, &answer) < 0)
+	if (__ipnh_get_id(&nh_cache_rth, nh_id, &answer) < 0)
 		goto out;
 
 	nhe = malloc(sizeof(*nhe));
@@ -585,7 +587,6 @@ static struct nh_entry *ipnh_cache_add(__u32 nh_id)
 out:
 	if (answer)
 		free(answer);
-	rtnl_close(&cache_rth);
 
 	return nhe;
 
-- 
2.31.1

