Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5AA43F4AB
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 03:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbhJ2B5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 21:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbhJ2B5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 21:57:05 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65449C061745
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 18:54:38 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b1so4241225pfm.6
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 18:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WUO1Uep2t9rJD6dn/61N2ts7z4n7K9ZGBvtN05Ewxcc=;
        b=FiO+p12nBODWv4LUO6PPCrqIap97oghsRi+cwWRra0Kha7cYaegu1mGHsskKh0DS0A
         PrY6SQzfF3xF2Wo6NKFcU9aObBEwCxNWwpvfMaa46ZR1jIqtjMgi5E4tNOPvzpv9wwCb
         ZFII2+vaMDo/8yK4tkui5x5KhN8thFlrU88PcwB9t9GKj8eafE2iMbGiC7LHSPW8KTb5
         c9g8XAC6JfeZlBbtb9nitee1o8IrecmTk0+z7QOa+0IW2PLZ9pmtJCpmetHD9XgXUWfA
         HEgyvPgZbjVYx382KoUFuKm7hHLgeSUZSFFhRO3GNLx4v1c2xKF28wXZc1TpDXINTViL
         8s1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WUO1Uep2t9rJD6dn/61N2ts7z4n7K9ZGBvtN05Ewxcc=;
        b=fwHfwQhfnQ/ClyUdSRpyhgTfch743yDGpDkC+OJU+l6wmFKeNRXEu8B7kYfpgCo8tF
         KBYr2PwUQEFp2KxhrUJooJgUGmbUUmDDL6cAbrqDIVzN4U1++7RRkW+dX/ggQk4gNCtQ
         Npta7rjKtPS8/auDIMIJctiPXWwXlR0IVlO1efBnAkZitBKR9x4rsoZ16VavD7FkIWzp
         aFl2VGhReDDPx791IJ4wfCiTWtJv8AXf4QYGMQhJotPW1hgEsj/oQ53tq/u/wHNovsC2
         nIY3DXN6i+momVHQdgNZM3cKDdARXYqZDpVTBK14AasMVX9fF9D9J3bg484cjv3VbXu+
         KsYQ==
X-Gm-Message-State: AOAM532suhcUmjsh9l/bqSzggonIN3U8XcY7rWTiq5578KMbK8XsaLi/
        smXa5H5b3U3iZneZrV+RX0pG7iSRW7u4MA==
X-Google-Smtp-Source: ABdhPJw5W8d2ZVsrb5evYhmzl5VOl9ohAMUwyKGX29XGi17ghtyfpC9o5YryYB9GuYVYvv8wzY6/lA==
X-Received: by 2002:a05:6a00:150d:b0:47c:1d28:4ef5 with SMTP id q13-20020a056a00150d00b0047c1d284ef5mr7918936pfu.6.1635472477623;
        Thu, 28 Oct 2021 18:54:37 -0700 (PDT)
Received: from localhost.localdomain ([111.201.149.194])
        by smtp.gmail.com with ESMTPSA id on17sm8974675pjb.47.2021.10.28.18.54.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Oct 2021 18:54:37 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: core: set skb useful vars in __bpf_tx_skb
Date:   Fri, 29 Oct 2021 09:54:31 +0800
Message-Id: <20211029015431.32516-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

We may use bpf_redirect to redirect the packets to other
netdevice (e.g. ifb) in ingress and egress path.

The target netdevice may check the *skb_iif, *redirected
and *from_ingress, for example, if skb_iif or redirected
is 0, ifb will drop the packets.

Fixes: a70b506efe89 ("bpf: enforce recursion limit on redirects")
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/core/filter.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 4bace37a6a44..2dbff0944768 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2107,9 +2107,19 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
 		return -ENETDOWN;
 	}
 
-	skb->dev = dev;
+	/* The target netdevice (e.g. ifb) may use the:
+	 * - skb_iif
+	 * - redirected
+	 * - from_ingress
+	 */
+	skb->skb_iif = skb->dev->ifindex;
+#ifdef CONFIG_NET_CLS_ACT
+	skb_set_redirected(skb, skb->tc_at_ingress);
+#else
 	skb->tstamp = 0;
+#endif
 
+	skb->dev = dev;
 	dev_xmit_recursion_inc();
 	ret = dev_queue_xmit(skb);
 	dev_xmit_recursion_dec();
-- 
2.27.0

