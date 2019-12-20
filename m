Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A49151273D5
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 04:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfLTDZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 22:25:53 -0500
Received: from mail-pf1-f173.google.com ([209.85.210.173]:40349 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfLTDZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 22:25:53 -0500
Received: by mail-pf1-f173.google.com with SMTP id q8so4425439pfh.7
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 19:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=il6MZbi4D6Y53e3+EWGlykkWNNY1AyluEtUm9KdPRbY=;
        b=WCRrJlrHXcliDo9QfNPg4ZYvaAiZHc+as7lySYeVveAQT8cLgcEl+mkqZYUDSrvey7
         sxhcKa4VSOqBLm8Km7oUssGH3tY6Xkkh33pwS4v5M0oIXFX0Bi9OboL0sZrGzh8YkDQH
         vdVNePUjL9lbuxNagXvOh8zfQEAy6giRyuZAlwMD8hNR8rAflNV7xOgRhWuSdOkStseY
         YYT+MCzyOTbvXegnxfJ01x8LCPnd+Mx0U2g9nhH6liDSWJOm8izTryw+LrropebyJdli
         mbMCEbCr6krSVxAN77XSkItcIhBzOi9Y3YxSZkMedTdwglX2LDA1RKghQ2v3mP6IOMzR
         KTlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=il6MZbi4D6Y53e3+EWGlykkWNNY1AyluEtUm9KdPRbY=;
        b=Zn5Pl3vU+iBlMOSzhccx6PYjYB3uzZjGGhB1r+k1yaWgyGjGkSN/wVNxKtWAP2jJLb
         99eTinJvVyNai0Hp/Vh4V7UevqRJUoIAuAwtZF+YVTgkAk7j7V0KiyIE6f2vn8Y+pHsY
         y0rq+oNvQTHLoL6kaj9sooSE4RHFvSfTR0kczOtUegs3S0FRCm5KF4Uq8Qu7r+L1wWQF
         pOgBYl2KLL2i3TLidWXg6EVQ3oW2WP/IHctHhh1/slu2+WNH3u5Q7rJqA29GmEHNG4WR
         VEyrBGmw0/+m2xEfkelMhlEyyRXNnZSO4niOmgZ2h04PzfBCOAoFfKJUoxy2MStFLACg
         g12w==
X-Gm-Message-State: APjAAAUHpFQEm5jQiXsrCmhsi+ailZVGnUbJpmzIqVR4J2kLdftgWkM/
        rhpcHpGqc6xidLXjPOTAh32C67oR5pY=
X-Google-Smtp-Source: APXvYqw9kYNsvpL2G4ewEguxPZTngJHaZmMlaQG3C0zL+Xvlv9DwWX8xOY1p+iqfAqT+C1DLfvqAyQ==
X-Received: by 2002:a65:42c2:: with SMTP id l2mr12298349pgp.172.1576812351449;
        Thu, 19 Dec 2019 19:25:51 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gc1sm7954265pjb.20.2019.12.19.19.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 19:25:50 -0800 (PST)
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
Subject: [PATCHv4 net 2/8] ip6_gre: do not confirm neighbor when do pmtu update
Date:   Fri, 20 Dec 2019 11:25:19 +0800
Message-Id: <20191220032525.26909-3-liuhangbin@gmail.com>
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

When we do ipv6 gre pmtu update, we will also do neigh confirm currently.
This will cause the neigh cache be refreshed and set to REACHABLE before
xmit.

But if the remote mac address changed, e.g. device is deleted and recreated,
we will not able to notice this and still use the old mac address as the neigh
cache is REACHABLE.

Fix this by disable neigh confirm when do pmtu update

v4: No change.
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

Reported-by: Jianlin Shi <jishi@redhat.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/ip6_gre.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 071cb237f00b..189de56f5e36 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1040,7 +1040,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 
 	/* TooBig packet may have updated dst->dev's mtu */
 	if (!t->parms.collect_md && dst && dst_mtu(dst) > dst->dev->mtu)
-		dst->ops->update_pmtu(dst, NULL, skb, dst->dev->mtu, true);
+		dst->ops->update_pmtu(dst, NULL, skb, dst->dev->mtu, false);
 
 	err = ip6_tnl_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu,
 			   NEXTHDR_GRE);
-- 
2.19.2

