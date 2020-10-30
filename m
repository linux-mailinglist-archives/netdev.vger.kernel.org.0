Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A9D29FB4E
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 03:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgJ3Caa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgJ3Caa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 22:30:30 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C4FC0613CF;
        Thu, 29 Oct 2020 19:30:30 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id e7so3955855pfn.12;
        Thu, 29 Oct 2020 19:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j6uvYZsdn9TjVvj7gx86V/39t9vFMxPa68xHa2VlZqY=;
        b=uVR8AlzNizv4t265Ok/jlnDW1uCEPkvT7AwY1qXZoV4G5n4PXgU3QGP36ag0UiIosC
         C28NLyMp5uVkmwbw9CE3HkZzSBtz6AE1VMO5JulI4C07XQwWL624B6fhR7+jAUktsQqK
         DLy073Zb7XE3fkKwD8vPU23CScz3reyvMJ38Np+D+mmDMb1n1rKzyomfljxSLwkIb9hA
         1OcBmXBcFDXtGPDRANKIWoFR2N/iRDyVbhsJqRY2AwLNL9dNOC4PSLCRKg/XxC/gcWJN
         MJ2NVTHZ9SnR/AFcCwngCMtNfaMOOvvJypjEN8nKy2Fqy+/+Llx2VA8AdFcOMyWj22ef
         1PcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j6uvYZsdn9TjVvj7gx86V/39t9vFMxPa68xHa2VlZqY=;
        b=D7YAkR6UDqa0DlBrQwsf8yXBkeE4SJ/mnWfdPmhEiY79HlrMMuKH4I0ImqPd55U5Ro
         vKffvibmgFbrJSSA4ewtq3NYj0AwR5lGs68yTpt2qK7X7kFuIVgeeCYovTMvASYngy3Q
         uy76zfzvSTtgffIHKXmx1zdyDJV66oQcrhHXKgoU4rFxv3qrCFbjKGYPgrdG3LiJ/7PE
         FV8kOJAgel9FUuYlyscjq239v8BzePnLFUJuWR9/HHwm7/TWMAV2tzDkbHWDdhwnIQBM
         jZAbtBf1pjh2o5QSnio0118QOqJ6lJQkfenZ47MnkrfYQB0kSjynD8wOX80+xu2rFI39
         gBsg==
X-Gm-Message-State: AOAM531aYczfUb8X6huQyTn4BPw7r1zubZ5VM8sDHjbQhGG3Hqp4vWCh
        vy5OWZTVqj2NWv3epdXp9iM=
X-Google-Smtp-Source: ABdhPJyu1EPaHSCFZlovbQkLQnsN71kwV97oCj6PF+lOtnD37yOzU4TgofXiQeQtazI/n6hxRYVH+w==
X-Received: by 2002:a63:105e:: with SMTP id 30mr224588pgq.33.1604025029908;
        Thu, 29 Oct 2020 19:30:29 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:dd13:d62a:9d03:9a42])
        by smtp.gmail.com with ESMTPSA id i24sm4216588pfd.7.2020.10.29.19.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 19:30:29 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v4 4/5] net: hdlc_fr: Do skb_reset_mac_header for skbs received on normal PVC devices
Date:   Thu, 29 Oct 2020 19:28:38 -0700
Message-Id: <20201030022839.438135-5-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201030022839.438135-1-xie.he.0141@gmail.com>
References: <20201030022839.438135-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an skb is received on a normal (non-Ethernet-emulating) PVC device,
call skb_reset_mac_header before we pass it to upper layers.

This is because normal PVC devices don't have header_ops, so any header we
have would not be visible to upper layer code when sending, so the header
shouldn't be visible to upper layer code when receiving, either.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 3639c2bfb141..9a37575686b9 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -935,6 +935,7 @@ static int fr_rx(struct sk_buff *skb)
 		skb_pull(skb, 4); /* Remove 4-byte header (hdr, UI, NLPID) */
 		skb->dev = pvc->main;
 		skb->protocol = htons(ETH_P_IP);
+		skb_reset_mac_header(skb);
 
 	} else if (data[3] == NLPID_IPV6) {
 		if (!pvc->main)
@@ -942,6 +943,7 @@ static int fr_rx(struct sk_buff *skb)
 		skb_pull(skb, 4); /* Remove 4-byte header (hdr, UI, NLPID) */
 		skb->dev = pvc->main;
 		skb->protocol = htons(ETH_P_IPV6);
+		skb_reset_mac_header(skb);
 
 	} else if (skb->len > 10 && data[3] == FR_PAD &&
 		   data[4] == NLPID_SNAP && data[5] == FR_PAD) {
@@ -958,6 +960,7 @@ static int fr_rx(struct sk_buff *skb)
 				goto rx_drop;
 			skb->dev = pvc->main;
 			skb->protocol = htons(pid);
+			skb_reset_mac_header(skb);
 			break;
 
 		case 0x80C20007: /* bridged Ethernet frame */
-- 
2.27.0

