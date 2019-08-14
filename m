Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E00A98C920
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbfHNCMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:12:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727317AbfHNCMx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:12:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAF5F2133F;
        Wed, 14 Aug 2019 02:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748772;
        bh=P4TJyc5U0YWV3Iyqtz0kwXWq/cfcoyIoWUmJ3Hcj1SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUh4eW429bz/WKhopbCRqQuhTvs2619ZZ4A3BymZerSYKaGxwV1yl0rrlAVxW27hA
         2t/BUDCh29ZqyggRGsBmKrY9A7WNuVt9fHI5C02MHrIZSvikQNBdDpOCoMt3Qmas9J
         gNkjlwPU0xCRw16dEHbP2EJeqcQWruZoQhXwG86A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Jeffrey Altman <jaltman@auristor.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 060/123] rxrpc: Fix the lack of notification when sendmsg() fails on a DATA packet
Date:   Tue, 13 Aug 2019 22:09:44 -0400
Message-Id: <20190814021047.14828-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit c69565ee6681e151e2bb80502930a16e04b553d1 ]

Fix the fact that a notification isn't sent to the recvmsg side to indicate
a call failed when sendmsg() fails to transmit a DATA packet with the error
ENETUNREACH, EHOSTUNREACH or ECONNREFUSED.

Without this notification, the afs client just sits there waiting for the
call to complete in some manner (which it's not now going to do), which
also pins the rxrpc call in place.

This can be seen if the client has a scope-level IPv6 address, but not a
global-level IPv6 address, and we try and transmit an operation to a
server's IPv6 address.

Looking in /proc/net/rxrpc/calls shows completed calls just sat there with
an abort code of RX_USER_ABORT and an error code of -ENETUNREACH.

Fixes: c54e43d752c7 ("rxrpc: Fix missing start of call timeout")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/sendmsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 5d3f33ce6d410..bae14438f8691 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -226,6 +226,7 @@ static int rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 			rxrpc_set_call_completion(call,
 						  RXRPC_CALL_LOCAL_ERROR,
 						  0, ret);
+			rxrpc_notify_socket(call);
 			goto out;
 		}
 		_debug("need instant resend %d", ret);
-- 
2.20.1

