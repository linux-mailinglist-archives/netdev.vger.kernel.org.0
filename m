Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D53B3FA8E9
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 06:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhH2Edd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 00:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhH2Edc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 00:33:32 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000F2C061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 21:32:40 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mj9-20020a17090b368900b001965618d019so1459906pjb.4
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 21:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=59LOTC9gts5azafnG1uKWbt0LZaGVODRIq+66ahkyTo=;
        b=SDm1UWDu/BaNO/Z+ROkbSNzi9U6n19VwCByCxoWe+x+sCFs7m/K4pmZ8Y5Vbx42Q2z
         gZkMeEr02wOvztycpRa5bcFTM15rS2EYIhbMffHnhfx9FTH7pCYm6NZJptjRCSJjl9f5
         7f1blct1Qqtv+kpyErOhKH9HiiJEIedP014dGHYuJKVLpN2CdL8DoHT88R89lCBfHL/9
         LNJsq8jwoWyrwXAxm/8/MshxbcfU1syCSmpo4Lbr0j/hcxI9K1tV+Irx0FoqOESlDDRf
         /exWL+zXy3H5ofdvk/J6hpcqMjKdGr10xw+zRpJC5FKOrdC1zc+ga/iaXnAEnECDFoBK
         jRZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=59LOTC9gts5azafnG1uKWbt0LZaGVODRIq+66ahkyTo=;
        b=EzFvYNPlVcMFz1PS+WIG58/dlHFr2A/bCS4pi1jGLHZNoow/fdfsPTYeRUGQ0FrV79
         PV4EmWkD8+fFCc7qDNFKyuTKU1whGrX2D4AhHuqP2JEz01X/QI+eZhOZGRH93A500ezx
         IP/EUFLDXUXNUStga2NUk+HHk7xoh/YYDVtDeC4eGgoM6KjERdjlg+7Phz6VIHWgmPEN
         IxBIWP8cyCC5+nLGyrR2HohC/V5lb6MtYAIrWYDZYyEhCLuFli5FjfafgtFsYzw4jzSw
         SOJXbEjwfbTmLbKkh6vduJyg72+ASHT3VaqIYlSTOWXpHN5G7b8TqpkX8WNAHV+rLkoB
         rKyA==
X-Gm-Message-State: AOAM530qjGKObTKnP5b79PRoWySGkmim5wzCzo9uPBTD8bQZRQBS4C2d
        DkKgIzvYItlTrE/qtts8Ebk=
X-Google-Smtp-Source: ABdhPJzDoLnXRsSF98gdwpGOSqJtH4hoWNBf4RBzC+mnMPCrOP5KJyaIi08KzhOk+VsXfgcwUtgfjQ==
X-Received: by 2002:a17:90a:1f09:: with SMTP id u9mr31484812pja.206.1630211560157;
        Sat, 28 Aug 2021 21:32:40 -0700 (PDT)
Received: from localhost.localdomain ([223.62.190.153])
        by smtp.googlemail.com with ESMTPSA id x16sm4305718pje.0.2021.08.28.21.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 21:32:39 -0700 (PDT)
From:   MichelleJin <shjy180909@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, nikolay@nvidia.com
Subject: [PATCH net-next v2] net: bridge: use mld2r_ngrec instead of icmpv6_dataun
Date:   Sun, 29 Aug 2021 04:32:29 +0000
Message-Id: <20210829043229.46000-1-shjy180909@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br_ip6_multicast_mld2_report function uses icmp6h 
to parse mld2_report packet.

mld2r_ngrec defines mld2r_hdr.icmp6_dataun.un_data16[1] 
in include/net/mld.h.

So, it is more compact to use mld2r rather than icmp6h.

By doing printk test, it is confirmed that 
icmp6h->icmp6_dataun.un_data16[1] and mld2r->mld2r_ngrec are 
indeed equivalent.

Also, sizeof(*mld2r) and sizeof(*icmp6h) are equivalent, too.

Signed-off-by: MichelleJin <shjy180909@gmail.com>
---

v1->v2:
 - change commit message
 - remove unnecesary space after a cast

 net/bridge/br_multicast.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 2c437d4bf632..8e38e02208bd 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2731,8 +2731,8 @@ static int br_ip6_multicast_mld2_report(struct net_bridge_mcast *brmctx,
 	struct net_bridge_mdb_entry *mdst;
 	struct net_bridge_port_group *pg;
 	unsigned int nsrcs_offset;
+	struct mld2_report *mld2r;
 	const unsigned char *src;
-	struct icmp6hdr *icmp6h;
 	struct in6_addr *h_addr;
 	struct mld2_grec *grec;
 	unsigned int grec_len;
@@ -2740,12 +2740,12 @@ static int br_ip6_multicast_mld2_report(struct net_bridge_mcast *brmctx,
 	int i, len, num;
 	int err = 0;
 
-	if (!ipv6_mc_may_pull(skb, sizeof(*icmp6h)))
+	if (!ipv6_mc_may_pull(skb, sizeof(*mld2r)))
 		return -EINVAL;
 
-	icmp6h = icmp6_hdr(skb);
-	num = ntohs(icmp6h->icmp6_dataun.un_data16[1]);
-	len = skb_transport_offset(skb) + sizeof(*icmp6h);
+	mld2r = (struct mld2_report *)icmp6_hdr(skb);
+	num = ntohs(mld2r->mld2r_ngrec);
+	len = skb_transport_offset(skb) + sizeof(*mld2r);
 
 	for (i = 0; i < num; i++) {
 		__be16 *_nsrcs, __nsrcs;
-- 
2.25.1

