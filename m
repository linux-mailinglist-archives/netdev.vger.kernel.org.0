Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C844146252
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 08:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgAWHLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 02:11:38 -0500
Received: from relay.sw.ru ([185.231.240.75]:36272 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgAWHLi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 02:11:38 -0500
Received: from vvs-ws.sw.ru ([172.16.24.21])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <vvs@virtuozzo.com>)
        id 1iuWeP-0005pk-33; Thu, 23 Jan 2020 10:11:37 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 5/6] rt_cpu_seq_next should increase position index
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Message-ID: <1ec7f8d9-f8b5-430d-4622-634917f30d96@virtuozzo.com>
Date:   Thu, 23 Jan 2020 10:11:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/ipv4/route.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 87e979f..e356ea7 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -271,6 +271,7 @@ static void *rt_cpu_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 		*pos = cpu+1;
 		return &per_cpu(rt_cache_stat, cpu);
 	}
+	(*pos)++;
 	return NULL;
 
 }
-- 
1.8.3.1

