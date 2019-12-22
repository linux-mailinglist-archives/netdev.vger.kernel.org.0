Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D601D128C65
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 03:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfLVCwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 21:52:06 -0500
Received: from mail-pl1-f182.google.com ([209.85.214.182]:44344 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfLVCwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 21:52:05 -0500
Received: by mail-pl1-f182.google.com with SMTP id az3so5753531plb.11
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 18:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AxZruANWApqWeSTD63Mdow4gckODHVs6GJsooNDfyIM=;
        b=O+2JCD1u7eBzjGComXbm21vr72FblMWCxyHUQRkSbRg+a0yKjUel9crXeNF5lQ3ARY
         2yxyvBSrbVtQrS9nabqed6NPyWb0hUBEZjwup6I10DUgnLSWm32c8J/HIQKDcwQ3sgUb
         OQIO8jSH1p+QqslzfnIbMAN0Gw93VeL3sjeazuMiLuRxW/qfRe+Jz77W9oUw5hQ1WEQJ
         aGWom1DxzcbdzJP2VmbGNAjsMJ6BUViF6ByxJky3Wp73yAsHNqC/Z1gofORzdCWHmNgx
         jcZwHqjDODO0yA5atANaL8qU1UkNUa3HpFulKjBTCgaMtFsRnag+SaUmDjubdVsBtKTu
         /8Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AxZruANWApqWeSTD63Mdow4gckODHVs6GJsooNDfyIM=;
        b=rcj5rlnrxVaRbRgGK7zMSc6332nfBY6OJHxI0ibrgxs1mCOtN81+3z+6swIZlRZWn+
         8dBtlvkQbDUvlUc325AL6PYe16E4608VNN/Egyo0h6APezTCcKc30AIwxWsLXce2Y2Xb
         Ec+5m+KMI32OQZAGC4uuJ5RpySpYKZfFA7whGyEMu3yJVSWvs4SR6yWKzVATCxgXgVPD
         dQRk/lxg2qzkzUL0l2SJTxC+Y36Xr5s/EvWnyS424n0VW6PmeItzTPMgvVzmsC4Nhhej
         rnhCE8f7+0RpMTCKOzWMv2fsBwfANCLQxJvDCWVYDR6wnJO+EsZp/AA0etTXWthUooRP
         ppSA==
X-Gm-Message-State: APjAAAViKW5727UfQomgc+0RwFnSqPJcezRuMCXtXK47UsnRsIuf5f2i
        XG+qsC6JE+3H8xbcCkFPzi6ceAVfxNw=
X-Google-Smtp-Source: APXvYqxkfxksIFbu1vEJQ9NHRKEIlSC+rEeGBeJzvG6LYBc5mXYJhfSjTalq3S+8EvJSp8lcO15pjA==
X-Received: by 2002:a17:90a:508:: with SMTP id h8mr25923583pjh.91.1576983124914;
        Sat, 21 Dec 2019 18:52:04 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k9sm1866775pjo.19.2019.12.21.18.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 18:52:04 -0800 (PST)
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
Subject: [PATCHv5 net 8/8] net/dst: do not confirm neighbor for vxlan and geneve pmtu update
Date:   Sun, 22 Dec 2019 10:51:16 +0800
Message-Id: <20191222025116.2897-9-liuhangbin@gmail.com>
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

So disable the neigh confirm for vxlan and geneve pmtu update.

v5: No change.
v4: No change.
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

Fixes: a93bf0ff4490 ("vxlan: update skb dst pmtu on tx path")
Fixes: 52a589d51f10 ("geneve: update skb dst pmtu on tx path")
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Tested-by: Guillaume Nault <gnault@redhat.com>
Acked-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/net/dst.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index dc7cc1f1051c..3448cf865ede 100644
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

