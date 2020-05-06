Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441B71C7DEF
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 01:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgEFXdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 19:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbgEFXdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 19:33:10 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66179C061A0F;
        Wed,  6 May 2020 16:33:10 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z1so1986941pfn.3;
        Wed, 06 May 2020 16:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JjMAyO4tLtAmhwV/k9L9sSW04zGeh8HxdZQAYEG4VoQ=;
        b=QdjVM5UlTNqjrwlvQ986J0UXLLGo+1dLtobwrQZQ4upd5rLRtGAP6EPxakQ6azs23H
         YdPS15KLLvDutw5Oodla6OPPC4dyprA7KXsA6BckMxD22jBVmOnjuuFdTOrhF4mjm5sR
         F2ePfcsd0b3pjfbACz5giT7H1GJEVF79DEoMkYcV5T9jYM+A+eXD9ewLVLxcElHAfbHl
         sju3zPBHP5G7lpByn7kETGsf7RjIsH8VQBhKTjwTHgkV020wIqiPdB8DwT08SuHPSRCJ
         MpQ5neNt1OIqKjKn7iLOdzF9uTVCzl80vih6B6WkesaZCdG3pRJ+HKUyrhcs6vu+Tct2
         d4Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JjMAyO4tLtAmhwV/k9L9sSW04zGeh8HxdZQAYEG4VoQ=;
        b=gQd59t/FrxFjk/0ehf2ie/l+deCKg6OmJp5YWxvMDRPL7WfzJeQxlsONf75VOOSWCL
         56IkK8VC9YWV1UpGsfzs8mdhn2NBj7J1TBSMMkNIJSIJ4XTnPjHK9CiSxMFaBzgHskwh
         xEvO2UbJC3k+b2PyLWaDlD4bVBSLVufFAGeT5chPagLtRjbKK6QLLtLz2g0S+1w+Bpsg
         2eircCwULsQAIoNBqLUI2wFgBRmheAY+iI4bIXbgfzi13QrsVVDbYxvoxfPWAQIF+x2t
         2SIGTWt6AgTWUXDeiqVY7yyEoNG7WWITc9U41VA8jUuT+zJb8xChKnc9rutmlkK9NdNN
         2n9g==
X-Gm-Message-State: AGi0PuYO0L92pJhQ9jUw8juU91FrBexivjgWqxPIoN8nN4n3AimMJjf/
        swrRc5/Lw3YL6ZlRfmJmWkc=
X-Google-Smtp-Source: APiQypJD92evuW6PsqCb4b+CNaSBoXZV67yCaBLIOsXAwbF5B3yXxXX1rC/eMZ8rZ+3deuQNTWyIog==
X-Received: by 2002:a63:3006:: with SMTP id w6mr8752880pgw.18.1588807989768;
        Wed, 06 May 2020 16:33:09 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id u188sm2957158pfu.33.2020.05.06.16.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 16:33:08 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v2] net: bpf: permit redirect from L3 to L2 devices at near max mtu
Date:   Wed,  6 May 2020 16:32:59 -0700
Message-Id: <20200506233259.112545-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
In-Reply-To: <20200420231427.63894-1-zenczykowski@gmail.com>
References: <20200420231427.63894-1-zenczykowski@gmail.com>
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

Credits to Alexei Starovoitov for the suggestion on how to 'fix' this.

This probably should be further fixed up *somehow*, just
not at all clear how.  This does at least make things work.

Cc: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/core/filter.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 7d6ceaa54d21..811aba77e24b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3159,8 +3159,20 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 
 static u32 __bpf_skb_max_len(const struct sk_buff *skb)
 {
-	return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
-			  SKB_MAX_ALLOC;
+	if (skb->dev) {
+		unsigned short header_len = skb->dev->hard_header_len;
+
+		/* HACK: Treat 0 as ETH_HLEN to allow redirect while
+		 * adding ethernet header from an L3 (tun, rawip, cellular)
+		 * to an L2 device (tap, ethernet, wifi)
+		 */
+		if (!header_len)
+			header_len = ETH_HLEN;
+
+		return skb->dev->mtu + header_len;
+	} else {
+		return SKB_MAX_ALLOC;
+	}
 }
 
 BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
-- 
2.26.2.526.g744177e7f7-goog

