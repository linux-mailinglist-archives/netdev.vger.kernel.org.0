Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBC98BAF6
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 15:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbfHMN7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 09:59:35 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57860 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729168AbfHMN7e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 09:59:34 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4022E7F344FFDF221A67;
        Tue, 13 Aug 2019 21:59:30 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Tue, 13 Aug 2019
 21:59:21 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <vyasevich@gmail.com>, <nhorman@tuxdriver.com>,
        <marcelo.leitner@gmail.com>, <davem@davemloft.net>,
        <linux-sctp@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH] sctp: fix memleak in sctp_send_reset_streams
Date:   Tue, 13 Aug 2019 22:05:50 +0800
Message-ID: <1565705150-17242-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the stream outq is not empty, need to kfree nstr_list.

Fixes: d570a59c5b5f ("sctp: only allow the out stream reset when the stream outq is empty")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 net/sctp/stream.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 2594660..e83cdaa 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -316,6 +316,7 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
 		nstr_list[i] = htons(str_list[i]);

 	if (out && !sctp_stream_outq_is_empty(stream, str_nums, nstr_list)) {
+		kfree(nstr_list);
 		retval = -EAGAIN;
 		goto out;
 	}
--
2.7.4

