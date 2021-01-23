Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21B130181E
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbhAWUCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbhAWUAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:00:36 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA59C061351
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:36 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id f1so2489727lfu.3
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F4sC//ZgGUmA9NlrM63F0I/xBsCDk3tlcYvven7F4F8=;
        b=GoAI0A7oyGNiY9AZQjHaFeUnYvLxXuknAG31fBdsQuTVvs7rBN2BNUBFMlsQMyDDMI
         NGfx5bVF4PPTDGWYguMmZa++/B0qIeJRwO18Ge/c4IFH+B/nuUKQ7eJA+zeFKicjG9YL
         ZXdZTLPJ+FxZELCue3BZiya+MibT+SQC2o0O69u5nIVfwegjNpxjCAlCnXfp1gTJsX7z
         t7cMy49eP/agfL1sSj5IsvIZhGC0O6xgeEuECPCXjYc5WcBOKjhwbojl4xur4AWd5DHI
         FFnvZkxAlazuCj580485te/GlFrbfr0X8H03CZ1RgVQdkPw/PHGsAdavJOhj73ioVMtO
         rxAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F4sC//ZgGUmA9NlrM63F0I/xBsCDk3tlcYvven7F4F8=;
        b=ipJWjA5aCIokvWPmNMS+BHlksFGWr70S9hAoWRMi/dJcSTfKgxjjCww638z+5aEUWj
         +vfuhrMo42T4zR3nxFLGRtZVgpHiKoDdVtROWiNSCvaHEG1ir7yGrEmGalACaCDYbyJ9
         /wuJatt4cIBwUGEnuQ1LpRt5PnmYaFW5Z5oNKPLg3lD/nI+TlAhLe85srZav2BNRvJzo
         EXJLI6xhQ+SmFRLBtiZQTiYvLp/9KL/VeAfWrlfK/GCzLXcLu8rTb7pr7PHscq9zc6G1
         6M+CZ8Unf2fJ+AIY0MVr0JOB8QyJjHP29vN6XxAWBEhdxcx+soAUHZYS+wM/kvxZINAX
         q49w==
X-Gm-Message-State: AOAM533YiTkjkNA4WwWH4+UdlvzTvtyL01YCpSb6Wo3nWxhsMoQUFmYM
        IVI2D/ydQ3CGNnU+tlUsnRrjZQ==
X-Google-Smtp-Source: ABdhPJzD2voNSbCbLvnNC5Tt1tXWHox80PeGJ4A0aAtPQlHJoeJkYUSu6uyhuaDR7l+RtMHWkVq3HA==
X-Received: by 2002:a05:6512:398a:: with SMTP id j10mr897450lfu.167.1611431974692;
        Sat, 23 Jan 2021 11:59:34 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id f9sm1265177lft.114.2021.01.23.11.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 11:59:34 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [RFC PATCH 05/16] gtp: drop unnecessary call to skb_dst_drop
Date:   Sat, 23 Jan 2021 20:59:05 +0100
Message-Id: <20210123195916.2765481-6-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210123195916.2765481-1-jonas@norrbonn.se>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
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

