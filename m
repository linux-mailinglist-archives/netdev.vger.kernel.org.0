Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19F1FA8C68
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732650AbfIDQNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:13:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732510AbfIDP76 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C39022CF5;
        Wed,  4 Sep 2019 15:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612797;
        bh=HaJIQUt1q4yjUOn3fBZcxEDzdsuOckbpaxjgOjv2+7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q8kONzCME8QJ/BftDjC9U9EP6cC0lTn+J+i5Ise8gr8W5/W+V4B2did/OSPPUojIP
         PBFPpr8SCvCUoWnss7V9GQe9ET1iREeH+JN5bicO6Y155t0pDRT9vYhNvX5jr1u0vH
         zkQfAoKFYbdVqz9+56Za6icOp7TGFMtLSKhTgFWE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 91/94] net: aquantia: fix out of memory condition on rx side
Date:   Wed,  4 Sep 2019 11:57:36 -0400
Message-Id: <20190904155739.2816-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

[ Upstream commit be6cef69ba570ebb327eba1ef6438f7af49aaf86 ]

On embedded environments with hard memory limits it is a normal although
rare case when skb can't be allocated on rx part under high traffic.

In such OOM cases napi_complete_done() was not called.
So the napi object became in an invalid state like it is "scheduled".
Kernel do not re-schedules the poll of that napi object.

Consequently, kernel can not remove that object the system hangs on
`ifconfig down` waiting for a poll.

We are fixing this by gracefully closing napi poll routine with correct
invocation of napi_complete_done.

This was reproduced with artificially failing the allocation of skb to
simulate an "out of memory" error case and check that traffic does
not get stuck.

Fixes: 970a2e9864b0 ("net: ethernet: aquantia: Vector operations")
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index 715685aa48c39..28892b8acd0e1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -86,6 +86,7 @@ static int aq_vec_poll(struct napi_struct *napi, int budget)
 			}
 		}
 
+err_exit:
 		if (!was_tx_cleaned)
 			work_done = budget;
 
@@ -95,7 +96,7 @@ static int aq_vec_poll(struct napi_struct *napi, int budget)
 					1U << self->aq_ring_param.vec_idx);
 		}
 	}
-err_exit:
+
 	return work_done;
 }
 
-- 
2.20.1

