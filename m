Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185A1137448
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 18:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgAJRAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 12:00:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:37308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbgAJRAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 12:00:19 -0500
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F48920673;
        Fri, 10 Jan 2020 17:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578675618;
        bh=fcF2Z0VWRYg6YqmRTCZGD/aAhbfa8rxUsLaBDZY+QfY=;
        h=From:To:Cc:Subject:Date:From;
        b=Bqk1d49HP3PEsy1ojwD4Pa6aOELCy8/aeKzc91zQTmVfDhhIrakPHSLWaN6XXoF2j
         kFOyPbu4CLuOISJOP/xBMZ0zdH0G0NFUs93KPhkVO7XRfEOhs7rJvq9RVTaVz2Bg9B
         qA1bhKyPjNSvVyV1LsBVSTWH+J6dn2soDfZ/3zI8=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, haegar@sdinet.de,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net] ipv4: Detect rollover in specific fib table dump
Date:   Fri, 10 Jan 2020 09:03:58 -0800
Message-Id: <20200110170358.29474-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Sven-Haegar reported looping on fib dumps when 255.255.255.255 route has
been added to a table. The looping is caused by the key rolling over from
FFFFFFFF to 0. When dumping a specific table only, we need a means to detect
when the table dump is done. The key and count saved to cb args are both 0
only at the start of the table dump. If key is 0 and count > 0, then we are
in the rollover case. Detect and return to avoid looping.

This only affects dumps of a specific table; for dumps of all tables
(the case prior to the change in the Fixes tag) inet_dump_fib moved
the entry counter to the next table and reset the cb args used by
fib_table_dump and fn_trie_dump_leaf, so the rollover ffffffff back
to 0 did not cause looping with the dumps.

Fixes: effe67926624 ("net: Enable kernel side filtering of route dumps")
Reported-by: Sven-Haegar Koch <haegar@sdinet.de>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/fib_trie.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index b9df9c09b84e..195469a13371 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2193,6 +2193,12 @@ int fib_table_dump(struct fib_table *tb, struct sk_buff *skb,
 	int count = cb->args[2];
 	t_key key = cb->args[3];
 
+	/* First time here, count and key are both always 0. Count > 0
+	 * and key == 0 means the dump has wrapped around and we are done.
+	 */
+	if (count && !key)
+		return skb->len;
+
 	while ((l = leaf_walk_rcu(&tp, key)) != NULL) {
 		int err;
 
-- 
2.11.0

