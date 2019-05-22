Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2B0271BB
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 23:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbfEVVhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 17:37:24 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:33994 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729691AbfEVVhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 17:37:24 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 86FE428007C;
        Wed, 22 May 2019 21:37:22 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 22 May
 2019 14:37:18 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v3 net-next 0/3] flow_offload: Re-add per-action statistics
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
Message-ID: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
Date:   Wed, 22 May 2019 22:37:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24630.004
X-TM-AS-Result: No-5.648800-4.000000-10
X-TMASE-MatchedRID: 01wLatwXZPzVF+EKi1OPX7BZAi3nrnzbSExQHIFQcStjLp8Cm8vwF1Xa
        1b4xhOVhF0rcil/c7qTZvRLZPkAeRvUpgL+KeT+3SVHYMTQ1F1pDxJKuWK52WumUIoKlWHoQQbS
        +7XzUoY3vlrkNPdjQmEmCfxc8JxhGWVAl4So01gD9xyC38S1f/QgqPpbA7sp1wzktBYXAF0p7+n
        Bu7fbl6mDV1vA8SrhSHT5Y+d1NIE4ELR0bfKcvmaJVTu7sjgg1jHhXj1NLbjB/Z0SyQdcmEFuE3
        6pB6+0b2cNhLWr7qIJ4zRiY9YYLzqt3joBwXbxebDAXTGoHcQjHSOYUp9HFyCUQ+FwDMzgqMH1x
        x17eFtT/YLA9lxn50FQgztMzN64i/B9dz1laVgySvRb8EMdYRVeOOwzb8N/Ga73+XlYDLuzeksF
        TIf93EY+pAn19BHXOQG62Sn3aGkyvvxILmKK/HDl/1fD/GopdcmfM3DjaQLHEQdG7H66TyMdRT5
        TQAJnAF7RKjkx1Y7QwcPLwaOOL/uokqh+RK+/HZ1AsRGYliWCeqD9WtJkSIw==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.648800-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24630.004
X-MDID: 1558561043-kT9nWqS3E8ub
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
 (These indices are per action type, so 'drop index 1' and 'mirred index
 1' are different actions.  However, this means that a mirror and a
 redirect action are in the same index namespace, since they're both
 mirred actions.)  The existing driver implementations did not support
 this, however, instead allocating a single counter per rule.  The
 flow_offload API did not support this either, as (a) the information
 that two actions were actually the same action never reached the
 driver, and (b) the TC_CLSFLOWER_STATS callback was only able to return
 a single set of stats which were added to all counters for actions on
 the rule.  Patch #1 of this series fixes (a) by adding a cookie member
 to struct flow_action_entry, while patch #2 fixes (b) by changing the
 .stats member of struct tc_cls_flower_offload from a single set of
 stats to an array.  Existing drivers are changed to retain their
 current behaviour, by adding their one set of stats to every element of
 this array (note however that this will behave oddly if an action
 appears more than once on a rule; I'm not sure whether that's a
 problem).  I have not tested these driver changes on corresponding
 hardware.
Patch #3 ensures that flow_offload.h is buildable in isolation, rather
 than relying on linux/kernel.h having already been included elsewhere;
 this is logically separable from the rest of the series.

Changed in v3:
* replaced action_index with cookie, so drivers don't have to look at
  flow_action_id to distinguish shared actions
* removed RFC tags

Changed in v2:
* use array instead of new callback for getting stats
* remove CVLAN patch (posted separately for net)
* add header inclusion fix

Edward Cree (3):
  flow_offload: add a cookie to flow_action_entry
  flow_offload: restore ability to collect separate stats per action
  flow_offload: include linux/kernel.h from flow_offload.h

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c     |  6 ++++--
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c | 10 ++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c  |  4 +++-
 .../ethernet/mellanox/mlxsw/spectrum_flower.c    |  5 +++--
 .../net/ethernet/netronome/nfp/flower/offload.c  |  8 ++++++--
 .../net/ethernet/netronome/nfp/flower/qos_conf.c |  6 ++++--
 include/net/flow_offload.h                       | 13 +++++++++++--
 include/net/pkt_cls.h                            | 13 +++++++++----
 net/core/flow_offload.c                          | 16 ++++++++++++++++
 net/sched/cls_api.c                              |  1 +
 net/sched/cls_flower.c                           |  9 ++++++---
 net/sched/cls_matchall.c                         |  7 +++++--
 12 files changed, 74 insertions(+), 24 deletions(-)

