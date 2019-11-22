Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 801D9106268
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbfKVGDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:03:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:41974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbfKVGDD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 01:03:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56C362070B;
        Fri, 22 Nov 2019 06:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402583;
        bh=Ok3I6A0cc8kL/J20hG8eQcCcmH4Ge5h24qRJu31z9wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M9Q9WGCuX78UG2O0q1NNgrFtxAlNp4omUs0pkXi5CjCp9bRJliHVEGOYGZZPOd//w
         24QhzBktReTfOhi3rqyRmKfaVAtU7oz6C9PMhza0zX3ePC1ajidIlIzdw0YLEcbP3T
         T588s1jZtWEgfbU1cs5/JHWsfdkj7HoujGq5Tu78=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maciej Kwiecien <maciej.kwiecien@nokia.com>,
        Marcin Stojek <marcin.stojek@nokia.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 84/91] sctp: don't compare hb_timer expire date before starting it
Date:   Fri, 22 Nov 2019 01:01:22 -0500
Message-Id: <20191122060129.4239-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Kwiecien <maciej.kwiecien@nokia.com>

[ Upstream commit d1f20c03f48102e52eb98b8651d129b83134cae4 ]

hb_timer might not start at all for a particular transport because its
start is conditional. In a result a node is not sending heartbeats.

Function sctp_transport_reset_hb_timer has two roles:
    - initial start of hb_timer for a given transport,
    - update expire date of hb_timer for a given transport.
The function is optimized to update timer's expire only if it is before
a new calculated one but this comparison is invalid for a timer which
has not yet started. Such a timer has expire == 0 and if a new expire
value is bigger than (MAX_JIFFIES / 2 + 2) then "time_before" macro will
fail and timer will not start resulting in no heartbeat packets send by
the node.

This was found when association was initialized within first 5 mins
after system boot due to jiffies init value which is near to MAX_JIFFIES.

Test kernel version: 4.9.154 (ARCH=arm)
hb_timer.expire = 0;                //initialized, not started timer
new_expire = MAX_JIFFIES / 2 + 2;   //or more
time_before(hb_timer.expire, new_expire) == false

Fixes: ba6f5e33bdbb ("sctp: avoid refreshing heartbeat timer too often")
Reported-by: Marcin Stojek <marcin.stojek@nokia.com>
Tested-by: Marcin Stojek <marcin.stojek@nokia.com>
Signed-off-by: Maciej Kwiecien <maciej.kwiecien@nokia.com>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 03d71cd97ec08..5c78942550e97 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -205,7 +205,8 @@ void sctp_transport_reset_hb_timer(struct sctp_transport *transport)
 
 	/* When a data chunk is sent, reset the heartbeat interval.  */
 	expires = jiffies + sctp_transport_timeout(transport);
-	if (time_before(transport->hb_timer.expires, expires) &&
+	if ((time_before(transport->hb_timer.expires, expires) ||
+	     !timer_pending(&transport->hb_timer)) &&
 	    !mod_timer(&transport->hb_timer,
 		       expires + prandom_u32_max(transport->rto)))
 		sctp_transport_hold(transport);
-- 
2.20.1

