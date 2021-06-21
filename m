Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB403AF328
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhFUR7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233313AbhFUR53 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:57:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E631613BE;
        Mon, 21 Jun 2021 17:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298019;
        bh=t7mEaJ1yES64bmuq1m0TdfMGZQUVXejcmtzHzjX1drI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzO1G2qbwcldgQzFhMhsmmSBWMG7cCGzRUGYhNxHD0KrgAkgcSxOopnpyyzNowCVH
         clxjHTqFacAhByG+z3o5mV4LhmSrTvUpvLl1zSFRaKJTdhwRtOY7QrlrFho9dwTlHB
         fwpcFFadnzp4E3RncWwCQBW8FXSzG0fpLGtqwmYZ8zVqit8LDz2sSz95pgkaEqYtTv
         RuWr69yhGQzByEIEVvbIPkDoqVhe+xAnlFhRAQ/O/6dsqdOkqvVYfm8HjOTYl920yF
         lH/NHq8OI0nLhMmO5i/UjBsTVwKwvZm37KJ/Ypl1/t3q8WUCjeQkbkUF51c+GBFNZW
         Zn+oZ+QaRPIHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 25/35] r8152: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 21 Jun 2021 13:52:50 -0400
Message-Id: <20210621175300.735437-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175300.735437-1-sashal@kernel.org>
References: <20210621175300.735437-1-sashal@kernel.org>
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
index f5010f8ac1ec..95e27fb7d2c1 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6054,7 +6054,7 @@ static void rtl8152_get_strings(struct net_device *dev, u32 stringset, u8 *data)
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

