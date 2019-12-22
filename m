Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE19C128C61
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 03:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfLVCvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 21:51:50 -0500
Received: from mail-pf1-f177.google.com ([209.85.210.177]:34725 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbfLVCvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 21:51:50 -0500
Received: by mail-pf1-f177.google.com with SMTP id i6so521151pfc.1
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 18:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tb/7nHDXSyTHRbn6bLUXJNyfhfW+mNakMOm97p9YJEI=;
        b=Y2xpPFpI891O9kBWdqpstSMgH/2Tw+n8oxwpi/B2pQSYCy50syNngv6StAB5k8xDe8
         Ba0OGGeQYg8+cKR7YND4ug/iudZGWz6Mb9hsCOhkneEz8bOa9NErJLLM6P/oCXeAAaJ0
         OMEeITOFu5d6q9K5Ng5Ilul33tTGqeT263shoRroXJijPSQ+OYZb+VOaS4eH0LTQhxqd
         eOA6nWj6tYChw8buLYcUoFXrb/0fSLveLTM991uIG7Gt6LbwVkAbHHRfdcirrPQEYTwO
         0V6/QYAs2NIvChcAtru0mCDkmoKt2pevUhvjQL3szO+rvcydQhpHhqcCZMcI0u4Y9t4f
         YGFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tb/7nHDXSyTHRbn6bLUXJNyfhfW+mNakMOm97p9YJEI=;
        b=SJkIIDjo1eQ1EyesOpcLnJhFt6fnERyifMCx8CXXlFcyaZ1tpCqSllzqiucQq3u1Fy
         MqrMCCP3zSFRWv/ge+y2ziaZcw3HnjRAnSo4HE1X///QRS56GuDuqHdIJnMh9AUDGPmK
         QC+ihUeNqnpkNG3GqWttja+FAHo6ce0GoMEvW/Gk6QvqLGYM4qI4vwlXnNhqu9nD2zfe
         Z7GHfJASkPhYdfsRwTNtl1HSbvEwp/u6rA3kFwVIv0uluHtVKSYDXRltvz2zQZZbQk+Z
         Hy3PGctThP4HBQxErIalilLegRjMls6hamMjLpRnrNhQtPrnuhGcJr6l4MJnXlq2Tibs
         ptJg==
X-Gm-Message-State: APjAAAXKAN5C7A6awn5a2yt5EoJXomcsc89RD/xIz7R4B6vaPg44JwQt
        4fUzfoB2URhekH2H17OpdaOLfrJLLcw=
X-Google-Smtp-Source: APXvYqx5A1aOB1rE+h8/cnGsSdF2XYiJeTFcQjQakLttJv0xcuSnVwsys+/z0QmJFNiHSUs6dPBFjg==
X-Received: by 2002:a62:14cc:: with SMTP id 195mr18628933pfu.160.1576983109635;
        Sat, 21 Dec 2019 18:51:49 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k9sm1866775pjo.19.2019.12.21.18.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 18:51:49 -0800 (PST)
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
Subject: [PATCHv5 net 4/8] net/dst: add new function skb_dst_update_pmtu_no_confirm
Date:   Sun, 22 Dec 2019 10:51:12 +0800
Message-Id: <20191222025116.2897-5-liuhangbin@gmail.com>
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

Add a new function skb_dst_update_pmtu_no_confirm() for callers who need
update pmtu but should not do neighbor confirm.

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
 include/net/dst.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/net/dst.h b/include/net/dst.h
index 593630e0e076..dc7cc1f1051c 100644
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

