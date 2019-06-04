Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E2B34EE8
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfFDRcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:32:42 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:43884 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726312AbfFDRcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:32:42 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EAC25A4022A;
        Tue,  4 Jun 2019 17:32:39 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 4 Jun
 2019 10:32:35 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [RFC PATCH v4 net-next 0/4] flow_offload: Re-add per-action
 statistics
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
Message-ID: <a3f0a79a-7e2c-4cdc-8c97-dfebe959ab1f@solarflare.com>
Date:   Tue, 4 Jun 2019 18:32:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24656.005
X-TM-AS-Result: No-5.930000-4.000000-10
X-TMASE-MatchedRID: gic6L41wNEbVF+EKi1OPX7BZAi3nrnzbSExQHIFQcStjLp8Cm8vwF1Xa
        1b4xhOVhF0rcil/c7qTZvRLZPkAeRvUpgL+KeT+3SVHYMTQ1F1pDxJKuWK52WumUIoKlWHoQoT0
        8d5VvAtkrocpt5QAsnDQWn+y/cgJKaaJAtxI1t/C5kFk6DtF9fyYof8qPjr5VzVgwP7ZMYf/PQk
        XuCrkdG3W8QOI06wMmH9v81ygotTt1/5vgSD8T3++JTqKfC3nfx0jmFKfRxcgb9oq6FrYQ3Pm8t
        yRwJQtUEtuR7TIdaKV45d+OV6248Iaw96TXEsdWnMQdNQ64xffpVMb1xnESMpGhAvBSa2i/EeWU
        GBiCoDXQWWA/y0oJPUNlKQGEMWqK6jHbEaTIvGGeAiCmPx4NwLTrdaH1ZWqC1kTfEkyaZdz6C0e
        Ps7A07b5LO7CI0nt7wQ1v8MORL+amyZF9SXZx/O014BcM2LDA0fE/Wu2MhUJWXGvUUmKP2w==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.930000-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24656.005
X-MDID: 1559669561-RImqQTZe6x3L
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the flow_offload infrastructure was added, per-action statistics,
 which were previously possible for drivers to support in TC offload,
 were not plumbed through, perhaps because the drivers in the tree did
 not implement them.
In TC (and in the previous offload API) statistics are per-action,
 though generally only on 'delivery' actions like mirred, ok and shot.
 Actions also have an index, which may be supplied by the user, which
 allows the sharing of entities such as counters between multiple rules.
The existing driver implementations did not support this, however,
 instead allocating a single counter per rule.  The flow_offload API did
 not support this either, as (a) the information that two actions were
 actually the same action never reached the driver, and (b) the
 TC_CLSFLOWER_STATS callback is only able to return a single set of
 stats, which are added to all counters for actions on the rule.
Patch #1 of this series fixes (a) by adding a cookie member to struct
 flow_action_entry, while the remaining patches fix (b) by adding a per-
 action offload callback (TC_SETUP_ACTION/TC_ACTION_STATS) for
 RTM_GETACTION, and also (patch #4) calling it for each action when
 dumping a rule.
For drivers supporting per-action stats (of which none yet exist
 upstream, hence RFC), this also means that RTM_GETACTION will return
 up-to-date stats, rather than stale values from the last time the rule
 was dumped.

Changed in v4:
* Incorporated RTM_GETACTION offload series
* Replaced TC_CLSFLOWER_STATS stats-array with multiple TC_SETUP_ACTION
  callbacks
* dropped header inclusion fix (submitted separately)
* re-added RFC tags

Changed in v3:
* replaced action_index with cookie, so drivers don't have to look at
  flow_action_id to distinguish shared actions
* removed RFC tags

Changed in v2:
* use array instead of new callback for getting stats
* remove CVLAN patch (posted separately for net)
* add header inclusion fix

Edward Cree (4):
  flow_offload: add a cookie to flow_action_entry
  net/sched: add callback to get stats on an action from clsflower
    offload
  net/sched: add action block binding to other classifiers
  net/sched: call action stats offload in flower or mall dump

 include/linux/netdevice.h  |  1 +
 include/net/act_api.h      |  7 +++++-
 include/net/flow_offload.h |  2 ++
 include/net/pkt_cls.h      | 18 ++++++++++++++
 net/sched/act_api.c        | 51 ++++++++++++++++++++++++++++++++++++++
 net/sched/cls_api.c        |  2 ++
 net/sched/cls_bpf.c        | 10 +++++++-
 net/sched/cls_flower.c     | 13 ++++++++++
 net/sched/cls_matchall.c   | 12 +++++++++
 net/sched/cls_u32.c        |  7 ++++++
 10 files changed, 121 insertions(+), 2 deletions(-)

