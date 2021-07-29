Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8B43D9EF2
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 09:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbhG2HrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 03:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbhG2HrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 03:47:17 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0B7C061757;
        Thu, 29 Jul 2021 00:47:14 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627544832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XXimOoQI1d0O8kEjg5QeSeqgs9ahW1SYrIjYJUFIUFk=;
        b=ZxU028pHpwvCtyCHblNHopevwPhNISY8scbRLab5RO12ZB79ThzDFEUOMpoitqLZcEhufp
        MJ54uK4qZoUJk7QEp6rYStFMQ0B1Ub76M1kpRxuJ5cFk3knShr9ucpjgEh5Q7sc/GbEd7f
        EuIcMCBQb5gpowr3KfbDZ5/moNDpICM=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH v2] netfilter: nf_conntrack_bridge: Fix memory leak when error
Date:   Thu, 29 Jul 2021 15:46:58 +0800
Message-Id: <20210729074658.8538-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It should be added kfree_skb_list() when err is not equal to zero
in nf_br_ip_fragment().

v2: keep this aligned with IPv6.

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 8d033a75a766..3cf5457919c6 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -88,6 +88,11 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 
 			skb = ip_fraglist_next(&iter);
 		}
+
+		if (!err)
+			return 0;
+
+		kfree_skb_list(iter.frag_list);
 		return err;
 	}
 slow_path:
-- 
2.32.0

