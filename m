Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC74B45643A
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 21:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbhKRUeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 15:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbhKRUeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 15:34:16 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD82C061748
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:31:15 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so7383560pjb.1
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TcLB7MvG3K4Ke10h1bINRCs3q+QDRcCT3lfYvCR0Icg=;
        b=eF6YFsU21ZNpUT9ttG8va6xfpqx992IvMr6iI4uWNx3Pi4DmcbDIos4Wu0d7fCnbOa
         2i0Q2JaqJO6RFFFu7I3C9jpN+/7Gfho/SD4r6QgMcQxBKiyIpei3Irq/AsGzMdTeNNPi
         qsXM+DEypZ3V0IH04X71UaBa7n7L2U77ZXVyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TcLB7MvG3K4Ke10h1bINRCs3q+QDRcCT3lfYvCR0Icg=;
        b=1B1qHO7sjs68K+m+opZmmxVPAvTY8rwV8Uu0ZIQPmsEhZUBgeIGG09kHyxbBeIe4jp
         4PzAJtbCb7RasAE0/jFDnGI78uVAtqTejmOXtSNou8nP1YKI6ePeqTAXc915B1KRYoID
         FR3lEcvW+tnWmvVupirO/zCYyhvcBKGWcQELcEHrBXAV+b0oF+OxqVzNnTKQzly5aqBG
         G53bL+1ajT4L37OYVAdhhmEdrzSwm0r30lPqb29tLfaTvV7LoNJvfRNMvgEMtWzTg3zm
         Fpqsr/c3NKdxmOYQIxtiodPouHF82+RbRFVC2/lmI5t3T+pt6GxybCjAEnl3/UoOmrru
         TcdA==
X-Gm-Message-State: AOAM530Aw3/IwF8hVJcgjQkLyGCWvy+kIf3D1pcUt355MZt1cUx9AQpM
        esEKhQ333zTCPpXYDuhmSXD1PA==
X-Google-Smtp-Source: ABdhPJzRya15wHW2UAKLnXUjjo2OcJuImXw4tuyrV18/sEsTXSQY7dn3QqXgLgUi5g6uysZtaiNrKA==
X-Received: by 2002:a17:90a:df83:: with SMTP id p3mr13827388pjv.145.1637267475336;
        Thu, 18 Nov 2021 12:31:15 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g17sm453059pfv.136.2021.11.18.12.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 12:31:15 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] netfilter: conntrack: Use memset_startat() to zero struct nf_conn
Date:   Thu, 18 Nov 2021 12:31:13 -0800
Message-Id: <20211118203113.1286928-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=989; h=from:subject; bh=8G8ELxCaYyImypCEBWdgERqa1W0PnBKrxOA03FjrnuI=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhlrgQ81go+amAV4Ra130N28YvcOlvVMevTi2OsK0V PP+vTgmJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZa4EAAKCRCJcvTf3G3AJhlGEA CjA7esHrkQXRc1xiiREdoZsmG60wWX92CFRgE+X8+C993iK8CaPdrfi+8Rhz2iOksVsnAYaNX8DR3T jKd0zhYJMa7TtVHL8OMDF3GCDJib0UYXjG1ocqe/hwTOyyANGytLztehRyHb7B7Kb1b02ea+gw65wW xjiAan5E9RVw90+50uTGqkK9d2GfBsv2XcF3HEXzhktA0zkH4Aurk6CtKXr8Xprwysw32Xc9Omk8Su ARAP1kfq+qgC+vKE/wCvXvSEJ0xYbq959PtCQW41dbwGQTYiPvCNBc2zs/lnuNEwqr+D7ZJ7oFg5ct 6ftzPlVwPlX5ij7oit5cn9nSXzMlvAu2MCBlQnRij4gi0VTWmbdUNh5q1tQGnEk90rLXrfom5OGd66 /F46gyg6mlZi0u6cv51ZtnacUdXkjVSZfaguaj3I4owqxrNcw4LzyemNqfAHEcLAR/Ra5feQB8Ovjx jZe/OEwgFXlP+LeVKvotPY45hztqforSJyNLWlWsCopwG7wyt0uZKXVApXDKR39N+mMy41d1nRitT9 Cvb3wb5aH6OPXhaQ6BfWwRAzWtnvOmVSd9K/CHbQtRw/g55Qt0jT2raJQQlGD9oCarRkGQeA2wfy1o JNg+0TmqxKV1SHFoj+KWXJbJvzv9wT6Bt4kbwdO1rEkoaojBo8A7ObRgzmeQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Use memset_startat() to avoid confusing memset() about writing beyond
the target struct member.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/netfilter/nf_conntrack_core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 770a63103c7a..cdfb63509501 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1562,9 +1562,7 @@ __nf_conntrack_alloc(struct net *net,
 	ct->status = 0;
 	ct->timeout = 0;
 	write_pnet(&ct->ct_net, net);
-	memset(&ct->__nfct_init_offset, 0,
-	       offsetof(struct nf_conn, proto) -
-	       offsetof(struct nf_conn, __nfct_init_offset));
+	memset_after(ct, 0, __nfct_init_offset);
 
 	nf_ct_zone_add(ct, zone);
 
-- 
2.30.2

