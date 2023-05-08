Return-Path: <netdev+bounces-831-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4272B6FA86B
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 12:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08693280E8E
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 10:40:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBA0F125DF;
	Mon,  8 May 2023 10:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DA6168A7;
	Mon,  8 May 2023 10:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4979C4339B;
	Mon,  8 May 2023 10:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542421;
	bh=9dP2pkoC/WQM0vP0ptL6LnIEekN5wSGvTMthfXdWkt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJCKGQb/6L0Q0OfnaWieEC90Dns3rZFs/ov3AJd+Ga2Z5LRg/vQ6QXl1pk9TsXv/w
	 3HfzIIqXSa6kOGE+hynHCsb3JiUX3/n9EKRNLlhwPuvelDoh+mR7mnqNoTLjiNCjM/
	 jPgp2vRMMoCiKQRyGtG9ieCa45VNtDGvnN8REc2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-afs@lists.infradead.org,
	netdev@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 430/663] rxrpc: Fix error when reading rxrpc tokens
Date: Mon,  8 May 2023 11:44:16 +0200
Message-Id: <20230508094442.012078721@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Dionne <marc.dionne@auristor.com>

[ Upstream commit fadfc57cc8047080a123b16f288b7138524fb1e2 ]

When converting from ASSERTCMP to WARN_ON, the tested condition must
be inverted, which was missed for this case.

This would cause an EIO error when trying to read an rxrpc token, for
instance when trying to display tokens with AuriStor's "tokens" command.

Fixes: 84924aac08a4 ("rxrpc: Fix checker warning")
Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 8d53aded09c42..33e8302a79e33 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -680,7 +680,7 @@ static long rxrpc_read(const struct key *key,
 			return -ENOPKG;
 		}
 
-		if (WARN_ON((unsigned long)xdr - (unsigned long)oldxdr ==
+		if (WARN_ON((unsigned long)xdr - (unsigned long)oldxdr !=
 			    toksize))
 			return -EIO;
 	}
-- 
2.39.2




