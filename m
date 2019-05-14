Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC64A1D06B
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 22:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbfENUST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 16:18:19 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:38124 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726044AbfENUST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 16:18:19 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id A386C340133;
        Tue, 14 May 2019 20:18:17 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 14 May
 2019 13:18:14 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net 1/2] flow_offload: support CVLAN match
To:     David Miller <davem@davemloft.net>
CC:     Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        <netdev@vger.kernel.org>, Jianbo Liu <jianbol@mellanox.com>
References: <6ba9ac10-411c-aa04-a8fc-f4c7172fa75e@solarflare.com>
Message-ID: <852c7843-0b97-3352-3bfd-23d074ceae7d@solarflare.com>
Date:   Tue, 14 May 2019 21:18:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <6ba9ac10-411c-aa04-a8fc-f4c7172fa75e@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24612.005
X-TM-AS-Result: No-1.547900-4.000000-10
X-TMASE-MatchedRID: lnut831UkvCtIop/D9Co1T8Ckw9b/GFeTJDl9FKHbrkKA2OoGAlTk8bb
        06Xu0adr4vM1YF6AJbZFi+KwZZttL42j49Ftap9Eymsk/wUE4hpbPkJPLKY8y97KoO8fPZbh5Ci
        1WhaQ/FHsTzAzOZF2uu5BV3JhGvsZ924FCF2f8bWXrRIM/ThybDfE0kJ44HXYQHNaOvpj9ANdcF
        XkHCaP10ODDY5/BuEsoxrk6Q2mIeSJ+wv7oJjhGWXfFD5fdmZR
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.547900-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24612.005
X-MDID: 1557865098-GBlpaTSiHb1R
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Plumb it through from the flow_dissector.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 include/net/flow_offload.h | 2 ++
 net/core/flow_offload.c    | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 6200900434e1..a2df99f9b196 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -71,6 +71,8 @@ void flow_rule_match_eth_addrs(const struct flow_rule *rule,
 			       struct flow_match_eth_addrs *out);
 void flow_rule_match_vlan(const struct flow_rule *rule,
 			  struct flow_match_vlan *out);
+void flow_rule_match_cvlan(const struct flow_rule *rule,
+			   struct flow_match_vlan *out);
 void flow_rule_match_ipv4_addrs(const struct flow_rule *rule,
 				struct flow_match_ipv4_addrs *out);
 void flow_rule_match_ipv6_addrs(const struct flow_rule *rule,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index c3a00eac4804..5ce7d47a960e 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -54,6 +54,13 @@ void flow_rule_match_vlan(const struct flow_rule *rule,
 }
 EXPORT_SYMBOL(flow_rule_match_vlan);
 
+void flow_rule_match_cvlan(const struct flow_rule *rule,
+			   struct flow_match_vlan *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_CVLAN, out);
+}
+EXPORT_SYMBOL(flow_rule_match_cvlan);
+
 void flow_rule_match_ipv4_addrs(const struct flow_rule *rule,
 				struct flow_match_ipv4_addrs *out)
 {

