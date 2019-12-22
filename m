Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF16128C64
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 03:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfLVCwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 21:52:02 -0500
Received: from mail-pg1-f173.google.com ([209.85.215.173]:39164 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbfLVCwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 21:52:02 -0500
Received: by mail-pg1-f173.google.com with SMTP id b137so6997808pga.6
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 18:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XwmNf0asSmJWs1qGKochv1L2Z4LXAsVWuhZlFKbu9ig=;
        b=szf7ebtEikl34qXR+UjO9v5hrB+PxH6fwsOSSuQrCuizZ7ZDLEjkrib99k6wUbZCD5
         RiVhhOGCQsYciv3qkr3W+tOy1VG7vr5nIIrqzx15tp6y1Ux6IT9neQntZ27RqmrF5G6I
         v0rZjHjJV0c/ovP6s6Pk43dZP83zd0w30LOMgjYmlnDUvT+rdDJrrTtG0rDvGgoTnQcV
         VM4esL/jT1iF21swOHduR5ieEsnzRxWKV4jGUYiXELj27jw3vVME9xa+wRexluHDubNh
         BKU1SsQ4gEDzS/d7Yche8KUwOod/ve2eeIVEbp634A4pkvKqiOsC4hguLUmzySEI0/eQ
         /OGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XwmNf0asSmJWs1qGKochv1L2Z4LXAsVWuhZlFKbu9ig=;
        b=ETMrnrfA46TR3UiD/RimHZzIaS8MLBHDPPEstij+b1BS9hcqVqe0yIT+qHK2JXDckS
         pH95+MXgOkrZo2bfSOb56617jelTanJGlheqfDOjQACj5fuTi+3vY4HHLqCbfTaIGWvv
         8LXKXXKbRYMAXjjbgqQG3z647pgzqRCMPT1cKiIRs4htBRO63Nlc3r/JlCGtL9m53UR7
         ffGjwoZHSwMJSlwwxlInDs1OQXISIrRruGjJVI6BXrb+A5SCs3hgnY1ig00TFEyUUgPY
         TaqsP1QUoQ4FbAr5YknIq/ks31Sheqds7MbWndZatot+b3zxSSEOS2zl4Wb08mBvUlpk
         72rg==
X-Gm-Message-State: APjAAAXnguEA5Eo77wCIvyAnCspGEWM7ue1pZ9n81PIOFq2BMtB4KDTU
        O/9g+sQglO8IF42LPAh/2uT/6awkwaI=
X-Google-Smtp-Source: APXvYqy8ZblhPIdKZP6lNt4KgGWceOppT0tU9+FPoUy4FFXBS6L5kk1rr7zuQCT6bGUttMEzsAlRbA==
X-Received: by 2002:a63:6507:: with SMTP id z7mr24810595pgb.322.1576983121089;
        Sat, 21 Dec 2019 18:52:01 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k9sm1866775pjo.19.2019.12.21.18.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 18:52:00 -0800 (PST)
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
Subject: [PATCHv5 net 7/8] sit: do not confirm neighbor when do pmtu update
Date:   Sun, 22 Dec 2019 10:51:15 +0800
Message-Id: <20191222025116.2897-8-liuhangbin@gmail.com>
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

v5: No change.
v4: No change.
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

Reviewed-by: Guillaume Nault <gnault@redhat.com>
Acked-by: David Ahern <dsahern@gmail.com>
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

