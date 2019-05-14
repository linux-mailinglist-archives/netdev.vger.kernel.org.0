Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1871F1D06C
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 22:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfENUS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 16:18:57 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:33778 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726036AbfENUS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 16:18:57 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id 2959F140079;
        Tue, 14 May 2019 20:18:56 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 14 May
 2019 13:18:52 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net 2/2] net/mlx5e: Fix calling wrong function to get inner
 vlan key and mask
To:     David Miller <davem@davemloft.net>
CC:     Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        <netdev@vger.kernel.org>, Jianbo Liu <jianbol@mellanox.com>
References: <6ba9ac10-411c-aa04-a8fc-f4c7172fa75e@solarflare.com>
Message-ID: <f773e721-717f-efef-d893-7b9aeac427aa@solarflare.com>
Date:   Tue, 14 May 2019 21:18:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <6ba9ac10-411c-aa04-a8fc-f4c7172fa75e@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24612.005
X-TM-AS-Result: No-1.010300-4.000000-10
X-TMASE-MatchedRID: jW2Old1ajwAMiQrcTwX2Aao2fOuRT7aaDyV2oSIWznIda1Vk3RqxOBFA
        +ewA1AiF/279qGcpzeaUgjpAAuN4mDZxjkmratY+sFkCLeeufNs1X1Ls767cpmMunwKby/AXCh5
        FGEJlYgEjlKSXhxkO7JscC5DV1Se5YlldA0POS1IaPMGCcVm9Do7BlHEYXpfjmyiLZetSf8nJ4y
        0wP1A6AEl4W8WVUOR/9xS3mVzWUuBUNjjpwwGmR8FtawVESjpsHUz9y2k2/w0cWghBv5g1hN7LZ
        nsFqnRFEf4CCoVWr9UuoRx21TJF4keUT1zqRwpk9uH9CNWhT1Ef+z3G/93kgxoQVhcDKUH1JRIz
        mbBpwaQgJCm6ypGLZ6Ol5oRXyhFEWoC08z/YUWKUTGVAhB5EbQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-1.010300-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24612.005
X-MDID: 1557865136-ps3cNgOXstbq
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@mellanox.com>

When flow_rule_match_XYZ() functions were first introduced,
flow_rule_match_cvlan() for inner vlan is missing.

In mlx5_core driver, to get inner vlan key and mask, flow_rule_match_vlan()
is just called, which is wrong because it obtains outer vlan information by
FLOW_DISSECTOR_KEY_VLAN.

This commit fixes this by changing to call flow_rule_match_cvlan() after
it's added.

Fixes: 8f2566225ae2 ("flow_offload: add flow_rule and flow_match structures and use them")
Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 122f457091a2..542354b5eb4d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1595,7 +1595,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CVLAN)) {
 		struct flow_match_vlan match;
 
-		flow_rule_match_vlan(rule, &match);
+		flow_rule_match_cvlan(rule, &match);
 		if (match.mask->vlan_id ||
 		    match.mask->vlan_priority ||
 		    match.mask->vlan_tpid) {
