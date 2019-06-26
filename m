Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB8F45681D
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 14:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfFZMBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 08:01:09 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36864 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfFZMBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 08:01:08 -0400
Received: by mail-wr1-f68.google.com with SMTP id v14so2425594wrr.4
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 05:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wBkXEAqwMnSxxeLSgwJjoxk2OEVMXkqCws+sukFYxxU=;
        b=W0aYU5qYe54/4mu/t/f+rBP/wrXmxBc6Lk48a0Om5ZBqjnanb15qlscMHD7IH3knbB
         lTMjlSlcNDQcj9yzZV8wap3b22esRUJ7QzuTFPBZy9PMp8mBZ/JbIW4tdIEX2E6s0/LS
         sUDK5mewpcAYBNJK51D5guvCHJQx19EAXOfis=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wBkXEAqwMnSxxeLSgwJjoxk2OEVMXkqCws+sukFYxxU=;
        b=OyV/9eZ+/Wqj7rgBgIS1iX/un0yuXJD7lMSHmLv+wGdbufN202MXmjJ0q/YIfdtM14
         c0SyRg0hmT11UvUF6qpFCpdFkWjO/WHfR07M9E9aVFuCYS7C4YAccLfiLL/S6jfcbO5A
         GR41DGK5ENZcQLrPb0ChJdQUMk50Euof1WiFcBwUAyghvqE0aMUXRTsqY/4vDxKq7OsI
         +2CWEGl/CRLJsokL7masrKDtWdKLmDRzAgsv1prW5clTi2Y0yNjC2rNHKuC7+2Oyor+R
         djIJ91hWfIiTPgkDCRHDooA13ri2+4ULwdUF5tOrFsiLlLFLfMygIdtckEeFq82thoaJ
         e4iQ==
X-Gm-Message-State: APjAAAXsdIaeuTWw4pU+j5Y7b3JFqpTtAy7v5djOrUH5xzCElJArSo++
        mUSwfEZwgkVd0W0j+9yxHLlhMVUt4dw=
X-Google-Smtp-Source: APXvYqxVTZEiihXjtaodvNWXroNGIRbBBW/TKyhnhgPf+2r2GH6kvmK/tZlA4aQwDDXhlOgEZ3LSdg==
X-Received: by 2002:adf:f812:: with SMTP id s18mr3686796wrp.32.1561550465849;
        Wed, 26 Jun 2019 05:01:05 -0700 (PDT)
Received: from localhost.localdomain ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id f190sm1676818wmg.13.2019.06.26.05.01.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 05:01:05 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, pablo@netfilter.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@resnulli.us,
        jhs@mojatatu.com, eyal.birger@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 3/5] net: sched: em_ipt: restrict matching to the respective protocol
Date:   Wed, 26 Jun 2019 14:58:53 +0300
Message-Id: <20190626115855.13241-4-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626115855.13241-1-nikolay@cumulusnetworks.com>
References: <20190626115855.13241-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently a match will continue even if the user-specified nfproto
doesn't match the packet's, so restrict it only to when they're equal or
the protocol is unspecified.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/sched/em_ipt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sched/em_ipt.c b/net/sched/em_ipt.c
index 23965a071177..d4257f5f1d94 100644
--- a/net/sched/em_ipt.c
+++ b/net/sched/em_ipt.c
@@ -187,11 +187,17 @@ static int em_ipt_match(struct sk_buff *skb, struct tcf_ematch *em,
 
 	switch (tc_skb_protocol(skb)) {
 	case htons(ETH_P_IP):
+		if (im->match->family != NFPROTO_UNSPEC &&
+		    im->match->family != NFPROTO_IPV4)
+			return 0;
 		if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
 			return 0;
 		state.pf = NFPROTO_IPV4;
 		break;
 	case htons(ETH_P_IPV6):
+		if (im->match->family != NFPROTO_UNSPEC &&
+		    im->match->family != NFPROTO_IPV6)
+			return 0;
 		if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
 			return 0;
 		state.pf = NFPROTO_IPV6;
-- 
2.20.1

