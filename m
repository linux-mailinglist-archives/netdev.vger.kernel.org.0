Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC91C2E85F7
	for <lists+netdev@lfdr.de>; Sat,  2 Jan 2021 01:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbhABAFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jan 2021 19:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbhABAFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jan 2021 19:05:32 -0500
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8723CC06179F
        for <netdev@vger.kernel.org>; Fri,  1 Jan 2021 16:04:40 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4D72Ds2MyQzQl91;
        Sat,  2 Jan 2021 01:04:13 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1609545849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZVyvI2kFbjj0FFkDsZa9rU+xYsNQrUsWQDdph2Hlnhw=;
        b=ZTbppG2DWhQcWuMpuQmYXhgHu5PP/dJ9WF16BtSBi1lkbuLlxaegJCKGHVWTODNhh4ScPi
        2lc13j3zK0gEH5usARJTK+1/uQyDLk/u8NtbrmEBMKh5eYM7H9E6YypvUVMltPmNJIaoVd
        YwmapBwAboxT2nNMagVc2BHj5hcBvXcvJmR81hCZKxMYnDc09itwYa4sMULftxwd3lLOwL
        7Gbap1MIgJxeMIle5IL5CI8iZrP3JD9bLdgZ/Ij6sPHboamU9G+UPhTNzUdUuyqrZVjXIJ
        4MIf8vte+nd7OHt0y06rGJ/s920WWWzjIxXT8DhxabeiZXCndBkdFY4OheQkRw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id tysVx5ZqZgDp; Sat,  2 Jan 2021 01:04:07 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v2 1/7] lib: rt_names: Add rtnl_dsfield_get_name()
Date:   Sat,  2 Jan 2021 01:03:35 +0100
Message-Id: <8f7f7d7266a60bb980d829fbebad36ff70ce2139.1609544200.git.me@pmachata.org>
In-Reply-To: <cover.1609544200.git.me@pmachata.org>
References: <cover.1609544200.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -0.07 / 15.00 / 15.00
X-Rspamd-Queue-Id: 08FF31726
X-Rspamd-UID: d0ea65
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For formatting DSCP (not full dsfield), it would be handy to be able to
just get the name from the name table, and not get any of the remaining
cruft related to formatting. Add a new entry point to just fetch the
name table string uninterpreted. Use it from rtnl_dsfield_n2a().

Signed-off-by: Petr Machata <me@pmachata.org>
---
 include/rt_names.h |  1 +
 lib/rt_names.c     | 20 ++++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/rt_names.h b/include/rt_names.h
index 990ed7f22e69..1835f3be2bed 100644
--- a/include/rt_names.h
+++ b/include/rt_names.h
@@ -9,6 +9,7 @@ const char *rtnl_rtscope_n2a(int id, char *buf, int len);
 const char *rtnl_rttable_n2a(__u32 id, char *buf, int len);
 const char *rtnl_rtrealm_n2a(int id, char *buf, int len);
 const char *rtnl_dsfield_n2a(int id, char *buf, int len);
+const char *rtnl_dsfield_get_name(int id);
 const char *rtnl_group_n2a(int id, char *buf, int len);
 
 int rtnl_rtprot_a2n(__u32 *id, const char *arg);
diff --git a/lib/rt_names.c b/lib/rt_names.c
index ca0680a12150..b976471d7979 100644
--- a/lib/rt_names.c
+++ b/lib/rt_names.c
@@ -479,18 +479,30 @@ static void rtnl_rtdsfield_initialize(void)
 
 const char *rtnl_dsfield_n2a(int id, char *buf, int len)
 {
+	const char *name;
+
 	if (id < 0 || id >= 256) {
 		snprintf(buf, len, "%d", id);
 		return buf;
 	}
+	if (!numeric) {
+		name = rtnl_dsfield_get_name(id);
+		if (name != NULL)
+			return name;
+	}
+	snprintf(buf, len, "0x%02x", id);
+	return buf;
+}
+
+const char *rtnl_dsfield_get_name(int id)
+{
+	if (id < 0 || id >= 256)
+		return NULL;
 	if (!rtnl_rtdsfield_tab[id]) {
 		if (!rtnl_rtdsfield_init)
 			rtnl_rtdsfield_initialize();
 	}
-	if (!numeric && rtnl_rtdsfield_tab[id])
-		return rtnl_rtdsfield_tab[id];
-	snprintf(buf, len, "0x%02x", id);
-	return buf;
+	return rtnl_rtdsfield_tab[id];
 }
 
 
-- 
2.26.2

