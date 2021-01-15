Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F08F2F743F
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 09:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732574AbhAOIWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 03:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbhAOIWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 03:22:18 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E311BC0613C1;
        Fri, 15 Jan 2021 00:21:37 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id i7so5544073pgc.8;
        Fri, 15 Jan 2021 00:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=KUsV1bM5sIVlTpPanw1WlNTCb4EgouPn3IG0lHd1U10=;
        b=Znrvfcwd859bNqV+w13Y22ZaRAbMaWObOP4zrYmIWA0Xce97UvI87ua8bJdn0hpgeV
         VL9Me5dkYHH1BRw8pusf34bABLKR7/D/X7QkHN8MDM7edvXqqfWHIa/zy0mLiIZCrcCe
         uBcBbHqBhjrz2Xj/escsHWCobl3PyCgpeC/NccRMfvphIOnWbK/FWJifn1MYvnRduYrN
         6M3dGgrLS4jBJeF5k+oHb0bc9QEMrGiZe+wD2Rui64qg4/m4XKTD3MIOpwU5A3yRfVwp
         ybc65INq8aJTC2lRzhrnaOgMqusV3PPUMhSbpxJ0wRsmqAvv8TwY+UbFdLFnw59zxBSa
         238A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=KUsV1bM5sIVlTpPanw1WlNTCb4EgouPn3IG0lHd1U10=;
        b=Z5+9/naUxACG7+1x4KQHzEeXEKaboo0lBQAv/oqWLcknLZYkLdX637qcmPYRPgRI/2
         r4yBQvWinJGCBVIvv0K0do5YnEVHtGZrFbIg/IUKfgqwcPnw5BX4216qp5VwxrVAuA96
         C8DOvdwrdyPWYlXf/+DPz/rBvbvZ2bVXRTlJdVrc7gSYVY0+n1SF+tk1WUaUC4cQK6YQ
         W40QF4nnEwKF4Vof+lr8Bhyp6Anqt96/4NHyiENySSoIziTJGEfVNc6KFQCfDHwxBrdx
         mw8AwAynSBYM98jkC91orJuR4p8rYpx07RTehQgx01WaxYrrXazJ8ywjAQJg1DO9O4Lt
         BAlA==
X-Gm-Message-State: AOAM531rDDnEJtU8Kk5PcR1VRH5p33bhviA3Tl+PNKzLALhTZ/2WRrbw
        BqgUlNV7bwRl2LxTU2U6/aB+JraJNqZNPQ==
X-Google-Smtp-Source: ABdhPJzIMfjSOn1hpGTWvYZGEnAsCBBwR9uOOZHRqVMjw0AZDIlGlvjtdxd2gclMGSBHN5wmQS9JCw==
X-Received: by 2002:a63:db08:: with SMTP id e8mr5989709pgg.261.1610698897237;
        Fri, 15 Jan 2021 00:21:37 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x28sm7189523pff.182.2021.01.15.00.21.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 00:21:36 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCHv2 net-next 2/2] udp: remove CRC flag from dev features in __skb_udp_tunnel_segment
Date:   Fri, 15 Jan 2021 16:21:12 +0800
Message-Id: <fb2283b264aac66379356ec7a1f17243f02504a1.1610698811.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <bfecc76748f5dc64eaddf501c258dca9efb92bdf.1610698811.git.lucien.xin@gmail.com>
References: <cover.1610698811.git.lucien.xin@gmail.com>
 <bfecc76748f5dc64eaddf501c258dca9efb92bdf.1610698811.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610698811.git.lucien.xin@gmail.com>
References: <cover.1610698811.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/udp_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index ff39e94..1168d18 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -68,8 +68,8 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 				      (NETIF_F_HW_CSUM | NETIF_F_IP_CSUM))));
 
 	features &= skb->dev->hw_enc_features;
-	/* CRC checksum can't be handled by HW when it's a UDP tunneling packet. */
-	features &= ~NETIF_F_SCTP_CRC;
+	if (need_csum)
+		features &= ~NETIF_F_SCTP_CRC;
 
 	/* The only checksum offload we care about from here on out is the
 	 * outer one so strip the existing checksum feature flags and
-- 
2.1.0

