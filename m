Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15EBA14624B
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 08:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgAWHLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 02:11:19 -0500
Received: from relay.sw.ru ([185.231.240.75]:36244 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgAWHLT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 02:11:19 -0500
Received: from vvs-ws.sw.ru ([172.16.24.21])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <vvs@virtuozzo.com>)
        id 1iuWe2-0005pI-2j; Thu, 23 Jan 2020 10:11:14 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 2/6] l2t_seq_next should increase position index
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org
Message-ID: <2e5504c8-edbe-395c-88f7-a69a7f681036@virtuozzo.com>
Date:   Thu, 23 Jan 2020 10:11:13 +0300
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
 drivers/net/ethernet/chelsio/cxgb4/l2t.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/l2t.c b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
index e9e4500..1a16449 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/l2t.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
@@ -678,8 +678,7 @@ static void *l2t_seq_start(struct seq_file *seq, loff_t *pos)
 static void *l2t_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	v = l2t_get_idx(seq, *pos);
-	if (v)
-		++*pos;
+	++(*pos);
 	return v;
 }
 
-- 
1.8.3.1

