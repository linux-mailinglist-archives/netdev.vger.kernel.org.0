Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7137F36897F
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 01:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239881AbhDVXu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 19:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhDVXu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 19:50:26 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A307C061574
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 16:49:49 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id s7so46411360wru.6
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 16:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NajTrN9BBqnPlsm2MhivhGmdkOA3Sl5eTlRcutI2gBs=;
        b=OwGP73Cp/GEQx3n0coHeBrJuUFXgkDr2cIOd+hNfTBj8NACmQouNLwhsuRCVYG5Ub4
         Myb3afBm2j9zSj48yCS7m70l81lSi2UEqqNb4pyo00uwrvP202Bjf+wnmawREvMZ6lcf
         qMQNtlMvvgGTVhFIXsuAgsrpiUIub00K4yYuMTY7clfmQH6UOQIJhOFgtQRY6x7d97fV
         NK05CGdS5lZDfPhv3Ccj9c8q6KFpTvwZjCRhRcfJTABficZBp5IQPdurB4tfieY3UDRq
         HF3m4oHHITVLwUe+HloTfnOXjrDg4U/mCpOAllIdmWwSu0t6etjiS09McE5xOfH0rc7D
         tlqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NajTrN9BBqnPlsm2MhivhGmdkOA3Sl5eTlRcutI2gBs=;
        b=P38ocl6ZrYdGu9KzxUhkBZZ2odN8jzmF93BgmS/lyvQx9pkmJMTuMDrQMhj4kfK/TU
         uUMTMXnQytvAoo2dfRth/4Tek6Q150LmWwCjFxoqZHgH9nAzieKvkzmiVHv8bvuuSdR3
         /Yb4KpsJUI1NO6IK+1iDZ8w2a9Pc/4i28iWufabXqC6RG+JUQ0wm/VGXzZ26wDcnwPqa
         nry/zxAQ0H/f+B6d/vPlkgDKlNUzoh0Z/1P1frS8kDllbs7WhjpZ3xARzcODBZsOxV0J
         fHaPhMpZ1MjfqIVyyGQNlLzUytUiZuxrN0HN5JT+pgDUtXhVmQeWz49wAe1qivkgfiw6
         2kBw==
X-Gm-Message-State: AOAM5319dbDxDfn8iPpB7CknOuzKasHhovmzuJbz+/rEhzjqVTz5dHtj
        LnePy223dYaReEDowb+wAyD5AQ==
X-Google-Smtp-Source: ABdhPJwIBvdzQK0JoY1rz5L2C8/VWaXqjk7Vic9kzeMNxmG/gmopenY+aMqjBQsbKYRVeODxGbAcag==
X-Received: by 2002:a05:6000:114e:: with SMTP id d14mr899685wrx.281.1619135388149;
        Thu, 22 Apr 2021 16:49:48 -0700 (PDT)
Received: from localhost.localdomain (2.0.5.1.1.6.3.8.5.c.c.3.f.b.d.3.0.0.0.0.6.1.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:df16:0:3dbf:3cc5:8361:1502])
        by smtp.gmail.com with ESMTPSA id l13sm6156326wrt.14.2021.04.22.16.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 16:49:47 -0700 (PDT)
From:   Phillip Potter <phil@philpotter.co.uk>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sd@queasysnail.net,
        edumazet@google.com, fw@strlen.de
Subject: [PATCH v2] net: geneve: modify IP header check in geneve6_xmit_skb and geneve_xmit_skb
Date:   Fri, 23 Apr 2021 00:49:45 +0100
Message-Id: <20210422234945.1190-1-phil@philpotter.co.uk>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the header size check in geneve6_xmit_skb and geneve_xmit_skb
to use pskb_inet_may_pull rather than pskb_network_may_pull. This fixes
two kernel selftest failures introduced by the commit introducing the
checks:
IPv4 over geneve6: PMTU exceptions
IPv4 over geneve6: PMTU exceptions - nexthop objects

It does this by correctly accounting for the fact that IPv4 packets may
transit over geneve IPv6 tunnels (and vice versa), and still fixes the
uninit-value bug fixed by the original commit.

Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: 6628ddfec758 ("net: geneve: check skb is large enough for IPv4/IPv6 header")
Suggested-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
---

V2:
* Incorporated feedback from Sabrina Dubroca regarding pskb_inet_may_pull
* Added Fixes: tag as requested by Eric Dumazet

---
 drivers/net/geneve.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 42f31c681846..61cd3dd4deab 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -891,7 +891,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
-	if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
+	if (!pskb_inet_may_pull(skb))
 		return -EINVAL;
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
@@ -988,7 +988,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
-	if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
+	if (!pskb_inet_may_pull(skb))
 		return -EINVAL;
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
-- 
2.30.2

