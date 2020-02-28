Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9045D17409E
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 20:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgB1T7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 14:59:18 -0500
Received: from correo.us.es ([193.147.175.20]:52580 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgB1T7R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 14:59:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EDE9DF2DE8
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 20:59:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF0B5DA3A9
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 20:59:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D02F5DA3A0; Fri, 28 Feb 2020 20:59:04 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9451ADA7B6;
        Fri, 28 Feb 2020 20:59:02 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 28 Feb 2020 20:59:02 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [213.143.61.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 33C7142EF4E0;
        Fri, 28 Feb 2020 20:59:02 +0100 (CET)
Date:   Fri, 28 Feb 2020 20:59:09 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, saeedm@mellanox.com, leon@kernel.org,
        michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, xiyou.wangcong@gmail.com,
        mlxsw@mellanox.com, Marian Pritsak <marianp@mellanox.com>
Subject: Re: [patch net-next 00/10] net: allow user specify TC filter HW
 stats type
Message-ID: <20200228195909.dfdhifnjy4cescic@salvia>
References: <20200221095643.6642-1-jiri@resnulli.us>
 <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
 <20200222063829.GB2228@nanopsycho>
 <b6c5f811-2313-14a0-75c4-96d29196e7e6@solarflare.com>
 <20200224131101.GC16270@nanopsycho>
 <9cd1e555-6253-1856-f21d-43323eb77788@mojatatu.com>
 <20200224162521.GE16270@nanopsycho>
 <b93272f2-f76c-10b5-1c2a-6d39e917ffd6@mojatatu.com>
 <20200225162203.GE17869@nanopsycho>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="iicrivzhonftqflf"
Content-Disposition: inline
In-Reply-To: <20200225162203.GE17869@nanopsycho>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--iicrivzhonftqflf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pirko,

On Tue, Feb 25, 2020 at 05:22:03PM +0100, Jiri Pirko wrote:
[...]
> Eh, that is not that simple. The existing users are used to the fact
> that the actions are providing counters by themselves. Having and
> explicit counter action like this would break that expectation.
> Also, I think it should be up to the driver implementation. Some HW
> might only support stats per rule, not the actions. Driver should fit
> into the existing abstraction, I think it is fine.

Something like the sketch patch that I'm attaching?

The idea behind it is to provide a counter action through the
flow_action API. Then, tc_setup_flow_action() checks if this action
comes with counters in that case the counter action is added.

My patch assumes tcf_vlan_counter() provides tells us what counter
type the user wants, I just introduced this to provide an example.

Thank you.

--iicrivzhonftqflf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index c6f7bd22db60..1a5006091edc 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -138,9 +138,16 @@ enum flow_action_id {
 	FLOW_ACTION_MPLS_PUSH,
 	FLOW_ACTION_MPLS_POP,
 	FLOW_ACTION_MPLS_MANGLE,
+	FLOW_ACTION_COUNTER,
 	NUM_FLOW_ACTIONS,
 };
 
+enum flow_action_counter_type {
+	FLOW_COUNTER_DISABLED		= 0,
+	FLOW_COUNTER_DELAYED,
+	FLOW_COUNTER_IMMEDIATE,
+};
+
 /* This is mirroring enum pedit_header_type definition for easy mapping between
  * tc pedit action. Legacy TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK is mapped to
  * FLOW_ACT_MANGLE_UNSPEC, which is supported by no driver.
@@ -213,6 +220,9 @@ struct flow_action_entry {
 			u8		bos;
 			u8		ttl;
 		} mpls_mangle;
+		struct {				/* FLOW_ACTION_COUNTER */
+			enum flow_action_counter_type	type;
+		} counter;
 	};
 };
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 13c33eaf1ca1..984f2129c760 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3435,6 +3435,7 @@ static void tcf_sample_get_group(struct flow_action_entry *entry,
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts)
 {
+	enum flow_action_counter_type counter = FLOW_COUNTER_DISABLED;
 	struct tc_action *act;
 	int i, j, k, err = 0;
 
@@ -3489,6 +3490,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 				err = -EOPNOTSUPP;
 				goto err_out_locked;
 			}
+			counter = tcf_vlan_counter(act);
 		} else if (is_tcf_tunnel_set(act)) {
 			entry->id = FLOW_ACTION_TUNNEL_ENCAP;
 			err = tcf_tunnel_encap_get_tunnel(entry, act);
@@ -3567,10 +3569,19 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			err = -EOPNOTSUPP;
 			goto err_out_locked;
 		}
-		spin_unlock_bh(&act->tcfa_lock);
 
 		if (!is_tcf_pedit(act))
 			j++;
+
+		if (counter) {
+			struct flow_action_entry *entry;
+
+			entry = &flow_action->entries[j++];
+			entry->id = FLOW_ACTION_COUNTER;
+			entry->counter.type = counter;
+			counter = FLOW_COUNTER_DISABLED;
+		}
+		spin_unlock_bh(&act->tcfa_lock);
 	}
 
 err_out:

--iicrivzhonftqflf--
