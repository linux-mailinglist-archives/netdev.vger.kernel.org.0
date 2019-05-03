Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 717AC130E7
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbfECPIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:08:31 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:56770 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726495AbfECPIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 11:08:31 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id AC55C30007B;
        Fri,  3 May 2019 15:08:29 +0000 (UTC)
Received: from ehc-opti7040.uk.solarflarecom.com (10.17.20.203) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 3 May 2019 16:08:22 +0100
Date:   Fri, 3 May 2019 16:08:13 +0100
From:   Edward Cree <ecree@solarflare.com>
X-X-Sender: ehc@ehc-opti7040.uk.solarflarecom.com
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Anjali Singhai Jain <anjali.singhai@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: [RFC PATCH net-next 3/3] flow_offload: support CVLAN match
Message-ID: <alpine.LFD.2.21.1905031607170.11823@ehc-opti7040.uk.solarflarecom.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24588.003
X-TM-AS-Result: No-2.055700-8.000000-10
X-TMASE-MatchedRID: sCDf79FZeQnOt+/gOYaZxQPZZctd3P4Bl2F9+KxZd8dLiJUKJm5lyKPF
        jJEFr+olxpQ77C1A1tr3FLeZXNZS4CiM3WUt6LtFaOz8F/pTe4s6KXoNUjPX83e0nBluT2htduc
        eJolmdr+YVct0aJ7Wm++yCLGQELewg2VxtXdrUuvUlyHrHv2rMgKTsGFb+J78FwqhNBEHf/RyoI
        PhxHMm1bhCj6a0MTv8SvGzpcUo0RA=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.055700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24588.003
X-MDID: 1556896110-QFXLn_q7yj2D
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
index 6f59cdaf6eb6..48847ee7aa3a 100644
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
