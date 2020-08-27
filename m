Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732AC25511A
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 00:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgH0WdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 18:33:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbgH0WdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 18:33:14 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33D7420B80;
        Thu, 27 Aug 2020 22:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598567594;
        bh=D/YPsAYRAGpzuQZHWDZnyq/tJC1zikV3r+8kkiFiJQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ws6HLszuTrqMO20mHwy9jPqzLPbS0pqzNcv04MhbJ60+0JB4qG0LZusKVGJjaLB/7
         E6U68E4RPIhyDwmf/4bNj0R4l6MxPFcvfLp7lZIVeAg5VcFyqRqksvMMO40bNlqzWu
         VUof3bpWVFyBDlUavwr0BwxgT+3Jsm+z9Z4km3o0=
From:   Jakub Kicinski <kuba@kernel.org>
To:     eric.dumazet@gmail.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC -next 3/3] net: make sure napi_list is safe for RCU traversal
Date:   Thu, 27 Aug 2020 15:32:50 -0700
Message-Id: <20200827223250.2045503-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200827223250.2045503-1-kuba@kernel.org>
References: <20200827104753.29d836bb@kicinski-fedora-PC1C0HJN>
 <20200827223250.2045503-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netpoll needs to traverse dev->napi_list under RCU, make
sure it uses the right iterator and that removal from this
list is handled safely.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev.c     | 2 +-
 net/core/netpoll.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 623060907132..dfb4a4137eea 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6656,7 +6656,7 @@ void __netif_napi_del(struct napi_struct *napi)
 		return;
 
 	napi_hash_del(napi);
-	list_del_init(&napi->dev_list);
+	list_del_rcu(&napi->dev_list);
 	napi_free_frags(napi);
 
 	flush_gro_hash(napi);
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 2338753e936b..c310c7c1cef7 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -297,7 +297,7 @@ static int netpoll_owner_active(struct net_device *dev)
 {
 	struct napi_struct *napi;
 
-	list_for_each_entry(napi, &dev->napi_list, dev_list) {
+	list_for_each_entry_rcu(napi, &dev->napi_list, dev_list) {
 		if (napi->poll_owner == smp_processor_id())
 			return 1;
 	}
-- 
2.26.2

