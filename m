Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF061273D7
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 04:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfLTD0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 22:26:00 -0500
Received: from mail-pl1-f180.google.com ([209.85.214.180]:41293 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbfLTD0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 22:26:00 -0500
Received: by mail-pl1-f180.google.com with SMTP id bd4so3484767plb.8
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 19:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k8VRD1EzP8N/XzjLV47adPG2jnB7PNDRXK3An1kMuvo=;
        b=k2Jra/dmNCQv7+zg7jc+Wn/PwnDv4xqUCQFetGcG1cZ3mRRhKmkqMnsIINvML+Phym
         8OErjCEXPZAqi8KrTsvtP6YoM6S80zfmU0vuHeTdvI62y4hjj88qmgjxR+aHfJCtQBVW
         01CbXftiTpSdFXtleBs6ayle4iNKnKyDVrijgt88EYACL/lUwKZfgUUX1LN6+bwdlN7w
         Ct2C5niRfk7Ed6rG1ueCbI6/NLLxBvELB5s0rR7Q60Im6IjC/KKvjdIoVlHf4jNDvx+E
         GWa9nuQ4tL7QwdUaafF7fvc1wQ4BKmnUkcKJA53aqMBnWQMGv150CCzpPtSBGUSa/Jjx
         g0eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k8VRD1EzP8N/XzjLV47adPG2jnB7PNDRXK3An1kMuvo=;
        b=GetqpPbiWPzXepTwrs1M5PySpc0iD35OzdesWf6uf6OYWiTiHr6bAMgyzNqyZmawZ/
         4UAQJbSJJz/CTNvyLMniqpHVkV62Ax6FoH3IwS1/RpwRUzPSOyeoEfxS0ls0qhm5BeTo
         sZuG1DPwiaMNPIRp7+EF2rXxe7pRcm2CQ9XfqHD+gJmIDyYJbqRZerDvG1U7GHmFCarS
         5UMfRRzOMgeiKcRJCPA+AuxsNPh4OQfkAlKW+aAKXnj39nKN1WL9G0xYu1jvqDZsB1kx
         E0oFh6TI7LtQUZbyKXR7vdD/gFzXxmKGzaLrn+1EjMUKXwuYezt3rP0WdowYVsb2iQj2
         p8bg==
X-Gm-Message-State: APjAAAWe0YWqjPHLTH3OEl2zqLhMxgYX+iK3hijmVEGvbxY7s32sll/2
        AKzqDpbpDVt4xS7eaW0X+4gLFAduOeQ=
X-Google-Smtp-Source: APXvYqzQtMWWIsFNEtX8sbKrvWriwZOI4t2My43X4JSDmDihiZkruIsqdMw4b1PWiRrfKzYC0MmcuQ==
X-Received: by 2002:a17:90a:2223:: with SMTP id c32mr14086343pje.15.1576812359150;
        Thu, 19 Dec 2019 19:25:59 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gc1sm7954265pjb.20.2019.12.19.19.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 19:25:58 -0800 (PST)
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
Subject: [PATCHv4 net 4/8] net/dst: add new function skb_dst_update_pmtu_no_confirm
Date:   Fri, 20 Dec 2019 11:25:21 +0800
Message-Id: <20191220032525.26909-5-liuhangbin@gmail.com>
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

Add a new function skb_dst_update_pmtu_no_confirm() for callers who need
update pmtu but should not do neighbor confirm.

v4: No change.
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/net/dst.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/net/dst.h b/include/net/dst.h
index 0739e84152e4..208e7c0c89d8 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -519,6 +519,15 @@ static inline void skb_dst_update_pmtu(struct sk_buff *skb, u32 mtu)
 		dst->ops->update_pmtu(dst, NULL, skb, mtu, true);
 }
 
+/* update dst pmtu but not do neighbor confirm */
+static inline void skb_dst_update_pmtu_no_confirm(struct sk_buff *skb, u32 mtu)
+{
+	struct dst_entry *dst = skb_dst(skb);
+
+	if (dst && dst->ops->update_pmtu)
+		dst->ops->update_pmtu(dst, NULL, skb, mtu, false);
+}
+
 static inline void skb_tunnel_check_pmtu(struct sk_buff *skb,
 					 struct dst_entry *encap_dst,
 					 int headroom)
-- 
2.19.2

