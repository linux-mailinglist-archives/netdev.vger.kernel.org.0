Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74D241B9F8
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 00:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243076AbhI1WOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 18:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243072AbhI1WOm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 18:14:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31DB26128E;
        Tue, 28 Sep 2021 22:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632867182;
        bh=DO4R1ntyCuxR411t9Um4s+4nqiBmOq4RrqJ6OCNb2JM=;
        h=Date:From:To:Cc:Subject:From;
        b=Bc7I9Cosp099R+FCix2qg9sJAR4y0Knq51WZuE0ubDjZeGzh/kJxW6T+XXqVgmbV+
         h2hJiLVsViRSXTuZzhSrl+cIir//EntAq8KfWH1skBkzFSV7Kp8I3UJFBwSF1K0kk7
         pYseO7CrOFAta8Y8mv3zmiFkRqRFaLqATxD4w9XihM9NnexAUvaXU+QKCgGPvtIuBT
         W6/dTF5CbqnQKTQ05vOpjPJDmjbCpyRwNHZ86v27OML9A3oJORxj6V64Z2jXLORmeb
         kQntAacQG564yT35SO8tTWn73XLAM1u6N9nhrkdEGabBDhzIVkczr7LHUkNOifHB9r
         4ygVj8Kx1YROA==
Date:   Tue, 28 Sep 2021 17:17:05 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][net-next] net: wireguard: Use kvcalloc() instead of
 kvzalloc()
Message-ID: <20210928221705.GA279593@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 2-factor argument form kvcalloc() instead of kvzalloc().

Link: https://github.com/KSPP/linux/issues/162
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireguard/ratelimiter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireguard/ratelimiter.c b/drivers/net/wireguard/ratelimiter.c
index 3fedd1d21f5e..dd55e5c26f46 100644
--- a/drivers/net/wireguard/ratelimiter.c
+++ b/drivers/net/wireguard/ratelimiter.c
@@ -176,12 +176,12 @@ int wg_ratelimiter_init(void)
 			(1U << 14) / sizeof(struct hlist_head)));
 	max_entries = table_size * 8;
 
-	table_v4 = kvzalloc(table_size * sizeof(*table_v4), GFP_KERNEL);
+	table_v4 = kvcalloc(table_size, sizeof(*table_v4), GFP_KERNEL);
 	if (unlikely(!table_v4))
 		goto err_kmemcache;
 
 #if IS_ENABLED(CONFIG_IPV6)
-	table_v6 = kvzalloc(table_size * sizeof(*table_v6), GFP_KERNEL);
+	table_v6 = kvcalloc(table_size, sizeof(*table_v6), GFP_KERNEL);
 	if (unlikely(!table_v6)) {
 		kvfree(table_v4);
 		goto err_kmemcache;
-- 
2.27.0

