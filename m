Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEEB3124638
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfLRLyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:54:10 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39240 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfLRLyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:54:09 -0500
Received: by mail-pg1-f196.google.com with SMTP id b137so1156094pga.6
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+rHj5u3iMCCxJRY2ucHo6msf9NxCYuFCALQA7T/CkCg=;
        b=ZvyIrqblWXWx61afEjzZF8ODKbhdlcrxzY86JOibzhFH8en4Wm6KITby3ypWOYPkoT
         /Fu8dCiXmRqriMk+8eIQPs1jvcpUs6cs4Xroibt+tIIXjEKG3m8L1HAatAacbaXD2iQu
         Ou9Hq+Nqb5JegUc+UFLt8H6EedbADcHyl+AW0O+e9msZATJzsmzeZNH4k01ABetLtfy/
         BknmdGXON8+uLHPY8i0SWvmlPlet6NMkyD2QufOanmPvDeLAh2UsRhL1E3plpjYUMCUm
         EFtT1TDz0Z+uyZ/5+Kp7iHVuOs7cDo0bS4hBuCS0Ys4QSyBtQKrlGny/YEiKTyjC5l6x
         wh3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+rHj5u3iMCCxJRY2ucHo6msf9NxCYuFCALQA7T/CkCg=;
        b=CPv5vvmtbStCitjyetkMsOzGDTtXVgMm+V9/IwpZ3ugpH/oJv6lspT9YZDUT04sA3R
         ZgdRhyjsPPiqdR6wcnFnkIUFbnEPJnkDAWJqYJfyCK9Xjz2YUpFKmkjXwL7ThJefpPsN
         RL5t7dHnw8lUT/tl1yRK5d2HCWFsZMXQbFGnZgMXKZEQHYKSPc8rRHY2rppBfiZpMeOl
         uZew975lmfF30ZhYf9Bcfw7LJ/KbcdY8EZXvGYjlNdaBc7BQJf0bd5ZA1iwr+aL0K88j
         OjLDU1c++vrpuAobbm4aViALasN2TVKMh4rdkjOUCHYBlg6KYSijsX6BkdWgQ0u0tp/0
         aAIA==
X-Gm-Message-State: APjAAAU37U5N0tt9i0N9ZuJzRtKgv15PgdenCaLS6yCmXRDJa7Sn1Owf
        mR8RIUGX36dXEM1XwyW0dK9pBi6uz8E=
X-Google-Smtp-Source: APXvYqz0Lfbaadb4AlKpcUgtzW3su+7nObK4896gG9tKUaR2BeVqYn9n1DkSm+qrzPuA3o7jLhxHbQ==
X-Received: by 2002:aa7:8ad9:: with SMTP id b25mr2589443pfd.70.1576670049050;
        Wed, 18 Dec 2019 03:54:09 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x33sm2961067pga.86.2019.12.18.03.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:54:08 -0800 (PST)
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
Subject: [PATCH net-next 7/8] sit: do not confirm neighbor when do pmtu update
Date:   Wed, 18 Dec 2019 19:53:12 +0800
Message-Id: <20191218115313.19352-8-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191218115313.19352-1-liuhangbin@gmail.com>
References: <20191203021137.26809-1-liuhangbin@gmail.com>
 <20191218115313.19352-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When do IPv6 tunnel PMTU update and calls __ip6_rt_update_pmtu() in the end,
we should not call dst_confirm_neigh() as there is no two-way communication.

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

