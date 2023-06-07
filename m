Return-Path: <netdev+bounces-9038-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FCB3726B19
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:22:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7AE891C20A3D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:22:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78AD43AE46;
	Wed,  7 Jun 2023 20:22:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943D43AE43;
	Wed,  7 Jun 2023 20:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B04C433D2;
	Wed,  7 Jun 2023 20:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169353;
	bh=LviSArhhkr0b91zeKqaYJBIauLoZ7udxZa5x7yeR72g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGYZCNBOy9eoZbd2qMHsn2wgXhmPExHxcTBmnIHWC93ylBj12MonfsEU1qsPruVV3
	 lADwaF7Jf8VydlkeQQ18DISZrVtD9gza6Zl+2L4nA5FSzdZZqMcZHiH5+P7cK0Xfv/
	 yWopCFsyLVB3ap4USPisZCxyCIxOCLW1QLl7Gw8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenny Ho <Kenny.Ho@amd.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Andrew Lunn <andrew@lunn.ch>,
	David Laight <David.Laight@ACULAB.COM>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-afs@lists.infradead.org,
	netdev@vger.kernel.org,
	Simon Horman <simon.horman@corigine.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 049/286] rxrpc: Truncate UTS_RELEASE for rxrpc version
Date: Wed,  7 Jun 2023 22:12:28 +0200
Message-ID: <20230607200924.649238348@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
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

[ Upstream commit 020c69c1a793ed29d28793808eddd75210c858dd ]

UTS_RELEASE has a maximum length of 64 which can cause rxrpc_version to
exceed the 65 byte message limit.

Per the rx spec[1]: "If a server receives a packet with a type value of 13,
and the client-initiated flag set, it should respond with a 65-byte payload
containing a string that identifies the version of AFS software it is
running."

The current implementation causes a compile error when WERROR is turned on
and/or UTS_RELEASE exceeds the length of 49 (making the version string more
than 64 characters).

Fix this by generating the string during module initialisation and limiting
the UTS_RELEASE segment of the string does not exceed 49 chars.  We need to
make sure that the 64 bytes includes "linux-" at the front and " AF_RXRPC"
at the back as this may be used in pattern matching.

Fixes: 44ba06987c0b ("RxRPC: Handle VERSION Rx protocol packets")
Reported-by: Kenny Ho <Kenny.Ho@amd.com>
Link: https://lore.kernel.org/r/20230523223944.691076-1-Kenny.Ho@amd.com/
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Kenny Ho <Kenny.Ho@amd.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Andrew Lunn <andrew@lunn.ch>
cc: David Laight <David.Laight@ACULAB.COM>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
Link: https://web.mit.edu/kolya/afs/rx/rx-spec [1]
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
Link: https://lore.kernel.org/r/654974.1685100894@warthog.procyon.org.uk
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/af_rxrpc.c    |  1 +
 net/rxrpc/ar-internal.h |  1 +
 net/rxrpc/local_event.c | 11 ++++++++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index a6f0d29f35ef9..f5d1fc1266a5a 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -967,6 +967,7 @@ static int __init af_rxrpc_init(void)
 	BUILD_BUG_ON(sizeof(struct rxrpc_skb_priv) > sizeof_field(struct sk_buff, cb));
 
 	ret = -ENOMEM;
+	rxrpc_gen_version_string();
 	rxrpc_call_jar = kmem_cache_create(
 		"rxrpc_call_jar", sizeof(struct rxrpc_call), 0,
 		SLAB_HWCACHE_ALIGN, NULL);
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 5d44dc08f66d0..e8e14c6f904d9 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1068,6 +1068,7 @@ int rxrpc_get_server_data_key(struct rxrpc_connection *, const void *, time64_t,
 /*
  * local_event.c
  */
+void rxrpc_gen_version_string(void);
 void rxrpc_send_version_request(struct rxrpc_local *local,
 				struct rxrpc_host_header *hdr,
 				struct sk_buff *skb);
diff --git a/net/rxrpc/local_event.c b/net/rxrpc/local_event.c
index 5e69ea6b233da..993c69f97488c 100644
--- a/net/rxrpc/local_event.c
+++ b/net/rxrpc/local_event.c
@@ -16,7 +16,16 @@
 #include <generated/utsrelease.h>
 #include "ar-internal.h"
 
-static const char rxrpc_version_string[65] = "linux-" UTS_RELEASE " AF_RXRPC";
+static char rxrpc_version_string[65]; // "linux-" UTS_RELEASE " AF_RXRPC";
+
+/*
+ * Generate the VERSION packet string.
+ */
+void rxrpc_gen_version_string(void)
+{
+	snprintf(rxrpc_version_string, sizeof(rxrpc_version_string),
+		 "linux-%.49s AF_RXRPC", UTS_RELEASE);
+}
 
 /*
  * Reply to a version request
-- 
2.39.2




