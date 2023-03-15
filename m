Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52146BB3BD
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbjCOM4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbjCOM4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:56:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5222211655
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 05:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678884954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=JaBgEDKfqWmVcH7ueaHiA2NEn4sgat0tMV862oPXgr4=;
        b=Iw4FYWWyUweuveIjmyV7BhU3HmCyG7I9Pr8o+X5wfKnCm+HBMEQ60Yh5lIR2aVUv6i6JB9
        ajf1VST82QDNrITlrDE+nHTAq5A/z6EKcsLL6xcRWCFUKIAXDG9OzlAYizV0hCmMfdJqHf
        1PoiC6t4yFJvkk3TWL2c0O2pCScfOd4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-eaW8nbLHM-SUABsQohllMQ-1; Wed, 15 Mar 2023 08:55:53 -0400
X-MC-Unique: eaW8nbLHM-SUABsQohllMQ-1
Received: by mail-ed1-f71.google.com with SMTP id r19-20020a50aad3000000b005002e950cd3so793914edc.11
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 05:55:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678884952;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JaBgEDKfqWmVcH7ueaHiA2NEn4sgat0tMV862oPXgr4=;
        b=U+lWug3NB4cJUdXuHFYaJoIfXxT2Jey+FLKiHd8qLF/dOsR04VVYGCXiFicerbNGL5
         ia7ilHvtBEsvJF9cMj9hDvQcXfvlb5HkURKbXVKb3CdgzkZrqcMMS3JnJwkh3gWlOuyz
         evNaJjZ/iC76NrtY1KuruunZD7ElmWq8tmDShVexxUfzvmCzl8KoQPIyI3ZcnKjs1hjI
         YVjRlQb7irbl7qzfFcjN2UwZ3JL6S6KJdVl9YOlfjwNXFY0wOdj86A2ZBuosyxbdsark
         i07afD0Tqd7AWm97h/nhiDR0ilZsR0GBt5Rb+o2raMotZvJoXoWFiyYrNscncaoRTwSy
         ovRQ==
X-Gm-Message-State: AO0yUKVubGxMNVglxWYV0BNqW9Cvt1gSyNe3HlksJ2r9onD0E2LnHNXe
        v1N0FRKDOlmlDFUcWKD5Qay8PaCnfjNcQGR4nRj6wxahjmLfaugOFZyRNT26due+PZ//f06FAlK
        GO4TTNsH0WcU3U3I+
X-Received: by 2002:a17:906:5619:b0:879:ec1a:4ac with SMTP id f25-20020a170906561900b00879ec1a04acmr5309060ejq.76.1678884951903;
        Wed, 15 Mar 2023 05:55:51 -0700 (PDT)
X-Google-Smtp-Source: AK7set92+fL8QpbWwG+iI45Vn0TA6DxsDamjpdhTlTEPG3PQ6xgwPGl4kxnIJbzVvn7UQ+LQTs+EeQ==
X-Received: by 2002:a17:906:5619:b0:879:ec1a:4ac with SMTP id f25-20020a170906561900b00879ec1a04acmr5309031ejq.76.1678884951493;
        Wed, 15 Mar 2023 05:55:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id qa17-20020a170907869100b008cecb8f374asm2498501ejc.0.2023.03.15.05.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 05:55:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 355E69E2E8C; Wed, 15 Mar 2023 13:55:50 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Igor Russkikh <irusskikh@marvell.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Freysteinn Alfredsson <Freysteinn.Alfredsson@kau.se>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH net] net: atlantic: Fix crash when XDP is enabled but no program is loaded
Date:   Wed, 15 Mar 2023 13:55:38 +0100
Message-Id: <20230315125539.103319-1-toke@redhat.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The aq_xdp_run_prog() function falls back to the XDP_ABORTED action
handler (using a goto) if the operations for any of the other actions fail.
The XDP_ABORTED handler in turn calls the bpf_warn_invalid_xdp_action()
tracepoint. However, the function also jumps into the XDP_PASS helper if no
XDP program is loaded on the device, which means the XDP_ABORTED handler
can be run with a NULL program pointer. This results in a NULL pointer
deref because the tracepoint dereferences the 'prog' pointer passed to it.

This situation can happen in multiple ways:
- If a packet arrives between the removal of the program from the interface
  and the static_branch_dec() in aq_xdp_setup()
- If there are multiple devices using the same driver in the system and
  one of them has an XDP program loaded and the other does not.

Fix this by refactoring the aq_xdp_run_prog() function to remove the 'goto
pass' handling if there is no XDP program loaded. Instead, factor out the
skb building in a separate small helper function.

Fixes: 26efaef759a1 ("net: atlantic: Implement xdp data plane")
Reported-by: Freysteinn Alfredsson <Freysteinn.Alfredsson@kau.se>
Tested-by: Freysteinn Alfredsson <Freysteinn.Alfredsson@kau.se>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 28 ++++++++++++++-----
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 1e8d902e1c8e..7f933175cbda 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -412,6 +412,25 @@ int aq_xdp_xmit(struct net_device *dev, int num_frames,
 	return num_frames - drop;
 }
 
+static struct sk_buff *aq_xdp_build_skb(struct xdp_buff *xdp,
+					struct net_device *dev,
+					struct aq_ring_buff_s *buff)
+{
+	struct xdp_frame *xdpf;
+	struct sk_buff *skb;
+
+	xdpf = xdp_convert_buff_to_frame(xdp);
+	if (unlikely(!xdpf))
+		return NULL;
+
+	skb = xdp_build_skb_from_frame(xdpf, dev);
+	if (!skb)
+		return NULL;
+
+	aq_get_rxpages_xdp(buff, xdp);
+	return skb;
+}
+
 static struct sk_buff *aq_xdp_run_prog(struct aq_nic_s *aq_nic,
 				       struct xdp_buff *xdp,
 				       struct aq_ring_s *rx_ring,
@@ -431,7 +450,7 @@ static struct sk_buff *aq_xdp_run_prog(struct aq_nic_s *aq_nic,
 
 	prog = READ_ONCE(rx_ring->xdp_prog);
 	if (!prog)
-		goto pass;
+		return aq_xdp_build_skb(xdp, aq_nic->ndev, buff);
 
 	prefetchw(xdp->data_hard_start); /* xdp_frame write */
 
@@ -442,17 +461,12 @@ static struct sk_buff *aq_xdp_run_prog(struct aq_nic_s *aq_nic,
 	act = bpf_prog_run_xdp(prog, xdp);
 	switch (act) {
 	case XDP_PASS:
-pass:
-		xdpf = xdp_convert_buff_to_frame(xdp);
-		if (unlikely(!xdpf))
-			goto out_aborted;
-		skb = xdp_build_skb_from_frame(xdpf, aq_nic->ndev);
+		skb = aq_xdp_build_skb(xdp, aq_nic->ndev, buff);
 		if (!skb)
 			goto out_aborted;
 		u64_stats_update_begin(&rx_ring->stats.rx.syncp);
 		++rx_ring->stats.rx.xdp_pass;
 		u64_stats_update_end(&rx_ring->stats.rx.syncp);
-		aq_get_rxpages_xdp(buff, xdp);
 		return skb;
 	case XDP_TX:
 		xdpf = xdp_convert_buff_to_frame(xdp);
-- 
2.39.2

