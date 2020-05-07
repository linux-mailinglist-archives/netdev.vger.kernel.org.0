Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184FE1C8010
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 04:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgEGCgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 22:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726218AbgEGCgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 22:36:20 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0519CC061A0F;
        Wed,  6 May 2020 19:36:19 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q24so1946471pjd.1;
        Wed, 06 May 2020 19:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Asj4Gooor/CKFIxMQNTckF+7GZoXmy3s4w3DaaXlqd4=;
        b=Ul0LZ38+URJljiZUX/ceNT+o3aSsX2EBZjVpE7QpFEycmvZzs68AgK1f766sCOpRmh
         Z6nByGJ50T3n9trYcO6e+TqhEcgCadUJ1jUPQUFR1jssVPmf1/uBPe17ll836xCjXABP
         I1dNNAWM0xmhLPXMDpnwRr9wdvdie1zBqfgi7ZbS+phVrQ7v/gztoIxAgEufpYnC+60c
         Z0UBfCsMpMiVBFeSc0kqbpyoSdgVvOxNoL7tcbIqWfJ0+YV/LK0/hXpjk8Pp5xH2BeVE
         +nCUS3pjsw/vZ73IQjh5ATzn/ffZ7fJZom0/3A11uLhnNROsI9xqb5tR82e5wtmvd6pH
         mqoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Asj4Gooor/CKFIxMQNTckF+7GZoXmy3s4w3DaaXlqd4=;
        b=HniiyUh07z0w6YrM8CooWfs0ivhiRfYS1S88xs/PM55gk0RCwm25FCCq6MvuG1v4Uh
         2D+sG8gP/OKZeA9JPlVK44P9ymUWyixA3FXWDKrolw1dSYJOG25boVh9etog9wDgNgjO
         BBIoco0PclFPzYvNLeVztaFc7crvIaT6ckErVbQXaC6bKtz2uyKkgejl89KI5AT553bH
         ujpm4rVa85/pAK0ctzgSifrZBA37Ponnbf9zZDArsckkTvTM4Y3xzblH0Ldhf71pIot2
         rcbj3tg+Cz0nUctzs2oi2ulvADAmeuBOnSn+z526TECGNmQ8aCKdsNdtDGkXkKvLTdSP
         6Rxg==
X-Gm-Message-State: AGi0PuansGf6AJAra8/tKCOvy7MaVQ/DYo8NaQgUUX9ehe8jyYzareJx
        X/W19ztBg8keaPZShqfErmc=
X-Google-Smtp-Source: APiQypKGB0sTNVtLUk/zocKj0OVAZ+6YQSpG4rSI293EPok9beWnMccBqCHJ/3pMXeJisc/l4Nsucg==
X-Received: by 2002:a17:902:b286:: with SMTP id u6mr11031868plr.11.1588818978010;
        Wed, 06 May 2020 19:36:18 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id n16sm3259976pfq.61.2020.05.06.19.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 19:36:17 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v3] net: bpf: permit redirect from ingress L3 to egress L2 devices at near max mtu
Date:   Wed,  6 May 2020 19:36:06 -0700
Message-Id: <20200507023606.111650-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
In-Reply-To: <CANP3RGduts2FJ2M5MLcf23GaRa=-fwUC7oPf-S4zp39f63jHMg@mail.gmail.com>
References: <CANP3RGduts2FJ2M5MLcf23GaRa=-fwUC7oPf-S4zp39f63jHMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

__bpf_skb_max_len(skb) is used from:
  bpf_skb_adjust_room
  __bpf_skb_change_tail
  __bpf_skb_change_head

but in the case of forwarding we're likely calling these functions
during receive processing on ingress and bpf_redirect()'ing at
a later point in time to egress on another interface, thus these
mtu checks are for the wrong device (input instead of output).

This is particularly problematic if we're receiving on an L3 1500 mtu
cellular interface, trying to add an L2 header and forwarding to
an L3 mtu 1500 mtu wifi/ethernet device (which is thus L2 1514).

The mtu check prevents us from adding the 14 byte ethernet header prior
to forwarding the packet.

After the packet has already been redirected, we'd need to add
an additional 2nd ebpf program on the target device's egress tc hook,
but then we'd also see non-redirected traffic and have no easy
way to tell apart normal egress with ethernet header packets
from forwarded ethernet headerless packets.

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/core/filter.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 7d6ceaa54d21..5c8243930462 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3159,8 +3159,9 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 
 static u32 __bpf_skb_max_len(const struct sk_buff *skb)
 {
-	return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
-			  SKB_MAX_ALLOC;
+	if (skb_at_tc_ingress(skb) || !skb->dev)
+		return SKB_MAX_ALLOC;
+	return skb->dev->mtu + skb->dev->hard_header_len;
 }
 
 BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
-- 
2.26.2.526.g744177e7f7-goog

