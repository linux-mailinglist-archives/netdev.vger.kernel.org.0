Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89ED81FB2E
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 21:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfEOTmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 15:42:11 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:53198 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbfEOTmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 15:42:11 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 16517A40082;
        Wed, 15 May 2019 19:42:10 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 15 May
 2019 12:42:05 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [RFC PATCH v2 net-next 1/3] flow_offload: copy tcfa_index into
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
References: <88b3c1de-b11c-ee9b-e251-43e1ac47592a@solarflare.com>
Message-ID: <f2d3400a-1e39-1351-ce5a-a64fe76d2be3@solarflare.com>
Date:   Wed, 15 May 2019 20:42:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <88b3c1de-b11c-ee9b-e251-43e1ac47592a@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24614.005
X-TM-AS-Result: No-4.131700-4.000000-10
X-TMASE-MatchedRID: 3TfCflTMpHtug0V7FdnPKZHKbA5GwI8hTIR/yqWMcrsd0WOKRkwsh3Io
        zGa69omdrdoLblq9S5rIJOxIgBZkp74v11zmWaeKystXWIjli5ktwCsGgGRRQ5soi2XrUn/JyeM
        tMD9QOgBJeFvFlVDkf/cUt5lc1lLgjMejjvPkBr7UaW1ldmWMu52Tkpr/h5MDu0tvE3qJJk4EDB
        Bk7yTsLV8j/j++MebuvvH7c1F7BO9tdu2HePpSgxaibLgnBzuQaJ/xwXmtUVQaEFYXAylB9SUSM
        5mwacGkICQpusqRi2ejpeaEV8oRRFZca9RSYo/b
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.131700-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24614.005
X-MDID: 1557949330-LCnsCGGPqrOD
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
index 6200900434e1..4ee0f68f2e8d 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -137,6 +137,7 @@ enum flow_action_mangle_base {
 
 struct flow_action_entry {
 	enum flow_action_id		id;
+	u32				action_index;
 	union {
 		u32			chain_index;	/* FLOW_ACTION_GOTO */
 		struct net_device	*dev;		/* FLOW_ACTION_REDIRECT */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d4699156974a..0d498c3815f5 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3195,6 +3195,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		struct flow_action_entry *entry;
 
 		entry = &flow_action->entries[j];
+		entry->action_index = act->tcfa_index;
 		if (is_tcf_gact_ok(act)) {
 			entry->id = FLOW_ACTION_ACCEPT;
 		} else if (is_tcf_gact_shot(act)) {

