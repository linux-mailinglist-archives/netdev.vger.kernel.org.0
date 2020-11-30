Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8295E2C91E9
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbgK3XC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgK3XC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 18:02:57 -0500
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEE7C0613D4
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 15:02:16 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4ClLMd4FhkzQlLV;
        Tue,  1 Dec 2020 00:01:49 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1606777307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jQ2+5BH4aadfbLzfbExjPsceO7UgLnWDIkGehVfjgdE=;
        b=wmoGIxVGyFHJB7yCij+K3fzsqJqhCioQh/tE2DhqshLgMCjhcDJ3HZr6VmiG2lwD8HkuK1
        xir5vBvosiBSxp5uUWAAaCNKWvcOD0VGUXC6B9PljY8rRxAsbGKs6S7HLenESwlw58zlrq
        qV3WAwF+3cFZnLbiUOIuoixxTzf514nnKuZs7nJ+Xflw1olZn6lWbVXYRXaIwzdXhPJCtv
        1Ox+Y942bW+I+W7fWDyprxnhBSz/jSQ43KS3OIwlylbdgHJOJxKT6cooFRyFpRVKrTvS76
        RSLGgMzG0zCaW3WHsUfst0q1yiWkD89r8XI8/jT/KgLEfEmAzFuqYvGIBdXviA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id tRIG02he3tJf; Tue,  1 Dec 2020 00:01:46 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Po.Liu@nxp.com, toke@toke.dk, dave.taht@gmail.com,
        edumazet@google.com, tahiliani@nitk.edu.in, vtlam@google.com,
        leon@kernel.org, Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 1/6] Move the use_iec declaration to the tools
Date:   Mon, 30 Nov 2020 23:59:37 +0100
Message-Id: <0dd14879918ec69e067eace196dad9dca63f824a.1606774951.git.me@pmachata.org>
In-Reply-To: <cover.1606774951.git.me@pmachata.org>
References: <cover.1606774951.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.66 / 15.00 / 15.00
X-Rspamd-Queue-Id: 804C71478
X-Rspamd-UID: 024583
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tools "ip" and "tc" use a flag "use_iec", which indicates whether, when
formatting rate values, the prefixes "K", "M", etc. should refer to powers
of 1024, or powers of 1000. The flag is currently kept as a global variable
in "ip" and "tc", but is nonetheless declared in util.h.

Instead, move the declaration to tool-specific headers ip/ip_common.h and
tc/tc_common.h.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 include/utils.h | 1 -
 ip/ip_common.h  | 2 ++
 tc/tc_common.h  | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/utils.h b/include/utils.h
index 588fceb72442..01454f71cb1a 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -20,7 +20,6 @@
 
 extern int preferred_family;
 extern int human_readable;
-extern int use_iec;
 extern int show_stats;
 extern int show_details;
 extern int show_raw;
diff --git a/ip/ip_common.h b/ip/ip_common.h
index d604f7554405..bba15f87ab94 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -6,6 +6,8 @@
 
 #include "json_print.h"
 
+extern int use_iec;
+
 struct link_filter {
 	int ifindex;
 	int family;
diff --git a/tc/tc_common.h b/tc/tc_common.h
index 802fb7f01fe4..58dc9d6a6c4f 100644
--- a/tc/tc_common.h
+++ b/tc/tc_common.h
@@ -27,3 +27,4 @@ int check_size_table_opts(struct tc_sizespec *s);
 
 extern int show_graph;
 extern bool use_names;
+extern int use_iec;
-- 
2.25.1

