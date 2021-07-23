Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E917B3D3335
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 06:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbhGWDUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 23:20:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234370AbhGWDSY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 23:18:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C29B60EE6;
        Fri, 23 Jul 2021 03:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012738;
        bh=FfBdqlz+tOuFIGhwyrYZct1287ZomhxWlL/Lw1DrOOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MrAOP9UtkgxhDXI+HlAE5pvmjl0AB7q9Zq2UrBvKmIOXnfnPz4RIkLNFZXptDZKnh
         jnwRPsFw75IQnySRY8MUk4v5gZq/iAgR/l96QqxCawr44FoZ3zv0Vs549O2IjAFvlG
         p7eqJGJOAhxfkl9GkCEnib7w/9vqq7FC0hwU1hz28u4cgV0NrlV5NbqQHRA9mVduSa
         54yElYZbL0QMV8SRZ2xy6zsUh9unvuiHuGlX9hN61Pw93zh8vBT+7ERKcJgYCVlkI9
         NYUB7u/sY0C6TJBLGoZAZaL0HGK54CuVR1nqh4ZzG83C8KdYCGO8eKmvCkMKF4rS3w
         vhV94w0N0zMLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>,
        =?UTF-8?q?S=C3=A9rgio?= <surkamp@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/8] sctp: move 198 addresses from unusable to private scope
Date:   Thu, 22 Jul 2021 23:58:48 -0400
Message-Id: <20210723035852.532303-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035852.532303-1-sashal@kernel.org>
References: <20210723035852.532303-1-sashal@kernel.org>
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
index d4da07048aa3..cbf96458ce22 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -348,8 +348,7 @@ enum {
 #define SCTP_SCOPE_POLICY_MAX	SCTP_SCOPE_POLICY_LINK
 
 /* Based on IPv4 scoping <draft-stewart-tsvwg-sctp-ipv4-00.txt>,
- * SCTP IPv4 unusable addresses: 0.0.0.0/8, 224.0.0.0/4, 198.18.0.0/24,
- * 192.88.99.0/24.
+ * SCTP IPv4 unusable addresses: 0.0.0.0/8, 224.0.0.0/4, 192.88.99.0/24.
  * Also, RFC 8.4, non-unicast addresses are not considered valid SCTP
  * addresses.
  */
@@ -357,7 +356,6 @@ enum {
 	((htonl(INADDR_BROADCAST) == a) ||  \
 	 ipv4_is_multicast(a) ||	    \
 	 ipv4_is_zeronet(a) ||		    \
-	 ipv4_is_test_198(a) ||		    \
 	 ipv4_is_anycast_6to4(a))
 
 /* Flags used for the bind address copy functions.  */
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 8fe9c0646205..da2e4be47d8d 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -418,7 +418,8 @@ static enum sctp_scope sctp_v4_scope(union sctp_addr *addr)
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

