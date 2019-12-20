Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8BB1273D6
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 04:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfLTDZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 22:25:56 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43820 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbfLTDZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 22:25:56 -0500
Received: by mail-pl1-f194.google.com with SMTP id p27so3479569pli.10
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 19:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1cCUASS39PRQ3Dk0JsX27UGknq3Vwp8U2oVYJAfpBhw=;
        b=IbcCW83cJTYiChjgA+e72cMY6jez9SToJYVn9mMtfIExUkCbU0o9hkP4zlXRSDJGOA
         n2FLVyGKAiXp+q1vh4tUxI1rD9kuiSInK9oq6NAvsWwqOTp3g4bwMi9/2TG46Gpmf+6l
         BzinRQBeYtld5ovOmAphx1ztoCLcYaE6oF8UbYJ6RXm4jVnFIajgHNxV3n98aP194X6W
         mXGd5yC1ios4j18jBka7ocX7nVfsPv5bXSEAcNHScNngIJEBeedssPw6niWrMMa+yDQY
         d9IXs+cTW2b/vCw9J1kUVRDPNqquG2XLHdLZI6O85Bfi+gCUM/C1pITDqplyIdZu6tsv
         bSnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1cCUASS39PRQ3Dk0JsX27UGknq3Vwp8U2oVYJAfpBhw=;
        b=FIn4qUtFiCfGM1nRbVQVsgGQlkD50nEGyoXfk2yDNr0dIPRLtwFoGC3w4/qLcXHYeJ
         KEcqTdavYm+lo05Z4vzkS0IT92VzYGlT8zHXEfxUZgY43c++6NyPKwQp1BX4UddUmPu4
         dM5hJEOGaCduqlCshuvnUgXHfKG8McaGQlkAu6SDOtQOGXTA7t9PfrtygfIkB2Gx4CF0
         4FQISVPq5eVf7ovnqdyAm8fD9xq/mucjTy0s8YyNq0vKoPViVugAFLJh6rWQR+7DQfwR
         o7Nf9us5mHiFYGGc8N0XyJ4CI9QUbyRnYJTjTZNMGOZbH2te5JUrximBH1WmZ/Nbyr7C
         YCbA==
X-Gm-Message-State: APjAAAUZEc7sQop6QBfbUa+YmI3dtcpbWDMR1n5gnLrblYWqoy7HpTNd
        kMljbQV+sIF7OOW/Qj2SNI5vEUkQudQ=
X-Google-Smtp-Source: APXvYqzEd+MFYBzMaLjtmK2+HzTZ9PjUEJx9qxDOaNj0K0NdA6cidb8xXByT32KC1gUHWUKk6fu+ug==
X-Received: by 2002:a17:902:b495:: with SMTP id y21mr12794535plr.47.1576812355282;
        Thu, 19 Dec 2019 19:25:55 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gc1sm7954265pjb.20.2019.12.19.19.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 19:25:54 -0800 (PST)
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
Subject: [PATCHv4 net 3/8] gtp: do not confirm neighbor when do pmtu update
Date:   Fri, 20 Dec 2019 11:25:20 +0800
Message-Id: <20191220032525.26909-4-liuhangbin@gmail.com>
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

Although gtp only support ipv4 right now, and __ip_rt_update_pmtu() does not
call dst_confirm_neigh(), we still set it to false to keep consistency with
IPv6 code.

v4: No change.
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

Reviewed-by: Guillaume Nault <gnault@redhat.com>
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

