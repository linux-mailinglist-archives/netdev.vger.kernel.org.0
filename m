Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0242CBD13
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 13:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgLBMei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 07:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbgLBMeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 07:34:37 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059DAC061A04
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 04:33:53 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id u18so4403877lfd.9
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 04:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bIEvPF6uAlOusLOWdiQWcOfYNoZoRxWo1vGs3pnAlms=;
        b=2Q++9XqvDTBERf9LkNlpoJl/3WuqkmpMNCoXi0WgBMUbA/vNyhv4PXUU17RflpO2wj
         GRjoi2SVrJ06bZ6NyaMEUoI3GNYzdLZ5xIo24m9X8Zda3S//96+BRdh4WOw3pT0mVtH/
         q12DdWo5KICy8kVIwGLenFGZ+Sp+PF0DZ+NhnZeM3lpOQjeBPZDhW+SiODiBYH5iYMog
         /TOCGOs0RogQiTfmWcygxTPyGOP9m6kjUmM5CUlazS/TauRd6ElK2FIfzXwOEdDtMco9
         nlTcUxV1y3HZIp3owP+LTDVG28M6UB6aDLcWDwJdM4Kh0Wbobdo+quUNwTx4Rbh9BgFQ
         GTSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bIEvPF6uAlOusLOWdiQWcOfYNoZoRxWo1vGs3pnAlms=;
        b=S3x+ik1lEZdOLyLUfxRn+RZZ00ILkMdyHLp3rMtBmRrmmA45UypWftcZLFlALV80eq
         DOrH6RjXBnis03lTkkAAPSrBvDG0vJmmYLmqZSkp8yBB8VEia2YSY54ACPPLHY5kYceg
         T/QDI8I5LhI8NvP74iQAFTnV2O6fiqvzRDT/RKRV1fzNzSzGPcx+JOwrtRjKWtggBTPd
         VsZnlZkbN4e0qEO+oWComgY0aP0YZgnA1e2PKm8Qlo5GMRvoN+Mr3jf3xaglv8TmrDXi
         IHwHI4G/M6MF0j/z0nStcduyNMZcJpuNN8lGIN4dgHidnu26ljKHWttXYkb/opSe384+
         LLWQ==
X-Gm-Message-State: AOAM532v0TQG2jjOlFmT++nwqFi+yw1kG+o+sKvZtkeQeYSVQ027AY1/
        1hmg+c4/aktboYQkbvlZkKe3Tls6u8Be6Q==
X-Google-Smtp-Source: ABdhPJyON2nCljwXZjF2n1H3o+S0g8xcPtNo9IG9L4uNObeJpkYCk1hZlIoAxvQNq1eN7HMHwiq7HQ==
X-Received: by 2002:a19:8883:: with SMTP id k125mr1094028lfd.10.1606912431420;
        Wed, 02 Dec 2020 04:33:51 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id m7sm439230ljb.8.2020.12.02.04.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 04:33:50 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org, pablo@netfilter.org
Cc:     laforge@gnumonks.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH 4/5] gtp: drop unnecessary call to skb_dst_drop
Date:   Wed,  2 Dec 2020 13:33:44 +0100
Message-Id: <20201202123345.565657-4-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201202123345.565657-1-jonas@norrbonn.se>
References: <20201202123345.565657-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The call to skb_dst_drop() is already done as part of udp_tunnel_xmit().

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index e053f86f43f3..c19465458187 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -515,8 +515,6 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
 		goto err_rt;
 	}
 
-	skb_dst_drop(skb);
-
 	/* This is similar to tnl_update_pmtu(). */
 	df = iph->frag_off;
 	if (df) {
-- 
2.27.0

