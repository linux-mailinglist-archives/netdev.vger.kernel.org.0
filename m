Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED96A1931FB
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 21:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgCYUfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 16:35:47 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37336 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgCYUfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 16:35:47 -0400
Received: by mail-lf1-f66.google.com with SMTP id j11so2981339lfg.4
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 13:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=V/dQfhW8PbAVGI3zLEkptWjMS60C9kr9Q3XpGAFQsWg=;
        b=vtrN1/kQWZvv7+VlzpSUweJwujbUyyI40v6Tn826waoynop0osbIwXl7pDzAU2JP7y
         fB+B4I/PWPCgiAou7axtoBo7le50hqPrFf3YAtKawNb76YHNgA2mum7140rxEWZJMpwt
         Og8rXodrg6nXbMNetVYqAj8ht45mEh79eZ2GSv9MbYHWZsJ49n1Sf8ItCBg1Yy1/QpEN
         qbcrsz2zx0HkMHFcbX9XidDvyUDBBNwKvNZImxrNH3jVC1xaRuMt60Bv7/yEVZ9XRqja
         ngK6wZwhueRiVZZIMCu4Nck4kTs13gWyAPq57POIQ0enZpApjKkClRn0jt9Egv3Iq4lB
         h8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=V/dQfhW8PbAVGI3zLEkptWjMS60C9kr9Q3XpGAFQsWg=;
        b=pzFP3kJ499ktEzhQ6U8kxStnX40q7C82W+4WsVrFtjwJfEt+KP0+w7p3Fy2FPWFITT
         zgiT7IUSABR0uhUH5MyRoQjzU1y75ZOc6hCC71Nyb5XsACnLh5KuWhGU0uBSvgLxdtSn
         jcUMoU9WYRpAZoE7F+DLBy32NZ6I8erIQ6glgzvTpWUPQZ75ElDmlriBzzIvLViZrA8c
         T5YxuOffVKEs2U17FXC3AkQFVaxVm42rtiTyTihdBGGgE3dr4eg3R2c2PmGmT/AV2eUt
         ORFz/3+hNjkA36Cxw7GAkSFc5dBK0/qLXmvQlJ/rBv89auoxtzTcMm9mnBBYdOnzZE7n
         qmDg==
X-Gm-Message-State: ANhLgQ02pKulwTyxfQu6HBrIh12PzxRlZy7AdzIg0xUwHUKc4ZD8kBYA
        6FcNJbdPbb++bf/rMphU7Wzm83aNCJw=
X-Google-Smtp-Source: ADFU+vsXo4GNehOoHY08T8qcKgGHJBMQvxyRWcTwtrZH4Tbwuh0qYoUP6GYdbwVDnfq3T74HwFygiA==
X-Received: by 2002:a19:7e01:: with SMTP id z1mr3402315lfc.196.1585168543101;
        Wed, 25 Mar 2020 13:35:43 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.40.234])
        by smtp.gmail.com with ESMTPSA id n7sm54411lfi.5.2020.03.25.13.35.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2020 13:35:42 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     hawk@kernel.org, ilias.apalodimas@linaro.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH v2 net-next] net: page pool: allow to pass zero flags to page_pool_init()
Date:   Wed, 25 Mar 2020 23:35:28 +0300
Message-Id: <1585168528-2445-1-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

page pool API can be useful for non-DMA cases like
xen-netfront driver so let's allow to pass zero flags to
page pool flags.

v2: check DMA direction only if PP_FLAG_DMA_MAP is set

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 net/core/page_pool.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index a6aefe9..af70331 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -43,9 +43,11 @@ static int page_pool_init(struct page_pool *pool,
 	 * DMA_BIDIRECTIONAL is for allowing page used for DMA sending,
 	 * which is the XDP_TX use-case.
 	 */
-	if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
-	    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
-		return -EINVAL;
+	if (pool->p.flags & PP_FLAG_DMA_MAP) {
+		if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
+		    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
+			return -EINVAL;
+	}
 
 	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV) {
 		/* In order to request DMA-sync-for-device the page
-- 
1.8.3.1

