Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6042B18C080
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 20:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgCSThe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 15:37:34 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:51372 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725817AbgCSThe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 15:37:34 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 548914C005C;
        Thu, 19 Mar 2020 19:37:33 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 19 Mar
 2020 19:37:24 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net] netfilter: nf_flow_table: populate addr_type mask
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>, <paulb@mellanox.com>
Message-ID: <7ab81e8a-d1db-6b0c-7f22-fb07e0d0432c@solarflare.com>
Date:   Thu, 19 Mar 2020 19:37:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25300.003
X-TM-AS-Result: No-1.830800-8.000000-10
X-TMASE-MatchedRID: oFxBp2LP3lKUkDPUhpX2vnpRh12Siy9rmdrHMkUHHq8ZwGrh4y4izBMn
        vir+JcmKBTL3N8yyT9ePQi9XuOWoOHI/MxNRI7UkKrDHzH6zmUV9LQinZ4QefL6qvLNjDYTwIq9
        5DjCZh0wUGm4zriL0oQtuKBGekqUpm+MB6kaZ2g4zyYQWlx89fUPaNQFgB7GZgKwNEXpWsKgzVt
        53+nukjq5FpTdUFrAhTcpBEpRR6nDwZnIKqsIaRZLOwgMioCAWwN5vxK4c6q7tfQ1SPvnqTJqVX
        UXjGsjz2F+vBZls4K+yaqc7gc0b5cNrTE0oNMe+
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.830800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25300.003
X-MDID: 1584646653-Wegfq2_PwKxe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nf_flow_rule_match() sets control.addr_type in key, so needs to also set
 the corresponding mask.  An exact match is wanted, so mask is all ones.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 net/netfilter/nf_flow_table_offload.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 06f00cdc3891..f2c22c682851 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -87,6 +87,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	default:
 		return -EOPNOTSUPP;
 	}
+	mask->control.addr_type = 0xffff;
 	match->dissector.used_keys |= BIT(key->control.addr_type);
 	mask->basic.n_proto = 0xffff;
 
