Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 330BF130CC
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 16:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfECO7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 10:59:48 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:47962 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbfECO7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 10:59:47 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id 3C606A80070;
        Fri,  3 May 2019 14:59:45 +0000 (UTC)
Received: from ehc-opti7040.uk.solarflarecom.com (10.17.20.203) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 3 May 2019 15:59:37 +0100
Date:   Fri, 3 May 2019 15:59:28 +0100
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
        "Or Gerlitz" <gerlitz.or@gmail.com>
Subject: [RFC PATCH net-next 0/3] flow_offload: Re-add various features that
 disappeared
Message-ID: <alpine.LFD.2.21.1905031538070.11823@ehc-opti7040.uk.solarflarecom.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24588.003
X-TM-AS-Result: No-4.216800-8.000000-10
X-TMASE-MatchedRID: H2wTq3MMruiTCMGA75EfMqb8GfRpncAzBdebOqawiLv5wedLIUgRE0dr
        5sXf1it/Dj8b8ZhIxSkTZKPDZZn4nqs6SlQGyqnf/az81CtIKD7DHSNFHFxB80S/boWSGMtdYXC
        agLTSWEgbwwMHTSE1HysTGnuQYWzXf5w6MH9gMGzYd2+/8wYTdVAI6wCVrE3vnejL6nki/2yaRU
        TjqKog/+3GkM7K3jtycJU4Dk4SOITuQRujK9zVmpUJP7vFynrRjI6qXkf2FQ0AhmnHHeGnvYBaM
        qh3jZTT4wnhOb+JR+R/JgN7Aw6tAOTCMddcL/gjymsk/wUE4hq//a2uCcPZHlPerQyceej3vMYf
        5nMy6MNtpFAxPrpjvg+DfkC3nXvKvsF+XWa9C2w7FPnLnm5bLdFIYazSbcVKbf9+SVdE8FoRfhu
        mrkAYcplDgGrFjQ3trD26xyvnotWnJJj8LUqPGEQcVBpn00jiQwymtxuJ6y0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.216800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24588.003
X-MDID: 1556895586-Gg5kow1NLBaz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the flow_offload infrastructure was added, a couple of things that
 were previously possible for drivers to support in TC offload were not
 plumbed through, perhaps because the drivers in the tree did not fully
 or correctly implement them.
The main issue was with statistics; in TC (and in the previous offload
 API) statistics are per-action, though generally only on 'delivery'
 actions like mirred, ok and shot.  Actions also have an index, which
 may be supplied by the user, which allows the sharing of entities such
 as counters between multiple rules.  The existing driver implementations
 did not support this, however, instead allocating a single counter per
 rule.  The flow_offload API did not support this either, as (a) the
 action index never reached the driver, and (b) the TC_CLSFLOWER_STATS
 callback was only able to return a single set of stats which were added
 to all counters for actions on the rule.  Patch #1 of this series fixes
 (a) by storing tcfa_index in a new action_index member of struct
 flow_action_entry, while patch #2 fixes (b) by adding a new callback,
 TC_CLSFLOWER_STATS_BYINDEX, which retrieves statistics for a specified
 action_index rather than by rule (although the rule cookie is still   
 passed as well).
Patch #3 adds flow_rule_match_cvlan(), analogous to
 flow_rule_match_vlan() but accessing FLOW_DISSECTOR_KEY_CVLAN instead
 of FLOW_DISSECTOR_KEY_VLAN, to allow offloading inner VLAN matches.
This patch series does not include any users of these new interfaces;   
 the driver in which I hope to use them does not yet exist upstream as  
 it is for hardware which is still under development.  However I've CCed
 developers of various other drivers that implement TC offload, in case
 any of them want to implement support.  Otherwise I imagine that David
 won't be willing to take this without a user, in which case I'll save
 it to submit alongside the aforementioned unfinished driver (hence the
 RFC tags for now).

Edward Cree (3):
  flow_offload: copy tcfa_index into flow_action_entry
  flow_offload: restore ability to collect separate stats per action
  flow_offload: support CVLAN match

 include/net/flow_offload.h |  3 +++
 include/net/pkt_cls.h      |  2 ++
 net/core/flow_offload.c    |  7 +++++++
 net/sched/cls_api.c        |  1 +
 net/sched/cls_flower.c     | 30 ++++++++++++++++++++++++++++++
 5 files changed, 43 insertions(+)
