Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFB23D3274
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 05:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbhGWDQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 23:16:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233638AbhGWDQx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 23:16:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 469F960ED7;
        Fri, 23 Jul 2021 03:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012647;
        bh=zOoCF+HS6tH6/uMM57hvO1ALQwVAf4hdAFDbogkm7xY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjMzWGMUuZZH26FHQ4mcJy/dmuo1rPtCxTTjaIo1s40B7AOygpbZ9lC+MEgUPwoS1
         oe6UveaRJcPWdbLm1DDB/1cRHstkGqS8D9fmtSV0vhL7XS3rg6QvRoiAbD8bb6N6Xe
         yhuYTMNEw75yEkMXPFDvQ+jzkEHvbMDY2xOhO1E3tWbY6TuiATq42tc7aAgIwDVkbl
         ia9zVftxkIJI/3CPxfOFY3g+1x+qLGI7h007lwQnN1Gr88vGcLVQwR/Xak3nb6gG1f
         ZXarR9X3nuxp2WcavVaaiUfIASGBIVvf96sGzE7xDmXPBBQ5qX8JLkIUt4Rr+jZ+vW
         uGn9GFUVfmUDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>,
        =?UTF-8?q?S=C3=A9rgio?= <surkamp@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 04/19] sctp: move 198 addresses from unusable to private scope
Date:   Thu, 22 Jul 2021 23:57:05 -0400
Message-Id: <20210723035721.531372-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035721.531372-1-sashal@kernel.org>
References: <20210723035721.531372-1-sashal@kernel.org>
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
index 14a0d22c9113..bf23a2ed92da 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -342,8 +342,7 @@ enum {
 #define SCTP_SCOPE_POLICY_MAX	SCTP_SCOPE_POLICY_LINK
 
 /* Based on IPv4 scoping <draft-stewart-tsvwg-sctp-ipv4-00.txt>,
- * SCTP IPv4 unusable addresses: 0.0.0.0/8, 224.0.0.0/4, 198.18.0.0/24,
- * 192.88.99.0/24.
+ * SCTP IPv4 unusable addresses: 0.0.0.0/8, 224.0.0.0/4, 192.88.99.0/24.
  * Also, RFC 8.4, non-unicast addresses are not considered valid SCTP
  * addresses.
  */
@@ -351,7 +350,6 @@ enum {
 	((htonl(INADDR_BROADCAST) == a) ||  \
 	 ipv4_is_multicast(a) ||	    \
 	 ipv4_is_zeronet(a) ||		    \
-	 ipv4_is_test_198(a) ||		    \
 	 ipv4_is_anycast_6to4(a))
 
 /* Flags used for the bind address copy functions.  */
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 6f2bbfeec3a4..603049aa4950 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -393,7 +393,8 @@ static enum sctp_scope sctp_v4_scope(union sctp_addr *addr)
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

