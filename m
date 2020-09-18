Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CE626F075
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbgIRCn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:43:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727527AbgIRCKl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:10:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85E802311A;
        Fri, 18 Sep 2020 02:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395040;
        bh=dd0qtlhGR+BuXIEjFCLdHvdAATNJgb10wbQgvOO26c8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TS9aa9HCgMaGIbhWhcFisuPFuwT1/eAN57lgkgaam6Gw3euV+16B9yoVjWbNVhv14
         tZ3yhKdxmaNgSkmQQIqprt7enwweION/vGeD1I8HKWDkhO3C2OF/ZsLBCmAdVisGry
         e6QjuO7MlYj5vZ1+54c2BOosxqzdFEHJwBpu75rw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 130/206] SUNRPC: Fix a potential buffer overflow in 'svc_print_xprts()'
Date:   Thu, 17 Sep 2020 22:06:46 -0400
Message-Id: <20200918020802.2065198-130-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b25b60d7bfb02a74bc3c2d998e09aab159df8059 ]

'maxlen' is the total size of the destination buffer. There is only one
caller and this value is 256.

When we compute the size already used and what we would like to add in
the buffer, the trailling NULL character is not taken into account.
However, this trailling character will be added by the 'strcat' once we
have checked that we have enough place.

So, there is a off-by-one issue and 1 byte of the stack could be
erroneously overwridden.

Take into account the trailling NULL, when checking if there is enough
place in the destination buffer.

While at it, also replace a 'sprintf' by a safer 'snprintf', check for
output truncation and avoid a superfluous 'strlen'.

Fixes: dc9a16e49dbba ("svc: Add /proc/sys/sunrpc/transport files")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
[ cel: very minor fix to documenting comment
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc_xprt.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index c8ee8e801edb8..709c082dc9059 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -103,8 +103,17 @@ void svc_unreg_xprt_class(struct svc_xprt_class *xcl)
 }
 EXPORT_SYMBOL_GPL(svc_unreg_xprt_class);
 
-/*
- * Format the transport list for printing
+/**
+ * svc_print_xprts - Format the transport list for printing
+ * @buf: target buffer for formatted address
+ * @maxlen: length of target buffer
+ *
+ * Fills in @buf with a string containing a list of transport names, each name
+ * terminated with '\n'. If the buffer is too small, some entries may be
+ * missing, but it is guaranteed that all lines in the output buffer are
+ * complete.
+ *
+ * Returns positive length of the filled-in string.
  */
 int svc_print_xprts(char *buf, int maxlen)
 {
@@ -117,9 +126,9 @@ int svc_print_xprts(char *buf, int maxlen)
 	list_for_each_entry(xcl, &svc_xprt_class_list, xcl_list) {
 		int slen;
 
-		sprintf(tmpstr, "%s %d\n", xcl->xcl_name, xcl->xcl_max_payload);
-		slen = strlen(tmpstr);
-		if (len + slen > maxlen)
+		slen = snprintf(tmpstr, sizeof(tmpstr), "%s %d\n",
+				xcl->xcl_name, xcl->xcl_max_payload);
+		if (slen >= sizeof(tmpstr) || len + slen >= maxlen)
 			break;
 		len += slen;
 		strcat(buf, tmpstr);
-- 
2.25.1

