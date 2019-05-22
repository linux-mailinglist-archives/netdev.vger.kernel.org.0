Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEBC271BD
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 23:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbfEVViX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 17:38:23 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:48180 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729691AbfEVViX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 17:38:23 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id AD8E52800B4;
        Wed, 22 May 2019 21:38:21 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 22 May
 2019 14:38:14 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v3 net-next 1/3] flow_offload: add a cookie to
 flow_action_entry
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
Message-ID: <5c11a13f-2fd9-8b5f-7f52-9652a6dffdc7@solarflare.com>
Date:   Wed, 22 May 2019 22:38:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24630.004
X-TM-AS-Result: No-3.962600-4.000000-10
X-TMASE-MatchedRID: tMKigTP4egabII6cSoXys4rkmrf0Igi/Qth2saDL5KrieGQLRIaTJAoe
        RRhCZWIBfGzuoVn0Vs6PQi9XuOWoOMHVNeDWrWSGimHWEC28pk2RAgbvhPsYZuGEBJBnnr+Ko8W
        MkQWv6iUD0yuKrQIMCD3Al4zalJpFWBd6ltyXuvuQQjt+HZXxgZyRPufRiWzMmrq4LYhtkTbC2x
        vwWsx9bH7BQqOS7X+k5K/iC1vCJYp7nyS6RgAOc9qRZAfp7dWNnmv78zNIx0Exwqle67/WNUAzB
        bitj/RY7aFmrxFux0RN2fIyiQnUdOJqixYeb35sftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.962600-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24630.004
X-MDID: 1558561102-wF5e9OotUlow
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populated with the address of the struct tc_action from which it was made.
Required for support of shared counters (and possibly other shared per-
 action entities in future).

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 include/net/flow_offload.h | 1 +
 net/sched/cls_api.c        | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index a2df99f9b196..d5f4cc0b45d4 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -139,6 +139,7 @@ enum flow_action_mangle_base {
 
 struct flow_action_entry {
 	enum flow_action_id		id;
+	unsigned long			cookie;
 	union {
 		u32			chain_index;	/* FLOW_ACTION_GOTO */
 		struct net_device	*dev;		/* FLOW_ACTION_REDIRECT */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d4699156974a..5411cec17af5 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3195,6 +3195,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		struct flow_action_entry *entry;
 
 		entry = &flow_action->entries[j];
+		entry->cookie = (unsigned long)act;
 		if (is_tcf_gact_ok(act)) {
 			entry->id = FLOW_ACTION_ACCEPT;
 		} else if (is_tcf_gact_shot(act)) {

