Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26DA1FE1E8
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733216AbgFRB6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729876AbgFRBZA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:25:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D10A921D80;
        Thu, 18 Jun 2020 01:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443500;
        bh=iZZmz+Ap5bLY4GuNSraezb984yLj0cyMICkNa8CYumg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cI7HSaNHUsvucnGgC1AzcnRcCXBVJEC/OxhzbKc/7c7nQ8bP3+wevweuMnBjyguaI
         VzfDvKv2opvUXH6aVc8znl2QkbRoPYkj5tTj9cBPQj2epqcK9oDbOPTmCF4XceGmEU
         2s8cprmhr7uekg1+wZjU5TXJr/9CpcqGMnZ4gwco=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fedor Tokarev <ftokarev@gmail.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 126/172] net: sunrpc: Fix off-by-one issues in 'rpc_ntop6'
Date:   Wed, 17 Jun 2020 21:21:32 -0400
Message-Id: <20200618012218.607130-126-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fedor Tokarev <ftokarev@gmail.com>

[ Upstream commit 118917d696dc59fd3e1741012c2f9db2294bed6f ]

Fix off-by-one issues in 'rpc_ntop6':
 - 'snprintf' returns the number of characters which would have been
   written if enough space had been available, excluding the terminating
   null byte. Thus, a return value of 'sizeof(scopebuf)' means that the
   last character was dropped.
 - 'strcat' adds a terminating null byte to the string, thus if len ==
   buflen, the null byte is written past the end of the buffer.

Signed-off-by: Fedor Tokarev <ftokarev@gmail.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/addr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/addr.c b/net/sunrpc/addr.c
index 2e0a6f92e563..8391c2785550 100644
--- a/net/sunrpc/addr.c
+++ b/net/sunrpc/addr.c
@@ -81,11 +81,11 @@ static size_t rpc_ntop6(const struct sockaddr *sap,
 
 	rc = snprintf(scopebuf, sizeof(scopebuf), "%c%u",
 			IPV6_SCOPE_DELIMITER, sin6->sin6_scope_id);
-	if (unlikely((size_t)rc > sizeof(scopebuf)))
+	if (unlikely((size_t)rc >= sizeof(scopebuf)))
 		return 0;
 
 	len += rc;
-	if (unlikely(len > buflen))
+	if (unlikely(len >= buflen))
 		return 0;
 
 	strcat(buf, scopebuf);
-- 
2.25.1

