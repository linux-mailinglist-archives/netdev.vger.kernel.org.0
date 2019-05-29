Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4EE2E5BE
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 22:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfE2UHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 16:07:51 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:59400 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726173AbfE2UHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 16:07:51 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 29A71B4009F;
        Wed, 29 May 2019 20:07:48 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 29 May
 2019 13:07:43 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [RFC PATCH net-next 0/2] RTM_GETACTION stats offload
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <bf4c9a41-ea81-4d87-2731-372e93f8d53d@solarflare.com>
Message-ID: <d9d3744f-3dd0-cb8f-955e-3e76be505a09@solarflare.com>
Date:   Wed, 29 May 2019 21:07:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <bf4c9a41-ea81-4d87-2731-372e93f8d53d@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24644.005
X-TM-AS-Result: No-5.012000-4.000000-10
X-TMASE-MatchedRID: bMq3ec/6HvuBv8gzkmASmyMJO6daqdyWO4NrJdLQuoGHv8otQeUIQnsy
        gY4tPtxeKDc3r8yrjqEi0bGwthrSF0LaGDDb5TR1aK+MsTwM+1l+JGMYYph/2xlLPW+8b7Saj/c
        JhxZIqFigGWyVYSar+pcVPxYm2n8nYnUoh1TRvt3VNj9wuvGJUDGL8GMOWjPk4PRrWDwT3Utpcr
        NTw4Vi6NBQGAYstbFrRR55i+wDpcR+fKhqEUkudi8s/ULwMh46lhpPdwv1Z0rs6eKzsbCgr462G
        g+W5SqY586pRK8aBpyKahaRxBoax68J24iV6v218KQMqZXaCznDAPSbMWlGt5GPHiE2kiT4IKRp
        iQCnYZurBF1Y6NemySTOZtu0rfUar5pi9/rVS/GcVWc2a+/ju30tCKdnhB58vqq8s2MNhPCZMPC
        nTMzfOiq2rl3dzGQ1hVsC9YSPqjHyT7s2U8BsOphFysTNrdMlz3EbMZB+0PNCKXSAfVNF+cC+ks
        T6a9fy
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.012000-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24644.005
X-MDID: 1559160470-i0jcg270PgAo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Additional patches on top of [v3] flow_offload: Re-add per-action statistics.
Each time we offload a rule to a block, if any hardware offload results
 (in_hw_count), we allocate a binding object for each action, and add it to a
 list on that action (hw_blocks); this is then updated on reoffload and freed
 on destroy.
Then, when handling RTM_GETACTION, just before copying the action stats into
 the netlink response we make a TC_SETUP_ACTION call to each block on the
 hw_blocks list, in tcf_action_update_stats().  The naming is slightly odd as
 tcf_action_update_stats() ends up calling tcf_action_stats_update(), but I
 couldn't think of something less confusing.
Patch #1 adds the machinery and hooks it from cls_flower; I have tested this
 but possibly not explored every possible sequence of events around binding
 and unbinding blocks from actions.
Patch #2 adds the hooks into the other classifiers with offload (matchall,
 u32 and bpf).  I have not tested these at all (except build testing).

There is nothing even remotely resembling an in-tree user of this (hence RFC).
 It does however prove it can be done, and thus that action cookies don't
 restrict our ability to 'fix RTM_GETACTION' once we _do_ have drivers using
 them.

I do somewhat wonder if we could go further, and instead of making, say, a
 TC_CLSFLOWER_STATS callback on a rule, the core could make TC_ACTION_STATS
 calls on each of its actions.  Initially we'd need to keep both callbacks,
 and drivers could choose to implement one or the other (but not both).  And
 of course we could elide the calls when a->ops->stats_update == NULL.
Maybe that's a crazy idea, I don't know.

Edward Cree (2):
  net/sched: add callback to get stats on an action from clsflower
    offload
  net/sched: add action block binding to other classifiers

 include/linux/netdevice.h |  1 +
 include/net/act_api.h     |  2 +-
 include/net/pkt_cls.h     | 18 ++++++++++++++
 net/sched/act_api.c       | 51 +++++++++++++++++++++++++++++++++++++++
 net/sched/cls_bpf.c       | 10 +++++++-
 net/sched/cls_flower.c    |  7 ++++++
 net/sched/cls_matchall.c  |  7 ++++++
 net/sched/cls_u32.c       |  7 ++++++
 8 files changed, 101 insertions(+), 2 deletions(-)

