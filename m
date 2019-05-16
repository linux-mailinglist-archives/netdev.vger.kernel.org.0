Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26D7621059
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 23:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbfEPVy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 17:54:29 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46243 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728884AbfEPVy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 17:54:28 -0400
Received: by mail-pf1-f196.google.com with SMTP id y11so2517269pfm.13
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 14:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jW23EVTaONU8fGl2rO/gh8exrFRja4BdXSBKXyg60v0=;
        b=zZ6dq6JYsNCTLilh4tdiqHrmv23xzcGSKF4r/LqIMcfbTyNphvxWoH9D2upjSAHuz0
         e9u/x6/0LdA6y7vansZpzlI25i5pXMmuex74Y0zuhc6kkxgG5UXePl8Mkqw3MZEb8Q1K
         fpPH7OlTG6MWtYaTTmh1Q6NAkCjEC7go7jEA+EP+cYezRte27zS3LRUfH1ymuFXKM6Ke
         iComxjPK+RX3NZgq4QGr3wNs4OgEzYvkfQeLDUFWkEIJ8b9TGMDeD+6DZN+ec7zigPMM
         kC6e8ypK+ANYfp2gFTL+W4KOxbt/pHRiS3C2Km5XDfUepuALZA8Fk6lE5mVizH7wd791
         WrNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jW23EVTaONU8fGl2rO/gh8exrFRja4BdXSBKXyg60v0=;
        b=ix50LFqIq8ht82v5mvaAdzT/PMjzGdRKHHVDTQo7iPQNmly89dnAM50bp2iVy6Dr35
         ocaSYyiXCsbILUZiWlgfIxybWSUtfkmXJFl+YRHR2/tNuUPc1wa0yHUg0tr2ESb3/M1F
         x7VEpqeEgeTd8nUqaSllun6bjeN+3ET+wFk4sBb/a968EQBAjvnkVFlct/BvoJ7I+SQc
         rzQbhPL2u9KWdcmVhIbHdWE5d04DMTOFJH/3DIGBphOij222r9RTYVUpn6h66P/9ePIk
         PA4MF5cmUN4zFyDbHpR3g2RkfUnMHHhq53FzocaRE3H4GMNu82MXXFXwzY/6C10LTg5S
         VZDQ==
X-Gm-Message-State: APjAAAWbo834jNiMHQX8qqMVK3Af423OmkBw9oaALysU94Fh/79O1fee
        EFPmXfhgmAdivRqIHJWNq3PNrgXjCjw=
X-Google-Smtp-Source: APXvYqx2B9kBrdR04F1t4i1XgaAah3bmKTotNbx3FQ2RNR9kO4Y5NeCwckRaxlUBDkYf1mqjeiOSIg==
X-Received: by 2002:a62:1b8a:: with SMTP id b132mr56143116pfb.19.1558043667786;
        Thu, 16 May 2019 14:54:27 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d15sm19842506pfm.186.2019.05.16.14.54.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 14:54:26 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     xdp-newbies@vger.kernel.org, bpf@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>
Subject: [PATCH net 1/3] netvsc: unshare skb in VF rx handler
Date:   Thu, 16 May 2019 14:54:21 -0700
Message-Id: <20190516215423.14185-2-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516215423.14185-1-sthemmin@microsoft.com>
References: <20190516215423.14185-1-sthemmin@microsoft.com>
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

