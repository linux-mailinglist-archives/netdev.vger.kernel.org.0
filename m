Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325D930B80C
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhBBGxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbhBBGww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 01:52:52 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B23C061756
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 22:52:11 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id e15so6224577lft.13
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 22:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Axi2g6I6F47I8bzDu1p5LN7RII40A/s6odd4OB1z8JY=;
        b=K7eMwPBghHXhnZXrn2zY/9oXlI5gHNgURdQ1efvzDP6ZMp/02hbpT7zXc2ymtKliAI
         7HiaA04pk1Z/X+61mDwKDByrEE814VuRDWy/4T6IEbMVjreXd6hRpy6gSXLb2PyjX/lN
         TIi83iCL5ZJBBbToPZeXm8Wl6O0yql8UXHOW18cFIm6Y2jHsTdmMfSZUZv22jiToIQow
         WlAXppchsE65jjRsfw0ddvG6KEDnJwGzQUSwvut5m2tLeLeoKPagalcN1ayFB2ugE0wV
         u9WJs1FG3iyNhUIf7JekIsl9U4SRh8xBlLtvteVCxJ5vFwLapDPjI4/4uuU5jzTO/2O1
         439Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Axi2g6I6F47I8bzDu1p5LN7RII40A/s6odd4OB1z8JY=;
        b=djQMNKlGY+TCy8BYbpK5NtWic5K2/G1nrVAcllv0r136h7i41wneopunC6Pz650hYZ
         5G4wwJBU38TEEN+10FaQwkO+sj9MkWb1FRJTPY934iu831V+hnEopBHzY+geVgKZcVcd
         nMzCpaNbLwSacz7h7b4UD67WY0qe9s2UU50tqR30HvvktohRJYZwzVw1BilN/yhFbIct
         0RY6lVNYL3lAUmAkMUkk5JysJBgpyNXqHkFCMBCSEQ8p3xK9SuPFJGIBsetgdvU3Mfut
         f7UWlW+zL/0aes3vF/um9XldlZNmxZuTk8QiJyxjP/Jink3Doru3DV0N1FEdTBw4fq0X
         eFhw==
X-Gm-Message-State: AOAM532pOd0NUJNhho0d8Tq5Ea7i+Ek5H4pfppVggnh3A5nyvhTGzSlm
        nlEtX6Hc89ckuejetKkPwC8Hvg==
X-Google-Smtp-Source: ABdhPJx9rpXfHupM7Abg7g/1uqf08dU9PqtSYUJuN2sBS7ozN3qsSFg4mm9IJ+JV6WV7uehx/hdvsw==
X-Received: by 2002:a05:6512:488:: with SMTP id v8mr9815487lfq.457.1612248730211;
        Mon, 01 Feb 2021 22:52:10 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id b26sm2535171lff.162.2021.02.01.22.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 22:52:09 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, kuba@kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Cc:     Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next 2/7] gtp: set initial MTU
Date:   Tue,  2 Feb 2021 07:51:54 +0100
Message-Id: <20210202065159.227049-3-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202065159.227049-1-jonas@norrbonn.se>
References: <20210202065159.227049-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GTP link is brought up with a default MTU of zero.  This can lead to
some rather unexpected behaviour for users who are more accustomed to
interfaces coming online with reasonable defaults.

This patch sets an initial MTU for the GTP link of 1500 less worst-case
tunnel overhead.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Harald Welte <laforge@gnumonks.org>
---
 drivers/net/gtp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 4c04e271f184..5a048f050a9c 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -612,11 +612,16 @@ static const struct net_device_ops gtp_netdev_ops = {
 
 static void gtp_link_setup(struct net_device *dev)
 {
+	unsigned int max_gtp_header_len = sizeof(struct iphdr) +
+					  sizeof(struct udphdr) +
+					  sizeof(struct gtp0_header);
+
 	dev->netdev_ops		= &gtp_netdev_ops;
 	dev->needs_free_netdev	= true;
 
 	dev->hard_header_len = 0;
 	dev->addr_len = 0;
+	dev->mtu = ETH_DATA_LEN - max_gtp_header_len;
 
 	/* Zero header length. */
 	dev->type = ARPHRD_NONE;
@@ -626,11 +631,7 @@ static void gtp_link_setup(struct net_device *dev)
 	dev->features	|= NETIF_F_LLTX;
 	netif_keep_dst(dev);
 
-	/* Assume largest header, ie. GTPv0. */
-	dev->needed_headroom	= LL_MAX_HEADER +
-				  sizeof(struct iphdr) +
-				  sizeof(struct udphdr) +
-				  sizeof(struct gtp0_header);
+	dev->needed_headroom	= LL_MAX_HEADER + max_gtp_header_len;
 }
 
 static int gtp_hashtable_new(struct gtp_dev *gtp, int hsize);
-- 
2.27.0

