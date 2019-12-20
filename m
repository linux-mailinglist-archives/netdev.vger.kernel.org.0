Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4E61273DD
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 04:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfLTD0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 22:26:15 -0500
Received: from mail-pf1-f177.google.com ([209.85.210.177]:34042 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbfLTD0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 22:26:15 -0500
Received: by mail-pf1-f177.google.com with SMTP id l127so4439420pfl.1
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 19:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gylx/NMD0ldqd3YSkq+7y4Gipb/VepE8tqTW6LAeoq0=;
        b=J0AutXzz7C/PdhlKxSofSNrFv9HiChYr0edafMfgvequUqFO8AVTfZf2BTFMZVYV+P
         oR2lUrXiXbFdU2jTwp1B/XC7Nm9iEEvg/+fjCX+Qol1ZpGZ+sUOs6gW+U1F9UUb8EhPs
         qaY/qIIcH3bPZYwR3dO14LM0znZvpWTk6nRjBNWK7egfVBd08y0K3uIDliO28i2g0qT7
         Ck4MreZzOGi5hKgrCXHwq/lHMcG0XvV8MphybyScPYwYH/apjd8Wq6YLFmhzEDNE7FHD
         VsmH+Fk5oGZFWppxV3giIjYHn65s4g+evYZUrrrDZ8PlgQSfpJ4RlTSFAWTCjPUvte7W
         HDEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gylx/NMD0ldqd3YSkq+7y4Gipb/VepE8tqTW6LAeoq0=;
        b=p7ljn9fhAvlqt0cJjb74jm+UKIBU3wJvD4nDZVfEO5MxNOueDlE2/7spU6U7jHhKzx
         0Y6XE2S+ZftLmCP8zlIMmQzodCJaXY/98xGfcFNBH1HiRrcSPN0KmFZDeaZcTOYuAleI
         jQFMjxgjwJFvVbo10XyzuiPQF79dMG8ca678617TiRb9kLyCVUC0v5/FXGMB1OE1eEDx
         NNZdkJwxM2w6EPSmZV3cA8e0yTvqVjwovus+0tjF0+4aUqclKGaUs2QDQ12tMgjndPkw
         eNOVo5y0z0l+qUxiaR7FTTW1Cs8Dozh+oNTe8JP4YgfStbpv9TQYdGgdCMfogQlZJXpd
         XHjQ==
X-Gm-Message-State: APjAAAXJWzgHtEJUI7+xN2SaHHRGy+c55NpKriQn1FlrDOqip97T0pnJ
        AggUfdLt+mEgqZCLh/w2NOSjh9rsOcI=
X-Google-Smtp-Source: APXvYqxCSg4X9I/RijJLUs7r7xDm0duasLvi0FQ+iL3kaoFYfe2H+a1ss86j9vLjrRBc0RWV9EJoMg==
X-Received: by 2002:a63:dc41:: with SMTP id f1mr13007032pgj.119.1576812374734;
        Thu, 19 Dec 2019 19:26:14 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gc1sm7954265pjb.20.2019.12.19.19.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 19:26:14 -0800 (PST)
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
Subject: [PATCHv4 net 8/8] net/dst: do not confirm neighbor for vxlan and geneve pmtu update
Date:   Fri, 20 Dec 2019 11:25:25 +0800
Message-Id: <20191220032525.26909-9-liuhangbin@gmail.com>
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

So disable the neigh confirm for vxlan and geneve pmtu update.

v4: No change.
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

Fixes: a93bf0ff4490 ("vxlan: update skb dst pmtu on tx path")
Fixes: 52a589d51f10 ("geneve: update skb dst pmtu on tx path")
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/net/dst.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 208e7c0c89d8..626cf614ad86 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -535,7 +535,7 @@ static inline void skb_tunnel_check_pmtu(struct sk_buff *skb,
 	u32 encap_mtu = dst_mtu(encap_dst);
 
 	if (skb->len > encap_mtu - headroom)
-		skb_dst_update_pmtu(skb, encap_mtu - headroom);
+		skb_dst_update_pmtu_no_confirm(skb, encap_mtu - headroom);
 }
 
 #endif /* _NET_DST_H */
-- 
2.19.2

