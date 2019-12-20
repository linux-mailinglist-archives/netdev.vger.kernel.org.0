Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 191271273DC
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 04:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbfLTD0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 22:26:12 -0500
Received: from mail-pf1-f181.google.com ([209.85.210.181]:38341 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbfLTD0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 22:26:11 -0500
Received: by mail-pf1-f181.google.com with SMTP id x185so4432087pfc.5
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 19:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cm7bXKD9o1sCx3jg8KwtBaYlyUHT3VMT3GrRMVAKWDc=;
        b=k5OgFaZg431siSSXv4zAqkQLmRu+zk+NA+xmpBVtGkOEpw3XQ81MstZlMYCtaT2iDF
         GpQ7yDK2CroA8xLcEeDqNF5T6hSY3AohGolhcjmx1JL+s7Py8mq0mNYn8xdbq8KOWsqo
         jeaC4X0W2vWBUZXU6/g0Ci/oeNVPBZC722XODkTqWK4mtiq66p/TMll0Mw1t9Jhfl1Nc
         9Ln0/xjqr0AU2n4zQ2PrLNJw74n138LE+uNJyvF2ERwUXdNSB3Ht9y1TomzlDicoKWxK
         t1zVs3fNPv6siSnjoPTGUu4pxAPthUMC4uMKJpDLU6/6UFQ8sRpDK2Agn6JIjfS2QZXw
         Xt5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cm7bXKD9o1sCx3jg8KwtBaYlyUHT3VMT3GrRMVAKWDc=;
        b=CUwcJvmUVRaLTl+Rtb4ohgNDwEx5zFn/UKwK4cQbX2Q+0oDTyKtQLVeeWQ3tJ0rGUL
         VXkT0dvbZrNvQCWG7W9TA8pnZmBr1CXKjPVDjwEIu7+9XEZlbtedaI16hdka21pTA+7z
         xJa6XnUqdtt7FaQm+ZHH9kS56w4JHTW9nfBeWDszmfp6z2kz2rERrmkS6JbPHx5tcYHC
         RiEfjlQebKCwFFUgUwhsczo2Ty/nAPYSacMNh7GCNdqQI88V708N2uWh0SrZKHzCoBzD
         zwWeCiXEdE8CbuOYtfVLvMZEnlGAPK0w+VGHESlxtgwF9X9BiQFyUGzJCPuPNhzOPKqQ
         eVBw==
X-Gm-Message-State: APjAAAV4f7KZ538VcmGsD7EPRjVQIfcwxllPNCpiknwFB9hMbYqmIEU7
        zk4FjIA9wgO4vyVsHOSCqLFpU0hPjro=
X-Google-Smtp-Source: APXvYqzDiphbDbZvd0mi0RYWzZbSrLrzH9Ifv/W8Przy1NSKw2HABEgbMZmWoTuFrx6UtkhxeKg+wQ==
X-Received: by 2002:a62:7681:: with SMTP id r123mr13476188pfc.169.1576812370806;
        Thu, 19 Dec 2019 19:26:10 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gc1sm7954265pjb.20.2019.12.19.19.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 19:26:10 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Pablo Neira <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv4 net 7/8] sit: do not confirm neighbor when do pmtu update
Date:   Fri, 20 Dec 2019 11:25:24 +0800
Message-Id: <20191220032525.26909-8-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191220032525.26909-1-liuhangbin@gmail.com>
References: <20191218115313.19352-1-liuhangbin@gmail.com>
 <20191220032525.26909-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When do IPv6 tunnel PMTU update and calls __ip6_rt_update_pmtu() in the end,
we should not call dst_confirm_neigh() as there is no two-way communication.

v4: No change.
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/sit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index b2ccbc473127..98954830c40b 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -944,7 +944,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 		}
 
 		if (tunnel->parms.iph.daddr)
-			skb_dst_update_pmtu(skb, mtu);
+			skb_dst_update_pmtu_no_confirm(skb, mtu);
 
 		if (skb->len > mtu && !skb_is_gso(skb)) {
 			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
-- 
2.19.2

