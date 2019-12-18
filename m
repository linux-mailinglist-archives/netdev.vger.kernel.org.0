Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFD5E124637
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfLRLyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:54:06 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46763 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfLRLyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:54:05 -0500
Received: by mail-pf1-f195.google.com with SMTP id y14so1063729pfm.13
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R+7EVsXGkDvkBgcesT7DXdsTGOKp1DInf6xnwnn+Hkw=;
        b=t/OHf/1yK96OWqX0P1MmyMZRUyWe2k17X1IlA83d3VX8RnQlkSd1jD0C9ZDABW1FDl
         SE8UNN5tV/WWIqUDUFwV3wkK/PkWFowQAg4Cuudpicywumcn0p79sWw4dwa3iK2+h8SE
         OR0qg9jVi0SDehcYSzCehW6eF2HOGYmMm3SfHat93ODG7EInSCCTFdMq3KFzHDdTlxNV
         apZ8vYQS8kPDcWPRJHfhq1yvDJC1B5iFPF1ifrW8F5RUO92+8ApQsYeOwcEQz083sirI
         Gn44hTMyJRZd+s74KjPw1XTzyZ3CykKOyiZYZXJYWbDUlpLAyNiQRtG1xPST/elfUgvk
         ju4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R+7EVsXGkDvkBgcesT7DXdsTGOKp1DInf6xnwnn+Hkw=;
        b=bRGFL/m+2mKzdt7CF1HgmDXD7y1FN0AIL4jK12M3//rTfZOCAIJIuzGdi+o/XK5Mq7
         x7T1P9vGQS2UZwda9iWaxlY1X7tC/D8llt3/u0HT5Qz+EBZDAI+EGaI+eL+PqT6Pyyim
         4Elv0suLE3trhXuirL0qCDgcrPLgowcB9BSrywvC/IYWA+GQ1uj/zdnoR0CpXOf17VVx
         hDwVQeZkbJ0aai8kK0klj331Hc20Rq3b3DfenvfTrZq9AuXX/s45exVkX0LNobTrbtCK
         T+XILmZ88qj216SMgYE9WUyutmPO6UsK+4ardFBsZC9J9m6uOANYUAJKIkc9edFCHnzM
         Ek5w==
X-Gm-Message-State: APjAAAXVcyrtObZ/vRZwBgrO9wtL4HELDSvO6DX4BhphtnxWk6JYqmUE
        xyfF6xy2lePyvsuvlfXyMqoZ66Ts/QQ=
X-Google-Smtp-Source: APXvYqzg32dGTZ8FuIA1arYy2As9slUyd6WqgF6jQaSINt/f/P/tv4584uEdmVaxmxeeEIHZo3/+Qw==
X-Received: by 2002:a63:d153:: with SMTP id c19mr2588843pgj.78.1576670044923;
        Wed, 18 Dec 2019 03:54:04 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x33sm2961067pga.86.2019.12.18.03.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:54:04 -0800 (PST)
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
Subject: [PATCH net-next 6/8] vti: do not confirm neighbor when do pmtu update
Date:   Wed, 18 Dec 2019 19:53:11 +0800
Message-Id: <20191218115313.19352-7-liuhangbin@gmail.com>
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

Although ip vti is not affected as __ip_rt_update_pmtu() does not call
dst_confirm_neigh(), we still not do neigh confirm to keep consistency with
IPv6 code.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv4/ip_vti.c  | 2 +-
 net/ipv6/ip6_vti.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index cfb025606793..fb9f6d60c27c 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -214,7 +214,7 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 
 	mtu = dst_mtu(dst);
 	if (skb->len > mtu) {
-		skb_dst_update_pmtu(skb, mtu);
+		skb_dst_update_pmtu_no_confirm(skb, mtu);
 		if (skb->protocol == htons(ETH_P_IP)) {
 			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 				  htonl(mtu));
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 024db17386d2..6f08b760c2a7 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -479,7 +479,7 @@ vti6_xmit(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 
 	mtu = dst_mtu(dst);
 	if (skb->len > mtu) {
-		skb_dst_update_pmtu(skb, mtu);
+		skb_dst_update_pmtu_no_confirm(skb, mtu);
 
 		if (skb->protocol == htons(ETH_P_IPV6)) {
 			if (mtu < IPV6_MIN_MTU)
-- 
2.19.2

