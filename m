Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA8BC3D1D
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733017AbfJAQ5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:57:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731494AbfJAQl5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:41:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B332B21920;
        Tue,  1 Oct 2019 16:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948116;
        bh=5RYbrWbEgh2pUYCTiY8DsiU2kwg66mfF2oaID6U5yrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZySHHmwfVQQ+mFJAOULSZXLg25dVeJPafhSfcxcetNqFNXm1PbxzicsjKSG1LYam
         nptE4n2rzkQASnu7fUnAYB78tgxqWNEQlr7EN4grmfYuK/S54CW4TTNxXK+0PYsJLu
         iCHTalV1WNCzy/hpew+1NqGSsTU6Kd8W8Idh8xws=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Yotam Gigi <yotam.gi@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 22/63] net/sched: act_sample: don't push mac header on ip6gre ingress
Date:   Tue,  1 Oct 2019 12:40:44 -0400
Message-Id: <20191001164125.15398-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164125.15398-1-sashal@kernel.org>
References: <20191001164125.15398-1-sashal@kernel.org>
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
index 10229124a9924..86344fd2ff1fa 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -146,6 +146,7 @@ static bool tcf_sample_dev_ok_push(struct net_device *dev)
 	case ARPHRD_TUNNEL6:
 	case ARPHRD_SIT:
 	case ARPHRD_IPGRE:
+	case ARPHRD_IP6GRE:
 	case ARPHRD_VOID:
 	case ARPHRD_NONE:
 		return false;
-- 
2.20.1

