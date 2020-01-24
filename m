Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A121485E3
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 14:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387982AbgAXNYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 08:24:06 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45989 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387562AbgAXNYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 08:24:05 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6BB8A21F85;
        Fri, 24 Jan 2020 08:24:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 24 Jan 2020 08:24:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=1Jt6nNgZRJ5JAy739qTF39xabqs1QiupAGSG0X0Dmds=; b=FoFjESy4
        0+e0yRVlfwptmhK1e6briDcEB6jD8Qp/2miP/H/nIWk4dFVGKVUODquTk0MKnmQB
        lib9N2WUtl712gbxZn18K9WKmBXuw5mg0717KKgsSh+OCyt2s4pz2DqcGpIQvZtG
        ZJF0cenzMBuf2e0vlcRshXKf1xxZ+jFn7XPqRds8W7/UOe7XJtvDSqWrHbfluNw9
        p/KjbAQM+iv5LnWcnN9Wp1QxMMQHjNH12EmXQEuHzQjySZ2ffoIhpU152ANTB5aK
        Hnn9/KtwKnztV+8cdjOlrzUrvGxdVvuygqUEgsGY4IRS1PcAoNlHNz8RYvMDuBLk
        8eGVQARgymcoIg==
X-ME-Sender: <xms:9O8qXrhZt3pgCuDHYn1tqked7qxFFAIqnvvMmPKbsGz_hbi8cs9ERQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvdeggdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukeefrddutdejrdduvddtnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:9O8qXvdcoJzpIH3RjL68R5Z5hosCsnkp7rIxqXG_ZhhzCYU6i1YIMg>
    <xmx:9O8qXgk_SmQZRg7Igm-BwuubDwqqB1VXrj3l-IhUI0r3pdCs9AAcDg>
    <xmx:9O8qXr-eOPJGgU-faPj9qZq8DJ4fEX3G4_RHOEDbyO0bEkgMwzYL8g>
    <xmx:9O8qXjoiiUhVVqgEwKi5AZUH95o0rouyqaUbd810rltJ2djiuADeSQ>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4F58030610F6;
        Fri, 24 Jan 2020 08:24:02 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/14] net: sched: sch_tbf: Don't overwrite backlog before dumping
Date:   Fri, 24 Jan 2020 15:23:05 +0200
Message-Id: <20200124132318.712354-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200124132318.712354-1-idosch@idosch.org>
References: <20200124132318.712354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

In 2011, in commit b0460e4484f9 ("sch_tbf: report backlog information"),
TBF started copying backlog depth from the child Qdisc before dumping, with
the motivation that the backlog was otherwise not visible in "tc -s qdisc
show".

Later, in 2016, in commit 8d5958f424b6 ("sch_tbf: update backlog as well"),
TBF got a full-blown backlog tracking. However it kept copying the child's
backlog over before dumping.

That line is now unnecessary, so remove it.

As shown in the following example, backlog is still reported correctly:

    # tc -s qdisc show dev veth0 invisible
    qdisc tbf 1: root refcnt 2 rate 1Mbit burst 128Kb lat 82.8s
     Sent 505475370 bytes 406985 pkt (dropped 0, overlimits 812544 requeues 0)
     backlog 81972b 66p requeues 0
    qdisc bfifo 0: parent 1:1 limit 10Mb
     Sent 505475370 bytes 406985 pkt (dropped 0, overlimits 0 requeues 0)
     backlog 81972b 66p requeues 0

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/sched/sch_tbf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 2cd94973795c..7ae317958090 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -441,7 +441,6 @@ static int tbf_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct nlattr *nest;
 	struct tc_tbf_qopt opt;
 
-	sch->qstats.backlog = q->qdisc->qstats.backlog;
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
-- 
2.24.1

