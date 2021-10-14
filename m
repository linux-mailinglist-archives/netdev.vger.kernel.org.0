Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0D042E0A5
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 19:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbhJNSBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 14:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhJNSB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 14:01:29 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62057C061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 10:59:24 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id x130so6122462pfd.6
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 10:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5p375nH6SDcuXVFeKU+aEZA/iCjz716SrKg4GrpN+iA=;
        b=poawZhYtqSn4TM0iaXQJyksyudsxSfMM3SITOLTlzWuHSMPnUnjaRCjjEVDG2Ft67v
         cBes0oaJ1gQvLYshoaMpCOqVWBUjYIScDrn0pGKBkAthBMhHUos9fl9H86moLiwZsJKw
         kD7GMULHmwQ6XDft79lFJW2zExRPygiKDm3KLVV+yu52jqlMa6WTAYwouTQ0+E2DA+8R
         kyuFcaENTLrcTnprKPnfh3lKVIE9Gy8aCEbSI5f+XiiOB5vdhV+LKQ0nyiY8foBfwiiP
         +8rWU3nxV0czj3zy1yC8QUFu/dV64zmHnz775o7w4VbDcyGyZ2Qfc8/vlwyYERP6w4WN
         i2Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5p375nH6SDcuXVFeKU+aEZA/iCjz716SrKg4GrpN+iA=;
        b=Dl1gguFrOd3xbJ60iGJiu5xN1U/ih8m25higc32/dLqY052M5MfIf9kK+ORmOGALaV
         TsoY+A+jv29X9VxlHmhdlceA2L3Z1iftkYBUmq3WIsFmQodLOz2B2mdo8mFJF3QuPD+l
         WHcx9HzDypOpVrFGGQsfV3iQURjXXHB0E226zQZX5wMhv9O1hoZgvpVEo60R5huSIb15
         Lgp6n1HteevidH+dZatPNSTbLxSW+IUwa1H/TXEnuFaEnVk5f4pmSM4HfaFc4K0D7xKh
         UH9PriQEqX9HtytsA/ibzSKOR/9YFke8OLVLg9Ne/L8ibT9ajO0smhUgT7LaHX8Tpn+B
         fDqg==
X-Gm-Message-State: AOAM5329Cz4tJocCjq5jn0n2z509LtakIANrJpNhiTr40s28tgr014CQ
        6D83jpxr2+W23/WEv64SmPU=
X-Google-Smtp-Source: ABdhPJx+9oMlFZU3wJJ0SyVsjZNpiq/l1sWMnQp1bsBCvr64OWIfRiFDmT7rlvxNKYoRtMdZDo9Myw==
X-Received: by 2002:a62:7506:0:b0:44c:5cd7:cbb5 with SMTP id q6-20020a627506000000b0044c5cd7cbb5mr6463476pfc.52.1634234363967;
        Thu, 14 Oct 2021 10:59:23 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b87e:a3bd:898a:99c6])
        by smtp.gmail.com with ESMTPSA id i123sm3060831pfg.157.2021.10.14.10.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 10:59:23 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>
Subject: [PATCH net-next 1/2] net: add skb_get_dsfield() helper
Date:   Thu, 14 Oct 2021 10:59:17 -0700
Message-Id: <20211014175918.60188-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211014175918.60188-1-eric.dumazet@gmail.com>
References: <20211014175918.60188-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

skb_get_dsfield(skb) gets dsfield from skb, or -1
if an error was found.

This is basically a wrapper around ipv4_get_dsfield()
and ipv6_get_dsfield().

Used by following patch for fq_codel.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Ingemar Johansson S <ingemar.s.johansson@ericsson.com>
Cc: Tom Henderson <tomh@tomh.org>
---
 include/net/inet_ecn.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/net/inet_ecn.h b/include/net/inet_ecn.h
index ba77f47ef61ed3dbb38504ece304c00825f461fd..ea32393464a291aad77400b34fcdcb5031f01676 100644
--- a/include/net/inet_ecn.h
+++ b/include/net/inet_ecn.h
@@ -188,6 +188,23 @@ static inline int INET_ECN_set_ce(struct sk_buff *skb)
 	return 0;
 }
 
+static inline int skb_get_dsfield(struct sk_buff *skb)
+{
+	switch (skb_protocol(skb, true)) {
+	case cpu_to_be16(ETH_P_IP):
+		if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
+			break;
+		return ipv4_get_dsfield(ip_hdr(skb));
+
+	case cpu_to_be16(ETH_P_IPV6):
+		if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
+			break;
+		return ipv6_get_dsfield(ipv6_hdr(skb));
+	}
+
+	return -1;
+}
+
 static inline int INET_ECN_set_ect1(struct sk_buff *skb)
 {
 	switch (skb_protocol(skb, true)) {
-- 
2.33.0.1079.g6e70778dc9-goog

