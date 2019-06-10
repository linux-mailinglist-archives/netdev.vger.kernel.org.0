Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6FE3AD9D
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 05:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387554AbfFJDY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 23:24:26 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:16421 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387483AbfFJDYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 23:24:25 -0400
X-IronPort-AV: E=Sophos;i="5.63,572,1557158400"; 
   d="scan'208";a="66690332"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 10 Jun 2019 11:24:14 +0800
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 5D60E4CDD44A;
        Mon, 10 Jun 2019 11:24:11 +0800 (CST)
Received: from localhost.localdomain (10.167.226.33) by
 G08CNEXCHPEKD03.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Mon, 10 Jun 2019 11:24:15 +0800
From:   Su Yanjun <suyj.fnst@cn.fujitsu.com>
To:     <vyasevich@gmail.com>, <nhorman@tuxdriver.com>,
        <marcelo.leitner@gmail.com>, <davem@davemloft.net>
CC:     <linux-sctp@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Su Yanjun <suyj.fnst@cn.fujitsu.com>
Subject: [PATCH] sctp: Add rcu lock to protect dst entry in sctp_transport_route
Date:   Mon, 10 Jun 2019 11:20:00 +0800
Message-ID: <1560136800-17961-1-git-send-email-suyj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.33]
X-yoursite-MailScanner-ID: 5D60E4CDD44A.ADDBD
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suyj.fnst@cn.fujitsu.com
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found a crash in rt_cache_valid. Problem is that when more
threads release dst in sctp_transport_route, the route cache can
be freed.

As follows,
p1:
sctp_transport_route
  dst_release
  get_dst

p2:
sctp_transport_route
  dst_release
  get_dst
...

If enough threads calling dst_release will cause dst->refcnt==0
then rcu softirq will reclaim the dst entry,get_dst then use
the freed memory.

This patch adds rcu lock to protect the dst_entry here.

Fixes: 6e91b578bf3f("sctp: re-use sctp_transport_pmtu in sctp_transport_route")
Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
Reported-by: syzbot+a9e23ea2aa21044c2798@syzkaller.appspotmail.com
---
 net/sctp/transport.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index ad158d3..5ad7e20 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -308,8 +308,13 @@ void sctp_transport_route(struct sctp_transport *transport,
 	struct sctp_association *asoc = transport->asoc;
 	struct sctp_af *af = transport->af_specific;
 
+	/* When dst entry is being released, route cache may be referred
+	 * again. Add rcu lock here to protect dst entry.
+	 */
+	rcu_read_lock();
 	sctp_transport_dst_release(transport);
 	af->get_dst(transport, saddr, &transport->fl, sctp_opt2sk(opt));
+	rcu_read_unlock();
 
 	if (saddr)
 		memcpy(&transport->saddr, saddr, sizeof(union sctp_addr));
-- 
2.7.4



