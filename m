Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A603B47C2FC
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239577AbhLUPgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239510AbhLUPgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:36:07 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F478C061759;
        Tue, 21 Dec 2021 07:36:03 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id y83-20020a1c7d56000000b003456dfe7c5cso1986195wmc.1;
        Tue, 21 Dec 2021 07:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WNPIqQM1z0+kuavyLggOTiNlMbd0U5faiuOmlW4HlIg=;
        b=dMnBV5a98j8DOXbdVK6Qk2c0ccAKxlo3uQwu5vf21CUOHogMDoVHgrwKFlOrNR68Vf
         RB/Vmnqp7T6rQxLraTX63VYJ7MNgjyQn50Hy5t1N9lB8EH1mrB7vdVRzWpv2KdRY5wwj
         x2hpCgfKYat5k8MCuo/ppkIXzwUEDbqu8oCxSZc0FhDWo/dLwYgS+nxddDAFD44O+c9Q
         MLmx1hXD5Oup1I1R42j9QXj4dCY1iJ4iJ9VL7sbdf0AYPie1GDp6zwdaEpU16BUnuLR+
         vwPNbMJEFHLpwjGE2wog+rtENZHDcKMILaa8eHArjv6/m5siFdXvNwConrvITz7EW3lg
         o+Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WNPIqQM1z0+kuavyLggOTiNlMbd0U5faiuOmlW4HlIg=;
        b=y8Kob//D+vaGgOciAIgB/MrI32miii1DpPg4kFTCkMmufJ2Wveu4gDHdZy7AymCGRi
         rOTCrHw0W0+KihC5ODDL/KvhozkjF2RGe4x2tx8/+vliZfV32McCVzC8vXdx9eLfYsUO
         2msugWNvUHxDt5lfxxcmBbQDVvCGQm9fo20wXtaKu8u+RR33bQZDO7s20v4dmG6MUSfC
         0LaX6YJLx9NRM98msKy2yDgbtCF8AD57K2ALgLvNmMOVLso2sv5yEPLLjDhjOlBplAYZ
         m6ThZGNJ1fnbmjjZZU2OltPogdfoUVaZ/DLAVBFmcJon90zEf5ZSwBvlMemlITCRRGxo
         9eSA==
X-Gm-Message-State: AOAM530INT8yg0kv7nZI5jW7znBfv0K+oWEpqgUXDx9/XTDIAbsus46i
        8LHfLGVM2J/inV/sZ5rLWUi4QkosztE=
X-Google-Smtp-Source: ABdhPJwhNbc/EwvwaWp87zZfhSuYzHX03J5P9vGGH5P7uABbg/G6WBHZi+KVdG76A4hdywSF6h9gBw==
X-Received: by 2002:a1c:e913:: with SMTP id q19mr3228084wmc.87.1640100961588;
        Tue, 21 Dec 2021 07:36:01 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:36:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC v2 09/19] ipv6: avoid partial copy for zc
Date:   Tue, 21 Dec 2021 15:35:31 +0000
Message-Id: <cd5b3d14fefd5f5eac4425f233bc81935c2d6cc7.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even when zerocopy transmission is requested and possible,
__ip_append_data() will still copy a small chunk of data just because it
allocated some extra linear space (e.g. 128 bytes). It wastes CPU cycles
on copy and iter manipulations and also misalignes potentially aligned
data. Avoid such coies. And as a bonus we can allocate smaller skb.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 822e3894dd3b..3ca07d2ea9ca 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1626,9 +1626,12 @@ static int __ip6_append_data(struct sock *sk,
 				 (fraglen + alloc_extra < SKB_MAX_ALLOC ||
 				  !(rt->dst.dev->features & NETIF_F_SG)))
 				alloclen = fraglen;
-			else {
+			else if (!zc) {
 				alloclen = min_t(int, fraglen, MAX_HEADER);
 				pagedlen = fraglen - alloclen;
+			} else {
+				alloclen = fragheaderlen + transhdrlen;
+				pagedlen = datalen - transhdrlen;
 			}
 			alloclen += alloc_extra;
 
-- 
2.34.1

