Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D378C128C60
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 03:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfLVCvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 21:51:47 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:55550 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbfLVCvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 21:51:46 -0500
Received: by mail-pj1-f66.google.com with SMTP id d5so5874392pjz.5
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 18:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gj0b6+3FM9p/IdxIMWsNyOcIH7PFaZaFMFbwyRxhohA=;
        b=EUvVppkWIgKLoIbQO1T6BkeasoCRVTBnex4AeEmyUkm2KoHdfA1IxQH+rgpkwrZftn
         Ni1bVOCgC7vBktipSrGlhbkj63WU4z1O+xsLLbw5VpwjhwVbhKuZD+JFsjPvWDshX5B1
         eTtxJ/gHvQb3EwGT4wJ8/SXDRf0/PoKPbGddPUh8CMknAgcLxq0nSNZPsDOLbJaqSicQ
         JRnywYCQcGK7erRj2Z5Ba2ngv3oxhnqLveoaqr1hJBRdA6+nWvTFMTS1mfo+ZbQ6kCPd
         R/A7QS+NOJ7GEmX+0A4Q7u73SsWu04aG/casRncX9SCaerc2aGwW7ef501xCAbTu2/my
         JElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gj0b6+3FM9p/IdxIMWsNyOcIH7PFaZaFMFbwyRxhohA=;
        b=lEaKOomZCc8u/MZoNFAWQ17rHGGFjersC5AmgpDtdYfivves4fD2SWi5qi3E6wzkSZ
         WJOsLfyjIFvvATBNsoi65u69fmfgOK+b8xqsg85emF1VyjeOKUHr45VriHFtcpA4E4EQ
         /1JILykrP9i7JzundZrEU8FWA6cPlB1X3JHE0l5agpk41M+6pkjNtJ5mXil0vsO/qkTJ
         cBbPhHDk+iCAo2LdkPm9lzBdz8aSyXglLCJhJJ/29W0rFzPC7abbbTD/Y2icGBcgH1Gs
         pVxv8Fge1biUYI3JkjmXJBRq/BGbE2cpytcLOiPYVaxP242CsgCM2J+68OCkivmUhJmY
         waxQ==
X-Gm-Message-State: APjAAAUzex2713QiWzAuMEUY0cwJjVhMga4ET3w7SZXXWMkmpa6vSkSA
        ni4zbdMRP0jTLS0ha1R4L3RU10Fy+MM=
X-Google-Smtp-Source: APXvYqyuduvIuPvh6JVOFRzjOMtfXcXr7rNh6VCg6rVUfT4riB+ZD5oszddtuY0RY5APwOlLtmJ+IQ==
X-Received: by 2002:a17:90a:d986:: with SMTP id d6mr26410848pjv.78.1576983105836;
        Sat, 21 Dec 2019 18:51:45 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k9sm1866775pjo.19.2019.12.21.18.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 18:51:45 -0800 (PST)
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
Subject: [PATCHv5 net 3/8] gtp: do not confirm neighbor when do pmtu update
Date:   Sun, 22 Dec 2019 10:51:11 +0800
Message-Id: <20191222025116.2897-4-liuhangbin@gmail.com>
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

Although GTP only support ipv4 right now, and __ip_rt_update_pmtu() does not
call dst_confirm_neigh(), we still set it to false to keep consistency with
IPv6 code.

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
 drivers/net/gtp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 913062017be9..fca471e27f39 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -540,7 +540,7 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
 		mtu = dst_mtu(&rt->dst);
 	}
 
-	rt->dst.ops->update_pmtu(&rt->dst, NULL, skb, mtu, true);
+	rt->dst.ops->update_pmtu(&rt->dst, NULL, skb, mtu, false);
 
 	if (!skb_is_gso(skb) && (iph->frag_off & htons(IP_DF)) &&
 	    mtu < ntohs(iph->tot_len)) {
-- 
2.19.2

