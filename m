Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA042855D
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 19:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731438AbfEWRyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 13:54:41 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37905 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731401AbfEWRyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 13:54:41 -0400
Received: by mail-pf1-f193.google.com with SMTP id b76so3648323pfb.5
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 10:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jW23EVTaONU8fGl2rO/gh8exrFRja4BdXSBKXyg60v0=;
        b=SMSQxND3SPkeUqxEOlPsrNuSDJoAYR/NUM5Cg+h0I8ZrwFTkMObmEBBAcpRh2ckucq
         6uYxtENJ8lQSyGCOmIkTGCPk5jdhHZnVinuwScSVLKhYweHZP9ZPcV9I4rqoW2pC5PwZ
         IYj5q6/x8D/HWJJk0D3eNmXEE/p+ybkS26OxKW5RM+31m85e0qbo2kgxg+QdhQuaPNpP
         /kk0NWkDcU2wdhe0s46BhZ3YlTFJOK7cxNdDQx8iS/ueCk+OYpPhjnupyXau2XtQH7dd
         6KoVgRSxt9/tkvu3eQy34WGl+fjNZ0WRg9GFolvsSsNhFVvTW5X3ugnNQCyJiyptaKnc
         kabw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jW23EVTaONU8fGl2rO/gh8exrFRja4BdXSBKXyg60v0=;
        b=rJzlv6NU0NrfKa9ko56TbXlqGiuN74oA2aisXu3EgnAInr8A5rLD8nsCIGAN51Wn17
         IW+8x4HOKnCmEEvrszdOs3LAzH5k3a6P4zM27UpUWYnrEnkY6lyrtJIS+fwFXYJIbryU
         cayil5Ig+WoCD+FnVm6HGy2idIp0MTqPklZg5DBds1UqRl5QZeGEQ1bJmchxnZnsc/X7
         9w8Ru4Cvw2vjkwA4haeOm5Sf1aklAo7cO3Sv4gqpcjIJGld78Hmz6MzPu1RgCNEYtdSs
         T6xAgipjKL9hVLm+vrnGk0FQo7H6d9sEn17geN3nwmb/DZoPCnEInFDKfzv1+eqRmTEP
         6mSg==
X-Gm-Message-State: APjAAAU1RIq8pvAumEU+mdh+Gy4X5G8GzBkdldi9Ggq9Ps2zcoScJzM7
        Iht4xgTYIMUyM7KRQuRbtvdEOw==
X-Google-Smtp-Source: APXvYqzgBnFJIzyo/om9bQCLooGHTW+EgQ3XcwhBBlWqUlHpm+1huKtWrCZ3g0TFC7JYlxSj6O3hbA==
X-Received: by 2002:a63:6c87:: with SMTP id h129mr39789642pgc.427.1558634080987;
        Thu, 23 May 2019 10:54:40 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n35sm4942pjc.3.2019.05.23.10.54.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 10:54:40 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>
Subject: [PATCH v3 1/2] netvsc: unshare skb in VF rx handler
Date:   Thu, 23 May 2019 10:54:28 -0700
Message-Id: <20190523175429.13302-2-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190523175429.13302-1-sthemmin@microsoft.com>
References: <20190523175429.13302-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netvsc VF skb handler should make sure that skb is not
shared. Similar logic already exists in bonding and team device
drivers.

This is not an issue in practice because the VF devicex
does not send up shared skb's. But the netvsc driver
should do the right thing if it did.

Fixes: 0c195567a8f6 ("netvsc: transparent VF management")
Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 06393b215102..9873b8679f81 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2000,6 +2000,12 @@ static rx_handler_result_t netvsc_vf_handle_frame(struct sk_buff **pskb)
 	struct netvsc_vf_pcpu_stats *pcpu_stats
 		 = this_cpu_ptr(ndev_ctx->vf_stats);
 
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (unlikely(!skb))
+		return RX_HANDLER_CONSUMED;
+
+	*pskb = skb;
+
 	skb->dev = ndev;
 
 	u64_stats_update_begin(&pcpu_stats->syncp);
-- 
2.20.1

