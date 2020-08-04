Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E6423BE67
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 18:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgHDQyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 12:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHDQyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 12:54:19 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C429C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 09:54:19 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z188so12899212pfc.6
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 09:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lIBT5qjudUsK29vpEQJOo/B1KD0nV5ATHPBKz7mq7Y0=;
        b=wjX9m02tOsvMFuZIf0UWuhd5YruAIaI1tjou8l+3ZGuXcjmOxjPnkIXBBMzsuWUitY
         fb50G3SlP+G4F89TF+cKBCc8SromsRXoy0MjnZaZn08HmrH3KC/ITmyY5Nc3f5M5FM1m
         sT8Nqz20klrPy9wkvZT/vVGGShsAfjAb7rxLvM5EUYr8EuD7hFh0K9T4xYHZaExYHGdO
         jRfItuMRIpooifNQW5SJPcy0oUpBmHBB+brrt/bwxdtHG0nnZpDhMOI9Wknsh3o6u4e2
         wdoWf8bSmiN/N2HTY4l3WQJlQbSyIgZpqTQ5pJEFLiAulkjSw8EHfYlhTT33aVqJ1/ZZ
         HjPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lIBT5qjudUsK29vpEQJOo/B1KD0nV5ATHPBKz7mq7Y0=;
        b=iiUgVRNwaSN6rJrg4NhqaF2cc3ch5Vsve6v7tfoZQYypLzGHcloiD470FYlZWSDh/b
         IaOSRPpr6V9VZqEGzBTAjM/a+ttNbny9LK/0x9XiYfzB8Hs7fEfUlP/qgQ1hPEFRvYSc
         0ddlEmXKFtDJlp03Ntz/DzP83nVA+5l4IyEORBBHEPREFEvs8cIOVTK1ixntbh1usWeO
         0dy1evbocpIveZmWwHdp/k0lUug9vo8U5rj13/ttbGslv9KzDK2dKVTBETmiP3uGXvyL
         RvPoxHqyF2lBnWljThtqOIY08gQ1bBFp+SRNMgB0EzhlJY2Xrd2KDdyVzPSU6TO0ym/6
         L4XA==
X-Gm-Message-State: AOAM530hpyCUalFu+ofuRb+Dx1GIxPZNTlOF4aNGF8ybtHKQzGXFn+Qk
        lWi1oGa1Ov57x2bDe9+yjXpEO+J/4in6tg==
X-Google-Smtp-Source: ABdhPJznoBNhRpgOQQ/90kTXaQKt2vweibXZmq3Ja/kNRJYn92eQhZTRblygUER57JjpxTPoEcXSzA==
X-Received: by 2002:a63:770f:: with SMTP id s15mr2736494pgc.249.1596560058730;
        Tue, 04 Aug 2020 09:54:18 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 3sm22331936pfv.109.2020.08.04.09.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 09:54:17 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     haiyangz@microsoft.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, wei.liu@kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Shah, Ashish N" <ashish.n.shah@intel.com>
Subject: [PATCH] hv_netvsc: do not use VF device if link is down
Date:   Tue,  4 Aug 2020 09:54:15 -0700
Message-Id: <20200804165415.7631-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the accelerated networking SRIOV VF device has lost carrier
use the synthetic network device which is available as backup
path. This is a rare case since if VF link goes down, normally
the VMBus device will also loose external connectivity as well.
But if the communication is between two VM's on the same host
the VMBus device will still work.

Reported-by: "Shah, Ashish N" <ashish.n.shah@intel.com>
Fixes: 0c195567a8f6 ("netvsc: transparent VF management")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 drivers/net/hyperv/netvsc_drv.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 6267f706e8ee..0d779bba1b01 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -532,12 +532,13 @@ static int netvsc_xmit(struct sk_buff *skb, struct net_device *net, bool xdp_tx)
 	u32 hash;
 	struct hv_page_buffer pb[MAX_PAGE_BUFFER_COUNT];
 
-	/* if VF is present and up then redirect packets
-	 * already called with rcu_read_lock_bh
+	/* If VF is present and up then redirect packets to it.
+	 * Skip the VF if it is marked down or has no carrier.
+	 * If netpoll is in uses, then VF can not be used either.
 	 */
 	vf_netdev = rcu_dereference_bh(net_device_ctx->vf_netdev);
 	if (vf_netdev && netif_running(vf_netdev) &&
-	    !netpoll_tx_running(net))
+	    netif_carrier_ok(vf_netdev) && !netpoll_tx_running(net))
 		return netvsc_vf_xmit(net, vf_netdev, skb);
 
 	/* We will atmost need two pages to describe the rndis
-- 
2.27.0

