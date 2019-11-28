Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5398310C2CD
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 04:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfK1DYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 22:24:14 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:32835 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727158AbfK1DYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 22:24:14 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 554E74B9CE;
        Thu, 28 Nov 2019 14:10:12 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mail_dkim; t=
        1574910612; bh=Sw2Vgr5NV1VBdyDW0t95lQSFCjtXjdlYSHiNMpVWzk0=; b=I
        gr72pBAgwGDTXiPoBK3zHBoGJrlFTfVB4LY96Jnunw53jMh6waKJIa6ZQOsRkytk
        fPB5uo/vL7jwiCkU2cO9pzTVkto6v1tR9ailFqp74ldLEQTD/6NG/1OZ/kPsEYk8
        RcFSoBMUv/vX8/5F827+uhuD0nSb73TYZP0vm22xZY=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vPV-rGFSNMdk; Thu, 28 Nov 2019 14:10:12 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 38F6A4B9CF;
        Thu, 28 Nov 2019 14:10:12 +1100 (AEDT)
Received: from ubuntu.dek-tpc.internal (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 9CEB34B9CE;
        Thu, 28 Nov 2019 14:10:11 +1100 (AEDT)
From:   Tung Nguyen <tung.q.nguyen@dektech.com.au>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [tipc-discussion] [net v1 2/4] tipc: fix wrong socket reference counter after tipc_sk_timeout() returns
Date:   Thu, 28 Nov 2019 10:10:06 +0700
Message-Id: <20191128031008.2045-3-tung.q.nguyen@dektech.com.au>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128031008.2045-1-tung.q.nguyen@dektech.com.au>
References: <20191128031008.2045-1-tung.q.nguyen@dektech.com.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When tipc_sk_timeout() is executed but user space is grabbing
ownership, this function rearms itself and returns. However, the
socket reference counter is not reduced. This causes potential
unexpected behavior.

This commit fixes it by calling sock_put() before tipc_sk_timeout()
returns in the above-mentioned case.

Fixes: afe8792fec69 ("tipc: refactor function tipc_sk_timeout()")
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
---
 net/tipc/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 7baed2c2c93d..fb5595081a05 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2759,6 +2759,7 @@ static void tipc_sk_timeout(struct timer_list *t)
 	if (sock_owned_by_user(sk)) {
 		sk_reset_timer(sk, &sk->sk_timer, jiffies + HZ / 20);
 		bh_unlock_sock(sk);
+		sock_put(sk);
 		return;
 	}
 
-- 
2.17.1

