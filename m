Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90C343D2BC
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239236AbhJ0UWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239211AbhJ0UV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:21:59 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61ECC061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:19:33 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id k26so3810939pfi.5
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p0edbO6SvxnfM0P4Jo1XWqLjXYzwPV2oty/MQVXgg1o=;
        b=BEAOTxiOj+0GocXmWoUDXi0oQeb2/FJR26XciRdKguvrWcrY94xclg/iXyrDt57OUE
         sRJegCujtzHKi9krLO7pYdcRl5nmXVs1STlR1wUo0vEMXD3Fb3Ursa1ZbjLfZPA+dLN+
         NbHz0iCaH/a8cFRmSgcP+WsZBX3PEnO5X7TMpM3EBm6LZ9H5rW5N9FNwQeWdB+F1kDje
         CGM3VmL3vC6WLwotzIzDh5jABSSfEtk/2Bx5KKh4bNM+L2/gG+mO6uPyerKOlVb3F7qS
         faY0G8u4oA+re8Qz4YOh3zmDAfHAOQWynGCM1YLZ1tOVO0b3fgsY1S1JgVbMwYQZLtrx
         5Ymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p0edbO6SvxnfM0P4Jo1XWqLjXYzwPV2oty/MQVXgg1o=;
        b=ZapNQHnhUo9hN04y5drdvoWFADwtmjwZdhtQ+RGTuDCP+vjQIXKCKwdjQtfZHPvhYC
         2YvTiZzFaj7HzcsEfFPdMgtu4KXrgHf3mHSeA6/iTZxLOgerMh+ns01JlrawjOaDKjKN
         DzwK2pTawlS1KMYY8pI3bNcQmQqgleCowQCgvRL3IWPCG+t8a05f8FuCQlf1OJvIBjxu
         iQWdzP2S8B75HDtfRHn5squmXZ5KHDRjymO2xRCr93rsOsXujd0b4vZmsio8hzxMVnDg
         YnpvK1UcH+CGLH6nbUQMFho1dzwtdGB/glOFb8i5RLpsbPBhjOh1zktRoJh2HRwkSkIT
         2P+A==
X-Gm-Message-State: AOAM530QCsq4W4mX8WsdZ7g4OLF7gT/nEW4DNzuh0ihYi0b5OObglMP8
        aaCjZ48kU/oP1oErfwlehMYx8OAOSjg=
X-Google-Smtp-Source: ABdhPJyA9SWVFEi/oDm5RYOjbb64dVPaCsi0irwRAHG4yVU3bwAgmRxFEWgRRLPkdlRa+6w5/8r4cg==
X-Received: by 2002:a05:6a00:1413:b0:47d:2415:a021 with SMTP id l19-20020a056a00141300b0047d2415a021mr38181pfu.43.1635365973481;
        Wed, 27 Oct 2021 13:19:33 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:19fb:5287:bbfe:fc2a])
        by smtp.gmail.com with ESMTPSA id fr12sm5338295pjb.36.2021.10.27.13.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 13:19:33 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 4/7] tcp: no longer set skb->reserved_tailroom
Date:   Wed, 27 Oct 2021 13:19:20 -0700
Message-Id: <20211027201923.4162520-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211027201923.4162520-1-eric.dumazet@gmail.com>
References: <20211027201923.4162520-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

TCP/MPTCP sendmsg() no longer puts payload in skb->head,
we can remove not needed code.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c       | 5 -----
 net/mptcp/protocol.c | 1 -
 2 files changed, 6 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 68b946cfd433720a034c2023a13c086428646c51..66ed0d79f41472f013edffe19802441e995175c9 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -876,11 +876,6 @@ struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
 		}
 		if (likely(mem_scheduled)) {
 			skb_reserve(skb, MAX_TCP_HEADER);
-			/*
-			 * Make sure that we have exactly size bytes
-			 * available to the caller, no more, no less.
-			 */
-			skb->reserved_tailroom = skb->end - skb->tail - size;
 			INIT_LIST_HEAD(&skb->tcp_tsorted_anchor);
 			return skb;
 		}
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index ccd62a2727c36a749455d122c106b4c5f76ef2ba..22c7d10db15f8321e988602b8c97a46ffd872298 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1218,7 +1218,6 @@ static struct sk_buff *__mptcp_do_alloc_tx_skb(struct sock *sk, gfp_t gfp)
 	if (likely(skb)) {
 		if (likely(__mptcp_add_ext(skb, gfp))) {
 			skb_reserve(skb, MAX_TCP_HEADER);
-			skb->reserved_tailroom = skb->end - skb->tail;
 			INIT_LIST_HEAD(&skb->tcp_tsorted_anchor);
 			return skb;
 		}
-- 
2.33.0.1079.g6e70778dc9-goog

