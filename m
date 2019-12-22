Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 189FE128C63
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 03:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfLVCv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 21:51:58 -0500
Received: from mail-pj1-f42.google.com ([209.85.216.42]:53918 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbfLVCv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 21:51:58 -0500
Received: by mail-pj1-f42.google.com with SMTP id n96so5881971pjc.3
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 18:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GCHG/p5dITeJ3OwHwWKI6eVLWBJvBeHgqTMSLIekDwA=;
        b=k7Mt4nsjGCti5+B26zan5sptj8U6ACO/fB6M6BmTBEYSQtnVwsuA3+m3VVpdKxirI7
         cAH2xpegR3fiYedJ9oXqdb3TNnmrNs2uBj6R/sBl2SLBg/FHESMguFwOErMbzO/wc3Ux
         LfEN4y8XY9dntW4h/a1+gN1ZAsk2NW85UlwrFdFU1nWyrbVcnQZ8D56Cq3CZrNeCgP/a
         I2e8eM1dFX7laVL7CMNoBUdxxgJynWPpCeTlMc8gsOUXEnesgg9PRdNvFrc5M7BxI40c
         C0GLt4hnyjBYeCyewoFaxefaHCaW+Uic+i7vkP485hhk7BVXteHsAIgLIJzH/WCgu1wE
         G3wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GCHG/p5dITeJ3OwHwWKI6eVLWBJvBeHgqTMSLIekDwA=;
        b=Z4CRgAd2VB4RDqCqR2d4zJsWnIuzZYgrt/jiAZ3iriYTi5MF3sAwrilMkAgZcc7KU0
         4SZniG0p8OkHPN+E73k7foFxAHGjnT+NzgU5xOoUwmR6gTIFXvTeEgRnEMLceXTspBkq
         +u6zNSQMkOZARM0U/VuW8g1fruT3QRDYwxwyTo5Oijm5N886VsRQgUXiCH/0PL7VqDd6
         RKorN6DQlEcuLX9HxcUTineULGadQ9Cdp+Dsyi8zkhIB2yU5dvbsGvyGQZ7FSuTc9Bhf
         ryJLQN8g3u5DFpF4kiYV8e9/Pc7fK7upST1lsy042TlxDVTx0bPMpYGCCgvTQljgwzCH
         nBbw==
X-Gm-Message-State: APjAAAU+PNznfGn6kuJS41mM41rxsxKIT3wYPAdDLBzwVVzIuSiFfHdK
        Z7ydVX3ZuGHjjQC5IvGic8EI5kkgurE=
X-Google-Smtp-Source: APXvYqzNPgFXQf4sEf+53azxtVTKH/asAQkMFOtrYYuk42Ln6CyADnXdyFX9ta9aQb66BYtXQt+zFQ==
X-Received: by 2002:a17:902:d705:: with SMTP id w5mr14941880ply.68.1576983117237;
        Sat, 21 Dec 2019 18:51:57 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k9sm1866775pjo.19.2019.12.21.18.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 18:51:56 -0800 (PST)
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
Subject: [PATCHv5 net 6/8] vti: do not confirm neighbor when do pmtu update
Date:   Sun, 22 Dec 2019 10:51:14 +0800
Message-Id: <20191222025116.2897-7-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191222025116.2897-1-liuhangbin@gmail.com>
References: <20191220032525.26909-1-liuhangbin@gmail.com>
 <20191222025116.2897-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When do IPv6 tunnel PMTU update and calls __ip6_rt_update_pmtu() in the end,
we should not call dst_confirm_neigh() as there is no two-way communication.

Although vti and vti6 are immune to this problem because they are IFF_NOARP
interfaces, as Guillaume pointed. There is still no sense to confirm neighbour
here.

v5: Update commit description.
v4: No change.
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

Reviewed-by: Guillaume Nault <gnault@redhat.com>
Acked-by: David Ahern <dsahern@gmail.com>
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

