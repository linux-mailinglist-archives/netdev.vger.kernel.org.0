Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A95B34EF9
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfFDRe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:34:26 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:44566 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726092AbfFDRe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:34:26 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0888B28006C;
        Tue,  4 Jun 2019 17:34:23 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 4 Jun
 2019 10:34:15 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [RFC PATCH v4 net-next 1/4] flow_offload: add a cookie to
 flow_action_entry
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
References: <a3f0a79a-7e2c-4cdc-8c97-dfebe959ab1f@solarflare.com>
Message-ID: <73da1de8-0522-412d-f582-2ca29fd3a061@solarflare.com>
Date:   Tue, 4 Jun 2019 18:34:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <a3f0a79a-7e2c-4cdc-8c97-dfebe959ab1f@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24656.005
X-TM-AS-Result: No-3.962600-4.000000-10
X-TMASE-MatchedRID: tMKigTP4egabII6cSoXys4rkmrf0Igi/Qth2saDL5KrieGQLRIaTJAoe
        RRhCZWIBfGzuoVn0Vs6PQi9XuOWoOMHVNeDWrWSGimHWEC28pk2RAgbvhPsYZuGEBJBnnr+Ko8W
        MkQWv6iUD0yuKrQIMCD3Al4zalJpFWBd6ltyXuvsnDanEk8Z/+s/k+u34u5xa+GH3qREwNFX/yy
        y8oURzj22+URvEh2OsYq6nD4ImiB5Qf6GXYylsNnztqLsFZ/c0QSGsf2HxCwkxwqle67/WNUAzB
        bitj/RY7aFmrxFux0RN2fIyiQnUdOJqixYeb35sftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.962600-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24656.005
X-MDID: 1559669665-TxjHz6Y8956M
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
index 36fdb85c974d..d526696958f6 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -140,6 +140,7 @@ enum flow_action_mangle_base {
 
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

