Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E386721C44
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 19:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbfEQROo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 13:14:44 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:32912 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725933AbfEQROn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 13:14:43 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id 791EC6C006E;
        Fri, 17 May 2019 17:14:41 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 17 May
 2019 10:14:37 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <9b137a90-9bfb-9232-b01b-6b6c10286741@solarflare.com>
Message-ID: <f4fdc1f1-bee2-8456-8daa-fbf65aabe0d4@solarflare.com>
Date:   Fri, 17 May 2019 18:14:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <9b137a90-9bfb-9232-b01b-6b6c10286741@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24618.005
X-TM-AS-Result: No-6.911000-4.000000-10
X-TMASE-MatchedRID: hls5oAVArl/mLzc6AOD8DfHkpkyUphL9+IfriO3cV8TO6WkMZF3I5jSd
        /+ozb9o/pjLp3yMyF7euZ3ZhBb1yQ7I9IhPaTqbkC/N7ukLndIDxn7tV/yJUkWMunwKby/AX5Cz
        l3JKva9DhFQAPYd9fpFsSY8X3RV5eV9Ws+nk4Orq7B1QwzOcQDzVfUuzvrtymuyL9jjE2skFtqw
        6rEcE6N98AZxXJ2Z3fjoDPjHIAhMKtIop/D9Co1T8Ckw9b/GFeTJDl9FKHbrmOSVCvVHWJJ/vUa
        lK/4MwMXhXt6OwHIvaRk6XtYogiau9c69BWUTGwur1QVFMnSQrEQdG7H66TyB5vYIBVaAnAm8iX
        gs/UlkgRUKk2C6ntH/RAt3Rf2zWBKy3WXwTBrGwVjjc2zNCOg37cGd19dSFd
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.911000-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24618.005
X-MDID: 1558113282-iXbtP06KW3XO
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/05/2019 16:27, Edward Cree wrote:
> I'm now leaning towards the
>  approach of adding "unsigned long cookie" to struct flow_action_entry
>  and populating it with (unsigned long)act in tc_setup_flow_action().

For concreteness, here's what that looks like: patch 1 is replaced with
 the following, the other two are unchanged.
Drivers now have an easier job, as they can just use the cookie directly
 as a hashtable key, rather than worrying about which action types share
 indices.

--8<--

[RFC PATCH v2.5 net-next 1/3] flow_offload: add a cookie to flow_action_entry

Populated with the address of the struct tc_action from which it was made.
Required for support of shared counters (and possibly other shared per-
 action entities in future).

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 include/net/flow_offload.h | 1 +
 net/sched/cls_api.c        | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 6200900434e1..fb3278a2bd41 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -137,6 +137,7 @@ enum flow_action_mangle_base {
 
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
