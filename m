Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA623AA7F0
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 02:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbhFQAM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 20:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234905AbhFQAMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 20:12:19 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FF7C06175F;
        Wed, 16 Jun 2021 17:10:11 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id e7so1990278plj.7;
        Wed, 16 Jun 2021 17:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2EVe6yWId4rmhH7SxvVNrCWJZunis2SdOr3XkJ2G69A=;
        b=foX74GqvdnCt/QsbrX2s6sJE/O6n8eGQ/zCW0eXZX4e2RmlMHmPXbWU//EXUnt9MbI
         U3jqGNyGv7bj7AdqK6jS78S5KfOI3GkGPLK1FikXKnDlq5an/s4bZgKPnMpo2c7YBnE3
         4scItAkG/6WKsbOUPb5XwceEOgilSIQQfHpMCj5DQHjn8afEeEe/Ick8m9rSPNJ7aaRZ
         YpQ9CGyhpife+LqMCZtqd7XhXM57MhxpJDm3ekD4oBkSuGgvejvX8kDw6Zl77SSDQ8FA
         zOq6mIXhTCbaqY9DSANRycRRPJBKY6R0RnpoHpgJhnlCqChZfLCaw78DbTykio0+2sH1
         un0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2EVe6yWId4rmhH7SxvVNrCWJZunis2SdOr3XkJ2G69A=;
        b=U+A5JxrhNrwtL/RNuQYlJdabkSLwHDbE9goZnRx/cMn9vLPqAUMp/GNGDwuITXnN96
         zmQTnR7DkttKXIFW5gIxoPiNFDF2tfDShKc2ykVpnRC+aS7QMdVQQCW4ik+FHIWdztd4
         0NK9awRt0BaIoAqeP24AH6FfhdDD8LJWe2HdI/9Dd+XI0f7Nyp1Oqx7Qr1N+/ODjMC1W
         4KEko/P0Sx9XUAH8GjLGSFD32K5vyDQO7yJquC2SENXPLirKJ2OE6oc9HGVs9l+/tLg/
         IVDpx7YjML19TxLbCH5KJuIGdnp+j+jSBY1Ivcq9FE2yvUoyFOYqY96zRjPlDzbL0LYC
         HUUw==
X-Gm-Message-State: AOAM530QrOPahmEPm7cVcZM8ktBnmFQ0xBSYB/UMxG/LjDn9wQqYaR8y
        js8T44OA0+Nt0KLY8I6fwdU=
X-Google-Smtp-Source: ABdhPJwtMFezZ2ja2Z+GrWh+C8/6DGBa3R1dsFmSpZ02TVPG5lzSFdH5/ESoJ/7klenA0M0gpEgf+A==
X-Received: by 2002:a17:90b:3004:: with SMTP id hg4mr13712647pjb.12.1623888610716;
        Wed, 16 Jun 2021 17:10:10 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:926a:e8dd:9095:3ddd])
        by smtp.gmail.com with ESMTPSA id r92sm6599633pja.6.2021.06.16.17.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 17:10:10 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH bpf-next v2 4/4] bpf: more lenient bpf_skb_net_shrink() with BPF_F_ADJ_ROOM_FIXED_GSO
Date:   Wed, 16 Jun 2021 17:09:53 -0700
Message-Id: <20210617000953.2787453-4-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
In-Reply-To: <20210617000953.2787453-1-zenczykowski@gmail.com>
References: <CANP3RGfjLikQ6dg=YpBU0OeHvyv7JOki7CyOUS9modaXAi-9vQ@mail.gmail.com>
 <20210617000953.2787453-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This is to more closely match behaviour of bpf_skb_change_proto()
which now does not adjust gso_size, and thus thoretically supports
all gso types, and does not need to set SKB_GSO_DODGY nor reset
gso_segs to zero.

Something similar should probably be done with bpf_skb_net_grow(),
but that code scares me.

Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/core/filter.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 8f05498f497e..faf2bae0309b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3506,11 +3506,10 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 			       BPF_F_ADJ_ROOM_NO_CSUM_RESET)))
 		return -EINVAL;
 
-	if (skb_is_gso(skb) && !skb_is_gso_tcp(skb)) {
-		/* udp gso_size delineates datagrams, only allow if fixed */
-		if (!(skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) ||
-		    !(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
-			return -ENOTSUPP;
+	if (skb_is_gso(skb) &&
+	    !skb_is_gso_tcp(skb) &&
+	    !(flags & BPF_F_ADJ_ROOM_FIXED_GSO)) {
+		return -ENOTSUPP;
 	}
 
 	ret = skb_unclone(skb, GFP_ATOMIC);
@@ -3521,12 +3520,11 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 	if (unlikely(ret < 0))
 		return ret;
 
-	if (skb_is_gso(skb)) {
+	if (skb_is_gso(skb) && !(flags & BPF_F_ADJ_ROOM_FIXED_GSO)) {
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
 
 		/* Due to header shrink, MSS can be upgraded. */
-		if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
-			skb_increase_gso_size(shinfo, len_diff);
+		skb_increase_gso_size(shinfo, len_diff);
 
 		/* Header must be checked, and gso_segs recomputed. */
 		shinfo->gso_type |= SKB_GSO_DODGY;
-- 
2.32.0.272.g935e593368-goog

