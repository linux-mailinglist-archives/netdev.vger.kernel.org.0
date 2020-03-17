Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41475187B62
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 09:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbgCQIjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 04:39:08 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35750 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgCQIjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 04:39:08 -0400
Received: by mail-ed1-f66.google.com with SMTP id a20so25339606edj.2
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 01:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=m6/hC8Pp+eOftf8dj8fo6MPSPOhmi6p4lAeg6BS6dTE=;
        b=YkbchcCJN8DEJViuT9MGUSAu/zZ9kgGU5dLkh1ORYL6MmUWqx3chfBfk4/f0PkaEdT
         s5kK8Nbeo1Ha5pobNCi9VdPbMESQOAYClCm+T+q0+Fc3MNsDLwRlYL0j820OR1iNHt/P
         g+RQcXIoQ38HuM1tTuN+XDPRuNQ/nvOAU6aVgb8GAMEAyhRIiwDwuiXzV6l3DL/75X2R
         Dqbo+jFTz7S6CPZePlO/1pAsfeqrzf209+puL/hYdkawvnoMdTmtei+SkomSKGeXL42l
         fqcJsVJ5MQ/kBinP24Y341/xzQTlJGvC7C97VmtZe6PnK19UoXY9cmLCC1RUOxGJ3HPW
         ic8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=m6/hC8Pp+eOftf8dj8fo6MPSPOhmi6p4lAeg6BS6dTE=;
        b=n5qAcagdMNJdvpEhvi7xQdbWBrZybGp81cEoxz7HqYCQF4DqBRkGrVLLsLRQSBVhlT
         QTvoCK9FeDoiikulXzWO7Vg9BkwYR+wN90VnyXJcCquS6XGeZJTll+VRyzm+JLFzF57s
         Tuj9AzzQ3oi9TKi2gprM6rvbWYcQP6aMXE1KnCLCCJGhqPONjRmb4EfoBaMc34KnuGeU
         pNtiV5FPpjsxwBd0uj4htF0uXMzKgLepio1gtmwOLvtQ+Ao73K3i18cenxA4RxgyVj1J
         v7LgHWl90K+bsyldfGeaRyDrr9t2qdJbpaKeHkHMrM5sSMEYWiL0JnqnU6W+YjippCmg
         J1sw==
X-Gm-Message-State: ANhLgQ2HT1UVSVEZr8ztFQKJ/c+AxKoAvl3sdBImPA+lYSwYw43bvqn0
        PYTPB9BZoTseigQrvEFUzkXHI/Im+TM=
X-Google-Smtp-Source: ADFU+vtZ64ZXN5WGKpLl8fs52FK0nzPCbJLa08y9MMLgHSL1cF9uxSU24LGV3J9QhBz+4XU4aiZGPQ==
X-Received: by 2002:aa7:c544:: with SMTP id s4mr3901960edr.99.1584434346765;
        Tue, 17 Mar 2020 01:39:06 -0700 (PDT)
Received: from blr-ykodiche02.dhcp.broadcom.net ([192.19.234.250])
        by smtp.googlemail.com with ESMTPSA id j12sm146881edn.86.2020.03.17.01.39.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Mar 2020 01:39:05 -0700 (PDT)
From:   Yadu Kishore <kyk.segfault@gmail.com>
To:     davem@davemloft.net
Cc:     David.Laight@aculab.com, eric.dumazet@gmail.com,
        kyk.segfault@gmail.com, netdev@vger.kernel.org,
        willemdebruijn.kernel@gmail.com
Subject: [PATCH v3] net: Make skb_segment not to compute checksum if network controller supports checksumming
Date:   Tue, 17 Mar 2020 14:08:38 +0530
Message-Id: <1584434318-27980-1-git-send-email-kyk.segfault@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20200313.110542.570427563998639331.davem@davemloft.net>
References: <20200313.110542.570427563998639331.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> I think you can rebase and submit against net-next.

> If your patch isn't active in the networking development patchwork instance,
> it is not pending to be applied and you must resend it.

Rebasing the patch on net-next and resending it.

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
index e1101a4..621b447 100644
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

