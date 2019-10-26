Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D000E5A9A
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbfJZNQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:16:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbfJZNQ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:16:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C5002070B;
        Sat, 26 Oct 2019 13:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095788;
        bh=SDGyo0NT2cQC5avrsBr7kyb3jRJsCnz9UDUEz/Zvzg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RmS1aFPB1sQ5bhvwwv9loD27u5ySn1wJowHvWB5Cuyd+FG4I1xGH8cTyStVOfmX2u
         +didjmDetN4A4eNNbz0jZW9vojUrNdIz9c1mojqHgURsmXPXb1wJQMMeo40wRRuu6r
         AL/xaX6APe97zH/sl4aV2YnUy6+TDcxFDhMK/pw0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        syzbot+d850c266e3df14da1d31@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 16/99] rxrpc: Fix call ref leak
Date:   Sat, 26 Oct 2019 09:14:37 -0400
Message-Id: <20191026131600.2507-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit c48fc11b69e95007109206311b0187a3090591f3 ]

When sendmsg() finds a call to continue on with, if the call is in an
inappropriate state, it doesn't release the ref it just got on that call
before returning an error.

This causes the following symptom to show up with kasan:

	BUG: KASAN: use-after-free in rxrpc_send_keepalive+0x8a2/0x940
	net/rxrpc/output.c:635
	Read of size 8 at addr ffff888064219698 by task kworker/0:3/11077

where line 635 is:

	whdr.epoch	= htonl(peer->local->rxnet->epoch);

The local endpoint (which cannot be pinned by the call) has been released,
but not the peer (which is pinned by the call).

Fix this by releasing the call in the error path.

Fixes: 37411cad633f ("rxrpc: Fix potential NULL-pointer exception")
Reported-by: syzbot+d850c266e3df14da1d31@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/sendmsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 6a1547b270fef..22f51a7e356ee 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -661,6 +661,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 		case RXRPC_CALL_SERVER_PREALLOC:
 		case RXRPC_CALL_SERVER_SECURING:
 		case RXRPC_CALL_SERVER_ACCEPTING:
+			rxrpc_put_call(call, rxrpc_call_put);
 			ret = -EBUSY;
 			goto error_release_sock;
 		default:
-- 
2.20.1

