Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E535F57DFF
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 10:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfF0INJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 04:13:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44251 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfF0INH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 04:13:07 -0400
Received: by mail-wr1-f65.google.com with SMTP id r16so1389737wrl.11
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 01:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B8vQDF13AHMcgupbh/IW1h1GHRnHKLoGdC/kU7rZ9zo=;
        b=ATg2o/HwspuZohKY8rpe9s3iYYVbgwQpaXIZ0VLiHX8piDOoBeRrZYs+fHsRa0YUN5
         tmSFS9Xo1/WGqYfVTC3ja1A4noUBeFA5I8loie1fbwm51/OCKU9J+jNV7LNLkmyr8r1R
         4SZt0hV/BMgu5yHbPotsIuT0EcSaL46UTE+oI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B8vQDF13AHMcgupbh/IW1h1GHRnHKLoGdC/kU7rZ9zo=;
        b=K/6ecNMKf5NsaL+0rd8qzfbIoVpCPtH2Z0Sudhfm2baxnFIs9j0VDLJPXANVmhZk0E
         5BhLmBiXGcN3b6+p8ANdDpL4GHEYD3xYsoo1+wc0yYuu8S3w3pfXGsb6QV8TcAUH9qLl
         M4UpnLo9z2Ae0verHFbJcgpsHWZk6U2aI0KsDFrL70c3nW3LyT4nLDLIoC4lggjKwAuH
         1F5Vp74DW2xp45hnHQDLsfKWWqlZZCzS6rI8XbjryNpfcuN9GtlrgCOhvBNmlLQ8DKHA
         QTVBhkcm1Cobo6m/MWdFgJ7TbOvDBTg6ELBLHaMtpFI+GVMUTb5xRspPAvTR8X0jfcMr
         9BtQ==
X-Gm-Message-State: APjAAAX35ub7aAVQP/tF6+grqs/e2n63LUu3Seg7EzV8hS+S0YS/3YNb
        55j07ezl8nt+UX1KO2GBgUEdRloIx60=
X-Google-Smtp-Source: APXvYqytd1owlVPAfrL5K2jgZlsWXVrJO/K4tvexMdPYvBPkfNXyoKWlXQ88c990obm8mSIM6NazRA==
X-Received: by 2002:adf:fe4e:: with SMTP id m14mr2184511wrs.21.1561623185469;
        Thu, 27 Jun 2019 01:13:05 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id o6sm6969949wmc.15.2019.06.27.01.13.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 01:13:04 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        pablo@netfilter.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        jhs@mojatatu.com, eyal.birger@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v3 1/4] net: sched: em_ipt: match only on ip/ipv6 traffic
Date:   Thu, 27 Jun 2019 11:10:44 +0300
Message-Id: <20190627081047.24537-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190627081047.24537-1-nikolay@cumulusnetworks.com>
References: <20190627081047.24537-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Restrict matching only to ip/ipv6 traffic and make sure we can use the
headers, otherwise matches will be attempted on any protocol which can
be unexpected by the xt matches. Currently policy supports only ipv4/6.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
v3: no change
v2: no change

 net/sched/em_ipt.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/sched/em_ipt.c b/net/sched/em_ipt.c
index 243fd22f2248..64dbafe4e94c 100644
--- a/net/sched/em_ipt.c
+++ b/net/sched/em_ipt.c
@@ -185,6 +185,19 @@ static int em_ipt_match(struct sk_buff *skb, struct tcf_ematch *em,
 	struct nf_hook_state state;
 	int ret;
 
+	switch (tc_skb_protocol(skb)) {
+	case htons(ETH_P_IP):
+		if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
+			return 0;
+		break;
+	case htons(ETH_P_IPV6):
+		if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
+			return 0;
+		break;
+	default:
+		return 0;
+	}
+
 	rcu_read_lock();
 
 	if (skb->skb_iif)
-- 
2.21.0

