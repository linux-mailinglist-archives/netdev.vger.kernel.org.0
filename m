Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1057A42CC0
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502275AbfFLQw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:52:58 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:39905 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502240AbfFLQw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:52:58 -0400
Received: by mail-pg1-f202.google.com with SMTP id j26so11726461pgj.6
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 09:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TSw/qWbuAYqXM4yRcMVStwSild2BRpMTsNKUZSRYjdc=;
        b=hV+R3tViyKQOMKgMIqlREEFvszIrwUEwd+8e9r/WAb0AuuCLbMKklHjaizjukFoNaI
         D/nEBqnnwGPIppz/LRlxgi05ugCt9O14YlXTOt4oujHrFjDdcPkacCAzN9EuFQDHCF4l
         Ar/BFYtK1NL/qX9WqsNCXVHyySsJclojkCCcFEqiKwAXMM2FTf72RMVlsftzKilHJeTk
         oYhjG6Qcz25EhfAlWuDb/Li5kJl5wDolMQY7eAUBoC5ruzeSVvVD8cvGo5ONjE1j8CYt
         uxFn8RUuxHKc4dt+vMf6PtFt6ShKtFFF+nnFQsEgYuqa8YJMi+pf6br4abz0xzEzHsXm
         lZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TSw/qWbuAYqXM4yRcMVStwSild2BRpMTsNKUZSRYjdc=;
        b=m4lxLxmAuw+6+YoB1rrF25E6Z8uLTGML0vDX4SXsRWlwcQBdTZ3Bu3HHcS53+C4rtU
         7H7gqIqOaYcCs/bXJvv7NW3NtWokPlDHQsfsWmsU0qFlGEZ+kDug0Wp3IKMFbcW9azz0
         5rtyUgj8UkmB3MUU9gHf6B4vhNEzCtP42F7XeZ/xhrv9gxLwzQjeeKLDgK2knGw1vwnY
         2MQLFJmIXLQSLP9PBTHeogTf1yFe+fyhWgAkNtovrfDTEKMkWYFc8o+pwVgbTTwpd0g6
         rEisQVGNS2tQ3ZlP6rf5qov5MEtsqkLskJsCbgFpuYtaMFZvG9ZNFgN5HmlsCtvO7t0r
         /ruw==
X-Gm-Message-State: APjAAAW1UYM0dFtnuFYCo0lcwg+ltjkaTQ++Zm2Gf1Dc7lwKtiw0iAKK
        6R6aS3ikSFprIjr6QrhKbCfoC2hDW22P5g==
X-Google-Smtp-Source: APXvYqz+j8SnOL0+0X1c/he+Yb0Nk77gePpIYnld/AJ3y0WsmDkZ361zZGlbzxZVCerTCdpM20rrLvv1eQ14bg==
X-Received: by 2002:a63:a41:: with SMTP id z1mr25488345pgk.389.1560358377302;
 Wed, 12 Jun 2019 09:52:57 -0700 (PDT)
Date:   Wed, 12 Jun 2019 09:52:31 -0700
In-Reply-To: <20190612165233.109749-1-edumazet@google.com>
Message-Id: <20190612165233.109749-7-edumazet@google.com>
Mime-Version: 1.0
References: <20190612165233.109749-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH net-next 6/8] net/packet: implement shortcut in tpacket_rcv()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tpacket_rcv() can be hit under DDOS quite hard, since
it will always grab a socket spinlock, to eventually find
there is no room for an additional packet.

Using tcpdump [1] on a busy host can lead to catastrophic consequences,
because of all cpus spinning on a contended spinlock.

This replicates a similar strategy used in packet_rcv()

[1] Also some applications mistakenly use af_packet socket
bound to ETH_P_ALL only to send packets.
Receive queue is never drained and immediately full.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 2d499679811af53886ce0c8a1cdd74cd73107eac..860ca3e6abf5198214612e9acc095530b61dac40 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2193,6 +2193,12 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (!res)
 		goto drop_n_restore;
 
+	/* If we are flooded, just give up */
+	if (__packet_rcv_has_room(po, skb) == ROOM_NONE) {
+		atomic_inc(&po->tp_drops);
+		goto drop_n_restore;
+	}
+
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
 		status |= TP_STATUS_CSUMNOTREADY;
 	else if (skb->pkt_type != PACKET_OUTGOING &&
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

