Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3AA2CFF1B
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgLEVPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbgLEVPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 16:15:02 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF25C0613CF
        for <netdev@vger.kernel.org>; Sat,  5 Dec 2020 13:14:21 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4CpMlG70LhzQlVP;
        Sat,  5 Dec 2020 22:14:18 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1607202857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AIhyi6Ww79w9PO28BVLYAAcyTrj3CvnLU7tjEBFmb10=;
        b=I8jTkNFn7bp5MQLl2fopwzWxAba6aj3qyGBQ/cRytR2WPBfSR4C0i7VsHEI3+KffTWQrkM
        kMcIfzmidgRes+8OYvv1vOKTVympt0BHqgb7AZODHAwNTqh8J8bT1pqiqfyvPK+4tvRA5d
        qDi2NKi5EVSwgXUiM4ZnAk1nEIda4b3FK62c8784BXKDYprizzObvJq55kEZVe8ZcCmCJl
        nLdKgbp/eN2ITdtCiwiDQo/hGTY8Rqowc7Ch5ePrIdOBRjreLx3p7wecn0ZusDAGPZ1b9e
        EOktgPyTz6L6YqdaNOlojsBBVVaDAOjrS78o2gLJcQcBn3Tta7TiVnEQV4Qu4Q==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id E33RKfmlbwJV; Sat,  5 Dec 2020 22:14:14 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Po.Liu@nxp.com, toke@toke.dk, dave.taht@gmail.com,
        edumazet@google.com, tahiliani@nitk.edu.in, leon@kernel.org,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v2 1/7] Move the use_iec declaration to the tools
Date:   Sat,  5 Dec 2020 22:13:29 +0100
Message-Id: <fcc1f303d0cb294f38ea63128d522fcd7736ef00.1607201857.git.me@pmachata.org>
In-Reply-To: <cover.1607201857.git.me@pmachata.org>
References: <cover.1607201857.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 2.06 / 15.00 / 15.00
X-Rspamd-Queue-Id: DCBDD1723
X-Rspamd-UID: 5546d4
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
index 227eddd3baf2..9a31e837563f 100644
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

