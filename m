Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8A5482322
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 11:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhLaKDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 05:03:38 -0500
Received: from smtp25.cstnet.cn ([159.226.251.25]:40350 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229448AbhLaKDi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Dec 2021 05:03:38 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-05 (Coremail) with SMTP id zQCowACniBVg1c5hbcFdBQ--.39772S2;
        Fri, 31 Dec 2021 18:03:12 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] mac80211: mlme: check for null after calling kmemdup
Date:   Fri, 31 Dec 2021 18:03:11 +0800
Message-Id: <20211231100311.1964437-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowACniBVg1c5hbcFdBQ--.39772S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Wr45Gw1UWr4xJF4DtF18Zrb_yoWkXrb_KF
        1qyrs8Zw17t3y3JrW8KayjqFs7GrsaqFWfKF9a9FZavwn3J3y7Cws3JwnxGr4xC3yYvrZx
        W34qvryrtanrWjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbckFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8twCF
        04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
        1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
        0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the possible failure of the alloc, the ifmgd->assoc_req_ies might be
NULL pointer and will be used by cfg80211_rx_assoc_resp() with the wrong
length.
Therefore it might be better to set length to 0 if fails as same as
ieee80211_mgd_stop().

Fixes: 4d9ec73d2b78 ("cfg80211: Report Association Request frame IEs in association events")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 net/mac80211/mlme.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9bed6464c5bd..258b492c699c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1058,7 +1058,10 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	pos = skb_tail_pointer(skb);
 	kfree(ifmgd->assoc_req_ies);
 	ifmgd->assoc_req_ies = kmemdup(ie_start, pos - ie_start, GFP_ATOMIC);
-	ifmgd->assoc_req_ies_len = pos - ie_start;
+	if (!ifmgd->assoc_req_ies)
+		ifmgd->assoc_req_ies_len = 0;
+	else
+		ifmgd->assoc_req_ies_len = pos - ie_start;
 
 	drv_mgd_prepare_tx(local, sdata, 0);
 
-- 
2.25.1

