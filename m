Return-Path: <netdev+bounces-2736-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A479703B91
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 20:04:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DC721C20C1F
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2E317733;
	Mon, 15 May 2023 18:04:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3511772F;
	Mon, 15 May 2023 18:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF473C4339B;
	Mon, 15 May 2023 18:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173853;
	bh=Qsn+HbTfAQLFSV/wDrSRpbRctrY6Rac/PUEoQQOQ5z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mryCEN0d8bd//YKY8duvx8HC8upzEhSMxm6e0uSWBQXF7oNjFYl+KFR8JdqoOpYo6
	 KEjk08/jV+GBDWz2zGHSIJVX4KowZCboND8Lv6JZKW/B1qvPUREKy+41dC3eCGjUJo
	 sba5ZRy8wKelQWl2ytBGG2D+e99+cijoz591EXLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-afs@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 227/282] rxrpc: Fix hard call timeout units
Date: Mon, 15 May 2023 18:30:05 +0200
Message-Id: <20230515161729.036198734@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 0d098d83c5d9e107b2df7f5e11f81492f56d2fe7 ]

The hard call timeout is specified in the RXRPC_SET_CALL_TIMEOUT cmsg in
seconds, so fix the point at which sendmsg() applies it to the call to
convert to jiffies from seconds, not milliseconds.

Fixes: a158bdd3247b ("rxrpc: Fix timeout of a call that hasn't yet been granted a channel")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/sendmsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 1cb90d32d553d..3439d14168e81 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -738,7 +738,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 		/* Fall through */
 	case 1:
 		if (p.call.timeouts.hard > 0) {
-			j = msecs_to_jiffies(p.call.timeouts.hard);
+			j = p.call.timeouts.hard * HZ;
 			now = jiffies;
 			j += now;
 			WRITE_ONCE(call->expect_term_by, j);
-- 
2.39.2




