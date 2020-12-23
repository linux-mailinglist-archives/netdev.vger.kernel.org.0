Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909572E2066
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 19:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgLWS1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 13:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbgLWS1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 13:27:04 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E900BC061794
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 10:26:23 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4D1M98533kzQlPD;
        Wed, 23 Dec 2020 19:26:20 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1608747978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=imtepctugE/gGTS9WZrUYv7GP3m65dpEvxwz95yZWsE=;
        b=tUt4lO2nDN4xPgRGtB8CmVOC49a/DO7K+/ypeo7IZHWEz4n3Sza51BN5jhxOIxtvQPvfP/
        hh0aKLPcMX0jM+R9GIz3OIIQ2tnKun5PL5xjETaj1Ah45Lefmvd0Wvbc97JcP/3CYt25HH
        /IGqQbxjtN5C2Ty+Bzjjxd/PGf/4wPwFeo57tEtCGFDBSxjcMy6W1q8M7Y49kgnWZulK/s
        xf1VB7V0c3weBdx9fARM9FhNruOfztZ4u8bFs32pEXMo8oSWMkHNE3NU3Z8JnOikT2Wf0N
        C/fZdfOL16fd+KoKZflRrwaKdk2YyOQmJKpTGGE2edonQdFhIGFkZZyMR5C0pQ==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id NrByjnf6QBml; Wed, 23 Dec 2020 19:26:17 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 3/9] lib: rt_names: Add rtnl_dsfield_get_name()
Date:   Wed, 23 Dec 2020 19:25:41 +0100
Message-Id: <d5dc56c34e06e00aadbf12a3f518cd250357d18c.1608746691.git.me@pmachata.org>
In-Reply-To: <cover.1608746691.git.me@pmachata.org>
References: <cover.1608746691.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.00 / 15.00 / 15.00
X-Rspamd-Queue-Id: B57BB17D7
X-Rspamd-UID: a9a51e
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
2.25.1

