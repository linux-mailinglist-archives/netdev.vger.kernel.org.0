Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 668983016F
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfE3SEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:04:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12629 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbfE3SEE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 14:04:04 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7F1512E95BE;
        Thu, 30 May 2019 18:03:54 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99CEF19736;
        Thu, 30 May 2019 18:03:52 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     shuali@redhat.com, Eli Britstein <elibr@mellanox.com>
Subject: [PATCH net v2 0/3] net/sched: fix QinQ when actions read IPv4/IPv6 header
Date:   Thu, 30 May 2019 20:03:40 +0200
Message-Id: <cover.1559237173.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 30 May 2019 18:04:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'act_csum' was recently fixed to mangle the IPv4/IPv6 header if a packet
having one or more VLAN headers was processed: patch #1 ensures that all
VLAN headers are in the linear area of the skb.
Other actions might read or mangle the IPv4/IPv6 header: patch #2 and #3
fix 'act_pedit' and 'act_skbedit' respectively.

Changes since v1:
 - add patch #1, thanks to Eric Dumazet
 - add patch #3

Davide Caratti (3):
  net/sched: act_csum: pull all VLAN headers before checksumming
  net/sched: act_pedit: fix 'ex munge' on network header in case of QinQ
    packet
  net/sched: act_skbedit: fix 'inheritdsfield' in case of QinQ packet

 include/net/pkt_cls.h   | 21 +++++++++++++++++++++
 net/sched/act_csum.c    | 14 ++------------
 net/sched/act_pedit.c   | 26 ++++++++++++++++++++++----
 net/sched/act_skbedit.c | 26 +++++++++++++++++++++-----
 4 files changed, 66 insertions(+), 21 deletions(-)

-- 
2.20.1

