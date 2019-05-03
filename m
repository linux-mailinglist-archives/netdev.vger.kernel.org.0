Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14618130D3
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfECPDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:03:30 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:41992 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbfECPD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 11:03:29 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id A2E82280081;
        Fri,  3 May 2019 15:03:27 +0000 (UTC)
Received: from ehc-opti7040.uk.solarflarecom.com (10.17.20.203) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 3 May 2019 16:03:20 +0100
Date:   Fri, 3 May 2019 16:03:11 +0100
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
Subject: [RFC PATCH net-next 1/3] flow_offload: copy tcfa_index into
 flow_action_entry
Message-ID: <alpine.LFD.2.21.1905031601050.11823@ehc-opti7040.uk.solarflarecom.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24588.003
X-TM-AS-Result: No-6.464900-8.000000-10
X-TMASE-MatchedRID: Ii+EGXSJ7Vi0PK/eA06et0xxHBq7BCSEj/xLIaDSshEAhmnHHeGnvXB4
        4IkzjfYyrUhQzMxACbp1LpODxWBULCCCuZ8QtFxJngIgpj8eDcDYr6U3ZlQkdsRB0bsfrpPIHm9
        ggFVoCcBMsgKEDln+gAK1cStn4Pdq4YDzEDJNH3MlyK7Oxyyn9x9+/0Kz56dvftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.464900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24588.003
X-MDID: 1556895808-rKx-d03YbwPU
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Required for support of shared counters (and possibly other shared per-
 action entities in future).

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 include/net/flow_offload.h | 1 +
 net/sched/cls_api.c        | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index d035183c8d03..6f59cdaf6eb6 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -135,6 +135,7 @@ enum flow_action_mangle_base {
 
 struct flow_action_entry {
 	enum flow_action_id		id;
+	u32				action_index;
 	union {
 		u32			chain_index;	/* FLOW_ACTION_GOTO */
 		struct net_device	*dev;		/* FLOW_ACTION_REDIRECT */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 263c2ec082c9..835f3129c24f 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3193,6 +3193,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		struct flow_action_entry *entry;
 
 		entry = &flow_action->entries[j];
+		entry->action_index = act->tcfa_index;
 		if (is_tcf_gact_ok(act)) {
 			entry->id = FLOW_ACTION_ACCEPT;
 		} else if (is_tcf_gact_shot(act)) {
