Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E092124639
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfLRLyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:54:14 -0500
Received: from mail-pf1-f175.google.com ([209.85.210.175]:46496 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbfLRLyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:54:13 -0500
Received: by mail-pf1-f175.google.com with SMTP id y14so1063917pfm.13
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ph2DqLZ8ZUSLbwOznp07vXgfxZOHgiCHoNyWoOMwFNY=;
        b=tV7O+0/IeLh9Wd+eVKMN0nBqMSdccbuNxx4l+nGSdFH/q3R+XZL8DYq6lP06V05Ep4
         oI9vfQBmFQShwTOYOcUkWv2SofXb7C9kquUg+KLOIDBkO49AQbUoH72TYlv2XXxbBYhH
         PbjzmeVjPc/AeEeneXuuiy5f7ooBAuMSH3ApLEFIazd10eIVJJb4QW2k6XZT5GtqUvuC
         9G4Z9W90CYHoKS9Lo2X0n8FRWiYzijzOH9pUr7ueZWMEAkAVPWXxYpT8XtIXoXqo4Pg8
         u/Vd7HC3CVZZSh+JlrUAWAPRKvi64rVgmJAXnTot5GAV8SfqDZov+NSFqu3JmG62ZgpE
         E7kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ph2DqLZ8ZUSLbwOznp07vXgfxZOHgiCHoNyWoOMwFNY=;
        b=l2r4EOmnfTvnHmVD4wcA5DkFDBmC7sufJ1btLMGcn4Cee5lSsaaIU5wAgGWlEX6YUV
         c4z/InOzFpMibl4F540eTMGbTdHLzkihh8R9s7cjd9rZMYrHSvvRkmu57UgIsMiaVN6h
         fx2xfRNQZsFcE56/IPqfUuohvkRMtTLOr7O4O1LrnhHVsJlRU6PWQQCTT9nl1pQclx++
         Tn7t86Koei/uee7xhDelTKFV5xufm+oMlr0B+AHA+O6wL7ea4SW4NY6xEbocmbMlXPgb
         LSj6eS/vZDgabRNMLIdMDf4nlTH5dH4GvTtkMi87GCnUA0hZZUfG5V3U0KHt2MAlM+Zf
         vHuQ==
X-Gm-Message-State: APjAAAWm0gFAmVkS3O5efM27J1MHuR3naTYzA+QYXj4Jj769x/dpSgBu
        j7MFOLX4+7pudJzR7g2lei2cMAwqbho=
X-Google-Smtp-Source: APXvYqwfifQW/LLIFKecHfCgMOkAqT2qR6p2j+jSBWpQb0P0oN3VIQwICvbTOQbj7/daZ2C59RpuFg==
X-Received: by 2002:a62:446:: with SMTP id 67mr2445107pfe.109.1576670052745;
        Wed, 18 Dec 2019 03:54:12 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x33sm2961067pga.86.2019.12.18.03.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:54:12 -0800 (PST)
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
Subject: [PATCH net-next 8/8] net/dst: do not confirm neighbor for vxlan and geneve pmtu update
Date:   Wed, 18 Dec 2019 19:53:13 +0800
Message-Id: <20191218115313.19352-9-liuhangbin@gmail.com>
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

So disable the neigh confirm for vxlan and geneve pmtu update.

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

