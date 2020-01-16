Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1365B13EC29
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406372AbgAPRyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:54:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405908AbgAPRoi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:44:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 603462476A;
        Thu, 16 Jan 2020 17:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196677;
        bh=LZXc39akRF9TdNnhbcpEkxTJJQMlUphOrcUB7D1NdQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKIx5JIgN+xkrHb6wi8jrqlAIhlaGXZl4wLCfp/juESJ7/6wETHXIM9hDYhZNCHaS
         5b66R/U5Os3jSnX2JNN91YQJuE4WEN+VUUSSVavStBhaCEpShVmKKGdvP5QzVb1bTc
         WMenUtb49PvHa4cmeuGgoLdJxuaqflIQUy1YvQHQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jie Liu <liujie165@huawei.com>, Qiang Ning <ningqiang1@huawei.com>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.4 076/174] tipc: set sysctl_tipc_rmem and named_timeout right range
Date:   Thu, 16 Jan 2020 12:41:13 -0500
Message-Id: <20200116174251.24326-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Liu <liujie165@huawei.com>

[ Upstream commit 4bcd4ec1017205644a2697bccbc3b5143f522f5f ]

We find that sysctl_tipc_rmem and named_timeout do not have the right minimum
setting. sysctl_tipc_rmem should be larger than zero, like sysctl_tcp_rmem.
And named_timeout as a timeout setting should be not less than zero.

Fixes: cc79dd1ba9c10 ("tipc: change socket buffer overflow control to respect sk_rcvbuf")
Fixes: a5325ae5b8bff ("tipc: add name distributor resiliency queue")
Signed-off-by: Jie Liu <liujie165@huawei.com>
Reported-by: Qiang Ning <ningqiang1@huawei.com>
Reviewed-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/sysctl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/tipc/sysctl.c b/net/tipc/sysctl.c
index 1a779b1e8510..40f6d82083d7 100644
--- a/net/tipc/sysctl.c
+++ b/net/tipc/sysctl.c
@@ -37,6 +37,8 @@
 
 #include <linux/sysctl.h>
 
+static int zero;
+static int one = 1;
 static struct ctl_table_header *tipc_ctl_hdr;
 
 static struct ctl_table tipc_table[] = {
@@ -45,14 +47,16 @@ static struct ctl_table tipc_table[] = {
 		.data		= &sysctl_tipc_rmem,
 		.maxlen		= sizeof(sysctl_tipc_rmem),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1         = &one,
 	},
 	{
 		.procname	= "named_timeout",
 		.data		= &sysctl_tipc_named_timeout,
 		.maxlen		= sizeof(sysctl_tipc_named_timeout),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1         = &zero,
 	},
 	{}
 };
-- 
2.20.1

