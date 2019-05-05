Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADB6614127
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 18:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfEEQjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 12:39:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727628AbfEEQjm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 12:39:42 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD4932133F;
        Sun,  5 May 2019 16:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557074381;
        bh=b28xSPEssqaFV/PPrRMM6D9x4tH5joeZEPvlHwNdgAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahkP3PFo51caejlG25mA2OjOu59e0XnrQDwODu8wxUtZU5zJd29SYbKxwbCoZmVZU
         9LTBltkb5bp3LJDcl1aBL2OMQEmUvomrypLo0zP8V+4GcyBsU5dijy5/3Hy99xXkQq
         RuoEjJ8/ldsEsNCWcMdlxggHnEVwEmVpwE8uOj94=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 6/7] ipv4: export fib_flush
Date:   Sun,  5 May 2019 09:40:55 -0700
Message-Id: <20190505164056.1742-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190505164056.1742-1-dsahern@kernel.org>
References: <20190505164056.1742-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

As nexthops are deleted, fib entries referencing it are marked dead.
Export fib_flush so those entries can be removed in a timely manner.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip_fib.h    | 1 +
 net/ipv4/fib_frontend.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 27d7c89ca9c4..79c18bd6a059 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -473,6 +473,7 @@ static inline void fib_combine_itag(u32 *itag, const struct fib_result *res)
 #endif
 }
 
+void fib_flush(struct net *net);
 void free_fib_info(struct fib_info *fi);
 
 static inline void fib_info_hold(struct fib_info *fi)
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index b298255f6fdb..dfa57a84ac14 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -192,7 +192,7 @@ int fib_unmerge(struct net *net)
 	return 0;
 }
 
-static void fib_flush(struct net *net)
+void fib_flush(struct net *net)
 {
 	int flushed = 0;
 	unsigned int h;
-- 
2.11.0

