Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A28A30B810
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbhBBGxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbhBBGxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 01:53:30 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FE5C061786
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 22:52:13 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id e18so22674976lja.12
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 22:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9mXvPzB0HDHgpYjkrEj9f1/KsmShypuTCsJLlqyoYZI=;
        b=L4kJUihiODR1evlfmTM6h0M0ZaHLNxaBar4uirpBWfwisC39vufvrWnwpa8idtkeiU
         mKe2s+7LA0do/qxSqiWIU+0fX8gT2b5FeXPnBMwGfM8aXzjVc6Q5WTVGTHMwpyNZ06IU
         OD47Q+3Oa96aSVubkfhTWSBcPIIkA+quZ4mfWLlTqq/ceUhq+jpE6TNX/J6ZASMMTeH6
         svsqHygJCteIgtnt7g3yMYf2kYydLo4hl5PnNgFQyQpqPTI6EWa9/GCHnpyWWasXcApv
         pqT6ow/q9skQc1lbpMaZiqisg8mRh49jEqJ8RkQuIaTEm03x3J5N6HZmbB6Hf55M+k8F
         SfAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9mXvPzB0HDHgpYjkrEj9f1/KsmShypuTCsJLlqyoYZI=;
        b=Z+HmIy/RWwefLEK6ireQ9XGOreb9oIjfNZggQofnHQJI9F2PnV74+heLMm1B6TqNdo
         WF75rhESUjBGAECAo3WO1Gbx2cO8PDnqZnAgvNeT1vr01w+lunG3Vd+Ccj6aBTVRq5HJ
         L8p5Kt3T7MLL/YFJfvqHTusxoBhSzZ9sFUCyfH5XeaJ+FQQWRT9kOZVS6Q6d0jNPW80V
         QNvd5Q9WWcMH0OK/hiGuMl+vMsQLP2Ks5eUMYIlV9hQ9mR5udtqEea/RwyVTwEeecJDi
         fzy0M4yPCHxQscVzJefkJf6zGUmGle4dFcmHq9TBR6Rf5gRDY4Ynp+PIGQZNwSgBQUJq
         MfpQ==
X-Gm-Message-State: AOAM530B5eNJTp8ifVlt/xdmqbE5llsV/DQJr+fqNa1+UYySXCiCKi3h
        UzVFVnFbPcFhsDlCbBundLXMxXKAklSHCw==
X-Google-Smtp-Source: ABdhPJywz7ri0DGey8R/nKRF89c+7Q6JX1lMYMrN01jVj5f2FsUWzbFezFa8BVhwNd7oCVWFKcUqBw==
X-Received: by 2002:a2e:85cf:: with SMTP id h15mr12239968ljj.452.1612248732410;
        Mon, 01 Feb 2021 22:52:12 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id b26sm2535171lff.162.2021.02.01.22.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 22:52:12 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, kuba@kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Cc:     Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next 5/7] gtp: drop unnecessary call to skb_dst_drop
Date:   Tue,  2 Feb 2021 07:51:57 +0100
Message-Id: <20210202065159.227049-6-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202065159.227049-1-jonas@norrbonn.se>
References: <20210202065159.227049-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The call to skb_dst_drop() is already done as part of udp_tunnel_xmit().

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Harald Welte <laforge@gnumonks.org>
---
 drivers/net/gtp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index e4e57c0552ee..04d9de385549 100644
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

