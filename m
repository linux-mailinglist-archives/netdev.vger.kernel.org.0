Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1ADE439C41
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhJYRCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234169AbhJYRCO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:02:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8325060F22;
        Mon, 25 Oct 2021 16:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181192;
        bh=7ws+I935y9f8B2ecOxeRyLCo+VOgQQB4j6S/b/0MAOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nanS7ujgh2Gl2Wm2wIPD9s2fbUp7GvVrNj6dfQDrCNS/i+wIbf8XNFGEufLvW8+MO
         i1QedOhVr8cKBFJE45/c0MR9tOiYKUU9714olhbNIFpJ8Ro7w9XiWWwa+r2HigT+2G
         LmxOTcSOAAd93jtJU+j8MSJa0lYi3FrZBQ20aDadyBhc2kKR1vL5xbwWy3j8PnBjV6
         uv6uhiBbkIdbgpN6SWXJq7yuZl8xqYEgThNGfpfVyS9ANxZB3dnujWAttFBBfCXrEK
         l4A7v9JC9fcCaQ52MPddOBwJ8+DK0qCl53JC7Gn9FKHq22P+gKg4o7IqYEKnH5/Hvn
         LySuoIKPewW+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kele Huang <huangkele@bytedance.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, richardcochran@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 06/18] ptp: fix error print of ptp_kvm on X86_64 platform
Date:   Mon, 25 Oct 2021 12:59:19 -0400
Message-Id: <20211025165939.1393655-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025165939.1393655-1-sashal@kernel.org>
References: <20211025165939.1393655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kele Huang <huangkele@bytedance.com>

[ Upstream commit c2402d43d183b11445aed921e7bebcd47ef222f1 ]

Commit a86ed2cfa13c5 ("ptp: Don't print an error if ptp_kvm is not supported")
fixes the error message print on ARM platform by only concerning about
the case that the error returned from kvm_arch_ptp_init() is not -EOPNOTSUPP.
Although the ARM platform returns -EOPNOTSUPP if ptp_kvm is not supported
while X86_64 platform returns -KVM_EOPNOTSUPP, both error codes share the
same value 95.

Actually kvm_arch_ptp_init() on X86_64 platform can return three kinds of
errors (-KVM_ENOSYS, -KVM_EOPNOTSUPP and -KVM_EFAULT). The problem is that
-KVM_EOPNOTSUPP is masked out and -KVM_EFAULT is ignored among them.
This patch fixes this by returning them to ptp_kvm_init() respectively.

Signed-off-by: Kele Huang <huangkele@bytedance.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_kvm_x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
index d0096cd7096a..4991054a2135 100644
--- a/drivers/ptp/ptp_kvm_x86.c
+++ b/drivers/ptp/ptp_kvm_x86.c
@@ -31,10 +31,10 @@ int kvm_arch_ptp_init(void)
 
 	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING, clock_pair_gpa,
 			     KVM_CLOCK_PAIRING_WALLCLOCK);
-	if (ret == -KVM_ENOSYS || ret == -KVM_EOPNOTSUPP)
+	if (ret == -KVM_ENOSYS)
 		return -ENODEV;
 
-	return 0;
+	return ret;
 }
 
 int kvm_arch_ptp_get_clock(struct timespec64 *ts)
-- 
2.33.0

