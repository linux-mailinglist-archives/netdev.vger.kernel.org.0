Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE4F313CA
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfEaR0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:26:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43104 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726634AbfEaR0g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 13:26:36 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B54026EB8A;
        Fri, 31 May 2019 17:26:32 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A3E410027B8;
        Fri, 31 May 2019 17:26:30 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     shuali@redhat.com, Eli Britstein <elibr@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net v3 0/3] net/sched: fix actions reading the network header in case of QinQ packets
Date:   Fri, 31 May 2019 19:26:06 +0200
Message-Id: <cover.1559322531.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 31 May 2019 17:26:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'act_csum' was recently fixed to mangle the IPv4/IPv6 header if a packet
having one or more VLAN headers was processed: patch #1 ensures that all
VLAN headers are in the linear area of the skb.
Other actions might read or mangle the IPv4/IPv6 header: patch #2 and #3
fix 'act_pedit' and 'act_skbedit' respectively.

Changes since v2:
 - don't inline tc_skb_pull_vlans(), thanks to Stephen Hemminger
 - remove unwanted whitespace in patch #3

Changes since v1:
 - add patch #1, thanks to Eric Dumazet
 - add patch #3

Davide Caratti (3):
  net/sched: act_csum: pull all VLAN headers before checksumming
  net/sched: act_pedit: fix 'ex munge' on network header in case of QinQ
    packet
  net/sched: act_skbedit: fix 'inheritdsfield' in case of QinQ packet

 include/net/pkt_cls.h   |  2 ++
 net/sched/act_csum.c    | 14 ++------------
 net/sched/act_pedit.c   | 26 ++++++++++++++++++++++----
 net/sched/act_skbedit.c | 24 ++++++++++++++++++++----
 net/sched/cls_api.c     | 22 ++++++++++++++++++++++
 5 files changed, 68 insertions(+), 20 deletions(-)

-- 
2.20.1

