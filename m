Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70183AF2AB
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbhFUR4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232051AbhFURzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:55:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89570611CE;
        Mon, 21 Jun 2021 17:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297963;
        bh=8IWXICxHnpLryZrffT+43P2/Z7QBWVS2avVr93+qw3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=REEgSSWIlpAKSFmaYe7wFxX40ilDq65sBofWG/RbELzX9JxHHWvbhJs/ZB6/FI4da
         82Ooc0Yh0ZMI0x2t3oYcfY+wmIA4bMscXbVO1vr5QAEUvGOVK7crd0oxgllEnAy7uG
         +xu1UKDnwbRNN19HijW5uGVJeQHfJIF+pNJKS8XXUNDj1Ly1W6bvq6/1JSmBAaMz02
         M7JnvtIOZ5dG5eE7RN+s2fA+x7Wjg9vcfgHN3pciSRBetkD1kgaTDoT/SKGRgce0ZP
         wqTSVsa8yrXZ54GaG895owGemz/IWsF4Q2ueYKhBrn1cL65ep1cG/7jTaYIqsOn+RC
         eJrk9KYvyM10Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 28/39] r8152: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 21 Jun 2021 13:51:44 -0400
Message-Id: <20210621175156.735062-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 99718abdc00e86e4f286dd836408e2834886c16e ]

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally reading across neighboring array fields.

The memcpy() is copying the entire structure, not just the first array.
Adjust the source argument so the compiler can do appropriate bounds
checking.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 20fb5638ac65..23fae943a119 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6078,7 +6078,7 @@ static void rtl8152_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 {
 	switch (stringset) {
 	case ETH_SS_STATS:
-		memcpy(data, *rtl8152_gstrings, sizeof(rtl8152_gstrings));
+		memcpy(data, rtl8152_gstrings, sizeof(rtl8152_gstrings));
 		break;
 	}
 }
-- 
2.30.2

