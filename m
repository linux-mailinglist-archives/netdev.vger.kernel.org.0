Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954933D333E
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 06:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbhGWDUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 23:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233823AbhGWDRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 23:17:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B8DE60F25;
        Fri, 23 Jul 2021 03:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012699;
        bh=r6KvBsv2mk7eJulnSPf9e29PrLX2bcuIHESMYO0eIhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QNe+zuxRYIFePgXATRxFMhw61ecUYbIquWnLZDEEbe93BbVvURLlJ3kn52ee47ihH
         jSB2SsV3CyA8/QRS9+P16LkInlhPMgPcy3ewD0Bz3FK+NvoZ4dOzA8Psi3LjjtIQiO
         9ZVt1cvBp8NvkdQa50oq5InTv6Jn5noKuJ43kDb53vLMBRp85evzMgzmnFYg4sDrsZ
         6JRRaX1JK9LTOYdOXLk8n3y1AVWixqLWtt4hSqR9Ql9k3757jf9ySAmIU9fk2mpDIX
         KG3lBzvVpkS6xTSriOxqqa4GMIL0WMTk4NUxQh03Ctc/LFp6aaNYw+j149O78AFdfY
         7eRBvkaQZ+tAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>,
        =?UTF-8?q?S=C3=A9rgio?= <surkamp@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/14] sctp: move 198 addresses from unusable to private scope
Date:   Thu, 22 Jul 2021 23:58:03 -0400
Message-Id: <20210723035813.531837-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035813.531837-1-sashal@kernel.org>
References: <20210723035813.531837-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 1d11fa231cabeae09a95cb3e4cf1d9dd34e00f08 ]

The doc draft-stewart-tsvwg-sctp-ipv4-00 that restricts 198 addresses
was never published. These addresses as private addresses should be
allowed to use in SCTP.

As Michael Tuexen suggested, this patch is to move 198 addresses from
unusable to private scope.

Reported-by: Sérgio <surkamp@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sctp/constants.h | 4 +---
 net/sctp/protocol.c          | 3 ++-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 06e1deeef464..8c6b04f9f6cb 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -328,8 +328,7 @@ enum {
 #define SCTP_SCOPE_POLICY_MAX	SCTP_SCOPE_POLICY_LINK
 
 /* Based on IPv4 scoping <draft-stewart-tsvwg-sctp-ipv4-00.txt>,
- * SCTP IPv4 unusable addresses: 0.0.0.0/8, 224.0.0.0/4, 198.18.0.0/24,
- * 192.88.99.0/24.
+ * SCTP IPv4 unusable addresses: 0.0.0.0/8, 224.0.0.0/4, 192.88.99.0/24.
  * Also, RFC 8.4, non-unicast addresses are not considered valid SCTP
  * addresses.
  */
@@ -337,7 +336,6 @@ enum {
 	((htonl(INADDR_BROADCAST) == a) ||  \
 	 ipv4_is_multicast(a) ||	    \
 	 ipv4_is_zeronet(a) ||		    \
-	 ipv4_is_test_198(a) ||		    \
 	 ipv4_is_anycast_6to4(a))
 
 /* Flags used for the bind address copy functions.  */
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 981c7cbca46a..2661a453a1c2 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -392,7 +392,8 @@ static enum sctp_scope sctp_v4_scope(union sctp_addr *addr)
 		retval = SCTP_SCOPE_LINK;
 	} else if (ipv4_is_private_10(addr->v4.sin_addr.s_addr) ||
 		   ipv4_is_private_172(addr->v4.sin_addr.s_addr) ||
-		   ipv4_is_private_192(addr->v4.sin_addr.s_addr)) {
+		   ipv4_is_private_192(addr->v4.sin_addr.s_addr) ||
+		   ipv4_is_test_198(addr->v4.sin_addr.s_addr)) {
 		retval = SCTP_SCOPE_PRIVATE;
 	} else {
 		retval = SCTP_SCOPE_GLOBAL;
-- 
2.30.2

