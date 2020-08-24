Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA5E24FC63
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 13:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgHXLRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 07:17:54 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10261 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726466AbgHXLQU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 07:16:20 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B6F12EAF421CE81A63E4;
        Mon, 24 Aug 2020 19:16:17 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Mon, 24 Aug 2020
 19:16:11 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: Avoid access icmp_err_convert when icmp code is ICMP_FRAG_NEEDED
Date:   Mon, 24 Aug 2020 07:15:04 -0400
Message-ID: <20200824111504.22272-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to fetch errno and fatal info from icmp_err_convert when
icmp code is ICMP_FRAG_NEEDED.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/ipv4/raw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 6fd4330287c2..ea4c36e93824 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -260,11 +260,12 @@ static void raw_err(struct sock *sk, struct sk_buff *skb, u32 info)
 		err = EHOSTUNREACH;
 		if (code > NR_ICMP_UNREACH)
 			break;
-		err = icmp_err_convert[code].errno;
-		harderr = icmp_err_convert[code].fatal;
 		if (code == ICMP_FRAG_NEEDED) {
 			harderr = inet->pmtudisc != IP_PMTUDISC_DONT;
 			err = EMSGSIZE;
+		} else {
+			err = icmp_err_convert[code].errno;
+			harderr = icmp_err_convert[code].fatal;
 		}
 	}
 
-- 
2.19.1

