Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F86C166ED5
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 06:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgBUFOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 00:14:42 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:32786 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgBUFOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 00:14:42 -0500
Received: by mail-ed1-f67.google.com with SMTP id r21so884158edq.0
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 21:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rZtA4eIpQlC4bRsbTidHDU6QtXv/4fTjELciyQG7MoY=;
        b=JPj1wlgs49rZL5AW14Yg9PGBrLriNYRrUuQogk9qOElkbV3MfN3TGLtwQ6hYgd4bbl
         zUGvOlP9cJPS3ZTNMuOjrDl6Arzw+Ka6U94zlWFqlIL8YVnd593I1sTA73RfXiFO2+9U
         lxOenFxeNFFTzHQlZ4S/9EZEzU2C0t+NQ4cRLawoD7a+qraXtYchAqS+XHSjrPu3JQOj
         PzcFX3pepKcSK7tdZmfpkn28L5JULxhgGOshP7uI5VKMZKz05aKa9jriZelcM9AbV32a
         Eq83ZbxOpOfC1ddIgWh21wepfpUKl1d0zGO8dbkaU7BmK9XXino8aZloAUiX3uYYcJ7V
         sWPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rZtA4eIpQlC4bRsbTidHDU6QtXv/4fTjELciyQG7MoY=;
        b=ZO6eq9PW9um5m0GdD/t14a682ooPljU2fXPPE9owfJlX8NA6kRg4uTu/iEI8dwxfra
         z5DYR5EHopq2OtGivZdXJ8nZO4V0rh5MvKhHurssoEXJDgrsyk9P3w5uJyx3Y9CQR09P
         OI7gQxxHV56DFGflnarLYcJzbEKY5pV7Y8bLdIq7eUiJ2cXeeVIJok+d9r2VsJpeWDcu
         6ZonuD+A8nHCLkAtjNVAEME2JoZBqZiq4b6vrhxsxu1Ej7HteBCvl08fvadYEPn+MoCN
         b3OKMWv/gMf3AGqixRKHfW+CFuWc/7EIQnYuh6NguW6bmhaofMUCeRO4weEF8+n7aYI5
         rQZA==
X-Gm-Message-State: APjAAAVphARuzkl/Wpmrh/9qQwlILUB8XGX+KM6TB037FF/CwQvVniLw
        odgGaRXS9PAN15Xon81eZZnKRzwG
X-Google-Smtp-Source: APXvYqyAWUzjuLWsPZh1t0MFzbDNeP1svFdrI2F1GDoY8+WN7DWwozg3NLliILoRFx/Yym6N4Jdtfg==
X-Received: by 2002:a05:6402:799:: with SMTP id d25mr31882540edy.221.1582262080722;
        Thu, 20 Feb 2020 21:14:40 -0800 (PST)
Received: from blr-ykodiche02.dhcp.broadcom.net ([192.19.234.250])
        by smtp.googlemail.com with ESMTPSA id l11sm188238edi.28.2020.02.20.21.14.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 20 Feb 2020 21:14:39 -0800 (PST)
From:   Yadu Kishore <kyk.segfault@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Yadu Kishore <kyk.segfault@gmail.com>
Subject: [PATCH] net: Make skb_segment not to compute checksum if network controller supports checksumming
Date:   Fri, 21 Feb 2020 10:43:59 +0530
Message-Id: <1582262039-25359-1-git-send-email-kyk.segfault@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <CA+FuTSeYGYr3Umij+Mezk9CUcaxYwqEe5sPSuXF8jPE2yMFJAw@mail.gmail.com>
References: <CA+FuTSeYGYr3Umij+Mezk9CUcaxYwqEe5sPSuXF8jPE2yMFJAw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Problem:
TCP checksum in the output path is not being offloaded during GSO
in the following case:
The network driver does not support scatter-gather but supports
checksum offload with NETIF_F_HW_CSUM.

Cause:
skb_segment calls skb_copy_and_csum_bits if the network driver
does not announce NETIF_F_SG. It does not check if the driver
supports NETIF_F_HW_CSUM.
So for devices which might want to offload checksum but do not support SG
there is currently no way to do so if GSO is enabled.

Solution:
In skb_segment check if the network controller does checksum and if so
call skb_copy_bits instead of skb_copy_and_csum_bits.

Testing:
Without the patch, ran iperf TCP traffic with NETIF_F_HW_CSUM enabled
in the network driver. Observed the TCP checksum offload is not happening
since the skbs received by the driver in the output path have
skb->ip_summed set to CHECKSUM_NONE.

With the patch ran iperf TCP traffic and observed that TCP checksum
is being offloaded with skb->ip_summed set to CHECKSUM_PARTIAL.
Also tested with the patch by disabling NETIF_F_HW_CSUM in the driver
to cover the newly introduced if-else code path in skb_segment.

In-Reply-To: CABGOaVTY6BrzJTYEtVXwawzP7-D8sb1KASDWFk15v0QFaJVbUg@mail.gmail.com
Signed-off-by: Yadu Kishore <kyk.segfault@gmail.com>
---
 net/core/skbuff.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1365a55..82a5b53 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3926,14 +3926,22 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 			goto perform_csum_check;
 
 		if (!sg) {
-			if (!nskb->remcsum_offload)
-				nskb->ip_summed = CHECKSUM_NONE;
-			SKB_GSO_CB(nskb)->csum =
-				skb_copy_and_csum_bits(head_skb, offset,
-						       skb_put(nskb, len),
-						       len, 0);
-			SKB_GSO_CB(nskb)->csum_start =
-				skb_headroom(nskb) + doffset;
+			if (!csum) {
+				if (!nskb->remcsum_offload)
+					nskb->ip_summed = CHECKSUM_NONE;
+				SKB_GSO_CB(nskb)->csum =
+					skb_copy_and_csum_bits(head_skb, offset,
+							       skb_put(nskb,
+								       len),
+							       len, 0);
+				SKB_GSO_CB(nskb)->csum_start =
+					skb_headroom(nskb) + doffset;
+			} else {
+				nskb->ip_summed = CHECKSUM_PARTIAL;
+				skb_copy_bits(head_skb, offset,
+					      skb_put(nskb, len),
+					      len);
+			}
 			continue;
 		}
 
-- 
2.7.4

