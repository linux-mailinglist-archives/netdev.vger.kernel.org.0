Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A736A302CD6
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 21:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732064AbhAYUn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 15:43:56 -0500
Received: from a1.mail.mailgun.net ([198.61.254.60]:51549 "EHLO
        a1.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731266AbhAYTuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 14:50:25 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611604206; h=Content-Type: MIME-Version: Message-ID:
 Subject: Cc: To: From: Date: Sender;
 bh=Gud41NJ96Erxd4slcT3VGJ5GJsjYT1kgQCvNOvQB01w=; b=vDIoUxw1uMK+FSuk23VSl8wZ03Oc9NG2pM7Js6y62qjbOK2i2AuqxGTYnQ6JhYFo+yRK2afR
 c9JN/OYrGlJpPFsebLDZqeE+NdNECemi8LMs56Z+BVJpV9AxfRvZd7VCxrQfJBBE8XbgkehA
 OnsKaKMgTJ8hXvVYIZLcNO9X/pY=
X-Mailgun-Sending-Ip: 198.61.254.60
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 600f20c872b7c29fd591f3df (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 25 Jan 2021 19:49:28
 GMT
Sender: chinagar=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6B557C43461; Mon, 25 Jan 2021 19:49:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from chinagar-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chinagar)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 360D9C433CA;
        Mon, 25 Jan 2021 19:49:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 360D9C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=chinagar@codeaurora.org
Date:   Tue, 26 Jan 2021 01:19:18 +0530
From:   Chinmay Agarwal <chinagar@codeaurora.org>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        xiyou.wangcong@gmail.com
Cc:     sharathv@codeaurora.org
Subject: [PATCH] neighbour: Prevent a dead entry from updating gc_list
Message-ID: <20210125194908.GA17992@chinagar-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following race condition was detected:
<CPU A, t0> - neigh_flush_dev() is under execution and calls neigh_mark_dead(n),
marking the neighbour entry 'n' as dead.

<CPU B, t1> - Executing: __netif_receive_skb() -> __netif_receive_skb_core()
-> arp_rcv() -> arp_process().arp_process() calls __neigh_lookup() which takes
a reference on neighbour entry 'n'.

<CPU A, t2> - Moves further along neigh_flush_dev() and calls
neigh_cleanup_and_release(n), but since reference count increased in t2,
'n' couldn't be destroyed.

<CPU B, t3> - Moves further along, arp_process() and calls
neigh_update()-> __neigh_update() -> neigh_update_gc_list(), which adds
the neighbour entry back in gc_list(neigh_mark_dead(), removed it
earlier in t0 from gc_list)

<CPU B, t4> - arp_process() finally calls neigh_release(n), destroying
the neighbour entry.

This leads to 'n' still being part of gc_list, but the actual
neighbour structure has been freed.

The situation can be prevented from happening if we disallow a dead
entry to have any possibility of updating gc_list. This is what the
patch intends to achieve.

Signed-off-by: Chinmay Agarwal <chinagar@codeaurora.org>
---
 net/core/neighbour.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index ff07358..cf8e3076 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1244,13 +1244,14 @@ static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
 	old    = neigh->nud_state;
 	err    = -EPERM;
 
-	if (!(flags & NEIGH_UPDATE_F_ADMIN) &&
-	    (old & (NUD_NOARP | NUD_PERMANENT)))
-		goto out;
 	if (neigh->dead) {
 		NL_SET_ERR_MSG(extack, "Neighbor entry is now dead");
+		new=old;
 		goto out;
 	}
+	if (!(flags & NEIGH_UPDATE_F_ADMIN) &&
+	    (old & (NUD_NOARP | NUD_PERMANENT)))
+		goto out;
 
 	ext_learn_change = neigh_update_ext_learned(neigh, flags, &notify);
 
-- 

