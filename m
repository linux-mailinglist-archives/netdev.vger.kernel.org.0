Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9464B4257ED
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242706AbhJGQ1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242664AbhJGQ1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 12:27:41 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B02C061570
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 09:25:47 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id c123-20020a621c81000000b004446be17615so329876pfc.7
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 09:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dCPWeeUFjrvtU3Sm917T3uFMVJ0WnFWxESHzDfpi2Is=;
        b=V66+W2WvWOZNuw0M6c/SznkTKqxiBNzb6T/Z1biWvgIZDggGalfAZdnptLr6Qnimwy
         pTUKmQeOaXkxOf882/ujo7aQrIWu6vLamwIXnucGslhaQUejlVB1BnhwVbnwvuF6SScF
         9icgcSV86vtwj9gvmo4cQgq8NRZj5F+1fVYcWBOaC1F4uJWb4YnHwBMcjGyOIfHk6bfv
         Hbb1Tui9eBIwudbM3CKVCZKuvsmiEgckyIxGnMdUFa+1A/eFfMKnFi6amuzVk+wWlITp
         MiZ5U/xpCw5rSeG4GgqpXBToapCpv1uODZThMxKVb6lQhRHOepS+dbtDXpfd9WwoZR3G
         k0KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dCPWeeUFjrvtU3Sm917T3uFMVJ0WnFWxESHzDfpi2Is=;
        b=8RM5TRtnrrL6SrySYNZQOOH/t7LbbsDsHY+c+LwUfxZW/gRG8T64MkbePoP8x28LbF
         sKm8siadgkWZB5mqr82khTdz2//8esth/VP1e1IdKEFNnYL94Q5vvDqnlkQR9HDwmLXZ
         uLD6fxXsit4p2S4HaDEmAnImqadRFoZnT7ymnbCLPCKRL5vIQg0jZ5Xq9ku972NpBS/0
         doBd7NRv9UpXuPN4BntkgxO9CiUdvD8nVP4D+mLFITnxRFYXinPA3gv4HFjtuz5tuAgX
         DGwjVcmg2YCBtfMS8PSdmPYTnoysGGKc5KlMJl26/+CbF9YAYPq2RRDSguf+sodmRPPO
         Tssw==
X-Gm-Message-State: AOAM53335w7A6QbuC8IoCo02qctSw/XZDXKRf5njweeYxI2WKOB2sbOz
        ISKnfziPOrKs6ynd7PRs1JfuemOunwVes+HTdP6/brOUXo8gEJd498Q5hwzcNXu8hs19wYPbp2F
        D0pHsOIAhQiioeHVhsoYSzZjfgvB9yUwjtENBkk5uCsLEF7tJK6+xDbFyvLXqEtP/oR0=
X-Google-Smtp-Source: ABdhPJzwRgAAh2zb7wyBsv1WVtzIWGWwzQ0uRsurbGP2M0NTUN/btraosmIaKPFYqyQs5D+YDzZb3FR5mCddvg==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:fe55:7411:11ac:c2a7])
 (user=jeroendb job=sendgmr) by 2002:a17:902:7e88:b0:13e:91ec:4114 with SMTP
 id z8-20020a1709027e8800b0013e91ec4114mr4914909pla.30.1633623947034; Thu, 07
 Oct 2021 09:25:47 -0700 (PDT)
Date:   Thu,  7 Oct 2021 09:25:33 -0700
In-Reply-To: <20211007162534.1502578-1-jeroendb@google.com>
Message-Id: <20211007162534.1502578-6-jeroendb@google.com>
Mime-Version: 1.0
References: <20211007162534.1502578-1-jeroendb@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH net-next 6/7] gve: Allow pageflips on larger pages
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jordan Kim <jrkim@google.com>,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jordan Kim <jrkim@google.com>

Half pages are just used for small enough packets. This change allows
this to also apply for systems with pages larger than 4 KB.

Fixes: 02b0e0c18ba75 ("gve: Rx Buffer Recycling")
Signed-off-by: Jordan Kim <jrkim@google.com>
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index ecf5a396290b..c6e95e1409a9 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -296,7 +296,7 @@ static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info, __be64 *sl
 
 static bool gve_rx_can_flip_buffers(struct net_device *netdev)
 {
-	return PAGE_SIZE == 4096
+	return PAGE_SIZE >= 4096
 		? netdev->mtu + GVE_RX_PAD + ETH_HLEN <= PAGE_SIZE / 2 : false;
 }
 
-- 
2.33.0.800.g4c38ced690-goog

