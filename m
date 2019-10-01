Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D05EFC3B81
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390031AbfJAQok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:44:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390022AbfJAQok (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:44:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59A44222C2;
        Tue,  1 Oct 2019 16:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948279;
        bh=/BkX1duVV7CS5C0o/QWskCQ6Z70Aa83HUMWYRNnqQ1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JzWw6H/7c2aynCpNXTJMShA7d2uLLxjM2heEuKgjOxrdJCp4bknHXP2E1PDRg7jGV
         wjXWqPhrUv+Jt2r98H4bN+QwpRmXgEDaAsSQutBjmDp0+lF1i0C7R7Wk56tt5H3xmW
         DA+Au0KM/+WqZz/9OAC77KgD8n6qu4muHMc0im+w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Yotam Gigi <yotam.gi@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 12/29] net/sched: act_sample: don't push mac header on ip6gre ingress
Date:   Tue,  1 Oct 2019 12:44:06 -0400
Message-Id: <20191001164423.16406-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164423.16406-1-sashal@kernel.org>
References: <20191001164423.16406-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 92974a1d006ad8b30d53047c70974c9e065eb7df ]

current 'sample' action doesn't push the mac header of ingress packets if
they are received by a layer 3 tunnel (like gre or sit); but it forgot to
check for gre over ipv6, so the following script:

 # tc q a dev $d clsact
 # tc f a dev $d ingress protocol ip flower ip_proto icmp action sample \
 > group 100 rate 1
 # psample -v -g 100

dumps everything, including outer header and mac, when $d is a gre tunnel
over ipv6. Fix this adding a missing label for ARPHRD_IP6GRE devices.

Fixes: 5c5670fae430 ("net/sched: Introduce sample tc action")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Yotam Gigi <yotam.gi@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_sample.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 489db1064d5bc..9d92eac019580 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -132,6 +132,7 @@ static bool tcf_sample_dev_ok_push(struct net_device *dev)
 	case ARPHRD_TUNNEL6:
 	case ARPHRD_SIT:
 	case ARPHRD_IPGRE:
+	case ARPHRD_IP6GRE:
 	case ARPHRD_VOID:
 	case ARPHRD_NONE:
 		return false;
-- 
2.20.1

