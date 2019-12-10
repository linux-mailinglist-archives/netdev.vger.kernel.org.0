Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1231191D8
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfLJUZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:25:03 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:34719 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfLJUZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 15:25:03 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N2Ujn-1hanVi3ZEN-013uwN; Tue, 10 Dec 2019 21:24:45 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, wenxu <wenxu@ucloud.cn>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: nf_flow_table: fix big-endian integer overflow
Date:   Tue, 10 Dec 2019 21:24:28 +0100
Message-Id: <20191210202443.2226043-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:3xTpZMsGdsJ1nvxkwus8gSKIRft4mnmZ3W5dayWzUFB6FRVJ1FI
 cwz46I+Cy1sEtLqEq0Bs81PGVd6YGU0+T9slg+xO61J5MkNHgzQkVucoPXu2Rl1OYtnPhlL
 SKS8EmVuhxo2B5J8pcy7UruFW5WMy0YzMinmMcPydbqtFZYySqRQdXCJ/IfEuJvfNEOzScF
 nqhPW1HRXRqSO0nAK7WLA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:YpT9RdGICqo=:t7cyKvd9q7by6YV8Gcm7Rr
 lSjAH7qRhK6341Ntpby4SCy0x2oNBq6xeVvRG4L2WK12QVV0Z0rvxPVAxG4q/XeG27F9ib0Mg
 EIqQrd90vpv8t65DCsq0LJljPZOj4M1/ijuPrQ0mTFzO9w85SUGtQHjNAGYBMJj0g1gsLd7oI
 d8Ljm3zXZetqlNWJtuI3uRtQOvw94acmFFSoFHBXKJRCTUY99oBt0zLEBUqs5KoSCZkOjN8Dj
 gC1x6KKWyTfpHhOKn+qa1+OZld9MPRBMh0Hlb5y1o0LqPE6uJnefXYvQmNEHmxYcJJKMkxBHE
 6XeoIzFE59HfgUAmv6bvL+rwohPvCWKux8Zw2kTWUREBH+bwjkS64iFopoF6bATPca94Q1hmf
 EhuimIG/GHJAHkG39h4Sh5BK08bDccFk2+gQzMAyHlggyVsTaw+Vm56xUAikMyNPc4CBTSztc
 IbtsenUxhjxJLZ3IPlCOAxiVv4pAo5FrSIo6aFe/2uucQaxa+8mrXl51ORi+WHzwhssKVgqE6
 UxfWkZTMzriH9g2mXscazGTW/mL3oNVS7GsGewUccu/FJOfMZAB72888NMInDb2PZbOAv4i2f
 3no4y+4Ofmg5admEHQ+FhJroZdk1IGg41ao73cyAwfL4FFMvUw9w5PxhEtix0owcngBS+6oAC
 LidcsC4m4ARnucXpXwlQ24KnmF1C7cRKc0ylUKiyrZpYQng9bClcnQJRmYaaBmW5bXIxPGOji
 /o2qeo4njt7bI1plHQVk7anfNB9ThjpcLBNCNod+wyceQ8Qvg6xlUzayJBFxP5CaxhL35Q5xW
 PKQWJ1wuP8P4I3lcTLL/5y6Ex8Schf/ZRkzraf1Cq4LtTuPIrKcMBrT9g6RuqQQb1mC0knUP2
 0wumud9eS2tZCkc/hTkg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some configurations, gcc reports an integer overflow:

net/netfilter/nf_flow_table_offload.c: In function 'nf_flow_rule_match':
net/netfilter/nf_flow_table_offload.c:80:21: error: unsigned conversion from 'int' to '__be16' {aka 'short unsigned int'} changes value from '327680' to '0' [-Werror=overflow]
   mask->tcp.flags = TCP_FLAG_RST | TCP_FLAG_FIN;
                     ^~~~~~~~~~~~

From what I can tell, we want the upper 16 bits of these constants,
so they need to be shifted in cpu-endian mode.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
I'm not sure if this is the correct fix, please check carefully
---
 net/netfilter/nf_flow_table_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index c54c9a6cc981..24543c45d501 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -77,7 +77,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	switch (tuple->l4proto) {
 	case IPPROTO_TCP:
 		key->tcp.flags = 0;
-		mask->tcp.flags = TCP_FLAG_RST | TCP_FLAG_FIN;
+		mask->tcp.flags = cpu_to_be16(be32_to_cpu(TCP_FLAG_RST | TCP_FLAG_FIN) >> 16);
 		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_TCP);
 		break;
 	case IPPROTO_UDP:
-- 
2.20.0

