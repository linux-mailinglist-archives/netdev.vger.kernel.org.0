Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACBE1273DB
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 04:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfLTD0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 22:26:09 -0500
Received: from mail-pf1-f180.google.com ([209.85.210.180]:44271 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbfLTD0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 22:26:07 -0500
Received: by mail-pf1-f180.google.com with SMTP id 195so3555203pfw.11
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 19:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QVt2qCPylLD1WkYogBAO9wgvwq/sv1ZXHX2D+EGpfCE=;
        b=IGd5P7Nw07LYQxW5zPam+EUiCe/QtOWKyUaNV3qmNASsb3C/GmU0zxvcwqgHdV6s31
         lCKnD7BfadYYQIWt82f7SZWK0pI87ZksUOPDatjbQVDMg/BIGrVZuzf5Ejtbw9fI4dtd
         SJndHHgycQPTz6Y/LkGvzMhKEUqC0QQwz77z7iBKcQYx4bbdBK02RR0OjYujutAOv3re
         8hbx1JPKWFlusoPR4vmOikwO4PBVrKoJ4bWessr/5Cl2LMlWhmd4Y2Xkhlj09BCKn/o1
         o/yyrFnPhQsCrhdvbRfVqZH+RQnK4fkNlA1cTPV4wxIO4cJstLhB0KdZ8ow0IS0X+oFc
         1KhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QVt2qCPylLD1WkYogBAO9wgvwq/sv1ZXHX2D+EGpfCE=;
        b=EPy/Fq7lvPlUdTTFOlSYJWW7bkZX/KXQ05lqpAXx6Hj+67HTT2ot1WW0UvLD8pwN6J
         QQoY/2ne8f+HVvTpW4FqMS9h0V47oli/ndQUjHWnWgawYx+m0NUT4TC1EsCfx+5st+r1
         TgAxSxa0nJXwSNUmGwiEOPuWKiEhJYiUlHRiDkBxrUaTA7VlecY3Kc0cAjOuuwCGtY60
         aP/ieamWpird78vmGu5GTuB6SdmldN+oLSupUiYTAZqdsowBEGqMv+9L5j0IZfZAzJ4o
         NhS0uadDOPLhoc8uvHfuKkt47Q+/cw6LPmxk8RDaL/XscfURAK3JSEjY9Bt3ArdbPWv0
         +UqQ==
X-Gm-Message-State: APjAAAVRDRMRH3flYTwmsJrA26jAabA2C7BTbxiu+ru0PXA7uT5H8bxe
        uMv650Iso71pZyfpSXi5TPx58Y8i/Rk=
X-Google-Smtp-Source: APXvYqy1TM7okNdoRhOcaDdetr/tHVxobUUvCMRsPs4VTJRVJ3q7ja3uAlq1SPzx+GsgPiVogek6Iw==
X-Received: by 2002:aa7:9205:: with SMTP id 5mr13773537pfo.213.1576812366793;
        Thu, 19 Dec 2019 19:26:06 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gc1sm7954265pjb.20.2019.12.19.19.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 19:26:06 -0800 (PST)
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
Subject: [PATCHv4 net 6/8] vti: do not confirm neighbor when do pmtu update
Date:   Fri, 20 Dec 2019 11:25:23 +0800
Message-Id: <20191220032525.26909-7-liuhangbin@gmail.com>
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

Although ip vti is not affected as __ip_rt_update_pmtu() does not call
dst_confirm_neigh(), we still not do neigh confirm to keep consistency with
IPv6 code.

v4: No change.
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

Reviewed-by: Guillaume Nault <gnault@redhat.com>
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

