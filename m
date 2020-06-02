Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B385C1EB606
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 08:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgFBGwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 02:52:39 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37582 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725872AbgFBGwj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 02:52:39 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 32A486DE0EC8CB2A7582;
        Tue,  2 Jun 2020 14:52:37 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Tue, 2 Jun 2020
 14:52:27 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>,
        <alex.aring@gmail.com>, <ahabdels@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] seg6: Fix slab-out-of-bounds in fl6_update_dst()
Date:   Tue, 2 Jun 2020 14:51:55 +0800
Message-ID: <20200602065155.18272-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When update flowi6 daddr in fl6_update_dst() for srcrt, the used index
of segments should be segments_left minus one per RFC8754
(section 4.3.1.1) S15 S16. Otherwise it may results in an out-of-bounds
read.

Reported-by: syzbot+e8c028b62439eac42073@syzkaller.appspotmail.com
Fixes: 0cb7498f234e ("seg6: fix SRH processing to comply with RFC8754")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/ipv6/exthdrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 5a8bbcdcaf2b..f5304bf33ab1 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -1353,7 +1353,7 @@ struct in6_addr *fl6_update_dst(struct flowi6 *fl6,
 	{
 		struct ipv6_sr_hdr *srh = (struct ipv6_sr_hdr *)opt->srcrt;
 
-		fl6->daddr = srh->segments[srh->segments_left];
+		fl6->daddr = srh->segments[srh->segments_left - 1];
 		break;
 	}
 	default:
-- 
2.17.1


