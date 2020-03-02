Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1A1117541F
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 07:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgCBGwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 01:52:17 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40849 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgCBGwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 01:52:16 -0500
Received: by mail-ed1-f66.google.com with SMTP id p3so11989158edx.7
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 22:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AdMBMcrHKSAalb6N+QcQaNkVD36wFgT4t7EzXTDrsz8=;
        b=p8NC1COlkQUtJ73ITS2IFhhd8wBAdDQvbD36MMXCb4omXIeDMOfNKY/H80RTuX3z3l
         yVIzUBRrMy+t6BCrviduog/LCcno+qQnOs5v18DwGZj0aC3UC0lN9a+Ti1CZUSAGzTTZ
         sWDwI9WyhMWElt8gY9gewPYsUTOHHJI06NhLFw4ZlpV3vST50XFfDjhOp4dIb2zvND6p
         1yj1vsXlz2Hc63KCW3HDN7y1eRfOqumE3NmvhjVhlhCvKFWnEZ+1m9RZ9TvIClJh4Ac1
         Zqd6KJTvWyQiPHwR0UX2rdH5RbuOylVMf3wWTcK6O7tpGZNV2vxP8GobP2UbsLsdJJn9
         XPZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AdMBMcrHKSAalb6N+QcQaNkVD36wFgT4t7EzXTDrsz8=;
        b=e4M3kXV0nVmRXIY32vh9rYQPPB1HhwhK4AnjcQXj82wHHYjtLdYsk9+SetbvwcmU88
         g5mP3wxYSqvoovtOJ9tSmd8ieZq6AnMep4jlMm0Qz2CoZpEUau0iQTJOiTFc4te7BIUn
         cLCqIY1MEqlTL+/0eIfn64OKH239jH+XCjcw7BTGq8KFWTNFSF4AQK+Qt5AT+uFwdY5y
         6O4l4crja6+TUHLE4dndfI4JdkQHYG/NDb/OUn59xyZbw/BABiz8Few3Ofe6lAJygJ7r
         Pg1lEwL7hW0/PNlbl+WkxxDBb6Jn3OXPSEC77qyTQ2nXe425h5rP4W99vhI75GaZ/KFJ
         V/UQ==
X-Gm-Message-State: ANhLgQ1T80U7jfk57uW/6PaiC226rXPNGPFImNFj2MWoBvjt9a6hFa4n
        pD7BqvqwVuuB4nKsUfRYerQJ0/6rq3E=
X-Google-Smtp-Source: ADFU+vv9MsqnikYcxXYGQW1kCfaHOaAwFcEkebawqMy5BbwQ/cpTe3roBLO0jzCZQUrY+IPV1bFM2g==
X-Received: by 2002:a17:906:eb83:: with SMTP id mh3mr1901100ejb.18.1583131934473;
        Sun, 01 Mar 2020 22:52:14 -0800 (PST)
Received: from blr-ykodiche02.dhcp.broadcom.net ([192.19.234.250])
        by smtp.googlemail.com with ESMTPSA id m7sm1046344edq.37.2020.03.01.22.52.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 01 Mar 2020 22:52:13 -0800 (PST)
From:   Yadu Kishore <kyk.segfault@gmail.com>
To:     davem@davemloft.net
Cc:     willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        Yadu Kishore <kyk.segfault@gmail.com>
Subject: [PATCH v2] net: Make skb_segment not to compute checksum if network controller supports checksumming
Date:   Mon,  2 Mar 2020 12:21:50 +0530
Message-Id: <1583131910-29260-1-git-send-email-kyk.segfault@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20200228.120150.302053489768447737.davem@davemloft.net>
References: <20200228.120150.302053489768447737.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Can you contrast this against a run with your changes? The thought is
> > that the majority of this cost is due to the memory loads and stores, not
> > the arithmetic ops to compute the checksum. When enabling checksum
> > offload, the same stalls will occur, but will simply be attributed to
> > memcpy instead of to do_csum.

> Agreed.

Below is the data from perf with and without the patch for the same
TCP Tx iperf run: (network driver has NETIF_F_HW_CSUM enabled)

Without patch :-
============
[Function = %cpu cycles]
skb_mac_gso_segment = 0.05
inet_gso_segment = 0.26
tcp4_gso_segment = 0.05
tcp_gso_segment = 0.17
skb_segment = 0.55
skb_copy_and_csum_bits = 0.60
do_csum = 7.43
memcpy = 3.81
__alloc_skb = 0.93
==================
SUM = 13.85


With patch :-
============
[Function = %cpu cycles]
skb_mac_gso_segment = 0.05
inet_gso_segment = 0.34
tcp4_gso_segment = 0.06
tcp_gso_segment = 0.26
skb_segment = 0.55
skb_copy_and_csum_bits = 0.00
do_csum = 0.04
memcpy = 4.29
__alloc_skb = 0.73
==================
SUM = 6.32

So, with the patch, from the above data we can see
that the percentage of cpu cycles spent in do_csum
has come down from 7.43% to 0.04%.

> > > Is this not already handled by __copy_skb_header above? If ip_summed
> > > has to be initialized, so have csum_start and csum_offset. That call
> > > should have initialized all three.

> > Thanks, I will look into why even though __copy_skb_header is being
> > called, I am still
> > seeing skb->ip_summed set to CHECKSUM_NONE in the network driver.

> Thanks.

My mistake. I had removed the 'skb->ip_summed = CHECKSUM_PARTIAL' line
from the patch but had forgotten to enable NETIF_F_HW_CSUM in the network
driver. Hence I was still seeing skb->ip_summed set to CHECKSUM_NONE.
After re-enabling NETIF_F_HW_CSUM in the driver, I now see that
skb->ip_summed is being set correctly to CHECKSUM_PARTIAL.
So as suggested, the __copy_skb_header is indeed taking care of doing
this and hence there is no need to explicitly set 'ip_summed' in the patch.
Below is V2 of the patch with the changes.


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

Link: https://lore.kernel.org/netdev/CA+FuTSeYGYr3Umij+Mezk9CUcaxYwqEe5sPSuXF8jPE2yMFJAw@mail.gmail.com
Signed-off-by: Yadu Kishore <kyk.segfault@gmail.com>
---
 net/core/skbuff.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1365a55..eca72bc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3926,14 +3926,21 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
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
+				skb_copy_bits(head_skb, offset,
+					      skb_put(nskb, len),
+					      len);
+			}
 			continue;
 		}
 
-- 
2.7.4

