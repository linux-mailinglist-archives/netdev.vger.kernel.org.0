Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF94B2D7592
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405920AbgLKM1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405425AbgLKM07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:26:59 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110D7C061793
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:19 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id t22so10696427ljk.0
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6BSRjOodBZ7tT7aU2nQdFJQPyYeEkXkMGDSFnjVOlb8=;
        b=vnJEYc4SMlLAKJULERS3y3Gd7jy7nMscVNx4wDHKyBFk+WwL4aNXhOubStwmiri0si
         2aWgGuJEJ2CpHfkGrgB9OSZCGSSjrN2svZZc5zKi04XIjo1mJketiyvlX5Dte+39bJwk
         9MSiSP6Tjz4FfWG0oqViWR/5LstiaeX51nfgYrTAq+0moZf7URS0Esv7ffGxK2RxnAA0
         +JTYTs713Kz2IR63RmHe6rX/bNwxH0nVgeCz5MjAZx0DRXRXmhYijZsxnXp0lCOwYALt
         UWq9m2utpqIdrtvN/vJ4A4fv+PMHVcD3CNNNMZ0I4VgGZ34me0P76rXHQ8O71YHFiNdn
         QT1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6BSRjOodBZ7tT7aU2nQdFJQPyYeEkXkMGDSFnjVOlb8=;
        b=Q4sUv6tmnsJoIh6nDwsAT81EwoUsg+3HQIfdJokWSesiSAox52Qsia/MHsnqHNdXv3
         jTr7twA70lvoW0ql2EdJua4ZOxp4Y2m0FN8o0A/dvouzHIbZpmm7AxgSpNqR59EuRiUO
         oWq0j23cv5zTjCQsgwSkJLAV1X4yTHdTEpO1Cq1O+4Kb+s5bbdT7G+oCSyLQV/Ejzlhd
         mWBZgN1gjLz+owL04GuFQBzcPwzkoJsSIR6xrDIq6cwg8UbbHnMRLqIWB9WPLV5RZ9rc
         ++MfIfOOi8e3zw0LxLMCKWaIb96v7noyOG112gJS+9017mo5ujX7hRXsCW0xkEGWPav9
         AyRg==
X-Gm-Message-State: AOAM531w3GgN360FDg03tu1iQpEmHArPpfL1uL6SfNdgbXPGHB2sEwwz
        w/knEa2GmnpGbvu3CzmU69VZDyqkMdAXSw==
X-Google-Smtp-Source: ABdhPJxHWMafldR2tHZEgaREunhdwqaOb4whyxhtS0Qm3RDlOJJW6JzjlzkkC2yR5pAsSpRnNcfUsQ==
X-Received: by 2002:a2e:9c5:: with SMTP id 188mr4730198ljj.446.1607689577394;
        Fri, 11 Dec 2020 04:26:17 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id s8sm335818lfi.21.2020.12.11.04.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 04:26:16 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 03/12] gtp: really check namespaces before xmit
Date:   Fri, 11 Dec 2020 13:26:03 +0100
Message-Id: <20201211122612.869225-4-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201211122612.869225-1-jonas@norrbonn.se>
References: <20201211122612.869225-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Blindly assuming that packet transmission crosses namespaces results in
skb marks being lost in the single namespace case.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 5682d3ba7aa5..e4e57c0552ee 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -592,7 +592,9 @@ static netdev_tx_t gtp_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 				    ip4_dst_hoplimit(&pktinfo.rt->dst),
 				    0,
 				    pktinfo.gtph_port, pktinfo.gtph_port,
-				    true, false);
+				    !net_eq(sock_net(pktinfo.pctx->sk),
+					    dev_net(dev)),
+				    false);
 		break;
 	}
 
-- 
2.27.0

