Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC5F386BFB
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244618AbhEQVKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244798AbhEQVJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 17:09:56 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C2BC061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 14:08:38 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id w15-20020ac857cf0000b02901e11cd2e82fso6063602qta.12
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 14:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=B6w1++YCFiD9VZ8Rd0TA75eIQwtteW2lCI1avo5KXww=;
        b=jL8shpEYEl3yR6LzifHKs5W8jiisTIhcBViOmCyM0y3A04H1+/gt3drNN1uQNsMSVO
         2NX7k5wHG+lB/302FhePAUCJNdQQBwi/lX1/qocDNfAU+M48xWGPa4PvZG0aZWrDhOLR
         hJNFLoSgkCQU15estOWTgEhJv/zFQMipLLfdK7Zl11l1dFV522j3K42+VI9ODGYlsEHw
         UspKF3Bp8XE41wi9sbQrKW9CJxNGr1tHO4DQcFYc76K6iPFvtkonieQZ47VOc337BiT9
         WRcjHRivNXr3G2tCbY7zpdrmZPkPNS9ThaJ880vrznL9blgmvtmDwMqw51VhFpJWsKhh
         FJkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=B6w1++YCFiD9VZ8Rd0TA75eIQwtteW2lCI1avo5KXww=;
        b=rb88xSx54Mn+TAXFP6rSTV2mImdrHUhnEDRJkj6JtoS6LOHGPU7Xv+BAP7qY0b5DB2
         ZFvVtHc1hjzVlMyXSwG3VHcIQUWRRK2IMsCiClZbKsY9USJyPSTkpolwISXqf7SxB6/K
         n/mx9+eGwlC84SH79ZyYlQdDb0wU+kZpuguru1VgEEVm+2nRC/Ya9nNFq93BYQiqoGmK
         IE6eb/JAN3fDKWjE6EUnMazWG9L1Y547H1gq2VQJkwGnhGDB4gvAVvdfOx91moA1RyZm
         qyYhPfx56VJrWQ8+Vyg1g0vCH1LbRd5kQsPcc37kbQhwMTB6/aMXHx9dH39MgNrQj3fG
         jWnw==
X-Gm-Message-State: AOAM532WFGBNV7sh2lxcn6ZwiF3pLHusYbPrrSuXECam0MiF9SOrxl+3
        OjAmhyR+NgYbPYRabXcLUwHKAZQQ4u6NJhsXO13IUZ1PP1ei0+K7i92uIIKYL/doYnrMvM+Nn4e
        kzji2zABs8lAVsjd1iW0iEeIBPZ0L9j1iUdHsyl2HHRs7BU4ocISdgQckKQ6v6bpxpdHijqEB
X-Google-Smtp-Source: ABdhPJwwarvqAt819gDxh9xQvPA/1xWDSNjOohTnVvdxU5cDt0VNvD4FwcasP0PWxTg+GLlWLw4woFC79KecXg1h
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:ba72:1464:177a:c6d4])
 (user=awogbemila job=sendgmr) by 2002:a05:6214:902:: with SMTP id
 dj2mr1711641qvb.11.1621285717287; Mon, 17 May 2021 14:08:37 -0700 (PDT)
Date:   Mon, 17 May 2021 14:08:14 -0700
In-Reply-To: <20210517210815.3751286-1-awogbemila@google.com>
Message-Id: <20210517210815.3751286-5-awogbemila@google.com>
Mime-Version: 1.0
References: <20210517210815.3751286-1-awogbemila@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH net 4/5] gve: Upgrade memory barrier in poll routine
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Willem de Brujin <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

As currently written, if the driver checks for more work (via
gve_tx_poll or gve_rx_poll) before the device posts work and the
irq doorbell is not unmasked
(via iowrite32be(GVE_IRQ_ACK | GVE_IRQ_EVENT, ...)) before the device
attempts to raise an interrupt, an interrupt is lost and this could
potentially lead to the traffic being completely halted. For
example, if a tx queue has already been stopped, the driver won't get
the chance to complete work and egress will be halted.

We need a full memory barrier in the poll
routine to ensure that the irq doorbell is unmasked before the driver
checks for more work.

Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
Acked-by: Willem de Brujin <willemb@google.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 21a5d058dab4..bbc423e93122 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -180,7 +180,7 @@ static int gve_napi_poll(struct napi_struct *napi, int budget)
 	/* Double check we have no extra work.
 	 * Ensure unmask synchronizes with checking for work.
 	 */
-	dma_rmb();
+	mb();
 	if (block->tx)
 		reschedule |= gve_tx_poll(block, -1);
 	if (block->rx)
-- 
2.31.1.751.gd2f1c929bd-goog

