Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3768A367390
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 21:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243742AbhDUTnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 15:43:19 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:37088 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241211AbhDUTnP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 15:43:15 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619034161; h=Content-Type: MIME-Version: Message-ID:
 Subject: Cc: To: From: Date: Sender;
 bh=vNoreGJpN2zFBzxWUhIMCetNAVN//zoCXymlx1dTtb8=; b=qtR7/1g0Yxl/EuEkh101abc2FVELI2da+/5iuVV4ofcMsv+gE455wMzfndVZXQFsBl1teGsj
 3iHaNJoCYAYGdzDkEROvfDUceP/fH+IgWJtGXHlNIetGR4t6n+re8osWh+R8Y89ru8jzzSaK
 lp4fHpBb0oTTzj00/zJTGVnNxR4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 60808029853c0a2c46983bee (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 21 Apr 2021 19:42:33
 GMT
Sender: chinagar=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AFBC5C43460; Wed, 21 Apr 2021 19:42:32 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from chinagar-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chinagar)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4985FC433F1;
        Wed, 21 Apr 2021 19:42:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4985FC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=chinagar@codeaurora.org
Date:   Thu, 22 Apr 2021 01:12:22 +0530
From:   Chinmay Agarwal <chinagar@codeaurora.org>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        xiyou.wangcong@gmail.com
Cc:     chinmay.12cs207@gmail.com, sharathv@codeaurora.org
Subject: [PATCH] neighbour: Prevent Race condition in neighbour subsytem
Message-ID: <20210421194212.GA5676@chinagar-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following Race Condition was detected:

<CPU A, t0>: Executing: __netif_receive_skb() ->__netif_receive_skb_core()
-> arp_rcv() -> arp_process().arp_process() calls __neigh_lookup() which
takes a reference on neighbour entry 'n'.
Moves further along, arp_process() and calls neigh_update()->
__neigh_update(). Neighbour entry is unlocked just before a call to
neigh_update_gc_list.

This unlocking paves way for another thread that may take a reference on
the same and mark it dead and remove it from gc_list.

<CPU B, t1> - neigh_flush_dev() is under execution and calls
neigh_mark_dead(n) marking the neighbour entry 'n' as dead. Also n will be
removed from gc_list.
Moves further along neigh_flush_dev() and calls
neigh_cleanup_and_release(n), but since reference count increased in t1,
'n' couldn't be destroyed.

<CPU A, t3>- Code hits neigh_update_gc_list, with neighbour entry
set as dead.

<CPU A, t4> - arp_process() finally calls neigh_release(n), destroying
the neighbour entry and we have a destroyed ntry still part of gc_list.

Fixes: eb4e8fac00d1("neighbour: Prevent a dead entry from updating gc_list")
Signed-off-by: Chinmay Agarwal <chinagar@codeaurora.org>
---
 net/core/neighbour.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index c26ecbe..bce395ed 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -133,6 +133,9 @@ static void neigh_update_gc_list(struct neighbour *n)
 	write_lock_bh(&n->tbl->lock);
 	write_lock(&n->lock);
 
+	if (n->dead)
+		goto out;
+
 	/* remove from the gc list if new state is permanent or if neighbor
 	 * is externally learned; otherwise entry should be on the gc list
 	 */
@@ -149,6 +152,7 @@ static void neigh_update_gc_list(struct neighbour *n)
 		atomic_inc(&n->tbl->gc_entries);
 	}
 
+out:
 	write_unlock(&n->lock);
 	write_unlock_bh(&n->tbl->lock);
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

