Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B932B13F38F
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392287AbgAPSml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:42:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389471AbgAPRLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:11:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 959DD21D56;
        Thu, 16 Jan 2020 17:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194685;
        bh=7pl7lK1KOW0b4GqLq3o0CUIRMgonuai131WNRNpX6/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JctedowzlH7nwWDLpBfsG/QRNICScbDHiUM1hga5P3d+hAM42hbomrEQPYVnHKj+
         LebhAxNZ11paoKWtVmdJG0ANnPzGiiheAFpbXsssnv3LQGWmhPStUoJpGsGMAHPkcT
         iRJLtgfhf80Bo7VkSEaJjdZCD59PzEQo7vlZ3R/g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 529/671] xsk: avoid store-tearing when assigning queues
Date:   Thu, 16 Jan 2020 12:02:47 -0500
Message-Id: <20200116170509.12787-266-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

[ Upstream commit 94a997637c5b562fa0ca44fca1d2cd02ec08236f ]

Use WRITE_ONCE when doing the store of tx, rx, fq, and cq, to avoid
potential store-tearing. These members are read outside of the control
mutex in the mmap implementation.

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Fixes: 37b076933a8e ("xsk: add missing write- and data-dependency barrier")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index c90854bc3048..b580078f04d1 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -320,7 +320,7 @@ static int xsk_init_queue(u32 entries, struct xsk_queue **queue,
 
 	/* Make sure queue is ready before it can be seen by others */
 	smp_wmb();
-	*queue = q;
+	WRITE_ONCE(*queue, q);
 	return 0;
 }
 
-- 
2.20.1

