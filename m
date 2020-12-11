Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BBD2D758F
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405916AbgLKM1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405435AbgLKM1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:27:00 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8B6C061794
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:19 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id m19so13092164lfb.1
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F4sC//ZgGUmA9NlrM63F0I/xBsCDk3tlcYvven7F4F8=;
        b=OEkfuu5P9PMegHBi9dowF0tSk/QRCeWPgguLndEkg9qVrEV8AD8zBvkmW5NN/KvLof
         78A9+Q/EykO+vlE85FvJrnI8jm/gZxTJt483AAYm2XctiCTlOtMTNit/r66k3DLNKAXc
         WcqbK75aQCXH+SWv/C6/NXDynRAC5DOUXNZZtpQIpuXJf7H9Y8Soww3fOKCMD5+WS6I0
         hVJvQMnDlw783n+nJBpRcPoaV6VEUKJz28m+rmy62RcIuQp4LRdqeBVtDmdnaEkUfWLB
         j3yOSSsNe73O8HDwuewM8D8tcXuZND776e4AwyxacU24YlCKPXw6+3aItbhWs8Eyiv0s
         wxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F4sC//ZgGUmA9NlrM63F0I/xBsCDk3tlcYvven7F4F8=;
        b=XGkqN8MaJ0iEtu7YjL2JbuEowdLvNjLlgNS7wU5VN6dJyYY6VlRaPqZs4IVLtAh18s
         jpEXv4TvdZEvuT2SQ8t/7D/zOKVk/AddrAgSDzUCd/3Uyi2WkM3ZncsSmjeKEiBGLB5u
         8kr3CW6JD/RTSm/wAzDhoqhBaDtF0b9l3v8GyhtkiUzw+aD1P3RQQXBy1MFMSENAggp+
         n0ub/VmeAGOH/xQwevJ2vKjWWE+fmvwvEjyawrVBfulu6HyJ0L8RPYotymq3/5fKYWbO
         wOs2oSQDMr4f39mWYUymn5ifs5zdSr0GhdzemItJ69No22Y2/4qRM6dBm6QYabc/RUux
         WFWw==
X-Gm-Message-State: AOAM532r/dOe1KKtvK3N2KUiGT+u40udVMDEJs7p8R2YWE3v1B7UjvaE
        AUCE7Jr6wgmFuWka8QCweeE3bxI5/gC3xw==
X-Google-Smtp-Source: ABdhPJwwWi29BRQac+hXWAO2FH9sRrN5ud10gIGjhjeP/8jI897A8U+HqzoTFtqwM+FP9+OIxSAB5g==
X-Received: by 2002:a19:cc10:: with SMTP id c16mr4371322lfg.112.1607689578200;
        Fri, 11 Dec 2020 04:26:18 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id s8sm335818lfi.21.2020.12.11.04.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 04:26:17 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 04/12] gtp: drop unnecessary call to skb_dst_drop
Date:   Fri, 11 Dec 2020 13:26:04 +0100
Message-Id: <20201211122612.869225-5-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201211122612.869225-1-jonas@norrbonn.se>
References: <20201211122612.869225-1-jonas@norrbonn.se>
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

