Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6041E26A7D
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbfEVTFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729580AbfEVTE6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:04:58 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6435B217D7;
        Wed, 22 May 2019 19:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558551898;
        bh=b28xSPEssqaFV/PPrRMM6D9x4tH5joeZEPvlHwNdgAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q8lima6+58aM0JT8QWvtUKpnc26q422FSCsWgA9uC4nIBlA64jackV0kMBAjaA2I9
         Pk9M5qA47Z/9SPI2OqlHMnHZG0dUwW4vUtJyOFxTehK5JAHqcLopBk1+IYNiaj0Dpe
         H6kOWVmv9+ZspV6KRpvEF8PhDyWYjo0PAnCMj6y4=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 net-next 6/8] ipv4: export fib_flush
Date:   Wed, 22 May 2019 12:04:44 -0700
Message-Id: <20190522190446.15486-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522190446.15486-1-dsahern@kernel.org>
References: <20190522190446.15486-1-dsahern@kernel.org>
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

