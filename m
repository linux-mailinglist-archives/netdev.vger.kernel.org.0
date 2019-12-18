Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C259124633
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfLRLxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:53:54 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33476 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfLRLxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:53:54 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so1173914pgk.0
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f1Ac/d/FIdYYt7eW5bvq2uKLuR2f6eUdSLn/TOhTQck=;
        b=LsJ8bxKWEBUEwUvaq/EsWYLRbuCY0IUurh8RGDsfB+dIb69mc1tyvsFRNW/v7BoyWm
         mL3eEMmbom+nSSuMggtVN2QjhiOglI3BGv4nHMVbb+Q3ybHwDBzVnTN3vYsAUXzgtUlb
         dD4p50ierHRBw4TsFoPNiW3YJ5Xp/c9cBHtj2Ar/XdojKKw69fmjvo3vJpmzYodljA5J
         gdr1cKSl8ZhmIPnYEVsqxpQHlb2h1DCHscLSnaft8suJ+Y+F1WmLX7CVPOzWUf8DMrf2
         F2HLhwRYaa7/TDlosb9u6Uj56otNQMXGbouxrZ6JglgppoL7DvFb5ZLLDwhbwKLbVUYT
         abag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f1Ac/d/FIdYYt7eW5bvq2uKLuR2f6eUdSLn/TOhTQck=;
        b=nRKAa68Z5v/nmI13JqWWNyawSyy6YPk0RxQxJWIUodtYroL2XQJCD+xUPbgV+rJwHh
         cp3iJQmX0ynb0EhshCg6oaMo5kEZCmg+JV1eFWxZwkGNoNQO3owpeE5g8t7UD2cYPS/I
         PWDB8ByrkTf9TPy66XgSdu2wv7yRf3N2jJZOQFNKzVkPx31Sv5wkUuOImmyhiyaU2UMN
         pdFP3fecoATigiXgGMVbchkfCdcuJCgN+XVS7dTE/1ZfUqiU+GwJVgXhLc/295+6oVM+
         DmTspHkdRi2+ikkiTEoEmePo5kwcbwKr0cNxbuqnW4ZrDMXVCsobISQ93vlKrcPMbQHn
         Bkyw==
X-Gm-Message-State: APjAAAWfYGBNezh9qxJThk/q+OzJIYqDkx0rOD15B8DBgUF8PXrqbX2U
        hSCDGgm1bcybNrFsY7gKKjdra7DvZeUuPQ==
X-Google-Smtp-Source: APXvYqyIIdPVxxFgpnJuvnpDc0ZekAjvWxGJnDlLNOPxTCPfnFFnIg2IYbg1JytlFNELfjamX5YRBQ==
X-Received: by 2002:a63:d00f:: with SMTP id z15mr2582762pgf.143.1576670033508;
        Wed, 18 Dec 2019 03:53:53 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x33sm2961067pga.86.2019.12.18.03.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:53:53 -0800 (PST)
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
Subject: [PATCH net-next 3/8] gtp: do not confirm neighbor when do pmtu update
Date:   Wed, 18 Dec 2019 19:53:08 +0800
Message-Id: <20191218115313.19352-4-liuhangbin@gmail.com>
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

Although gtp only support ipv4 right now, and __ip_rt_update_pmtu() does not
call dst_confirm_neigh(), we still set it to false to keep consistency with
IPv6 code.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/gtp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 9cac0accba7a..71b34ff8e7eb 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -541,7 +541,7 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
 		mtu = dst_mtu(&rt->dst);
 	}
 
-	rt->dst.ops->update_pmtu(&rt->dst, NULL, skb, mtu, true);
+	rt->dst.ops->update_pmtu(&rt->dst, NULL, skb, mtu, false);
 
 	if (!skb_is_gso(skb) && (iph->frag_off & htons(IP_DF)) &&
 	    mtu < ntohs(iph->tot_len)) {
-- 
2.19.2

