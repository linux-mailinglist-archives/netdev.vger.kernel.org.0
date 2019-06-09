Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B35B3A2AB
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 02:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfFIAsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 20:48:55 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42694 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfFIAsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 20:48:54 -0400
Received: by mail-qt1-f195.google.com with SMTP id s15so6704676qtk.9
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 17:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kIO9s0bYZPNRvBAfAzSeqipzJSaH+zznA7IlTzWzw+k=;
        b=KTzDGX364LwFWX1Sr06A3aPLr+iHS2RFwmc2vdnkoIXDq/65RnWvQ4NDWjyvPmGRl/
         z9JHgYk1vzyT8T0Igs+o2hPMxg6msFFYt9QbZQ0h9jhGYzx7PSTdcfC1e0P5gQfiv1BC
         /0y/La7FgRFhJe5eobtU+/vJkYmPaPs9zTT+xyb42xNkgsKrC+MihPB5gsh427YmX4ep
         /V2QtjKPtM+NVP9Ml3p5djT+niWKc2MZ/tHTp9e0W6LbhZxIfp5jK0ly2YoX/p+CLU6X
         WpTgMIaqfp+dbbwSTylgyp68K8O2FrNdr8SZlQ9T7xxCyUlmlxIIU0BkPNBDa4qvLSud
         wunQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kIO9s0bYZPNRvBAfAzSeqipzJSaH+zznA7IlTzWzw+k=;
        b=bOxwZBpxlb01T/mFUeVkg6yLep4MNU38MnR8nOht5+ikoGL40hN0EpfGQIqxCgz5nn
         bIlVoRQZNSRbm3vJ0/8jJmA+vxPJ5plUpgU0yYxcmeszhwrKaGjIVW0Tm1aA5medobTo
         p5egvlqMDRvRuPmSFnZYL7yk+DhvzzHZB5eZeQ3uAJnykUQSITqQdFJmL9KdSfYHxzw0
         MQLQlucvzXqqOvbwaJJZEBIG7eb4Mx3KREJTqi+ZVB0cgtP7qaYSSsVzD7NldyWhQVBy
         LNogyIstA9moEAKRI62GHGzU620Tkgz4KTNmx0K3y3PZcjg3dQs0G4sS76Vsp+THgRiR
         0DiQ==
X-Gm-Message-State: APjAAAUeUdaT3cjoSd63s7jOCzb1FTFyXfN8bwByleG0ESzaKnifFyBY
        RwXMzz5ePFXvFeLzNb7GHVe3zW/t2DI=
X-Google-Smtp-Source: APXvYqxrq9pvB54nIYUP0WtlO656WKlyHspe2AFcLRJ3/HI1M3M78qG4Gf7Aowlv3IuURPz8z/tKig==
X-Received: by 2002:a0c:d136:: with SMTP id a51mr9036764qvh.107.1560041333566;
        Sat, 08 Jun 2019 17:48:53 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f9sm3265347qtl.75.2019.06.08.17.48.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 17:48:52 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net] nfp: ensure skb network header is set for packet redirect
Date:   Sat,  8 Jun 2019 17:48:03 -0700
Message-Id: <20190609004803.9018-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hurley <john.hurley@netronome.com>

Packets received at the NFP driver may be redirected to egress of another
netdev (e.g. in the case of OvS internal ports). On the egress path, some
processes, like TC egress hooks, may expect the network header offset
field in the skb to be correctly set. If this is not the case there is
potential for abnormal behaviour and even the triggering of BUG() calls.

Set the skb network header field before the mac header pull when doing a
packet redirect.

Fixes: 27f54b582567 ("nfp: allow fallback packets from non-reprs")
Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index b82b684f52ce..36a3bd30cfd9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1867,6 +1867,7 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 			napi_gro_receive(&rx_ring->r_vec->napi, skb);
 		} else {
 			skb->dev = netdev;
+			skb_reset_network_header(skb);
 			__skb_push(skb, ETH_HLEN);
 			dev_queue_xmit(skb);
 		}
-- 
2.21.0

