Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D2030D3E5
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 08:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhBCHJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 02:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbhBCHJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 02:09:31 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50EAC061788
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 23:08:13 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id e18so27058445lja.12
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 23:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9mXvPzB0HDHgpYjkrEj9f1/KsmShypuTCsJLlqyoYZI=;
        b=f0q4HTD32DxLDfjsOglhbNvLI4WGG6thLqtX0+y4VlR0Wt/15nArsToQHXfzc7tXtl
         mqdszZzdJxnH4qNBVVApiUqbEwf3W8qZJs/Q5HUWnLrpW0qBBTzpBlxpaymdWOgx6Mt5
         bzSIx3KHfm39Ug/dKMnvh0J673wDyrVgH3BMjSZuoGe2VHaRlVKIu4BcYG5FjOn5NItX
         Mp6fdG3iXAF4H+IFmioOzK+uIZaf9h9xnGjzjVpYFE6etwQXHfi0sa3Le2Wb8e9zXwsq
         zLUbcXqS2SqBKx5ziuoQHBP604yF8CLMetYXYXNIkZcz9sOxKMqLMY1Cf0yKlTCMIuSR
         fmUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9mXvPzB0HDHgpYjkrEj9f1/KsmShypuTCsJLlqyoYZI=;
        b=tVZ/gJXGSSYAGDpqicF3axd+gdKcrSoBV63n1mnBZoDL9MeuGIKFNNKJ2ppA4W3TGr
         HFdVUCDJGqz1KKP00/QPmBwXyKkB3fE+B1XrGP1VvsC20OIjN5IYqvCb3Cl0naON7Pz0
         Ww0y9cd7SSe1liO/dElCJfP+LrmA0PEnS5tisxYd0obYccghBiSXA8rEJLx5O/kyQyCt
         JTQJ9HCmGROBjqU9p4ymHBsRqPDOUq/ewQpLBxSM3SRV0wzi9AXr5hN51q7HyNbZ3MEG
         FRkPS6NbZFOJWqhLc0bM7jKxA5KzxWGhwsPpYtHUmsv4e7fACPLhj78mjhynJNNgHEHK
         JJHQ==
X-Gm-Message-State: AOAM531wN82kqsY6Q+jNKhICJ5hItj6gvLfRgPOl3wru4CdLbM+bUCeO
        GGMS15ThdnsTVoJ8fmL3pYH/Lg==
X-Google-Smtp-Source: ABdhPJylWabs8kp55zQyEW6Vw1uM1sb4EhLt7cja7pNJeYe+/bNuOWtO86xq0ZuniadgoGxazTJlcw==
X-Received: by 2002:a05:651c:482:: with SMTP id s2mr961554ljc.193.1612336092203;
        Tue, 02 Feb 2021 23:08:12 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id d3sm147367lfg.122.2021.02.02.23.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 23:08:11 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, kuba@kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Cc:     Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 5/7] gtp: drop unnecessary call to skb_dst_drop
Date:   Wed,  3 Feb 2021 08:08:03 +0100
Message-Id: <20210203070805.281321-6-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210203070805.281321-1-jonas@norrbonn.se>
References: <20210202065159.227049-1-jonas@norrbonn.se>
 <20210203070805.281321-1-jonas@norrbonn.se>
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

